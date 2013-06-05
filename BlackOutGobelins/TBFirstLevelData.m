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

@implementation TBFirstLevelData
{
    NSMutableArray *_characterData;
    int _currentObstacleNumber;
    int _totalObstacleNumber;
    float *_obstableScoreRelated;
    
    float _score;
    float _scoreIncrement;
}

- (id)initWithBotNumber:(int)botNumber
{
    self = [super init];
    if (self) {
        _currentObstacleNumber = 0;
        
        _scoreIncrement = 1.0f / botNumber;
        
        _obstableScoreRelated = (float *)malloc(4 * sizeof(float));
        
        _obstableScoreRelated[0] = _scoreIncrement;
        _obstableScoreRelated[1] = _obstableScoreRelated[0] + _scoreIncrement * 2;
        _obstableScoreRelated[2] = _obstableScoreRelated[1] + _scoreIncrement * 4;
        _obstableScoreRelated[3] = _obstableScoreRelated[2] + _scoreIncrement * 5;
        
        _score = 0.0f;
    }
    return self;
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

- (void)dealloc
{
    [_characterData release];
    _characterData = nil;
    
    [super dealloc];
}

@end
