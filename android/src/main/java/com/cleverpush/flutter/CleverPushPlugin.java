package com.cleverpush.flutter;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.cleverpush.ChannelTopic;
import com.cleverpush.CleverPush;
import com.cleverpush.Notification;
import com.cleverpush.NotificationOpenedResult;
import com.cleverpush.listener.ChannelTopicsListener;
import com.cleverpush.listener.NotificationOpenedListener;
import com.cleverpush.listener.NotificationReceivedCallbackListener;
import com.cleverpush.listener.NotificationsCallbackListener;
import com.cleverpush.listener.SubscribedListener;

import org.json.JSONException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterNativeView;


public class CleverPushPlugin extends FlutterRegistrarResponder implements MethodCallHandler, NotificationOpenedListener, SubscribedListener, FlutterPlugin, ActivityAware {
    private NotificationOpenedResult coldStartNotificationResult;
    private boolean hasSetNotificationOpenedHandler = false;
    private Context context;
    private Activity activity;

    @SuppressWarnings("deprecation")
    public static void registerWith(Registrar registrar) {
        final CleverPushPlugin plugin = new CleverPushPlugin();
        plugin.onAttachedToEngine(registrar.context(), registrar.messenger());
    }

    @Override
    public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding) {
        onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
        this.context = applicationContext;
        channel = new MethodChannel(messenger, "CleverPush");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        CleverPush.getInstance(binding.getApplicationContext()).removeNotificationReceivedListener();
        CleverPush.getInstance(binding.getApplicationContext()).removeNotificationOpenedListener();
        CleverPush.getInstance(binding.getApplicationContext()).removeSubscribedListener();
        context = null;

    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.contentEquals("CleverPush#init")) {
            this.initCleverPush(call, result);
        } else if (call.method.contentEquals("CleverPush#subscribe")) {
            this.subscribe(call, result);
        } else if (call.method.contentEquals("CleverPush#unsubscribe")) {
            this.unsubscribe(call, result);
        } else if (call.method.contentEquals("CleverPush#isSubscribed")) {
            this.isSubscribed(result);
        } else if (call.method.contentEquals("CleverPush#showTopicsDialog")) {
            this.showTopicsDialog(call, result);
        } else if (call.method.contentEquals("CleverPush#initNotificationOpenedHandlerParams")) {
            this.initNotificationOpenedHandlerParams();
        } else if (call.method.contentEquals("CleverPush#getNotifications")) {
            this.getNotifications(result);
        } else if (call.method.contentEquals("CleverPush#getNotificationsWithApi")) {
            this.getNotificationsWithApi(call, result);
        } else if (call.method.contentEquals("CleverPush#setSubscriptionTopics")) {
            this.setSubscriptionTopics(call, result);
        } else if (call.method.contentEquals("CleverPush#getSubscriptionTopics")) {
            this.getSubscriptionTopics(result);
        } else if (call.method.contentEquals("CleverPush#getAvailableTopics")) {
            this.getAvailableTopics(result);
        } else {
            replyNotImplemented(result);
        }
    }

    private void initCleverPush(MethodCall call, Result reply) {
        String channelId = call.argument("channelId");
        boolean autoRegister = false;
        if (call.hasArgument("autoRegister") && call.argument("autoRegister") != null) {
            try {
                autoRegister = (boolean) call.argument("autoRegister");
            } catch (NullPointerException ignored) {
            }
        }

        NotificationReceivedCallbackListener receivedListener = new NotificationReceivedCallbackListener() {
            @Override
            public boolean notificationReceivedCallback(NotificationOpenedResult result) {
                Log.d("CleverPush", "notificationReceived");
                try {
                    invokeMethodOnUiThread("CleverPush#handleNotificationReceived", CleverPushSerializer.convertNotificationOpenResultToMap(result));
                } catch (JSONException e) {
                    e.printStackTrace();
                    Log.e("CleverPush", "Encountered an error attempting to convert CPNotification object to map: " + e.getMessage());
                }

                return true;
            }
        };

        CleverPush.getInstance(context).init(channelId, receivedListener, this, this, autoRegister);

        replySuccess(reply, null);
    }

    private void subscribe(MethodCall call, Result result) {
        CleverPush.getInstance(context).subscribe();
        replySuccess(result, null);
    }

    private void unsubscribe(MethodCall call, Result result) {
        CleverPush.getInstance(context).unsubscribe();
        replySuccess(result, null);
    }

    private void isSubscribed(Result reply) {
        replySuccess(reply, CleverPush.getInstance(context).isSubscribed());
    }

    private void showTopicsDialog(MethodCall call, Result reply) {
        CleverPush.getInstance(context).showTopicsDialog(activity);
        replySuccess(reply, null);
    }

    private void initNotificationOpenedHandlerParams() {
        this.hasSetNotificationOpenedHandler = true;
        if (this.coldStartNotificationResult != null) {
            this.notificationOpened(this.coldStartNotificationResult);
            this.coldStartNotificationResult = null;
        }
    }

    private void getNotifications(Result reply) {
        try {
            replySuccess(reply, CleverPushSerializer.convertNotificationToMapList(new ArrayList<>(CleverPush.getInstance(context).getNotifications())));
        } catch (JSONException exception) {
            exception.printStackTrace();
        }
    }

    private void getNotificationsWithApi(MethodCall call, final Result reply) {
        boolean combineWithApi = call.argument("combineWithApi");
        CleverPush.getInstance(context).getNotifications(combineWithApi, new NotificationsCallbackListener() {
            @Override
            public void ready(Set<Notification> notifications) {
                try {
                    replySuccess(reply, CleverPushSerializer.convertNotificationToMapList(new ArrayList<>(notifications)));
                } catch (JSONException exception) {
                    exception.printStackTrace();
                }
            }
        });

    }

    private void setSubscriptionTopics(MethodCall call, Result reply) {
        List<String> topics = call.argument("topics");
        if (topics == null) {
            replySuccess(reply, null);
            return;
        }
        String[] topicIds = new String[topics.size()];
        topicIds = topics.toArray(topicIds);
        CleverPush.getInstance(context).setSubscriptionTopics(topicIds);
        replySuccess(reply, null);
    }

    private void getSubscriptionTopics(Result reply) {
        Set<String> topicIds = CleverPush.getInstance(context).getSubscriptionTopics();
        List<String> list = new ArrayList<>(topicIds);
        replySuccess(reply, list);
    }

    private void getAvailableTopics(final Result reply) {
        CleverPush.getInstance(context).getAvailableTopics(new ChannelTopicsListener() {
            @Override
            public void ready(Set<ChannelTopic> channelTopics) {
                try {
                    replySuccess(reply, CleverPushSerializer.convertChannelTopicToMapList(new ArrayList<ChannelTopic>(channelTopics)));
                } catch (JSONException exception) {
                    exception.printStackTrace();
                }
            }
        });
    }

    @Override
    public void subscribed(String subscriptionId) {
        HashMap<String, Object> hash = new HashMap<>();
        hash.put("subscriptionId", subscriptionId);
        invokeMethodOnUiThread("CleverPush#handleSubscribed", hash);
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
