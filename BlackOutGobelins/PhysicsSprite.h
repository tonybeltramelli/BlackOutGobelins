//
//  PhysicsSprite.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 03/04/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"

@interface PhysicsSprite : CCSprite
{
	cpBody *body_;
}

-(void) setPhysicsBody:(cpBody*)body;

@end