//
//  TBProgressBar.m
//  BlackOutGobelins
//
//  Created by tony's computer on 19/05/13.
//
//

#import "TBProgressBar.h"
#import "CCSpriteScale9.h"
#import "TBResources.h"
#import "TBModel.h"
#import "CCProgressBar.h"

@implementation TBProgressBar
{
    CCProgressBar *_progressBar;
    
    float _width;
    float _heigth;
    float _margin;
}

@synthesize progress = _progress;

- (id)init
{
    self = [super init];
    if (self)
    { 
        _width = 210.0f;
        _heigth = 5.0f;
        _margin = 10.0f;
        _progress = 0.0f;
        
        float cornerSize = 5.0f;
        
        CCSpriteScale9 *background = [CCSpriteScale9 spriteWithFile:[TBResources getAsset:"progress_bar.png"] andLeftCapWidth:cornerSize andTopCapHeight:cornerSize];
        
        CCSpriteScale9 *foreground = [CCSpriteScale9 spriteWithFile:[TBResources getAsset:"progress_bar_glow.png"] andLeftCapWidth:cornerSize andTopCapHeight:cornerSize];
        
        _progressBar = [[CCProgressBar alloc] initWithBgSprite:background andFgSprite:foreground andSize:CGSizeMake(_width, _heigth) andMargin:CGSizeMake(-10.0f, -10.0f)];
        [self addChild:_progressBar];
    }
    return self;
}

-(void)setProgress:(float)progress
{
    _progress = progress;
    [_progressBar animateProgress:_progress];
}

-(void) setPosition:(CGPoint)position
{ 
    [super setPosition:CGPointMake(position.x - _width/2 - _margin, position.y - _heigth/2 - _margin)];
}

- (void)dealloc
{
    [_progressBar release];
    _progressBar = nil;
    
    [super dealloc];
}

@end
