//
//  TBEnvironment.m
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 22/01/13.
//
//

#import "TBEnvironment.h"
#import "TBModel.h"
#import "TypeDef.c"
#import "TBResources.h"

@implementation TBEnvironment
{
    TBMap *_elementLayer;
    
    CGSize _mapSize;
    CGSize _tileSize;
    CCTMXLayer *_meta;
    float _ratio;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSMutableArray *elementLayers = [[NSMutableArray alloc] init];
        [elementLayers addObject:@"sets"];
        [elementLayers addObject:@"wall3"];
        [elementLayers addObject:@"wall2"];
        [elementLayers addObject:@"wall"];
        [elementLayers addObject:@"effect"];
        [elementLayers addObject:@"floor"];
        [elementLayers addObject:@"background"];
        
        _elementLayer = [[TBMap alloc] initWith:[TBResources getAsset:ASSETS_MAP_LEVEL1_TMX] andDisplay:elementLayers];
        [self addChild:_elementLayer z:-1 tag:elementLayer];
        
        _meta = _elementLayer.getMeta;
        _mapSize = _elementLayer.map.mapSize;
        _tileSize = _elementLayer.map.tileSize;
        
        _ratio = [[TBModel getInstance] isRetinaDisplay] ? 0.5f : 1.0f;
    }
    return self;
}

- (CGPoint)getStartPositionFromMeta
{
    return [self getMetaWithKey:@"start" andValue:@"true"];
}

- (NSMutableArray *)getBotsStartPositions:(int)botNumber
{
    return [self getAllMetaWithKey:@"bot" andValue:[NSString stringWithFormat:@"%d", botNumber]];
}

- (NSMutableArray *)getCharactersPositions:(int)charactersNumber
{
    return [self getAllMetaWithKey:@"character" andValue:[NSString stringWithFormat:@"%d", charactersNumber]];
}

- (NSMutableArray *)getObstaclesPositions
{
    return [self getAllMetaWithKey:@"obstacle" andValue:@"true"];
}

- (CGPoint)getMetaWithKey:(NSString *)key andValue:(NSString *)value
{
    int i = 0;
    int j = 0;
    
    for(i = 0; i < _mapSize.width; i++)
    {
        for(j = 0; j < _mapSize.height; j++)
        {
            int tileGid = [_meta tileGIDAt:ccp(i, j)];
            if([self testTileGrid:tileGid withKey:key andValue:value])
            {
                int cocosX = i * _tileSize.width;
                int cocosY = (_mapSize.height * _tileSize.height) - (j * _tileSize.height);
                
                return CGPointMake(cocosX * _ratio, cocosY * _ratio);
            }
        }
    }
    
    return CGPointZero;
}

- (NSMutableArray *)getAllMetaWithKey:(NSString *)key andValue:(NSString *)value
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    int i = 0;
    int j = 0;
    
    for(i = 0; i < _mapSize.width; i++)
    {
        for(j = 0; j < _mapSize.height; j++)
        {
            int tileGid = [_meta tileGIDAt:ccp(i, j)];
            if([self testTileGrid:tileGid withKey:key andValue:value])
            {
                int cocosX = i * _tileSize.width;
                int cocosY = (_mapSize.height * _tileSize.height) - (j * _tileSize.height);
                
                CGPoint point = CGPointMake(cocosX * _ratio, cocosY * _ratio);
                NSValue *value = [NSValue valueWithCGPoint: point];
                [result addObject:value];
            }
        }
    }
    
    return result;
}

- (BOOL)isCollisionAt:(CGPoint)position
{
    return [self testTileWithKey:@"collidable" andValue:@"true" at:position];
}

- (BOOL)isObstacleAt:(CGPoint)position
{
    return [self testTileWithKey:@"obstacle" andValue:@"true" at:position];
}

- (BOOL)testTileWithKey:(NSString *)keyName andValue:(NSString *)value at:(CGPoint)position
{
    int tileGid = [_meta tileGIDAt:[self getTileRelativePosition:position]];
    
    return [self testTileGrid:tileGid withKey:keyName andValue:value];
}

- (BOOL)testTileGrid:(int)tileGid withKey:(NSString *)keyName andValue:(NSString *)value
{
    if (tileGid) {
        NSDictionary *properties = [_elementLayer.map propertiesForGID:tileGid];
        
        if (properties)
        {
            NSString *collision = [properties valueForKey:keyName];
            if (collision && [collision compare:value] == NSOrderedSame) return TRUE;
        }
    }
    
    return FALSE;
}

- (void)removeMetaTileAt:(CGPoint)position
{
    [_meta removeTileAt:[self getTileRelativePosition:position]];
}

-(CGPoint)getTileRelativePosition:(CGPoint)absolutePosition
{
    int x = absolutePosition.x / (_tileSize.width * _ratio);
    int y = ((_mapSize.height * (_tileSize.height * _ratio)) - absolutePosition.y) / (_tileSize.height * _ratio);
    
    return CGPointMake(x, y);
}

- (void)dealloc
{
    [self removeChild:_elementLayer cleanup:TRUE];
    
    [_elementLayer release];
    _elementLayer = nil;
    
    _meta = nil;
    
    [super dealloc];
}

@end
