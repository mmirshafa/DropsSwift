//
//  _collectionViewCellBase.h
//  mactehrannew
//
//  Created by hAmidReza on 5/6/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _collectionViewCellBase : UICollectionViewCell

-(void)initialize;
+(NSString*)reuseIdentifier;

+(void)processLayoutWithDictionary:(NSMutableDictionary *)dic options:(NSDictionary *)options;
-(void)configureCellWithDictionary:(NSMutableDictionary*)dic options:(NSDictionary*)options;

@end
