//
//  TBParticle.m
//  BlackOutGobelins
//
//  Created by tony's computer on 10/05/13.
//
//

#import "TBParticle.h"

#import "CCParticleExamples.h"

@implementation TBParticle
{
    float _counter;
}

-(id) initAt:(CGPoint)location with:(ccColor4F)color
{
    self = [super init];
    if (self) {
        CCParticleSystem *particle = [[CCParticleGalaxy alloc] initWithTotalParticles:200];
        [particle autorelease];
        [self addChild:particle];
        particle.position = location;
        particle.startColor = color;
        particle.startSize = 10;
        particle.endSize = 1;
        particle.emissionRate = 200;
        particle.life = 0.5f;
        particle.duration = 0.5f;
        
        _value = 1.0f;
        
        [super startSchedule];
    }
    return self;
}

@end
