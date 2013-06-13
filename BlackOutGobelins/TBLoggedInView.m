//
//  TBLoggedInView.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 05/04/13.
//
//

#import <MediaPlayer/MediaPlayer.h>

#import "TBLoggedInView.h"
#import "TBModel.h"

@implementation TBLoggedInView
{
    MPMoviePlayerController *_moviePlayer;
}

-(void) build
{
    [super build];
    [self showLoader];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendOnPictureIsLoaded:) name:@"FRIEND_LOADED" object:nil];
    
    [[TBModel getInstance].facebookController getFriendOnPicture];
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
    
    NSURL *videoURL = nil;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle)
	{
		NSString *moviePath = [bundle pathForResource:@"search_ego" ofType:@"mov"];
		if (moviePath)
		{
			videoURL = [NSURL fileURLWithPath:moviePath];
		}
	}
    
    /*
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    if ([_moviePlayer respondsToSelector:@selector(loadState)]) {
        [_moviePlayer setControlStyle:MPMovieControlStyleNone];
        [_moviePlayer setFullscreen:YES];
        [_moviePlayer prepareToPlay];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerLoadStateDidChange:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
    }*/
}

- (void)moviePlayerLoadStateDidChange:(NSNotification *)notification
{
    if([_moviePlayer loadState] != MPMovieLoadStateUnknown)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerLoadStateDidChangeNotification
                                                      object:nil];
        
        [[_moviePlayer view] setFrame:[self bounds]];
        [self addSubview:[_moviePlayer view]];
        [self bringSubviewToFront:_label];
        
        [_moviePlayer play];
    }
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
    [_moviePlayer play];
}

-(void)hideLoader
{
    _loaderView.hidden = TRUE;
    
    [_loaderView stopAnimating];
    
    [_moviePlayer stop];
    [_moviePlayer.view removeFromSuperview];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_loaderView release];
    [_label release];
    
    [super dealloc];
}

@end
