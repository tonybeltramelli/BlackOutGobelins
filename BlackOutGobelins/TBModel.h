//
//  TBModel.h
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 12/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TBFacebookController.h"
#import "TBHomeViewController.h"
#import "TBGameViewController.h"
#import "TBDatabaseController.h"
#import "TBFacebookDataManager.h"
#import "TBFirstLevelData.h"

@interface TBModel : NSObject

@property (assign, nonatomic) BOOL isRetinaDisplay;
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (assign, nonatomic) TBFacebookController *facebookController;
@property (assign, nonatomic) TBFacebookDataManager *facebookDataManager;
@property (assign, nonatomic) TBGameViewController *gameController;

+ (TBModel*)getInstance;

-(TBFirstLevelData *)getCurrentLevelData;

@end
