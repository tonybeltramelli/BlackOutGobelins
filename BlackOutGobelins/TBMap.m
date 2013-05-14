//
//  TBMap.m
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 08/01/13.
//
//

#import "TBMap.h"

@implementation TBMap

const bool USE_ANTIALIAS = FALSE;

@synthesize map = _map;

- (id)initWith:(NSString *)mapName
{
    self = [super init];
    if (self) {
        _map = [CCTMXTiledMap tiledMapWithTMXFile:mapName];
        
        for( CCTMXLayer* child in [_map children] ) {
            if(USE_ANTIALIAS)
            {
                [[child texture] setAntiAliasTexParameters];
                [[child textureAtlas].texture setAntiAliasTexParameters];
            }else{
                [[child texture] setAliasTexParameters];
                [[child textureAtlas].texture setAliasTexParameters];
            }
        }
        
        [self draw];
        [self addChild:_map];
    }
    return self;
}

- (id)initWith:(NSString *)mapName andDisplayOnly:(NSString *)layerName
{
    self = [self initWith:mapName];
    if(self) {
        int length = [[_map children] count];
        
        for(int i = 0; i < length; i++)
        {
            CCTMXLayer *layer = [[_map children] objectAtIndex:i];
            if(![layer.layerName isEqual:layerName]) layer.visible = NO;
        }
    } 
    return self;
}

- (id)initWith:(NSString *)mapName andDisplay:(NSMutableArray *)array
{
    self = [self initWith:mapName];
    if(self) {
        int length = [[_map children] count];
        
        CCTMXLayer *layer;
        
        for(int i = 0; i < length; i++)
        {
            layer = [[_map children] objectAtIndex:i];
            layer.visible = NO;
        }
        
        int n = [array count];
        
        for(int j = 0; j < n; j++)
        {
            layer = [_map layerNamed:[array objectAtIndex:j]];
            layer.visible = YES;
        }
    }
    return self;
}

- (void) draw
{
   //to override
}

- (CCTMXLayer *) getMeta
{
    return [_map layerNamed:@"meta"];
}

- (void)dealloc
{
    [self removeChild:_map cleanup:TRUE];
    _map = nil;
    
    [super dealloc];
}

@end
