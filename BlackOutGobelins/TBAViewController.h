//
//  TBAViewController.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 05/04/13.
//
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

@interface TBAViewController : UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (void)dealloc;

@property(nonatomic, retain) AppDelegate *appDelegate;

@end
