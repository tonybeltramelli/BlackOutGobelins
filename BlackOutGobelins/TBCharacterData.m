//
//  TBCharacterData.m
//  BlackOutGobelins
//
//  Created by tony's computer on 29/05/13.
//
//

#import "TBCharacterData.h"
#import "TBFacebookDataManager.h"

@implementation TBCharacterData
{
    TBFacebookFriendDescriptor *_descriptor;
    NSString *_dialog;
}

- (id)initWithDescriptor:(TBFacebookFriendDescriptor *)descriptor andDialog:(NSString *)dialog
{
    self = [super init];
    if (self) {
        _descriptor = descriptor;
        
        if(!_descriptor)
        {
            NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
            [userData setObject:@"0" forKey:@"USER_ID"];
            [userData setObject:@"Fake name" forKey:@"USER_NAME"];
            [userData setObject:@"0" forKey:@"MUTUAL_FRIENDS_NUMBER"];
            [userData setObject:@"0" forKey:@"PROFILE_PICTURE_URL"];
            
            _descriptor = [[TBFacebookFriendDescriptor alloc] initWithDictionnary:userData];
        }
        
        _dialog = dialog;
    }
    return self;
}

-(TBFacebookFriendDescriptor *)getDescriptor
{
    return _descriptor;
}

-(NSString *)getDialog
{
    return _dialog;
}

@end
