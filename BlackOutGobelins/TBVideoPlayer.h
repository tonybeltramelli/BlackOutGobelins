//
//  TBVideoPlayer.h
//  BlackOutGobelins
//
//  Created by tony's computer on 14/06/13.
//
//

#import <UIKit/UIKit.h>

@interface TBVideoPlayer : UIView

- (id)initWithVideoName:(NSString *)name andVideoType:(NSString *)type loop:(BOOL)toLoop withDelegate:(id)delegate stateDidChangeCallBack:(SEL)selectorStateDidChange playBackDidFinishCallBack:(SEL)selectorPlayBackDidFinish;

- (void)stop;

@end
