//
//  TBLineData.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 22/05/13.
//
//

#import "TBLineData.h"
#import "CCLabelTTF.h"

@implementation TBLineData
{
    CCLabelTTF *_typeLabel;
    CCLabelTTF *_dataLabel;
}

- (id)initWithType:(NSString *)type andData:(NSString *)data
{
    self = [super initWithColor:ccc4(255, 255, 255, 255)];
    if (self) {
        [self setContentSize:CGSizeMake(100, 25)];
        
        _typeLabel = [CCLabelTTF labelWithString:type dimensions:self.contentSize hAlignment:NSTextAlignmentLeft fontName:@"Helvetica" fontSize:10.0f];
        _typeLabel.color = ccc3(100, 100, 100);
        [self addChild:_typeLabel];
        
        _dataLabel = [CCLabelTTF labelWithString:data dimensions:self.contentSize hAlignment:NSTextAlignmentLeft fontName:@"Helvetica" fontSize:10.0f];
        _dataLabel.color = ccc3(0, 0, 0);
        [self addChild:_dataLabel];
        
        [_typeLabel setPosition:CGPointMake(self.contentSize.width / 2 + 5, self.contentSize.height / 2)];
        [_dataLabel setPosition:CGPointMake(_typeLabel.position.x, self.contentSize.height / 2 - 12)];
    }
    return self;
}

- (void)dealloc
{
    _typeLabel = nil;
    _dataLabel = nil;
    
    [super dealloc];
}

@end
