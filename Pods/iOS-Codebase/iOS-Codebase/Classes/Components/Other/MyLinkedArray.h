//
//  MyLinkedArray.h
//  rac_tets
//
//  Created by Hamidreza Vakilian on 1/28/1397 AP.
//  Copyright © 1397 Hamidreza Vakilian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyLinkedObjectProtocol

@property (weak, nonatomic) id previousObject;
@property (weak, nonatomic) id nextObject;
//-(void)setNextObject:(id)anObject;
//-(void)setPreviousObject:(id)anObject;
@end

@interface MyLinkedArray <__covariant ValueType> : NSObject

@property (nullable, nonatomic, readonly) ValueType<MyLinkedObjectProtocol> firstObject;
@property (nullable, nonatomic, readonly) ValueType<MyLinkedObjectProtocol> lastObject;

-(NSUInteger)indexOfObject:(ValueType<MyLinkedObjectProtocol>)anObject;
-(void)addObject:(ValueType<MyLinkedObjectProtocol>)anObject;
-(void)addObjectsFromArray:(NSArray<ValueType<MyLinkedObjectProtocol>> *)otherArray;
-(void)insertObjects:(NSArray<ValueType<MyLinkedObjectProtocol>> *)array atIndex:(NSUInteger)idx;
-(void)insertObject:(ValueType<MyLinkedObjectProtocol>)anObject atIndex:(NSUInteger)idx;
-(void)removeObject:(ValueType<MyLinkedObjectProtocol>)anObject;
-(void)removeObjectAtIndex:(NSUInteger)idx;
-(void)removeLastObject;
-(NSUInteger)count;
-(void)replaceObjectAtIndex:(NSUInteger)idx withObject:(ValueType<MyLinkedObjectProtocol>)anObject;
-(void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
-(void)moveItemAtIndex:(NSUInteger)idx1 toIndex:(NSUInteger)idx2;
- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(ValueType<MyLinkedObjectProtocol>)obj atIndexedSubscript:(NSUInteger)idx;

@end
