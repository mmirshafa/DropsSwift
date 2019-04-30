//
//  TearedPaperView.h
//  Kababchi
//
//  Created by hAmidReza on 7/17/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "_viewBase.h"

typedef enum : NSUInteger {
	TearedPaperViewEtchTypeNone = 0,
	TearedPaperViewEtchTypeTop = 1 << 0,
	TearedPaperViewEtchTypeBottom = 1 << 1,
} TearedPaperViewEtchType;

@interface TearedPaperView : _viewBase



/**
 default: TearedPaperViewEtchTypeTop | TearedPaperViewEtchTypeBottom
 */
@property (assign, nonatomic) TearedPaperViewEtchType etchType;

/**
 true: (Default)
 
 /\/\/\
 |      |
 |      |
 |		|
 
 false:
 
 |\/\/\/|
 |      |
 |      |
 */
@property (assign, nonatomic) BOOL seed;



/**
 default edge size = 10;
 */
@property (assign, nonatomic) CGFloat edge;


/**
 refines the edge (reduces it a bit) to fit width; default = YES;
 */
@property (assign, nonatomic) BOOL adjustEdgeToFitWidth;

@property (retain, nonatomic) UIColor* tintColor;

@property (retain, nonatomic) UIColor* shadowColor;
@property (assign, nonatomic) CGFloat shadowRadius;
@property (assign, nonatomic) CGFloat shadowOpacity;
@property (assign, nonatomic) CGSize shadowOffset;

@end
