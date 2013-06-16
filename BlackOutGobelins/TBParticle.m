//
//  TBParticle.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 10/05/13.
//
//

#import "TBParticle.h"

#import "CCParticleExamples.h"

static ccColor4F hexColorToRGBA(int hexValue, float alpha)
{
    float pRed = (hexValue & 0xFF0000) >> 16;
    float pGreen = (hexValue & 0xFF00) >> 8;
    float pBlue = (hexValue & 0xFF);
    
	return (ccColor4F) {pRed/255, pGreen/255, pBlue/255, alpha};
}

@implementation TBParticle
{
    float _counter;
}

-(id) initAt:(CGPoint)location with:(int)hexColor
{
    self = [super init];
    if (self) {
        CCParticleSystem *particle = [[CCParticleGalaxy alloc] initWithTotalParticles:120];
        [particle autorelease];
        [self addChild:particle];
        particle.position = location;
        particle.startColor = hexColorToRGBA(hexColor, 0.9f);
        particle.startSize = 10;
        particle.endSize = 1;
        particle.emissionRate = 120;
        particle.life = 0.5f;
        particle.duration = 0.5f;
        
        _value = 1.0f;
        
        [super startSchedule];
    }
    return self;
}

@end
