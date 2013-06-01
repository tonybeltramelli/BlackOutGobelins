//
//  AppDelegate.mm
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 03/04/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "TBModel.h"
#import "TBGameViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize director = _director;
@synthesize session = _session;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	_director = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	_director.wantsFullScreenLayout = YES;
	[_director setDisplayStats:YES];
	[_director setAnimationInterval:1.0/60];
	[_director setDelegate:self];
	[_director setProjection:kCCDirectorProjection2D];
    
    [_director setContentScaleFactor:[[TBModel getInstance] isRetinaDisplay] ? 2.0f : 1.0f];
	
    if( ! [_director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];
	[sharedFileUtils setiPadSuffix:@"-ipad"];
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];
	
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
    [[TBModel getInstance] setAppDelegate:self];
    
	_navController = [[UINavigationController alloc] initWithRootViewController:_director];
	_navController.navigationBarHidden = YES;
    
	[_window setRootViewController:_navController];
	[_window makeKeyAndVisible];
    
	return YES;
}

- (void)goToGamePage
{
    [_navController pushViewController:[[[TBGameViewController alloc] initWithNibName:nil bundle:nil] autorelease] animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [_navController visibleViewController] == _director )
		[_director pause];
}

-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [_navController visibleViewController] == _director )
		[_director resume];
    
    [FBSession.activeSession handleDidBecomeActive];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [_navController visibleViewController] == _director )
		[_director stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [_navController visibleViewController] == _director )
		[_director startAnimation];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [_session handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
    
    [_session close];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[_window release];
	[_navController release];
	
	[super dealloc];
}
@end