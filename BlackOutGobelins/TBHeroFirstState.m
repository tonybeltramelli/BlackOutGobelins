//
//  TBHeroFirstState.m
//  BlackOut
//
//  Created by tony's computer on 06/02/13.
//
//

#import "TBHeroFirstState.h"

@implementation TBHeroFirstState

- (id)init
{        
    self = [super initDefault];
    if (self)
    {
        _front_animation_name = "milieu_face";
        _back_animation_name = "milieu_dos";
        _right_animation_name = "milieu_droite";
        _left_animation_name = "milieu_gauche";
        
        NSString *prefix = @"hero_first_";
        
        _frontFace = [[TBCharacterFace alloc] initWithStartNumFrame:12 andEndNumFrame:31  withAnimName:[NSString stringWithUTF8String:_front_animation_name] andFilePrefix:prefix];
        
        _backFace = [[TBCharacterFace alloc] initWithStartNumFrame:12 andEndNumFrame:31 withAnimName:[NSString stringWithUTF8String:_back_animation_name] andFilePrefix:prefix];
                     
        _rightFace = [[TBCharacterFace alloc] initWithStartNumFrame:12 andEndNumFrame:31 withAnimName:[NSString stringWithUTF8String:_right_animation_name] andFilePrefix:prefix];
                     
        _leftFace = [[TBCharacterFace alloc] initWithStartNumFrame:12 andEndNumFrame:31 withAnimName:[NSString stringWithUTF8String:_left_animation_name] andFilePrefix:prefix];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
