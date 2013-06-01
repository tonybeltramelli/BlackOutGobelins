//
//  TBFacebookDataManager.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 15/05/13.
//
//

#import <Foundation/Foundation.h>

#import "TBFacebookController.h"
#import "TBDatabaseController.h"

@interface TBFacebookDataManager : NSObject

- (id)initWithControllers:(TBFacebookController *)facebookController and:(TBDatabaseController *)databaseController;

-(void) saveBestFriend;
-(NSString *) getBestFriend;

-(void) saveFriendOnPicture;
-(NSString *) getFriendOnPicture;

-(void) saveUser;
-(NSString *) getUser;

-(void) saveSomeFriends;
-(NSMutableArray *) getSomeFriends;

-(void)setUserFromGraph:(NSDictionary<FBGraphUser> *)user;

@end
