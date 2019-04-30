//
//  _MTDialog.m
//  mactehrannew
//
//  Created by hAmidReza on 8/16/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_MTDialog.h"
#import "_loadingEnabledView.h"
#import "UIView+SDCAutoLayout.h"
#import "UIColor+Extensions.h"

@interface _MTDialog ()

@end

@implementation _MTDialog

-(void)initialize
{
	[super initialize];
	
	self.transition_NoBackZoom = YES;
	
	self.contentView.layer.cornerRadius = 2.0f;
	self.contentView.clipsToBounds = YES;
	self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	self.myShadowView.shadowOffset = CGSizeMake(0, 20);
	self.myShadowView.shadowRadius = 10;
	self.myShadowView.shadowOpacity = .3;
	self.myShadowView.cornerRadius = 2.0;
	
	[self.contentView sdc_pinWidth:320];
	
	self.visualEffectView.hidden = YES;
	
    self.dimView.backgroundColor = [UIColor colorWithHexString:@"#00000073"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
