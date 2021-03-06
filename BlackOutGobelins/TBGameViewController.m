//
//  TBGameViewController.m
//  BlackOutGobelins
//
//  Created by Tony Beltramelli on 04/04/13.
//
//

#import "TBGameViewController.h"
#import "TBPreHomeViewController.h"
#import "cocos2d.h"
#import "TBSplashScreen.h"
#import "TBModel.h"
#import "TBVideoPlayer.h"

@interface TBGameViewController ()

@end

@implementation TBGameViewController
{
    CCGLView *_glView;
    TBVideoPlayer *_videoPlayer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [TBModel getInstance].gameController = self;
    
    if([TBModel getInstance].facebookController.user.isDoorOpen)
    {
        _videoPlayer = [[TBVideoPlayer alloc] initWithVideoName:@"second_level" andVideoType:@"mov" loop:FALSE withDelegate:self stateDidChangeCallBack:@selector(moviePlayerLoadStateDidChange:) playBackDidFinishCallBack:@selector(moviePlayBackDidFinish:)];
        [self.view addSubview:_videoPlayer];
        
        return;
    }
    
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

- (void)moviePlayerLoadStateDidChange:(NSNotification *)notification
{
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
    [_videoPlayer stop];
    [_videoPlayer removeFromSuperview];
    
    [[TBModel getInstance].facebookDataManager dropBase];
}

-(void) loginFacebook
{
    [TBModel getInstance].facebookController.user.isDoorOpen = TRUE;
    [[TBModel getInstance].facebookDataManager saveUser];
    
    [self navigateToFacebookProfile];
    
    [UIView animateWithDuration:0.3 delay:0.5 options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         [self.navigationController pushViewController:[[[TBPreHomeViewController alloc] initWithNibName:nil bundle:nil] autorelease] animated:YES];
                         [self removeFromParentViewController];
                     }];
}

-(void) navigateToFacebookProfile
{   
    NSURL *facebookUrl = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@", [TBModel getInstance].facebookController.user.userId]];
    
    [[UIApplication sharedApplication] openURL:facebookUrl];
}

@end
