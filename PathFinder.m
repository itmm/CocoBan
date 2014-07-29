//
//  PathFinder.m
//  CocoBan
//
//  Created by Timm on 02.10.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PathFinder.h"
#import "Level.h"
#import "Position.h"
#import "Direction.h"

@implementation PathFinder

- (PathFinder *) initWithLevel: (Level *) level {
  self = [super init];
  if (self) {
    _level = [level scratchLevel];    
  }
  return self;
}


- (void) mayMove: (Direction *) direction from: (Position *) position map: (NSMutableDictionary *) map list: (NSMutableArray *) list {
  Position *newPos = [direction positionMovedFrom: position];
  if (map[newPos] != nil) { return; }
  if (![_level canWalkIn: direction]) { return; }
  map[newPos] = [direction inverse];
  [list addObject: newPos];
}

- (NSArray *) findPathTo: (Position *) position {
  Position *init = [_level playerPosition];
  NSMutableDictionary *visitedPositions = [NSMutableDictionary dictionary];
  NSMutableArray *positionsToGo = [NSMutableArray arrayWithObject: init];
  
  while ([positionsToGo count] > 0) {
    Position *current = positionsToGo[0];
    [positionsToGo removeObjectAtIndex: 0];
    if ([current isEqual: position]) {
      [positionsToGo removeAllObjects];
      while (![current isEqual: init]) {
        Direction *backtrack = visitedPositions[current];
        current = [backtrack positionMovedFrom: current];
        [positionsToGo insertObject: [backtrack inverse] atIndex: 0];
      }
      return positionsToGo;
    }
    [_level setPlayerPosition: current];
    [self mayMove: [Direction directionUp] from: current map: visitedPositions list: positionsToGo];
    [self mayMove: [Direction directionDown] from: current map: visitedPositions list: positionsToGo];
    [self mayMove: [Direction directionLeft] from: current map: visitedPositions list: positionsToGo];
    [self mayMove: [Direction directionRight] from: current map: visitedPositions list: positionsToGo];
  }
  
  return nil;
}

@end
