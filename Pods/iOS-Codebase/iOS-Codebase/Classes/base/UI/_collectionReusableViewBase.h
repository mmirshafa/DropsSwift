//
//  _collectionReusableViewBase.h
//  mactehrannew
//
//  Created by hAmidReza on 6/7/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _collectionReusableViewBase : UICollectionReusableView

@property (weak, nonatomic) NSMutableDictionary* dic;

-(void)initialize;
+(NSString *)reuseIdentifier;

-(void)configureWithDictionary:(NSMutableDictionary*)dic;
-(void)initial_layout;
@end
