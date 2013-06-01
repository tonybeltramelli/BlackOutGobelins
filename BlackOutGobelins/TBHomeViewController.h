//
//  TBHomeViewController.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 03/04/13.
//
//

#import <FacebookSDK/FacebookSDK.h>

#import "TBAViewController.h"
#import "TBModel.h"

@interface TBHomeViewController : TBAViewController

@property (retain, nonatomic) IBOutlet UIView *notLoggedView;
@property (retain, nonatomic) IBOutlet UIView *loggedView;

@end
