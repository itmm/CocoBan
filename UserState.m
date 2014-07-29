//
//  UserState.m
//  CocoBan
//
//  Created by Timm Knape on Sat Mar 05 2005.
//  Copyright (c) 2005 __MyCompanyName__. All rights reserved.
//

#import "UserState.h"
#import "Map.h"

@implementation UserState

- (instancetype) init  {
  self = [super init];
  if (self) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultMapPath = [[NSBundle mainBundle]
      pathForResource: @"map" ofType: @"plist"
    ];
    
    NSDictionary *defaultsDictionary = @{@"CurrentMap": defaultMapPath,
      @"CurrentLevel": @0};
    [defaults registerDefaults: defaultsDictionary];
    
    currentMap = [defaults valueForKey: @"CurrentMap"];
    currentLevel = [defaults integerForKey: @"CurrentLevel"];
  }
  return self; 
}

- (NSString *) getCurrentMapName { return currentMap; }

- (int) getLevel { return currentLevel; }

- (void) setCurrentMapName: (NSString *) name {
  currentMap = name;
  currentLevel = 0;

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setInteger: currentLevel forKey: @"CurrentLevel"];
  [defaults setObject: currentMap forKey: @"CurrentMap"];
}

- (void) nextLevel {
  ++currentLevel;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setInteger: currentLevel forKey: @"CurrentLevel"];
}

@end
