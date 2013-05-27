//
//  TBLine.h
//  BlackOutGobelins
//
//  Created by tony's computer on 10/05/13.
//
//

#import "TBSpecial.h"

@interface TBLine : TBSpecial

- (id)initFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint withInteractionType:(NSString *)type andData:(NSString *)data;
+ (id)lineFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint withInteractionType:(NSString *)type andData:(NSString *)data;

@end
