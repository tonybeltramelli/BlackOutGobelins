//
//  TBResources.m
//  BlackOut
//
//  Created by tony's computer on 06/02/13.
//
//

#import "TBResources.h"
#import "TBModel.h"

@implementation TBResources

const char *ASSETS_MAP_LEVEL1_TMX = "map_level1.tmx";
//
NSString *FUTURASTD_CONDENSEDLIGHT = @"FuturaStd-CondensedLight";

+ (NSString *)getRetinaName:(NSString*)name
{
    NSString *fileName = [name stringByDeletingPathExtension];
    NSString *fileExtension = [name pathExtension];
    return [NSString stringWithFormat:@"%@@2x.%@", fileName, fileExtension];
}

+ (NSString *)getAsset:(const char *)charName
{
    NSString *name = [NSString stringWithUTF8String:charName];
    return [[TBModel getInstance] isRetinaDisplay] ? [self getRetinaName:name] : name;
}

+ (void)printFontList
{
    NSMutableArray *fontNames = [[NSMutableArray alloc] init];
    NSArray *fontFamilyNames = [UIFont familyNames];
    
    for (NSString *familyName in fontFamilyNames)
    {
        NSLog(@"-----> Font Family Name = %@", familyName);
        
        NSArray *names = [UIFont fontNamesForFamilyName:familyName];
        
        NSLog(@"-----> Font Names = %@", fontNames);
        
        [fontNames addObjectsFromArray:names];
    }
    
    [fontNames release];
}

@end
