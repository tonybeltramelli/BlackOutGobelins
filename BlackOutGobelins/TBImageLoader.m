//
//  TBImageLoader.m
//  BlackOutGobelins
//
//  Created by tony's computer on 13/06/13.
//
//

#import "TBImageLoader.h"
#import "CCTexture2D.h"

@implementation TBImageLoader
{
    id _delegate;
    SEL _selectorCallBack;
    BOOL _isTexture;
}

- (id)initWithUrl:(NSString *)urlString at:(id)delegate andSelector:(SEL)selectorCallBack needTexture:(BOOL)isTexture
{
    self = [super init];
    if (self) {
        [self loadPicture:urlString at:delegate andSelector:selectorCallBack needTexture:isTexture];
    }
    return self;
}

- (id)initWithUrl:(NSString *)urlString at:(id)delegate andSelector:(SEL)selectorCallBack
{
    self = [self initWithUrl:urlString at:delegate andSelector:selectorCallBack needTexture:FALSE];
    if (self) {
    }
    return self;
}

+(id)loaderWithUrl:(NSString *)urlString at:(id)delegate andSelector:(SEL)selectorCallBack
{
    return [[[TBImageLoader alloc] initWithUrl:urlString at:delegate andSelector:selectorCallBack] autorelease];
}

+(id)loaderWithUrl:(NSString *)urlString at:(id)delegate andSelector:(SEL)selectorCallBack needTexture:(BOOL)isTexture
{
    return [[[TBImageLoader alloc] initWithUrl:urlString at:delegate andSelector:selectorCallBack needTexture:isTexture] autorelease];
}

-(void)loadPicture:(NSString *)urlString at:(id)delegate andSelector:(SEL)selectorCallBack needTexture:(BOOL)isTexture
{
    _delegate = delegate;
    _selectorCallBack = selectorCallBack;
    _isTexture = isTexture;
    
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:2];
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                     delegate:self];
    if (!urlConnection) NSLog(@"Failed to download picture");
}

-(void)loadPicture:(NSString *)urlString at:(id)delegate andSelector:(SEL)selectorCallBack
{
    [self loadPicture:urlString at:delegate andSelector:selectorCallBack needTexture:FALSE];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(!_isTexture)
    {
        [_delegate performSelector:_selectorCallBack withObject:data];
    }else{
        CFDataRef imageData = (CFDataRef)data;
        CGDataProviderRef imageDataProvider = CGDataProviderCreateWithCFData (imageData);
        CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(imageDataProvider, NULL, true, kCGRenderingIntentDefault);
        
        CCTexture2D *texture = [[CCTexture2D alloc] initWithCGImage:imageRef resolutionType:kCCResolutionUnknown];
        
        [_delegate performSelector:_selectorCallBack withObject:texture];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
}

@end
