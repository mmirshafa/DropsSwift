//
//  _weakContainer.h
//  DZNEmptyDataSet
//
//  Created by Hamidreza Vakilian on 1/6/1397 AP.
//

#import <Foundation/Foundation.h>

@interface _weakContainer : NSObject

@property (weak, nonatomic) NSObject* weakObject;

-(instancetype)initWithWeakObject:(id)object;

@end
