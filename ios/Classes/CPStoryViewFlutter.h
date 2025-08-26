#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <CleverPush/CPStoryViewFlutter.h>
#import <CleverPush/CPStoryViewFl>

@interface CPStoryViewFlutterFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype _Nullable)initWithMessenger:(NSObject<FlutterBinaryMessenger>* _Nullable)messenger;
@end

@interface CPStoryViewFlutter : NSObject <FlutterPlatformView>
- (instancetype _Nullable)initWithFrame:(CGRect)frame
                         viewIdentifier:(int64_t)viewId
                              arguments:(id _Nullable)args
                        binaryMessenger:(NSObject<FlutterBinaryMessenger>* _Nullable)messenger;

- (UIView * _Nullable)view;

// Comprehensive method with all parameters - this is what you requested!
+ (CPStoryView* _Nullable)createStoryViewWithFrame:(CGRect)frame backgroundColor:(UIColor * _Nullable)backgroundColor
                                         textColor:(UIColor * _Nullable)textColor fontFamily:(NSString * _Nullable)fontFamily borderColor:(UIColor * _Nullable)borderColor borderColorLoading:(UIColor * _Nullable)borderColorLoading titleVisibility:(BOOL)titleVisibility titleTextSize:(int)titleTextSize storyIconHeight:(int)storyIconHeight storyIconWidth:(int)storyIconWidth storyIconCornerRadius:(int)storyIconCornerRadius storyIconSpacing:(int)storyIconSpacing storyIconBorderVisibility:(BOOL)storyIconBorderVisibility storyIconBorderMargin:(int)storyIconBorderMargin storyIconBorderWidth:(int)storyIconBorderWidth storyIconShadow:(BOOL)storyIconShadow storyRestrictToItems:(int)storyRestrictToItems unreadStoryCountVisibility:(BOOL)unreadStoryCountVisibility unreadStoryCountBackgroundColor:(UIColor * _Nullable)unreadStoryCountBackgroundColor unreadStoryCountTextColor:(UIColor * _Nullable)unreadStoryCountTextColor storyViewCloseButtonPosition:(int)storyViewCloseButtonPosition storyViewTextPosition:(int)storyViewTextPosition storyWidgetShareButtonVisibility:(BOOL)storyWidgetShareButtonVisibility sortToLastIndex:(BOOL)sortToLastIndex allowAutoRotation:(BOOL)allowAutoRotation borderColorDarkMode:(UIColor * _Nullable)borderColorDarkMode borderColorLoadingDarkMode:(UIColor * _Nullable)borderColorLoadingDarkMode backgroundColorDarkMode:(UIColor * _Nullable)backgroundColorDarkMode textColorDarkMode:(UIColor * _Nullable)textColorDarkMode unreadStoryCountBackgroundColorDarkMode:(UIColor* _Nullable)unreadStoryCountBackgroundColorDarkMode unreadStoryCountTextColorDarkMode:(UIColor * _Nullable)unreadStoryCountTextColorDarkMode autoTrackShown:(BOOL)autoTrackShown widgetId:(NSString * _Nullable)widgetId;

+ (void)setDarkModeEnabled:(BOOL)enabled;
+ (BOOL)isDarkModeEnabled;

@end
