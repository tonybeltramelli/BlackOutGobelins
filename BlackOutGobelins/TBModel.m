//
//  TBModel.m
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 12/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBModel.h"

@implementation TBModel
{
    TBDatabaseController *_databaseController;
    TBFirstLevelData *_level;
}

static TBModel* _instance = nil;

@synthesize isRetinaDisplay = _isRetinaDisplay;
@synthesize appDelegate = _appDelegate;
@synthesize facebookController = _facebookController;
@synthesize facebookDataManager = _facebookDataManager;

+(TBModel*)getInstance
{
	@synchronized([TBModel class])
	{
		if (!_instance) [[self alloc] init];
		return _instance;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([TBModel class])
	{
		NSAssert(_instance == nil, @"Attempted to allocate a second instance of a singleton.");
		_instance = [super alloc];
		return _instance;
	}
    
	return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _facebookController = [[TBFacebookController alloc] init];
        _isRetinaDisplay = [self isRetinaDisplayHandler];
        _databaseController = [[TBDatabaseController alloc] init];
        
        _facebookDataManager = [[TBFacebookDataManager alloc] initWithControllers:_facebookController and:_databaseController];
        
        _level = [[TBFirstLevelData alloc] init];
    }
    return self;
}

- (BOOL)isRetinaDisplayHandler
{
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        return [[UIScreen mainScreen] scale] == 2.0 ? YES : NO;
    }
    
    return NO;
}

-(TBFirstLevelData *)getCurrentLevelData
{
    return _level;
}

@end
