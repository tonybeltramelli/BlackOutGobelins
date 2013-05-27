//
//  TBFacebookUserDescriptor.m
//  BlackOutGobelins
//
//  Created by tony's computer on 15/05/13.
//
//

#import "TBFacebookUserDescriptor.h"

@implementation TBFacebookUserDescriptor
{
    NSData *profilePicture;
}

@synthesize userId = _userId;
@synthesize name = _name;
@synthesize profilePictureUrl = _profilePictureUrl;

const NSString *GRAPH_API_URL = @"http://graph.facebook.com";

- (id)initWithGraphUser:(NSDictionary<FBGraphUser> *)graphUser
{
    self = [super init];
    if (self) {
        _graphUser = [graphUser retain];
        
        _userId = _graphUser.id;
        _name = _graphUser.name;
        _profilePictureUrl = [NSString stringWithFormat:@"%@/%@/picture?type=large", GRAPH_API_URL, _userId];
    }
    return self;
}

-(id)initWithDictionnary:(NSDictionary *)userData
{
    self = [super init];
    if (self) {
        _userId = [userData objectForKey:@"USER_ID"];
        _name = [userData objectForKey:@"USER_NAME"];
        _profilePictureUrl = [NSString stringWithFormat:@"%@/%@/picture?type=large", GRAPH_API_URL, _userId];
    }
    return self;
}

-(void)loadProfilePicture
{
    [self loadPicture:_profilePictureUrl];
}

-(void)loadPicture:(NSString *)urlString
{    
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:2];
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                     delegate:self];
    if (!urlConnection) NSLog(@"Failed to download picture");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{    
    profilePicture = data;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PROFILE_PICTURE_LOADED" object:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
}

-(NSData *)getProfilePicture
{
    return profilePicture;
}

@end
