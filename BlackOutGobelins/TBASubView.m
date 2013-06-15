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

-(void) build {
    _isShown = FALSE;
}

-(void) show {
    _isShown = TRUE;
}

@end
