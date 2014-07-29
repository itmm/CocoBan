//
//  Level.m
//  CocoBan
//
//  Created by Timm on 16.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"
#import "Level.h"
#import "Direction.h"
#import "Position.h"

@implementation Level

- (Level *) initWithArray: (NSArray *) level undoManager: (NSUndoManager *) undoManager
{
  self = [super init];
  if (self)
  {
    _undoManager = undoManager;
    _stones = 0;
    _columns = 0;
    _rows = 0;
    _observer = nil;
    
    NSEnumerator *rows = [level objectEnumerator];
    NSString *row;
    NSMutableDictionary *cells = [NSMutableDictionary dictionary];
    while (row = [rows nextObject])
    {
      int colCount;
      for (colCount = 0; colCount < [row length]; ++colCount)
      {
        Position *position = [Position positionWithCol: colCount row: _rows];
        Cell *cell = [Cell cellFor: [row characterAtIndex: colCount]];
        if ([cell isPlayer] || [cell isPlayerOnTarget])
        {
          _playerPosition = position; 
        }
        if ([cell isStone])
        {
          ++_stones;
        }
        cells[position] = cell;
      }
      if (colCount > _columns)
      {
        _columns = colCount;
      }
      ++_rows;
    }
    _cells = [NSDictionary dictionaryWithDictionary: cells];
  }
  return self;
}

- (Level *) scratchLevel
{
  Level *result = [[Level alloc] init];
  result->_cells = _cells;
  result->_undoManager = nil;
  result->_playerPosition = _playerPosition;
  result->_stones = _stones;
  result->_columns = _columns;
  result->_rows = _rows;
  result->_observer = nil;
  return result;
}


- (void) addLevelObserver: (id) observer withSelector: (SEL) selector
{
  _observer = observer;
  _selector = selector;
}

- (void) levelChanged
{
  if (_observer)
  {
    IMP imp = [_observer methodForSelector: _selector];
    void (*func)(id, SEL) = (void *)imp;
    func(_observer, _selector);
  }
}

- (Cell *) cellAt: (Position *) position
{
  Cell *cell = _cells[position];
  if (cell == nil) 
  {
    cell = [Cell cell];
  }
  return cell;
}

- (BOOL) canWalkIn: (Direction *) direction
{
  Position *newPosition = [direction positionMovedFrom: _playerPosition];
  return [[self cellAt: newPosition] isWalkable];
}

- (BOOL) canPushIn: (Direction *) direction
{
  Position *newPlayerPosition = [direction positionMovedFrom: _playerPosition];
  if (![[self cellAt: newPlayerPosition] isMoveable])
  {
    return NO;
  }
  Position *newTargetPosition = [direction positionMovedFrom: newPlayerPosition];
  return [[self cellAt: newTargetPosition] isWalkable];
}

- (void) registerUndoAction: (SEL) action oldDirection: (Direction *) old
{
  if (!_undoManager)
  {
    return;
  }
  
  [_undoManager registerUndoWithTarget: self
                              selector: action
                                object: [old inverse]
  ];
  [_undoManager setActionName: NSLocalizedString(@"UndoMove", @"name of undo action")];
}

- (void) walkIn: (Direction *) direction
{
  if (![self canWalkIn: direction]) 
  {
    [NSException raise: @"walkIn" format: @"not walkable"]; 
  }
  
  Position *newPosition = [direction positionMovedFrom: _playerPosition];
  [[self cellAt: _playerPosition] removePlayer];
  [[self cellAt: newPosition] addPlayer];
  _playerPosition = newPosition;

  [self registerUndoAction: @selector(walkIn:) oldDirection: direction];  
  [self levelChanged];
}

- (void) pushIn: (Direction *) direction
{
  if (![self canPushIn: direction]) 
  {
    [NSException raise: @"pushIn" format: @"not pushable"]; 
  }
  
  Position *newPlayerPosition = [direction positionMovedFrom: _playerPosition];
  Position *newTargetPosition = [direction positionMovedFrom: newPlayerPosition];
  [[self cellAt: _playerPosition] removePlayer];
  Cell *newPlayerCell = [self cellAt: newPlayerPosition];
  _stones -= [newPlayerCell removeStone];
  [newPlayerCell addPlayer];
  _stones += [[self cellAt: newTargetPosition] addStone];
  
  _playerPosition = newPlayerPosition;
  
  [self registerUndoAction: @selector(pullIn:) oldDirection: direction];  
  [self levelChanged];
}

- (void) pullIn: (Direction *) direction
{
  Position *newPlayerPosition = [direction positionMovedFrom: _playerPosition];
  Cell *newPlayerCell = [self cellAt: newPlayerPosition];
  Position *oldTargetPosition = [[direction inverse] positionMovedFrom: _playerPosition];
  Cell *oldTargetCell = [self cellAt: oldTargetPosition];
  Cell *current = [self cellAt: _playerPosition];
  
  if (![newPlayerCell isWalkable] || ![oldTargetCell isMoveable])
  {
    [NSException raise: @"pullIn" format: @"not pullable"];
  }
  
  [current removePlayer];
  [newPlayerCell addPlayer];
  _stones -= [oldTargetCell removeStone];
  _stones += [current addStone];
  
  _playerPosition = newPlayerPosition;
  
  [self registerUndoAction: @selector(pushIn:) oldDirection: direction];  
  [self levelChanged];
}

- (void) handleDirection: (Direction *) direction
{
  if ([self canWalkIn: direction])
  {
    [self walkIn: direction];
  }
  else if ([self canPushIn: direction])
  {
    [self pushIn: direction];
  }
}

- (BOOL) finished
{
  return _stones == 0;
}

- (int) columns
{
  return _columns;
}

- (int) rows
{
  return _rows;
}

- (Position *) playerPosition
{
  return _playerPosition;
}

- (void) setPlayerPosition: (Position *) position
{
  if (position != _playerPosition)
  {
    _playerPosition = position;
  }
}

- (void) moveGhostDirection: (Direction *) direction
{
  [self showGhost];

  Position *newGhost = [direction positionMovedFrom: _ghost];
  _ghost = newGhost;
  [self levelChanged];
}

- (Position *) ghost
{
  return _ghost;
}

- (void) hideGhost
{
  if (_ghost)
  {
     _ghost = nil;
    [self levelChanged];
  }
}

- (void) showGhost
{
  if (!_ghost) { _ghost = _playerPosition; [self levelChanged]; }
}

@end
