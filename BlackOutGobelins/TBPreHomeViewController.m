//
//  TBPreHomeViewController.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 05/04/13.
//
//

#import "TBPreHomeViewController.h"
#import "TBHomeViewController.h"
#import "TBGameViewController.h"

@interface TBPreHomeViewController ()

@end

@implementation TBPreHomeViewController

- (void)viewDidLoad
{
    NSString *labelContent = NSLocalizedString(@"PREHOME_TEXT", nil);
    
    _textView.text = labelContent;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGSize contentSize = [_textView.text sizeWithFont:_textView.font constrainedToSize:_textView.frame.size];
    
    _textView.frame = CGRectMake(_textView.frame.origin.x, [UIScreen mainScreen].bounds.size.height / 2 - contentSize.height, _textView.frame.size.width, _textView.frame.size.height);
    
    [[TBModel getInstance].facebookDataManager getUser];
    [[TBModel getInstance].facebookDataManager getBestFriend];
    [[TBModel getInstance].facebookDataManager getFriendOnPicture];
    [[TBModel getInstance].facebookDataManager getSomeFriends];
    
    UIViewController *viewController;
    
    if([TBModel getInstance].facebookController.user)
    {
        viewController = [TBGameViewController alloc];
    }else{
        viewController = [TBHomeViewController alloc];
    }
    
    [UIView animateWithDuration:0.3 delay: 6.0 options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         [self.navigationController pushViewController:[[viewController initWithNibName:nil bundle:nil] autorelease] animated:YES];
                         [self removeFromParentViewController];
                     }];
}

- (void)dealloc {
    [_textView release];
    
    [super dealloc];
}
@end
