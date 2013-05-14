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
    NSDictionary<FBGraphUser> *_graphUser;
}

@synthesize userId = _userId;
@synthesize name = _name;
@synthesize mutualFriendsNumber = _mutualFriendsNumber;

- (id)initWithGraphUser:(NSDictionary<FBGraphUser> *)graphUser
{
    self = [super init];
    if (self) {
        _graphUser = [graphUser retain];
        
        _userId = _graphUser.id;
        _name = _graphUser.name;
    }
    return self;
}

-(id)initWithDictionnary:(NSDictionary *)userData
{
    self = [super init];
    if (self) {
        _userId = [userData objectForKey:@"USER_ID"];
        _name = [userData objectForKey:@"BESTFRIEND_NAME"];
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

@end
