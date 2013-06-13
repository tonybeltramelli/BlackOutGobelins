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
    NSString *_dialogue;
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
    TBCharacterData *data = [[[[TBModel getInstance] getCurrentLevelData] getCharactersData] objectAtIndex:index];
    
    _gamePopin = [[TBCharacterNamePopin alloc] initWithName:[data getDescriptor].name similarFriendNumber:[data getDescriptor].mutualFriendsNumber andPictureUrl:[data getDescriptor].profilePictureUrl];
    
    _dialogue = [data getDialog];
    
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

-(NSString *)getDialogue
{
    return _dialogue;
}

- (void)dealloc
{
    [self removeChild:_gamePopin cleanup:TRUE];
    
    [_gamePopin release];
    _gamePopin = nil;
    
    [super dealloc];
}

@end
