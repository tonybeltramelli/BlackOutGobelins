//
//  TBCharacterFirstState.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 15/05/13.
//
//

#import "TBCharacterFirstState.h"
#import "TBCharacterNamePopin.h"
#import "TBModel.h"
#import "TBCharacterData.h"
#import "SimpleAudioEngine.h"

@implementation TBCharacterFirstState
{
    TBCharacterNamePopin *_gamePopin;
    TBCharacterData *_data;
}

- (id)init
{
    self = [super init];
    if (self) {        
        _frontFace = [[TBCharacterFace alloc] initWithNumFrame:36 withAnimName:@"face" andFilePrefix:@"friend_first_state_"];
        
        _gravityCenter = CGPointMake(4, 0);
    }
    return self;
}

-(void) getDataAt:(int)index
{
    _data = [[[[TBModel getInstance] getCurrentLevelData] getCharactersData] objectAtIndex:index];
    
    _gamePopin = [[TBCharacterNamePopin alloc] initWithName:[_data getDescriptor].name similarFriendNumber:[_data getDescriptor].mutualFriendsNumber andPictureUrl:[_data getDescriptor].profilePictureUrl];
    
    [self addChild:_gamePopin];
}

-(void) connectionOnRange:(BOOL)isOnRange
{
    if(isOnRange)
    {
        if(!_isOnRange)
        {
            [_gamePopin show];
            [[SimpleAudioEngine sharedEngine] playEffect:@"EGo-Connectacle.mp3"];
        }
    }else{
        if(_isOnRange) [_gamePopin hide];
    }
    
    [_gamePopin setPosition:CGPointMake(CGPointZero.x, [self getSize].height * 0.75f)];
    
    [super connectionOnRange:isOnRange];
}

-(void) handleConnection:(BOOL)toConnect
{
    [super handleConnection:toConnect];
    
    if(toConnect) [[SimpleAudioEngine sharedEngine] playEffect:@"Connexion-EGo.mp3"];
}

-(NSString *)getDialogueContent
{
    return [_data getDialog];
}

- (void)dealloc
{
    [self removeChild:_gamePopin cleanup:TRUE];
    
    [_gamePopin release];
    _gamePopin = nil;
    
    [_data release];
    _data = nil;
    
    [super dealloc];
}

@end
