//
//  TBPreHomeViewController.m
//  BlackOutGobelins
//
//  Created by tony's computer on 05/04/13.
//
//

#import "TBPreHomeViewController.h"
#import "TBHomeViewController.h"
#import "TBGameViewController.h"

@interface TBPreHomeViewController ()

@end

@implementation TBPreHomeViewController

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[TBModel getInstance].facebookDataManager getUser];
    
    UIViewController *viewController;
    
    if([TBModel getInstance].facebookController.user)
    {
        viewController = [TBGameViewController alloc];
    }else{
        viewController = [TBHomeViewController alloc];
    }
    
    viewController = [TBGameViewController alloc];
    
    [UIView animateWithDuration:0.3 delay: 1.0 options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         [self.navigationController pushViewController:[[viewController initWithNibName:nil bundle:nil] autorelease] animated:YES];
                         [self removeFromParentViewController];
                     }];
}

@end
