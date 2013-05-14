//
//  TBFacebookFriendDescriptor.h
//  BlackOutGobelins
//
//  Created by tony's computer on 17/04/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface TBFacebookFriendDescriptor : NSObject

@property(nonatomic, assign) NSString *userId;
@property(nonatomic, assign) NSString *name;
@property(nonatomic) int mutualFriendsNumber;

-(id)initWithGraphUser:(NSDictionary<FBGraphUser> *)graphUser;
-(id)initWithDictionnary:(NSDictionary *)userData;
-(void) loadMutualFriends;

@end
