//
//  NSLayoutConstraint+Extensions.h
//  Pods
//
//  Created by hAmidReza on 8/1/17.
//
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Extensions)

-(BOOL)matchesAnItem:(id)obj1 withSomeAttribute:(NSLayoutAttribute)attr1 anotherItem:(id)obj2 withSomeAttribute:(NSLayoutAttribute)attr2;

@end
