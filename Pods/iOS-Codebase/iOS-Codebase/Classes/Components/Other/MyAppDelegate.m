//
//  MyAppDelegate.m
//  oncost
//
//  Created by Hamidreza Vakilian on 3/18/1397 AP.
//  Copyright © 1397 oncost. All rights reserved.
//

#import "MyAppDelegate.h"
#import "DBModel.h"
#import "Codebase_definitions.h"

#ifdef DEBUG
#define _ENV @"development"
#define _NOTIF_TYPE @"dev"
#define _NOTIF_TOKEN_KEY @"notif-token-dev"
#define _NOTIF_TOKEN_REGISTERED_KEY @"notif-token-registered-dev"
#else
#define _ENV @"production"
#define _NOTIF_TYPE @"prod"
#define _NOTIF_TOKEN_KEY @"notif-token-prod"
#define _NOTIF_TOKEN_REGISTERED_KEY @"notif-token-registered-prod"
#endif

@interface MyAppDelegate ()

@property (nonatomic, readwrite) RACSubject<UIApplication*>* willResignActiveSubject;
@property (nonatomic, readwrite) RACSubject<UIApplication*>* didEnterBackgroundSubject;
@property (nonatomic, readwrite) RACSubject<UIApplication*>* willEnterForegroundSubject;
@property (nonatomic, readwrite) RACSubject<UIApplication*>* didBecomeActiveSubject;
@property (nonatomic, readwrite) RACSubject<UIApplication*>* willTerminateSubject;
@property (nonatomic, readwrite) RACSubject<NSValue*>* willChangeStatusBarFrameSubject;
@property (nonatomic, readwrite) RACSubject<NSValue*>* didChangeStatusBarFrameSubject;


@end

@implementation MyAppDelegate

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    self.willResignActiveSubject = [RACSubject new];
    self.didEnterBackgroundSubject = [RACSubject new];
    self.willEnterForegroundSubject = [RACSubject new];
    self.didBecomeActiveSubject = [RACSubject new];
    self.willTerminateSubject = [RACSubject new];
    self.willChangeStatusBarFrameSubject = [RACSubject new];
    self.didChangeStatusBarFrameSubject = [RACSubject new];
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configAppearance];
    [self registerPushNotification];
    [self determineVC2Show];
    
    return YES;
}

-(RACSignal*)registerPushNotiServerRegistrationCB:(void (^)(NSString* notifToken, void (^callback)(BOOL success)))cb
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        // we have obtained the token and we have already registered the device notif token with our server
        if (_bool_true([DBModel valueForKey:_NOTIF_TOKEN_REGISTERED_KEY]))
        {
            [subscriber sendCompleted];
            return nil;
        }
        
        void(^registerWithSevrerBlock)(NSString* stringToken) = ^(NSString* stringToken) {
            if (cb)
            {
                cb(stringToken, ^(BOOL success) {
                    if (success)
                    {
                        [DBModel updateValue:@true forKey:_NOTIF_TOKEN_REGISTERED_KEY];
                        [subscriber sendCompleted];
                    }
                    else
                    [subscriber sendError:[NSError errorWithDomain:NSMachErrorDomain code:500 userInfo:@{@"msg": @"Server registration callback returned without a successful code."}]];
                });
            }
            else
            {
                [subscriber sendError:[NSError errorWithDomain:NSMachErrorDomain code:500 userInfo:@{@"msg": @"No callback was set for registerPushNotiServerRegistrationCB:"}]];
            }
        };
        
        // we have obtained the token but we have not registered the device notif token with our server
        if (_str_ok2([DBModel valueForKey:_NOTIF_TOKEN_KEY]))
        {
            NSString* stringToken = [DBModel valueForKey:_NOTIF_TOKEN_KEY];
            registerWithSevrerBlock(stringToken);
            return nil;
        }
        
        RACCompoundDisposable* disposable = [RACCompoundDisposable new];
        
        RACDisposable* d1 = [[self rac_signalForSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)] subscribeNext:^(RACTuple * _Nullable x) {
            NSError* error = x.second;
            [subscriber sendError:error];
        }];
        
        RACDisposable* d2 = [[self rac_signalForSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)] subscribeNext:^(RACTuple * _Nullable x) {
            NSData* deviceToken = x.second;
            
            NSString *stringToken = [self stringTokenFromDataToken:deviceToken];
            
            if (_str_ok2(stringToken))
            {
                [DBModel updateValue:stringToken forKey:_NOTIF_TOKEN_KEY];
                registerWithSevrerBlock(stringToken);
            }
            else
            {
                [subscriber sendError:[NSError errorWithDomain:NSMachErrorDomain code:500 userInfo:@{@"msg": @"OS returned a null string for notification token."}]];
            }
            
        }];
        
        //** execute registration process **/
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        [disposable addDisposable:d1];
        [disposable addDisposable:d2];
        
        return disposable;
    }];
}

-(NSString*)stringTokenFromDataToken:(NSData*)deviceToken
{
    const unsigned *tokenBytes = [deviceToken bytes];
    return [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
            ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
            ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
            ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
}

-(void)deleteAllNotificationTokens
{
    [DBModel deleteValueForKey:_NOTIF_TOKEN_KEY];
    [DBModel deleteValueForKey:_NOTIF_TOKEN_REGISTERED_KEY];
}

#pragma mark methods to override

-(void)determineVC2Show
{
    
}

-(void)configAppearance
{
    
}

-(void)registerPushNotification
{
    
}

#pragma mark other delegated methods

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [self.willResignActiveSubject sendNext:application];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.didEnterBackgroundSubject sendNext:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self.willEnterForegroundSubject sendNext:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.didBecomeActiveSubject sendNext:application];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.willTerminateSubject sendNext:application];
}

-(void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
    [self.willChangeStatusBarFrameSubject sendNext:[NSValue valueWithCGRect:newStatusBarFrame]];
}

-(void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
{
    [self.didChangeStatusBarFrameSubject sendNext:[NSValue valueWithCGRect:oldStatusBarFrame]];
}

#pragma mark returned signals

-(RACSignal<UIApplication *> *)willResignActiveSignal
{
    return self.willResignActiveSubject;
}

-(RACSignal<UIApplication *> *)didEnterBackgroundSignal
{
    return self.didEnterBackgroundSubject;
}

-(RACSignal<UIApplication *> *)willEnterForegroundSignal
{
    return self.willEnterForegroundSubject;
}

-(RACSignal<UIApplication *> *)didBecomeActiveSignal
{
    return self.didBecomeActiveSubject;
}

-(RACSignal<UIApplication *> *)willTerminateSignal
{
    return self.willTerminateSubject;
}

-(RACSignal<NSValue *> *)willChangeStatusBarFrameSignal
{
    return self.willChangeStatusBarFrameSubject;
}

-(RACSignal<NSValue *> *)didChangeStatusBarFrameSignal
{
    return self.didChangeStatusBarFrameSubject;
}
@end
