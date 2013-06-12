//
//  TBFacebookUserDescriptor.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 15/05/13.
//
//

#import "TBFacebookUserDescriptor.h"

@implementation TBFacebookUserDescriptor
{
    NSData *_profilePicture;
}

@synthesize userId = _userId;
@synthesize name = _name;
@synthesize profilePictureUrl = _profilePictureUrl;
@synthesize location = _location;
@synthesize locationPictureUrl = _locationPictureUrl;
@synthesize companyName = _companyName;
@synthesize companyPictureUrl = _companyPictureUrl;
@synthesize positionName = _positionName;
@synthesize schoolName = _schoolName;
@synthesize schoolPictureUrl = _schoolPictureUrl;

const NSString *GRAPH_API_URL = @"http://graph.facebook.com";

- (id)initWithGraphUser:(NSDictionary<FBGraphUser> *)graphUser
{
    self = [super init];
    if (self) {
        _graphUser = [graphUser retain];
        
        _userId = _graphUser.id;
        _name = _graphUser.name;
        _profilePictureUrl = [[NSString alloc] initWithFormat:@"%@/%@/picture?type=large", GRAPH_API_URL, _userId];
        _location = _graphUser.location.name;
        _locationPictureUrl = [self getPictureFromPageId:_graphUser.location.id];
    }
    return self;
}

-(id)initWithDictionnary:(NSDictionary *)userData
{
    self = [super init];
    if (self) {
        _userId = [userData objectForKey:@"USER_ID"];
        _name = [userData objectForKey:@"USER_NAME"];
        _profilePictureUrl = [[NSString alloc] initWithFormat:@"%@/%@/picture?type=large", GRAPH_API_URL, _userId];
        _location = [userData objectForKey:@"USER_LOCATION"];
        _locationPictureUrl = [userData objectForKey:@"LOCATION_PICTURE_URL"];
        
        _companyName = [userData objectForKey:@"COMPANY_NAME"];
        _companyPictureUrl = [userData objectForKey:@"COMPANY_PICTURE_URL"];
        _positionName = [userData objectForKey:@"POSITION_NAME"];
        _schoolName = [userData objectForKey:@"SCHOOL_NAME"];
        _schoolPictureUrl = [userData objectForKey:@"SCHOOL_PICTURE_URL"];        
    }
    return self;
}

-(void)loadExtraData
{
    NSArray* worksData = [_graphUser objectForKey:@"work"];
    
    if([worksData count] >= 1)
    {
        FBGraphObject *work = [worksData objectAtIndex:0];
        
        NSDictionary *employer = [work objectForKey:@"employer"];
        NSString *employerName = [employer objectForKey:@"name"];
        
        NSDictionary *location = [work objectForKey:@"location"];
        NSString *locationName = [location objectForKey:@"name"];
        
        _companyName = [NSString stringWithFormat:@"%@ - %@", employerName, locationName];
        _companyPictureUrl = [self getPictureFromPageId:[employer objectForKey:@"id"]];
        
        NSDictionary *position = [work objectForKey:@"position"];
        _positionName = [position objectForKey:@"name"];
    }
    
    NSArray* educationsData = [_graphUser objectForKey:@"education"];
    
    if([educationsData count] >= 1)
    {
        FBGraphObject *education = [educationsData objectAtIndex:[educationsData count] - 1];
        
        NSDictionary *school = [education objectForKey:@"school"];
        _schoolName = [school objectForKey:@"name"];
        _schoolPictureUrl = [self getPictureFromPageId:[school objectForKey:@"id"]];
    }
}

-(NSString *) getPictureFromPageId:(NSString *)pageId
{
    return [NSString stringWithFormat:@"graph.facebook.com/%@/picture", pageId];
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
    _profilePicture = data;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PROFILE_PICTURE_LOADED" object:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
}

-(NSData *)getProfilePicture
{
    return _profilePicture;
}

- (void)dealloc
{
    _graphUser = nil;
    _profilePicture = nil;
    
    [super dealloc];
}

@end
