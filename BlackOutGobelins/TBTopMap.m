//
//  TBTopMap.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 30/05/13.
//
//

#import "TBTopMap.h"
#import "TBMap.h"
#import "TBResources.h"

@implementation TBTopMap

- (id)init
{
    self = [super init];
    if (self) {
        NSMutableArray *topLayers = [[NSMutableArray alloc] init];
        [topLayers addObject:@"foreground2_decor"];
        [topLayers addObject:@"foreground2_mur"];
        [topLayers addObject:@"foreground_decor"];
        [topLayers addObject:@"foreground_mur"];
        
        TBMap *topMap = [[TBMap alloc] initWith:[TBResources getAsset:ASSETS_MAP_LEVEL1_TMX] andDisplay:topLayers];
        [self addChild:topMap];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
