//
//  HVExpandableLayout.h
//  oncost
//
//  Created by Hamidreza Vakilian on 2/27/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//


#import "MyCollectionViewLayoutBase.h"

@protocol HVExpandableLayoutDelegate
-(CGFloat)HVExpandableLayoutHeightForHeaderAtSection:(NSUInteger)section;
-(CGFloat)HVExpandableLayoutHeightForItemAtIndexPath:(NSIndexPath*)indexPath;
-(CGFloat)HVExpandableLayoutItemsSpacing;
-(CGFloat)HVExpandableLayoutHeaderBottomSpacing;
@end

@interface HVExpandableLayout : MyCollectionViewLayoutBase

@property (weak, nonatomic) id<HVExpandableLayoutDelegate> delegate;

@end
