//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#import "NSObject+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@interface myMD5Obj ()
{
    BOOL isDestroyed;
}
@property (retain, nonatomic) NSValue* pointer2MD5;
@end

@implementation myMD5Obj

-(CC_MD5_CTX*)__md5
{
    if (_pointer2MD5)
        return (CC_MD5_CTX*)[_pointer2MD5 pointerValue];
    else
    {
        CC_MD5_CTX* __md5 = (CC_MD5_CTX*)malloc(sizeof(CC_MD5_CTX));
        CC_MD5_Init(__md5);
        _pointer2MD5 = [NSValue valueWithPointer:__md5];
        return __md5;
    }
}

-(instancetype)updateHashWithData:(NSData*)data
{
    CC_MD5_CTX* __md5 = [self __md5];
    CC_MD5_Update(__md5, [data bytes], (CC_LONG)[data length]);
    return self;
}

-(instancetype)updateHashCStr:(const char*)data
{
    CC_MD5_CTX* __md5 = [self __md5];
    CC_MD5_Update(__md5, data, (CC_LONG)strlen(data));
    return self;
}
-(NSString *)getHashAndDestroy
{
    NSAssert(isDestroyed != true, @"it's destroyed!");
    
    CC_MD5_CTX* __md5 = [self __md5];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, __md5);
    free(__md5);
    
    isDestroyed = YES;
    
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            digest[0], digest[1],
            digest[2], digest[3],
            digest[4], digest[5],
            digest[6], digest[7],
            digest[8], digest[9],
            digest[10], digest[11],
            digest[12], digest[13],
            digest[14], digest[15]];
}


@end

@implementation NSObject (MD5)

- (NSString*)MD5
{
    return nil;
}

-(myMD5Obj*)updateMD5HashWithMD5Obj:(myMD5Obj*)obj
{
    return nil;
}

@end

@implementation NSData (MD5)

- (NSString*)MD5
{
    // Create byte array of unsigned chars
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(self.bytes, (CC_LONG)self.length, digest);
    
    // Convert unsigned char buffer to NSString of hex values
    //  NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    //  for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    //        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            digest[0], digest[1],
            digest[2], digest[3],
            digest[4], digest[5],
            digest[6], digest[7],
            digest[8], digest[9],
            digest[10], digest[11],
            digest[12], digest[13],
            digest[14], digest[15]];
}

-(myMD5Obj*)updateMD5HashWithMD5Obj:(myMD5Obj*)obj
{
    if (obj)
        return [obj updateHashWithData:self];
    else
    {
        myMD5Obj* obj = [myMD5Obj new];
        return [obj updateHashWithData:self];
    }
}

@end


@implementation NSString(MD5)

- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 bytes MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), digest);
    
    //    // Convert unsigned char buffer to NSString of hex values
    //    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    //    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    //        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            digest[0], digest[1],
            digest[2], digest[3],
            digest[4], digest[5],
            digest[6], digest[7],
            digest[8], digest[9],
            digest[10], digest[11],
            digest[12], digest[13],
            digest[14], digest[15]];
    
    //    return output;
}

-(myMD5Obj*)updateMD5HashWithMD5Obj:(myMD5Obj*)obj
{
    const char* cstr = [self UTF8String];
    
    if (obj)
        return [obj updateHashCStr:cstr];
    else
    {
        myMD5Obj* obj = [myMD5Obj new];
        return [obj updateHashCStr:cstr];
    }
}

@end

