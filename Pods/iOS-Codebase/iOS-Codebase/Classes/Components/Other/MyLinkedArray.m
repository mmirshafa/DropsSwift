//
//  MyLinkedArray.m
//  rac_tets
//
//  Created by Hamidreza Vakilian on 1/28/1397 AP.
//  Copyright © 1397 Hamidreza Vakilian. All rights reserved.
//

#import "MyLinkedArray.h"

typedef NSObject<MyLinkedObjectProtocol>* MyLinkedObject;

@interface MyLinkedArray ()
{
    NSMutableArray* theBackingStore;
}

//@property (retain, nonatomic) NSMutableArray* backingStore;
@end

@implementation MyLinkedArray

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        theBackingStore = [NSMutableArray new];
    }
    return self;
}

-(void)moveItemAtIndex:(NSUInteger)idx1 toIndex:(NSUInteger)idx2
{
    MyLinkedObject item = self.backingStore[idx1];
    [self removeObject:item];
    [self insertObject:item atIndex:idx2];
}

-(NSMutableArray *)backingStore
{
//    _mainThreadAfter(^{
//        [self __checkArrayLinksConsistency];
//    }, 5);
    
#ifdef DEBUG
//    _mainThreadAsync(^{
//        [self __checkArrayLinksConsistency];
//    });
    
#endif
    
    return theBackingStore;
}


#ifdef DEBUG
-(void)__checkArrayLinksConsistency
{
//    @synchronized(theBackingStore)
//    {    
    if (theBackingStore.count == 1)
    {
        MyLinkedObject obj = theBackingStore[0];
        NSAssert(obj.previousObject == nil, @"!?");
        NSAssert(obj.nextObject == nil, @"!?");
    }
    else if (theBackingStore.count > 1)
    {
        MyLinkedObject prev_item = theBackingStore[0];
        for (int i = 1; i < theBackingStore.count-1; i++)
        {
            MyLinkedObject thisObject = theBackingStore[i];
            NSAssert(prev_item.nextObject == thisObject, @"missssss");
            NSAssert(thisObject.previousObject == prev_item, @"mismatch!!!");
            prev_item = thisObject;
        }
        
        //prev item now it the object before the last object
        MyLinkedObject lastObject = theBackingStore.lastObject;
        NSAssert(prev_item.nextObject == lastObject, @"oh mismatch!");
        NSAssert(lastObject.previousObject == prev_item, @"oh mismatchhhhh!");
        NSAssert(lastObject.nextObject == nil, @"oh mismatchhhhheeddd!");
    }
//    }
}
#endif

-(id<MyLinkedObjectProtocol>)lastObject
{
//    @synchronized(theBackingStore)
//    {
    
    return self.backingStore.lastObject;
//    }
}

-(id<MyLinkedObjectProtocol>)firstObject
{
//    @synchronized(theBackingStore)
//    {
    
    return self.backingStore.firstObject;
//    }
}

-(void)addObject:(MyLinkedObject)anObject
{
#ifdef DEBUG
    NSAssert([anObject respondsToSelector:@selector(setNextObject:)], @"ahhhh! [!setNextObject:] whyy you are adding this idiot object to me!?");
    NSAssert([anObject respondsToSelector:@selector(setPreviousObject:)], @"ahhhh! [!setPreviousObject:] whyy you are adding this idiot object to me!?");
#endif
 
//    @synchronized(theBackingStore)
//    {
    [self.backingStore addObject:anObject];
    
    NSUInteger idx = [self indexOfObject:anObject];
    MyLinkedObject prevItem = [self getPrevItemWithIdx:idx];
    [prevItem setNextObject:anObject];
    
    [anObject setPreviousObject:prevItem];
    [anObject setNextObject:[self getNextItemWithIdx:idx]]; //obviously nil
//    }
    
//    NSLog(@"%s: %@", __FUNCTION__, self);
    
}

-(NSUInteger)indexOfObject:(id)anObject
{
//    @synchronized(theBackingStore)
//    {
    return [self.backingStore indexOfObject:anObject];
//    }
}

-(void)insertObjects:(NSArray<MyLinkedObject>*)array atIndex:(NSUInteger)idx
{
//    int i = 0;
//    for (MyLinkedObject anObject in array)
//        [self insertObject:anObject atIndex:i++];
    
    if (array.count <= 1)
        [self insertObject:array[0] atIndex:idx];
    else
    {
        MyLinkedObject nextItem = self.backingStore[idx];
        MyLinkedObject prevItem = nextItem.previousObject;
        
        array.firstObject.previousObject = prevItem;
        prevItem.nextObject = array.firstObject;
        
        array.lastObject.nextObject = nextItem;
        nextItem.previousObject = array.lastObject;
        
        MyLinkedObject lastObject = array.firstObject;
        [self.backingStore insertObject:lastObject atIndex:idx];
        
        for (int i = 1; i < array.count; i++)
        {
            array[i].previousObject = lastObject;
            lastObject.nextObject = array[i];
            lastObject = array[i];
            [self.backingStore insertObject:lastObject atIndex:idx+i];
        }
        
//        [self __checkArrayLinksConsistency];
    }
}

-(void)insertObject:(MyLinkedObject)anObject atIndex:(NSUInteger)idx
{
#ifdef DEBUG
    NSAssert([anObject respondsToSelector:@selector(setNextObject:)], @"ahhhh! [!setNextObject:] whyy you are adding this idiot object to me!?");
    NSAssert([anObject respondsToSelector:@selector(setPreviousObject:)], @"ahhhh! [!setPreviousObject:] whyy you are adding this idiot object to me!?");
#endif
    
//    @synchronized(theBackingStore)
//    {
    [self.backingStore insertObject:anObject atIndex:idx];
    
    MyLinkedObject prevItem = [self getPrevItemWithIdx:idx];
    MyLinkedObject nextItem = [self getNextItemWithIdx:idx];
    [prevItem setNextObject:anObject];
    
    [anObject setPreviousObject:prevItem];
    [anObject setNextObject:nextItem];
    
    [nextItem setPreviousObject:anObject];
//    }
    
//    NSLog(@"%s: %@", __FUNCTION__, self);
}

-(void)removeObject:(MyLinkedObject)anObject
{
#ifdef DEBUG
    NSAssert([anObject respondsToSelector:@selector(setNextObject:)], @"ahhhh! [!setNextObject:] whyy you are adding this idiot object to me!?");
    NSAssert([anObject respondsToSelector:@selector(setPreviousObject:)], @"ahhhh! [!setPreviousObject:] whyy you are adding this idiot object to me!?");
#endif
    
//    NSUInteger idx = [self indexOfObject:anObject];
//
//    MyLinkedObject prevItem = [self getPrevItemWithIdx:idx];
//    MyLinkedObject nextItem = [self getNextItemWithIdx:idx];
//
//    [prevItem setNextObject:nextItem];
//    [nextItem setPreviousObject:prevItem];
//
//    [self.backingStore removeObject:anObject];
    
    
    [self removeObjectAtIndex:[self indexOfObject:anObject]];
    
}

-(void)removeObjectAtIndex:(NSUInteger)idx
{
//    @synchronized(theBackingStore)
//    {
    MyLinkedObject prevItem = [self getPrevItemWithIdx:idx];
    MyLinkedObject nextItem = [self getNextItemWithIdx:idx];
    
    [prevItem setNextObject:nextItem];
    [nextItem setPreviousObject:prevItem];
    
    [self.backingStore removeObjectAtIndex:idx];
//    }
    
//    NSLog(@"%s: %@", __FUNCTION__, self);
}

-(void)addObjectsFromArray:(NSArray *)otherArray
{
    for (MyLinkedObject anObject in otherArray)
        [self addObject:anObject];
    
//    NSLog(@"%s: %@", __FUNCTION__, self);
}

-(void)removeLastObject
{
//    @synchronized(theBackingStore)
//    {
    id lastObject = [self.backingStore lastObject];
    if (lastObject)
    {
        NSUInteger idx = [self indexOfObject:lastObject];
        MyLinkedObject prevItem = [self getPrevItemWithIdx:idx];
        [prevItem setNextObject:nil];
    }
    
    [self.backingStore removeLastObject];
//    }
    
//    NSLog(@"%s: %@", __FUNCTION__, self);
}

-(void)replaceObjectAtIndex:(NSUInteger)idx withObject:(MyLinkedObject)anObject
{
//    @synchronized(theBackingStore)
//    {
    [self.backingStore replaceObjectAtIndex:idx withObject:anObject];
    
    MyLinkedObject prevItem = [self getPrevItemWithIdx:idx];
    MyLinkedObject nextItem = [self getNextItemWithIdx:idx];
    [prevItem setNextObject:anObject];
    
    [anObject setPreviousObject:prevItem];
    [anObject setNextObject:nextItem];
    
    [nextItem setPreviousObject:anObject];
//    }
//    NSLog(@"%s: %@", __FUNCTION__, self);
}

-(void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
    //    @synchronized(theBackingStore)
    //    {
    
    [self.backingStore exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    
    MyLinkedObject obj1 = self.backingStore[idx1];
    MyLinkedObject obj2 = self.backingStore[idx2];
    
    MyLinkedObject obj1_prev = [self getPrevItemWithIdx:idx1];
    MyLinkedObject obj1_next = [self getNextItemWithIdx:idx1];
    
    MyLinkedObject obj2_prev = [self getPrevItemWithIdx:idx2];
    MyLinkedObject obj2_next = [self getNextItemWithIdx:idx2];
    
    
    [obj2_prev setNextObject:obj2];
    [obj2_next setPreviousObject:obj2];
    
    [obj2 setPreviousObject:obj2_prev];
    [obj2 setNextObject:obj2_next];
    
    [obj1_prev setNextObject:obj1];
    [obj1_next setPreviousObject:obj1];
    
    [obj1 setNextObject:obj1_next];
    [obj1 setPreviousObject:obj1_prev];
    
//    [obj1_prev setNextObject:obj2];
//    [obj1_next setPreviousObject:obj2];
//
//    [obj2_prev setNextObject:obj1];
//    [obj2_next setPreviousObject:obj1];
//
//    [obj1 setPreviousObject:obj2_prev];
//    [obj1 setNextObject:obj2_next];
//
//    [obj2 setPreviousObject:obj1_prev];
//    [obj2 setNextObject:obj1_next];
    

    //    }
    
//    NSLog(@"%s: %@", __FUNCTION__, self);
}

-(void)exchangeObjectAtIndex2:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
//    @synchronized(theBackingStore)
//    {
    MyLinkedObject obj1 = self.backingStore[idx1];
    MyLinkedObject obj2 = self.backingStore[idx2];
    
    MyLinkedObject obj1_prev = [self getPrevItemWithIdx:idx1];
    MyLinkedObject obj1_next = [self getNextItemWithIdx:idx1];
    
    MyLinkedObject obj2_prev = [self getPrevItemWithIdx:idx2];
    MyLinkedObject obj2_next = [self getNextItemWithIdx:idx2];
    
    [obj1_prev setNextObject:obj2];
    [obj1_next setPreviousObject:obj2];
    
    [obj2_prev setNextObject:obj1];
    [obj2_next setPreviousObject:obj1];
        
        [obj1 setPreviousObject:obj2_prev];
        [obj1 setNextObject:obj2_next];
        
        [obj2 setPreviousObject:obj1_prev];
        [obj2 setNextObject:obj1_next];
    
    [self.backingStore exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
//    }
    
//    NSLog(@"%s: %@", __FUNCTION__, self);
}

//-(void)setNextPrevForItemAtIndex:(NSUInteger)idx
//{
//    NextPreviousIndexes idxs = [self getNextPreviousObjectIndexesForObjectWithIndex:idx];
//    id previousObj = nil;
//    id nextObj = nil;
//    if (idxs.previous_id > -1)
//        previousObj = self[idxs.previous_id];
//    if (idxs.next_id > -1)
//        nextObj = self[idxs.next_id];
//
//    MyLinkedObject obj = self[idx];
//    [obj setNextObject:nextObj];
//    [obj setPreviousObject:previousObj];
//}

-(NSUInteger)count
{
//    @synchronized(theBackingStore)
//    {
    return [self.backingStore count];
//}
}

-(id)getPrevItemWithIdx:(NSUInteger)idx
{
    NSInteger prev_idx = [self getPrevItemIdxWithIdx:idx];
    return (prev_idx > -1) ? self.backingStore[prev_idx] : nil;
    
}

-(NSInteger)getPrevItemIdxWithIdx:(NSUInteger)idx
{
    if (idx > 0)
        return idx-1;
    else
        return -1;
}

-(id)getNextItemWithIdx:(NSUInteger)idx
{
    NSInteger next_idx = [self getNextItemIdxWithIdx:idx];
    return (next_idx > -1) ? self.backingStore[next_idx] : nil;
}

-(NSInteger)getNextItemIdxWithIdx:(NSUInteger)idx
{
    if (idx < self.count-1)
        return idx+1;
    else
        return -1;
}


- (id)objectAtIndexedSubscript:(NSUInteger)index
{
//    @synchronized(theBackingStore)
//    {
    return [self.backingStore objectAtIndexedSubscript:index];
//    }
}

- (void)setObject:(MyLinkedObject)anObject atIndexedSubscript:(NSUInteger)idx
{
//    @synchronized(theBackingStore)
//    {
    [self.backingStore setObject:anObject atIndexedSubscript:idx];
    
    MyLinkedObject prevItem = [self getPrevItemWithIdx:idx];
    MyLinkedObject nextItem = [self getNextItemWithIdx:idx];
    [prevItem setNextObject:anObject];
    
    [anObject setPreviousObject:prevItem];
    [anObject setNextObject:nextItem];
    
    [nextItem setPreviousObject:anObject];
//    }
}

#ifdef DEBUG
-(NSString *)description
{
    return self.backingStore.description;
}
#endif

//-(NextPreviousIndexes)getNextPreviousObjectIndexesForObjectWithIndex:(NSUInteger)idx
//{
//    NextPreviousIndexes result;
//    if (idx > 0)
//        result.previous_id = idx-1;
//    else
//        result.previous_id = -1;
//
//    if (idx < self.count-1)
//        result.next_id = idx+1;
//    else
//        result.next_id = -1;
//
//    return result;
//}

@end
