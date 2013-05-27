//
//  TBFacebookController.m
//  BlackOutGobelins
//
//  Created by tony's computer on 17/04/13.
//
//

#import "TBFacebookController.h"

@implementation TBFacebookController
{
    int _totalFriends;
    int _loadedFriends;
    int _maxMutualFriendsNumber;
    int _maxFriendsNumber;
}

@synthesize user = _user;
@synthesize bestFriend = _bestFriend;
@synthesize friendOnPicture = _friendOnPicture;

-(void)getFriendOnPicture
{
    FBRequest* request = [FBRequest requestForGraphPath:@"me/photos"];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error)
        {
            NSArray* data = [result objectForKey:@"data"];
            int length = [data count];
            
            for(int i = 0; i < length; i++)
            {
                FBGraphObject *photo = [data objectAtIndex:i];
                NSDictionary *tags = [photo objectForKey:@"tags"];
                NSArray *dataTags = [tags objectForKey:@"data"];
                
                NSArray *pictureUrls = [photo objectForKey:@"images"];
                NSDictionary *picture = [pictureUrls objectAtIndex:([pictureUrls count] - 1)];
                NSString *pictureUrl = [picture objectForKey:@"source"];
                
                int n = [dataTags count];

                for(int j = 0; j < n; j++)
                {
                    NSDictionary<FBGraphUser> *friend = [dataTags objectAtIndex:j];
                    
                    if(friend.id != _user.userId)
                    {
                        _friendOnPicture = [[TBFacebookFriendDescriptor alloc] initWithGraphUser:friend];
                        _friendOnPicture.pictureUrl = pictureUrl;
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"FRIEND_LOADED" object:nil];
                        return;
                    }
                }
            }
        }
    }];
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
            
                [friendDescriptor loadMutualFriends];
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

-(void)setPictureFriendFromData:(NSMutableDictionary *)userData
{
    _friendOnPicture = [[TBFacebookFriendDescriptor alloc] initWithDictionnary:userData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
