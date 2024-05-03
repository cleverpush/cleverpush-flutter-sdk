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
    } autoRegister:autoRegister];

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
            result(error.localizedDescription);
        }];
    });
}

- (void)unsubscribe:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        [CleverPush unsubscribe:^(BOOL success) {
            if (success) {
                result(nil);
            } else {
                result(@"unsubscribe failure");
            }
        }];
    });
}

- (void)isSubscribed:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        bool subscribed = [CleverPush isSubscribed];
        result([NSNumber numberWithBool:subscribed]);
    } @catch (NSException *exception) {
        result(exception.reason);
    }
}

- (void)areNotificationsEnabled:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush areNotificationsEnabled:^(BOOL enabled) {
            result([NSNumber numberWithBool:enabled]);
        }];
    } @catch (NSException *exception) {
        result(exception.reason);
    }
}

- (void)getSubscriptionId:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush getSubscriptionId:^(NSString *subscriptionId) {
        if (subscriptionId != nil && ![subscriptionId isKindOfClass:[NSNull class]] && ![subscriptionId isEqualToString:@""]) {
            result(subscriptionId);
        } else {
            result(@"Subscription ID is null or empty");
        }
    }];
}

- (void)getDeviceToken:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush getDeviceToken:^(NSString *deviceToken) {
        if (deviceToken != nil && ![deviceToken isKindOfClass:[NSNull class]] && ![deviceToken isEqualToString:@""]) {
            result(deviceToken);
        } else {
            result(@"Device token is null or empty");
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
        @try {
            [CleverPush showTopicsDialog:[self keyWindow] callback:^{
                result(nil);
            }];
        } @catch (NSException *exception) {
            NSString *errorMessage = [NSString stringWithFormat:@"Error showing topics dialog: %@", exception.reason];
            result(errorMessage);
        }
    });
}

- (void)getNotifications:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        NSArray *storedNotifications = [CleverPush getNotifications];
        NSMutableArray *notifications = [NSMutableArray array];
        for (CPNotification *notification in storedNotifications) {
            NSDictionary *dict = [self dictionaryWithPropertiesOfObject:notification];
            [notifications addObject:dict];
        }
        result(notifications);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error getting notifications: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)getNotificationsWithApi:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSMutableArray *remoteNotifications = [NSMutableArray new];
    @try {
        [CleverPush getNotifications:call.arguments[@"combineWithApi"] callback:^(NSArray* Notifications) {
            for (CPNotification *notification in Notifications) {
                NSDictionary *dict = [self dictionaryWithPropertiesOfObject:notification];
                [remoteNotifications addObject:dict];
            }
            result(remoteNotifications);
        }];
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error getting notifications: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)getSubscriptionTopics:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        NSMutableArray *topicIds = [CleverPush getSubscriptionTopics];
        NSMutableArray *list = [NSMutableArray arrayWithArray:topicIds];
        result(list);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error getting subscription topics: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)setSubscriptionTopics:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush setSubscriptionTopics:call.arguments[@"topics"]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error setting subscription topics: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)getAvailableTopics:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSMutableArray *availableTopics = [NSMutableArray new];
    @try {
        [CleverPush getAvailableTopics:^(NSArray* channelTopics_) {
            for (CPChannelTopic *topic in channelTopics_) {
                NSDictionary *dict = [self dictionaryWithPropertiesOfObject:topic];
                [availableTopics addObject:dict];
            }
            result(availableTopics);
        }];
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error getting available topics: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)getSubscriptionTags:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        NSArray *tagIds = [CleverPush getSubscriptionTags];
        NSMutableArray *list = [NSMutableArray arrayWithArray:tagIds];
        result(list);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error getting subscription tags: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)addSubscriptionTag:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush addSubscriptionTag:call.arguments[@"id"]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error adding subscription tag: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)addSubscriptionTags:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSArray *tags = call.arguments[@"ids"];
    @try {
        [CleverPush addSubscriptionTags:tags callback:^(NSArray *addedTags) {
            NSLog(@"%@", addedTags);
        }];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error adding subscription tags: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)removeSubscriptionTag:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush removeSubscriptionTag:call.arguments[@"id"]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error removing subscription tag: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)removeSubscriptionTags:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSArray *tags = call.arguments[@"ids"];
    @try {
        [CleverPush removeSubscriptionTags:tags callback:^(NSArray *removedTags) {
            NSLog(@"%@", removedTags);
        }];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error removing subscription tags: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)pushSubscriptionAttributeValue:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush pushSubscriptionAttributeValue:call.arguments[@"id"] value:call.arguments[@"value"]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error pushing subscription attribute value: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)pullSubscriptionAttributeValue:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush pullSubscriptionAttributeValue:call.arguments[@"id"] value:call.arguments[@"value"]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error pulling subscription attribute value: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)getAvailableTags:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSMutableArray *availableTags = [NSMutableArray new];
    @try {
        [CleverPush getAvailableTags:^(NSArray* channelTags_) {
            for (CPChannelTag *tag in channelTags_) {
                NSDictionary *dict = [self dictionaryWithPropertiesOfObject:tag];
                [availableTags addObject:dict];
            }
            result(availableTags);
        }];
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error getting available tags: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)getSubscriptionAttributes:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        NSDictionary *attributes = [CleverPush getSubscriptionAttributes];
        result(attributes);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error getting subscription attributes: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)setSubscriptionAttribute:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush setSubscriptionAttribute:call.arguments[@"id"] value:call.arguments[@"value"]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error setting subscription attribute: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)getSubscriptionAttribute:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        id attribute = [CleverPush getSubscriptionAttribute:call.arguments[@"id"]];
        result(attribute);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error getting subscription attribute: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)getAvailableAttributes:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    [CleverPush getAvailableAttributes:^(NSMutableArray* attributes_) {
        @try {
            NSMutableArray *availableAttributes = [NSMutableArray new];
            for (NSMutableDictionary* attribute in attributes_) {
                NSMutableDictionary *dict = [NSMutableDictionary new];
                [dict setObject:[attribute objectForKey:@"id"] forKey:@"id"];
                [dict setObject:[attribute objectForKey:@"name"] forKey:@"name"];
                [availableAttributes addObject:dict];
            }
            result(availableAttributes);
        }
        @catch (NSException *exception) {
            NSString *errorMessage = [NSString stringWithFormat:@"Error getting available attributes: %@", exception.reason];
            result(errorMessage);
        }
    }];
}

- (void)setShowNotificationsInForeground:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush setShowNotificationsInForeground:[call.arguments[@"show"] boolValue]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error setting show notifications in foreground: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)setTrackingConsentRequired:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush setTrackingConsentRequired:[call.arguments[@"consentRequired"] boolValue]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error setting tracking consent required: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)setTrackingConsent:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush setTrackingConsent:[call.arguments[@"hasConsent"] boolValue]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error setting tracking consent: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)enableAppBanners:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush enableAppBanners];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error enabling app banners: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)disableAppBanners:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush disableAppBanners];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error disabling app banners: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)enableDevelopmentMode:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush enableDevelopmentMode];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error enabling development mode: %@", exception.reason];
        result(exception);
    }
}

- (void)setBrandingColor:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush setBrandingColor:[UIColor colorWithHexString:call.arguments[@"color"]]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error setting branding color: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)initNotificationOpenedHandlerParams {
    @try {
        self.hasNotificationOpenedHandler = YES;
        if (self.coldStartOpenResult) {
            [self handleNotificationOpened:self.coldStartOpenResult];
            self.coldStartOpenResult = nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error initializing notification opened handler params: %@", exception.reason);
    }
}

- (void)setLogListener:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush setLogListener:^(NSString* message) {
            NSMutableDictionary *resultDict = [NSMutableDictionary new];
            resultDict[@"message"] = message;
            [self.channel invokeMethod:@"CleverPush#handleLog" arguments:resultDict];
        }];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error setting log listener: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)trackPageView:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush trackPageView:call.arguments[@"url"]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error tracking page view: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)setAuthorizerToken:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush setAuthorizerToken:call.arguments[@"token"]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error setting authorizer token: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)trackEvent:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
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
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error tracking event: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)triggerFollowUpEvent:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush triggerFollowUpEvent:call.arguments[@"eventName"] parameters:call.arguments[@"parameters"]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error triggering follow-up event: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)setSubscriptionLanguage:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush setSubscriptionLanguage:call.arguments[@"language"]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error setting subscription language: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)setSubscriptionCountry:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    @try {
        [CleverPush setSubscriptionCountry:call.arguments[@"country"]];
        result(nil);
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error setting subscription country: %@", exception.reason];
        result(errorMessage);
    }
}

- (void)handleSubscribed:(NSString *)result {
    @try {
        NSMutableDictionary *resultDict = [NSMutableDictionary new];
        resultDict[@"subscriptionId"] = result;
        [self.channel invokeMethod:@"CleverPush#handleSubscribed" arguments:resultDict];
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error handling subscription: %@", exception.reason];
        [self.channel invokeMethod:@"CleverPush#handleError" arguments:@{@"error": errorMessage}];
    }
}

- (void)handleNotificationReceived:(CPNotificationReceivedResult *)result {
    @try {
        NSMutableDictionary *resultDict = [NSMutableDictionary new];
        resultDict[@"notification"] = [self dictionaryWithPropertiesOfObject:result.notification];
        [self.channel invokeMethod:@"CleverPush#handleNotificationReceived" arguments:resultDict];
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error handling notification received: %@", exception.reason];
        [self.channel invokeMethod:@"CleverPush#handleError" arguments:@{@"error": errorMessage}];
    }
}

- (void)handleNotificationOpened:(CPNotificationOpenedResult *)result {
    @try {
        NSMutableDictionary *resultDict = [NSMutableDictionary new];
        resultDict[@"notification"] = [self dictionaryWithPropertiesOfObject:result.notification];
        [self.channel invokeMethod:@"CleverPush#handleNotificationOpened" arguments:resultDict];
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error handling notification opened: %@", exception.reason];
        [self.channel invokeMethod:@"CleverPush#handleError" arguments:@{@"error": errorMessage}];
    }
}

- (void)handleAppBannerShown:(CPAppBanner *)appBanner {
    @try {
        NSMutableDictionary *resultDict = [NSMutableDictionary new];
        resultDict[@"appBanner"] = [self dictionaryWithPropertiesOfObject:appBanner];
        [self.channel invokeMethod:@"CleverPush#handleAppBannerShown" arguments:resultDict];
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error handling app banner shown: %@", exception.reason];
        [self.channel invokeMethod:@"CleverPush#handleError" arguments:@{@"error": errorMessage}];
    }
}

- (void)handleAppBannerOpened:(CPAppBannerAction *)action {
    @try {
        NSMutableDictionary *resultDict = [NSMutableDictionary new];
        resultDict[@"action"] = [self dictionaryWithPropertiesOfObject:action];
        [self.channel invokeMethod:@"CleverPush#handleAppBannerOpened" arguments:resultDict];
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error handling app banner opened: %@", exception.reason];
        [self.channel invokeMethod:@"CleverPush#handleError" arguments:@{@"error": errorMessage}];
    }
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
                NSString *convertedDateString = [NSString stringWithFormat:@"%@", [obj valueForKey:key]];
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
