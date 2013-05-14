//
//  TBLoggedInView.m
//  BlackOutGobelins
//
//  Created by tony's computer on 05/04/13.
//
//

#import "TBLoggedInView.h"
#import "TBModel.h"

@implementation TBLoggedInView

-(void) build
{
    _nameLabel.text = [TBModel getInstance].facebookController.user.name;
    _bestFriendNameLabel.text = @"";
    
    [self hideLoader];
    
    [[TBModel getInstance].facebookController getProfilePicture:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_imageView setImage:[UIImage imageWithData:data]];
    
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

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
}

-(void)loadData
{
    NSString *bestFriendName = [[TBModel getInstance] getBestFriend];
    
    if([bestFriendName isEqualToString:@""])
    {
        [self showLoader];
        [[TBModel getInstance].facebookController getBestFriend];
    }else{
        [self displayBestFriend];
    }
}

-(void)dataLoaded
{
    [self hideLoader];
    
    [self displayBestFriend];
    
    [[TBModel getInstance] saveBestFriend];
}

-(void)displayBestFriend
{
    _bestFriendNameLabel.text = [NSString stringWithFormat:@"The best friend is %@ with %d mutual friends.", [TBModel getInstance].facebookController.bestFriend.name, [TBModel getInstance].facebookController.bestFriend.mutualFriendsNumber];
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
    [_loaderView release];
    
    [super dealloc];
}

@end
