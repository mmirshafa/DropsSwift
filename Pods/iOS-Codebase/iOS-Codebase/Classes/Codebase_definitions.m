//
//  core_definitions.m
//  Pods
//
//  Created by hAmidReza on 6/1/17.
//
//

#import "Codebase_definitions.h"

@implementation core_definitions

NSArray* k_iconCircle() {
    
    static NSArray* result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result =
        @[
          @{@"conf": @{@"size": @[@108.87,@108.87]}},
          @[@"m", @108.37, @54.43],
          @[@"c", @54.43, @108.37, @108.37, @84.22, @84.22, @108.37],
          @[@"c", @0.50, @54.43, @24.65, @108.37, @0.50, @84.22],
          @[@"c", @54.43, @0.50, @0.50, @24.65, @24.65, @0.50],
          @[@"c", @108.37, @54.43, @84.22, @0.50, @108.37, @24.65],
          ]
        ;
    });
    return result;
}

NSArray* k_iconNull() {
    
    static NSArray* result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result =@[
                  @{@"conf": @{@"size": @[@100.00,@100.00]}},
                  @[@"m", @0, @0],
                  ]
        ;
    });
    return result;
}

NSArray* k_iconLeftArrow() {
	
	static NSArray* result;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		result =
		
  @[
	@[@"m", @72.39, @100.00],
	@[@"c", @70.17, @99.04, @71.58, @100.00, @70.77, @99.68],
	@[@"c", @24.19, @49.99, @70.17, @99.04, @24.19, @49.99],
	@[@"c", @70.54, @0.96, @24.19, @49.99, @70.54, @0.96],
	@[@"c", @74.86, @0.83, @71.70, @-0.27, @73.63, @-0.32],
	@[@"c", @74.98, @5.15, @76.08, @1.99, @76.14, @3.92],
	@[@"c", @32.57, @50.01, @74.98, @5.15, @32.57, @50.01],
	@[@"c", @74.62, @94.86, @32.57, @50.01, @74.62, @94.86],
	@[@"c", @74.48, @99.17, @75.77, @96.09, @75.71, @98.02],
	@[@"c", @72.39, @100.00, @73.89, @99.73, @73.14, @100.00],
	];
		
	});
	return result;
	
}


NSArray* k_iconExclam() {
	
	static NSArray* result;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		result =
  @[
	@[@"m", @54.45, @75.13],
	@[@"l", @98.75, @80.52],
	@[@"c", @58.05, @10.16, @98.75, @80.52, @58.05, @10.16],
	@[@"c", @50.00, @5.52, @56.40, @7.30, @53.31, @5.52],
	@[@"c", @41.95, @10.16, @46.69, @5.52, @43.60, @7.30],
	@[@"c", @1.25, @80.52, @41.95, @10.16, @1.25, @80.52],
	@[@"c", @1.24, @89.83, @-0.41, @83.39, @-0.42, @86.96],
	@[@"c", @9.30, @94.48, @2.90, @92.70, @5.98, @94.48],
	@[@"c", @90.70, @94.48, @9.30, @94.48, @90.70, @94.48],
	@[@"c", @98.76, @89.83, @94.02, @94.48, @97.10, @92.70],
	@[@"c", @98.75, @80.52, @100.42, @86.96, @100.41, @83.39],
	@[@"l", @54.45, @75.13],
	@[@"l", @90.70, @88.70],
	@[@"c", @50.00, @88.70, @90.70, @88.70, @50.00, @88.70],
	@[@"c", @9.30, @88.70, @50.00, @88.70, @9.30, @88.70],
	@[@"c", @6.25, @83.42, @6.59, @88.70, @4.90, @85.76],
	@[@"c", @46.95, @13.06, @6.25, @83.42, @46.95, @13.06],
	@[@"c", @53.05, @13.06, @48.31, @10.72, @51.69, @10.72],
	@[@"c", @93.75, @83.42, @53.05, @13.06, @93.75, @83.42],
	@[@"c", @90.70, @88.70, @95.10, @85.76, @93.41, @88.70],
	@[@"l", @54.45, @75.13],
	@[@"l", @50.93, @65.62],
	@[@"c", @49.10, @65.62, @50.93, @65.62, @49.10, @65.62],
	@[@"c", @47.23, @63.81, @48.09, @65.62, @47.26, @64.82],
	@[@"c", @46.34, @33.70, @46.93, @53.77, @46.64, @43.76],
	@[@"c", @48.21, @31.77, @46.31, @32.64, @47.15, @31.77],
	@[@"c", @51.80, @31.77, @48.21, @31.77, @51.80, @31.77],
	@[@"c", @53.67, @33.69, @52.85, @31.77, @53.70, @32.64],
	@[@"c", @52.80, @63.81, @53.38, @43.72, @53.09, @53.73],
	@[@"c", @50.93, @65.62, @52.77, @64.82, @51.94, @65.62],
	@[@"l", @54.45, @75.13],
	@[@"c", @50.03, @79.79, @54.45, @77.89, @52.65, @79.78],
	@[@"c", @45.55, @75.14, @47.46, @79.80, @45.56, @77.83],
	@[@"c", @50.01, @70.49, @45.55, @72.46, @47.44, @70.49],
	@[@"c", @54.45, @75.13, @52.64, @70.49, @54.44, @72.38],
	]
		;
	});
	return result;
}

NSArray* k_iconRetry() {
	
	static NSArray* result;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		result =
  @[
	@[@"m", @94.43, @39.92],
	@[@"l", @22.90, @19.83],
	@[@"c", @74.73, @18.46, @37.67, @6.48, @59.76, @6.27],
	@[@"c", @62.86, @18.91, @74.73, @18.46, @62.86, @18.91],
	@[@"c", @60.21, @21.77, @61.33, @18.97, @60.15, @20.24],
	@[@"c", @62.97, @24.42, @60.27, @23.26, @61.50, @24.42],
	@[@"c", @63.07, @24.42, @62.97, @24.42, @63.07, @24.42],
	@[@"c", @81.28, @23.75, @63.07, @24.42, @81.28, @23.75],
	@[@"c", @83.94, @20.99, @82.77, @23.69, @83.94, @22.49],
	@[@"c", @83.94, @20.67, @83.94, @20.99, @83.94, @20.67],
	@[@"c", @83.26, @2.66, @83.94, @20.67, @83.26, @2.66],
	@[@"c", @80.41, @0.00, @83.20, @1.13, @81.92, @-0.06],
	@[@"c", @77.75, @2.86, @78.87, @0.06, @77.69, @1.33],
	@[@"c", @78.18, @14.15, @77.75, @2.86, @78.18, @14.15],
	@[@"c", @51.88, @4.09, @70.77, @8.09, @61.64, @4.58],
	@[@"c", @19.21, @15.75, @39.79, @3.47, @28.17, @7.62],
	@[@"c", @5.57, @60.08, @6.87, @26.92, @1.65, @43.91],
	@[@"c", @8.24, @62.18, @5.87, @61.34, @6.99, @62.18],
	@[@"c", @8.89, @62.10, @8.47, @62.18, @8.67, @62.16],
	@[@"c", @10.92, @58.77, @10.36, @61.73, @11.28, @60.24],
	@[@"c", @22.90, @19.83, @7.49, @44.56, @12.06, @29.63],
	@[@"c", @22.90, @19.83, @22.90, @19.83, @22.90, @19.83],
	@[@"l", @94.43, @39.92],
	@[@"l", @22.90, @19.83],
	@[@"l", @94.43, @39.92],
	@[@"l", @94.43, @39.92],
	@[@"c", @91.11, @37.90, @94.07, @38.45, @92.58, @37.54],
	@[@"c", @89.08, @41.23, @89.64, @38.27, @88.72, @39.76],
	@[@"c", @77.10, @80.17, @92.53, @55.44, @87.94, @70.37],
	@[@"c", @50.41, @90.44, @69.48, @87.05, @59.92, @90.44],
	@[@"c", @24.94, @81.27, @41.32, @90.44, @32.25, @87.36],
	@[@"c", @36.95, @80.19, @24.94, @81.27, @36.95, @80.19],
	@[@"c", @39.44, @77.19, @38.46, @80.05, @39.59, @78.72],
	@[@"c", @36.44, @74.70, @39.30, @75.66, @37.97, @74.56],
	@[@"c", @18.29, @76.33, @36.44, @74.70, @18.29, @76.33],
	@[@"c", @15.80, @79.33, @16.78, @76.48, @15.65, @77.80],
	@[@"c", @17.43, @97.49, @15.80, @79.33, @17.43, @97.49],
	@[@"c", @20.17, @100.00, @17.55, @98.92, @18.76, @100.00],
	@[@"c", @20.41, @99.98, @20.25, @100.00, @20.33, @100.00],
	@[@"c", @22.90, @96.98, @21.92, @99.84, @23.05, @98.51],
	@[@"c", @21.92, @85.93, @22.90, @96.98, @21.92, @85.93],
	@[@"c", @48.12, @95.92, @29.34, @91.93, @38.42, @95.43],
	@[@"c", @50.43, @95.98, @48.90, @95.96, @49.67, @95.98],
	@[@"c", @80.79, @84.26, @61.68, @95.98, @72.38, @91.85],
	@[@"c", @94.43, @39.92, @93.13, @73.09, @98.35, @56.12],
	@[@"c", @94.43, @39.92, @94.43, @39.92, @94.43, @39.92],
	@[@"l", @94.43, @39.92],
	]
		;
	});
	return result;
}


NSArray* __codebase_k_iconWarning() {
	
	static NSArray* result;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		result =
  @[
	@[@"m", @50.00, @83.96],
	@[@"l", @50.00, @79.58],
	@[@"c", @57.34, @72.84, @53.83, @79.58, @57.01, @76.65],
	@[@"c", @62.31, @13.39, @57.34, @72.84, @62.31, @13.39],
	@[@"c", @59.09, @3.99, @62.60, @9.94, @61.43, @6.54],
	@[@"c", @50.00, @-0.00, @56.76, @1.45, @53.46, @-0.00],
	@[@"c", @40.90, @3.99, @46.54, @-0.00, @43.24, @1.45],
	@[@"c", @37.69, @13.39, @38.56, @6.54, @37.40, @9.94],
	@[@"c", @42.66, @72.84, @37.69, @13.39, @42.66, @72.84],
	@[@"c", @50.00, @79.58, @42.98, @76.65, @46.17, @79.58],
	@[@"c", @50.00, @79.58, @50.00, @79.58, @50.00, @79.58],
	@[@"l", @50.00, @83.96],
	@[@"l", @50.00, @79.58],
	@[@"l", @50.00, @83.96],
	@[@"l", @50.00, @83.96],
	@[@"c", @41.98, @91.98, @45.57, @83.96, @41.98, @87.55],
	@[@"c", @50.00, @100.00, @41.98, @96.41, @45.57, @100.00],
	@[@"c", @58.02, @91.98, @54.43, @100.00, @58.02, @96.41],
	@[@"c", @50.00, @83.96, @58.02, @87.55, @54.43, @83.96],
	@[@"c", @50.00, @83.96, @50.00, @83.96, @50.00, @83.96],
	@[@"l", @50.00, @83.96],
	];
	});
	return result;
}

NSArray* __codebase_k_iconCrossHeavy() {
	
	static NSArray* result;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		result =
		
  @[
	@[@"m", @98.20, @11.88],
	@[@"c", @88.12, @1.80, @98.20, @11.88, @88.12, @1.80],
	@[@"c", @79.42, @1.80, @85.72, @-0.60, @81.82, @-0.60],
	@[@"c", @54.35, @26.87, @79.42, @1.80, @54.35, @26.87],
	@[@"c", @45.65, @26.87, @51.95, @29.27, @48.05, @29.27],
	@[@"c", @20.58, @1.80, @45.65, @26.87, @20.58, @1.80],
	@[@"c", @11.88, @1.80, @18.18, @-0.60, @14.28, @-0.60],
	@[@"c", @1.80, @11.88, @11.88, @1.80, @1.80, @11.88],
	@[@"c", @1.80, @20.58, @-0.60, @14.28, @-0.60, @18.18],
	@[@"c", @26.87, @45.65, @1.80, @20.58, @26.87, @45.65],
	@[@"c", @26.87, @54.35, @29.27, @48.05, @29.27, @51.95],
	@[@"c", @1.80, @79.42, @26.87, @54.35, @1.80, @79.42],
	@[@"c", @1.80, @88.12, @-0.60, @81.82, @-0.60, @85.72],
	@[@"c", @11.88, @98.20, @1.80, @88.12, @11.88, @98.20],
	@[@"c", @20.58, @98.20, @14.28, @100.60, @18.18, @100.60],
	@[@"c", @45.65, @73.13, @20.58, @98.20, @45.65, @73.13],
	@[@"c", @54.35, @73.13, @48.05, @70.73, @51.95, @70.73],
	@[@"c", @79.42, @98.20, @54.35, @73.13, @79.42, @98.20],
	@[@"c", @88.12, @98.20, @81.82, @100.60, @85.72, @100.60],
	@[@"c", @98.20, @88.12, @88.12, @98.20, @98.20, @88.12],
	@[@"c", @98.20, @79.42, @100.60, @85.72, @100.60, @81.82],
	@[@"c", @73.13, @54.35, @98.20, @79.42, @73.13, @54.35],
	@[@"c", @73.13, @45.65, @70.73, @51.95, @70.73, @48.05],
	@[@"c", @98.20, @20.58, @73.13, @45.65, @98.20, @20.58],
	@[@"c", @98.20, @11.88, @100.60, @18.18, @100.60, @14.28],
	]
		;
	});
	return result;
}

NSArray* __codebase_k_iconLocationSible() {
	
	static NSArray* result;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		result =
		
  @[
	@[@"m", @67.22, @50.00],
	@[@"l", @95.80, @45.80],
	@[@"c", @88.26, @45.80, @95.80, @45.80, @88.26, @45.80],
	@[@"c", @88.27, @45.87, @88.26, @45.82, @88.26, @45.85],
	@[@"c", @54.03, @11.73, @86.34, @27.91, @72.01, @13.61],
	@[@"c", @54.20, @11.74, @54.09, @11.73, @54.15, @11.73],
	@[@"c", @54.20, @4.20, @54.20, @11.74, @54.20, @4.20],
	@[@"c", @50.00, @-0.00, @54.20, @1.88, @52.32, @-0.00],
	@[@"c", @45.80, @4.20, @47.68, @-0.00, @45.80, @1.88],
	@[@"c", @45.80, @11.74, @45.80, @4.20, @45.80, @11.74],
	@[@"c", @45.87, @11.73, @45.82, @11.74, @45.85, @11.74],
	@[@"c", @11.73, @45.97, @27.91, @13.66, @13.61, @27.99],
	@[@"c", @11.74, @45.80, @11.73, @45.91, @11.73, @45.85],
	@[@"c", @4.20, @45.80, @11.74, @45.80, @4.20, @45.80],
	@[@"c", @-0.00, @50.00, @1.88, @45.80, @-0.00, @47.68],
	@[@"c", @4.20, @54.20, @-0.00, @52.32, @1.88, @54.20],
	@[@"c", @11.74, @54.20, @4.20, @54.20, @11.74, @54.20],
	@[@"c", @11.73, @54.03, @11.73, @54.15, @11.73, @54.09],
	@[@"c", @45.87, @88.27, @13.61, @72.01, @27.91, @86.34],
	@[@"c", @45.80, @88.26, @45.85, @88.26, @45.82, @88.26],
	@[@"c", @45.80, @95.80, @45.80, @88.26, @45.80, @95.80],
	@[@"c", @50.00, @100.00, @45.80, @98.12, @47.68, @100.00],
	@[@"c", @54.20, @95.80, @52.32, @100.00, @54.20, @98.12],
	@[@"c", @54.20, @88.26, @54.20, @95.80, @54.20, @88.26],
	@[@"c", @54.03, @88.27, @54.15, @88.27, @54.09, @88.27],
	@[@"c", @88.27, @54.13, @72.01, @86.39, @86.34, @72.09],
	@[@"c", @88.26, @54.20, @88.26, @54.15, @88.26, @54.18],
	@[@"c", @95.80, @54.20, @88.26, @54.20, @95.80, @54.20],
	@[@"c", @100.00, @50.00, @98.12, @54.20, @100.00, @52.32],
	@[@"c", @95.80, @45.80, @100.00, @47.68, @98.12, @45.80],
	@[@"l", @67.22, @50.00],
	@[@"l", @50.00, @79.81],
	@[@"c", @20.19, @50.00, @33.57, @79.81, @20.19, @66.43],
	@[@"c", @50.00, @20.19, @20.19, @33.57, @33.57, @20.19],
	@[@"c", @79.81, @50.00, @66.43, @20.19, @79.81, @33.57],
	@[@"c", @50.00, @79.81, @79.81, @66.43, @66.43, @79.81],
	@[@"l", @67.22, @50.00],
	@[@"c", @50.00, @67.22, @67.22, @59.51, @59.51, @67.22],
	@[@"c", @32.78, @50.00, @40.49, @67.22, @32.78, @59.51],
	@[@"c", @50.00, @32.78, @32.78, @40.49, @40.49, @32.78],
	@[@"c", @67.22, @50.00, @59.51, @32.78, @67.22, @40.49],
	]
		;
	});
	return result;
}

NSArray* __codebase_k_iconMyLocationPickerPin() {
	
	static NSArray* result;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		result =
		
		
  @[
	@[@"m", @50.01, @48.69],
	@[@"l", @50.00, @-0.00],
	@[@"c", @15.89, @34.11, @31.16, @-0.00, @15.89, @15.27],
	@[@"c", @50.00, @100.00, @15.89, @52.95, @50.00, @100.00],
	@[@"c", @84.11, @34.11, @50.00, @100.00, @84.11, @52.95],
	@[@"c", @50.00, @-0.00, @84.11, @15.27, @68.84, @-0.00],
	@[@"l", @50.01, @48.69],
	@[@"c", @31.58, @30.26, @39.83, @48.69, @31.58, @40.44],
	@[@"c", @50.01, @11.83, @31.58, @20.08, @39.83, @11.83],
	@[@"c", @68.44, @30.26, @60.19, @11.83, @68.44, @20.08],
	@[@"c", @50.01, @48.69, @68.44, @40.44, @60.19, @48.69],
	];
		;
	});
	return result;
}

@end
