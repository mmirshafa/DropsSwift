//
//  UIViewController+MyAppearance.m
//  appearance_Test
//
//  Created by hAmidReza on 8/31/17.
//  Copyright © 2017 innovian. All rights reserved.
//

#import "NSObject+uniconf.h"
#import <objc/runtime.h>
#import "NSObject+Runtime.h"
#import "NSObject+DataObject.h"

@implementation NSObject (uniconf)

+(NSMutableDictionary*)_uniconf_table
{
	static NSMutableDictionary* _table;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_table = [NSMutableDictionary new];
	});
	return _table;
}

+(NSMutableDictionary*)_uniconf_class_dic
{
	NSString* class_name = NSStringFromClass([self class]);
	if ([self _uniconf_table][class_name])
		return [self _uniconf_table][class_name];
	else
	{
		[self _uniconf_table][class_name] = [NSMutableDictionary new];
		return [self _uniconf_table][class_name];
	}
}

+(instancetype)_uniconf_proxy_obj:(BOOL)force_create
{
	NSMutableDictionary* fl = [self _uniconf_class_dic];
	if (fl && fl[@"proxy"])
		return fl[@"proxy"];
	else if (force_create)
	{
		fl[@"proxy"] = [self new];
		return fl[@"proxy"];
	}
	else
		return nil;
}

+(instancetype)uniconf
{
	return [self _uniconf_proxy_obj:YES];
}

-(void)uniconf_restore
{
	id proxy_obj = [[self class] _uniconf_proxy_obj:NO];
	
	if (!proxy_obj || self == proxy_obj)
		return;
	
	[[self class] swizzleMethod:@selector(setValue:forUndefinedKey:) withMethod:@selector(_setValue:forUndefinedKey:)];
	
	[self setDataObject:@0 forKey:@"ignoreUndef"];
	
	unsigned int count;
	objc_property_t *properties = class_copyPropertyList([self class], &count);
	for (size_t i = 0; i < count; ++i) {
		NSString *key = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
		//		NSString* k = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
		NSRange rng = [key rangeOfString:@"u_"];
		if (rng.location == 0 && rng.length == 2)
			[self setValue:[proxy_obj valueForKeyPath:key] forKeyPath:key];
	}
	free(properties);
	
	[self setDataObject:nil forKey:@"ignoreUndef"];
}

-(void)_setValue:(id)value forUndefinedKey:(NSString *)key
{
	if ([self dataObjectForKey:@"ignoreUndef"])
		return;
	
	[self _setValue:value forUndefinedKey:key];
}

@end
