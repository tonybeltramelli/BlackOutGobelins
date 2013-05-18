//
//  TBSequenceFace.m
//  BlackOutGobelins
//
//  Created by tony's computer on 18/05/13.
//
//

#import "TBSequenceFace.h"
#import "TBCharacterFace.h"

@implementation TBSequenceFace
{
    TBCharacterFace *_face;
    int _step;
}

- (id)initWithFilePrefix:(NSString *)prefix andStartTransitionFirstFrame:(int)startNumber andStartTransitionLastFrame:(int)endNumber
{
    self = [super init];
    if (self)
    {
        _startTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"debut"];
        _endTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"fin"];
        _middleTransitionName = [[NSString alloc] initWithFormat:@"%@%@", prefix, @"milieu"];
        
        _startTransitionFirstFrameNumber = startNumber;
        _startTransitionLastFrameNumber = endNumber;
        
        _face = [[TBCharacterFace alloc] initWithStartNumFrame:_startTransitionFirstFrameNumber andEndNumFrame:_startTransitionLastFrameNumber withAnimName:_startTransitionName andFileName:@"" andFilePrefix:prefix];
        
        _step = 1;
        
        [self connectionScheduleHandler:nil];
    }
    return self;
}

-(void) stopConnection
{
    [self connectionScheduleHandler:nil];
}

-(void) connectionScheduleHandler:(id)sender
{
    [self unschedule:@selector(connectionScheduleHandler:)];
    
    NSString *animation = @"";
    
    int firstFrameNumber;
    int lastFrameNumber;
    
    BOOL toContinue = false;
    
    _step ++;
    
    switch (_step) {
        case 1:
            animation = _startTransitionName;
            
            firstFrameNumber = _startTransitionFirstFrameNumber;
            lastFrameNumber = _startTransitionLastFrameNumber;
            
            toContinue = true;
            break;
        case 2:
            animation = _middleTransitionName;
            
            firstFrameNumber = _middleTransitionFirstFrameNumber;
            lastFrameNumber = _middleTransitionLastFrameNumber;
            
            toContinue = false;
            break;
        case 3:
            animation = _endTransitionName;
            
            firstFrameNumber = _endTransitionFirstFrameNumber;
            lastFrameNumber = _endTransitionLastFrameNumber;
            
            toContinue = true;
            break;
        case 4:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"STOP_CONNECTION_ANIMATION_COMPLETE" object:nil];
            
            toContinue = false;
            
            _step = 0;
            break;
        default:
            toContinue = false;
            
            _step = 0;
            break;
    }
    
    if(![animation isEqualToString:@""]) [_face changeAnimation:animation from:firstFrameNumber to:lastFrameNumber];
    
    if(toContinue) [self schedule:@selector(connectionScheduleHandler:) interval:((lastFrameNumber - firstFrameNumber) * [_face delay])];
}

-(void) drawAt:(CGPoint)pos
{
    [self setPosition:pos];
    
    [_face drawAt:CGPointZero];
    
    [self addChild:_face.sprite];
}

-(CGSize) getSize
{
    return _face.getSize;
}

- (void)dealloc
{
    [_face release];
    _face = nil;
    
    [super dealloc];
}

@end
