//
//  TBASets.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 31/05/13.
//
//

#import "CCLayer.h"
#import "TBConnectableElement.h"
#import "TBCharacterFace.h"

@interface TBASets : CCLayer <TBConnectableElement>
{
    TBCharacterFace *_currentFace;
    
    NSString *_prefix;
    
    BOOL _isDiscovered;
}

- (id)initWithPrefix:(NSString *)prefix;
-(void) drawAt:(CGPoint)pos;

@end
