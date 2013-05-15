//
//  TBPreHomeViewController.m
//  BlackOutGobelins
//
//  Created by tony's computer on 05/04/13.
//
//

#import "TBPreHomeViewController.h"
#import "TBHomeViewController.h"

@interface TBPreHomeViewController ()

@end

@implementation TBPreHomeViewController

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.3 delay: 1.0 options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         [self.navigationController pushViewController:[[[TBHomeViewController alloc] initWithNibName:nil bundle:nil] autorelease] animated:YES];
                         [self removeFromParentViewController];
                     }];

}

@end
