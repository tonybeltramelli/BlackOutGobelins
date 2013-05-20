//
//  TBSpecial.h
//  BlackOutGobelins
//
//  Created by tony's computer on 10/05/13.
//
//

#import "CCSprite.h"

@interface TBSpecial : CCSprite
{
    float _value;
    float _decrementer;
}

-(void) startSchedule;
-(void) complete;

@end
