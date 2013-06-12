//
//  TBEnvironment.h
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 22/01/13.
//
//

#import "CCSprite.h"
#import "TBMap.h"

@interface TBEnvironment : CCSprite

- (CGPoint)getStartPositionFromMeta;
- (NSMutableArray *)getBotsStartPositions:(int)botNumber;
- (NSMutableArray *)getCharactersPositions:(int)characterNumber;
- (NSMutableArray *)getObstaclesPositions;
- (NSMutableArray *)getPlantsPositions:(int)plantNumber;
- (CGPoint)getDoorPosition;
- (BOOL)isCollisionAt:(CGPoint)position;
- (BOOL)isObstacleAt:(CGPoint)position;
- (BOOL)isDoorAt:(CGPoint)position;
- (void)removeMetaTileAt:(CGPoint)position;

@end
