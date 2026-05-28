#import "include/cleverpush_flutter/CPChatViewFlutter.h"
#import "include/cleverpush_flutter/CleverPushPlugin.h"
#if __has_include(<CleverPush/CPChatView.h>)
#import <CleverPush/CPChatView.h>
#else
#import <CPChatView.h>
#endif
#import <UIKit/UIKit.h>

@implementation CPChatViewFlutterFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  return [[CPChatViewFlutter alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

@end

@implementation CPChatViewFlutter {
   CPChatView *_chatView;
}
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
    _chatView = [[CPChatView alloc] initWithFrame:frame urlOpenedCallback:^(NSURL *url) {
      NSMutableDictionary *resultDict = [NSMutableDictionary new];
      resultDict[@"url"] = url.absoluteString;
      dispatch_async(dispatch_get_main_queue(), ^{
          [[[CleverPushPlugin sharedInstance] channel] invokeMethod:@"CleverPush#handleChatUrlOpened" arguments:resultDict];
      });
    } subscribeCallback:^() {
        
    }];
  }
  return self;
}

- (CPChatView*)view {
  return _chatView;
}

@end
