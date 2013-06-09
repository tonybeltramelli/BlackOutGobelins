//
//  TBLoggedInView.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 05/04/13.
//
//

#import "TBLoggedInView.h"
#import "TBModel.h"

@implementation TBLoggedInView

-(void) build
{    
    [self hideLoader];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profilePictureIsLoaded:) name:@"PROFILE_PICTURE_LOADED" object:nil];
    
    [[TBModel getInstance].facebookController.user loadProfilePicture];
    
    NSString *friendOnPictureName = [[TBModel getInstance].facebookDataManager getFriendOnPicture];
    
    if([friendOnPictureName isEqualToString:@""])
    {
        if ([FBSession.activeSession.permissions indexOfObject:@"user_photos"] == NSNotFound)
        {
            [FBSession.activeSession reauthorizeWithReadPermissions:[NSArray arrayWithObject:@"user_photos"] completionHandler:^(FBSession *session, NSError *error)
             {
                 if (!error) {
                 
                     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendOnPictureIsLoaded:) name:@"FRIEND_LOADED" object:nil];
                     
                     [[TBModel getInstance].facebookController getFriendOnPicture];
                 }
             }];
        }
    }
}

-(void) profilePictureIsLoaded:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PROFILE_PICTURE_LOADED" object:nil];
    
    _loaderView.backgroundColor = [UIColor whiteColor];
    _loaderView.layer.cornerRadius = 5.0f;
    _loaderView.layer.masksToBounds = YES;
    _loaderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _loaderView.layer.borderWidth = 1.5f;
    _loaderView.layer.shadowColor = [UIColor blackColor].CGColor;
    _loaderView.layer.shadowOpacity = 0.6;
    _loaderView.layer.shadowRadius = 5.0;
    _loaderView.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    
    CGRect loaderViewFrame = _loaderView.frame;
    loaderViewFrame.origin.x = self.frame.size.width / 2 - loaderViewFrame.size.width;
    loaderViewFrame.origin.y = self.frame.size.height / 2 - loaderViewFrame.size.height;
    loaderViewFrame.size.width = loaderViewFrame.size.width * 2;
    loaderViewFrame.size.height = loaderViewFrame.size.height * 2;
    
    [_loaderView setFrame:loaderViewFrame];
}

-(void) friendOnPictureIsLoaded:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FRIEND_LOADED" object:nil];
    
    [[TBModel getInstance].facebookDataManager saveFriendOnPicture];
}

-(void)loadData
{
    NSString *bestFriendName = [[TBModel getInstance].facebookDataManager getBestFriend];
    
    if([bestFriendName isEqualToString:@""])
    {
        [self showLoader];
        [[TBModel getInstance].facebookController getFriendsData];
    }
}

-(void)dataLoaded
{
    [self hideLoader];
    
    [[TBModel getInstance].facebookDataManager saveBestFriend];
    [[TBModel getInstance].facebookDataManager saveSomeFriends];
}

-(void)showLoader
{
    CGRect loaderViewFrame = _loaderView.frame;
    loaderViewFrame.origin.x = self.frame.size.width / 2 - loaderViewFrame.size.width / 2;
    loaderViewFrame.origin.y = self.frame.size.height / 2 - loaderViewFrame.size.height / 2;
    
    [_loaderView setFrame:loaderViewFrame];
    _loaderView.hidden = FALSE;
    
    [_loaderView startAnimating];
}

-(void)hideLoader
{
    _loaderView.hidden = TRUE;
    
    [_loaderView stopAnimating];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_loaderView release];
    
    [super dealloc];
}

@end
