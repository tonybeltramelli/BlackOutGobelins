//
//  TBMapScreen.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 30/04/13.
//
//

#import "TBMapScreen.h"

#import "TBGameController.h"
#import "TBEnvironment.h"
#import "TBTopMap.h"
#import "TBHeroFirstState.h"
#import "TBCharacterTransitionBot.h"
#import "TBCharacterFirstState.h"
#import "TBResources.h"
#import "TypeDef.c"
#import "TBLine.h"
#import "TBParticle.h"
#import "TBObstacleManager.h"
#import "TBDoor.h"
#import "TBProgressBar.h"
#import "TBDialoguePopin.h"
#import "TBModel.h"
#import "SimpleAudioEngine.h"

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
    CCLayer *_effectContainer;
    TBGameController *_gameController;
    TBEnvironment *_environmentContainer;
    TBTopMap *_topContainer;
    TBHeroFirstState *_hero;
    NSMutableArray *_bots;
    TBCharacter *_targetedCharacter;
    NSMutableArray *_characters;
    TBProgressBar *_progressBar;
    TBDialoguePopin *_dialoguePopIn;
    TBDoor *_door;
    NSMutableArray *_plants;
    TBObstacleManager *_obstacleManager;
    
    CGSize _size;
    BOOL _isMoving;
    CGPoint _swipeStartPosition;
    CGPoint _swipeEndPosition;
    float _delay;
    BOOL _toFreeze;
    float _score;
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
        _mainContainer = [[CCLayer alloc] init];
        [self addChild:_mainContainer z:0 tag:mainContainer];
        
        _size = [[CCDirector sharedDirector] winSize];
        
        _environmentContainer = [[TBEnvironment alloc] init];
        [self addChild:_environmentContainer z:-1 tag:environmentContainer];
        
        _topContainer = [[TBTopMap alloc] init];
        [self addChild:_topContainer z:1 tag:topContainer];
        
        CCSprite *mask = [CCSprite spriteWithFile:[TBResources getAsset:_size.width != 568 ? "mask.png" : "mask-568h.png"]];
        [mask setAnchorPoint:CGPointZero];
        [self addChild:mask z:1];
        
        _bots = [[NSMutableArray alloc] init];
        _characters = [[NSMutableArray alloc] init];
        _plants = [[NSMutableArray alloc] init];
        
        _obstacleManager = [[TBObstacleManager alloc] initWithMainContainerRef:_mainContainer andEnvironmentContainerRef:_environmentContainer];
        
        _progressBar = [[TBProgressBar alloc] init];
        [_progressBar setPosition:CGPointMake(_size.width, _size.height)];
        [self addChild:_progressBar z:1];
    }
    return self;
}

-(void) onEnter
{
	[super onEnter];
    
    CGPoint startPosition = [_environmentContainer getStartPositionFromMeta];
    [self addOrMoveHeroAtPosition:startPosition];
    
    [self addAllBots];
    [self addCharactersAtPositions:[_environmentContainer getCharactersPositions:1]];
    [self addAllPlants];
    [self addObstaclesAtPositions:[_environmentContainer getObstaclesPositions]];
    
    _door = [[TBDoor alloc] init];
    [_door drawAt:[_environmentContainer getDoorPosition]];
    [_mainContainer addChild:_door z:-1];
    
    _gameController = [[TBGameController alloc] initInLayer:self withHero:_hero];
    [_gameController useTouch:TRUE];
    
    NSLog(@"%@", [CCSpriteFrameCache sharedSpriteFrameCache]);
    [[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
    
    //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"first_level_loop.mp3" loop:YES];
    
    [self scheduleUpdate];
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
    [self handleBotMovements];
    [self reorderIndexes];
    
    _mainContainer.position = CGPointMake(round(-_hero.position.x + _size.width / 2), round(-_hero.position.y + _size.height / 2));
    _environmentContainer.position = _effectContainer.position = _topContainer.position = _mainContainer.position;
    
    CGPoint position = [_gameController getTargetPosition];

    CGPoint volumicBoundaries = [_hero getVolumicBoundariesFromPositionTarget:position];
    CGPoint target = CGPointMake(_hero.position.x + position.x + volumicBoundaries.x, _hero.position.y + position.y + volumicBoundaries.y);
    
    if([_environmentContainer isCollisionAt:target] || [_environmentContainer isObstacleAt:target])
    {
        [_hero collide];
        return;
    }
    
    [_hero walkTo: position];
}

-(void)displayPossibleConnections
{    
    [self loopForElements:_bots typeOfInteraction:isOnRange];
    [self loopForElements:_characters typeOfInteraction:isOnRange];
    [self loopForElements:_plants typeOfInteraction:isOnRange];
}

-(BOOL)loopForElements:(NSMutableArray *)array typeOfInteraction:(interactionType_t)type
{
    int i = 0;
    int length = [array count];
    
    for(i = 0; i < length; i++)
    {
        id<TBConnectableElement> element = (id<TBConnectableElement>)[array objectAtIndex:i];
        
        switch (type) {
            case isOnRange:
                if([_hero isOnHeroRange:element])
                {
                    [element connectionOnRange:true];
                }else{
                    [element connectionOnRange:false];
                }
                break;
            case isTouched:
                if([self isElement:element touchedAt:_swipeStartPosition])
                {
                    if([element isKindOfClass:[TBCharacterTransitionBot class]])
                    {
                        if([((TBCharacterTransitionBot *)element) isConnectable])
                        {
                            _targetedCharacter = (TBCharacter *)element;
                            return TRUE;
                        }
                    }else{
                        _targetedCharacter = (TBCharacter *)element;
                        return TRUE;
                    }
                }
                break;
            default:
                break;
        }
    }
    
    return FALSE;
}

- (void)handleBotMovements
{
    int i = 0;
    int length = [_bots count];
    
    for(i = 0; i < length; i++)
    {
        TBCharacterTransitionBot *bot = (TBCharacterTransitionBot *)[_bots objectAtIndex:i];
        
        CGPoint target = [bot getTargetPosition];
            
        if([_environmentContainer isCollisionAt:target] || [_environmentContainer isObstacleAt:target])
        {
            [bot changeDirection];
            
            return;
        }
        
        [bot update];
    }
}

-(void)reorderIndexes
{
    CCNode* item;
    
    int i = 0;
    int length = [_mainContainer children].count;
    
    int j = 1;
    
    for(j = 1; j < length; j++)
    {
        item = [[_mainContainer children] objectAtIndex:j];
        
        for(i = j - 1; i >= 0 && ((CCNode*)[[_mainContainer children] objectAtIndex:i]).position.y < item.position.y; i--)
        {
            [[_mainContainer children] replaceObjectAtIndex:i + 1 withObject:[[_mainContainer children] objectAtIndex:i]];
        }
        
        [[_mainContainer children] replaceObjectAtIndex:i + 1 withObject:item];
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_toFreeze) return;
    
    CGPoint location = [self getContainerPositionFromTouch:touches];
    
    _swipeStartPosition = location;
    _swipeEndPosition = CGPointZero;
    
    BOOL charactersResult = [self loopForElements:_bots typeOfInteraction: isTouched];
    BOOL botsResult = [self loopForElements:_characters typeOfInteraction: isTouched];
    BOOL obstaclesResult = [self loopForElements:_obstacleManager.getObstacles typeOfInteraction: isTouched];
    
    if(!charactersResult && !botsResult && !obstaclesResult) _swipeStartPosition = CGPointZero;
    
    _isMoving = false;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_toFreeze) return;
    
    CGPoint location = [self getContainerPositionFromTouch:touches];

    if(![_gameController doNeedToIgnoreTouchAction])
    {
        TBParticle *particle = [[[TBParticle alloc] initAt:location with:hexColorToRGBA(0xffffff, 0.9f)] autorelease];
        [_topContainer addChild:particle];
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
        if([self isElement:_hero touchedAt:location])
        {
            _swipeEndPosition = location;
        }
    
        if(_swipeStartPosition.x != CGPointZero.x && _swipeStartPosition.y != CGPointZero.y &&
           _swipeEndPosition.x != CGPointZero.x && _swipeEndPosition.y != CGPointZero.y &&
           _delay == 0.0f)
        {            
            if([_targetedCharacter isKindOfClass:[TBObstacle class]])
            {
                if([[[TBModel getInstance] getCurrentLevelData] isObstacleDestroyable])
                {
                    [_obstacleManager removeObstacleReafFrom:(TBObstacle *)_targetedCharacter];
                
                    _targetedCharacter = nil;
                
                    _isMoving = false;
                }
                
                return;
            }
            
            TBLine *line;
            
            if([_targetedCharacter isKindOfClass:[TBCharacterTransitionBot class]])
            {
                NSString *interactionValue = [(TBCharacterTransitionBot *)_targetedCharacter getDataValue];
                NSString *interactionType = [(TBCharacterTransitionBot *)_targetedCharacter getDataType];
                
                CGPoint botConnectionPos = CGPointMake(_targetedCharacter.position.x + [_targetedCharacter getGravityCenter].x, _targetedCharacter.position.y + [_targetedCharacter getGravityCenter].y);
                
                line = [TBLine lineFrom:botConnectionPos andTo:_hero.position withInteractionType:interactionType andData:interactionValue andColor:[(TBCharacterTransitionBot *)_targetedCharacter getColor]];
            }else {
                line = [TBLine lineFrom:_targetedCharacter.position andTo:_hero.position];
            }
            
            [_mainContainer addChild:line z:-1];
            
            if([_targetedCharacter isKindOfClass:[TBCharacterFirstState class]])
            {
                _dialoguePopIn = [[TBDialoguePopin alloc] initWithContent:[((TBCharacterFirstState *) _targetedCharacter) getDialogue]];
                [self addChild:_dialoguePopIn z:1];
                
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
    
    _isMoving = false;
}

-(void) botDisconnected:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
        
    TBCharacterTransitionBot *bot = (TBCharacterTransitionBot *)[notification object];
    [_bots removeObject:bot];
    
    [[[TBModel getInstance] getCurrentLevelData] incrementScore];
    
    [_progressBar setProgress:[[[TBModel getInstance] getCurrentLevelData] getScore]];
    
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

-(CGPoint)getContainerPositionFromTouch:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: [touch view]];
    point = [[CCDirector sharedDirector] convertToGL: point];
    
    CGPoint location = CGPointMake(point.x - _mainContainer.position.x, point.y - _mainContainer.position.y);
    return location;
}

-(BOOL)isElement:(id<TBConnectableElement>)element touchedAt:(CGPoint)location
{
    if((location.x > [element getPosition].x - element.getSize.width/2) && (location.x < [element getPosition].x + element.getSize.width/2) &&
       (location.y > [element getPosition].y - element.getSize.height/2) && (location.y < [element getPosition].y + element.getSize.height/2))
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
        
        [_mainContainer addChild:_hero z:1 tag:hero];
    }
}

-(void) addAllBots
{
    [self addElements:@"TBBotFirstState" atPositions:[_environmentContainer getBotsStartPositions:1] andSaveThemIn:_bots];
    [self addElements:@"TBBotSecondState" atPositions:[_environmentContainer getBotsStartPositions:2] andSaveThemIn:_bots];
    [self addElements:@"TBBotThirdState" atPositions:[_environmentContainer getBotsStartPositions:3] andSaveThemIn:_bots];
}

-(void) addCharactersAtPositions:(NSMutableArray *)positions
{    
    [self addElements:@"TBCharacterFirstState" atPositions:positions andSaveThemIn:_characters];
}

-(void) addObstaclesAtPositions:(NSMutableArray *)positions
{    
    [self addElements:@"TBObstacle" atPositions:positions andSaveThemIn:_obstacleManager.getObstacles];
}

-(void) addAllPlants
{
    [self addElements:@"TBFirstPlant" atPositions:[_environmentContainer getPlantsPositions:1] andSaveThemIn:_plants];
    [self addElements:@"TBSecondPlant" atPositions:[_environmentContainer getPlantsPositions:2] andSaveThemIn:_plants];
    [self addElements:@"TBThirdPlant" atPositions:[_environmentContainer getPlantsPositions:3] andSaveThemIn:_plants];
    [self addElements:@"TBFourthPlant" atPositions:[_environmentContainer getPlantsPositions:4] andSaveThemIn:_plants];
    [self addElements:@"TBFifthPlant" atPositions:[_environmentContainer getPlantsPositions:5] andSaveThemIn:_plants];
    [self addElements:@"TBSixthPlant" atPositions:[_environmentContainer getPlantsPositions:6] andSaveThemIn:_plants];
    [self addElements:@"TBSeventhPlant" atPositions:[_environmentContainer getPlantsPositions:7] andSaveThemIn:_plants];
}

-(void) addElements:(NSString *)className atPositions:(NSMutableArray *)positions andSaveThemIn:(NSMutableArray *)array
{
    int i = 0;
    int length = [positions count];
    
    for(i = 0; i < length; i++)
    {
        id element = [[NSClassFromString(className) alloc] init];
        [element drawAt:[[positions objectAtIndex:i] CGPointValue]];
        
        if([element isKindOfClass:[TBCharacter class]]) [((TBCharacter *)element) getDataAt:i];
        
        [array addObject:element];
        [_mainContainer addChild:(CCLayer *)element];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeChild:_mainContainer cleanup:TRUE];
    [self removeChild:_environmentContainer cleanup:TRUE];
    
    _mainContainer = nil;
    
    [_hero release];
    _hero = nil;
    
    [_obstacleManager release];
    _obstacleManager = nil;
    
    [_environmentContainer release];
    _environmentContainer = nil;
    
    [_gameController release];
    _gameController = nil;
    
    [_dialoguePopIn release];
    _dialoguePopIn = nil;
    
    [super dealloc];
}

@end
