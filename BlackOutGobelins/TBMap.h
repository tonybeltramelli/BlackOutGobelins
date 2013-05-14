//
//  TBMap.h
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 08/01/13.
//
//

#import "cocos2d.h"

@interface TBMap : CCSprite

@property(assign, nonatomic) CCTMXTiledMap *map;

- (id)initWith:(NSString *)mapName;
- (id)initWith:(NSString *)mapName andDisplayOnly:(NSString *)layerName;
- (id)initWith:(NSString *)mapName andDisplay:(NSMutableArray *)array;
- (CCTMXLayer *)getMeta;

@end
