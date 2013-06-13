//
//  TBImageLoader.h
//  BlackOutGobelins
//
//  Created by tony's computer on 13/06/13.
//
//

#import <Foundation/Foundation.h>

@interface TBImageLoader : NSObject

- (id)initWithUrl:(NSString *)urlString at:(id)delegate andSelector:(SEL)selectorCallBack;
- (id)initWithUrl:(NSString *)urlString at:(id)delegate andSelector:(SEL)selectorCallBack needTexture:(BOOL)isTexture;

+(id)loaderWithUrl:(NSString *)urlString at:(id)delegate andSelector:(SEL)selectorCallBack;
+(id)loaderWithUrl:(NSString *)urlString at:(id)delegate andSelector:(SEL)selectorCallBack needTexture:(BOOL)isTexture;

-(void)loadPicture:(NSString *)urlString at:(id)delegate andSelector:(SEL)selectorCallBack;
-(void)loadPicture:(NSString *)urlString at:(id)delegate andSelector:(SEL)selectorCallBack needTexture:(BOOL)isTexture;

@end
