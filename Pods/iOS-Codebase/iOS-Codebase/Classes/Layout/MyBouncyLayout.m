


#import "MyBouncyLayout.h"
#import <ReactiveObjC/ReactiveObjC.h>

const CGFloat DefaultScrollResistanceFactor = 900.0f;

const CGFloat DefaultSpringLength = 1.0f;
const CGFloat DefaultSpringDamping = 0.95f;
const CGFloat DefaultSpringFrequency = 1.0f;

@interface MyBouncyLayout () <UIDynamicAnimatorDelegate>


@end


@implementation MyBouncyLayout {
    
    CGFloat scrollResistanceFactor;
    
    NSMutableSet<NSIndexPath *> *visibleIndexPathsSet;
    NSMutableSet *visibleHeaderAndFooterSet;
    CGFloat latestDelta;
    
    /// The dynamic animator used to animate the collection's bounce
    UIDynamicAnimator *dynamicAnimator;
    RACSubject* pauseSubject;
    RACSubject* resumeSubject;
    RACSubject* statusSubject;
}

#pragma mark - LifeCycle

- (instancetype)initWithScrollResistance:(CGFloat)scrollResistance
{
    self = [super init];
    if (self)
    {
        scrollResistanceFactor = scrollResistance;
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

#pragma mark - Custom stuff

- (void)setup
{
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    dynamicAnimator.delegate = self;
    visibleIndexPathsSet = [[NSMutableSet<NSIndexPath*> alloc] init];
    visibleHeaderAndFooterSet = [[NSMutableSet alloc] init];
    
    pauseSubject = [RACSubject subject];
    resumeSubject = [RACSubject subject];
    statusSubject = [RACReplaySubject replaySubjectWithCapacity:1];
    [statusSubject sendNext:@false];
}

-(RACSignal *)pauseSignal
{
    return pauseSubject;
}

-(RACSignal *)resumeSignal
{
    return resumeSubject;
}

-(RACSignal *)statusSignal
{
    return statusSubject;
}

#pragma mark - Flow Layout override

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (!self.bouncingEnabled)
        return;
    
    // Need to overflow our actual visible rect slightly to avoid flickering.
    CGRect visibleRect = CGRectInset((CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size}, -100, -100);
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
    
    
    // Remove any behaviours that are no longer visible.
    NSArray<__kindof UIDynamicBehavior *> *noLongerVisibleBehaviours = [dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL (UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        return [itemsIndexPathsInVisibleRectSet containsObject:[(UICollectionViewLayoutAttributes *)[[behaviour items] firstObject] indexPath]] == NO;
    }]];
    
    [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [dynamicAnimator removeBehavior:obj];
        [visibleIndexPathsSet removeObject:[(UICollectionViewLayoutAttributes *)[[obj items] firstObject] indexPath]];
        [visibleHeaderAndFooterSet removeObject:[(UICollectionViewLayoutAttributes *)[[obj items] firstObject] indexPath]];
        
    }];
    
    // Add any newly visible behaviours.
    // A "newly visible" item is one that is in the itemsInVisibleRect(Set|Array) but not in the visibleIndexPathsSet
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL (UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        return (item.representedElementCategory == UICollectionElementCategoryCell ?
                [visibleIndexPathsSet containsObject:item.indexPath]:[visibleHeaderAndFooterSet containsObject:item.indexPath]) == NO;
    }]];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        
        springBehaviour.length = DefaultSpringLength;
        springBehaviour.damping = DefaultSpringDamping;
        springBehaviour.frequency = DefaultSpringFrequency;
        
        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(CGPointZero, touchLocation))
        {
            CGFloat scrollResistance;
            CGFloat distanceFromTouch;
            
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
            {
                distanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
                
                
                if (scrollResistanceFactor)
                {
                    scrollResistance = distanceFromTouch / scrollResistanceFactor;
                } else
                {
                    scrollResistance = distanceFromTouch / DefaultScrollResistanceFactor;
                }
                
                if (latestDelta < 0)
                {
                    center.y += MAX(latestDelta, latestDelta*scrollResistance);
                } else
                {
                    center.y += MIN(latestDelta, latestDelta*scrollResistance);
                }
                
                item.center = center;
                
            } else
            {
                distanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
                
                if (scrollResistanceFactor)
                {
                    scrollResistance = distanceFromTouch / scrollResistanceFactor;
                } else
                {
                    scrollResistance = distanceFromTouch / DefaultScrollResistanceFactor;
                }
                
                if (latestDelta < 0)
                {
                    center.x += MAX(latestDelta, latestDelta*scrollResistance);
                } else
                {
                    center.x += MIN(latestDelta, latestDelta*scrollResistance);
                }
                
            }
            item.center = center;
        }
        
        [dynamicAnimator addBehavior:springBehaviour];
        
        
//        springBehaviour.damping = 1;
//        springBehaviour.frequency = 0;
        
        if (item.representedElementCategory == UICollectionElementCategoryCell)
        {
            [visibleIndexPathsSet addObject:item.indexPath];
        } else
        {
            [visibleHeaderAndFooterSet addObject:item.indexPath];
        }
        
    }];
}

-(void)setBouncingEnabled:(BOOL)bouncingEnabled
{
    _bouncingEnabled = bouncingEnabled;
    
    NSLog(@"bouncing changeddddd to: %@", @(bouncingEnabled));
    
    if (bouncingEnabled)
    {
        [self invalidateLayout];
    }
    else
    {
        [visibleIndexPathsSet removeAllObjects];
        [visibleHeaderAndFooterSet removeAllObjects];
        [dynamicAnimator removeAllBehaviors];
                [self invalidateLayout];
    }
    
    
    
//    for (UIAttachmentBehavior* b in dynamicAnimator.behaviors) {
////        springBehaviour.length = DefaultSpringLength;
////        springBehaviour.damping = DefaultSpringDamping;
//        b.frequency = self.bouncingEnabled ? DefaultSpringFrequency : 0;
//    };
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.bouncingEnabled ? [dynamicAnimator itemsInRect:rect] : [super layoutAttributesForElementsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
if (self.bouncingEnabled)
{
    UICollectionViewLayoutAttributes *dynamicLayoutAttributes = [dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    
    return (dynamicLayoutAttributes) ? dynamicLayoutAttributes:[super layoutAttributesForItemAtIndexPath:indexPath];
}
    else
        return [super layoutAttributesForItemAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (self.bouncingEnabled)
    {
    UIScrollView *scrollView = self.collectionView;
    
    CGFloat delta;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        delta = newBounds.origin.y - scrollView.bounds.origin.y;
    } else
    {
        delta = newBounds.origin.x - scrollView.bounds.origin.x;
    }
    
    latestDelta = delta;
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)[springBehaviour.items firstObject];
        CGPoint center = item.center;
        CGFloat scrollResistance;
        CGFloat distanceFromTouch;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
        {
            distanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
            
            
            if (scrollResistanceFactor)
            {
                scrollResistance = distanceFromTouch / scrollResistanceFactor;
            } else
            {
                scrollResistance = distanceFromTouch / DefaultScrollResistanceFactor;
            }
            
            
            if (delta < 0)
                center.y += MAX(delta, delta*scrollResistance);
            else
                center.y += MIN(delta, delta*scrollResistance);
            
            
        } else
        {
            
            distanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
            
            if (scrollResistanceFactor)
            {
                scrollResistance = distanceFromTouch / scrollResistanceFactor;
            } else
            {
                scrollResistance = distanceFromTouch / DefaultScrollResistanceFactor;
            }
            
            if (delta < 0)
                center.x += MAX(delta, delta*scrollResistance);
            else
                center.x += MIN(delta, delta*scrollResistance);
            
        }
        
        item.center = center;
        [dynamicAnimator updateItemUsingCurrentState:item];
        
    }];
    
    return NO;
    }
    
    else
        return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

#pragma mark - UIDynamicAnimatorDelegate

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [statusSubject sendNext:@false];
    [pauseSubject sendNext:animator];
}

-(void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
    [statusSubject sendNext:@true];
    [resumeSubject sendNext:animator];
}

@end

