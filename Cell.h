//
//  Cell.h
//  CocoBan
//
//  Created by Timm on 16.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Cell: NSObject
{
  char _code;
}

+ (Cell *) cell;
+ (Cell *) cellFor: (char) code;

- (Cell *) initWithCode: (char) code NS_DESIGNATED_INITIALIZER;

@property (NS_NONATOMIC_IOSONLY, getter=isWalkable, readonly) BOOL walkable;
@property (NS_NONATOMIC_IOSONLY, getter=isMoveable, readonly) BOOL moveable;

@property (NS_NONATOMIC_IOSONLY, getter=isFree, readonly) BOOL free;
@property (NS_NONATOMIC_IOSONLY, getter=isEarth, readonly) BOOL earth;
@property (NS_NONATOMIC_IOSONLY, getter=isWall, readonly) BOOL wall;
@property (NS_NONATOMIC_IOSONLY, getter=isStone, readonly) BOOL stone;
@property (NS_NONATOMIC_IOSONLY, getter=isGem, readonly) BOOL gem;
@property (NS_NONATOMIC_IOSONLY, getter=isTarget, readonly) BOOL target;
@property (NS_NONATOMIC_IOSONLY, getter=isPlayer, readonly) BOOL player;
@property (NS_NONATOMIC_IOSONLY, getter=isPlayerOnTarget, readonly) BOOL playerOnTarget;

@property (NS_NONATOMIC_IOSONLY, readonly) int addStone;
@property (NS_NONATOMIC_IOSONLY, readonly) int removeStone;
- (void) addPlayer;
- (void) removePlayer;

@end
