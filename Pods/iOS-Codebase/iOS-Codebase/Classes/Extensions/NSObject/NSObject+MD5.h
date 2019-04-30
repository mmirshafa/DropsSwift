//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

@interface myMD5Obj : NSObject
-(NSString*)getHashAndDestroy;
@end


@interface NSObject (MD5)

-(NSString *)MD5;
-(myMD5Obj*)updateMD5HashWithMD5Obj:(myMD5Obj*)obj;
@end

