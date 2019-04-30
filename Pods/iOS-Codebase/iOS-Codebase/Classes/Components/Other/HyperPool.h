//
//  HyperPool.h
//  Aiywa2
//
//  Created by Hamidreza Vakilian on 8/27/1396 AP.
//  Copyright © 1396 nizek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HyperPool)

-(void)HyperPoolReleaseObject;

@end;

@interface HyperPool : NSObject

+(void)createPoolWithIdentifier:(NSString* _Nonnull)ident minCount:(NSUInteger)minCount objectCreationBlock:(_Nonnull id (^_Nonnull)(NSString* _Nonnull pool_ident))objectCreationBlock objectBeforeReuseBlock:(void (^_Nullable)(id _Nonnull object2bereused, NSString* _Nonnull pool_ident))reuseBlock;
+(_Nonnull id)acquireObjectFromPoolWithIdent:(NSString* _Nonnull)ident;
+(void)destroyPoolWithIdentifier:(NSString* _Nonnull)ident;
@end
