//
//  TBFirstLevelData.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 27/05/13.
//
//

#import <Foundation/Foundation.h>

@interface TBFirstLevelData : NSObject

- (id)initWithBotNumber:(int)botNumber;

-(BOOL)isObstacleDestroyable;
-(void)incrementScore;
-(float)getScore;
-(NSString *)getUserName;
-(NSString *)getUserNameDataType;
-(NSMutableArray *)getCharactersData;

@end
