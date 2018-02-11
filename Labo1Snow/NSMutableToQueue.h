//
//  NSMutableToQueue.h
//  Labo1Snow
//
//  Created by Mike on 2018-02-11.
//  Copyright © 2018 Turcotte, Michael. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end
