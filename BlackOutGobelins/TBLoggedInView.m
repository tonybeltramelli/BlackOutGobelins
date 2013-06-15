//
//  TBLoggedInView.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 05/04/13.
//
//

#import "TBLoggedInView.h"
#import "TBModel.h"
#import "TBVideoPlayer.h"

@implementation TBLoggedInView
{
    TBVideoPlayer *_videoPlayer;
}

-(void) build
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:self.frame.size.height != 568 ? @"Blank-Background.jpg" : @"Blank-Background-568h@2x.jpg"]];
    
    [super build];
    [self showLoader];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendOnPictureIsLoaded:) name:@"FRIEND_LOADED" object:nil];
    
    [[TBModel getInstance].facebookController getFriendOnPicture];
}

-(void) friendOnPictureIsLoaded:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FRIEND_LOADED" object:nil];
    
    [[TBModel getInstance].facebookDataManager saveFriendOnPicture];
}

-(void)loadData
{
    NSString *bestFriendName = [[TBModel getInstance].facebookDataManager getBestFriend];
    
    if([bestFriendName isEqualToString:@""]) [[TBModel getInstance].facebookController getFriendsData];
}

-(void)dataLoaded
{
    [self hideLoader];
    
    [[TBModel getInstance].facebookDataManager saveBestFriend];
    [[TBModel getInstance].facebookDataManager saveSomeFriends];
}

-(void)showLoader
{
    _loaderView.backgroundColor = [UIColor whiteColor];
    _loaderView.layer.cornerRadius = 5.0f;
    _loaderView.layer.masksToBounds = YES;
    _loaderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _loaderView.layer.borderWidth = 1.5f;
    _loaderView.layer.shadowColor = [UIColor blackColor].CGColor;
    _loaderView.layer.shadowOpacity = 0.6;
    _loaderView.layer.shadowRadius = 5.0;
    _loaderView.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    _loaderView.hidden = FALSE;
    
    [_loaderView startAnimating];
    
    NSString *loadingText = NSLocalizedString(@"FACEBOOK_DATA_LOADING", nil);
    
    int i = 0;
    int length = loadingText.length;
    
    int lineNumber = 0;
    
    for(i = 0; i < length; i++)
    {
        NSString* splittedString = [loadingText substringWithRange:NSMakeRange(i, 1)];
        
        if([splittedString isEqualToString:@"\n"]) lineNumber ++;
    }
    
    [_label setText:loadingText];
    _label.numberOfLines = lineNumber + 1;
    
    _videoPlayer = [[TBVideoPlayer alloc] initWithVideoName:@"search_ego" andVideoType:@"mov" loop:TRUE withDelegate:self stateDidChangeCallBack:@selector(moviePlayerLoadStateDidChange:) playBackDidFinishCallBack:@selector(moviePlayBackDidFinish:)];
    [self addSubview:_videoPlayer];
}

- (void)moviePlayerLoadStateDidChange:(NSNotification *)notification
{
    [self bringSubviewToFront:_label];
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
}

-(void)hideLoader
{
    _loaderView.hidden = TRUE;
    
    [_loaderView stopAnimating];
    
    [_videoPlayer stop];
    [_videoPlayer removeFromSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_loaderView release];
    [_label release];
    
    if(_videoPlayer)
    {
        [_videoPlayer release];
        _videoPlayer = nil;
    }
    
    [super dealloc];
}

@end
