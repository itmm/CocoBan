//
//  Direction.m
//  CocoBan
//
//  Created by Timm on 16.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Direction.h"
#import "Position.h"

@implementation Direction

enum Directions { up = 0, down = 1, right = 2, left = 3 };

+ (Direction *) directionFor: (int) direction withInverse: (int) inverse
{
  static Direction *_directions[4];
  static int _deltaCols[4] = {0, 0, 1, -1};
  static int _deltaRows[4] = {-1, 1, 0, 0};

  if (!_directions[direction])
  {
    _directions[direction] = [[Direction alloc] init];
    _directions[direction]->_inverse = [Direction directionFor: inverse withInverse: direction];
    _directions[direction]->_deltaCol = _deltaCols[direction];
    _directions[direction]->_deltaRow = _deltaRows[direction];
  }
  return _directions[direction];
}

+ (Direction *) directionUp
{
  return [Direction directionFor: up withInverse: down];
}

+ (Direction *) directionDown
{
  return [Direction directionFor: down withInverse: up];
}

+ (Direction *) directionRight
{
  return [Direction directionFor: right withInverse: left];
}

+ (Direction *) directionLeft
{
  return [Direction directionFor: left withInverse: right];
}

- (Direction *) inverse
{
  return _inverse;
}

- (Position *) positionMovedFrom: (Position *) position
{
  return [Position positionWithCol: [position col] + _deltaCol row: [position row] + _deltaRow];
}

+ (Direction *) directionBetweenPosition: (Position *) from
    andPosition: (Position *) to
{
  int deltaCol = [to col] - [from col];
  int deltaRow = [to row] - [from row];
  
  Direction *d = [Direction directionUp];
  if (d->_deltaCol == deltaCol && d->_deltaRow == deltaRow) { return d; }
  d = [Direction directionDown];
  if (d->_deltaCol == deltaCol && d->_deltaRow == deltaRow) { return d; }
  d = [Direction directionLeft];
  if (d->_deltaCol == deltaCol && d->_deltaRow == deltaRow) { return d; }
  d = [Direction directionRight];
  if (d->_deltaCol == deltaCol && d->_deltaRow == deltaRow) { return d; }
  
  return nil;
}

@end
