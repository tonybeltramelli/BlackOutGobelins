//
//  TBCharacterData.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 29/05/13.
//
//

#import <Foundation/Foundation.h>

#import "TBFacebookFriendDescriptor.h"

@interface TBCharacterData : NSObject

- (id)initWithDescriptor:(TBFacebookFriendDescriptor *)descriptor andDialog:(NSString *)dialog;

-(TBFacebookFriendDescriptor *)getDescriptor;
-(NSString *)getDialog;

@end
