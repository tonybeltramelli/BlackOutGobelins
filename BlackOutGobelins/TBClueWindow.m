//
//  TBClueWindow.m
//  BlackOutGobelins
//
//  Created by tony's computer on 12/06/13.
//
//

#import "TBClueWindow.h"
#import "TBResources.h"
#import "TBModel.h"
#import "TBClueBox.h"

@implementation TBClueWindow
{
    CGPoint _gravityCenter;
    CGPoint _p1;
    CGPoint _p2;
    CGPoint _p3;
    CGPoint _p4;
    
    float _ratio;
    float _value;
    
    BOOL _isReady;
}

- (id)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        _gravityCenter = CGPointMake(size.width / 2, size.height / 2);
        _ratio = [[TBModel getInstance] isRetinaDisplay] ? 1.0f : 0.5f;
        _value = 0.5f;
        
        _isReady = FALSE;
        
        _p1 = CGPointMake(_gravityCenter.x, _gravityCenter.y + 30);
        _p2 = CGPointMake(_gravityCenter.x - 20, _gravityCenter.y);
        _p3 = CGPointMake(_gravityCenter.x, _gravityCenter.y - 30);
        _p4 = CGPointMake(_gravityCenter.x + 20, _gravityCenter.y);
        
        [self schedule:@selector(build:) interval:0.6f];
    }
    return self;
}

-(void) build:(id)sender
{
    [self unschedule:@selector(build:)];
    
    [self addClueWith:CGSizeMake(50, 50) at:CGPointMake(_gravityCenter.x - 60, _gravityCenter.y + 110)];
    [self addClueWith:CGSizeMake(100, 80) at:CGPointMake(_gravityCenter.x - 100, _gravityCenter.y + 30)];
    [self addClueWith:CGSizeMake(150, 50) at:CGPointMake(_gravityCenter.x - 130, _gravityCenter.y - 50)];
    [self addClueWith:CGSizeMake(100, 60) at:CGPointMake(_gravityCenter.x - 50, _gravityCenter.y - 120)];
    [self addClueWith:CGSizeMake(150, 40) at:CGPointMake(_gravityCenter.x + 120, _gravityCenter.y + 120)];
    [self addClueWith:CGSizeMake(120, 100) at:CGPointMake(_gravityCenter.x + 140, _gravityCenter.y + 30)];
    [self addClueWith:CGSizeMake(50, 50) at:CGPointMake(_gravityCenter.x + 120, _gravityCenter.y - 70)];
    [self addClueWith:CGSizeMake(60, 60) at:CGPointMake(_gravityCenter.x + 180, _gravityCenter.y - 60)];
    
    [((TBClueBox *)[[self children] objectAtIndex:4]) fillWithText:NSLocalizedString(@"CLUE_DOOR", nil)];
    
    _isReady = TRUE;
}

-(void)addClueWith:(CGSize)size at:(CGPoint)position
{
    TBClueBox *_clue = [[TBClueBox alloc] initWithSize:size atPosition:position];
    [self addChild:_clue];
}

-(void)draw
{
    if(!_isReady) return;
    
    glLineWidth(0.25f * _ratio);
    
    ccDrawColor4F(_value, _value, _value, _value);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:0]) getRightBottomCorner], [((TBClueBox *)[[self children] objectAtIndex:4]) getLeftBottomCorner]);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:1]) getRightTopCorner], [((TBClueBox *)[[self children] objectAtIndex:4]) getLeftBottomCorner]);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:4]) getLeftBottomCorner], [((TBClueBox *)[[self children] objectAtIndex:5]) getLeftBottomCorner]);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:6]) getLeftTopCorner], [((TBClueBox *)[[self children] objectAtIndex:7]) getLeftTopCorner]);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:5]) getLeftBottomCorner], [((TBClueBox *)[[self children] objectAtIndex:7]) getLeftTopCorner]);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:3]) getRightBottomCorner], [((TBClueBox *)[[self children] objectAtIndex:6]) getLeftBottomCorner]);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:2]) getLeftBottomCorner], [((TBClueBox *)[[self children] objectAtIndex:3]) getRightTopCorner]);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:1]) getRightBottomCorner], [((TBClueBox *)[[self children] objectAtIndex:2]) getRightTopCorner]);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:1]) getRightTopCorner], _p2);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:2]) getRightTopCorner], _p2);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:2]) getRightBottomCorner], _p2);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:2]) getRightBottomCorner], _p3);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:3]) getRightTopCorner], _p3);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:6]) getLeftBottomCorner], _p3);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:6]) getLeftBottomCorner], _p4);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:5]) getLeftBottomCorner], _p4);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:4]) getLeftBottomCorner], _p4);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:4]) getLeftBottomCorner], _p4);
    
    ccDrawLine([((TBClueBox *)[[self children] objectAtIndex:4]) getLeftBottomCorner], _p1);
}

- (void)dealloc
{
    [self removeAllChildrenWithCleanup:TRUE];
    
    [super dealloc];
}

@end
