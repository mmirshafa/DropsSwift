//
//  _weakContainer.m
//  DZNEmptyDataSet
//
//  Created by Hamidreza Vakilian on 1/6/1397 AP.
//

#import "_weakContainer.h"

@implementation _weakContainer

-(instancetype)initWithWeakObject:(id)object
{
    self = [super init];
    if (self)
    {
        self.weakObject = object;
    }
    return self;
}

@end
