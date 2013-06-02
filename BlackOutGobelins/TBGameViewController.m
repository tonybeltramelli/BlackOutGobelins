//
//  TBGameViewController.m
//  BlackOutGobelins
//
//  Created by Tony Beltramelli on 04/04/13.
//
//

#import "TBGameViewController.h"

#import "cocos2d.h"
#import "TBSplashScreen.h"

@interface TBGameViewController ()

@end

@implementation TBGameViewController
{
    CCGLView *_glView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(_glView == nil)
    {
        _glView = [CCGLView viewWithFrame:self.view.bounds
                              pixelFormat:kEAGLColorFormatRGBA8 //kEAGLColorFormatRGB565
                              depthFormat:0
                       preserveBackbuffer:NO
                               sharegroup:nil
                            multiSampling:NO
                          numberOfSamples:0];
        
        [_glView setMultipleTouchEnabled:YES];
        
        [CCTexture2D PVRImagesHavePremultipliedAlpha:TRUE];
        
        [self.view insertSubview:_glView atIndex:0];
        [[CCDirector sharedDirector] setView:_glView];
        
        [[CCDirector sharedDirector] runWithScene: [TBSplashScreen scene]];
    }
}

@end
