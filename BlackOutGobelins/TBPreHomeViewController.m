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
#import "TBResources.h"

@interface TBPreHomeViewController ()

@end

@implementation TBPreHomeViewController

- (void)viewDidLoad
{
    [_textView setHidden:TRUE];
    [_label setHidden:TRUE];
    
    _textView.text = NSLocalizedString(@"PREHOME_TEXT", nil);
    _label.text = NSLocalizedString(@"USER_COMEBACK", nil);
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.view.frame.size.height != 568 ? @"Blank-Background.jpg" : @"Blank-Background-568h@2x.jpg"]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[TBModel getInstance].facebookDataManager getUser];
    [[TBModel getInstance].facebookDataManager getBestFriend];
    [[TBModel getInstance].facebookDataManager getFriendOnPicture];
    [[TBModel getInstance].facebookDataManager getSomeFriends];
    
    BOOL userIsKnown = [TBModel getInstance].facebookController.user != nil && ![[TBModel getInstance].facebookController.user.name isEqualToString:@""];
    
    UIViewController *viewController;
    
    if(userIsKnown)
    {
        viewController = [TBGameViewController alloc];
        
        _label.text = [_label.text stringByReplacingOccurrencesOfString:@"{username}" withString:[TBModel getInstance].facebookController.user.name];
        
        [_label setHidden:FALSE];
    }else{
        CGSize contentSize = [_textView.text sizeWithFont:_textView.font constrainedToSize:_textView.frame.size];
        
        _textView.frame = CGRectMake(_textView.frame.origin.x, [UIScreen mainScreen].bounds.size.height / 2 - contentSize.height, _textView.frame.size.width, _textView.frame.size.height);

        viewController = [TBHomeViewController alloc];
        
        [_textView setHidden:FALSE];
    }
    
    viewController = [TBHomeViewController alloc];
    
    [UIView animateWithDuration:0.3 delay:userIsKnown ? 1.2 : 6.0 options: UIViewAnimationOptionCurveEaseInOut
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
    [_label release];
    
    [super dealloc];
}
@end
