//
//  NSMapTable+NSMapTableExtensions.h
//  deepfinity
//
//  Created by Hamidreza Vakilian on 12/26/1396 AP.
//  Copyright © 1396 nizek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMapTable (Extensions)

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id)key;

@end
