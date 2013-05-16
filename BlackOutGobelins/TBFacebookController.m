//
//  TBFacebookController.m
//  BlackOutGobelins
//
//  Created by tony's computer on 17/04/13.
//
//

#import "TBFacebookController.h"

const NSString *GRAPH_API_URL = @"http://graph.facebook.com";

@implementation TBFacebookController
{
    int _totalFriends;
    int _loadedFriends;
    int _maxMutualFriendsNumber;
    int _maxFriendsNumber;
}

@synthesize user = _user;
@synthesize bestFriend = _bestFriend;
@synthesize mostPopularFriend = _mostPopularFriend;

-(void)getProfilePicture:(id)delegate
{
    NSString *urlString = [NSString stringWithFormat:@"%@/picture?type=large", [self getGraphAPIURLFromCurrentUser]];
    
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:2];
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                     delegate:delegate];
    if (!urlConnection) NSLog(@"Failed to download picture");
}

-(void)getFriendsData
{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        if (!error)
        {
            NSArray* friends = [result objectForKey:@"data"];
        
            int i = 0;
            int length = [friends count];
        
            _totalFriends = length;
            _loadedFriends = 0;
            _maxMutualFriendsNumber = 0;
        
            for(i = 0; i < length; i++)
            {
                NSDictionary<FBGraphUser>* friend = [friends objectAtIndex:i];
                
                TBFacebookFriendDescriptor *friendDescriptor = [[TBFacebookFriendDescriptor alloc] initWithGraphUser:friend];
            
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendIsLoaded:) name:[NSString stringWithFormat:@"LOADED_%@",friend.id] object:nil];
            
                [friendDescriptor loadFriendData];
            }
        }
    }];
}

-(void) friendIsLoaded:(NSNotification *)notification
{
    TBFacebookFriendDescriptor *friend = (TBFacebookFriendDescriptor *)[notification object];
    
    if(_maxMutualFriendsNumber < friend.mutualFriendsNumber)
    {
        _maxMutualFriendsNumber = friend.mutualFriendsNumber;
        _bestFriend = friend;
    }
    
    if(_maxFriendsNumber < friend.friendsNumber)
    {
        _maxFriendsNumber = friend.friendsNumber;
        _mostPopularFriend = friend;
    }
    
    _loadedFriends ++;
    
    if(_loadedFriends == _totalFriends)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"READY" object:nil];
    }
}

-(void)setUserFromData:(NSMutableDictionary *)userData
{
    _user = [[TBFacebookUserDescriptor alloc] initWithDictionnary:userData];
}

-(void)setBestFriendFromData:(NSMutableDictionary *)userData
{
    _bestFriend = [[TBFacebookFriendDescriptor alloc] initWithDictionnary:userData];
}

-(void)setMostPopularFriendFromData:(NSMutableDictionary *)userData
{
    _mostPopularFriend = [[TBFacebookFriendDescriptor alloc] initWithDictionnary:userData];
}

-(NSString *)getGraphAPIURLFromCurrentUser
{
    return [self getGraphAPIURLFromUserId:_user.userId];
}

-(NSString *)getGraphAPIURLFromUserId:(NSString *)userId
{
    return [NSString stringWithFormat:@"%@/%@", GRAPH_API_URL, userId];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
