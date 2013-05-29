//
//  TBFirstLevelData.m
//  BlackOutGobelins
//
//  Created by tony's computer on 27/05/13.
//
//

#import "TBFirstLevelData.h"
#import "TBModel.h"
#import "TBCharacterData.h"
#import "TBCharacter.h"

@implementation TBFirstLevelData
{
    NSMutableArray *_characterData;
}

-(void)generateCharactersData
{
    _characterData = [[NSMutableArray alloc] init];
    
    TBCharacterData *dataBestFriend = [[TBCharacterData alloc] initWithDescriptor: [[TBModel getInstance] facebookController].bestFriend andDialog:NSLocalizedString(@"CHARACTER_DIALOGUE_BESTFRIEND", nil)];
    [_characterData addObject:dataBestFriend];
    
    TBCharacterData *dataFriendOnPicture = [[TBCharacterData alloc] initWithDescriptor: [[TBModel getInstance] facebookController].friendOnPicture andDialog:NSLocalizedString(@"CHARACTER_DIALOGUE_FRIEND_ON_PICTURE", nil)];
    [_characterData addObject:dataFriendOnPicture];
}

-(NSString *)getUserName
{
    if([self isUserAvailable])
    {
        return [TBModel getInstance].facebookController.user.name;
    }
    
    return @"This is a fake name";
}

-(NSString *)getUserNameDataType
{
    return @"Facebook user name";
}

-(BOOL)isUserAvailable
{
    return [TBModel getInstance].facebookController.user != nil;
}

-(NSMutableArray *)getCharactersData
{
    if(!_characterData) [self generateCharactersData];
    
    return _characterData;
}

@end
