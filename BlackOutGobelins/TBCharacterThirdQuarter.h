//
//  TBCharacter.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 09/05/13.
//
//

#import "TBCharacter.h"
#import "TBCharacterFace.h"

@interface TBCharacterThirdQuarter : TBCharacter
{
    NSString *_backRightAnimationName;
    NSString *_backLeftAnimationName;
    NSString *_frontRightAnimationName;
    NSString *_frontLeftAnimationName;
    
    TBCharacterFace *_backRightFace;
    TBCharacterFace *_backLeftFace;
    TBCharacterFace *_frontRightFace;
    TBCharacterFace *_frontLeftFace;
}

@end
