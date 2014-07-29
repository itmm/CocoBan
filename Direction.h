//
//  Direction.h
//  CocoBan
//
//  Created by Timm on 16.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Position;

@interface Direction: NSObject
{
@private
	Direction *_inverse;
  int _deltaCol;
  int _deltaRow;
}

+ (Direction *) directionUp;
+ (Direction *) directionDown;
+ (Direction *) directionRight;
+ (Direction *) directionLeft;

@property (NS_NONATOMIC_IOSONLY, readonly, strong) Direction *inverse;

- (Position *) positionMovedFrom: (Position *) position;

+ (Direction *) directionBetweenPosition: (Position *) from
    andPosition: (Position *) to;

@end
