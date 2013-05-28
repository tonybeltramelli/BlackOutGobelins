//
//  TBMapScreen.m
//  BlackOutGobelins
//
//  Created by tony's computer on 30/04/13.
//
//

#import "TBMapScreen.h"

#import "TBGameController.h"
#import "TBEnvironment.h"
#import "TBHeroFirstState.h"
#import "TBCharacterTransitionBot.h"
#import "TBCharacterFirstState.h"
#import "TBResources.h"
#import "TypeDef.c"
#import "TBLine.h"
#import "TBParticle.h"
#import "TBPlantOne.h"
#import "TBProgressBar.h"
#import "TBDialoguePopin.h"
#import "TBModel.h"

const float DELAY = 20.0f;

static ccColor4F hexColorToRGBA(int hexValue, float alpha)
{
    float pRed = (hexValue & 0xFF0000) >> 16;
    float pGreen = (hexValue & 0xFF00) >> 8;
    float pBlue = (hexValue & 0xFF);
    
	return (ccColor4F) {pRed/255, pGreen/255, pBlue/255, alpha};
}

@implementation TBMapScreen
{
    CCLayer *_mainContainer;
    TBGameController *_gameController;
    TBEnvironment *_environment;
    TBHeroFirstState *_hero;
    NSMutableArray *_bots;
    TBCharacter *_targetedCharacter;
    NSMutableArray *_characters;
    NSMutableArray *_obstacles;
    TBProgressBar *_progressBar;
    TBDialoguePopin *_dialoguePopIn;
    
    CGSize _size;
    BOOL _isMoving;
    CGPoint _swipeStartPosition;
    CGPoint _swipeEndPosition;
    float _delay;
    BOOL _toFreeze;
}

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
	
	TBMapScreen *layer = [TBMapScreen node];
	[scene addChild: layer];
	
    return scene;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[TBResources getAsset:ASSETS_SPRITE_SHEET_COMMON_PLIST]];
        
        _mainContainer = [[CCLayer alloc] init];
        [self addChild:_mainContainer z:0 tag:mainContainer];
        
        _size = [[CCDirector sharedDirector] winSize];
        
        _environment = [[TBEnvironment alloc] init];
        [self addChild:_environment z:-1 tag:environmentContainer];
        
        CGPoint startPosition = [_environment getStartPositionFromMeta];
        [self addOrMoveHeroAtPosition:startPosition];
        
        _bots = [[NSMutableArray alloc] init];
        _characters = [[NSMutableArray alloc] init];
        _obstacles = [[NSMutableArray alloc] init];
        
        [self addAllBots];
        [self addCharactersAtPositions:[_environment getCharactersPositions:1]];
        [self addObstaclesAtPositions:[_environment getObstaclesPositions]];

        _gameController = [[TBGameController alloc] initInLayer:self withHero:_hero];
        [_gameController useTouch:TRUE];
        
        _progressBar = [[TBProgressBar alloc] init];
        [_progressBar setPosition:CGPointMake(_size.width, _size.height)];
        [self addChild:_progressBar];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) update:(ccTime)delta
{
    if(_delay > 0.0f)
    {
        _delay -= 0.1f;
        return;
    }else{
        _delay = 0.0f;
    }
    
    [self displayPossibleConnections];
    
    _mainContainer.position = CGPointMake(round(-_hero.position.x + _size.width / 2), round(-_hero.position.y + _size.height / 2));
    _environment.position = _mainContainer.position;
    
    CGPoint position = [_gameController getTargetPosition];

    CGPoint volumicBoundaries = [_hero getVolumicBoundariesFromPositionTarget:position];
    CGPoint target = CGPointMake(_hero.position.x + position.x + volumicBoundaries.x, _hero.position.y + position.y + volumicBoundaries.y);
    
    if([_environment isCollisionAt:target] || [_environment isObstacleAt:target])
    {
        [_hero collide];
        return;
    }
    
    [_hero walkTo: position];
}

-(void)displayPossibleConnections
{    
    [self loopForCharacters:_bots typeOfInteraction:isOnRange];
    [self loopForCharacters:_characters typeOfInteraction:isOnRange];
}

-(BOOL)loopForCharacters:(NSMutableArray *)array typeOfInteraction:(interactionType_t)type
{
    int i = 0;
    int length = [array count];
    
    for(i = 0; i < length; i++)
    {
        TBCharacter *character = (TBCharacter *)[array objectAtIndex:i];
        
        switch (type) {
            case isOnRange:
                if([_hero isOnHeroRange:character])
                {
                    [character connectionOnRange:true];
                }else{
                    [character connectionOnRange:false];
                }
                break;
            case isTouched:
                if([self isCharacter:character touchedAt:_swipeStartPosition])
                {
                    _targetedCharacter = character;
                    return TRUE;
                }
                break;
            default:
                break;
        }
    }
    
    return FALSE;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_toFreeze) return;
    
    CGPoint location = [self getContainerPositionFromTouch:touches];
    
    _swipeStartPosition = location;
    _swipeEndPosition = CGPointZero;
    
    BOOL charactersResult = [self loopForCharacters:_bots typeOfInteraction: isTouched];
    BOOL botsResult = [self loopForCharacters:_characters typeOfInteraction: isTouched];
    
    if(!charactersResult && !botsResult) _swipeStartPosition = CGPointZero;
    
    _isMoving = false;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_toFreeze) return;
    
    CGPoint location = [self getContainerPositionFromTouch:touches];

    if(![_gameController doNeedToIgnoreTouchAction])
    {
        TBParticle *particle = [[[TBParticle alloc] initAt:location with:hexColorToRGBA(0xffffff, 0.9f)] autorelease];
        [_mainContainer addChild:particle];
    }
    
    _isMoving = true;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_toFreeze)
    {
        if(_dialoguePopIn != nil) [_dialoguePopIn nextStep];
            
        return;
    }
    
    CGPoint location = [self getContainerPositionFromTouch:touches];
    
    if(!_isMoving)
    {
        [_gameController ccTouchesEnded:touches withEvent:event];
    }else{
        if([self isCharacter:_hero touchedAt:location])
        {
            _swipeEndPosition = location;
        }
    
        if(_swipeStartPosition.x != CGPointZero.x && _swipeStartPosition.y != CGPointZero.y &&
           _swipeEndPosition.x != CGPointZero.x && _swipeEndPosition.y != CGPointZero.y &&
           _delay == 0.0f)
        {
            TBLine *line;
            
            if([_targetedCharacter isKindOfClass:[TBCharacterTransitionBot class]])
            {
                NSString *interactionType = [[TBModel getInstance].getCurrentLevelData getUserNameDataType];
                NSString *interactionData = [[TBModel getInstance].getCurrentLevelData getUserName];
                
                line = [TBLine lineFrom:_targetedCharacter.position andTo:_hero.position withInteractionType:interactionType andData:interactionData andColor:[(TBCharacterTransitionBot *)_targetedCharacter getColor]];
            }else{
                line = [TBLine lineFrom:_targetedCharacter.position andTo:_hero.position];
            }
            
            [_mainContainer addChild:line z:[_mainContainer.children indexOfObject:_hero] - 1];
            
            if([_targetedCharacter isKindOfClass:[TBCharacterFirstState class]])
            {
                _dialoguePopIn = [[TBDialoguePopin alloc] initWithContent:[((TBCharacterFirstState *) _targetedCharacter) getDialogue]];
                [self addChild:_dialoguePopIn];
                
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(characterDisconnected:) name:@"CHARACTER_DISCONNECTED" object:nil];
                
                [_dialoguePopIn show];
            }else if([_targetedCharacter isKindOfClass:[TBCharacterTransitionBot class]])
            {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(botDisconnected:) name:@"BOT_DISCONNECTED" object:nil];
            }
            
            [_hero startConnection];
            
            [_targetedCharacter handleConnection:true];
            _targetedCharacter = nil;
            
            _delay = DELAY;
            _toFreeze = true;
        }
    }
    
    [self testTouchOnObstacleAtLocation:location];
    
    _isMoving = false;
}

-(void) botDisconnected:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
        
    TBCharacterTransitionBot *bot = (TBCharacterTransitionBot *)[notification object];
    [_bots removeObject:bot];
    
    float incrementValue = 1 / [_bots count];
    
    [_progressBar setProgress:[_progressBar progress] + incrementValue];
    
    _toFreeze = false;
}

-(void) characterDisconnected:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeChild:_dialoguePopIn cleanup:TRUE];
    
    [_dialoguePopIn release];
    _dialoguePopIn = nil;
    
    _toFreeze = false;
}

-(void)testTouchOnObstacleAtLocation:(CGPoint)location
{
    int i = 0;
    int length = [_obstacles count];
    
    for(i = 0; i < length; i++)
    {
        TBMapElement *obstacle = (TBMapElement *)[_obstacles objectAtIndex:i];
        CGPoint obstaclePosition = [obstacle getPosition];
        CGSize obstacleSize = [obstacle getSize];
        
        if((location.x > obstaclePosition.x - obstacleSize.width/2) && (location.x < obstaclePosition.x + obstacleSize.width/2) &&
           (location.y > obstaclePosition.y - obstacleSize.height/2) && (location.y < obstaclePosition.y + obstacleSize.height/2))
        {
            [_mainContainer removeChild:obstacle cleanup:TRUE];
            [_obstacles removeObjectAtIndex:i];
            [_environment removeMetaTileAt:location];
            return;
        }
    }
}

-(CGPoint)getContainerPositionFromTouch:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: [touch view]];
    point = [[CCDirector sharedDirector] convertToGL: point];
    
    CGPoint location = CGPointMake(point.x - _mainContainer.position.x, point.y - _mainContainer.position.y);
    return location;
}

-(BOOL)isCharacter:(TBCharacter *)character touchedAt:(CGPoint)location
{
    if((location.x > character.position.x - character.getSize.width/2) && (location.x < character.position.x + character.getSize.width/2) &&
       (location.y > character.position.y - character.getSize.height/2) && (location.y < character.position.y + character.getSize.height/2))
    {
        return TRUE;
    }else{
        return FALSE;
    }
}

-(void) addOrMoveHeroAtPosition:(CGPoint)position
{
    if(_hero)
    {
        [_hero setPosition:position];
    }else{
        _hero = [[TBHeroFirstState alloc] init];
        [_hero drawAt:position];
        
        [_mainContainer addChild:_hero];
    }
}

-(void) addAllBots
{
    [self addElements:@"TBBotFirstState" atPositions:[_environment getBotsStartPositions:1] andSaveThemIn:_bots];
    [self addElements:@"TBBotSecondState" atPositions:[_environment getBotsStartPositions:2] andSaveThemIn:_bots];
    [self addElements:@"TBBotThirdState" atPositions:[_environment getBotsStartPositions:3] andSaveThemIn:_bots];
}

-(void) addCharactersAtPositions:(NSMutableArray *)positions
{    
    [self addElements:@"TBCharacterFirstState" atPositions:positions andSaveThemIn:_characters];
}

-(void) addObstaclesAtPositions:(NSMutableArray *)positions
{    
    [self addElements:@"TBPlantOne" atPositions:positions andSaveThemIn:_obstacles];
}

-(void) addElements:(NSString *)className atPositions:(NSMutableArray *)positions andSaveThemIn:(NSMutableArray *)array
{
    int i = 0;
    int length = [positions count];
    
    for(i = 0; i < length; i++)
    {
        id element = [[NSClassFromString(className) alloc] init];
        [element drawAt:[[positions objectAtIndex:i] CGPointValue]];
        
        [array addObject:element];
        [_mainContainer addChild:(CCLayer *)element];
    }
}

- (void)dealloc
{
    [self removeChild:_mainContainer cleanup:TRUE];
    [self removeChild:_environment cleanup:TRUE];
    
    _mainContainer = nil;
    
    [_hero release];
    _hero = nil;
    
    [_environment release];
    _environment = nil;
    
    [_gameController release];
    _gameController = nil;
    
    [_dialoguePopIn release];
    _dialoguePopIn = nil;
    
    [super dealloc];
}

@end
