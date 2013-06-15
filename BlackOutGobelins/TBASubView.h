//
//  TBASubView.h
//  BlackOutGobelins
//
//  Created by Tony Beltramelli on 15/04/13.
//
//

#import <UIKit/UIKit.h>

@interface TBASubView : UIView <NSURLConnectionDelegate>
{
    BOOL _isShown;
}

-(void) build;
-(void) show;

@end
