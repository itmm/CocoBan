/* WindowsDelegate */

#import <Cocoa/Cocoa.h>

@interface WindowsDelegate: NSObject
{
@private
  NSUndoManager *_undoManager;
}

@property (NS_NONATOMIC_IOSONLY, getter=isRevertable, readonly) BOOL revertable;

@end
