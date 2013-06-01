
//
//  TBFacebookDataManager.m
//  BlackOutGobelins
//
//  Created by Tony Beltramelli on 15/05/13.
//
//

#import "TBFacebookDataManager.h"

//user
NSString *USER_TABLE_NAME= @"USER";

//bestfriend
NSString *BESTFRIEND_TABLE_NAME = @"BESTFRIEND";
NSString *MUTUAL_FRIENDS_NUMBER = @"MUTUAL_FRIENDS_NUMBER";

//friend on picture
NSString *FRIEND_ON_PICTURE_TABLE_NAME = @"FRIEND_ON_PICTURE";
NSString *PICTURE_URL = @"PICTURE_URL";

//common rows
NSString *USER_ID = @"USER_ID";
NSString *USER_NAME = @"USER_NAME";
NSString *PROFILE_PICTURE_URL = @"PROFILE_PICTURE_URL";

//some friends
NSString *SOME_FRIENDS_TABLE_NAME = @"SOME_FRIENDS";

@implementation TBFacebookDataManager
{
    TBFacebookController *_facebookController;
    TBDatabaseController *_databaseController;
}

- (id)initWithControllers:(TBFacebookController *)facebookController and:(TBDatabaseController *)databaseController
{
    self = [super init];
    if (self) {
        _facebookController = facebookController;
        _databaseController = databaseController;
    }
    return self;
}

-(void) saveUser
{
    NSString *userId = _facebookController.user.userId;
    NSString *userName = _facebookController.user.name;
    NSString *userProfilePictureUrl = _facebookController.user.profilePictureUrl;
    
    [self cleanIfDataAlreadySaved:userId on:USER_TABLE_NAME];
    
    NSString *requestParams = [NSString stringWithFormat:@"%@ TEXT, %@ TEXT, %@ TEXT", USER_NAME, PROFILE_PICTURE_URL, USER_ID];
    
    [_databaseController createTable:USER_TABLE_NAME andParams:requestParams];
    
    NSMutableDictionary *toSave = [[NSMutableDictionary alloc] init];
    [toSave setObject:userId forKey:USER_ID];
	[toSave setObject:userName forKey:USER_NAME];
    [toSave setObject:userProfilePictureUrl forKey:PROFILE_PICTURE_URL];
    
    [_databaseController insertIntoTable:USER_TABLE_NAME theseRowsAndValues:toSave];
}

-(void) saveBestFriend
{
    NSString *bestfriendUserId = _facebookController.bestFriend.userId;
    NSString *bestfriendName = _facebookController.bestFriend.name;
    NSString *bestfriendProfilePictureUrl = _facebookController.bestFriend.profilePictureUrl;
    int mutualFriendsNumber = _facebookController.bestFriend.mutualFriendsNumber;
    
    [self cleanIfDataAlreadySaved:bestfriendUserId on:BESTFRIEND_TABLE_NAME];
    
    NSString *requestParams = [NSString stringWithFormat:@"%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT", USER_NAME, MUTUAL_FRIENDS_NUMBER, PROFILE_PICTURE_URL, USER_ID];
    
    [_databaseController createTable:BESTFRIEND_TABLE_NAME andParams:requestParams];
    
    NSMutableDictionary *toSave = [[NSMutableDictionary alloc] init];
    [toSave setObject:bestfriendUserId forKey:USER_ID];
	[toSave setObject:bestfriendName forKey:USER_NAME];
    [toSave setObject:bestfriendProfilePictureUrl forKey:PROFILE_PICTURE_URL];
	[toSave setObject:[NSString stringWithFormat:@"%d", mutualFriendsNumber] forKey:MUTUAL_FRIENDS_NUMBER];
    
    [_databaseController insertIntoTable:BESTFRIEND_TABLE_NAME theseRowsAndValues:toSave];
}

-(void) saveFriendOnPicture
{    
    NSString *friendOnPictureUserId = _facebookController.friendOnPicture.userId;
    NSString *friendOnPictureName = _facebookController.friendOnPicture.name;
    NSString *friendProfilePictureUrl = _facebookController.friendOnPicture.profilePictureUrl;
    NSString *friendPictureUrl = _facebookController.friendOnPicture.pictureUrl;
    
    [self cleanIfDataAlreadySaved:friendOnPictureUserId on:FRIEND_ON_PICTURE_TABLE_NAME];
    
    NSString *requestParams = [NSString stringWithFormat:@"%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT", USER_NAME, PROFILE_PICTURE_URL, PICTURE_URL, USER_ID];
    
    [_databaseController createTable:FRIEND_ON_PICTURE_TABLE_NAME andParams:requestParams];
    
    NSMutableDictionary *toSave = [[NSMutableDictionary alloc] init];
    [toSave setObject:friendOnPictureUserId forKey:USER_ID];
	[toSave setObject:friendOnPictureName forKey:USER_NAME];
    [toSave setObject:friendProfilePictureUrl forKey:PROFILE_PICTURE_URL];
    [toSave setObject:friendPictureUrl forKey:PICTURE_URL];
    
    [_databaseController insertIntoTable:FRIEND_ON_PICTURE_TABLE_NAME theseRowsAndValues:toSave];
}

-(void) saveSomeFriends
{
    int i = 0;
    int length = [_facebookController.someFriends count];
    
    for(i = 0; i < length; i++)
    {
        TBFacebookFriendDescriptor *parsedFriend = (TBFacebookFriendDescriptor *)[_facebookController.someFriends objectAtIndex:i];
        
        NSString *userId = parsedFriend.userId;
        NSString *userName = parsedFriend.name;
        NSString *userProfilePictureUrl = parsedFriend.profilePictureUrl;
        
        NSString *requestParams = [NSString stringWithFormat:@"%@ TEXT, %@ TEXT, %@ TEXT", USER_NAME, PROFILE_PICTURE_URL, USER_ID];
        
        [_databaseController createTable:SOME_FRIENDS_TABLE_NAME andParams:requestParams];
        
        NSMutableDictionary *toSave = [[NSMutableDictionary alloc] init];
        [toSave setObject:userId forKey:USER_ID];
        [toSave setObject:userName forKey:USER_NAME];
        [toSave setObject:userProfilePictureUrl forKey:PROFILE_PICTURE_URL];
        
        [_databaseController insertIntoTable:SOME_FRIENDS_TABLE_NAME theseRowsAndValues:toSave];
    }
}

-(BOOL)cleanIfDataAlreadySaved:(NSString *)valueToCheck on:(NSString *)tableName
{
    NSMutableArray *result = [_databaseController getRow:USER_ID fromTable:tableName];
    
    BOOL boo;
    
    if([result count] > 1)
    {
        [_databaseController dropTable:tableName];
        boo = FALSE;
    }else if([result count] == 1 && [(NSString *)[result objectAtIndex:0] isEqualToString:valueToCheck])
    {
        boo = TRUE;
    }
    
    return boo;
}

-(void)setUserFromGraph:(NSDictionary<FBGraphUser> *)user
{
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
    [userData setObject:user.id forKey:USER_ID];
    [userData setObject:user.name forKey:USER_NAME];
    
    [_facebookController setUserFromData:userData];
    
    [self saveUser];
}

-(NSString *) getBestFriend
{
    NSMutableArray *resultNames = [_databaseController getRow:USER_NAME fromTable:BESTFRIEND_TABLE_NAME];
    
    NSString *bestFriendName = @"";
    
    if([resultNames count] > 0)
    {
        bestFriendName = (NSString *)[resultNames objectAtIndex:0];
    }
    
    if(![bestFriendName isEqualToString:@""])
    {
        NSMutableArray *resultUserIds = [_databaseController getRow:USER_ID fromTable:BESTFRIEND_TABLE_NAME];
        NSMutableArray *resultMutualFriendsNumbers = [_databaseController getRow:MUTUAL_FRIENDS_NUMBER fromTable:BESTFRIEND_TABLE_NAME];
        NSMutableArray *resultProfilePicture = [_databaseController getRow:PROFILE_PICTURE_URL fromTable:BESTFRIEND_TABLE_NAME];
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
        [userData setObject:(NSString *)[resultUserIds objectAtIndex:0] forKey:USER_ID];
        [userData setObject:bestFriendName forKey:USER_NAME];
        [userData setObject:(NSString *)[resultMutualFriendsNumbers objectAtIndex:0] forKey:MUTUAL_FRIENDS_NUMBER];
        [userData setObject:(NSString *)[resultProfilePicture objectAtIndex:0] forKey:PROFILE_PICTURE_URL];
        
        [_facebookController setBestFriendFromData:userData];
    }
    
    return bestFriendName;
}

-(NSString *) getFriendOnPicture
{
    NSMutableArray *resultNames = [_databaseController getRow:USER_NAME fromTable:FRIEND_ON_PICTURE_TABLE_NAME];
    
    NSString *friendOnPictureName = @"";
    
    if([resultNames count] > 0)
    {
        friendOnPictureName = (NSString *)[resultNames objectAtIndex:0];
    }
    
    if(![friendOnPictureName isEqualToString:@""])
    {
        NSMutableArray *resultUserIds = [_databaseController getRow:USER_ID fromTable:FRIEND_ON_PICTURE_TABLE_NAME];
        NSMutableArray *resultProfilePicture = [_databaseController getRow:PROFILE_PICTURE_URL fromTable:FRIEND_ON_PICTURE_TABLE_NAME];
        NSMutableArray *resultPicture = [_databaseController getRow:PICTURE_URL fromTable:FRIEND_ON_PICTURE_TABLE_NAME];
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
        [userData setObject:(NSString *)[resultUserIds objectAtIndex:0] forKey:USER_ID];
        [userData setObject:friendOnPictureName forKey:USER_NAME];
        [userData setObject:(NSString *)[resultProfilePicture objectAtIndex:0] forKey:PROFILE_PICTURE_URL];
        [userData setObject:(NSString *)[resultPicture objectAtIndex:0] forKey:PICTURE_URL];
        
        [_facebookController setPictureFriendFromData:userData];
    }
    
    return friendOnPictureName;
}

-(NSString *) getUser
{
    NSMutableArray *resultNames = [_databaseController getRow:USER_NAME fromTable:USER_TABLE_NAME];
    
    NSString *userName = @"";
    
    if([resultNames count] > 0)
    {
        userName = (NSString *)[resultNames objectAtIndex:0];
    }
    
    if(![userName isEqualToString:@""])
    {
        NSMutableArray *resultUserIds = [_databaseController getRow:USER_ID fromTable:USER_TABLE_NAME];
        NSMutableArray *resultProfilePicture = [_databaseController getRow:PROFILE_PICTURE_URL fromTable:USER_TABLE_NAME];
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
        [userData setObject:(NSString *)[resultUserIds objectAtIndex:0] forKey:USER_ID];
        [userData setObject:userName forKey:USER_NAME];
        [userData setObject:(NSString *)[resultProfilePicture objectAtIndex:0] forKey:PROFILE_PICTURE_URL];
        
        [_facebookController setUserFromData:userData];
    }
    
    return userName;
}

-(NSMutableArray *) getSomeFriends
{
    NSMutableArray *resultNames = [_databaseController getRow:USER_NAME fromTable:SOME_FRIENDS_TABLE_NAME];
    NSMutableArray *resultUserIds = [_databaseController getRow:USER_ID fromTable:SOME_FRIENDS_TABLE_NAME];
    NSMutableArray *resultProfilePicture = [_databaseController getRow:PROFILE_PICTURE_URL fromTable:SOME_FRIENDS_TABLE_NAME];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    int i = 0;
    int length = [resultNames count];
        
    for(i = 0; i < length; i ++)
    {
        NSMutableDictionary *friendData = [[NSMutableDictionary alloc] init];
        [friendData setObject:(NSString *)[resultUserIds objectAtIndex:i] forKey:USER_ID];
        [friendData setObject:(NSString *)[resultNames objectAtIndex:i] forKey:USER_NAME];
        [friendData setObject:(NSString *)[resultProfilePicture objectAtIndex:i] forKey:PROFILE_PICTURE_URL];
        
        [result addObject:friendData];
    }
    
    [_facebookController setSomeFriendsFromData:result];
    
    return resultNames;
}

- (void)dealloc
{
    [_facebookController release];
    _facebookController = nil;
    
    [_databaseController release];
    _databaseController = nil;
    
    [super dealloc];
}

@end
