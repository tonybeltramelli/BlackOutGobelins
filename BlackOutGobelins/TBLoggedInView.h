//
//  TBLoggedInView.h
//  BlackOutGobelins
//
//  Created by tony's computer on 05/04/13.
//
//

#import "TBASubView.h"

@interface TBLoggedInView : TBASubView

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loaderView;
@property (retain, nonatomic) IBOutlet UILabel *bestFriendNameLabel;

-(void)loadData;
-(void)dataLoaded;

@end
