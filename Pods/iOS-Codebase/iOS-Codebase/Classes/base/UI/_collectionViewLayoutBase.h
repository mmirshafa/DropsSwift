//
//  MyCollectionViewLayoutBase.h
//  Prediscore
//
//  Created by Hamidreza Vaklian on 7/31/16.
//  Copyright © 2016 pxlmind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _collectionViewLayoutBase : UICollectionViewLayout

- (NSString *)layoutKeyForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)layoutKeyForHeaderAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)layoutKeyForFooterAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)layoutKeyForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath;

@property (retain, nonatomic) NSMutableDictionary *layoutAttributes;
@property (assign, nonatomic) CGSize contentSize;

-(NSMutableArray*)elementsInRectArray;

@end

