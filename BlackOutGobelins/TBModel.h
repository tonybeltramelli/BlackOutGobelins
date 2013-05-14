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
#import "TBDatabaseController.h"

@interface TBModel : NSObject

@property (assign, nonatomic) BOOL isRetinaDisplay;
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (assign, nonatomic) TBFacebookController *facebookController;

+ (TBModel*)getInstance;

-(void) saveBestFriend;
-(NSString *) getBestFriend;

@end
