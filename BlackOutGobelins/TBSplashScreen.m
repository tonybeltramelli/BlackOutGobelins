//
//  IntroLayer.m
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 12/12/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "TBSplashScreen.h"
#import "TBAssetPreLoader.h"
#import "TBMapScreen.h"
#import "CCLabelTTF.h"

@implementation TBSplashScreen
{
    CCLabelTTF *_label;
}

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
    
    int n = (arc4random() % 3) + 1;
    
    NSString *tipText = [NSString stringWithFormat:@"TIP_%d", n];
    
    _label = [CCLabelTTF labelWithString:NSLocalizedString(tipText, nil) dimensions:CGSizeMake(size.width * 0.8, size.height) hAlignment:NSTextAlignmentCenter fontName:@"Helvetica" fontSize:16.0f];
    [_label setPosition:CGPointMake(size.width / 2, -20.0f)];
    [_label setColor:ccc3(200, 200, 200)];
    [self addChild:_label];
    
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
    _label = nil;
    
    [super dealloc];
}

@end
