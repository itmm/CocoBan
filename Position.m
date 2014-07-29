//
//  Position.m
//  CocoBan
//
//  Created by Timm on 16.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Position.h"

@implementation Position

- (unsigned) hash {
  return (unsigned) (_col + _row * 100);
}

- (BOOL) isEqual: (id) other {
  if (![other isKindOfClass: [self class]]) {
    return NO;
  }
  Position *otherPosition = other;
  return (_col == otherPosition->_col && _row == otherPosition->_row);
}

- (id) copyWithZone: (NSZone *) zone {
  return [[Position allocWithZone: zone] initWithCol: _col row: _row];
}

- (Position *) initWithCol: (int) col row: (int) row {
  self = [super init];
  if (self) {
  	_col = col;
    _row = row;
  }
  return self;
}

+ (Position *) positionWithCol: (int) col row: (int) row {
  return [[Position alloc] initWithCol: col row: row];
}

- (int) col {
  return _col;
}

- (int) row {
  return _row;
}

@end
