//
//  UserState.h
//  CocoBan
//
//  Created by Timm Knape on Sat Mar 05 2005.
//  Copyright (c) 2005 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserState : NSObject
{
@private
  NSString *currentMap;
  int currentLevel;
}

@property (NS_NONATOMIC_IOSONLY, getter=getCurrentMapName, copy) NSString *currentMapName;
@property (NS_NONATOMIC_IOSONLY, getter=getLevel, readonly) int level;
- (void) nextLevel;

@end
