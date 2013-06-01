//
//  TBGamePopin.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 20/05/13.
//
//

#import "TBGamePopin.h"
#import "TBResources.h"
#import "CCSpriteScale9.h"

@implementation TBGamePopin
{    
    CCSpriteScale9 *_background;
}

- (id)initWithSize:(CGSize)size
{
    self = [super init];
    if (self)
    {
        _size = size;
        
        _background = [CCSpriteScale9 spriteWithFile:[TBResources getAsset:"rounded_corner_popin.png"] andLeftCapWidth:10.0f andTopCapHeight:10.0f];
        [_background scale9:size];
        
        [self addChild:_background];
    }
    return self;
}

- (void)show {
    [self fadeTo:255];
}

- (void)hide {
    [self fadeTo:0];
}

- (void)fadeTo:(GLubyte)value
{
    int i = 0;
    int length = [[self children] count];
    
    for(i = 0; i < length; i++)
    {
        CCNode *child = (CCNode *)[[self children] objectAtIndex:i];
        [child runAction:[CCFadeTo actionWithDuration:0.5f opacity:value]];
    }
}

- (void)dealloc
{
    _background = nil;
    
    [super dealloc];
}

@end
