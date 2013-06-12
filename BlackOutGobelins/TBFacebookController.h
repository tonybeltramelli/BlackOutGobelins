//
//  TBFacebookController.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 17/04/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#import "TBFacebookFriendDescriptor.h"

@interface TBFacebookController : NSObject

@property (assign, nonatomic) TBFacebookUserDescriptor *user;
@property (assign, nonatomic) TBFacebookFriendDescriptor *bestFriend;
@property (assign, nonatomic) TBFacebookFriendDescriptor *friendOnPicture;
@property (assign, nonatomic) NSMutableArray *someFriends;

-(void)setUserFromGraph:(NSDictionary<FBGraphUser> *)user;
-(void)setUserFromData:(NSMutableDictionary *)userData;
-(void)setBestFriendFromData:(NSMutableDictionary *)userData;
-(void)setPictureFriendFromData:(NSMutableDictionary *)userData;
-(void)setSomeFriendsFromData:(NSMutableArray *)allData;

-(void)getFriendOnPicture;
-(void)getFriendsData;

@end
