//
//  TBFacebookUserDescriptor.h
//  BlackOutGobelins
//
//  Created by tony's computer on 15/05/13.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface TBFacebookUserDescriptor : NSObject
{
    NSDictionary<FBGraphUser> *_graphUser;
}

@property(nonatomic, assign) NSString *userId;
@property(nonatomic, assign) NSString *name;
@property(nonatomic, assign) NSString *profilePictureUrl;

-(id)initWithGraphUser:(NSDictionary<FBGraphUser> *)graphUser;
-(id)initWithDictionnary:(NSDictionary *)userData;

-(void)loadProfilePicture;
-(NSData *)getProfilePicture;

@end
