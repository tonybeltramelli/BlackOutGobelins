//
//  TBSimpleItem.m
//  Cocos2DChipmunkScaffold
//
//  Created by Tony BELTRAMELLI on 20/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBSimpleItem.h"

@implementation TBSimpleItem
{
    CCRepeatForever *_baseAnimation;
    NSString *_atlasFormat;
    int _startNumber;
    int _endNumber;
    float _delay;
    float _elasticity;
    float _friction;
    float _mass;
}

@synthesize sprite = _sprite;
@synthesize body = _body;
@synthesize shape = _shape;

- (id)init
{
    self = [super init];
    if (self) {
        _elasticity = 0.5f;
        _friction = 0.5f;
        _mass = 1.0f;
    }
    return self;
}

-(void) drawAt:(CGPoint)pos
{
    //override this method to custom the item initialization
    //look at TBHero.m and TBMonster.m for examples
}

-(void) setPhysicProperties:(float)mass andFriction:(float)friction andElasticity:(float)elasticity
{
    _mass = mass;
    _friction = friction;
    _elasticity = elasticity;
}

-(void) buildWithImage:(NSString *)name
{
    [self buildWithImage:name at:cpv(0,0)];
}

-(void) buildWithImage:(NSString *)name at:(CGPoint)pos
{
    _sprite = [PhysicsSprite spriteWithSpriteFrameName:name];
    [self buildIt:pos];
    [self setPosition:pos];
}

-(void) buildWithImage:(NSString *)name andAnimateWith:(NSString *)atlasFormat with:(int)imageNumber
{
    [self buildWithImage:name andAnimateWith:atlasFormat with:imageNumber andDelay:0.05f];
}

-(void) buildWithImage:(NSString *)name andAnimateWith:(NSString *)atlasFormat with:(int)imageNumber andDelay:(float)delay
{
    [self buildWithImage:name];
    [self setAnimation:atlasFormat with:imageNumber andDelay:delay];
}

-(void) buildWithImage:(NSString *)name at:(CGPoint)pos andAnimateWith:(NSString *)atlasFormat with:(int)imageNumber
{
    [self buildWithImage:name at:pos andAnimateWith:atlasFormat with:imageNumber andDelay:0.05f];
}

-(void) buildWithImage:(NSString *)name at:(CGPoint)pos andAnimateWith:(NSString *)atlasFormat with:(int)imageNumber andDelay:(float)delay
{
    [self buildWithImage:name at:pos];
    [self setAnimation:atlasFormat with:imageNumber andDelay:delay];
}

-(void) buildWithImage:(NSString *)name at:(CGPoint)pos andAnimateWith:(NSString *)atlasFormat startAt:(int)imageStartNumber endAt:(int)imageEndNumber andDelay:(float)delay
{
    [self buildWithImage:name at:pos];
    [self setAnimation:atlasFormat startAt:imageStartNumber andEnd:imageEndNumber andDelay:delay];
}

-(void) buildIt:(CGPoint)pos
{
    int num = 4;
	cpVect verts[] = {
		cpv(- _sprite.contentSize.width / 2, - _sprite.contentSize.height / 2),
		cpv(- _sprite.contentSize.width / 2, _sprite.contentSize.height / 2),
		cpv(_sprite.contentSize.width / 2, _sprite.contentSize.height / 2),
		cpv(_sprite.contentSize.width / 2, - _sprite.contentSize.height / 2),
	};
    
    _body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
	cpBodySetPos(_body, pos);
    cpBodySetMass(_body, _mass);
    
    _shape = cpPolyShapeNew(_body, num, verts, CGPointZero);
	cpShapeSetElasticity(_shape, _elasticity);
	cpShapeSetFriction(_shape, _friction);
	
    [_sprite setPhysicsBody:_body];
}

-(void) setAnimation:(NSString *)atlasFormat startAt:(int)startNumber andEnd:(int)endNumber andDelay:(float)delay
{
    [self stop];
    
    _delay = delay;
    
    _atlasFormat = atlasFormat;
    [_atlasFormat retain];
    
    _startNumber = startNumber;
    _endNumber = endNumber;
    
    NSMutableArray *animFrames = [[NSMutableArray alloc] init];
    [animFrames autorelease];
    for (int i = _startNumber; i <= _endNumber; i++) {
        NSString *number = i < 10 ? [NSString stringWithFormat:@"0%d", i] : [NSString stringWithFormat:@"%d", i];
        NSString *frameName = [NSString stringWithFormat:atlasFormat, number];
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [animFrames addObject:frame];
    }
	
    CCAnimation *anim = [CCAnimation animationWithSpriteFrames:animFrames delay:delay];
    _baseAnimation = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:anim]];
    
    [atlasFormat release];
    [_sprite runAction:_baseAnimation];
}

-(void) setAnimation:(NSString *)atlasFormat with:(int)imageNumber andDelay:(float)delay
{
    [self setAnimation:atlasFormat startAt:0 andEnd:imageNumber andDelay:delay];
}

-(void) setAnimation:(NSString *)atlasFormat with:(int)imageNumber
{
    [self setAnimation:atlasFormat with:imageNumber andDelay:0.05f];
}

-(void) setAnimationDelay:(float)delay
{
    [self setAnimation:_atlasFormat startAt:_startNumber andEnd:_endNumber andDelay:delay];
}

-(void) play
{
    [self setAnimation:_atlasFormat startAt:_startNumber andEnd:_endNumber andDelay:_delay];
}

-(void) stop
{
    [_sprite stopAllActions];
}

-(void) setPosition:(CGPoint)pos
{
    _sprite.position = pos;
    cpBodySetPos(_body, pos);
}

-(CGPoint) getPosition
{
    return _body->p;
}

-(void) setX:(CGFloat)xPos
{
    [self setPosition:cpv(xPos, [self getY])];
}

-(CGFloat) getX
{
    return [self getPosition].x;
}

-(void) setY:(CGFloat)yPos
{
    [self setPosition:cpv([self getX], yPos)];
}

-(CGFloat) getY
{
    return [self getPosition].y;
}

-(CGSize) getSize
{
    return _sprite.contentSize;
}

-(CGFloat) getWidth
{
    return [self getSize].width;
}

-(CGFloat) getHeight
{
    return [self getSize].height;
}

- (void) dealloc
{
    [self stop];
    
    _sprite = nil;
    _baseAnimation = nil;
    _atlasFormat = nil;
    
    cpShapeFree(_shape);
    _shape = nil;
    cpBodyFree(_body);
    _body = nil;
    
	[super dealloc];
}

@end
