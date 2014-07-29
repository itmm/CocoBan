//
//  Cell.m
//  CocoBan
//
//  Created by Timm on 16.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"

#define FREE ' '
#define EARTH '-'
#define TARGET '.'
#define STONE '$'
#define GEM '*'
#define WALL '#'
#define PLAYER '@'
#define PLAYER_TARGET '+'

@implementation Cell

- (Cell *) initWithCode: (char) code {
  self = [super init];
  if (self) {
    _code = code;
  }
  return self;
}

- (NSString *) description {
  switch (_code) {
    case FREE: return @"empty cell";
    case EARTH: return @"earth cell";
    case TARGET: return @"empty target cell";
    case STONE: return @"stone cell";
    case GEM: return @"gem cell";
    case WALL: return @"wall cell";
    case PLAYER: return @"player cell";
    case PLAYER_TARGET: return @"player on target cell";
    default: [NSException raise: @"Cell" format: @"unknown code <%c>" arguments: _code];
  }
  return @"unknown cell";
}

+ (Cell *) cellFor: (char) code {
  return [[Cell alloc] initWithCode: code];
}

+ (Cell *) cell {
  return [Cell cellFor: EARTH];
}

- (BOOL) isWalkable {
  return _code == FREE || _code == TARGET;
}

- (BOOL) isMoveable {
  return _code == STONE || _code == GEM;
}

- (BOOL) isFree {
  return _code == FREE;
}

- (BOOL) isEarth {
  return _code == EARTH;
}

- (BOOL) isWall {
  return _code == WALL;
}

- (BOOL) isStone {
  return _code == STONE;
}

- (BOOL) isGem {
  return _code == GEM;
}

- (BOOL) isTarget {
  return _code == TARGET;
}

- (BOOL) isPlayer {
  return _code == PLAYER;
}

- (BOOL) isPlayerOnTarget {
  return _code == PLAYER_TARGET;
}

- (int) addStone {
  int stones = 0;
  switch (_code) {
    case FREE: _code = STONE; ++stones; break;
    case TARGET: _code = GEM; break;
    default: [NSException raise: @"addStone" format: @"can't add stone to <%@>", self];
  }
  return stones;
}

- (int) removeStone {
  int stones = 0;
  switch (_code) {
    case STONE: _code = FREE; ++stones; break;
    case GEM: _code = TARGET; break;
    default: [NSException raise: @"removeStone" format: @"can't remove stone from <%@>", self];
  }
  return stones;
}

- (void) addPlayer {
  switch (_code) {
    case FREE: _code = PLAYER; break;
    case TARGET: _code = PLAYER_TARGET; break;
    default: [NSException raise: @"addPlayer" format: @"can't add player to <%@>", self];
  }
}

- (void) removePlayer {
  switch (_code) {
    case PLAYER: _code = FREE; break;
    case PLAYER_TARGET: _code = TARGET; break;
    default: [NSException raise: @"removePlayer" format: @"can't remove player from <%@>", self];
  }
}

@end
