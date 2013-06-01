//
//  TBAssetPreLoader.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 01/06/13.
//
//

#import "TBAssetPreLoader.h"
#import "TBModel.h"
#import "TBProgressBar.h"

@implementation TBAssetPreLoader
{
    NSMutableArray *_textures;
    
    TBProgressBar *_progressBar;
    
    int _numberOfLoadedTextures;
    BOOL _onlySpritesheets;
}

- (id)init
{
    self = [super init];
    if (self) {
        _progressBar = [[TBProgressBar alloc] init];
        [self addChild:_progressBar];
        
        _onlySpritesheets = false;
    }
    return self;
}

- (void) load
{    
    NSError *error;
    NSArray *bundleContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath] error:&error];
    
    _textures = [[NSMutableArray alloc] initWithCapacity:[bundleContents count]];
    
    for(NSString *file in bundleContents)
    {
        if([[file pathExtension] compare:@"png"] == NSOrderedSame)
        {
            NSString *fileName = [file stringByDeletingPathExtension];
            NSString* splittedString = [fileName substringWithRange:NSMakeRange([fileName length] - 3, 3)];
            
            if([[TBModel getInstance] isRetinaDisplay])
            {
                if([splittedString isEqualToString:@"@2x"])
                {
                    [_textures addObject:[file lastPathComponent]];
                }
            }else{
                if(![splittedString isEqualToString:@"@2x"])
                {
                    [_textures addObject:[file lastPathComponent]];
                }
            }
        }
    }
    
    _numberOfLoadedTextures = 0;
    
    [[CCTextureCache sharedTextureCache] addImageAsync:[_textures objectAtIndex:_numberOfLoadedTextures] target:self selector:@selector(imageDidLoad:)];
}

- (void) loadOnlySpritesheets
{
    _onlySpritesheets = true;
    
    [self load];
}

- (void) imageDidLoad:(CCTexture2D*)tex
{
    NSString *plistFile = [[(NSString*)[_textures objectAtIndex:_numberOfLoadedTextures] stringByDeletingPathExtension] stringByAppendingString:@".plist"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:plistFile]])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistFile];
        NSLog(@"loading %@", plistFile);
    }else if(_onlySpritesheets){
        [[CCTextureCache sharedTextureCache] removeTextureForKey:(NSString*)[_textures objectAtIndex:_numberOfLoadedTextures]];
    }
    
    _numberOfLoadedTextures++;
    
    [_progressBar setProgress:(float)_numberOfLoadedTextures / (float)[_textures count]];
                                                       
    if(_numberOfLoadedTextures == [_textures count])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PRELOADING_COMPLETE" object:nil];
    }else{
        [[CCTextureCache sharedTextureCache] addImageAsync:[_textures objectAtIndex:_numberOfLoadedTextures] target:self selector:@selector(imageDidLoad:)];
    }
}

- (void)dealloc
{
    [_textures release];
    _textures = nil;
    
    [super dealloc];
}

@end
