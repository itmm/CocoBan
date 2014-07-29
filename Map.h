//
//  Map.h
//  CocoBan
//
//  Created by Timm Knape on Sun Feb 20 2005.
//  Copyright (c) 2005 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Level;

@interface Map: NSObject
{
@private
  NSMutableArray *mapArray;
}

- (Level *) getLevel: (int) level undoManager: (NSUndoManager *) undoManager;
- (instancetype) initWithContentsOfURL: (NSURL *) url NS_DESIGNATED_INITIALIZER;

@end
