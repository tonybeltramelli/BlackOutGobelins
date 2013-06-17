
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
NSString *USER_LOCATION = @"USER_LOCATION";
NSString *LOCATION_PICTURE_URL = @"LOCATION_PICTURE_URL";
NSString *COMPANY_NAME = @"COMPANY_NAME";
NSString *COMPANY_PICTURE_URL = @"COMPANY_PICTURE_URL";
NSString *POSITION_NAME = @"POSITION_NAME";
NSString *SCHOOL_NAME = @"SCHOOL_NAME";
NSString *SCHOOL_PICTURE_URL = @"SCHOOL_PICTURE_URL";
NSString *AGE = @"AGE";
NSString *BIO = @"BIO";
NSString *IS_DOOR_OPEN = @"IS_DOOR_OPEN";

//bestfriend
NSString *BESTFRIEND_TABLE_NAME = @"BESTFRIEND";

//friend on picture
NSString *FRIEND_ON_PICTURE_TABLE_NAME = @"FRIEND_ON_PICTURE";
NSString *PICTURE_URL = @"PICTURE_URL";

//common rows
NSString *USER_ID = @"USER_ID";
NSString *USER_NAME = @"USER_NAME";
NSString *PROFILE_PICTURE_URL = @"PROFILE_PICTURE_URL";
NSString *MUTUAL_FRIENDS_NUMBER = @"MUTUAL_FRIENDS_NUMBER";

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

-(NSString *)getData:(NSString *)data
{ 
    if([data isEqualToString:@""] || data == nil || [data isEqualToString:@"(null)"] || [data isEqualToString:@"null"] || data == NULL)
    {
        return NSLocalizedString(@"PROTECTED", nil);
    }else{
        return data;
    }
}

-(NSString *)getPictureUrl:(NSString *)url
{
    if([url isEqualToString:@""] || url == nil)
    {
        return @"default_facebook_profile_picture.jpg";
    }else{
        return url;
    }
}

-(void) saveUser
{
    NSString *userId = _facebookController.user.userId;
    NSString *userName = _facebookController.user.name;
    NSString *userProfilePictureUrl = _facebookController.user.profilePictureUrl;
    NSString *userLocation = _facebookController.user.location;
    NSString *locationPictureUrl = _facebookController.user.locationPictureUrl;
    NSString *companyName = _facebookController.user.companyName;
    NSString *companyPictureUrl = _facebookController.user.companyPictureUrl;
    NSString *positionName = _facebookController.user.positionName;
    NSString *schoolName = _facebookController.user.schoolName;
    NSString *schoolPictureUrl = _facebookController.user.schoolPictureUrl;
    int age = _facebookController.user.age;
    NSString *bio = _facebookController.user.bio;
    BOOL isDoorOpen = _facebookController.user.isDoorOpen;
    
    [self cleanIfDataAlreadySaved:userId on:USER_TABLE_NAME];
    
    NSString *requestParams = [NSString stringWithFormat:@"%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT", USER_NAME, PROFILE_PICTURE_URL, USER_LOCATION, LOCATION_PICTURE_URL, COMPANY_NAME, COMPANY_PICTURE_URL, POSITION_NAME, SCHOOL_NAME, SCHOOL_PICTURE_URL, AGE, BIO, IS_DOOR_OPEN, USER_ID];
    
    [_databaseController createTable:USER_TABLE_NAME andParams:requestParams];
    
    NSMutableDictionary *toSave = [[NSMutableDictionary alloc] init];
    [toSave setObject:userId forKey:USER_ID];
	[toSave setObject:userName forKey:USER_NAME];
    [toSave setObject:[self getPictureUrl:userProfilePictureUrl] forKey:PROFILE_PICTURE_URL];
    [toSave setObject:[self getData:userLocation] forKey:USER_LOCATION];
    [toSave setObject:[self getData:locationPictureUrl] forKey:LOCATION_PICTURE_URL];
    [toSave setObject:[self getData:companyName] forKey:COMPANY_NAME];
    [toSave setObject:[self getData:companyPictureUrl] forKey:COMPANY_PICTURE_URL];
    [toSave setObject:[self getData:positionName] forKey:POSITION_NAME];
    [toSave setObject:[self getData:schoolName] forKey:SCHOOL_NAME];
    [toSave setObject:[self getData:schoolPictureUrl] forKey:SCHOOL_PICTURE_URL];
    [toSave setObject:[self getData:[NSString stringWithFormat:@"%d", age]] forKey:AGE];
    [toSave setObject:[self getData:bio] forKey:BIO];
    [toSave setObject:isDoorOpen ? @"TRUE" : @"FALSE" forKey:IS_DOOR_OPEN];
    
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
    [toSave setObject:[self getPictureUrl:bestfriendProfilePictureUrl] forKey:PROFILE_PICTURE_URL];
	[toSave setObject:[NSString stringWithFormat:@"%d", mutualFriendsNumber] forKey:MUTUAL_FRIENDS_NUMBER];
    
    [_databaseController insertIntoTable:BESTFRIEND_TABLE_NAME theseRowsAndValues:toSave];
}

-(void) saveFriendOnPicture
{    
    NSString *friendOnPictureUserId = _facebookController.friendOnPicture.userId;
    NSString *friendOnPictureName = _facebookController.friendOnPicture.name;
    NSString *friendProfilePictureUrl = _facebookController.friendOnPicture.profilePictureUrl;
    NSString *friendPictureUrl = _facebookController.friendOnPicture.pictureUrl;
    int mutualFriendsNumber = _facebookController.friendOnPicture.mutualFriendsNumber;
    
    [self cleanIfDataAlreadySaved:friendOnPictureUserId on:FRIEND_ON_PICTURE_TABLE_NAME];
    
    NSString *requestParams = [NSString stringWithFormat:@"%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT", USER_NAME, PROFILE_PICTURE_URL, PICTURE_URL, MUTUAL_FRIENDS_NUMBER, USER_ID];
    
    [_databaseController createTable:FRIEND_ON_PICTURE_TABLE_NAME andParams:requestParams];
    
    NSMutableDictionary *toSave = [[NSMutableDictionary alloc] init];
    [toSave setObject:friendOnPictureUserId forKey:USER_ID];
	[toSave setObject:friendOnPictureName forKey:USER_NAME];
    [toSave setObject:[self getPictureUrl:friendProfilePictureUrl] forKey:PROFILE_PICTURE_URL];
    [toSave setObject:[self getPictureUrl:friendPictureUrl] forKey:PICTURE_URL];
    [toSave setObject:[NSString stringWithFormat:@"%d", mutualFriendsNumber] forKey:MUTUAL_FRIENDS_NUMBER];
    
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
        int mutualFriendsNumber = parsedFriend.mutualFriendsNumber;
        
        NSString *requestParams = [NSString stringWithFormat:@"%@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT", USER_NAME, PROFILE_PICTURE_URL, MUTUAL_FRIENDS_NUMBER, USER_ID];
        
        [_databaseController createTable:SOME_FRIENDS_TABLE_NAME andParams:requestParams];
        
        NSMutableDictionary *toSave = [[NSMutableDictionary alloc] init];
        [toSave setObject:userId forKey:USER_ID];
        [toSave setObject:userName forKey:USER_NAME];
        [toSave setObject:[self getPictureUrl:userProfilePictureUrl] forKey:PROFILE_PICTURE_URL];
        [toSave setObject:[NSString stringWithFormat:@"%d", mutualFriendsNumber] forKey:MUTUAL_FRIENDS_NUMBER];
        
        [_databaseController insertIntoTable:SOME_FRIENDS_TABLE_NAME theseRowsAndValues:toSave];
    }
}

-(BOOL)cleanIfDataAlreadySaved:(NSString *)valueToCheck on:(NSString *)tableName
{
    NSMutableArray *result = [_databaseController getRow:USER_ID fromTable:tableName];
    
    BOOL boo;
    
    if([result count] >= 1)
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
    [_facebookController setUserFromGraph:user];
    
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
        NSMutableArray *resultMutualFriendNumber = [_databaseController getRow:MUTUAL_FRIENDS_NUMBER fromTable:FRIEND_ON_PICTURE_TABLE_NAME];
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
        [userData setObject:(NSString *)[resultUserIds objectAtIndex:0] forKey:USER_ID];
        [userData setObject:friendOnPictureName forKey:USER_NAME];
        [userData setObject:(NSString *)[resultProfilePicture objectAtIndex:0] forKey:PROFILE_PICTURE_URL];
        [userData setObject:(NSString *)[resultPicture objectAtIndex:0] forKey:PICTURE_URL];
        [userData setObject:(NSString *)[resultMutualFriendNumber objectAtIndex:0] forKey:MUTUAL_FRIENDS_NUMBER];
        
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
        NSMutableArray *resultLocation = [_databaseController getRow:USER_LOCATION fromTable:USER_TABLE_NAME];
        NSMutableArray *resultLocationPictureUrl = [_databaseController getRow:LOCATION_PICTURE_URL fromTable:USER_TABLE_NAME];
        NSMutableArray *resultCompanyName = [_databaseController getRow:COMPANY_NAME fromTable:USER_TABLE_NAME];
        NSMutableArray *resultCompanyPictureUrl = [_databaseController getRow:COMPANY_PICTURE_URL fromTable:USER_TABLE_NAME];
        NSMutableArray *resultPositionName = [_databaseController getRow:POSITION_NAME fromTable:USER_TABLE_NAME];
        NSMutableArray *resultSchoolName = [_databaseController getRow:SCHOOL_NAME fromTable:USER_TABLE_NAME];
        NSMutableArray *resultSchoolPictureUrl = [_databaseController getRow:SCHOOL_PICTURE_URL fromTable:USER_TABLE_NAME];
        NSMutableArray *resultAge = [_databaseController getRow:AGE fromTable:USER_TABLE_NAME];
        NSMutableArray *resultBio = [_databaseController getRow:BIO fromTable:USER_TABLE_NAME];
        NSMutableArray *resultIsDoorOpen = [_databaseController getRow:IS_DOOR_OPEN fromTable:USER_TABLE_NAME];
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
        [userData setObject:(NSString *)[resultUserIds objectAtIndex:0] forKey:USER_ID];
        [userData setObject:userName forKey:USER_NAME];
        [userData setObject:(NSString *)[resultProfilePicture objectAtIndex:0] forKey:PROFILE_PICTURE_URL];
        [userData setObject:(NSString *)[resultLocation objectAtIndex:0] forKey:USER_LOCATION];
        [userData setObject:(NSString *)[resultLocationPictureUrl objectAtIndex:0] forKey:LOCATION_PICTURE_URL];
        [userData setObject:(NSString *)[resultCompanyName objectAtIndex:0] forKey:COMPANY_NAME];
        [userData setObject:(NSString *)[resultCompanyPictureUrl objectAtIndex:0] forKey:COMPANY_PICTURE_URL];
        [userData setObject:(NSString *)[resultPositionName objectAtIndex:0] forKey:POSITION_NAME];
        [userData setObject:(NSString *)[resultSchoolName objectAtIndex:0] forKey:SCHOOL_NAME];
        [userData setObject:(NSString *)[resultSchoolPictureUrl objectAtIndex:0] forKey:SCHOOL_PICTURE_URL];
        [userData setObject:(NSString *)[resultAge objectAtIndex:0] forKey:AGE];
        [userData setObject:(NSString *)[resultBio objectAtIndex:0] forKey:BIO];
        [userData setObject:(NSString *)[resultIsDoorOpen objectAtIndex:0] forKey:IS_DOOR_OPEN];
        
        [_facebookController setUserFromData:userData];
    }
    
    return userName;
}

-(NSMutableArray *) getSomeFriends
{
    NSMutableArray *resultNames = [_databaseController getRow:USER_NAME fromTable:SOME_FRIENDS_TABLE_NAME];
    NSMutableArray *resultUserIds = [_databaseController getRow:USER_ID fromTable:SOME_FRIENDS_TABLE_NAME];
    NSMutableArray *resultProfilePicture = [_databaseController getRow:PROFILE_PICTURE_URL fromTable:SOME_FRIENDS_TABLE_NAME];
    NSMutableArray *resultMutualFriendNumber = [_databaseController getRow:MUTUAL_FRIENDS_NUMBER fromTable:SOME_FRIENDS_TABLE_NAME];
    NSMutableArray *result = [NSMutableArray array];
    
    int i = 0;
    int length = [resultNames count];
        
    for(i = 0; i < length; i ++)
    {
        NSMutableDictionary *friendData = [[NSMutableDictionary alloc] init];
        [friendData setObject:(NSString *)[resultUserIds objectAtIndex:i] forKey:USER_ID];
        [friendData setObject:(NSString *)[resultNames objectAtIndex:i] forKey:USER_NAME];
        [friendData setObject:(NSString *)[resultProfilePicture objectAtIndex:i] forKey:PROFILE_PICTURE_URL];
        [friendData setObject:(NSString *)[resultMutualFriendNumber objectAtIndex:i] forKey:MUTUAL_FRIENDS_NUMBER];
        
        [result addObject:friendData];
    }
    
    [_facebookController setSomeFriendsFromData:result];
    
    return resultNames;
}

-(void)dropBase
{
    [_databaseController dropTable:USER_TABLE_NAME];
    [_databaseController dropTable:BESTFRIEND_TABLE_NAME];
    [_databaseController dropTable:FRIEND_ON_PICTURE_TABLE_NAME];
    [_databaseController dropTable:SOME_FRIENDS_TABLE_NAME];
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
