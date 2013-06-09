//
//  TBHomeViewController.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 03/04/13.
//
//

#import "TBHomeViewController.h"
#import "TBGameViewController.h"
#import "TBLoggedInView.h"

@interface TBHomeViewController ()
{
    FBRequestConnection *_requestConnection;
    UIView *_currentView;
}

@end

@implementation TBHomeViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _requestConnection = [[FBRequestConnection alloc] init];
    
    [self updateView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.appDelegate.session.isOpen)
    {
        self.appDelegate.session = [[FBSession alloc] init];
        
        if (self.appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [self.appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                                  FBSessionState status,
                                                                  NSError *error) {
                [self updateView];
            }];
        }
    }
    
    self.appDelegate.session = [[FBSession alloc] init];
    [FBSession setActiveSession: self.appDelegate.session];
}

- (IBAction)loginButtonHandler:(id)sender
{
    if (self.appDelegate.session.isOpen) [self.appDelegate.session closeAndClearTokenInformation];
    
    if (self.appDelegate.session.state != FBSessionStateCreated)
    {
        self.appDelegate.session = [[FBSession alloc] init];
        [FBSession setActiveSession: self.appDelegate.session];
    }
    
    [self.appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error)
    {
        if ([[FBSession activeSession] isOpen])
        {
            FBRequest *me = [FBRequest requestForMe];
            [me startWithCompletionHandler: ^(FBRequestConnection *connection,
                                              NSDictionary<FBGraphUser> *user,
                                              NSError *error)
            {
                if (!error)
                {
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookControllerIsReady:) name:@"READY" object:nil];
                    [[TBModel getInstance].facebookDataManager setUserFromGraph:user];
                    [self updateView];
                    
                    [((TBLoggedInView *) _currentView) loadData];
                }
            }];
        }
    }];
}

-(void) facebookControllerIsReady:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [((TBLoggedInView *) _currentView) dataLoaded];
    
    [UIView animateWithDuration:0.3 delay: 1.0 options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         [self.navigationController pushViewController:[[[TBGameViewController alloc] initWithNibName:nil bundle:nil] autorelease] animated:YES];
                         [self removeFromParentViewController];
                     }];
}

- (IBAction)logoutButtonHandler:(id)sender
{
    if (self.appDelegate.session.isOpen)
    {
        [self.appDelegate.session closeAndClearTokenInformation];
        
        [self updateView];
    }
}

- (void)updateView
{
    TBASubView *viewToHide;
    TBASubView *viewToShow;
    
    if ([[FBSession activeSession] isOpen])
    {
        viewToHide = (TBASubView *) _notLoggedView;
        viewToShow = (TBASubView *) _loggedView;
    } else {
        viewToHide = (TBASubView *) _loggedView;
        viewToShow = (TBASubView *) _notLoggedView;
    }
    
    viewToHide.hidden = TRUE;
    viewToShow.hidden = FALSE;
    
    [viewToShow build];
    
    _currentView = viewToShow;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_notLoggedView release];
    [_loggedView release];
    
    [super dealloc];
}

@end
