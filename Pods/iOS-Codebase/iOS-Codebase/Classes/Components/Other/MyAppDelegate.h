//
//  MyAppDelegate.h
//  oncost
//
//  Created by Hamidreza Vakilian on 3/18/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

@interface MyAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, readonly) RACSignal<UIApplication*>* willResignActiveSignal;
@property (nonatomic, readonly) RACSignal<UIApplication*>* didEnterBackgroundSignal;
@property (nonatomic, readonly) RACSignal<UIApplication*>* willEnterForegroundSignal;
@property (nonatomic, readonly) RACSignal<UIApplication*>* didBecomeActiveSignal;
@property (nonatomic, readonly) RACSignal<UIApplication*>* willTerminateSignal;
@property (nonatomic, readwrite) RACSignal<NSValue*>* willChangeStatusBarFrameSignal;
@property (nonatomic, readwrite) RACSignal<NSValue*>* didChangeStatusBarFrameSignal;
@property (strong, nonatomic) UIWindow *window;

/**
 Request for push notification registration proccess. On any error it will return it on the onError of signal. If everything goes well, it will call your block wich gives you the notifStringToken + a callback. On this block perform any request to your server and at the end return the status of through the callback argument, so that this class won't call your callback thereafter. To reset the process call deleteAllNotificationTokens and resubscribe to this signal. subscribe to this method on the overridden method for registerPushNotification on your AppDelegate.h file.
 
 @param cb The call back with notifStringToken and a result callback argument
 @return The signal
 */
-(RACSignal*)registerPushNotiServerRegistrationCB:(void (^)(NSString* notifToken, void (^callback)(BOOL success)))cb;

/**
 Delete all related key/value information for push notification tokens.
 */
-(void)deleteAllNotificationTokens;


/**
 The last operation after didFinishLaunching. Determine the viewController and set it as the rootViewController of the main window.
 */
-(void)determineVC2Show;

/**
 override this method on your AppDelegate.h file to perform any UIAppearance or uniconf configuration. Is called before determineVC2Show.
 */
-(void)configAppearance;


/**
 override this method on your AppDelegate.h file to perform push notification registration process. You may need to subscribe to registerPushNotiServerRegistrationCB: for convenience.
 */
-(void)registerPushNotification;

@end
