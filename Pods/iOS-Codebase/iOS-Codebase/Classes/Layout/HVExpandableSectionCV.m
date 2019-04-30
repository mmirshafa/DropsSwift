//
//  HVExpandableView.m
//  oncost
//
//  Created by Hamidreza Vakilian on 2/27/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "HVExpandableSectionCV.h"

@implementation HVExpandableSectionCV

-(instancetype)initWithLayoutDelegate:(id<HVExpandableLayoutDelegate>)layoutDelegate
{
    self = [super initWithFrame:CGRectZero collectionViewLayout:[HVExpandableLayout new]];
    if (self)
    {
        ((HVExpandableLayout*)(self.collectionViewLayout)).delegate = layoutDelegate;
    }
    return self;
}

//-(void)initialize
//{
//    [super initialize];
//
//
//
//
//    self.cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
//    if ([self.cv respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)])
//        self.cv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//
//    self.cv.contentInset = UIEdgeInsetsMake(_statusBarHeight + 44.0f, 0, 0, 0);
//
//    self.cv.delegate = self;
//    self.cv.dataSource = self;
//    self.cv.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    self.cv.translatesAutoresizingMaskIntoConstraints = NO;
//
//    [self addSubview:self.cv];
//
//    [self.cv sdc_alignEdgesWithSuperview:UIRectEdgeAll];
//    self.cv.alwaysBounceVertical = YES;
//
//    [self.cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ss"];
//
//    [self.cv registerClass:[sampleSup class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
//
//    self.dataset = [@[
//                     @{@"items": @[]},
//                     @{@"items": @[@1, @2, @3, @1, @2, @3, @1, @2, @3, @1, @2, @3]},
//                     @{@"items": @[@1, @2, @3, @4, @5, @6]},
//                     ] deepMutableCopy];
//
//
//    _mainThreadAfter(^{
//
//        [self.cv performBatchUpdates:^{
//            [self.dataset[0][@"items"] addObjectsFromArray:@[@11, @12, @13, @14, @15]];
////
//            [self.cv insertItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:0 inSection:0], [NSIndexPath indexPathForItem:1 inSection:0], [NSIndexPath indexPathForItem:2 inSection:0], [NSIndexPath indexPathForItem:3 inSection:0], [NSIndexPath indexPathForItem:4 inSection:0] ]];
////
//
////            [self.dataset[0][@"items"] addObjectsFromArray:@[@11]];
//
////            [self.cv insertItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:0 inSection:0] ]];
//
//        } completion:nil];
//
//
//
//        _mainThreadAfter(^{
//
//            [self.cv performBatchUpdates:^{
//                [self.dataset[0][@"items"] removeAllObjects];
//                //
//                [self.cv deleteItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:0 inSection:0], [NSIndexPath indexPathForItem:1 inSection:0], [NSIndexPath indexPathForItem:2 inSection:0], [NSIndexPath indexPathForItem:3 inSection:0], [NSIndexPath indexPathForItem:4 inSection:0] ]];
//                //
//
//                //            [self.dataset[0][@"items"] addObjectsFromArray:@[@11]];
//
//                //            [self.cv insertItemsAtIndexPaths:@[ [NSIndexPath indexPathForItem:0 inSection:0] ]];
//
//            } completion:nil];
//
//        }, 2);
//
//    }, 2);
//
//}

@end
