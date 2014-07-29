//
//  Map.m
//  CocoBan
//
//  Created by Timm Knape on Sun Feb 20 2005.
//  Copyright (c) 2005 __MyCompanyName__. All rights reserved.
//

#import "Map.h"
#import "Level.h"

#define MAP_ROWS_KEY @"Map Rows"

@implementation Map

- (instancetype) initWithContentsOfURL: (NSURL *) url {
    self = [super init];
    if (self) {
        NSString *errorString;
        NSPropertyListFormat format;
        NSData *xmlData = [NSData dataWithContentsOfURL: url];
        mapArray = [NSPropertyListSerialization
            propertyListFromData: xmlData
            mutabilityOption: NSPropertyListMutableContainersAndLeaves
            format: &format
            errorDescription: &errorString];
    }
    return self;
}

- (Level *) getLevel: (int) level undoManager: (NSUndoManager *) undoManager {
  NSArray *array = mapArray[level][MAP_ROWS_KEY];
  return [[Level alloc] initWithArray: array undoManager: undoManager];
}

@end


