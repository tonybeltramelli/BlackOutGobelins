//
//  TBClueBox.m
//  BlackOutGobelins
//
//  Created by tony's computer on 12/06/13.
//
//

#import "TBClueBox.h"
#import "CCSpriteScale9.h"
#import "TBImageLoader.h"
#import "TBResources.h"
#import "TBModel.h"

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
    _label = [CCLabelTTF labelWithString:string dimensions:CGSizeMake(_size.width - _padding * 2, _size.height - _padding * 2) hAlignment:NSTextAlignmentCenter fontName:@"Helvetica" fontSize:10.0f];
    _label.color = ccc3(65, 65, 65);
    [_label setPosition:CGPointMake(0.0f, _background.contentSize.height / 2 - _label.contentSize.height / 2 - 6)];
    [self addChild:_label];
}

-(void)fillWithText:(NSString *)string andImageUrl:(NSString *)url
{
    [self fillWithText:string];
    
    [TBImageLoader loaderWithUrl:url at:self andSelector:@selector(imageIsLoaded:) needTexture:TRUE];
}

-(void) imageIsLoaded:(CCTexture2D *)texture
{
    if(!texture) return;
    
    CCSprite *image = [CCSprite spriteWithTexture:texture];
    [image setScale:[TBModel getInstance].isRetinaDisplay ? 1.0f : 0.5f];
    [image setPosition:CGPointMake(CGPointZero.x, - _background.contentSize.height / 2 + ((image.contentSize.height - _padding * 2) * image.scale))];
    [self addChild:image];
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
