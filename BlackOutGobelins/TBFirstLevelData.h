//
//  TBFirstLevelData.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 27/05/13.
//
//

#import <Foundation/Foundation.h>

@interface TBFirstLevelData : NSObject

-(BOOL)isObstacleDestroyable;
-(void)incrementScore;
-(float)getScore;
-(NSMutableArray *)getCharactersData;
-(NSMutableArray *)getBotsData;

@end
