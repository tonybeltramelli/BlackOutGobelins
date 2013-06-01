//
//  TBObstacleManager.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 01/06/13.
//
//

#import <Foundation/Foundation.h>

#import "TBObstacle.h"
#import "TBEnvironment.h"

@interface TBObstacleManager : NSObject

- (id)initWithMainContainerRef:(CCLayer *)mainContainer andEnvironmentContainerRef:(TBEnvironment *)environmentContainer;

-(void)removeObstacleReafFrom:(TBObstacle *)targetObstacle;
-(NSMutableArray *)getObstacles;

@end
