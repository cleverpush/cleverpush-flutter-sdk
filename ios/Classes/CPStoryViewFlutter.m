#import "CPStoryViewFlutter.h"
#import "CleverPushPlugin.h"
#import <CleverPush/CPStoryView.h>
#import <UIKit/UIKit.h>

@implementation CPStoryViewFlutterFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    return [[CPStoryViewFlutter alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    return [[CPStoryViewFlutter alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:messenger];
}

@end

@implementation CPStoryViewFlutter {
    CPStoryView *_storyView;
    id<NSObject> _appearanceObserver;
}

#pragma mark - Helper Methods
- (UIColor *)colorFromFlutterColor:(NSNumber *)colorValue {
    if (!colorValue || ![colorValue isKindOfClass:[NSNumber class]]) {
        return nil;
    }

    NSInteger color = [colorValue integerValue];
    return [UIColor colorWithRed:((color >> 16) & 0xFF) / 255.0
                           green:((color >> 8) & 0xFF) / 255.0
                            blue:(color & 0xFF) / 255.0
                           alpha:((color >> 24) & 0xFF) / 255.0];
}

- (BOOL)boolFromParams:(NSDictionary *)params key:(NSString *)key defaultValue:(BOOL)defaultValue {
    if (params[key] && [params[key] isKindOfClass:[NSNumber class]]) {
        return [params[key] boolValue];
    }
    return defaultValue;
}

- (NSInteger)integerFromParams:(NSDictionary *)params key:(NSString *)key defaultValue:(NSInteger)defaultValue {
    if (params[key] && [params[key] isKindOfClass:[NSNumber class]]) {
        return [params[key] integerValue];
    }
    return defaultValue;
}

+ (CPStoryView*)createStoryViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
                               textColor:(UIColor *)textColor fontFamily:(NSString *)fontFamily borderColor:(UIColor *)borderColor borderColorLoading:(UIColor *)borderColorLoading titleVisibility:(BOOL)titleVisibility titleTextSize:(int)titleTextSize storyIconHeight:(int)storyIconHeight storyIconWidth:(int)storyIconWidth storyIconCornerRadius:(int)storyIconCornerRadius storyIconSpacing:(int)storyIconSpacing storyIconBorderVisibility:(BOOL)storyIconBorderVisibility storyIconBorderMargin:(int)storyIconBorderMargin storyIconBorderWidth:(int)storyIconBorderWidth storyIconShadow:(BOOL)storyIconShadow storyRestrictToItems:(int)storyRestrictToItems unreadStoryCountVisibility:(BOOL)unreadStoryCountVisibility
         unreadStoryCountBackgroundColor:(UIColor *)unreadStoryCountBackgroundColor unreadStoryCountTextColor:(UIColor *)unreadStoryCountTextColor storyViewCloseButtonPosition:(int)storyViewCloseButtonPosition storyViewTextPosition:(int)storyViewTextPosition storyWidgetShareButtonVisibility:(BOOL)storyWidgetShareButtonVisibility sortToLastIndex:(BOOL)sortToLastIndex allowAutoRotation:(BOOL)allowAutoRotation borderColorDarkMode:(UIColor *)borderColorDarkMode borderColorLoadingDarkMode:(UIColor *)borderColorLoadingDarkMode backgroundColorDarkMode:(UIColor *)backgroundColorDarkMode textColorDarkMode:(UIColor *)textColorDarkMode unreadStoryCountBackgroundColorDarkMode:(UIColor *)unreadStoryCountBackgroundColorDarkMode unreadStoryCountTextColorDarkMode:(UIColor *)unreadStoryCountTextColorDarkMode autoTrackShown:(BOOL)autoTrackShown widgetId:(NSString *)widgetId {

    CPStoryView *storyView = [[CPStoryView alloc] initWithFrame:frame];

    [storyView configureWithFrame:frame backgroundColor:backgroundColor textColor:textColor fontFamily:fontFamily borderColor:borderColor borderColorLoading:borderColorLoading titleVisibility:titleVisibility titleTextSize:titleTextSize storyIconHeight:storyIconHeight storyIconWidth:storyIconWidth storyIconCornerRadius:storyIconCornerRadius storyIconSpacing:storyIconSpacing
        storyIconBorderVisibility:storyIconBorderVisibility storyIconBorderMargin:storyIconBorderMargin storyIconBorderWidth:storyIconBorderWidth storyIconShadow:storyIconShadow storyRestrictToItems:storyRestrictToItems unreadStoryCountVisibility:unreadStoryCountVisibility unreadStoryCountBackgroundColor:unreadStoryCountBackgroundColor unreadStoryCountTextColor:unreadStoryCountTextColor storyViewCloseButtonPosition:storyViewCloseButtonPosition storyViewTextPosition:storyViewTextPosition storyWidgetShareButtonVisibility:storyWidgetShareButtonVisibility sortToLastIndex:sortToLastIndex allowAutoRotation:allowAutoRotation borderColorDarkMode:borderColorDarkMode borderColorLoadingDarkMode:borderColorLoadingDarkMode backgroundColorDarkMode:backgroundColorDarkMode textColorDarkMode:textColorDarkMode unreadStoryCountBackgroundColorDarkMode:unreadStoryCountBackgroundColorDarkMode unreadStoryCountTextColorDarkMode:unreadStoryCountTextColorDarkMode autoTrackShown:autoTrackShown
                         widgetId:widgetId];

    return storyView;
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {

    if (self = [super init]) {
        [self setupDarkModeDetection];

        if (args && [args isKindOfClass:[NSDictionary class]]) {
            NSDictionary *params = (NSDictionary *)args;

            double finalWidth = 300.0;
            double finalHeight = 300.0;
            double finalX = 0.0;
            double finalY = 0.0;
            CGRect finalFrame = CGRectMake(finalX, finalY, finalWidth, finalHeight);
            UIColor *backgroundColor = [UIColor clearColor];
            UIColor *textColor = [UIColor blackColor];
            NSString *fontFamily = @"System";
            UIColor *borderColor = [UIColor clearColor];
            UIColor *borderColorLoading = [UIColor clearColor];
            BOOL titleVisibility = YES;
            NSInteger titleTextSize = 10;
            NSInteger storyIconHeight = 150;
            NSInteger storyIconWidth = 150;
            NSInteger storyIconCornerRadius = 10;
            NSInteger storyIconSpacing = 5;
            BOOL storyIconBorderVisibility = YES;
            NSInteger storyIconBorderMargin = 0;
            NSInteger storyIconBorderWidth = 2;
            BOOL storyIconShadow = YES;
            NSInteger storyRestrictToItems = 3;
            BOOL unreadStoryCountVisibility = YES;
            UIColor *unreadStoryCountBackgroundColor = [UIColor redColor];
            UIColor *unreadStoryCountTextColor = [UIColor whiteColor];
            NSInteger storyViewCloseButtonPosition = 1;
            NSInteger storyViewTextPosition = 1;
            BOOL storyWidgetShareButtonVisibility = NO;
            BOOL sortToLastIndex = NO;
            BOOL allowAutoRotation = YES;
            UIColor *borderColorDarkMode = [UIColor redColor];
            UIColor *borderColorLoadingDarkMode = [UIColor redColor];
            UIColor *backgroundColorDarkMode = [UIColor clearColor];
            UIColor *textColorDarkMode = [UIColor cyanColor];
            UIColor *unreadStoryCountBackgroundColorDarkMode = [UIColor magentaColor];
            UIColor *unreadStoryCountTextColorDarkMode = [UIColor whiteColor];
            BOOL autoTrackShown = NO;

            if (params[@"storyViewWidth"] && [params[@"storyViewWidth"] isKindOfClass:[NSNumber class]]) {
                finalWidth = [params[@"storyViewWidth"] doubleValue];
            }

            if (params[@"storyViewHeight"] && [params[@"storyViewHeight"] isKindOfClass:[NSNumber class]]) {
                finalHeight = [params[@"storyViewHeight"] doubleValue];
            }

            if (params[@"storyViewX"] && [params[@"storyViewX"] isKindOfClass:[NSNumber class]]) {
                finalX = [params[@"storyViewX"] doubleValue];
            }

            if (params[@"storyViewY"] && [params[@"storyViewY"] isKindOfClass:[NSNumber class]]) {
                finalY = [params[@"storyViewY"] doubleValue];
            }

            if (params[@"backgroundColor"]) {
                backgroundColor = [self colorFromFlutterColor:params[@"backgroundColor"]] ?: backgroundColor;
            }

            if (params[@"textColor"]) {
                textColor = [self colorFromFlutterColor:params[@"textColor"]] ?: textColor;
            }

            if (params[@"borderColor"]) {
                borderColor = [self colorFromFlutterColor:params[@"borderColor"]] ?: borderColor;
            }

            if (params[@"borderColorLoading"]) {
                borderColorLoading = [self colorFromFlutterColor:params[@"borderColorLoading"]] ?: borderColorLoading;
            }

            if (params[@"fontFamily"] && [params[@"fontFamily"] isKindOfClass:[NSString class]]) {
                fontFamily = params[@"fontFamily"];
            }

            titleVisibility = [self boolFromParams:params key:@"titleVisibility" defaultValue:titleVisibility];

            titleTextSize = [self integerFromParams:params key:@"titleTextSize" defaultValue:titleTextSize];

            storyIconHeight = [self integerFromParams:params key:@"storyIconHeight" defaultValue:storyIconHeight];

            if (params[@"storyIconWidth"] && [params[@"storyIconWidth"] isKindOfClass:[NSNumber class]]) {
                storyIconWidth = [params[@"storyIconWidth"] integerValue];
            }

            if (params[@"storyIconCornerRadius"] && [params[@"storyIconCornerRadius"] isKindOfClass:[NSNumber class]]) {
                storyIconCornerRadius = [params[@"storyIconCornerRadius"] integerValue];
            }

            if (params[@"storyIconSpacing"] && [params[@"storyIconSpacing"] isKindOfClass:[NSNumber class]]) {
                storyIconSpacing = [params[@"storyIconSpacing"] integerValue];
            }

            storyIconBorderVisibility = [self boolFromParams:params key:@"storyIconBorderVisibility" defaultValue:storyIconBorderVisibility];

            if (params[@"storyIconBorderMargin"] && [params[@"storyIconBorderMargin"] isKindOfClass:[NSNumber class]]) {
                storyIconBorderMargin = [params[@"storyIconBorderMargin"] integerValue];
            }

            if (params[@"storyIconBorderWidth"] && [params[@"storyIconBorderWidth"] isKindOfClass:[NSNumber class]]) {
                storyIconBorderWidth = [params[@"storyIconBorderWidth"] integerValue];
            }

            if (params[@"storyIconShadow"] && [params[@"storyIconShadow"] isKindOfClass:[NSNumber class]]) {
                storyIconShadow = [params[@"storyIconShadow"] boolValue];
            }

            if (params[@"storyRestrictToItems"] && [params[@"storyRestrictToItems"] isKindOfClass:[NSNumber class]]) {
                storyRestrictToItems = [params[@"storyRestrictToItems"] integerValue];
            }

            if (params[@"unreadStoryCountVisibility"] && [params[@"unreadStoryCountVisibility"] isKindOfClass:[NSNumber class]]) {
                unreadStoryCountVisibility = [params[@"unreadStoryCountVisibility"] boolValue];
            }

            if (params[@"unreadStoryCountBackgroundColor"]) {
                unreadStoryCountBackgroundColor = [self colorFromFlutterColor:params[@"unreadStoryCountBackgroundColor"]] ?: unreadStoryCountBackgroundColor;
            }

            if (params[@"unreadStoryCountTextColor"]) {
                unreadStoryCountTextColor = [self colorFromFlutterColor:params[@"unreadStoryCountTextColor"]] ?: unreadStoryCountTextColor;
            }

            if (params[@"storyViewCloseButtonPosition"] && [params[@"storyViewCloseButtonPosition"] isKindOfClass:[NSNumber class]]) {
                storyViewCloseButtonPosition = [params[@"storyViewCloseButtonPosition"] integerValue];
            }

            if (params[@"storyViewTextPosition"] && [params[@"storyViewTextPosition"] isKindOfClass:[NSNumber class]]) {
                storyViewTextPosition = [params[@"storyViewTextPosition"] integerValue];
            }

            if (params[@"storyWidgetShareButtonVisibility"] && [params[@"storyWidgetShareButtonVisibility"] isKindOfClass:[NSNumber class]]) {
                storyWidgetShareButtonVisibility = [params[@"storyWidgetShareButtonVisibility"] boolValue];
            }

            if (params[@"sortToLastIndex"] && [params[@"sortToLastIndex"] isKindOfClass:[NSNumber class]]) {
                sortToLastIndex = [params[@"sortToLastIndex"] boolValue];
            }

            if (params[@"allowAutoRotation"] && [params[@"allowAutoRotation"] isKindOfClass:[NSNumber class]]) {
                allowAutoRotation = [params[@"allowAutoRotation"] boolValue];
            }

            if (params[@"borderColorDarkMode"]) {
                borderColorDarkMode = [self colorFromFlutterColor:params[@"borderColorDarkMode"]] ?: borderColorDarkMode;
            }

            if (params[@"borderColorLoadingDarkMode"]) {
                borderColorLoadingDarkMode = [self colorFromFlutterColor:params[@"borderColorLoadingDarkMode"]] ?: borderColorLoadingDarkMode;
            }

            if (params[@"backgroundColorDarkMode"]) {
                backgroundColorDarkMode = [self colorFromFlutterColor:params[@"backgroundColorDarkMode"]] ?: backgroundColorDarkMode;
            }

            if (params[@"textColorDarkMode"]) {
                textColorDarkMode = [self colorFromFlutterColor:params[@"textColorDarkMode"]] ?: textColorDarkMode;
            }

            if (params[@"unreadStoryCountBackgroundColorDarkMode"]) {
                unreadStoryCountBackgroundColorDarkMode = [self colorFromFlutterColor:params[@"unreadStoryCountBackgroundColorDarkMode"]] ?: unreadStoryCountBackgroundColorDarkMode;
            }

            if (params[@"unreadStoryCountTextColorDarkMode"]) {
                unreadStoryCountTextColorDarkMode = [self colorFromFlutterColor:params[@"unreadStoryCountTextColorDarkMode"]] ?: unreadStoryCountTextColorDarkMode;
            }

            if (params[@"autoTrackShown"] && [params[@"autoTrackShown"] isKindOfClass:[NSNumber class]]) {
                autoTrackShown = [params[@"autoTrackShown"] boolValue];
            }

            _storyView = [CPStoryViewFlutter createStoryViewWithFrame:finalFrame
                                                      backgroundColor:backgroundColor textColor:textColor fontFamily:fontFamily borderColor:borderColor borderColorLoading:borderColorLoading titleVisibility:titleVisibility titleTextSize:titleTextSize storyIconHeight:storyIconHeight storyIconWidth:storyIconWidth storyIconCornerRadius:storyIconCornerRadius storyIconSpacing:storyIconSpacing storyIconBorderVisibility:storyIconBorderVisibility storyIconBorderMargin:storyIconBorderMargin storyIconBorderWidth:storyIconBorderWidth storyIconShadow:storyIconShadow storyRestrictToItems:storyRestrictToItems unreadStoryCountVisibility:unreadStoryCountVisibility unreadStoryCountBackgroundColor:unreadStoryCountBackgroundColor unreadStoryCountTextColor:unreadStoryCountTextColor storyViewCloseButtonPosition:storyViewCloseButtonPosition storyViewTextPosition:storyViewTextPosition storyWidgetShareButtonVisibility:storyWidgetShareButtonVisibility sortToLastIndex:sortToLastIndex allowAutoRotation:allowAutoRotation borderColorDarkMode:borderColorDarkMode borderColorLoadingDarkMode:borderColorLoadingDarkMode backgroundColorDarkMode:backgroundColorDarkMode textColorDarkMode:textColorDarkMode unreadStoryCountBackgroundColorDarkMode:unreadStoryCountBackgroundColorDarkMode unreadStoryCountTextColorDarkMode:unreadStoryCountTextColorDarkMode autoTrackShown:autoTrackShown widgetId:params[@"widgetId"]];

            _storyView.openedCallback = ^(NSURL *url, void (^finishedCallback)(void)) {
                NSMutableDictionary *resultDict = [NSMutableDictionary new];
                resultDict[@"url"] = url.absoluteString;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[CleverPushPlugin sharedInstance] channel] invokeMethod:@"CleverPush#handleStoryOpened" arguments:resultDict];
                });

                if (finishedCallback) {
                    finishedCallback();
                }
            };
        }
    }
    return self;
}

- (UIView*)view {
    return _storyView;
}

#pragma mark - Dark Mode Detection

- (void)setupDarkModeDetection {
    [self updateDarkModeState];
    if (@available(iOS 13.0, *)) {
        _appearanceObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [self updateDarkModeState];
        }];
    }
}

- (void)updateDarkModeState {
    BOOL isDarkMode = NO;
    if (@available(iOS 13.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        if (window) {
            isDarkMode = (window.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
        }
    }

    [CPStoryView setDarkModeEnabled:isDarkMode];
}

- (void)dealloc {
    if (_appearanceObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:_appearanceObserver];
        _appearanceObserver = nil;
    }
}

#pragma mark - Dark Mode Control Methods
+ (void)setDarkModeEnabled:(BOOL)enabled {
    [CPStoryView setDarkModeEnabled:enabled];
}

+ (BOOL)isDarkModeEnabled {
    return [CPStoryView getDarkModeEnabled];
}

@end
