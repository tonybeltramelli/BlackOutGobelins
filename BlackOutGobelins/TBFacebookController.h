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

@property (assign, nonatomic) TBFacebookUserDescriptor *user;
@property (assign, nonatomic) TBFacebookFriendDescriptor *bestFriend;

-(void)setUserFromData:(NSMutableDictionary *)userData;
-(void)setBestFriendFromData:(NSMutableDictionary *)userData;

-(void)getProfilePicture:(id)delegate;
-(void)getBestFriend;

@end
