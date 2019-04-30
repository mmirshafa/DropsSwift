//
//  HVExpandableLayout.m
//  oncost
//
//  Created by Hamidreza Vakilian on 2/27/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "HVExpandableLayout.h"
#import "Codebase_definitions.h"

@interface HVExpandableLayout ()
@property (retain, nonatomic) NSMutableArray* insertIndexPaths;
@property (retain, nonatomic) NSMutableArray* deleteIndexPaths;
@end

@implementation HVExpandableLayout

-(void)initialize
{
    [super initialize];
    
    self.insertIndexPaths = [NSMutableArray new];
    self.deleteIndexPaths = [NSMutableArray new];
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    // Keep track of insert and delete index paths
    [super prepareForCollectionViewUpdates:updateItems];
    
    for (UICollectionViewUpdateItem *update in updateItems)
    {
        if (update.updateAction == UICollectionUpdateActionDelete)
        {
            [self.deleteIndexPaths addObject:update.indexPathBeforeUpdate];
        }
        else if (update.updateAction == UICollectionUpdateActionInsert)
        {
            [self.insertIndexPaths addObject:update.indexPathAfterUpdate];
        }
    }
}

- (void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];
    // release the insert and delete index paths
    [self.deleteIndexPaths removeAllObjects];
    [self.insertIndexPaths removeAllObjects];
}

-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attr = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.deleteIndexPaths containsObject:itemIndexPath])
    {
        UICollectionViewLayoutAttributes* headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:itemIndexPath.section]];
        
        attr.alpha = 0.0f;
        
        //        attr.zIndex = -1000;
        
        attr.frame = CGRectSetY(attr, CGRectGetMaxY(headerAttributes.frame) + [self.delegate HVExpandableLayoutHeaderBottomSpacing]);
        
        return attr;
    }
    else
    {
        return attr;
    }
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes* attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertIndexPaths containsObject:itemIndexPath])
    {
        UICollectionViewLayoutAttributes* headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:itemIndexPath.section]];
        
        attr.alpha = 0.0f;
        
//        attr.zIndex = -1000;
        
        attr.frame = CGRectSetY(attr, CGRectGetMaxY(headerAttributes.frame) + [self.delegate HVExpandableLayoutHeaderBottomSpacing]);
        
        return attr;
    }
    else
    {
        return attr;
    }
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return true;
}

-(void)prepareLayout
{
    
    self.layoutAttributes = [self dicForLayoutAttributes];
    [self.layoutAttributes removeAllObjects];
    
    NSUInteger numberOfSections = [self.collectionView numberOfSections];
    
    if (numberOfSections == 0)
    {
        self.contentSize = CGSizeZero;
        return;
    }
    
//    UIEdgeInsets initial_insets = [self.delegate initialCollectionViewInsets];
    
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat cv_height = self.collectionView.frame.size.height;
    
    CGFloat items_vertical_spacing = [self.delegate HVExpandableLayoutItemsSpacing];
    CGFloat header_bottom_spacing = [self.delegate HVExpandableLayoutHeaderBottomSpacing];
    
    // LOAD CELL ATTRIBUTES
    CGFloat yOffset = 0;
    CGFloat xOffset = 0;
    
    BOOL currentSectionSet = false;
    NSUInteger currentSection = 0;
    
    
    
    CGFloat currentPoint = self.collectionView.contentOffset.y + self.collectionView.contentInset.top;

    
    NSUInteger sections = [self.collectionView numberOfSections];
    
    

    
    
    for (int i = 0; i < sections; i++)
    {
        
            CGFloat thisSectionStartPoint = yOffset;
        
        NSIndexPath* sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:i];

        UICollectionViewLayoutAttributes* att = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionIndexPath];

        CGFloat header_height = [self.delegate HVExpandableLayoutHeightForHeaderAtSection:i];
        
        att.frame = CGRectMake(xOffset, yOffset, width, header_height);
        
        att.zIndex = i*10000+100;

        yOffset += header_height + header_bottom_spacing;
        
//        if (yOffset > self.collectionView.contentOffset.y)

        NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < numberOfItems; j++)
        {
            NSIndexPath* itemIndexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            UICollectionViewLayoutAttributes* attributes = [self attributesForIndexPath:itemIndexPath];
            
            CGFloat itemHeight = [self.delegate HVExpandableLayoutHeightForItemAtIndexPath:itemIndexPath];
            
            attributes.frame = CGRectMake(xOffset, yOffset, width, itemHeight);
            
            attributes.zIndex = i*100+j;
            
            yOffset += itemHeight + items_vertical_spacing;
        }
        
        if (!currentSectionSet && currentPoint >= thisSectionStartPoint && currentPoint < yOffset)
        {
            currentSectionSet = true;
            currentSection = i;
        }
        
    }
    
    //determine which section we are on? --> currentSection
    //sticky header
    NSIndexPath* sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:currentSection];
    UICollectionViewLayoutAttributes* att = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionIndexPath];
    
    att.frame = CGRectSetY(att, MAX(currentPoint, 0));
    
    NSLog(@"section: %lu", currentSection);
    
//    NSLog(@"yoffset: %f/ height: %f", yOffset, cv_height);
    
    self.contentSize = CGSizeMake(width, yOffset);
    
}



@end
