
//
//  TBObstacleManager.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 01/06/13.
//
//

#import "TBObstacleManager.h"
#import "TBSquareCounter.h"
#import "TBModel.h"
#import "SimpleAudioEngine.h"

@implementation TBObstacleManager
{
    CCLayer *_mainContainer;
    TBEnvironment *_environmentContainer;
    
    NSMutableArray *_obstacles;
    NSMutableArray *_obstacleGroups;
    NSMutableArray *_obstacleCounter;
    
    BOOL _isFrozen;
    
    int _explodedObstacles;
    int _totalObstaclesToExplode;
}

- (id)initWithMainContainerRef:(CCLayer *)mainContainer andEnvironmentContainerRef:(TBEnvironment *)environmentContainer
{
    self = [super init];
    if (self) {
        _mainContainer = mainContainer;
        _environmentContainer = environmentContainer;
        
        _obstacles = [[NSMutableArray alloc] init];
        _obstacleGroups = [[NSMutableArray alloc] init];
        _obstacleCounter = [[NSMutableArray alloc] init];
        
        _isFrozen = false;
    }
    return self;
}

-(void)buildGroups
{
    int i = 0;
    int length = [_obstacles count];
    
    int j = 0;
    
    for(i = 0; i < length; i++)
    {
        CGPoint location = [(TBObstacle *)[_obstacles objectAtIndex:i] getPosition];
        NSMutableArray *group = [[NSMutableArray alloc] init];
    
        for(j = 0; j < length; j++)
        {
            TBObstacle *obstacle = (TBObstacle *)[_obstacles objectAtIndex:j];
            CGPoint obstaclePosition = [obstacle getPosition];
            CGSize obstacleSize = [obstacle getSize];
        
            if((location.x > obstaclePosition.x - (obstacleSize.width * 2)) && (location.x < obstaclePosition.x + (obstacleSize.width * 2)) &&
               (location.y > obstaclePosition.y - (obstacleSize.height * 2)) && (location.y < obstaclePosition.y + (obstacleSize.height * 2)))
            {
                location = [obstacle getPosition];
                [group addObject:obstacle];
            }
        }
        
        if(![self isAlreadyInThere:_obstacleGroups with:group])
        {
            float *scoreRelated = [[[TBModel getInstance] getCurrentLevelData] getBotNumberRelated];
            
            TBSquareCounter *squareCounter = [[TBSquareCounter alloc] initWithDataNumber:scoreRelated[[_obstacleGroups count]]];
            TBObstacle *obstacle = (TBObstacle *)[group objectAtIndex:round([group count] / 2)];
            
            [squareCounter setPosition:CGPointMake(obstacle.position.x, obstacle.position.y)];
            [_mainContainer addChild:squareCounter];
            
            [_obstacleGroups addObject:group];
            [_obstacleCounter addObject:squareCounter];
        }
    }
}

-(BOOL)isAlreadyInThere:(NSMutableArray *)arrayFirst with:(NSMutableArray *)arraySecond
{
    int i = 0;
    int length = [arrayFirst count];
    
    int j = 0;
    int n = 0;
    
    int k = 0;
    int a = [arraySecond count];
    
    int similarNumber = 0;
    
    for(i = 0; i < length; i++)
    {
        n = [[arrayFirst objectAtIndex:i] count];
        
        for(j = 0; j < n; j++)
        {
            NSMutableArray *arrayFirstElement = [[arrayFirst objectAtIndex:i] objectAtIndex:j];
            
            for(k = 0; k < a; k++)
            {
                if(arrayFirstElement == [arraySecond objectAtIndex:k]) similarNumber ++;
            }
        }
    }
    
    return similarNumber != 0;
}

-(void)removeObstacleReafFrom:(TBObstacle *)targetObstacle
{
    if(_isFrozen) return;
    
    _isFrozen = true;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"Explosion-Obstacle.mp3"];
    
    [(TBSquareCounter *)[_obstacleCounter objectAtIndex:[[[TBModel getInstance] getCurrentLevelData] getCurrentObstacleNumber] - 1] hide];
    
    int i = 0;
    int length = [_obstacles count];
    
    _totalObstaclesToExplode = 0;
    _explodedObstacles = 0;
    
    CGPoint location = [targetObstacle getPosition];
    
    for(i = 0; i < length; i++)
    {
        TBObstacle *obstacle = (TBObstacle *)[_obstacles objectAtIndex:i];
        CGPoint obstaclePosition = [obstacle getPosition];
        CGSize obstacleSize = [obstacle getSize];
        
        if((location.x > obstaclePosition.x - (obstacleSize.width * 2)) && (location.x < obstaclePosition.x + (obstacleSize.width * 2)) &&
           (location.y > obstaclePosition.y - (obstacleSize.height * 2)) && (location.y < obstaclePosition.y + (obstacleSize.height * 2)))
        {
            location = [obstacle getPosition];
            
            NSString *eventSignature = [NSString stringWithFormat:@"OBSTACLE_DESTROYED_%@", [obstacle getUId]];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:eventSignature object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(obstacleDestroyed:) name:eventSignature object:nil];
            
            _totalObstaclesToExplode ++;
            [obstacle explodeAt:_totalObstaclesToExplode];
        }
    }
}

-(void) obstacleDestroyed:(NSNotification *)notification
{
    TBObstacle *obstacle = (TBObstacle *)[notification object];
    
    _explodedObstacles ++;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"OBSTACLE_DESTROYED_%@", [obstacle getUId]] object:nil];
    
    [_mainContainer removeChild:obstacle cleanup:TRUE];
    [_environmentContainer removeMetaTileAt:[obstacle getPosition]];
    
    if(_explodedObstacles == _totalObstaclesToExplode)
    {
        _isFrozen = false;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

-(void)updateCurrentObstacleCounter
{
    TBSquareCounter *obstacle = (TBSquareCounter *)[_obstacleCounter objectAtIndex:[[[TBModel getInstance] getCurrentLevelData] getCurrentObstacleNumber]];
    [obstacle updateCounter];
    
    if([obstacle isReady])
    {
        NSMutableArray *obstacles = [_obstacleGroups objectAtIndex:[[[TBModel getInstance] getCurrentLevelData] getCurrentObstacleNumber]];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"Connexion-Obstacle.mp3"];
        
        int i = 0;
        int length = [obstacles count];
        
        for(i = 0; i < length; i++)
        {
            [(TBObstacle *)[obstacles objectAtIndex:i] becomeActive];
        }
    }
}

-(NSMutableArray *)getObstacles
{
    return _obstacles;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_obstacles release];
    _obstacles = nil;
    
    [_obstacleGroups release];
    _obstacleGroups = nil;
    
    [_obstacleCounter release];
    _obstacleCounter = nil;
    
    [super dealloc];
}

@end
