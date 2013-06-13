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
}

- (id)initWithName:(NSString *)name similarFriendNumber:(int)friendNumber andPictureUrl:(NSString *)url
{
    self = [super initWithSize:CGSizeMake(200, 50)];
    if (self)
    {
        CGSize size = CGSizeMake(_size.width - 50, _size.height);
        
        _nameLabel = [CCLabelTTF labelWithString:name dimensions:size hAlignment:NSTextAlignmentLeft fontName:@"Helvetica" fontSize:14.0f];
        [self addChild:_nameLabel];
        
        _similarFriendLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d %@", friendNumber, NSLocalizedString(@"POPIN_CHARACTER_SIMILAR_FRIEND", nil)] dimensions:size hAlignment:NSTextAlignmentLeft fontName:@"Helvetica" fontSize:10.0f];
        [self addChild:_similarFriendLabel];
        
        [_nameLabel setPosition:CGPointMake(50, -5)];
        [_similarFriendLabel setPosition:CGPointMake(50, _nameLabel.position.y - 20)];
        
        [TBImageLoader loaderWithUrl:url at:self andSelector:@selector(imageIsLoaded:) needTexture:TRUE];
        
        [self hide];
    }
    return self;
}

-(void) imageIsLoaded:(CCTexture2D *)texture
{
    CCSprite *image = [CCSprite spriteWithTexture:texture];
    [image setScale:[TBModel getInstance].isRetinaDisplay ? 1.0f : 0.5f];
    [image setPosition:CGPointMake(-_size.width / 2 + image.contentSize.width * image.scale, CGPointZero.y)];
    [self addChild:image];
}

- (void)dealloc
{
    _nameLabel = nil;
    _similarFriendLabel = nil;
    
    [super dealloc];
}

@end
