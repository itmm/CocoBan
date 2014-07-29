/* Controller */

#import <Cocoa/Cocoa.h>

@class UserState;

@interface ApplicationDelegate: NSObject
{
}

- (NSApplicationTerminateReply) applicationShouldTerminate: (NSApplication *) app;
- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) app;

@end
