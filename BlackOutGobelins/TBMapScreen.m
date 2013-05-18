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
#import "TBBotFirstState.h"
#import "TBCharacterFirstState.h"
#import "TBResources.h"
#import "TypeDef.c"
#import "TBLine.h"
#import "TBParticle.h"
#import "TBPlantOne.h"

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
    TBBotFirstState *_targetedBot;
    NSMutableArray *_characters;
    NSMutableArray *_obstacles;
    
    CGSize _size;
    BOOL _isMoving;
    CGPoint _swipeStartPosition;
    CGPoint _swipeEndPosition;
    float _delay;
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
        
        [self addBotsAtPositions:[_environment getBotsStartPositions:1]];
        [self addCharactersAtPositions:[_environment getCharactersPositions:1]];
        [self addObstaclesAtPositions:[_environment getObstaclesPositions]];

        _gameController = [[TBGameController alloc] initInLayer:self withHero:_hero];
        [_gameController useTouch:TRUE];
        
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
    int i = 0;
    int length = [_bots count];
    
    for(i = 0; i < length; i++)
    {
        TBBotFirstState *bot = (TBBotFirstState *)[_bots objectAtIndex:i];
        
        if([_hero isOnHeroRange:bot])
        {
            [bot connectionOnRange:true];
        }else{
            [bot connectionOnRange:false];
        }
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [self getContainerPositionFromTouch:touches];
    
    _swipeStartPosition = CGPointZero;
    _swipeEndPosition = CGPointZero;
    
    int i = 0;
    int length = [_bots count];

    for(i = 0; i < length; i++)
    {
        TBBotFirstState *bot = (TBBotFirstState *) [_bots objectAtIndex:i];
        
        if([self isCharacter:bot touchedAt:location])
        {
            _targetedBot = bot;
            _swipeStartPosition = location;
        }
    }
    
    _isMoving = false;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
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
            TBLine *line = [[[TBLine alloc] initFrom:_targetedBot.position andTo:_hero.position] autorelease];
            [_mainContainer addChild:line z:[_mainContainer.children indexOfObject:_hero] - 1];
            
            [_hero startConnection];
            [_targetedBot handleConnection:true];
            
            _targetedBot = nil;
            _delay = DELAY;
        }
    }
    
    [self testTouchOnObstacleAtLocation:location];
    
    _isMoving = false;
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

-(void) addBotsAtPositions:(NSMutableArray *)positions
{
    [self addElements:@"TBBotFirstState" atPositions:positions andSaveThemIn:_bots];
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
    
    [super dealloc];
}

@end
