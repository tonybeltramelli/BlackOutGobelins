//
//  TBCharacterNamePopin.m
//  BlackOutGobelins
//
//  Created by tony's computer on 20/05/13.
//
//

#import "TBCharacterNamePopin.h"
#import "cocos2d.h"

@implementation TBCharacterNamePopin
{
    CCLabelTTF *_nameLabel;
    CCLabelTTF *_similarFriendLabel;
}

- (id)initWithName:(NSString *)name similarFriendNumber:(int)friendNumber andPictureData:(NSData *)data
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
        
        [self hide];
    }
    return self;
}

- (void)dealloc
{
    _nameLabel = nil;
    _similarFriendLabel = nil;
    
    [super dealloc];
}

@end
