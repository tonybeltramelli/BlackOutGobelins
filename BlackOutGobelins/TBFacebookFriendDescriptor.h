//
//  TBFacebookFriendDescriptor.h
//  BlackOutGobelins
//
//  Created by tony's computer on 17/04/13.
//
//

#import <Foundation/Foundation.h>

#import "TBFacebookUserDescriptor.h"

@interface TBFacebookFriendDescriptor : TBFacebookUserDescriptor

@property(nonatomic) int mutualFriendsNumber;
@property(nonatomic, assign) NSString *pictureUrl;

- (void)loadMutualFriends;

@end
