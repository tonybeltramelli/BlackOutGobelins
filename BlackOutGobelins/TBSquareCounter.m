//
//  TBSquareCounter.m
//  BlackOutGobelins
//
//  Created by tony's computer on 11/06/13.
//
//

#import "TBSquareCounter.h"
#import "CCSpriteScale9.h"
#import "TBResources.h"
#import "TBModel.h"

@implementation TBSquareCounter
{
    CCSpriteScale9 *_squareBackground;
    CCLabelTTF *_currentLabel;
    CCLabelTTF *_totalLabel;
    
    float _ratio;
    int _offsetXa;
    int _offsetXb;
    int _offsetYa;
    int _offsetYb;
    int _currentDataNumber;
    int _totalDataNumber;
    BOOL _isReady;
}

- (id)initWithDataNumber:(int)dataNumber
{
    self = [super init];
    if (self)
    {
        _totalDataNumber = dataNumber;
        _currentDataNumber = 0;
        _value = 1.0f;
        _decrementer = 0.05f;
        
        _squareBackground = [CCSpriteScale9 spriteWithFile:[TBResources getAsset:"rounded_corner_popin.png"] andLeftCapWidth:10.0f andTopCapHeight:10.0f];
        [_squareBackground scale9:CGSizeMake(60.0f, 20.0f)];
        [self addChild:_squareBackground];
        
        _ratio = [[TBModel getInstance] isRetinaDisplay] ? 1.0f : 0.5f;
        
        float directionX = (arc4random() % 10) < 5 ? 1.0f : -1.0f;
        
        _offsetXa = (20 + (arc4random() % 90)) * directionX;
        _offsetXb = (20 + (arc4random() % 90)) * - directionX;
        _offsetYa = -(10 + (arc4random() % 20));
        _offsetYb = -(10 + (arc4random() % 20));
        
        _currentLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", _currentDataNumber] dimensions:self.contentSize hAlignment:NSTextAlignmentLeft fontName:@"Helvetica" fontSize:14.0f];
        _currentLabel.color = ccc3(255, 255, 255);
        [self addChild:_currentLabel];
        
        _totalLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"/%d", dataNumber] dimensions:self.contentSize hAlignment:NSTextAlignmentLeft fontName:@"Helvetica" fontSize:14.0f];
        _totalLabel.color = ccc3(200, 200, 200);
        [self addChild:_totalLabel];
        
        [_currentLabel setPosition:CGPointMake(-5, 0)];
        [_totalLabel setPosition:CGPointMake(5, 0)];
    }
    return self;
}

-(void)draw
{
    glLineWidth(0.25f * _ratio);
    
    ccDrawColor4F(_value, _value, _value, _value);
    
    ccDrawLine(CGPointMake(0, _squareBackground.position.y -_squareBackground.contentSize.height / 2), CGPointMake(_offsetXa, _offsetYa));
    ccDrawLine(CGPointMake(0, _squareBackground.position.y - _squareBackground.contentSize.height / 2), CGPointMake(_offsetXb, _offsetYb));
    
    [self setOpacity:(_value * 255)];
}

-(void)updateCounter
{
    _currentDataNumber ++;
    
    [_currentLabel setString:[NSString stringWithFormat:@"%d", _currentDataNumber]];
    
    _isReady = _currentDataNumber == _totalDataNumber;
}

-(void)hide
{
    [super startSchedule];
}

-(BOOL)isReady
{
    return _isReady;
}

- (void)dealloc
{
    _squareBackground = nil;
    _currentLabel = nil;
    _totalLabel = nil;
    
    [super dealloc];
}

@end
