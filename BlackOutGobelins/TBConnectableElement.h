//
//  TBConnectableElement.h
//  BlackOutGobelins
//
//  Created by Tony BELTRAMELLI on 31/05/13.
//
//

#import <Foundation/Foundation.h>

@protocol TBConnectableElement <NSObject>

-(void) connectionOnRange:(BOOL)isOnRange;
-(CGPoint) getPosition;
-(CGSize) getSize;

@end
