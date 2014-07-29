/* GameView */

#import <Cocoa/Cocoa.h>

@class Level;
@class Map;
@class UserState;

@interface GameView : NSView
{
  @private
    Level *_currentLevel;
    Map *currentMap;
    UserState *userState;

    NSMutableArray *_futureMoves;
}

- (void) levelChanged;
- (void) newLevel;
- (void) checkNextLevel;

- (IBAction) revert: (id) sender;

- (void) noFutureMoves;
- (void) timerFired: (id) userInfo;
- (void) setupTimer;

@end
