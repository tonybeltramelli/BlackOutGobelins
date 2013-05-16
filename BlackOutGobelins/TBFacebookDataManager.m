
//
//  TBFacebookDataManager.m
//  BlackOutGobelins
//
//  Created by tony's computer on 15/05/13.
//
//

#import "TBFacebookDataManager.h"

//user
NSString *USER_TABLE_NAME= @"USER";

//bestfriend
NSString *BESTFRIEND_TABLE_NAME = @"BESTFRIEND";
NSString *MUTUAL_FRIENDS_NUMBER = @"MUTUAL_FRIENDS_NUMBER";

//most popular friend
NSString *MOST_POPULAR_FRIEND_TABLE_NAME = @"MOST_POPULAR_FRIEND_TABLE_NAME";
NSString *FRIENDS_NUMBER = @"FRIENDS_NUMBER";

//common rows
NSString *USER_ID = @"USER_ID";
NSString *USER_NAME = @"USER_NAME";

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
    
    if([self isUniqueUserAlreadySaved:userId on:USER_TABLE_NAME])
    {
        return;
    }
    
    NSString *requestParams = [NSString stringWithFormat:@"%@ TEXT, %@ TEXT", USER_NAME, USER_ID];
    
    [_databaseController createTable:USER_TABLE_NAME andParams:requestParams];
    
    NSMutableDictionary *toSave = [[NSMutableDictionary alloc] init];
    [toSave setObject:userId forKey:USER_ID];
	[toSave setObject:userName forKey:USER_NAME];
    
    [_databaseController insertIntoTable:USER_TABLE_NAME theseRowsAndValues:toSave];
}

-(void) saveBestFriend
{
    NSString *bestfriendUserId = _facebookController.bestFriend.userId;
    NSString *bestfriendName = _facebookController.bestFriend.name;
    int mutualFriendsNumber = _facebookController.bestFriend.mutualFriendsNumber;
    
    if([self isUniqueUserAlreadySaved:bestfriendUserId on:BESTFRIEND_TABLE_NAME])
    {
        return;
    }
    
    NSString *requestParams = [NSString stringWithFormat:@"%@ TEXT, %@ TEXT, %@ TEXT", USER_NAME, MUTUAL_FRIENDS_NUMBER, USER_ID];
    
    [_databaseController createTable:BESTFRIEND_TABLE_NAME andParams:requestParams];
    
    NSMutableDictionary *toSave = [[NSMutableDictionary alloc] init];
    [toSave setObject:bestfriendUserId forKey:USER_ID];
	[toSave setObject:bestfriendName forKey:USER_NAME];
	[toSave setObject:[NSString stringWithFormat:@"%d", mutualFriendsNumber] forKey:MUTUAL_FRIENDS_NUMBER];
    
    [_databaseController insertIntoTable:BESTFRIEND_TABLE_NAME theseRowsAndValues:toSave];
}

-(void) saveMostPopularFriend
{
    NSString *popularFriendUserId = _facebookController.mostPopularFriend.userId;
    NSString *popularFriendName = _facebookController.mostPopularFriend.name;
    int friendsNumber = _facebookController.mostPopularFriend.friendsNumber;
    
    if([self isUniqueUserAlreadySaved:popularFriendUserId on:MOST_POPULAR_FRIEND_TABLE_NAME])
    {
        return;
    }
    
    NSString *requestParams = [NSString stringWithFormat:@"%@ TEXT, %@ TEXT, %@ TEXT", USER_NAME, FRIENDS_NUMBER, USER_ID];
    
    [_databaseController createTable:MOST_POPULAR_FRIEND_TABLE_NAME andParams:requestParams];
    
    NSMutableDictionary *toSave = [[NSMutableDictionary alloc] init];
    [toSave setObject:popularFriendUserId forKey:USER_ID];
	[toSave setObject:popularFriendName forKey:USER_NAME];
	[toSave setObject:[NSString stringWithFormat:@"%d", friendsNumber] forKey:FRIENDS_NUMBER];
    
    [_databaseController insertIntoTable:MOST_POPULAR_FRIEND_TABLE_NAME theseRowsAndValues:toSave];
}

-(BOOL)isUniqueUserAlreadySaved:(NSString *)valueToCheck on:(NSString *)tableName
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
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
        [userData setObject:(NSString *)[resultUserIds objectAtIndex:0] forKey:USER_ID];
        [userData setObject:bestFriendName forKey:USER_NAME];
        [userData setObject:(NSString *)[resultMutualFriendsNumbers objectAtIndex:0] forKey:MUTUAL_FRIENDS_NUMBER];
        
        [_facebookController setBestFriendFromData:userData];
    }
    
    return bestFriendName;
}

-(NSString *) getMostPopularFriend
{
    NSMutableArray *resultNames = [_databaseController getRow:USER_NAME fromTable:MOST_POPULAR_FRIEND_TABLE_NAME];
    
    NSString *mostPopularFriendName = @"";
    
    if([resultNames count] > 0)
    {
        mostPopularFriendName = (NSString *)[resultNames objectAtIndex:0];
    }
    
    if(![mostPopularFriendName isEqualToString:@""])
    {
        NSMutableArray *resultUserIds = [_databaseController getRow:USER_ID fromTable:MOST_POPULAR_FRIEND_TABLE_NAME];
        NSMutableArray *resultFriendsNumbers = [_databaseController getRow:FRIENDS_NUMBER fromTable:MOST_POPULAR_FRIEND_TABLE_NAME];
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
        [userData setObject:(NSString *)[resultUserIds objectAtIndex:0] forKey:USER_ID];
        [userData setObject:mostPopularFriendName forKey:USER_NAME];
        [userData setObject:(NSString *)[resultFriendsNumbers objectAtIndex:0] forKey:FRIENDS_NUMBER];
        
        [_facebookController setMostPopularFriendFromData:userData];
    }
    
    return mostPopularFriendName;
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
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
        [userData setObject:(NSString *)[resultUserIds objectAtIndex:0] forKey:USER_ID];
        [userData setObject:userName forKey:USER_NAME];
        
        [_facebookController setUserFromData:userData];
    }
    
    return userName;
}

@end
