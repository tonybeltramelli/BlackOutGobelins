//
//  TBFacebookFriendDescriptor.m
//  BlackOutGobelins
//
//  Created by tony's computer on 17/04/13.
//
//

#import "TBFacebookFriendDescriptor.h"

@implementation TBFacebookFriendDescriptor
{
    int _friendsNumber;
}

@synthesize mutualFriendsNumber = _mutualFriendsNumber;

-(id)initWithDictionnary:(NSDictionary *)userData
{
    self = [super initWithDictionnary:userData];
    if (self) {
        _mutualFriendsNumber = [(NSString *)[userData objectForKey:@"MUTUAL_FRIENDS_NUMBER"] integerValue];
    }
    return self;
}

- (void)loadMutualFriends
{
    if(!_graphUser) return;
    
    NSString *graphAPIURL = [NSString stringWithFormat:@"me/mutualfriends/%@/", _graphUser.id];
    
    FBRequest* request = [FBRequest requestForGraphPath:graphAPIURL];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error)
        {
            NSArray* mutualFriends = [result objectForKey:@"data"];
            _mutualFriendsNumber = [mutualFriends count];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"LOADED_%@",_graphUser.id] object:self];
        }
    }];
}

- (void)loadFriends
{
    if(!_graphUser) return;
    
    FBRequest* request = [FBRequest requestForGraphPath:@"me/friends/"];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error)
        {
            NSArray* friends = [result objectForKey:@"data"];
            _friendsNumber = [friends count];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"LOADED_%@",_graphUser.id] object:self];
        }
    }];
}

@end
