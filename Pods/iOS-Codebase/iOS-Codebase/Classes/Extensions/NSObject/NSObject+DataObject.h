//
//  NSObject+DataObject.h
//  SetarehShowNew
//
//  Created by hAmidReza on 8/21/1393 AP.
//  Copyright (c) 1393 setarehsho.ir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObjectAdditions)
@property (nonatomic, retain) id objectData;
-(void)setDataObject:(id)obj forKey:(NSString*)key;
-(id)dataObjectForKey:(NSString*)key;
@end
