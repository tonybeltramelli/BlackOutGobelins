//
//  TBFacebookDataManager.h
//  BlackOutGobelins
//
//  Created by tony's computer on 15/05/13.
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

-(void)setUserFromGraph:(NSDictionary<FBGraphUser> *)user;

@end
