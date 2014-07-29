//
//  PathFinder.h
//  CocoBan
//
//  Created by Timm on 02.10.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Direction;
@class Level;
@class Position;

@interface PathFinder: NSObject
{
  Level *_level;
}

- (PathFinder *) initWithLevel: (Level *) level NS_DESIGNATED_INITIALIZER;
- (void) mayMove: (Direction *) direction from: (Position *) position map: (NSMutableDictionary *) map list: (NSMutableArray *) list;
- (NSArray *) findPathTo: (Position *) position;

@end
