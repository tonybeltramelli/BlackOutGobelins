//
//  IntroLayer.m
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 12/12/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "TBSplashScreen.h"
#import "TBAssetPreLoader.h"
#import "TBMapScreen.h"

@implementation TBSplashScreen

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
	
	TBSplashScreen *layer = [TBSplashScreen node];
	[scene addChild: layer];
	
    return scene;
}

-(void) onEnter
{
	[super onEnter];
    
	CGSize size = [[CCDirector sharedDirector] winSize];

    CCSprite *background;
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		background = [CCSprite spriteWithFile:@"Default.png"];
		background.rotation = 90;
	} else {
		background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
	}
	background.position = ccp(size.width/2, size.height/2);

	[self addChild: background];
    
    TBAssetPreLoader *preloader = [[TBAssetPreLoader alloc] init];
    [preloader setPosition:CGPointMake(size.width / 2, size.height / 2)];
    [self addChild:preloader];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preloadingComplete:) name:@"PRELOADING_COMPLETE" object:nil];
    
    [preloader loadOnlySpritesheets:TRUE andUsePVR:TRUE];
}

-(void) preloadingComplete:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self scheduleOnce:@selector(makeTransition:) delay:0.2];
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TBMapScreen scene] withColor:ccBLACK]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
