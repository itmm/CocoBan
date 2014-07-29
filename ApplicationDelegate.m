#import "ApplicationDelegate.h"
#import "UserState.h"

@implementation ApplicationDelegate

- (NSApplicationTerminateReply) applicationShouldTerminate: (NSApplication *) app {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults synchronize];
  
  return NSTerminateNow;
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) app {
  return YES;
}

@end
