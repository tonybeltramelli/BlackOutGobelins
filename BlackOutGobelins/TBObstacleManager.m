
//
//  TBObstacleManager.m
//  BlackOutGobelins
//
//  Created by tony's computer on 01/06/13.
//
//

#import "TBObstacleManager.h"

@implementation TBObstacleManager
{
    CCLayer *_mainContainer;
    TBEnvironment *_environmentContainer;
    
    NSMutableArray *_obstacles;
}

- (id)initWithMainContainerRef:(CCLayer *)mainContainer andEnvironmentContainerRef:(TBEnvironment *)environmentContainer
{
    self = [super init];
    if (self) {
        _mainContainer = mainContainer;
        _environmentContainer = environmentContainer;
        
        _obstacles = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)removeObstacleReafFrom:(TBObstacle *)targetObstacle
{
    int i = 0;
    int length = [_obstacles count];
    
    int destroyedIndex = 0;
    
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
            
            destroyedIndex ++;
            [obstacle explodeAt:destroyedIndex];
        }
    }
}

-(void) obstacleDestroyed:(NSNotification *)notification
{
    TBObstacle *obstacle = (TBObstacle *)[notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"OBSTACLE_DESTROYED_%@", [obstacle getUId]] object:nil];
    
    [_mainContainer removeChild:obstacle cleanup:TRUE];
    [_environmentContainer removeMetaTileAt:[obstacle getPosition]];
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
    
    [super dealloc];
}

@end
