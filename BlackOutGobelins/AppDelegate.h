//
//  AppDelegate.h
//  BlackOutGobelins
//
//  Created by tony's computer on 03/04/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "cocos2d.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, CCDirectorDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (strong, nonatomic) FBSession *session;

- (void)goToGamePage;

@end
