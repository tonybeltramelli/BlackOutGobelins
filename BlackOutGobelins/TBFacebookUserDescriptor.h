//
//  TBFacebookUserDescriptor.h
//  BlackOutGobelins
//
//  Created by Tony Beltramelli on 15/05/13.
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
@property(nonatomic, assign) NSString *location;
@property(nonatomic, assign) NSString *locationPictureUrl;
@property(nonatomic, assign) NSString *companyName;
@property(nonatomic, assign) NSString *companyPictureUrl;
@property(nonatomic, assign) NSString *positionName;
@property(nonatomic, assign) NSString *schoolName;
@property(nonatomic, assign) NSString *schoolPictureUrl;
@property(nonatomic, assign) NSString *age;

-(id)initWithGraphUser:(NSDictionary<FBGraphUser> *)graphUser;
-(id)initWithDictionnary:(NSDictionary *)userData;

-(void)loadExtraData;

@end
