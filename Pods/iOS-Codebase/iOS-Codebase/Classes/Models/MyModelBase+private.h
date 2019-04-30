//
//  DFModelBase+private.h
//  deepfinity
//
//  Created by Hamidreza Vakilian on 12/26/1396 AP.
//  Copyright © 1396 nizek. All rights reserved.
//

#import "MyModelBase.h"
#import "NSMapTable+Extensions.h"
#import "MySerialQueue.h"

@interface MyModelBase (private)

@property (class, nonatomic, readonly) NSMapTable* modelsTable;

+(NSString*)modelIDFieldKey;
+(NSString*)uidForModel:(id)model;
+(NSString*)uidForID:(NSString*)id;
-(instancetype)initWithModel:(id)model;
+(void)storeInMapTable:(MyModelBase*)model withUID:(NSString*)uid;
+(MySerialQueue*)serialQ;

@end
