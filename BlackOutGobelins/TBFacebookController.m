//
//  TBFacebookController.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 17/04/13.
//
//

#import "TBFacebookController.h"
#import "TBModel.h"

@implementation TBFacebookController
{
    int _totalFriends;
    int _loadedFriends;
    int _maxMutualFriendsNumber;
    int _maxFriendsNumber;
    int _numberSomeFriendsToSave;
    
    NSMutableArray *_allFriends;
}

@synthesize user = _user;
@synthesize bestFriend = _bestFriend;
@synthesize friendOnPicture = _friendOnPicture;
@synthesize someFriends = _someFriends;

- (id)init
{
    self = [super init];
    if (self) {
        _numberSomeFriendsToSave = 5;
    }
    return self;
}

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
                        _friendOnPicture.pictureUrl = [pictureUrl retain];
                        
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendOnPictureIsLoaded:) name:[NSString stringWithFormat:@"LOADED_%@", _friendOnPicture.userId] object:nil];
                        
                        [_friendOnPicture loadMutualFriends];
                        
                        return;
                    }
                }
            }
        }
    }];
}

-(void) friendOnPictureIsLoaded:(NSNotification *)notification
{
    TBFacebookFriendDescriptor *friend = (TBFacebookFriendDescriptor *)[notification object];
    _friendOnPicture.mutualFriendsNumber = friend.mutualFriendsNumber;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"LOADED_%@", friend.userId] object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FRIEND_LOADED" object:nil];
}

-(void)getFriendsData
{
    _allFriends = [[NSMutableArray alloc] init];
    
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
            
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendIsLoaded:) name:[NSString stringWithFormat:@"LOADED_%@", friend.id] object:nil];
            
                [friendDescriptor loadMutualFriends];
            }
        }
    }];
}

-(void) friendIsLoaded:(NSNotification *)notification
{
    TBFacebookFriendDescriptor *friend = (TBFacebookFriendDescriptor *)[notification object];
    
    [_allFriends addObject:friend];
    
    if(_maxMutualFriendsNumber < friend.mutualFriendsNumber)
    {
        _maxMutualFriendsNumber = friend.mutualFriendsNumber;
        _bestFriend = friend;
    }
    
    _loadedFriends ++;
    
    if(_loadedFriends == _totalFriends)
    {
        _someFriends = [[NSMutableArray alloc] init];
        
        int randomIndex;
        TBFacebookFriendDescriptor *parsedFriend;
        
        for(int i = 0; i < _numberSomeFriendsToSave; i++)
        {
            randomIndex = arc4random() % [_allFriends count];
            parsedFriend = (TBFacebookFriendDescriptor *)[_allFriends objectAtIndex:randomIndex];
            
            [_someFriends addObject:parsedFriend];
        }
        
        if(!_friendOnPicture)
        {
            _friendOnPicture = [_someFriends objectAtIndex:_numberSomeFriendsToSave - 1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FRIEND_LOADED" object:nil];
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"READY" object:nil];
    }
}

-(void)setUserFromGraph:(NSDictionary<FBGraphUser> *)user
{
    _user = [[TBFacebookUserDescriptor alloc] initWithGraphUser:user];
    [_user loadExtraData];
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

-(void)setSomeFriendsFromData:(NSMutableArray *)allData
{
    _someFriends = [[NSMutableArray alloc] init];
    
    int i = 0;
    int length = [allData count];
    
    for(i = 0; i < length; i++)
    {
        TBFacebookFriendDescriptor *friend = [[TBFacebookFriendDescriptor alloc] initWithDictionnary:(NSMutableDictionary*)[allData objectAtIndex:i]];
        [_someFriends addObject:friend];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_allFriends release];
    _allFriends = nil;
    
    [super dealloc];
}

@end
