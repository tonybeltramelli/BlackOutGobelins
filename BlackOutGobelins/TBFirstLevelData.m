//
//  TBFirstLevelData.m
//  BlackOutGobelins
//
//  Created by tony's computer on 27/05/13.
//
//

#import "TBFirstLevelData.h"
#import "TBModel.h"

@implementation TBFirstLevelData

-(NSString *)getUserName
{
    if([self isUserAvailable])
    {
        return [TBModel getInstance].facebookController.user.name;
    }
    
    return @"This is a fake name";
}

-(NSString *)getUserNameDataType
{
    return @"Facebook user name";
}

-(BOOL)isUserAvailable
{
    return [TBModel getInstance].facebookController.user != nil;
}

-(NSString *)getBestFriendName
{
    if([self isBestFriendAvailable])
    {
        return [TBModel getInstance].facebookController.bestFriend.name;
    }
    
    return @"Fake bestfriend";
}

-(int)getBestFriendMutualFriendsNumber
{
    if([self isBestFriendAvailable])
    {
        return [TBModel getInstance].facebookController.bestFriend.mutualFriendsNumber;
    }
    
    return 0;
}

-(BOOL)isBestFriendAvailable
{
    return [TBModel getInstance].facebookController.bestFriend != nil;
}

@end
