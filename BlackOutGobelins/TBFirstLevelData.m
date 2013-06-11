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
        
        _scoreIncrement = 1.0f / 12;
        
        _botNumberRelated = (float *)malloc(4 * sizeof(float));
        
        _botNumberRelated[0] = 1;
        _botNumberRelated[1] = 2;
        _botNumberRelated[2] = 4;
        _botNumberRelated[3] = 5;
        
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
    [_characterData addObject:[TBCharacterData dataWithDescriptor: [[TBModel getInstance] facebookController].bestFriend andDialog:NSLocalizedString(@"CHARACTER_DIALOGUE_BESTFRIEND", nil)]];
    [_characterData addObject:[TBCharacterData dataWithDescriptor: [[TBModel getInstance] facebookController].friendOnPicture andDialog:NSLocalizedString(@"CHARACTER_DIALOGUE_FRIEND_ON_PICTURE", nil)]];
    [_characterData addObject:[TBCharacterData dataWithDescriptor: [[TBModel getInstance] facebookController].bestFriend andDialog:NSLocalizedString(@"CHARACTER_DIALOGUE_BESTFRIEND", nil)]];
    [_characterData addObject:[TBCharacterData dataWithDescriptor: [[TBModel getInstance] facebookController].friendOnPicture andDialog:NSLocalizedString(@"CHARACTER_DIALOGUE_FRIEND_ON_PICTURE", nil)]];
}

-(void)generateBotsData
{
    _botsData = [[NSMutableArray alloc] init];
    
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.user.name] andType:NSLocalizedString(@"DATA_TYPE_USER_NAME", nil)]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.user.location] andType:NSLocalizedString(@"DATA_TYPE_LOCATION", nil)]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.bestFriend.name] andType:@"Best friend name"]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.friendOnPicture.name] andType:@"Great buddy name"]];
    [_botsData addObject:[TBBotData dataWithValue:@"" andType:@"Friend name"]];
    [_botsData addObject:[TBBotData dataWithValue:@"" andType:@"Friend name"]];
    [_botsData addObject:[TBBotData dataWithValue:@"" andType:@"Friend name"]];
    [_botsData addObject:[TBBotData dataWithValue:@"" andType:@"Friend name"]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.user.name] andType:@"Facebook user name"]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.user.name] andType:@"Facebook user name"]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.user.name] andType:@"Facebook user name"]];
    [_botsData addObject:[TBBotData dataWithValue:[self getDataFrom:[TBModel getInstance].facebookController.user.name] andType:@"Facebook user name"]];
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
