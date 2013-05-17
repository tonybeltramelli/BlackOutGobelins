//
//  TBCharacter.h
//  BlackOutGobelins
//
//  Created by tony's computer on 09/05/13.
//
//

#import "TBCharacter.h"
#import "TBCharacterFace.h"

@interface TBCharacterThirdQuarter : TBCharacter
{
    char *_back_right_animation_name;
    char *_back_left_animation_name;
    char *_front_right_animation_name;
    char *_front_left_animation_name;
    
    TBCharacterFace *_backRightFace;
    TBCharacterFace *_backLeftFace;
    TBCharacterFace *_frontRightFace;
    TBCharacterFace *_frontLeftFace;
}

@end
