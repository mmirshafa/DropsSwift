//
//  HVExpandableView.h
//  oncost
//
//  Created by Hamidreza Vakilian on 2/27/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "HVExpandableLayout.h"

@interface HVExpandableSectionCV : UICollectionView
/**
 deprecated use initWithLayoutDelegate: instead

 @param frame the frame
 @param layout the layout
 @return the collectionview
 */
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout __attribute__ ((deprecated));


/**
 Use this init method only

 @param layoutDelegate delegat for the layout
 @return the collectionview
 */
-(instancetype)initWithLayoutDelegate:(id<HVExpandableLayoutDelegate>)layoutDelegate;


/**
  deprecated use initWithLayoutDelegate: instead

 @return the collectionview
 */
-(instancetype)init __attribute__ ((deprecated));

@end
