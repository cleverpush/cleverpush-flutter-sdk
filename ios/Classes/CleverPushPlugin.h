#import <Flutter/Flutter.h>
#import <CleverPush/CleverPush.h>

#ifdef FlutterSceneLifeCycleDelegate
@interface CleverPushPlugin : NSObject<FlutterPlugin, FlutterSceneLifeCycleDelegate>
#else
@interface CleverPushPlugin : NSObject<FlutterPlugin>
#endif

@property (strong, nonatomic) FlutterMethodChannel *channel;
@property (weak, nonatomic) NSObject<FlutterPluginRegistrar> *registrar;

+ (instancetype)sharedInstance;

@end
