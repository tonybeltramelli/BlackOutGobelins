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
-(void)fillWithText:(NSString *)string andImageUrl:(NSString *)url;
-(void)fillWithText:(NSString *)string andBigText:(NSString *)bigString;
-(void)fillWithImageUrl:(NSString *)url;

-(CGPoint) getRightTopCorner;
-(CGPoint) getRightBottomCorner;
-(CGPoint) getLeftTopCorner;
-(CGPoint) getLeftBottomCorner;

@end
