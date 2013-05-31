//
//  TBASets.m
//  BlackOutGobelins
//
//  Created by tony's computer on 31/05/13.
//
//

#import "TBASets.h"
#import "TBCharacterFace.h"

@implementation TBASets

- (id)initWithPrefix:(NSString *)prefix
{
    self = [super init];
    if (self) {
        _prefix = prefix;
        
        _isDiscovered = false;
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{
    [self setPosition:pos];
    
    [self addChild:_currentFace.sprite];
}

-(void) connectionOnRange:(BOOL)isOnRange
{
    if(_isDiscovered) return;
    
    if(isOnRange && !_isDiscovered)
    {
        _isDiscovered = true;
    }
}

-(CGPoint) getPosition
{
    return [self position];
}

-(CGSize) getSize
{
    return _currentFace.getSize;
}

@end
