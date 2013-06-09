//
//  TBNotLoggedInView.m
//  BlackOutGobelins
//
//  Created by Tony Beltramelli on 05/04/13.
//
//

#import "TBNotLoggedInView.h"

@implementation TBNotLoggedInView

-(void) build
{
    [_button setTitle:NSLocalizedString(@"BUTTON_LOGIN", nil) forState:UIControlStateNormal];
}

- (void)dealloc
{
    [_button release];
    
    [super dealloc];
}

@end
