//
//  TBFirstLevelData.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 27/05/13.
//
//

#import "TBFirstLevelData.h"
#import "TBModel.h"
#import "TBCharacterData.h"
#import "TBCharacter.h"
#import "TBBotData.h"

@implementation TBFirstLevelData
{
    NSMutableArray *_characterData;
    NSMutableArray *_botsData;
    int _currentObstacleNumber;
    int _totalObstacleNumber;
    float *_obstableScoreRelated;
    float *_botNumberRelated;
    
    float _score;
    float _scoreIncrement;
}

- (id)init
{
    self = [super init];
    if (self) {
        _currentObstacleNumber = 0;
        
        _scoreIncrement = 1.0f / 10;
        
        _botNumberRelated = (float *)malloc(4 * sizeof(float));
        
        _botNumberRelated[0] = 1;
        _botNumberRelated[1] = 2;
        _botNumberRelated[2] = 3;
        _botNumberRelated[3] = 4;
        
        _obstableScoreRelated = (float *)malloc(4 * sizeof(float));
        
        _obstableScoreRelated[0] = _scoreIncrement * _botNumberRelated[0];
        _obstableScoreRelated[1] = _obstableScoreRelated[0] + _scoreIncrement * _botNumberRelated[1];
        _obstableScoreRelated[2] = _obstableScoreRelated[1] + _scoreIncrement * _botNumberRelated[2];
        _obstableScoreRelated[3] = _obstableScoreRelated[2] + _scoreIncrement * _botNumberRelated[3];
        
        _score = 0.0f;
    }
    return self;
}

-(void)generateCharactersData
{
    _characterData = [[NSMutableArray alloc] init];
    
    [_characterData addObject:[TBCharacterData dataWithDescriptor: [[TBModel getInstance] facebookController].friendOnPicture andDialog:NSLocalizedString(@"CHARACTER_DIALOGUE_FRIEND_ON_PICTURE", nil)]];
    [_characterData addObject:[TBCharacterData dataWithDescriptor: [[TBModel getInstance] facebookController].bestFriend andDialog:NSLocalizedString(@"CHARACTER_DIALOGUE_BESTFRIEND", nil)]];
    [_characterData addObject:[TBCharacterData dataWithDescriptor: (TBFacebookFriendDescriptor*)[[[TBModel getInstance] facebookController].someFriends objectAtIndex:0] andDialog:[self getDialogueAge]]];
    [_characterData addObject:[TBCharacterData dataWithDescriptor: (TBFacebookFriendDescriptor*)[[[TBModel getInstance] facebookController].someFriends objectAtIndex:1] andDialog:[self getDialogueCity]]];
    [_characterData addObject:[TBCharacterData dataWithDescriptor: (TBFacebookFriendDescriptor*)[[[TBModel getInstance] facebookController].someFriends objectAtIndex:2] andDialog:NSLocalizedString(@"LOVE_SITUATION", nil)]];
    [_characterData addObject:[TBCharacterData dataWithDescriptor: (TBFacebookFriendDescriptor*)[[[TBModel getInstance] facebookController].someFriends objectAtIndex:3] andDialog:NSLocalizedString(@"ENIGMA", nil)]];
}

-(NSString *)getDialogueAge
{
    NSString *stringName = @"AGE_40_PLUS";
    
    if([TBModel getInstance].facebookController.user.age <= 20)
    {
        stringName = @"AGE_20";
    }else if([TBModel getInstance].facebookController.user.age > 20 && [TBModel getInstance].facebookController.user.age <= 25)
    {
        stringName = @"AGE_25";
    }else if([TBModel getInstance].facebookController.user.age > 25 && [TBModel getInstance].facebookController.user.age <= 30)
    {
        stringName = @"AGE_30";
    }else if([TBModel getInstance].facebookController.user.age > 30 && [TBModel getInstance].facebookController.user.age <= 40)
    {
        stringName = @"AGE_40";
    }
    
    return NSLocalizedString(stringName, nil);
}

-(NSString *)getDialogueCity
{
    int n = 1; //(arc4random() % 2) + 1;
    
    NSString *cityText = [NSString stringWithFormat:@"CITY_%d", n];
    NSString *rawString = NSLocalizedString(cityText, nil);
    
    return [[rawString stringByReplacingOccurrencesOfString:@"{cityname}" withString:[TBModel getInstance].facebookController.user.location] retain];
}

-(void)generateBotsData
{
    _botsData = [[NSMutableArray alloc] init];
    
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.user.name] andType:NSLocalizedString(@"DATA_TYPE_USER_NAME", nil)]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.user.location] andType:NSLocalizedString(@"DATA_TYPE_LOCATION", nil)]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.bestFriend.name] andType:NSLocalizedString(@"BEST_FRIEND_NAME", nil)]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.friendOnPicture.name] andType:NSLocalizedString(@"GREAT_BUDDY_NAME", nil)]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.user.profilePictureUrl] andType:@"image"]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.user.positionName] andType:NSLocalizedString(@"JOB_POSITION", nil)]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.user.schoolName] andType:NSLocalizedString(@"EDUCATION", nil)]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.friendOnPicture.pictureUrl] andType:@"image"]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.user.companyName] andType:NSLocalizedString(@"COMPANY_NAME", nil)]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:((TBFacebookUserDescriptor *)[[TBModel getInstance].facebookController.someFriends objectAtIndex:0]).name] andType:NSLocalizedString(@"A_FRIEND_NAME", nil)]];
}

-(NSString *)getDataFrom:(id)pointer
{
    if(pointer)
    {
        return pointer;
    }
    
    return @"Data protected";
}

-(NSMutableArray *)getCharactersData
{
    if(!_characterData) [self generateCharactersData];
    
    return _characterData;
}

-(NSMutableArray *)getBotsData
{
    if(!_botsData) [self generateBotsData];
    
    return _botsData;
}

-(BOOL)isObstacleDestroyable
{
    float value = _score - _obstableScoreRelated[_currentObstacleNumber];
    if(value < 0.0001f && value > -0.0001f)
    {
        _currentObstacleNumber ++;
        return TRUE;
    }else{
        return FALSE;
    }
}

-(void)incrementScore
{
    _score += _scoreIncrement;
}

-(float)getScore
{
    return _score;
}

-(float *)getBotNumberRelated
{
    return _botNumberRelated;
}

-(int)getCurrentObstacleNumber
{
    return _currentObstacleNumber;
}

- (void)dealloc
{
    [_characterData release];
    _characterData = nil;
    
    [super dealloc];
}

@end
