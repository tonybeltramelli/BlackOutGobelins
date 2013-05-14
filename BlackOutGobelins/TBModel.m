//
//  TBModel.m
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 12/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBModel.h"

@implementation TBModel
{
    TBDatabaseController *_databaseController;
}

static TBModel* _instance = nil;

@synthesize isRetinaDisplay = _isRetinaDisplay;
@synthesize appDelegate = _appDelegate;
@synthesize facebookController = _facebookController;

+(TBModel*)getInstance
{
	@synchronized([TBModel class])
	{
		if (!_instance) [[self alloc] init];
		return _instance;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([TBModel class])
	{
		NSAssert(_instance == nil, @"Attempted to allocate a second instance of a singleton.");
		_instance = [super alloc];
		return _instance;
	}
    
	return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _facebookController = [[TBFacebookController alloc] init];
        _isRetinaDisplay = [self isRetinaDisplayHandler];
        _databaseController = [[TBDatabaseController alloc] init];
    }
    return self;
}

- (BOOL)isRetinaDisplayHandler
{
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        return [[UIScreen mainScreen] scale] == 2.0 ? YES : NO;
    }
    
    return NO;
}

-(void) saveBestFriend
{
    NSString *userId = _facebookController.bestFriend.userId;
    NSString *friendName = _facebookController.bestFriend.name;
    int mutualFriendsNumber = _facebookController.bestFriend.mutualFriendsNumber;
    
    NSMutableArray *result = [_databaseController getRow:@"USER_ID" fromTable:@"FACEBOOK"];
    
    if([result count] > 1)
    {
        [_databaseController dropTable:@"FACEBOOK"];
    }else if([result count] == 1 && [(NSString *)[result objectAtIndex:0] isEqualToString:userId])
    {
        return;
    }
    
    [_databaseController createTable:@"FACEBOOK" andParams:@"BESTFRIEND_NAME TEXT, MUTUAL_FRIENDS_NUMBER TEXT, USER_ID TEXT"];
    
    NSMutableDictionary *toSave = [[NSMutableDictionary alloc] init];
    [toSave setObject:userId forKey:@"USER_ID"];
	[toSave setObject:friendName forKey:@"BESTFRIEND_NAME"];
	[toSave setObject:[NSString stringWithFormat:@"%d", mutualFriendsNumber] forKey:@"MUTUAL_FRIENDS_NUMBER"];
    
    [_databaseController insertIntoTable:@"FACEBOOK" theseRowsAndValues:toSave];
}

-(NSString *) getBestFriend
{
    NSMutableArray *resultNames = [_databaseController getRow:@"BESTFRIEND_NAME" fromTable:@"FACEBOOK"];
    
    NSString *bestFriendName = @"";
    
    if([resultNames count] > 0)
    {
        bestFriendName = (NSString *)[resultNames objectAtIndex:0];
    }
    
    if(![bestFriendName isEqualToString:@""])
    {
        NSMutableArray *resultUserIds = [_databaseController getRow:@"USER_ID" fromTable:@"FACEBOOK"];
        NSMutableArray *resultMutualFriendsNumbers = [_databaseController getRow:@"MUTUAL_FRIENDS_NUMBER" fromTable:@"FACEBOOK"];
        
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
        [userData setObject:(NSString *)[resultUserIds objectAtIndex:0] forKey:@"USER_ID"];
        [userData setObject:bestFriendName forKey:@"BESTFRIEND_NAME"];
        [userData setObject:(NSString *)[resultMutualFriendsNumbers objectAtIndex:0] forKey:@"MUTUAL_FRIENDS_NUMBER"];
        
        [_facebookController createNewBestFriend:userData];
    }
    
    return bestFriendName;
}

@end
