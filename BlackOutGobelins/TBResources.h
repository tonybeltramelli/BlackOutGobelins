//
//  TBResources.h
//  BlackOut
//
//  Created by tony's computer on 06/02/13.
//
//

#import <Foundation/Foundation.h>

@interface TBResources : NSObject

extern const char *ASSETS_MAP_LEVEL1_TMX;
//
extern NSString *FUTURASTD_CONDENSEDLIGHT;

+ (NSString *)getAsset:(const char *)charName;
+ (void)printFontList;

@end
