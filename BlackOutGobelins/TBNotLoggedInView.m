//
//  TBNotLoggedInView.m
//  BlackOutGobelins
///Users/tbeltramelli/Documents/Objective-C/BlackOutGobelins/BlackOutGobelins.xcodeproj
//  Created by Tony Beltramelli on 05/04/13.
//
//

#import "TBNotLoggedInView.h"

@implementation TBNotLoggedInView
{
    float _margin;
}

-(void) build
{
    [super build];
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.frame.size.height != 568 && self.frame.size.width != 568 ? @"home_background.jpg" : @"home_background-568h@2x.jpg"]];
    
    [_button setTitle:NSLocalizedString(@"BUTTON_LOGIN", nil) forState:UIControlStateNormal];
    
    _margin = _rockImageView.image.size.width / 4;
    
    [_rockImageView setFrame:CGRectMake(-_rockImageView.image.size.width, 0.0f, _rockImageView.image.size.width, _rockImageView.image.size.height)];
    
    [_egoImageView setFrame:CGRectMake(_rockImageView.image.size.width / 2, _rockImageView.image.size.height, _egoImageView.image.size.width - _margin, _egoImageView.image.size.height)];
}

-(void) show
{
    if(_isShown) return;
    
    [super show];
    
    [self performSelector:@selector(animate:) withObject:nil afterDelay:0.5];
}

-(void) animate:(id)sender
{
    _rockImageView.hidden = FALSE;
    _egoImageView.hidden = FALSE;
    
    [UIView animateWithDuration:0.6 delay:0.0 options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect rockImageFrame = _rockImageView.frame;
                         rockImageFrame.origin.x = -_margin;
                         _rockImageView.frame = rockImageFrame;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:1.0 delay: 0.9 options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              CGRect egoImageFrame = _egoImageView.frame;
                                              egoImageFrame.origin.y = _rockImageView.image.size.height / 2 -  _egoImageView.image.size.height / 2;
                                              _egoImageView.frame = egoImageFrame;
                                          }
                                          completion:nil];
                     }];
}

- (void)dealloc
{
    [_button release];
    [_rockImageView release];
    [_egoImageView release];
    
    [super dealloc];
}

@end
