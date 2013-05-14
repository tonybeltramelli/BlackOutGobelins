//
//  TBFacebookController.h
//  BlackOutGobelins
//
//  Created by tony's computer on 17/04/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#import "TBFacebookFriendDescriptor.h"

@interface TBFacebookController : NSObject

@property (assign, nonatomic) NSDictionary<FBGraphUser> *user;
@property (assign, nonatomic) TBFacebookFriendDescriptor *bestFriend;

-(void)getProfilePicture:(id)delegate;
-(void)getBestFriend;
-(void)createNewBestFriend:(NSMutableDictionary *)userData;

@end
