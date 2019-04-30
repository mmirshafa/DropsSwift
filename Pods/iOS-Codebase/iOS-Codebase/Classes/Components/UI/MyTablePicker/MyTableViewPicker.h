//
//  PickerTableVC.h
//  oncost
//
//  Created by Hamidreza Vakilian on 3/22/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

@class MyTableViewPickerCompatibleCell;

@protocol MyTableViewPickerCompatibleCellDelegate
-(void)MyTableViewPickerCompatibleCell:(MyTableViewPickerCompatibleCell*)instance didTapWithDictionary:(NSMutableDictionary*)dic;
@end

@protocol MyTableViewPickerCompatibleCell

-(void)configureWithDictionary:(NSDictionary*)dic;
+(NSString *)reuseIdentifier;

@property (weak, nonatomic) id<MyTableViewPickerCompatibleCellDelegate> delegate;

@end

@interface MyTableViewPicker<__covariant vcType> : NSObject


+(instancetype)withNAVCClass:(Class)baseNavCClass VCClass:(Class)baseClass cellClass:(Class <MyTableViewPickerCompatibleCell>)cellClass title:(NSString*)title titleFieldKey:(NSString*)titleFieldKey;

// PUSH VC TO CURRENT NAVC
+(instancetype)withVCClass:(Class)baseClass title:(NSString*)title titleFieldKey:(NSString*)titleFieldKey;
+(instancetype)withVCClass:(Class)baseClass title:(NSString*)title;
+(instancetype)withVCClass:(Class)baseClass;
+(instancetype)withVCClass:(Class)baseClass cellClass:(Class <MyTableViewPickerCompatibleCell>)cellClass title:(NSString*)title titleFieldKey:(NSString*)titleFieldKey;
+(instancetype)withVCClass:(Class)baseClass cellClass:(Class <MyTableViewPickerCompatibleCell>)cellClass title:(NSString*)title;

@property (nonatomic, copy, nullable) void (^callback)(NSDictionary*);

//@property (nonatomic, copy, nullable) void (^willLoadDataset)(vcType vc);
//@property (nonatomic, copy, nullable) void (^didInit)(vcType vc);
@property (weak, nonatomic) vcType vc;
@property (weak, nonatomic) UINavigationController* navC;

@property (assign, nonatomic) BOOL dismissManually;

@property (retain, nonatomic) NSValue* overridenTableInsets;

-(void)loadDataset:(NSArray<NSMutableDictionary*>*)dataset;

@end
