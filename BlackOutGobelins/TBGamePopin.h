//
//  TBGamePopin.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 20/05/13.
//
//

#import "CCSprite.h"

@interface TBGamePopin : CCSprite
{
    CGSize _size;
}

- (id)initWithSize:(CGSize)size;

- (void)show;
- (void)hide;

@end
