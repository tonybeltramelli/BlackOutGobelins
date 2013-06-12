//
//  TBClueBox.m
//  BlackOutGobelins
//
//  Created by tony's computer on 12/06/13.
//
//

#import "TBClueBox.h"
#import "CCSpriteScale9.h"
#import "TBResources.h"

@implementation TBClueBox
{
    CCSpriteScale9 *_background;
    CCLabelTTF *_label;
    
    CGSize _size;
    int _rangeX;
    int _rangeY;
    int _padding;
    float _incrementer;
    float _maxX;
    float _minX;
    float _maxY;
    float _minY;
    float _xDirection;
    float _yDirection;
    BOOL _isEnabledMoving;
}

- (id)initWithSize:(CGSize)size atPosition:(CGPoint)position
{
    self = [super init];
    if (self) {
        _size = size;
        _padding = 3.0f;
        
        _background = [CCSpriteScale9 spriteWithFile:[TBResources getAsset:"clue_box.png"] andLeftCapWidth:10.0f andTopCapHeight:10.0f];
        [_background scale9:size];
        
        _rangeX = 5;
        _rangeY = 5;
        
        [self setPosition:position];
        
        _maxX = self.position.x + _rangeX;
        _minX = self.position.x - _rangeX;
        _maxY = self.position.y + _rangeY;
        _minY = self.position.y - _rangeY;
        
        _incrementer = 0.0625f;
        _isEnabledMoving = FALSE;
        
        [self setPosition:CGPointMake((arc4random() % 10) < 5 ? _minX : _maxX, (arc4random() % 10) < 5 ? _minY : _maxY)];
        
        [self addChild:_background];        
        [self schedule:@selector(enabledMoving:) interval:(arc4random() % 10) * 0.25f];
    }
    return self;
}

-(void) enabledMoving:(id)sender
{
    [self unschedule:@selector(enabledMoving:)];
    
    _isEnabledMoving = TRUE;
}

-(void)fillWithText:(NSString *)string
{
    _label = [CCLabelTTF labelWithString:string dimensions:_size hAlignment:NSTextAlignmentCenter fontName:@"Helvetica" fontSize:10.0f];
    _label.color = ccc3(65, 65, 65);
    [_label setPosition:CGPointMake(0.0f, _background.contentSize.height / 2 - _label.contentSize.height / 2 - 6)];
    [self addChild:_label];
}

-(void) draw
{
    if(!_isEnabledMoving) return;
    
    float newX = self.position.x;
    float newY = self.position.y;
    
    if(self.position.x == _maxX)
    {
        _xDirection = -_incrementer;
    }else if(self.position.x == _minX)
    {
        _xDirection = _incrementer;
    }
    
    if(self.position.y == _maxY)
    {
        _yDirection = -_incrementer;
    }else if(self.position.y == _minY)
    {
        _yDirection = _incrementer;
    }
    
    newX += _xDirection;
    newY += _yDirection;
    
    [self setPosition:CGPointMake(newX, newY)];
}

-(CGPoint) getRightTopCorner
{
    return CGPointMake(self.position.x + _background.contentSize.width / 2 - _padding, self.position.y + _background.contentSize.height / 2 - _padding);
}

-(CGPoint) getRightBottomCorner
{
    return CGPointMake(self.position.x + _background.contentSize.width / 2 - _padding, self.position.y - _background.contentSize.height / 2 + _padding);
}

-(CGPoint) getLeftTopCorner
{
    return CGPointMake(self.position.x - _background.contentSize.width / 2 + _padding, self.position.y + _background.contentSize.height / 2 - _padding);
}

-(CGPoint) getLeftBottomCorner
{
    return CGPointMake(self.position.x - _background.contentSize.width / 2 + _padding, self.position.y - _background.contentSize.height / 2 + _padding);
}

- (void)dealloc
{
    _background = nil;
    
    [super dealloc];
}

@end
