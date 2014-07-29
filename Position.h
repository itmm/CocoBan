//
//  Position.h
//  CocoBan
//
//  Created by Timm on 16.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Position: NSObject <NSCopying>
{
@private
  int _col;
  int _row;
}

@property (NS_NONATOMIC_IOSONLY, readonly) unsigned int hash;
- (BOOL) isEqual: (id) other;
- (id) copyWithZone: (NSZone *) zone;

- (Position *) initWithCol: (int) col row: (int) row NS_DESIGNATED_INITIALIZER;
+ (Position *) positionWithCol: (int) col row: (int) row;

@property (NS_NONATOMIC_IOSONLY, readonly) int col;
@property (NS_NONATOMIC_IOSONLY, readonly) int row;

@end
