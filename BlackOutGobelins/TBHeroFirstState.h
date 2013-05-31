//
//  TBHeroFirstState.h
//  BlackOut
//
//  Created by tony's computer on 06/02/13.
//
//

#import "TBCharacterTransition.h"

@interface TBHeroFirstState : TBCharacterTransition

-(BOOL)isOnHeroRange:(id<TBConnectableElement>)element;

@end
