//
//  MyShapeButtonLayer.h
//  Aiywa2
//
//  Created by hAmidReza on 2/12/17.
//  Copyright © 2017 nizek. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@protocol MyShapeButtonLayerDelegate <NSObject>

-(void)MyShapeButtonLayerSetCornerRadius:(CGFloat)cornerRadius;
-(BOOL)MyShapeButtonLayerShouldOverrideSetCornerRadius;

@end

@interface MyShapeButtonLayer : CALayer

@property (weak, nonatomic) id<MyShapeButtonLayerDelegate> buttonDelegate;

@end
