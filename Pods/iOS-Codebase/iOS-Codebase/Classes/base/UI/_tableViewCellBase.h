//
//  _tableViewCellBase.h
//  mactehrannew
//
//  Created by hAmidReza on 5/1/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _tableViewCellBase : UITableViewCell

-(void)initialize;
-(void)configureWithDictionary:(NSDictionary*)dic;
+(NSString*)reuseIdentifier;


@end
