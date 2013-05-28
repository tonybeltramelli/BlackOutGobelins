//
//  TBLine.h
//  BlackOutGobelins
//
//  Created by tony's computer on 10/05/13.
//
//

#import "TBSpecial.h"

@interface TBLine : TBSpecial

- (id)initFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint;
- (id)initFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint withInteractionType:(NSString *)type andData:(NSString *)data andColor:(ccColor3B)color;

+ (id)lineFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint;
+ (id)lineFrom:(CGPoint)startPoint andTo:(CGPoint)endPoint withInteractionType:(NSString *)type andData:(NSString *)data andColor:(ccColor3B)color;

@end
