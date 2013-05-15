//
//  TBFacebookUserDescriptor.m
//  BlackOutGobelins
//
//  Created by tony's computer on 15/05/13.
//
//

#import "TBFacebookUserDescriptor.h"

@implementation TBFacebookUserDescriptor

- (id)initWithGraphUser:(NSDictionary<FBGraphUser> *)graphUser
{
    self = [super init];
    if (self) {
        _graphUser = [graphUser retain];
        
        _userId = _graphUser.id;
        _name = _graphUser.name;
    }
    return self;
}

-(id)initWithDictionnary:(NSDictionary *)userData
{
    self = [super init];
    if (self) {
        _userId = [userData objectForKey:@"USER_ID"];
        _name = [userData objectForKey:@"USER_NAME"];
    }
    return self;
}


@end
