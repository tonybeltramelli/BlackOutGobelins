//
//  TBCharacterFirstState.m
//  BlackOutGobelins
//
//  Created by tony's computer on 15/05/13.
//
//

#import "TBCharacterFirstState.h"
#import "TBCharacterNamePopin.h"

@implementation TBCharacterFirstState
{
    TBCharacterNamePopin *_gamePopin;
    NSString *_dialogue;
}

- (id)init
{
    self = [super initWithPrefix:@"friend_first_state_" andNumFrame:39];
    if (self) {
        _gamePopin = [[TBCharacterNamePopin alloc] initWithName:@"Character Name" similarFriendNumber:12 andPictureData:nil];
        
        _dialogue = NSLocalizedString(@"CHARACTER_DIALOGUE", nil);
        
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
