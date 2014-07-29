#import "WindowsDelegate.h"

@implementation WindowsDelegate

- (WindowsDelegate *) init {
  self = [super init];
  if (self) {
    _undoManager = nil;
  }
  
  return self;
}

- (NSUndoManager *) undoManager {
  if (!_undoManager) {
    _undoManager = [[NSUndoManager alloc] init];
  }
  return _undoManager;
}

- (NSUndoManager *) windowWillReturnUndoManager: (NSWindow *) sender {
  return [self undoManager];
}

- (BOOL) isRevertable {
  return [[self undoManager] canUndo];
}

@end
