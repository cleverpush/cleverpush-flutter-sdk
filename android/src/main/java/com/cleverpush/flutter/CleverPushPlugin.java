package com.cleverpush.flutter;

import android.content.Context;
import android.util.Log;

import com.cleverpush.Notification;
import com.cleverpush.NotificationOpenedResult;
import com.cleverpush.CleverPush;
import com.cleverpush.listener.SubscribedListener;
import com.cleverpush.listener.NotificationReceivedListener;
import com.cleverpush.listener.NotificationOpenedListener;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterNativeView;

public class CleverPushPlugin extends FlutterRegistrarResponder implements MethodCallHandler, NotificationReceivedListener, NotificationOpenedListener, SubscribedListener {
  private NotificationOpenedResult coldStartNotificationResult;
  private boolean hasSetNotificationOpenedHandler = false;
  private boolean hasSetInAppMessageClickedHandler = false;

  public static void registerWith(Registrar registrar) {
    final CleverPushPlugin plugin = new CleverPushPlugin();

    plugin.channel = new MethodChannel(registrar.messenger(), "CleverPush");
    plugin.channel.setMethodCallHandler(plugin);
    plugin.flutterRegistrar = registrar;

    plugin.flutterRegistrar.addViewDestroyListener(new PluginRegistry.ViewDestroyListener() {
      @Override
      public boolean onViewDestroy(FlutterNativeView flutterNativeView) {
        Context context = plugin.flutterRegistrar.activeContext();
        CleverPush.getInstance(context).removeNotificationReceivedListener();
        CleverPush.getInstance(context).removeNotificationOpenedListener();
        CleverPush.getInstance(context).removeSubscribedListener();
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
    boolean autoRegister = false;
    if (call.hasArgument("autoRegister") && call.argument("autoRegister") != null) {
      try {
        autoRegister = (boolean) call.argument("autoRegister");
      } catch (NullPointerException ignored) {}
    }
    Context context = flutterRegistrar.activeContext();

    CleverPush.getInstance(context).init(channelId, this, this, this, autoRegister);

    replySuccess(reply, null);
  }

  private void subscribe(MethodCall call, Result result) {
    Context context = flutterRegistrar.activeContext();
    CleverPush.getInstance(context).subscribe();
    replySuccess(result, null);
  }

  private void unsubscribe(MethodCall call, Result result) {
    Context context = flutterRegistrar.activeContext();
    CleverPush.getInstance(context).unsubscribe();
    replySuccess(result, null);
  }

  private void isSubscribed(Result reply) {
    Context context = flutterRegistrar.activeContext();
    replySuccess(reply, CleverPush.getInstance(context).isSubscribed());
  }

  private void showTopicsDialog(MethodCall call, Result reply) {
    Context context = flutterRegistrar.activeContext();
    CleverPush.getInstance(context).showTopicsDialog();
    replySuccess(reply, null);
  }

  private void initNotificationOpenedHandlerParams() {
    this.hasSetNotificationOpenedHandler = true;
    if (this.coldStartNotificationResult != null) {
      this.notificationOpened(this.coldStartNotificationResult);
      this.coldStartNotificationResult = null;
    }
  }

  @Override
  public void subscribed(String subscriptionId) {
    HashMap<String, Object> hash = new HashMap<>();
    hash.put("subscriptionId", subscriptionId);
    invokeMethodOnUiThread("CleverPush#handleSubscribed", hash);
  }

  @Override
  public void notificationReceived(NotificationOpenedResult result) {
    Log.d("CleverPush", "notificationReceived");
    try {
      invokeMethodOnUiThread("CleverPush#handleNotificationReceived", CleverPushSerializer.convertNotificationOpenResultToMap(result));
    } catch (JSONException e) {
      e.printStackTrace();
      Log.e("CleverPush", "Encountered an error attempting to convert CPNotification object to map: " + e.getMessage());
    }
  }

  @Override
  public void notificationOpened(NotificationOpenedResult result) {
    Log.d("CleverPush", "notificationOpened");
    if (!this.hasSetNotificationOpenedHandler) {
      this.coldStartNotificationResult = result;
      return;
    }

    try {
      invokeMethodOnUiThread("CleverPush#handleNotificationOpened", CleverPushSerializer.convertNotificationOpenResultToMap(result));
    } catch (JSONException e) {
      e.getStackTrace();
      Log.e("CleverPush", "Encountered an error attempting to convert CPNotificationOpenResult object to map: " + e.getMessage());
    }
  }
}
