//
//  helper_authorization.m
//  iOS-Codebase
//
//  Created by Hamidreza Vakilian on 8/11/1396 AP.
//

#import "helper_authorization.h"
#import <AVFoundation/AVFoundation.h>
#import "helper.h"

@implementation helper_authorization


+(void)camera_ask:(BOOL)askForAuthorization authorized:(void (^)())hasAccessBlock restricted:(void (^)())restrictedAccessBlock
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        hasAccessBlock ? hasAccessBlock() : 0;
    }
    else if(authStatus == AVAuthorizationStatusNotDetermined)
    {
        if (askForAuthorization)
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if(granted)
                 {
                     _mainThread(^{
                         hasAccessBlock ? hasAccessBlock() : 0;
                     });
                 }
                 else
                 {
                     _mainThreadAfter(^{
                         restrictedAccessBlock ? restrictedAccessBlock() : 0;
                     }, .35);
                 }
             }];
        }
        else
            restrictedAccessBlock ? restrictedAccessBlock() : 0;
    }
    else if (authStatus == AVAuthorizationStatusRestricted)
    {
        restrictedAccessBlock ? restrictedAccessBlock() : 0;
    }
    else
    {
        restrictedAccessBlock ? restrictedAccessBlock() : 0;
    }
}

@end

