//
//  TBCharacterData.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 29/05/13.
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
            NSMutableDictionary *userData = [NSMutableDictionary dictionary];
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

+ (id)dataWithDescriptor:(TBFacebookFriendDescriptor *)descriptor andDialog:(NSString *)dialog
{
    return [[[self alloc] initWithDescriptor:descriptor andDialog:dialog] autorelease];
}

-(TBFacebookFriendDescriptor *)getDescriptor
{
    return _descriptor;
}

-(NSString *)getDialog
{
    return _dialog;
}

- (void)dealloc
{
    [_descriptor release];
    _descriptor = nil;
    
    _dialog = nil;
    
    [super dealloc];
}

@end
