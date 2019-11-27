package com.cleverpush.flutter;

import android.content.Context;

import com.cleverpush.OSEmailSubscriptionObserver;
import com.cleverpush.OSEmailSubscriptionStateChanges;
import com.cleverpush.OSInAppMessageAction;
import com.cleverpush.OSNotification;
import com.cleverpush.OSNotificationOpenResult;
import com.cleverpush.OSPermissionObserver;
import com.cleverpush.OSPermissionStateChanges;
import com.cleverpush.OSPermissionSubscriptionState;
import com.cleverpush.OSSubscriptionObserver;
import com.cleverpush.OSSubscriptionStateChanges;
import com.cleverpush.CleverPush;
import com.cleverpush.CleverPush.EmailUpdateError;
import com.cleverpush.CleverPush.EmailUpdateHandler;
import com.cleverpush.CleverPush.InAppMessageClickHandler;
import com.cleverpush.CleverPush.NotificationOpenedHandler;
import com.cleverpush.CleverPush.NotificationReceivedHandler;
import com.cleverpush.CleverPush.OSInFocusDisplayOption;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Collection;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterNativeView;

public class CleverPushPlugin extends FlutterRegistrarResponder implements MethodCallHandler, NotificationReceivedHandler, NotificationOpenedHandler {
  private CPNotificationOpenResult coldStartNotificationResult;
  private boolean hasSetNotificationOpenedHandler = false;
  private boolean hasSetInAppMessageClickedHandler = false;

  public static void registerWith(Registrar registrar) {
    CleverPushPlugin plugin = new CleverPushPlugin();

    plugin.channel = new MethodChannel(registrar.messenger(), "CleverPush");
    plugin.channel.setMethodCallHandler(plugin);
    plugin.flutterRegistrar = registrar;

    plugin.flutterRegistrar.addViewDestroyListener(new PluginRegistry.ViewDestroyListener() {
      @Override
      public boolean onViewDestroy(FlutterNativeView flutterNativeView) {
        CleverPush.removeNotificationReceivedHandler();
        CleverPush.removeNotificationOpenedHandler();
        CleverPush.removeInAppMessageClickHandler();
        return false;
      }
    });
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.contentEquals("CleverPush#init"))
      this.initCleverPush(call, result);
    else if (call.method.contentEquals("CleverPush#subscribe"))
      this.subscribe(call, result);
    else if (call.method.contentEquals("CleverPush#unsubscribe"))
      this.unsubscribe(call, result);
    else if (call.method.contentEquals("CleverPush#isSubscribed"))
      this.isSubscribed(result);
    else if (call.method.contentEquals("CleverPush#showTopicsDialog"))
      this.showTopicsDialog(call, result);
    else if (call.method.contentEquals("CleverPush#initNotificationOpenedHandlerParams"))
      this.initNotificationOpenedHandlerParams();
    else
      replyNotImplemented(result);
  }

  private void initCleverPush(MethodCall call, Result reply) {
    String channelId = call.argument("channelId");
    Context context = flutterRegistrar.activeContext();

    CleverPush.Builder builder = CleverPush.getCurrentOrNewInitBuilder();

    CleverPush.init(context, null, channelId, this, this);

    replySuccess(reply, null);
  }

  private void subscribe(MethodCall call, Result result) {
    CleverPush.subscribe();
    replySuccess(result, null);
  }

  private void unsubscribe(MethodCall call, Result result) {
    CleverPush.unsubscribe();
    replySuccess(result, null);
  }

  private void isSubscribed(Result reply) {
    replySuccess(reply, CleverPush.isSubscribed());
  }

  private void initNotificationOpenedHandlerParams() {
    this.hasSetNotificationOpenedHandler = true;
    if (this.coldStartNotificationResult != null) {
      this.notificationOpened(this.coldStartNotificationResult);
      this.coldStartNotificationResult = null;
    }
  }

  @Override
  public void handleSubscribed(OSSubscriptionStateChanges stateChanges) {
    invokeMethodOnUiThread("CleverPush#handleSubscribed", CleverPushSerializer.convertSubscriptionStateChangesToMap(stateChanges));
  }

  @Override
  public void notificationReceived(OSNotification notification) {
    try {
      invokeMethodOnUiThread("CleverPush#handleReceivedNotification", CleverPushSerializer.convertNotificationToMap(notification));
    } catch (JSONException e) {
      e.printStackTrace();
      CleverPush.cleverpushLog(CleverPush.LOG_LEVEL.ERROR,
         "Encountered an error attempting to convert CPNotification object to map: " + e.getMessage());
    }
  }

  @Override
  public void notificationOpened(OSNotificationOpenResult result) {
    if (!this.hasSetNotificationOpenedHandler) {
      this.coldStartNotificationResult = result;
      return;
    }

    try {
      invokeMethodOnUiThread("CleverPush#handleOpenedNotification", CleverPushSerializer.convertNotificationOpenResultToMap(result));
    } catch (JSONException e) {
      e.getStackTrace();
      CleverPush.cleverpushLog(CleverPush.LOG_LEVEL.ERROR,
              "Encountered an error attempting to convert CPNotificationOpenResult object to map: " + e.getMessage());
    }
  }
}
