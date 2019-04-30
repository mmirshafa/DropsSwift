//
//  StaticItemPickerVC.h
//  mactehrannew
//
//  Created by Hamidreza Vakilian on 8/3/1396 AP.
//  Copyright © 1396 archibits. All rights reserved.
//

#import "_HomeBaseVC.h"
#import "NSObject+uniconf.h"

@interface StaticItemPickerVC : _HomeBaseVC <uniconf>


/**
 title on navbar
 */
@property (retain, nonatomic) NSString* pageTitle;



/**
 callback
 */
@property (copy, nonatomic) void (^callback) (NSMutableDictionary* item);


/**
 search bar placeholder string
 */
@property (retain, nonatomic) NSString* searchPlaceHolder;

/**
 the dataset for picker. (an array of dics with format: {id, title}
 */
@property (retain, nonatomic) NSArray* items;



/**
 either set this or selected_item_id. if you set this property, this class will look for the corresponding item and sets it accordingly.
 */
@property (retain, nonatomic) NSMutableDictionary* selectedItem;


@property (assign, nonatomic) UIEdgeInsets contentInsets;

@property (retain, nonatomic) UIFont* u_font;


/**
 either set this or selectedItem. if you set this property, this class will look for the corresponding item and sets it accordingly. the ID must be >= 0
 default: -1;
 */
@property (assign, nonatomic) int selected_item_id;

@end

