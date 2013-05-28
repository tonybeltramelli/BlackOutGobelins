//
//  TBCharacterFirstState.m
//  BlackOutGobelins
//
//  Created by tony's computer on 15/05/13.
//
//

#import "TBCharacterFirstState.h"
#import "TBCharacterNamePopin.h"
#import "TBModel.h"

@implementation TBCharacterFirstState
{
    TBCharacterNamePopin *_gamePopin;
    NSString *_dialogue;
}

- (id)init
{
    self = [super initWithPrefix:@"friend_first_state_" andNumFrame:36];
    if (self) {
        _gamePopin = [[TBCharacterNamePopin alloc] initWithName:[[TBModel getInstance].getCurrentLevelData getBestFriendName] similarFriendNumber:[[TBModel getInstance].getCurrentLevelData getBestFriendMutualFriendsNumber] andPictureData:nil];
        
        _dialogue = NSLocalizedString(@"CHARACTER_DIALOGUE", nil);
        
        _gravityCenter = CGPointMake(4, 0);
        
        [self addChild:_gamePopin];
    }
    return self;
}

-(void) connectionOnRange:(BOOL)isOnRange
{
    if(isOnRange)
    {
        if(!_isOnRange) [_gamePopin show];
    }else{
        if(_isOnRange) [_gamePopin hide];
    }
    
    [_gamePopin setPosition:CGPointMake(CGPointZero.x, [self getSize].height * 0.75f)];
    
    [super connectionOnRange:isOnRange];
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
