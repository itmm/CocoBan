//
//  Level.h
//  CocoBan
//
//  Created by Timm on 16.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Cell;
@class Direction;
@class Position;

@interface Level: NSObject
{
@private
  NSDictionary *_cells;
  NSUndoManager *_undoManager;
  Position *_playerPosition;
  int _stones;
  int _columns;
  int _rows;
  
  id _observer;
  SEL _selector;
  
  Position *_ghost;
}

- (void) addLevelObserver: (id) observer withSelector: (SEL) selector;
- (void) levelChanged;

- (Level *) initWithArray: (NSArray *) level undoManager: (NSUndoManager *) undoManager NS_DESIGNATED_INITIALIZER;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) Level *scratchLevel;

- (Cell *) cellAt: (Position *) position;

- (BOOL) canWalkIn: (Direction *) direction;
- (BOOL) canPushIn: (Direction *) direction;

- (void) registerUndoAction: (SEL) action oldDirection: (Direction *) old;
- (void) walkIn: (Direction *) direction;
- (void) pushIn: (Direction *) direction;
- (void) pullIn: (Direction *) direction;

- (void) handleDirection: (Direction *) direction;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL finished;

- (void) moveGhostDirection: (Direction *) direction;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) Position *ghost;
- (void) hideGhost;
- (void) showGhost;

@property (NS_NONATOMIC_IOSONLY, readonly) int columns;
@property (NS_NONATOMIC_IOSONLY, readonly) int rows;

@property (NS_NONATOMIC_IOSONLY, strong) Position *playerPosition;

@end
