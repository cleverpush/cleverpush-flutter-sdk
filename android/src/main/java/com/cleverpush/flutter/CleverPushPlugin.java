package com.cleverpush.flutter;

import android.content.Context;
import android.util.Log;

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

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterNativeView;

public class CleverPushPlugin extends FlutterRegistrarResponder implements MethodCallHandler, NotificationOpenedListener, SubscribedListener {
    private NotificationOpenedResult coldStartNotificationResult;
    private boolean hasSetNotificationOpenedHandler = false;

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
        Context context = flutterRegistrar.activeContext();

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
        CleverPush.getInstance(context).showTopicsDialog(context);
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
        Context context = flutterRegistrar.activeContext();
        try {
            replySuccess(reply, CleverPushSerializer.convertNotificationToMapList(new ArrayList<>(CleverPush.getInstance(context).getNotifications())));
        } catch (JSONException exception) {
            exception.printStackTrace();
        }
    }

    private void getNotificationsWithApi(MethodCall call, final Result reply) {
        final Context context = flutterRegistrar.activeContext();
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
        Context context = flutterRegistrar.activeContext();
        CleverPush.getInstance(context).setSubscriptionTopics(topicIds);
        replySuccess(reply, null);
    }

    private void getSubscriptionTopics(Result reply) {
        Context context = flutterRegistrar.activeContext();
        Set<String> topicIds = CleverPush.getInstance(context).getSubscriptionTopics();
        List<String> list = new ArrayList<>(topicIds);
        replySuccess(reply, list);
    }

    private void getAvailableTopics(final Result reply) {
        Context context = flutterRegistrar.activeContext();
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
