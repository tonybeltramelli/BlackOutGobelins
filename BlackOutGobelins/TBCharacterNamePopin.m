//
//  TBCharacterNamePopin.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 20/05/13.
//
//

#import "TBCharacterNamePopin.h"
#import "cocos2d.h"
#import "TBImageLoader.h"
#import "TBModel.h"

@implementation TBCharacterNamePopin
{
    CCLabelTTF *_nameLabel;
    CCLabelTTF *_similarFriendLabel;
    CCSprite *_image;
}

- (id)initWithName:(NSString *)name similarFriendNumber:(int)friendNumber andPictureUrl:(NSString *)url
{
    self = [super initWithSize:CGSizeMake(160, 50)];
    if (self)
    {
        CGSize size = CGSizeMake(_size.width - 50, _size.height);
        
        NSString *userName = [name length] > 16 ? [NSString stringWithFormat:@"%@…", [name substringWithRange:NSMakeRange(0, 14)]] : name;
        
        _nameLabel = [CCLabelTTF labelWithString:userName dimensions:size hAlignment:NSTextAlignmentLeft fontName:@"Helvetica" fontSize:14.0f];
        [self addChild:_nameLabel];
        
        _similarFriendLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d %@", friendNumber, NSLocalizedString(@"POPIN_CHARACTER_SIMILAR_FRIEND", nil)] dimensions:size hAlignment:NSTextAlignmentLeft fontName:@"Helvetica" fontSize:10.0f];
        [self addChild:_similarFriendLabel];
        
        [_nameLabel setPosition:CGPointMake(20, -5)];
        [_similarFriendLabel setPosition:CGPointMake(20, _nameLabel.position.y - 20)];
        
        [TBImageLoader loaderWithUrl:url at:self andSelector:@selector(imageIsLoaded:) needTexture:TRUE];
        
        _image = [[CCSprite alloc] initWithFile:@"default_facebook_picture.jpg"];
        [_image setScale:[TBModel getInstance].isRetinaDisplay ? 1.0f : 0.5f];
        [_image setPosition:CGPointMake(-_size.width / 2 + _image.contentSize.width * _image.scale, CGPointZero.y)];
        [self addChild:_image];
        
        [self hide];
    }
    return self;
}

-(void) imageIsLoaded:(CCTexture2D *)texture
{
    if(!texture) return;
    
    [_image setTexture:texture];
    [_image setScale:[TBModel getInstance].isRetinaDisplay ? 1.0f : 0.5f];
    [_image setPosition:CGPointMake(-_size.width / 2 + _image.contentSize.width * _image.scale, CGPointZero.y)];
}

- (void)dealloc
{
    _nameLabel = nil;
    _similarFriendLabel = nil;
    
    [_image release];
    _image = nil;
    
    [super dealloc];
}

@end
