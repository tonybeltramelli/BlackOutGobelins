//
//  TBClueBox.h
//  BlackOutGobelins
//
//  Created by tony's computer on 12/06/13.
//
//

#import "CCSprite.h"

@interface TBClueBox : CCSprite

- (id)initWithSize:(CGSize)size atPosition:(CGPoint)position;

-(void)fillWithText:(NSString *)string;

-(CGPoint) getRightTopCorner;
-(CGPoint) getRightBottomCorner;
-(CGPoint) getLeftTopCorner;
-(CGPoint) getLeftBottomCorner;

@end
