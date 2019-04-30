//
//  PickerTableVC.m
//  oncost
//
//  Created by Hamidreza Vakilian on 3/22/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "MyTableViewPicker.h"
#import "MyTableViewPickerCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "codebase_definitions.h"
#import "NSObject+DataObject.h"
#import "UIScrollView+Extensions.h"
#import "UIView+SDCAutoLayout.h"
#import "UIView+Extensions.h"

@interface MyTableViewPickerCell (private)
-(void)setTitle:(NSString*)title andDic:(NSMutableDictionary*)dic;
@end

@interface MyTableViewPicker () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MyTableViewPickerCompatibleCellDelegate>

@property (retain, nonatomic) NSArray<NSMutableDictionary*>* dataset;
@property (retain, nonatomic) Class<MyTableViewPickerCompatibleCell> cellClass;
@property (weak, nonatomic) UITableView* tv;
@property (retain, nonatomic) NSString* titleFieldKey;

@property (assign, nonatomic) BOOL presenting;


/**
 we should keep a strong reference to the vc until laodDataset is called. because in withVCClass we return an instance MyTableViewPicker but MyTableViewPicker has a weak reference to VC so the vc will be deallocated when we call loaddataset. so on initialization we set temp_strong_vc to the vc to keep it alive and at loaddataset we set temp_strong_vc to nil. There is a chance of creating retain-cycle if you don't call loaddataset. The only case which causes retain-cycle is if the developer create and instance of MyTableViewPicker and push the vc, but doesn't call loaddataset. which is not logical to happen.
 */
@property (retain, nonatomic) id temp_strong_vc;
@end

@implementation MyTableViewPicker

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.titleFieldKey = @"title";
        self.cellClass = MyTableViewPickerCell.class;
    }
    return self;
}

+(instancetype)withVCClass:(Class)baseClass title:(NSString*)title titleFieldKey:(NSString*)titleFieldKey
{
    return [self withVCClass:baseClass cellClass:nil title:title titleFieldKey:titleFieldKey];
}

+(instancetype)withVCClass:(Class)baseClass title:(NSString*)title
{
    return [self withVCClass:baseClass cellClass:nil title:title titleFieldKey:nil];
}

+(instancetype)withVCClass:(Class)baseClass
{
    return [self withVCClass:baseClass cellClass:nil title:nil titleFieldKey:nil];
}

+(instancetype)withVCClass:(Class)baseClass cellClass:(Class <MyTableViewPickerCompatibleCell>)cellClass title:(NSString*)title
{
    return [self withVCClass:baseClass cellClass:cellClass title:title titleFieldKey:nil];
}
+(instancetype)withVCClass:(Class)baseClass cellClass:(Class <MyTableViewPickerCompatibleCell>)cellClass title:(NSString*)title titleFieldKey:(NSString*)titleFieldKey
{
    UIViewController* vc = [baseClass new];
    
    vc.title = title;
    
    MyTableViewPicker* delegateObj = [MyTableViewPicker new];
    delegateObj.vc = vc;
    if (titleFieldKey)
        delegateObj.titleFieldKey = titleFieldKey;
    
    [vc setDataObject:delegateObj forKey:@"delegate"];
    
    delegateObj.temp_strong_vc = vc;
    
    if (cellClass)
        delegateObj.cellClass = cellClass;
    
    return delegateObj;
}

+(instancetype)withNAVCClass:(Class)baseNavCClass VCClass:(Class)baseClass cellClass:(Class <MyTableViewPickerCompatibleCell>)cellClass title:(NSString*)title titleFieldKey:(NSString*)titleFieldKey
{
    UIViewController* vc = [baseClass new];
    UINavigationController* navC = [[baseNavCClass alloc] initWithRootViewController:vc];
    
    vc.title = title;
    
    MyTableViewPicker* delegateObj = [MyTableViewPicker new];
    delegateObj.navC = navC;
    delegateObj.vc = vc;
    
    delegateObj.presenting = YES;
    
    if (titleFieldKey)
        delegateObj.titleFieldKey = titleFieldKey;
    
    [vc setDataObject:delegateObj forKey:@"delegate"];
    
    delegateObj.temp_strong_vc = navC;
    
    if (cellClass)
        delegateObj.cellClass = cellClass;
    
    return delegateObj;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataset ? 1 : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataset.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell<MyTableViewPickerCompatibleCell>* cell = [tableView dequeueReusableCellWithIdentifier:[self.cellClass reuseIdentifier] forIndexPath:indexPath];
    
    cell.delegate = self;
    
    NSMutableDictionary* dic = self.dataset[indexPath.row];
    
    if ([cell isKindOfClass:[MyTableViewPickerCell class]])
    {
        MyTableViewPickerCell* _cell = (MyTableViewPickerCell*)cell;
        [_cell setTitle:dic[self.titleFieldKey] andDic:dic];
    }
    else
        [cell configureWithDictionary:dic];
    
    return cell;
}

-(void)MyTableViewPickerCompatibleCell:(id)instance didTapWithDictionary:(NSMutableDictionary *)dic
{
    if (self.callback) self.callback(dic);
    UIViewController* vc = self.vc;
    
    if (!self.dismissManually)
    {
        if (self.presenting)
            [self.navC dismissViewControllerAnimated:YES completion:nil];
        else
            [vc.navigationController popViewControllerAnimated:YES];
    }
}

-(void)loadDataset:(NSArray<NSMutableDictionary*>*)dataset
{
    self.dataset = dataset;
    
    
    
    
    UITableView* tv = [UITableView new2];
    tv.tableFooterView = [UIView new];
    [tv noAutoInset];
    if (self.overridenTableInsets)
        tv.contentInset = [self.overridenTableInsets UIEdgeInsetsValue];
    else
        tv.contentInset = UIEdgeInsetsMake(_statusBarHeight + 44.0f, 0, 0, 0);
    tv.scrollIndicatorInsets = tv.contentInset;
    [((UIViewController*)self.vc).view addSubview:tv];
    tv.separatorInset = UIEdgeInsetsZero;
    [tv sdc_alignEdgesWithSuperview:UIRectEdgeAll];
    tv.delegate = self;
    tv.dataSource = self;
    tv.emptyDataSetSource = self;
    tv.emptyDataSetDelegate = self;
    
    self.tv = tv;
    
    
    
    [tv registerClass:self.cellClass forCellReuseIdentifier:[self.cellClass reuseIdentifier]];
    
    //    if (self.didInit)
    //        self.didInit(self.vc);
    
    self.temp_strong_vc = nil;
    
    [UIView animateWithDuration:0 animations:^{
        [self.tv reloadData];
    } completion:^(BOOL finished) {
        CGFloat offsetY =  - _statusBarHeight - 44.0f;
        if (self.overridenTableInsets)
            offsetY = [self.overridenTableInsets UIEdgeInsetsValue].top * -1;
        self.tv.contentOffset = CGPointMake(0, offsetY);
    }];
    
}

@end
