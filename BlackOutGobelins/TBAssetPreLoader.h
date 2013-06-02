//
//  TBAssetPreLoader.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 01/06/13.
//
//

#import "cocos2d.h"

@interface TBAssetPreLoader : CCNode

- (void) load;
- (void) loadOnlySpritesheets:(BOOL)onlySpriteSheets andUsePVR:(BOOL)usePVR;

@end
