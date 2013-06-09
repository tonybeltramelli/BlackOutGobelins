//
//  TBLoggedInView.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 05/04/13.
//
//

#import "TBASubView.h"

@interface TBLoggedInView : TBASubView

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loaderView;

-(void)loadData;
-(void)dataLoaded;

@end
