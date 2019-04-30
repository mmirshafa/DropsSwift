//
//  MATTextFieldSupportedScrollView.h
//  oncost
//
//  Created by Hamidreza Vakilian on 3/23/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 if needed to scroll to a MATTextField to become visible, it will scroll to the real MATTextField's frame not it descendant UITextfield/UITextView (which is definitely smaller that MATTextField). You have to set scrollViewConentsView: this is the main content view for the scroll view. this API works if have only one contentView and if you set it.
 */
@interface MATTextFieldSupportedScrollView : UIScrollView

@property (retain, nonatomic) UIView* scrollViewConentsView;

@end
