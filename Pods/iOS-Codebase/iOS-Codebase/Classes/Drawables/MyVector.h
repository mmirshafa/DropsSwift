//
//  MyVector.h
//  MyVector
//
//  Created by hAmidReza on 6/25/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 this class automatically takes care of the vector's aspect ratio. if you want it to maintain it's aspect ratio, let one of the height or width cons to be free. it will add an aspect ratio constraint with priority 950. if you define both the width and height cons it will be overridden with no problems.
 */
@interface MyVector : UIView

-(instancetype)initWithVector:(NSDictionary*)vector;

@property (retain, nonatomic) NSDictionary* vector;

@end
