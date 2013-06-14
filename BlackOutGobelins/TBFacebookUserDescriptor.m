//
//  TBFacebookUserDescriptor.m
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 15/05/13.
//
//

#import "TBFacebookUserDescriptor.h"

@implementation TBFacebookUserDescriptor

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
@synthesize age = _age;
@synthesize bio = _bio;
@synthesize isDoorOpen = _isDoorOpen;

const NSString *GRAPH_API_URL = @"http://graph.facebook.com";

- (id)initWithGraphUser:(NSDictionary<FBGraphUser> *)graphUser
{
    self = [super init];
    if (self) {
        _graphUser = [graphUser retain];
        
        _userId = _graphUser.id;
        _name = _graphUser.name;
        _profilePictureUrl = [self getPictureFromId:_userId];
        _location = _graphUser.location.name;
        _locationPictureUrl = [self getPictureFromId:_graphUser.location.id];
        _isDoorOpen = FALSE;
    }
    return self;
}

-(id)initWithDictionnary:(NSDictionary *)userData
{
    self = [super init];
    if (self) {
        _userId = [userData objectForKey:@"USER_ID"];
        _name = [userData objectForKey:@"USER_NAME"];
        _profilePictureUrl = [self getPictureFromId:_userId];
        _location = [userData objectForKey:@"USER_LOCATION"];
        _locationPictureUrl = [userData objectForKey:@"LOCATION_PICTURE_URL"];
        
        _companyName = [userData objectForKey:@"COMPANY_NAME"];
        _companyPictureUrl = [userData objectForKey:@"COMPANY_PICTURE_URL"];
        _positionName = [userData objectForKey:@"POSITION_NAME"];
        _schoolName = [userData objectForKey:@"SCHOOL_NAME"];
        _schoolPictureUrl = [userData objectForKey:@"SCHOOL_PICTURE_URL"];
        _age = [(NSString *)[userData objectForKey:@"AGE"] integerValue];
        _bio = [userData objectForKey:@"BIO"];
        _isDoorOpen = [(NSString *)[userData objectForKey:@"IS_DOOR_OPEN"] boolValue];
    }
    return self;
}

-(void)loadExtraData
{
    NSString* birthday = [_graphUser objectForKey:@"birthday"];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"mm/dd/yyyy"];
   
    NSDate *birthdayDate = [[[NSDate alloc] init] autorelease];
    birthdayDate = [dateFormatter dateFromString:birthday];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:birthdayDate toDate:now options:0];
    
    _age = [ageComponents year];
    _bio = [_graphUser objectForKey:@"bio"];
    
    NSArray* worksData = [_graphUser objectForKey:@"work"];
    
    if([worksData count] >= 1)
    {
        FBGraphObject *work = [worksData objectAtIndex:0];
        
        NSDictionary *employer = [work objectForKey:@"employer"];
        NSString *employerName = [employer objectForKey:@"name"];
        
        NSDictionary *location = [work objectForKey:@"location"];
        NSString *locationName = [location objectForKey:@"name"];
        
        _companyName = [NSString stringWithFormat:@"%@ - %@", employerName, locationName];
        _companyPictureUrl = [self getPictureFromId:[employer objectForKey:@"id"]];
        
        NSDictionary *position = [work objectForKey:@"position"];
        _positionName = [position objectForKey:@"name"];
    }
    
    NSArray* educationsData = [_graphUser objectForKey:@"education"];
    
    if([educationsData count] >= 1)
    {
        FBGraphObject *education = [educationsData objectAtIndex:[educationsData count] - 1];
        
        NSDictionary *school = [education objectForKey:@"school"];
        _schoolName = [school objectForKey:@"name"];
        _schoolPictureUrl = [self getPictureFromId:[school objectForKey:@"id"]];
    }
}

-(NSString *) getPictureFromId:(NSString *)userId
{
    return [[NSString alloc] initWithFormat:@"%@/%@/picture", GRAPH_API_URL, userId];
}

- (void)dealloc
{
    _graphUser = nil;
    
    [super dealloc];
}

@end
