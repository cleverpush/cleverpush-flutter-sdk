#import "CleverPushPlugin.h"
#import "CPChatViewFlutter.h"
#import "UIColor+HexString.h"
#import <objc/runtime.h>

@interface CleverPushPlugin ()

@property (strong, nonatomic) CPNotificationOpenedResult *coldStartOpenResult;
@property (strong, nonatomic) NSDictionary *launchOptions;
@property (nonatomic) BOOL hasNotificationOpenedHandler;

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
    CleverPushPlugin.sharedInstance.hasNotificationOpenedHandler = NO;

    CleverPushPlugin.sharedInstance.channel = [FlutterMethodChannel
                                               methodChannelWithName:@"CleverPush"
                                               binaryMessenger:[registrar messenger]];

    [registrar addMethodCallDelegate:CleverPushPlugin.sharedInstance channel:CleverPushPlugin.sharedInstance.channel];

    CPChatViewFlutterFactory* factory = [[CPChatViewFlutterFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:factory withId:@"cleverpush-chat-view"];

    [registrar addApplicationDelegate:CleverPushPlugin.sharedInstance];
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    CleverPushPlugin.sharedInstance.launchOptions = launchOptions;

    return YES;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"CleverPush Flutter: handleMethodCall %@", call.method);
    if ([@"CleverPush#init" isEqualToString:call.method])
        [self initCleverPush:call withResult:result];
    else if ([@"CleverPush#subscribe" isEqualToString:call.method])
        [self subscribe:call withResult:result];
    else if ([@"CleverPush#unsubscribe" isEqualToString:call.method])
        [self unsubscribe:call withResult:result];
    else if ([@"CleverPush#isSubscribed" isEqualToString:call.method])
        [self isSubscribed:call withResult:result];
    else if ([@"CleverPush#areNotificationsEnabled" isEqualToString:call.method])
        [self areNotificationsEnabled:call withResult:result];
    else if ([@"CleverPush#getSubscriptionId" isEqualToString:call.method])
        [self getSubscriptionId:call withResult:result];
    else if ([@"CleverPush#getDeviceToken" isEqualToString:call.method])
        [self getDeviceToken:call withResult:result];
    else if ([@"CleverPush#showTopicsDialog" isEqualToString:call.method])
        [self showTopicsDialog:call withResult:result];
    else if ([@"CleverPush#getNotifications" isEqualToString:call.method])
        [self getNotifications:call withResult:result];
    else if ([@"CleverPush#getNotificationsWithApi" isEqualToString:call.method])
        [self getNotificationsWithApi:call withResult:result];
    else if ([@"CleverPush#getSubscriptionTopics" isEqualToString:call.method])
        [self getSubscriptionTopics:call withResult:result];
    else if ([@"CleverPush#setSubscriptionTopics" isEqualToString:call.method])
        [self setSubscriptionTopics:call withResult:result];
    else if ([@"CleverPush#getAvailableTopics" isEqualToString:call.method])
        [self getAvailableTopics:call withResult:result];
    else if ([@"CleverPush#getAvailableAttributes" isEqualToString:call.method])
        [self getAvailableAttributes:call withResult:result];
    else if ([@"CleverPush#getSubscriptionTags" isEqualToString:call.method])
        [self getSubscriptionTags:call withResult:result];
    else if ([@"CleverPush#addSubscriptionTag" isEqualToString:call.method])
        [self addSubscriptionTag:call withResult:result];
    else if ([@"CleverPush#addSubscriptionTags" isEqualToString:call.method]) 
        [self addSubscriptionTags:call withResult:result];
    else if ([@"CleverPush#removeSubscriptionTag" isEqualToString:call.method])
        [self removeSubscriptionTag:call withResult:result];
    else if ([@"CleverPush#removeSubscriptionTags" isEqualToString:call.method]) 
        [self removeSubscriptionTags:call withResult:result];
    else if ([@"CleverPush#getAvailableTags" isEqualToString:call.method])
        [self getAvailableTags:call withResult:result];
    else if ([@"CleverPush#getSubscriptionAttributes" isEqualToString:call.method])
        [self getSubscriptionAttributes:call withResult:result];
    else if ([@"CleverPush#getSubscriptionAttribute" isEqualToString:call.method])
        [self getSubscriptionAttribute:call withResult:result];
    else if ([@"CleverPush#setSubscriptionAttribute" isEqualToString:call.method])
        [self setSubscriptionAttribute:call withResult:result];
    else if ([@"CleverPush#initNotificationOpenedHandlerParams" isEqualToString:call.method])
        [self initNotificationOpenedHandlerParams];
    else if ([@"CleverPush#setShowNotificationsInForeground" isEqualToString:call.method])
        [self setShowNotificationsInForeground:call withResult:result];
    else if ([@"CleverPush#setTrackingConsentRequired" isEqualToString:call.method])
        [self setTrackingConsentRequired:call withResult:result];
    else if ([@"CleverPush#setTrackingConsent" isEqualToString:call.method])
        [self setTrackingConsent:call withResult:result];
    else if ([@"CleverPush#setIgnoreDisabledNotificationPermission" isEqualToString:call.method])
        [self setIgnoreDisabledNotificationPermission:call withResult:result];
    else if ([@"CleverPush#setAutoRequestNotificationPermission" isEqualToString:call.method])
        [self setAutoRequestNotificationPermission:call withResult:result];
    else if ([@"CleverPush#setBrandingColor" isEqualToString:call.method])
        [self setBrandingColor:call withResult:result];
    else if ([@"CleverPush#enableAppBanners" isEqualToString:call.method])
        [self enableAppBanners:call withResult:result];
    else if ([@"CleverPush#disableAppBanners" isEqualToString:call.method])
        [self disableAppBanners:call withResult:result];
    else if ([@"CleverPush#initNotificationOpenedHandlerParams" isEqualToString:call.method])
        [self initNotificationOpenedHandlerParams];
    else if ([@"CleverPush#enableDevelopmentMode" isEqualToString:call.method])
        [self enableDevelopmentMode:call withResult:result];
    else if ([@"CleverPush#setLogListener" isEqualToString:call.method])
      [self setLogListener:call withResult:result];
    else if ([@"CleverPush#trackPageView" isEqualToString:call.method])
      [self trackPageView:call withResult:result];
    else if ([@"CleverPush#setAuthorizerToken" isEqualToString:call.method])
      [self setAuthorizerToken:call withResult:result];
    else if ([@"CleverPush#trackEvent" isEqualToString:call.method])
      [self trackEvent:call withResult:result];
    else if ([@"CleverPush#triggerFollowUpEvent" isEqualToString:call.method])
      [self triggerFollowUpEvent:call withResult:result];
    else if ([@"CleverPush#setSubscriptionLanguage" isEqualToString:call.method])
      [self setSubscriptionLanguage:call withResult:result];
    else if ([@"CleverPush#setSubscriptionCountry" isEqualToString:call.method])
      [self setSubscriptionCountry:call withResult:result];
    else if ([@"CleverPush#pushSubscriptionAttributeValue" isEqualToString:call.method])
      [self pushSubscriptionAttributeValue:call withResult:result];
    else if ([@"CleverPush#pullSubscriptionAttributeValue" isEqualToString:call.method])
      [self pullSubscriptionAttributeValue:call withResult:result];
    else if ([@"CleverPush#showAppBanner" isEqualToString:call.method])
        [self showAppBanner:call withResult:result];
    else
        result(FlutterMethodNotImplemented);
}

- (void)initCleverPush:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString* channelId = call.arguments[@"channelId"];
    BOOL autoRegister = YES;
    if (call.arguments[@"autoRegister"] != nil) {
      autoRegister = [call.arguments[@"autoRegister"] boolValue];
    }

    [CleverPush initWithLaunchOptions:self.launchOptions channelId:channelId
           handleNotificationReceived:^(CPNotificationReceivedResult *result) {
        [self handleNotificationReceived:result];
    } handleNotificationOpened:^(CPNotificationOpenedResult *result) {
        if (!self.hasNotificationOpenedHandler) {
          self.coldStartOpenResult = result;
        } else {
          [self handleNotificationOpened:result];
        }
    } handleSubscribed:^(NSString *subscriptionId) {
        [self handleSubscribed:subscriptionId];
    } autoRegister:autoRegister handleInitialized:^(BOOL success, NSString * _Nullable failureMessage) {
        if (success) {
            [self handleInitializationResult:nil success:YES];
        } else {
            NSString *errorMessage = failureMessage ?: @"Initialization failed with unknown error.";
            [self handleInitializationResult:errorMessage success:NO];
        }
    }];

    [CleverPush setAppBannerShownCallback:^(CPAppBanner *appBanner) {
        [self handleAppBannerShown:appBanner];
    }];

    [CleverPush setAppBannerOpenedCallback:^(CPAppBannerAction *action) {
        [self handleAppBannerOpened:action];
    }];

    result(nil);
}

- (void)subscribe:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        [CleverPush subscribe:^(NSString *subscriptionId) {
            result(subscriptionId);
        } failure:^(NSError *error) {
            result(@"");
        }];
    });
}

- (void)unsubscribe:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        [CleverPush unsubscribe];
        result(nil);
    });
}

- (void)isSubscribed:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    bool subscribed = [CleverPush isSubscribed];
    result([NSNumber numberWithBool:subscribed]);
}

- (void)areNotificationsEnabled:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush areNotificationsEnabled:^(BOOL enabled) {
        result([NSNumber numberWithBool:enabled]);
    }];
}

- (void)getSubscriptionId:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush getSubscriptionId:^(NSString *subscriptionId) {
        result(subscriptionId);
    }];
}

- (void)getDeviceToken:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush getDeviceToken:^(NSString *deviceToken) {
      if (deviceToken != nil && ![deviceToken isKindOfClass:[NSNull class]] && ![deviceToken isEqualToString:@""]) {
        result(deviceToken);
      } else {
        NSString *errorMessage = @"Device token is null or empty";
        result(errorMessage);
      }
    }];
}

- (UIWindow*)keyWindow {
    UIWindow *foundWindow = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (window.isKeyWindow) {
            foundWindow = window;
            break;
        }
    }
    return foundWindow;
}

- (void)showTopicsDialog:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        [CleverPush showTopicsDialog:[self keyWindow] callback:^() {
            result(nil);
        }];
    });
}

- (void)getNotifications:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSArray *storedNotifications = [CleverPush getNotifications];
    NSMutableArray *notifications = [NSMutableArray array];
    for (CPNotification *notification in storedNotifications) {
        NSDictionary *dict = [self dictionaryWithPropertiesOfObject:notification];
        [notifications addObject:dict];
    }
    result(notifications);
}

- (void)getNotificationsWithApi:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSMutableArray *remoteNotifications = [NSMutableArray new];
    [CleverPush getNotifications:call.arguments[@"combineWithApi"] callback:^(NSArray* Notifications) {
        for (CPNotification *notification in Notifications) {
            NSDictionary *dict = [self dictionaryWithPropertiesOfObject:notification];
            [remoteNotifications addObject:dict];
        }
        result(remoteNotifications);
    }];
}

- (void)getSubscriptionTopics:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSMutableArray *topicIds = [CleverPush getSubscriptionTopics];
    NSMutableArray *list = [NSMutableArray arrayWithArray:topicIds];
    result(list);
}

- (void)setSubscriptionTopics:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush setSubscriptionTopics:call.arguments[@"topics"] onSuccess:^{
        [self handleSubscriptionTopics:nil success:YES];
        result(@YES);
    } onFailure:^(NSError * _Nullable error) {
        NSString *errorMessage = error.localizedDescription ?: @"Failed to set subscription topics";
        [self handleSubscriptionTopics:errorMessage success:NO];
        result(errorMessage);
    }];
}

- (void)getAvailableTopics:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSMutableArray *availableTopics = [NSMutableArray new];
    [CleverPush getAvailableTopics:^(NSArray* channelTopics_) {
        for (CPChannelTopic *topic in channelTopics_) {
            NSDictionary *dict = [self dictionaryWithPropertiesOfObject:topic];
            [availableTopics addObject:dict];
        }
        result(availableTopics);
    }];
}

- (void)getSubscriptionTags:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSArray *tagIds = [CleverPush getSubscriptionTags];
    NSMutableArray *list = [NSMutableArray arrayWithArray:tagIds];
    result(list);
}

- (void)addSubscriptionTag:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush addSubscriptionTag:call.arguments[@"id"] callback:^(NSString * _Nullable tag) {
        result(nil);
    } onFailure:^(NSError * _Nullable error) {
        result(nil);
    }];
}

- (void)addSubscriptionTags:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSArray *tags = call.arguments[@"ids"];
    [CleverPush addSubscriptionTags:tags callback:^(NSArray *addedTags) {
        result(nil);
    }];
}

- (void)removeSubscriptionTag:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush removeSubscriptionTag:call.arguments[@"id"] callback:^(NSString * _Nullable tag) {
        result(nil);
    } onFailure:^(NSError * _Nullable error) {
        result(nil);
    }];
}

- (void)removeSubscriptionTags:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSArray *tags = call.arguments[@"ids"];
    [CleverPush removeSubscriptionTags:tags callback:^(NSArray *removedTags) {
        result(nil);
    }];
}

- (void)pushSubscriptionAttributeValue:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush pushSubscriptionAttributeValue:call.arguments[@"id"] value:call.arguments[@"value"]];
    result(nil);
}

- (void)pullSubscriptionAttributeValue:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush pullSubscriptionAttributeValue:call.arguments[@"id"] value:call.arguments[@"value"]];
    result(nil);
}

- (void)getAvailableTags:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSMutableArray *availableTags = [NSMutableArray new];
    [CleverPush getAvailableTags:^(NSArray* channelTags_) {
        for (CPChannelTag *tag in channelTags_) {
            NSDictionary *dict = [self dictionaryWithPropertiesOfObject:tag];
            [availableTags addObject:dict];
        }
        result(availableTags);
    }];
}

- (void)getSubscriptionAttributes:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSDictionary *attributes = [CleverPush getSubscriptionAttributes];
    result(attributes);
}

- (void)setSubscriptionAttribute:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush setSubscriptionAttribute:call.arguments[@"id"] value:call.arguments[@"value"] callback:^{
        result(nil);
    }];
}

- (void)getSubscriptionAttribute:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    result([CleverPush getSubscriptionAttribute:call.arguments[@"id"]]);
}

- (void)getAvailableAttributes:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush getAvailableAttributes:^(NSMutableArray* attributes_) {
        NSMutableArray *availableAttributes = [NSMutableArray new];
        for (NSMutableDictionary* attribute in attributes_) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[attribute objectForKey:@"id"] forKey:@"id"];
            [dict setObject:[attribute objectForKey:@"name"] forKey:@"name"];
            [availableAttributes addObject:dict];
        }
        result(availableAttributes);
    }];
}

- (void)setShowNotificationsInForeground:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush setShowNotificationsInForeground:[call.arguments[@"show"] boolValue]];
    result(nil);
}

- (void)setTrackingConsentRequired:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush setTrackingConsentRequired:[call.arguments[@"consentRequired"] boolValue]];
    result(nil);
}

- (void)setTrackingConsent:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush setTrackingConsent:[call.arguments[@"hasConsent"] boolValue]];
    result(nil);
}

- (void)setIgnoreDisabledNotificationPermission:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush setIgnoreDisabledNotificationPermission:[call.arguments[@"ignore"] boolValue]];
    result(nil);
}

- (void)setAutoRequestNotificationPermission:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush setAutoRequestNotificationPermission:[call.arguments[@"autoRequest"] boolValue]];
    result(nil);
}

- (void)enableAppBanners:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush enableAppBanners];
    result(nil);
}

- (void)disableAppBanners:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush disableAppBanners];
    result(nil);
}

- (void)enableDevelopmentMode:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush enableDevelopmentMode];
    result(nil);
}

- (void)setBrandingColor:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush setBrandingColor:[UIColor colorWithHexString:call.arguments[@"color"]]];
    result(nil);
}

- (void)initNotificationOpenedHandlerParams {
    self.hasNotificationOpenedHandler = YES;
    if (self.coldStartOpenResult) {
        [self handleNotificationOpened:self.coldStartOpenResult];
        self.coldStartOpenResult = nil;
    }
}

- (void)setLogListener:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush setLogListener:^(NSString* message) {
        NSMutableDictionary *resultDict = [NSMutableDictionary new];
        resultDict[@"message"] = message;
        [self.channel invokeMethod:@"CleverPush#handleLog" arguments:resultDict];
    }];
    result(nil);
}

- (void)trackPageView:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush trackPageView:call.arguments[@"url"]];
    result(nil);
}

- (void)setAuthorizerToken:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush setAuthorizerToken:call.arguments[@"token"]];
    result(nil);
}

- (void)trackEvent:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSString *eventName = call.arguments[@"eventName"];
    NSNumber *amount = call.arguments[@"amount"];
    NSDictionary *properties = call.arguments[@"properties"];
    if (properties != nil) {
        [CleverPush trackEvent:eventName properties:properties];
    } else if (amount != nil) {
        [CleverPush trackEvent:eventName amount:amount];
    } else {
        [CleverPush trackEvent:eventName];
    }
    result(nil);
}

- (void)triggerFollowUpEvent:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush triggerFollowUpEvent:call.arguments[@"eventName"] parameters:call.arguments[@"parameters"]];
    result(nil);
}

- (void)setSubscriptionLanguage:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush setSubscriptionLanguage:call.arguments[@"language"]];
    result(nil);
}

- (void)setSubscriptionCountry:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush setSubscriptionCountry:call.arguments[@"country"]];
    result(nil);
}

- (void)handleSubscribed:(NSString *)result {
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    resultDict[@"subscriptionId"] = result;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"CleverPush#handleSubscribed" arguments:resultDict];
    });
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

- (void)handleAppBannerShown:(CPAppBanner *)appBanner {
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    resultDict[@"appBanner"] = [self dictionaryWithPropertiesOfObject:appBanner];
    [self.channel invokeMethod:@"CleverPush#handleAppBannerShown" arguments:resultDict];
}

- (void)handleAppBannerOpened:(CPAppBannerAction *)action {
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    resultDict[@"action"] = [self dictionaryWithPropertiesOfObject:action];
    [self.channel invokeMethod:@"CleverPush#handleAppBannerOpened" arguments:resultDict];
}

- (void)handleInitializationResult:(NSString *)failureMessage success:(BOOL)success {
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    resultDict[@"failureMessage"] = failureMessage;
    resultDict[@"success"] = @(success);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"CleverPush#handleInitialized" arguments:resultDict];
    });
}

- (void)handleSubscriptionTopics:(NSString *)failureMessage success:(BOOL)success {
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    resultDict[@"failureMessage"] = failureMessage;
    resultDict[@"success"] = @(success);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"CleverPush#handleSubscriptionTopics" arguments:resultDict];
    });
}

- (void)showAppBanner:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush showAppBanner:call.arguments[@"id"]];
    result(nil);
}

- (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id object = [obj valueForKey:key];

        if (object) {
            if ([object isKindOfClass:[NSArray class]]) {
                NSMutableArray *subObj = [NSMutableArray array];
                for (id o in object) {
                    if ([o isKindOfClass:[NSDictionary class]]) {
                        [subObj addObject:o];
                    } else {
                        [subObj addObject:[self dictionaryWithPropertiesOfObject:o]];
                    }
                }
                dict[key] = subObj;
            } else if (
                       [object isKindOfClass:[NSString class]]
                       || [object isKindOfClass:[NSNumber class]]
                       || [object isKindOfClass:[NSDictionary class]]
                       ) {
                dict[key] = object;
            } else if ([object isKindOfClass:[NSDate class]]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                NSString *convertedDateString = [dateFormatter stringFromDate:[obj valueForKey:key]];
                [dict setObject:convertedDateString forKey:key];
            }  else if ([object isKindOfClass:[NSURL class]]) {
                dict[key] = [object absoluteString];
            }
        }
    }
    free(properties);
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
