

//
//  TBBotData.m
//  BlackOutGobelins
//
//  Created by tony's computer on 08/06/13.
//
//

#import "TBBotData.h"

@implementation TBBotData
{
    NSString *_value;
    NSString *_type;
}

- (id)initWithValue:(NSString *)value andType:(NSString *)type
{
    self = [super init];
    if (self) {
        _value = value;
        _type = type;
    }
    return self;
}

+ (id)dataWithValue:(NSString *)value andType:(NSString *)type
{
    return [[[TBBotData alloc] initWithValue:value andType:type] autorelease];
}

-(NSString *)getValue
{
    return _value;
}

-(NSString *)getType
{
    return _type;
}

@end
