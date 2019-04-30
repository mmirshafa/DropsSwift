//
//  StaticItemPickerVC.m
//  mactehrannew
//
//  Created by Hamidreza Vakilian on 8/3/1396 AP.
//  Copyright © 1396 archibits. All rights reserved.
//

#import "StaticItemPickerVC.h"
#import "UIScrollView+EmptyDataSet.h"
#import "StaticItemPickerCell.h"
#import "_HomeBaseNavBar.h"
#import "myShapeView.h"
#import "Codebase_definitions.h"
#import "MyLocationPickerSubmitButton.h"
#import "UIView+SDCAutoLayout.h"
#import "helper.h"

@interface StaticItemPickerVC () <UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSArray* searchDS;
    BOOL isSearching;
    NSString* last_search;
}

@property (retain, nonatomic) UITableView* tableView;
@property (retain, nonatomic) UISearchController* searchController;
@property (retain, nonatomic) MyLocationPickerSubmitButton* mySubmitButton;

@end

@implementation StaticItemPickerVC

-(void)initialize
{
    [super initialize];
    
    [self uniconf_restore];
    
    _selected_item_id = -1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _pageTitle;
    
    _HomeBaseNavBar* navBar = (_HomeBaseNavBar*)self.navigationController.navigationBar;
    navBar.leftButton.shapeView.shapeDesc = k_iconLeftArrow();
    navBar.leftButton.shapeMargins = UIEdgeInsetsMake(15, 15, 15, 15);
    [navBar.leftButton setButtonClick:^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self configSearchBar];
    
    for (NSMutableDictionary* dic in _items)
        dic[@"_selected"] = nil;
    
    if (!_selectedItem && _selected_item_id > -1)
    {
        for (NSMutableDictionary* anItem in _items) {
            if ([anItem[@"id"] intValue] == _selected_item_id)
            {
                _selectedItem = anItem;
                break;
            }
        }
    }
    
    _selectedItem[@"_selected"] = @(YES);
    
    if (_selectedItem)
    {
        [UIView animateWithDuration:0 animations:^{
            [_tableView reloadData];
        } completion:^(BOOL finished) {
            NSIndexPath* indexPathForSelectedItem = [self indexPathForSelectedItem];
            if (indexPathForSelectedItem)
                [_tableView scrollToRowAtIndexPath:indexPathForSelectedItem atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }];
    }
    
    _mySubmitButton = [MyLocationPickerSubmitButton new];
    _mySubmitButton.titleText = _str(@"Continue");
    _mySubmitButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_mySubmitButton];
    [_mySubmitButton sdc_alignSideEdgesWithSuperviewInset:25];
    [_mySubmitButton sdc_pinHeight:46];
    [_mySubmitButton sdc_alignBottomEdgeWithSuperviewMargin:25];
    [_mySubmitButton addTarget:self action:@selector(sumbitButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!_selectedItem)
    {
        
        _mySubmitButton.alpha = .4;
        _mySubmitButton.userInteractionEnabled = NO;
    }
}

-(void)sumbitButtonTouch:(id)sender
{
    if (_callback)
    {
        _callback(_selectedItem);
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)configSearchBar
{
    _tableView = [UITableView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    [_tableView sdc_alignSideEdgesWithSuperviewInset:0];
    [_tableView sdc_alignTopEdgeWithTopLayoutGuideOfVC:self];
    [_tableView sdc_alignBottomEdgeWithSuperviewMargin:0];
    
    
    if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)])
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    
    _tableView.contentInset = _contentInsets;
    
    [_tableView registerClass:[StaticItemPickerCell class] forCellReuseIdentifier:[StaticItemPickerCell reuseIdentifier]];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.definesPresentationContext = YES;
    
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.dimsBackgroundDuringPresentation = NO;
    
    _searchController.searchBar.delegate = self;
    
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.frame = CGRectMake(_searchController.searchBar.frame.origin.x,0,_searchController.searchBar.frame.size.width, 44.0);
    
    _searchController.searchBar.placeholder = _searchPlaceHolder;
    _searchController.searchBar.barTintColor = RGBAColor(89, 89, 89, 1);
    _searchController.searchBar.translucent = NO;
    _searchController.searchBar.backgroundColor = [UIColor clearColor];//RGBAColor(37, 37, 37, 1);
    
    [_searchController.searchBar setValue:_str(@"Return") forKey:@"_cancelButtonText"];
    
    _tableView.tableHeaderView = _searchController.searchBar;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:_tableView.bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = backgroundView;
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:[UIColor lightGrayColor]];
    
    NSDictionary* text_attr = @{NSFontAttributeName: _u_font ? _u_font : [UIFont systemFontOfSize:14]};
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:text_attr forState:UIControlStateNormal];
    
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:text_attr];
    
    _mainThreadAfter(^{
        
        [_searchController.searchBar setNeedsLayout];
        [_searchController.searchBar layoutIfNeeded];
        
        //        [UIView animateWithDuration:0 animations:^{
        //            [_searchController.searchBar becomeFirstResponder];
        //
        //        } completion:^(BOOL finished) {
        //            [_searchController.searchBar resignFirstResponder];
        //        }];
        
    }, 2);
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchController.searchBar.text = last_search;
    isSearching = NO;
    [_tableView reloadData];
    [_tableView reloadEmptyDataSet];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString* searchText = searchController.searchBar.text;
    
    if ([searchText isEqualToString:last_search])
        return;
    
    if (!self.searchController.isActive)
        return;
    
    last_search = searchText;
    
    if (!searchText.length)
    {
        isSearching = NO;
        [self.tableView reloadData];
        return;
    }
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:_strfmt(@"SELF.title CONTAINS '%@'", searchText)];
    searchDS = [_items filteredArrayUsingPredicate:predicate];
    
    isSearching = YES;
    _mainThread(^{
        [_tableView reloadData];
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _items ? 1 : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching)
        return searchDS.count;
    else
        return _items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaticItemPickerCell* cell = [tableView dequeueReusableCellWithIdentifier:[StaticItemPickerCell reuseIdentifier] forIndexPath:indexPath];
    
    NSMutableDictionary* dic = [self getItemForIndexPath:indexPath];
    
    [cell configureWithDictionary:dic];
    
    return cell;
}

-(NSMutableDictionary*)getItemForIndexPath:(NSIndexPath*)indexPath
{
    NSMutableDictionary* dic;
    if (isSearching)
        dic = searchDS[indexPath.row];
    else
        dic = _items[indexPath.row];
    
    return dic;
}

-(StaticItemPickerCell*)possiblySelectedCell
{
    return [_tableView cellForRowAtIndexPath:[self indexPathForSelectedItem]];
}

-(NSIndexPath*)indexPathForSelectedItem
{
    NSArray* ds2Search = isSearching ? searchDS : _items;
    
    for (int i = 0; i < ds2Search.count; i++)
        if (_bool_true(ds2Search[i][@"_selected"]))
        {
            return [NSIndexPath indexPathForRow:i inSection:0];
        }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchController.searchBar resignFirstResponder];
    
    StaticItemPickerCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    StaticItemPickerCell* possiblySelectedCell = [self possiblySelectedCell];
    [possiblySelectedCell setChosenAnimated:NO];
    _selectedItem[@"_selected"] = nil;
    
    
    _selectedItem = [self getItemForIndexPath:indexPath];
    _selectedItem[@"_selected"] = @(YES);
    
    
    
    [cell setChosenAnimated:YES];
    
    
    _mySubmitButton.alpha = 1;
    _mySubmitButton.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

