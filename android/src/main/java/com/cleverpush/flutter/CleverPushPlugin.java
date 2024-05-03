package com.cleverpush.flutter;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.cleverpush.ChannelTag;
import com.cleverpush.ChannelTopic;
import com.cleverpush.CleverPush;
import com.cleverpush.CustomAttribute;
import com.cleverpush.Notification;
import com.cleverpush.NotificationOpenedResult;
import com.cleverpush.banner.models.Banner;
import com.cleverpush.banner.models.BannerAction;
import com.cleverpush.listener.AppBannerOpenedListener;
import com.cleverpush.listener.AppBannerShownListener;
import com.cleverpush.listener.ChatUrlOpenedListener;
import com.cleverpush.listener.ChannelAttributesListener;
import com.cleverpush.listener.ChannelTagsListener;
import com.cleverpush.listener.ChannelTopicsListener;
import com.cleverpush.listener.DeviceTokenListener;
import com.cleverpush.listener.InitializeListener;
import com.cleverpush.listener.LogListener;
import com.cleverpush.listener.NotificationOpenedListener;
import com.cleverpush.listener.NotificationReceivedCallbackListener;
import com.cleverpush.listener.NotificationsCallbackListener;
import com.cleverpush.listener.SubscribedCallbackListener;
import com.cleverpush.listener.SubscribedListener;
import com.cleverpush.listener.TopicsDialogListener;
import com.cleverpush.util.ColorUtils;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin; 
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.platform.PlatformViewRegistry;

public class CleverPushPlugin extends FlutterRegistrarResponder implements MethodCallHandler, NotificationOpenedListener, SubscribedListener, FlutterPlugin, ActivityAware {
    private NotificationOpenedResult coldStartNotificationResult;
    private boolean hasSetNotificationOpenedHandler = false;
    private boolean showNotificationsInForeground = true;
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
        initPlatformViews(binding.getPlatformViewRegistry());
    }

    private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
        this.context = applicationContext;
        // Making sure to init Android sdk
        CleverPush.getInstance(this.context);
        channel = new MethodChannel(messenger, "CleverPush");
        channel.setMethodCallHandler(this);
    }

    private void initPlatformViews(PlatformViewRegistry registry) {
        registry.registerViewFactory("cleverpush-chat-view", new CleverPushChatViewFactory());
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
        } else if (call.method.contentEquals("CleverPush#areNotificationsEnabled")) {
            this.areNotificationsEnabled(result);
        } else if (call.method.contentEquals("CleverPush#getSubscriptionId")) {
            this.getSubscriptionId(result);
        } else if (call.method.contentEquals("CleverPush#getDeviceToken")) {
            this.getDeviceToken(result);
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
        } else if (call.method.contentEquals("CleverPush#addSubscriptionTag")) {
            this.addSubscriptionTag(call, result);
        }  else if (call.method.contentEquals("CleverPush#addSubscriptionTags")) {
            this.addSubscriptionTags(call, result);
        } else if (call.method.contentEquals("CleverPush#removeSubscriptionTag")) {
            this.removeSubscriptionTag(call, result);
        }  else if (call.method.contentEquals("CleverPush#removeSubscriptionTags")) {
            this.removeSubscriptionTags(call, result);
        } else if (call.method.contentEquals("CleverPush#getSubscriptionTags")) {
            this.getSubscriptionTags(result);
        } else if (call.method.contentEquals("CleverPush#getAvailableTags")) {
            this.getAvailableTags(result);
        } else if (call.method.contentEquals("CleverPush#getAvailableAttributes")) {
            this.getAvailableAttributes(result);
        } else if (call.method.contentEquals("CleverPush#getSubscriptionAttributes")) {
            this.getSubscriptionAttributes(result);
        } else if (call.method.contentEquals("CleverPush#getSubscriptionAttribute")) {
            this.getSubscriptionAttribute(call, result);
        } else if (call.method.contentEquals("CleverPush#setSubscriptionAttribute")) {
            this.setSubscriptionAttribute(call, result);
        } else if (call.method.contentEquals("CleverPush#setShowNotificationsInForeground")) {
            this.setShowNotificationsInForeground(call, result);
        } else if (call.method.contentEquals("CleverPush#setTrackingConsentRequired")) {
            this.setTrackingConsentRequired(call, result);
        } else if (call.method.contentEquals("CleverPush#setTrackingConsent")) {
            this.setTrackingConsent(call, result);
        } else if (call.method.contentEquals("CleverPush#setBrandingColor")) {
            this.setBrandingColor(call, result);
        } else if (call.method.contentEquals("CleverPush#enableAppBanners")) {
            this.enableAppBanners(result);
        } else if (call.method.contentEquals("CleverPush#enableDevelopmentMode")) {
            this.enableDevelopmentMode(result);
        } else if (call.method.contentEquals("CleverPush#disableAppBanners")) {
            this.disableAppBanners(result);
        } else if (call.method.contentEquals("CleverPush#setLogListener")) {
            this.setLogListener(result);
        } else if (call.method.contentEquals("CleverPush#trackPageView")) {
            this.trackPageView(call, result);
        } else if (call.method.contentEquals("CleverPush#setAuthorizerToken")) {
            this.setAuthorizerToken(call, result);
        } else if (call.method.contentEquals("CleverPush#setSubscriptionCountry")) {
            this.setSubscriptionCountry(call, result);
        } else if (call.method.contentEquals("CleverPush#setSubscriptionLanguage")) {
            this.setSubscriptionLanguage(call, result);
        } else if (call.method.contentEquals("CleverPush#trackEvent")) {
            this.trackEvent(call, result);
        } else if (call.method.contentEquals("CleverPush#triggerFollowUpEvent")) {
            this.triggerFollowUpEvent(call, result);
        } else if (call.method.contentEquals("CleverPush#pushSubscriptionAttributeValue")) {
            this.pushSubscriptionAttributeValue(call, result);
        } else if (call.method.contentEquals("CleverPush#pullSubscriptionAttributeValue")) {
            this.pullSubscriptionAttributeValue(call, result);
        } else {
            replyNotImplemented(result);
        }
    }

    private void initCleverPush(MethodCall call, final Result reply) {
        String channelId = call.argument("channelId");
        boolean autoRegister = false;
        if (call.hasArgument("autoRegister") && call.argument("autoRegister") != null) {
            try {
                autoRegister = (boolean) call.argument("autoRegister");
            } catch (NullPointerException ignored) {
            }
        }

        final CleverPush cleverPush = CleverPush.getInstance(context);

        NotificationReceivedCallbackListener receivedListener = new NotificationReceivedCallbackListener() {
            @Override
            public boolean notificationReceivedCallback(NotificationOpenedResult result) {
                boolean appIsOpen = cleverPush.isAppOpen();
                Log.d("CleverPush", "notificationReceived");

                if (appIsOpen) {
                    try {
                      invokeMethodOnUiThread("CleverPush#handleNotificationReceived", CleverPushSerializer.convertNotificationOpenResultToMap(result));
                    } catch (JSONException e) {
                        e.printStackTrace();
                        Log.e("CleverPush", "Encountered an error attempting to convert CPNotification object to map: " + e.getMessage());
                    }
                }

                if (showNotificationsInForeground) {
                  return true;
                }

                return !appIsOpen;
            }
        };

        cleverPush.init(channelId, receivedListener, this, this, autoRegister, new InitializeListener() {
            @Override
            public void onInitialized() {
                replySuccess(reply, null);
            }
        });

        cleverPush.setChatUrlOpenedListener(new ChatUrlOpenedListener() {
            @Override
            public void opened(String url) {
                HashMap<String, Object> hash = new HashMap<>();
                hash.put("url", url);
                invokeMethodOnUiThread("CleverPush#handleChatUrlOpened", hash);
            }
        });

        cleverPush.setAppBannerShownListener(new AppBannerShownListener() {
            @Override
            public void shown(Banner banner) {
                HashMap<String, Object> hash = new HashMap<>();
                hash.put("appBanner", CleverPushSerializer.convertAppBannerToMap(banner));
                invokeMethodOnUiThread("CleverPush#handleAppBannerShown", hash);
            }
        });

        cleverPush.setAppBannerOpenedListener(new AppBannerOpenedListener() {
            @Override
            public void opened(BannerAction action) {
                HashMap<String, Object> hash = new HashMap<>();
                hash.put("action", CleverPushSerializer.convertAppBannerActionToMap(action));
                invokeMethodOnUiThread("CleverPush#handleAppBannerOpened", hash);
            }
        });
    }

    private void subscribe(MethodCall call, final Result result) {
        CleverPush.getInstance(context).subscribe(new SubscribedCallbackListener() {
            @Override
            public void onSuccess(String subscriptionId) {
                replySuccess(result, subscriptionId);
            }

            @Override
            public void onFailure(Throwable exception) {
                replySuccess(result, "SUBSCRIPTION_FAILED: " + exception.getMessage());
            }
        }, this.activity);
    }

    private void unsubscribe(MethodCall call, Result result) {
        CleverPush.getInstance(context).unsubscribe();
        replySuccess(result, null);
    }

    private void enableAppBanners(Result result) {
        try {
            CleverPush.getInstance(context).enableAppBanners();
            replySuccess(result, null);
        } catch (Exception e) {
            String errorMessage = "Error while enabling app banners: " + e.getMessage();
            replySuccess(result, errorMessage);
        }
    }

    private void enableDevelopmentMode(Result result) {
        try {
            CleverPush.getInstance(context).enableDevelopmentMode();
            replySuccess(result, null);
        } catch (Exception e) {
            String errorMessage = "Error while development mode: " + e.getMessage();
            replySuccess(result, errorMessage);
        }
    }

    private void disableAppBanners(Result result) {
        try {
            CleverPush.getInstance(context).disableAppBanners();
            replySuccess(result, null);
        } catch (Exception e) {
            String errorMessage = "Error while disabling app banners: " + e.getMessage();
            replySuccess(result, errorMessage);
        }
    }

    private void setLogListener(Result result) {
        try {
            CleverPush.getInstance(context).setLogListener(new LogListener() {
                @Override
                public void log(String message) {
                    HashMap<String, Object> hash = new HashMap<>();
                    hash.put("message", message);
                    invokeMethodOnUiThread("CleverPush#handleLog", hash);
                }
            });
            replySuccess(result, null);
        } catch (Exception e) {
            String errorMessage = "Error while setting log listener: " + e.getMessage();
            replySuccess(result, errorMessage);
        }
    }

    private void trackPageView(MethodCall call, Result result) {
        try {
            CleverPush.getInstance(context).trackPageView((String) call.argument("url"));
            replySuccess(result, null);
        } catch (Exception e) {
            String errorMessage = "Error while trackPageView:" + e.getMessage();
            replySuccess(result, errorMessage);
        }
    }

    private void setAuthorizerToken(MethodCall call, Result result) {
        try {
            CleverPush.getInstance(context).setAuthorizerToken((String) call.argument("token"));
            replySuccess(result, null);
        } catch (Exception e) {
            String errorMessage = "Error while setting authorizer token: " + e.getMessage();
            replySuccess(result, errorMessage);
        }
    }

    private void trackEvent(MethodCall call, Result result) {
        try {
            String eventName = (String) call.argument("eventName");
            Double amount = call.argument("amount");
            Map properties = call.argument("properties");
            if (properties != null) {
                CleverPush.getInstance(context).trackEvent(eventName, properties);
            } else if (amount != null) {
                CleverPush.getInstance(context).trackEvent(eventName, amount.floatValue());
            } else {
                CleverPush.getInstance(context).trackEvent(eventName);
            }
            replySuccess(result, null);
        } catch (Exception e) {
            String errorMessage = "Error while trackEvent: " + e.getMessage();
            replySuccess(result, errorMessage);
        }
    }

    private void triggerFollowUpEvent(MethodCall call, Result result) {
        try {
            CleverPush.getInstance(context).triggerFollowUpEvent((String) call.argument("eventName"), (Map) call.argument("parameters"));
            replySuccess(result, null);
        } catch (Exception e) {
            String errorMessage = "Error while triggerFollowUpEvent: " + e.getMessage();
            replySuccess(result, errorMessage);
        }
    }

    private void setSubscriptionLanguage(MethodCall call, Result result) {
        try {
            CleverPush.getInstance(context).setSubscriptionLanguage((String) call.argument("language"));
            replySuccess(result, null);
        } catch (Exception e) {
            String errorMessage = "Error while setSubscriptionLanguage: " + e.getMessage();
            replySuccess(result, errorMessage);
        }
    }

    private void setSubscriptionCountry(MethodCall call, Result result) {
        try {
            CleverPush.getInstance(context).setSubscriptionCountry((String) call.argument("country"));
            replySuccess(result, null);
        } catch (Exception e) {
            String errorMessage = "Error while setSubscriptionCountry: " + e.getMessage();
            replySuccess(result, errorMessage);
        }
    }

    private void isSubscribed(Result reply) {
        try {
            replySuccess(reply, CleverPush.getInstance(context).isSubscribed());
        } catch (Exception e) {
            String errorMessage = "Error while checking isSubscribed: " + e.getMessage();
            replySuccess(reply, errorMessage);
        }
    }

    private void areNotificationsEnabled(Result reply) {
        try {
            replySuccess(reply, CleverPush.getInstance(context).areNotificationsEnabled());
        } catch (Exception e) {
            String errorMessage = "Error while checking areNotificationsEnabled: " + e.getMessage();
            replySuccess(reply, errorMessage);
        }
    }

    private void getSubscriptionId(final Result reply) {
        try {
            CleverPush.getInstance(context).getSubscriptionId(new SubscribedListener() {
                @Override
                public void subscribed(String subscriptionId) {
                    if (subscriptionId == null || subscriptionId.isEmpty()) {
                        String message = "Subscription ID is null or empty.";
                        replySuccess(reply, message);
                    } else {
                        replySuccess(reply, subscriptionId);
                    }
                }
            });
        } catch (Exception e) {
            String errorMessage = "Error while getSubscriptionId: " + e.getMessage();
            replySuccess(reply, errorMessage);
        }
    }

    private void getDeviceToken(final Result reply) {
        CleverPush.getInstance(context).getDeviceToken(new DeviceTokenListener() {
          @Override
          public void complete(String deviceToken) {
              if (deviceToken != null && !deviceToken.equals("")) {
                  replySuccess(reply, deviceToken);
              } else {
                  replySuccess(reply, "Device Token is null or empty");
              }
          }
        });
    }

    private void showTopicsDialog(MethodCall call, final Result reply) {
        try {
            CleverPush.getInstance(context).showTopicsDialog(this.activity, new TopicsDialogListener() {
                @Override
                public void callback(boolean accepted) {
                    replySuccess(reply, null);
                }
            });
        } catch (Exception e) {
            replySuccess(reply, "showTopicsDialog_FAILED: " + e.getMessage());
        }
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
            replySuccess(reply, "Error while getting notification. " + exception.getMessage());
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
                    replySuccess(reply, "Error while getting notification combineWithApi. " + exception.getMessage());
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
                    replySuccess(reply, CleverPushSerializer.convertChannelTopicToMapList(new ArrayList<>(channelTopics)));
                } catch (JSONException exception) {
                    exception.printStackTrace();
                }
            }
        });
    }

    private void addSubscriptionTag(MethodCall call, Result reply) {
        String id = call.argument("id");
        if (id == null) {
            replySuccess(reply, null);
            return;
        }
        CleverPush.getInstance(context).addSubscriptionTag(id);
        replySuccess(reply, null);
    }

    private void removeSubscriptionTag(MethodCall call, Result reply) {
        String id = call.argument("id");
        if (id == null) {
            replySuccess(reply, null);
            return;
        }
        CleverPush.getInstance(context).removeSubscriptionTag(id);
        replySuccess(reply, null);
    }

    private void addSubscriptionTags(MethodCall call, Result reply) {
        List<String> ids = call.argument("ids");
        if (ids == null) {
            replySuccess(reply, null);
            return;
        }
        String[] tagIds = new String[ids.size()];
        tagIds = ids.toArray(tagIds);
        CleverPush.getInstance(context).addSubscriptionTags(tagIds);
        replySuccess(reply, null);
    }

    private void removeSubscriptionTags(MethodCall call, Result reply) {
        List<String> ids = call.argument("ids");
        if (ids == null) {
            replySuccess(reply, null);
            return;
        }
        String[] tagIds = new String[ids.size()];
        tagIds = ids.toArray(tagIds);
        CleverPush.getInstance(context).removeSubscriptionTags(tagIds);
        replySuccess(reply, null);
    }

    private void getSubscriptionTags(Result reply) {
        Set<String> tagIds = CleverPush.getInstance(context).getSubscriptionTags();
        List<String> list = new ArrayList<>(tagIds);
        replySuccess(reply, list);
    }

    private void getAvailableTags(final Result reply) {
        CleverPush.getInstance(context).getAvailableTags(new ChannelTagsListener() {
            @Override
            public void ready(Set<ChannelTag> channelTags) {
                try {
                    replySuccess(reply, CleverPushSerializer.convertChannelTagToMapList(new ArrayList<>(channelTags)));
                } catch (JSONException exception) {
                    exception.printStackTrace();
                }
            }
        });
    }

    private void getAvailableAttributes(final Result reply) {
        CleverPush.getInstance(context).getAvailableAttributes(new ChannelAttributesListener() {
            @Override
            public void ready(Set<CustomAttribute> channelAttributes) {
                try {
                    replySuccess(reply, CleverPushSerializer.convertCustomAttributeToMapList(new ArrayList<>(channelAttributes)));
                } catch (JSONException exception) {
                    exception.printStackTrace();
                }
            }
        });
    }

    private void getSubscriptionAttributes(final Result result) {
        try {
            Map<String, Object> attributeMap = CleverPush.getInstance(context).getSubscriptionAttributes();

            Map<String, Object> convertedMap = new HashMap<>();
            for (Map.Entry<String, Object> entry : attributeMap.entrySet()) {
                String key = entry.getKey();
                Object value = entry.getValue();
                if (value instanceof JSONArray) {
                    JSONArray jsonArray = (JSONArray) value;
                    List<Object> list = new ArrayList<>();
                    for (int i = 0; i < jsonArray.length(); i++) {
                        list.add(jsonArray.get(i));
                    }
                    convertedMap.put(key, list);
                } else {
                    convertedMap.put(key, Collections.singletonList(value));
                }
            }
            replySuccess(result, convertedMap);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e("CleverPush", "Error converting subscriptionAttributes JSONArray to Map: " + e.getMessage());
        }
    }

    private void getSubscriptionAttribute(MethodCall call, final Result result) {
        String id = call.argument("id");
        try {
            Object attributeArray = CleverPush.getInstance(context).getSubscriptionAttribute(id);
            if (attributeArray instanceof JSONArray) {
                JSONArray jsonArray = (JSONArray) attributeArray;
                List<Object> list = new ArrayList<>();
                Object o = new Object();
                for (int i = 0; i < jsonArray.length(); i++) {
                    list.add(jsonArray.get(i));
                }
                replySuccess(result, list);
            } else {
                replySuccess(result, attributeArray);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Log.e("CleverPush", "Encountered an error attempting to convert subscriptionAttribute JSONArray to list: " + e.getMessage());
        }
    }

    private void setSubscriptionAttribute(MethodCall call, final Result result) {
        String id = call.argument("id");
        String value = call.argument("value");
        CleverPush.getInstance(context).setSubscriptionAttribute(id, value);
        replySuccess(result, null);
    }

    private void setShowNotificationsInForeground(MethodCall call, final Result result) {
        Boolean show = call.argument("show");
        this.showNotificationsInForeground = show;
        replySuccess(result, null);
    }

    private void setTrackingConsentRequired(MethodCall call, final Result result) {
        Boolean consentRequired = call.argument("consentRequired");
        CleverPush.getInstance(context).setTrackingConsentRequired(consentRequired);
        replySuccess(result, null);
    }

    private void setTrackingConsent(MethodCall call, final Result result) {
        Boolean hasConsent = call.argument("hasConsent");
        CleverPush.getInstance(context).setTrackingConsent(hasConsent);
        replySuccess(result, null);
    }

    private void setBrandingColor(MethodCall call, final Result result) {
        String color = call.argument("color");
        CleverPush.getInstance(context).setBrandingColor(ColorUtils.parseColor(color));
        replySuccess(result, null);
    }

    private void pushSubscriptionAttributeValue(MethodCall call, final Result result) {
        String id = call.argument("id");
        String value = call.argument("value");
        CleverPush.getInstance(context).pushSubscriptionAttributeValue(id, value);
        replySuccess(result, null);
    }

    private void pullSubscriptionAttributeValue(MethodCall call, final Result result) {
        String id = call.argument("id");
        String value = call.argument("value");
        CleverPush.getInstance(context).pullSubscriptionAttributeValue(id, value);
        replySuccess(result, null);
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
