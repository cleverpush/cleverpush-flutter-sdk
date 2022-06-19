#import <Flutter/Flutter.h>
#import <CleverPush/CleverPush.h>

@interface CleverPushPlugin : NSObject<FlutterPlugin>

@property (strong, nonatomic) FlutterMethodChannel *channel;

+ (instancetype)sharedInstance;

@end
