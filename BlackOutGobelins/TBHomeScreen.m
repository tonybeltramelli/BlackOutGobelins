//
//  TBHomeScreen.m
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 04/02/13.
//
//

#import "TBHomeScreen.h"

@implementation TBHomeScreen

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
	
	TBHomeScreen *layer = [TBHomeScreen node];
	[scene addChild: layer];
	
    return scene;
}

@end
