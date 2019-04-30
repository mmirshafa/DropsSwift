//
//  _collectionViewCellBase.m
//  mactehrannew
//
//  Created by hAmidReza on 5/6/17.
//  Copyright © 2017 archibits. All rights reserved.
//

#import "_collectionViewCellBase.h"
#import "NSObject+DataObject.h"

@implementation _collectionViewCellBase

-(instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		[self initialize];
	}
	return self;
}

-(void)initialize
{
	
}

+(NSString *)reuseIdentifier
{
    NSString* reuseIdentifier = [self dataObjectForKey:@"reuseIdentifier"];
    if (!reuseIdentifier)
    {
        reuseIdentifier = NSStringFromClass([self class]);
        [self setDataObject:reuseIdentifier forKey:@"reuseIdentifier"];
    }
    return reuseIdentifier;
}

+(void)processLayoutWithDictionary:(NSMutableDictionary *)dic options:(NSDictionary *)options
{
//    CGFloat w = [options[@"width"] floatValue];
//    CGFloat h = [options[@"height"] floatValue];
	
//    ProductsViewLayoutMode mode = [options[@"mode"] unsignedIntegerValue];
	
//    NSMutableDictionary* renderDic = dic[@"_render"];
//
//    if (!renderDic)
//    {
//        renderDic = [NSMutableDictionary new];
//        dic[@"_render"] = renderDic;
//    }
//
//    CGFloat imageView_top = 0;
//    CGFloat imageView_left = 0;
//    CGFloat imageView_width = 0;
//    CGFloat imageView_height = 0;
	
//    if (mode == ProductsViewLayoutModeGrid)
//    {
//
//    }
}

@end
