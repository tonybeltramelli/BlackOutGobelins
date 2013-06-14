//
//  TBVideoPlayer.m
//  BlackOutGobelins
//
//  Created by tony's computer on 14/06/13.
//
//

#import <MediaPlayer/MediaPlayer.h>

#import "TBVideoPlayer.h"

@implementation TBVideoPlayer
{
    MPMoviePlayerController *_moviePlayer;
    
    BOOL _toLoop;
    id _delegate;
    SEL _selectorStateDidChange;
    SEL _selectorPlayBackDidFinish;
}

- (id)initWithVideoName:(NSString *)name andVideoType:(NSString *)type loop:(BOOL)toLoop withDelegate:(id)delegate stateDidChangeCallBack:(SEL)selectorStateDidChange playBackDidFinishCallBack:(SEL)selectorPlayBackDidFinish
{
    self = [super initWithFrame:(CGRectMake(0.0f, 0.0f, UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width, UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height))];
    if (self) {
        NSURL *videoURL = nil;
        NSBundle *bundle = [NSBundle mainBundle];
        if (bundle)
        {
            NSString *moviePath = [bundle pathForResource:name ofType:type];
            if (moviePath)
            {
                videoURL = [NSURL fileURLWithPath:moviePath];
            }
        }
        
        _toLoop = toLoop;
        _delegate = delegate;
        _selectorStateDidChange = selectorStateDidChange;
        _selectorPlayBackDidFinish = selectorPlayBackDidFinish;
        
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
        }
    }
    return self;
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
        
        [_moviePlayer play];
    }
    
    [_delegate performSelector:_selectorStateDidChange withObject:nil];
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
    if(_toLoop) [_moviePlayer play];
    
    [_delegate performSelector:_selectorPlayBackDidFinish];
}

- (void)stop
{
    [_moviePlayer stop];
}

- (void)dealloc
{
    [_moviePlayer release];
    _moviePlayer = nil;
    
    [super dealloc];
}

@end
