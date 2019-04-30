#import <UIKit/UIKit.h>

#ifndef __IPHONE_7_0
#error Because of Dynamic Kit, this custom flowLayout requires APIs only available in iOS SDK 7.0 and later
#endif

@class RACSignal;

/**
 *  A UICollectionViewFlowLayout subclass that, when implemented,
 *  creates a dynamic / elastic scroll effect for UICollectionViews
 */
@interface MyBouncyLayout : UICollectionViewFlowLayout


/**
 *  Call this method to instanciate a custom bouncing flow layout for UICollectionView
 *
 *  @param scrollResistance the scroll resistance, ie elasticity between cells (by default @ 900)
 *
 *  @return the instanciated CWElasticFlowLayout object
 */
- (instancetype)initWithScrollResistance:(CGFloat)scrollResistance;


/**
 default: false
 */
@property (assign, nonatomic) BOOL bouncingEnabled;

@property (nonatomic) RACSignal* pauseSignal;
@property (nonatomic) RACSignal* resumeSignal;
@property (nonatomic) RACSignal* statusSignal;

@end



/******************************************/

////
////  MyBouncyLayout.h
////  oncost
////
////  Created by Hamidreza Vakilian on 3/3/1397 AP.
////  Copyright © 1397 oncost. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//
//@interface MyBouncyLayout : UICollectionViewFlowLayout
//
//@property (assign, nonatomic) CGFloat damping;
//@property (assign, nonatomic) CGFloat frequency;
//
//
//
//@end
