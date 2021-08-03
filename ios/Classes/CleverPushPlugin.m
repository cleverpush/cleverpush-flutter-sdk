#import "CleverPushPlugin.h"
#import <objc/runtime.h>
@interface CleverPushPlugin ()

@property (strong, nonatomic) FlutterMethodChannel *channel;
@property (strong, nonatomic) CPNotificationOpenedResult *coldStartOpenResult;

@end

@implementation CleverPushPlugin

+ (instancetype)sharedInstance {
    static CleverPushPlugin *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [CleverPushPlugin new];
    });
    return sharedInstance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    /*
    [CleverPush initWithLaunchOptions:nil channelId:nil handleNotificationOpened:^(CPNotificationOpenedResult *result) {
        CleverPushPlugin.sharedInstance.coldStartOpenResult = result;
    }];
    */

    CleverPushPlugin.sharedInstance.channel = [FlutterMethodChannel
                                     methodChannelWithName:@"CleverPush"
                                     binaryMessenger:[registrar messenger]];

    [registrar addMethodCallDelegate:CleverPushPlugin.sharedInstance channel:CleverPushPlugin.sharedInstance.channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"CleverPush#init" isEqualToString:call.method])
        [self initCleverPush:call withResult:result];
    else if ([@"CleverPush#subscribe" isEqualToString:call.method])
        [self subscribe:call withResult:result];
    else if ([@"CleverPush#unsubscribe" isEqualToString:call.method])
        [self unsubscribe:call withResult:result];
    else if ([@"CleverPush#isSubscribed" isEqualToString:call.method])
        result([NSNumber numberWithBool:CleverPush.isSubscribed]);
    else if ([@"CleverPush#showTopicsDialog" isEqualToString:call.method])
        [self showTopicsDialog:call withResult:result];
    else if ([@"CleverPush#initNotificationOpenedHandlerParams" isEqualToString:call.method])
        [self initNotificationOpenedHandlerParams];
    else
        result(FlutterMethodNotImplemented);
}

- (void)initCleverPush:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush initWithLaunchOptions:nil channelId:call.arguments[@"channelId"]
     handleNotificationReceived:^(CPNotificationReceivedResult *result) {
      [self handleNotificationReceived:result];
    } handleNotificationOpened:^(CPNotificationOpenedResult *result) {
      [self handleNotificationOpened:result];
    } handleSubscribed:^(NSString *subscriptionId) {
      [self handleSubscribed:subscriptionId];
    } autoRegister:call.arguments[@"autoRegister"]];

    result(nil);
}

- (void)subscribe:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush subscribe];
    result(nil);
}

- (void)unsubscribe:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush unsubscribe];
    result(nil);
}

- (void)isSubscribed:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    bool subscribed = [CleverPush isSubscribed];
    result([NSNumber numberWithBool:subscribed]);
}

- (void)showTopicsDialog:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush showTopicsDialog];
    result(nil);
}

- (void)initNotificationOpenedHandlerParams {
    if (self.coldStartOpenResult) {
        [self handleNotificationOpened:self.coldStartOpenResult];
        self.coldStartOpenResult = nil;
    }
}

- (void)handleSubscribed:(NSString *)result {
    [self.channel invokeMethod:@"CleverPush#handleSubscribed" arguments:result];
}

- (void)handleNotificationReceived:(CPNotificationReceivedResult *)result {
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    resultDict[@"notification"] = [self dictionaryWithPropertiesOfObject:result.notification];
    [self.channel invokeMethod:@"CleverPush#handleNotificationReceived" arguments:resultDict];
}

- (void)handleNotificationOpened:(CPNotificationOpenedResult *)result {
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    resultDict[@"notification"] = [self dictionaryWithPropertiesOfObject:result.notification];
    [self.channel invokeMethod:@"CleverPush#handleNotificationOpened" arguments:resultDict];
}

- (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);

    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([obj valueForKey:key] != nil) {
            if ([[obj valueForKey:key] isKindOfClass:[NSDate class]]) {
                NSString *convertedDateString = [NSString stringWithFormat:@"%@", [obj valueForKey:key]];
                [dict setObject:convertedDateString forKey:key];
            } else {
                [dict setObject:[obj valueForKey:key] forKey:key];
            }
        }
    }
    
    free(properties);
    return [NSDictionary dictionaryWithDictionary:dict];
}
@end
