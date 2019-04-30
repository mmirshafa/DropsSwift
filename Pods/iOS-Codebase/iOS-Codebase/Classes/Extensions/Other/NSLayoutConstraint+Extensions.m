//
//  NSLayoutConstraint+Extensions.m
//  Pods
//
//  Created by hAmidReza on 8/1/17.
//
//

#import "NSLayoutConstraint+Extensions.h"

@implementation NSLayoutConstraint (Extensions)

-(BOOL)matchesAnItem:(id)obj1 withSomeAttribute:(NSLayoutAttribute)attr1 anotherItem:(id)obj2 withSomeAttribute:(NSLayoutAttribute)attr2
{
	if ((obj1 == nil || self.firstItem == obj1) && ((NSInteger)attr1 == -1 || self.firstAttribute == attr1) && (obj2 == nil || self.secondItem == obj2) && ((NSInteger)attr2 == -1 || self.secondAttribute == attr2))
		return true;
	
	if ((obj2 == nil || self.firstItem == obj2) && ((NSInteger)attr2 == -1 || self.firstAttribute == attr2) && (obj1 == nil || self.secondItem == obj1) && ((NSInteger)attr1 == -1 || self.secondAttribute == attr1))
		return true;

	return false;
}

@end
