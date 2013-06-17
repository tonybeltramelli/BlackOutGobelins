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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.view.frame.size.height != 568 && self.view.frame.size.width != 568 ? @"Blank-Background.jpg" : @"Blank-Background-568h@2x.jpg"]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[TBModel getInstance].facebookDataManager getUser];
    [[TBModel getInstance].facebookDataManager getBestFriend];
    [[TBModel getInstance].facebookDataManager getFriendOnPicture];
    [[TBModel getInstance].facebookDataManager getSomeFriends];
    
    BOOL isReady = [self isUserKnown:[TBModel getInstance].facebookController.user] && [self isUserKnown:[TBModel getInstance].facebookController.bestFriend] && [self isUserKnown:[TBModel getInstance].facebookController.friendOnPicture] && [[TBModel getInstance].facebookController.someFriends count] != 0;
    
    UIViewController *viewController;
    
    if(isReady)
    {
        viewController = [TBGameViewController alloc];
        
        _label.text = [_label.text stringByReplacingOccurrencesOfString:@"{username}" withString:[TBModel getInstance].facebookController.user.name];
        
        [_label setHidden:FALSE];
    }else{
        CGSize contentSize = [_textView.text sizeWithFont:_textView.font constrainedToSize:_textView.frame.size];
        
        _textView.frame = CGRectMake(_textView.frame.origin.x, contentSize.height / 2, _textView.frame.size.width, _textView.frame.size.height);

        viewController = [TBHomeViewController alloc];
        
        [_textView setHidden:FALSE];
    }
    
    [UIView animateWithDuration:0.3 delay:isReady ? 1.2 : 6.0 options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         [self.navigationController pushViewController:[[viewController initWithNibName:nil bundle:nil] autorelease] animated:YES];
                         [self removeFromParentViewController];
                     }];
}

-(BOOL) isUserKnown:(TBFacebookUserDescriptor *)user
{
    return (user != nil && ![user.name isEqualToString:@""]);
}

- (void)dealloc {
    [_textView release];
    [_label release];
    
    [super dealloc];
}
@end
