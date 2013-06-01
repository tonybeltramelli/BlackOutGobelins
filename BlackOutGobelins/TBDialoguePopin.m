//
//  TBDialoguePopin.m
//  BlackOutGobelins
//
//  Created by tony's computer on 20/05/13.
//
//

#import "TBDialoguePopin.h"
#import "CCDirector.h"
#import "CCLabelTTF.h"
#import "CCLayer.h"
#import "cocos2d.h"

@implementation TBDialoguePopin
{
    CCLabelTTF *_dialogueContent;
    
    NSMutableArray *_strings;
    CGSize _size;
    int _step;
    BOOL _isOver;
}

const float CHARACTER_LIMIT = 220.0f;
const float TRANSITION_DURATION = 0.1f;

- (id)initWithContent:(NSString *)content
{
    _size = CGSizeMake([[CCDirector sharedDirector] winSize].width - 20, 90);
    
    self = [super initWithSize:_size];
    if (self)
    {
        _strings = [[NSMutableArray alloc] init];
        
        float splitNumber = [content length] / CHARACTER_LIMIT;
        
        int i = 0;
        int length = ceil(splitNumber) + 1;
        
        int prevIndex = 0;
        
        for(i = 1; i < length; i++)
        {
            int index = CHARACTER_LIMIT * i > [content length] ? [content length] : CHARACTER_LIMIT * i;
            
            NSString* splittedString = [content substringWithRange:NSMakeRange(prevIndex, index - prevIndex)];
            [_strings addObject:splittedString];
            
            prevIndex = index;
        }
        
        _step = 0;
        
        _dialogueContent = [CCLabelTTF labelWithString:[_strings objectAtIndex:_step] dimensions:CGSizeMake(_size.width - 20, _size.height - 20) hAlignment:NSTextAlignmentLeft fontName:@"Helvetica" fontSize:14.0f];
        [self addChild:_dialogueContent];
        
        _isOver = false;
        
        [self setPosition:CGPointMake(_size.width / 2 + 10, - _size.height / 2)];
    }
    return self;
}

-(void) show
{
    [self runAction:[CCMoveTo actionWithDuration:TRANSITION_DURATION position:CGPointMake(_size.width / 2 + 10, _size.height / 2 + 10)]];
}

-(void) hide
{
    [self runAction:[CCMoveTo actionWithDuration:TRANSITION_DURATION position:CGPointMake(_size.width / 2 + 10, - _size.height / 2)]];
}

-(void) nextStep
{
    if(_isOver) return;
    
    _step ++;
    
    if(_step != [_strings count])
    {
        [_dialogueContent setString:[_strings objectAtIndex:_step]];
    }else{
        _isOver = true;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDE_DIALOGUE" object:nil];
        
        [self hide];
        
        [self scheduleOnce:@selector(makeTransition:) delay:TRANSITION_DURATION];
    }
}

-(void) makeTransition:(ccTime)dt
{
    [self unscheduleAllSelectors];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHARACTER_DISCONNECTED" object:nil];
}

- (void)dealloc
{
    _dialogueContent = nil;
    
    [_strings release];
    _strings = nil;
    
    [super dealloc];
}

@end
