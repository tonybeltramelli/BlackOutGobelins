//
//  TBBotData.h
//  BlackOutGobelins
//
//  Created by tony's computer on 08/06/13.
//
//

#import <Foundation/Foundation.h>

@interface TBBotData : NSObject

-(id)initWithValue:(NSString *)value andType:(NSString *)type;

+(id)dataWithValue:(NSString *)value andType:(NSString *)type;

-(NSString *)getValue;
-(NSString *)getType;

@end
