#import "GameView.h"
#import "Map.h"
#import "UserState.h"
#import "Level.h"
#import "Cell.h"
#import "Position.h"
#import "PathFinder.h"
#import "Direction.h"

#define MAP_FILE_NAME @"map"
#define MAP_FILE_TYPE @"plist"

#define CELL_WIDTH 32
#define CELL_HEIGHT 32

@implementation GameView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if ((self = [super initWithFrame:frameRect]) != nil) {
        NSString *plistPath = [[NSBundle mainBundle]
            pathForResource: MAP_FILE_NAME ofType: MAP_FILE_TYPE
        ];
        NSURL *plistURL = [NSURL fileURLWithPath: plistPath];
        currentMap = [[Map alloc] initWithContentsOfURL: plistURL];
        
        userState = [[UserState alloc] init];
        currentMap = [[Map alloc] initWithContentsOfURL: [NSURL fileURLWithPath: [userState getCurrentMapName]]];
        
        _currentLevel = nil;
    }
    return self;
}

- (NSRect) rectForMapCellAtColumn: (int) col row: (int) row {
    return NSMakeRect(col * CELL_WIDTH, row * CELL_HEIGHT, CELL_WIDTH, CELL_HEIGHT);
}

- (void)drawRect:(NSRect)rect {
  int row, col;

  if (!_currentLevel) {
    _currentLevel = [currentMap getLevel: [userState getLevel] undoManager: [[self window] undoManager]];
    [_currentLevel addLevelObserver: self withSelector: @selector(levelChanged)];
    [self newLevel];
    [[self window] setFrameAutosaveName: @"windowFrame"];
  }

  int columns = [_currentLevel columns];
  int rows = [_currentLevel rows];    
  Position *ghost = [_currentLevel ghost];
  
  for (row = 0; row < rows; ++row) {
    for (col = 0; col < columns; ++col) {
      NSRect cellRect = [self rectForMapCellAtColumn: col row: rows - row - 1];
      Position *pos = [Position positionWithCol: col row: row];
      Cell *cell = [_currentLevel cellAt: pos];
      if ([cell isStone]) {
        [[NSColor orangeColor] set];
        [NSBezierPath fillRect: cellRect];            
      } else if ([cell isGem]) {
        [[NSColor yellowColor] set];
        [NSBezierPath fillRect: cellRect];            
      } else if ([cell isTarget]) {
        [[NSColor blueColor] set];
        [NSBezierPath fillRect: cellRect];            
      } else if ([cell isWall]) {
        [[NSColor blackColor] set];
        [NSBezierPath fillRect: cellRect];
      } else if ([cell isEarth]) {
        [[NSColor brownColor] set];
        [NSBezierPath fillRect: cellRect];
      } else if ([cell isPlayer] || [cell isPlayerOnTarget]) {
        [[NSColor blackColor] set];
        NSBezierPath* playerPath = [[NSBezierPath alloc] init];
        [playerPath appendBezierPathWithOvalInRect: cellRect];
        [playerPath stroke];
      }
      
      if (ghost && [ghost isEqual: pos]) {
        [[NSColor blackColor] set];
        NSBezierPath* playerPath = [[NSBezierPath alloc] init];
        NSRect small = NSInsetRect(cellRect, 4, 4);
        [playerPath appendBezierPathWithOvalInRect: small];
        [playerPath stroke];
      }
    }
  }
}

- (void) levelChanged { [self setNeedsDisplay: YES]; }

- (void) newLevel {
  [self noFutureMoves];
  [[[self window] undoManager] removeAllActions];
  _currentLevel = [currentMap getLevel: [userState getLevel] undoManager: [[self window] undoManager]];
  [_currentLevel addLevelObserver: self withSelector: @selector(levelChanged)];
  
  NSRect frame = [[self window] frame];
  float width = [_currentLevel columns] * CELL_WIDTH - [self bounds].size.width;
  float height = [_currentLevel rows] * CELL_HEIGHT - [self bounds].size.height;
  frame.size.width += width;
  frame.size.height += height;
  frame.origin.x -= width/2; if (frame.origin.x < 0) { frame.origin.x = 0; }
  frame.origin.y -= height/2; if (frame.origin.y < 0) { frame.origin.y = 0; }
  
  [[self window] setFrame: frame display: YES animate: YES];
  [self setNeedsDisplay: YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self newLevel];
}

- (void) checkNextLevel {
  if ([_currentLevel finished]) {
    [userState nextLevel];
    [self newLevel];
  }
}

- (void) flagsChanged: (NSEvent *) theEvent {
  BOOL shift = ([theEvent modifierFlags] & NSShiftKeyMask) != 0;
  Position *ghost = [_currentLevel ghost];
  
  if (!shift) {
    if (ghost) {
      PathFinder *finder = [[PathFinder alloc] initWithLevel: _currentLevel];
      [self noFutureMoves];
      _futureMoves = [[NSMutableArray alloc] initWithArray:[finder findPathTo: ghost]];
      [_currentLevel hideGhost];
      [self setupTimer];  
    }
  } else {
    if (!ghost) {
      [_currentLevel showGhost];
    }
  }  
}

- (void) keyDown: (NSEvent *) theEvent {
  NSString *keys = [theEvent charactersIgnoringModifiers];
    
  [self noFutureMoves];
    
  if (keys && [keys length] > 0) {
    BOOL shift = ([theEvent modifierFlags] & NSShiftKeyMask) != 0;
    Direction *dir = nil;
    switch ([keys characterAtIndex: 0]) {
      case NSUpArrowFunctionKey: case 'k': case 'K':
        dir = [Direction directionUp]; break;
      case NSDownArrowFunctionKey: case 'j': case 'J':
        dir = [Direction directionDown]; break;
      case NSLeftArrowFunctionKey: case 'h': case 'H':
        dir = [Direction directionLeft]; break;
      case NSRightArrowFunctionKey: case 'l': case 'L':
        dir = [Direction directionRight]; break;
    }

    if (dir) {
      if (shift) {
        [_currentLevel moveGhostDirection: dir];
      } else {
        [_currentLevel handleDirection: dir];
        [self checkNextLevel];
      }
      return;
    }
  }

  [super keyDown: theEvent];
}

- (void) noFutureMoves {
  if (_futureMoves) {
    _futureMoves = nil;
  }
}

- (void) timerFired: (id) userInfo {
  if (_futureMoves && [_futureMoves count] > 0) {
    Direction *dir = _futureMoves[0];
    [_futureMoves removeObjectAtIndex: 0];
    [_currentLevel walkIn: dir];
    [self setupTimer];
  } else {
    [self noFutureMoves];
  }
}

- (void) setupTimer {
  if (_futureMoves && [_futureMoves count] > 0) {
    [NSTimer scheduledTimerWithTimeInterval: 0.05 target: self selector: @selector(timerFired:) userInfo: nil repeats: NO];
  } else {
    [self noFutureMoves];
  }
}

- (void) mouseDown: (NSEvent *) theEvent {
  int rows = [_currentLevel rows];

  NSPoint location = [self 
    convertPoint: [theEvent locationInWindow] 
    fromView: nil];
    
  Position *pos = [Position
    positionWithCol: location.x / CELL_WIDTH 
    row: rows - location.y / CELL_HEIGHT];
  
  PathFinder *finder = [[PathFinder alloc] initWithLevel: _currentLevel];
  [self noFutureMoves];
  _futureMoves = [[NSMutableArray alloc] initWithArray:[finder findPathTo: pos]];
  [self setupTimer];
  
  if (!_futureMoves) {
    // maybe we can move one stone?
    
    Direction *d = [Direction
      directionBetweenPosition: [_currentLevel playerPosition]
      andPosition: pos];
    
    if (d) {
      if ([_currentLevel canPushIn: d]) {
        [_currentLevel pushIn: d];
        [self checkNextLevel];
      }
    }
  }
}

- (BOOL) acceptsFirstResponder { return YES; }

- (IBAction) revert: (id) sender { [self newLevel]; }

@end
