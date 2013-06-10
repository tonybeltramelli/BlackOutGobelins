//
//  TBASubView.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 15/04/13.
//
//

#import "TBASubView.h"

@implementation TBASubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) build
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.frame.size.height != 568 ? @"Blank-Background.jpg" : @"Blank-Background-568h@2x.jpg"]];
}

@end
