//
//  TBLineData.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 22/05/13.
//
//

#import "TBLineData.h"
#import "CCLabelTTF.h"
#import "TBModel.h"
#import "TBImageLoader.h"

@implementation TBLineData
{
    CCLabelTTF *_typeLabel;
    CCLabelTTF *_dataLabel;
    CCSprite *_image;
}

- (id)initWithType:(NSString *)type andData:(NSString *)data
{
    self = [super initWithColor:ccc4(255, 255, 255, 255)];
    if (self) {
        if(![type isEqualToString:@"image"])
        {
            [self setContentSize:CGSizeMake(100, 25)];
            
            _typeLabel = [CCLabelTTF labelWithString:type dimensions:self.contentSize hAlignment:NSTextAlignmentLeft fontName:@"Helvetica" fontSize:10.0f];
            _typeLabel.color = ccc3(100, 100, 100);
            [self formatText:type onLabel:_typeLabel];
            [self addChild:_typeLabel];
            
            _dataLabel = [CCLabelTTF labelWithString:data dimensions:self.contentSize hAlignment:NSTextAlignmentLeft fontName:@"Helvetica" fontSize:10.0f];
            _dataLabel.color = ccc3(0, 0, 0);
            [self formatText:data onLabel:_dataLabel];
            [self addChild:_dataLabel];
            
            [_typeLabel setPosition:CGPointMake(self.contentSize.width / 2 + 5, self.contentSize.height / 2)];
            [_dataLabel setPosition:CGPointMake(_typeLabel.position.x, self.contentSize.height / 2 - 12)]; 
        }else{
            [self setContentSize:CGSizeMake(30, 30)];
            
            [TBImageLoader loaderWithUrl:data at:self andSelector:@selector(imageIsLoaded:) needTexture:TRUE];
            
            _image = [[CCSprite alloc] initWithFile:@"default_facebook_profile_picture.jpg"];
            [_image setScale:[TBModel getInstance].isRetinaDisplay ? 1.0f : 0.5f];
            [_image setPosition:CGPointMake(self.contentSize.width / 2, self.contentSize.height / 2)];
            [self addChild:_image];
        }
    }
    return self;
}

-(void) formatText:(NSString *)text onLabel:(CCLabelTTF *)label
{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    CGSize realSize = [text sizeWithFont:font constrainedToSize:self.contentSize lineBreakMode:NSLineBreakByWordWrapping];
    
    while (realSize.width > 90 || realSize.height > 20) {
        text = [NSString stringWithFormat:@"%@…", [text substringWithRange:NSMakeRange(0, [text length] - 3)]];
        realSize = [text sizeWithFont:font constrainedToSize:self.contentSize lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    [label setString:text];
}

-(void) imageIsLoaded:(CCTexture2D *)texture
{
    if(!texture) return;
    
    [_image setTexture:texture];
}

- (void)dealloc
{
    _typeLabel = nil;
    _dataLabel = nil;
    
    [super dealloc];
}

@end
