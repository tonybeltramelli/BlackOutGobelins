//
//  TBDoor.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 29/05/13.
//
//

#import "TBDoor.h"
#import "TBCharacterFace.h"

@implementation TBDoor
{
    TBCharacterFace *_face;
    
    NSString *_openedAnimationName;
    NSString *_openingAnimationName;
    
    int _openedTransitionFrameNumber;
    int _openingTransitionFrameNumber;
    int _step;
    BOOL _isOpen;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _openedTransitionFrameNumber = 3;
        _openingTransitionFrameNumber = 12;
        
        _openedAnimationName = @"door_ouverte";
        _openingAnimationName = @"door_ouverture";
        
        _face = [[TBCharacterFace alloc] initWithStartNumFrame:0 andEndNumFrame:3 withAnimName:@"door_fermee" andFileName:@"" andFilePrefix:@"door"];
        
        _isOpen = FALSE;
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{
    [self setPosition:pos];
    
    [_face drawAt:CGPointZero];
    [self addChild:_face.sprite];
}

-(void) openIt
{
    if(_isOpen) return;
    
    _isOpen = TRUE;
    _step = 0;
    
    [self doorOpeningScheduleHandler:nil];
}

-(void) doorOpeningScheduleHandler:(id)sender
{
    [self unschedule:@selector(doorOpeningScheduleHandler:)];
    
    NSString *animation;
    
    int frameNumber;
    
    BOOL toContinue = false;
    
    _step ++;
    
    switch (_step) {
        case 1:
            animation = _openingAnimationName;
            
            frameNumber = _openingTransitionFrameNumber;
            
            toContinue = true;
            break;
        case 2:
            animation = _openedAnimationName;
            
            frameNumber = _openedTransitionFrameNumber;
            
            toContinue = false;
            break;
        default:
            toContinue = false;
            
            _step = 0;
            break;
    }
    
    [_face changeAnimation:animation from:0 to:frameNumber];
    
    if(toContinue) [self schedule:@selector(doorOpeningScheduleHandler:) interval:(frameNumber * [_face delay])];
}

- (void)dealloc
{
    [_face release];
    _face = nil;
    
    _openedAnimationName = nil;
    _openingAnimationName = nil;
    
    [super dealloc];
}

@end
