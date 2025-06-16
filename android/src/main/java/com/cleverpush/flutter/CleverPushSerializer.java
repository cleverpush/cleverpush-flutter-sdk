package com.cleverpush.flutter;

import android.util.Log;
import com.cleverpush.*;
import com.cleverpush.banner.models.Banner;
import com.cleverpush.banner.models.BannerAction;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.TimeZone;

class CleverPushSerializer {
    private static HashMap<String, Object> convertNotificationToMap(Notification payload) throws JSONException {
        HashMap<String, Object> hash = new HashMap<>();

        hash.put("_id", payload.getId());
        hash.put("title", payload.getTitle());
        hash.put("text", payload.getText());
        hash.put("url", payload.getUrl());
        hash.put("iconUrl", payload.getIconUrl());
        hash.put("mediaUrl", payload.getMediaUrl());
        String createdAtRaw = payload.getCreatedAt();
        try {
            if (createdAtRaw != null && !createdAtRaw.isEmpty()) {
                Date parsedDate = tryParseDate(createdAtRaw);
                if (parsedDate != null) {
                    SimpleDateFormat iso8601Format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US);
                    iso8601Format.setTimeZone(TimeZone.getTimeZone("UTC"));
                    hash.put("createdAt", iso8601Format.format(parsedDate));
                } else {
                    hash.put("createdAt", createdAtRaw);
                }
            } else {
                hash.put("createdAt", null);
            }
        } catch (Exception e) {
            hash.put("createdAt", createdAtRaw);
            Log.e("CleverPush", "Error while converting date to ISO format. " + e.getMessage(), e);
        }
        hash.put("chatNotification",payload.isChatNotification());
        hash.put("appBanner", payload.getAppBanner());

        ArrayList<HashMap> buttons = new ArrayList<>();

        if (payload.getActions() != null) {
            for (int i = 0; i < payload.getActions().length; i++) {
                NotificationAction button = payload.getActions()[i];

                HashMap<String, Object> buttonHash = new HashMap<>();
                buttonHash.put("title", button.getTitle());
                buttonHash.put("icon", button.getIcon());
                buttonHash.put("url", button.getUrl());
                buttons.add(buttonHash);
            }
        }

        if (buttons.size() > 0) {
            hash.put("actions", buttons);
        }

        Log.d("CleverPush", "Created json payload: " + hash.toString());

        if (payload.getCustomData() != null)
            hash.put("customData", payload.getCustomData());

        return hash;
    }

    protected static HashMap<String, Object> convertAppBannerToMap(Banner payload) {
        HashMap<String, Object> hash = new HashMap<>();

        hash.put("_id", payload.getId());
        hash.put("title", payload.getTitle());
        hash.put("name", payload.getName());
        hash.put("description", payload.getDescription());
        hash.put("mediaUrl", payload.getMediaUrl());

        Log.d("CleverPush", "Created json payload: " + hash.toString());

        return hash;
    }

    protected static HashMap<String, Object> convertAppBannerActionToMap(BannerAction payload) {
        HashMap<String, Object> hash = new HashMap<>();

        hash.put("url", payload.getUrl());
        hash.put("urlType", payload.getUrlType());
        hash.put("name", payload.getName());
        hash.put("type", payload.getType());

        Log.d("CleverPush", "Created json payload: " + hash.toString());

        return hash;
    }

    static ArrayList<HashMap> convertNotificationToMapList(ArrayList<Notification> notifications) throws JSONException {
        ArrayList<HashMap> notificationMapList = new ArrayList<>();
        for (int i = 0; i < notifications.size(); i++) {
            HashMap<String, Object> hash = convertNotificationToMap(notifications.get(i));
            notificationMapList.add(hash);
        }

        return notificationMapList;
    }

    static ArrayList<HashMap> convertChannelTopicToMapList(ArrayList<ChannelTopic> channelTopics) throws JSONException {
        ArrayList<HashMap> availableTopics = new ArrayList<>();
        for (int i = 0; i < channelTopics.size(); i++) {
            HashMap<String, Object> hash = new HashMap<>();

            hash.put("id", channelTopics.get(i).getId());
            hash.put("name", channelTopics.get(i).getName());
            hash.put("parentTopicId", channelTopics.get(i).getParentTopicId());
            hash.put("defaultUnchecked", channelTopics.get(i).getDefaultUnchecked());
            hash.put("fcmBroadcastTopic", channelTopics.get(i).getFcmBroadcastTopic());
            hash.put("externalId", channelTopics.get(i).getExternalId());
            if (channelTopics.get(i).getCustomData() != null){
                hash.put("customData", channelTopics.get(i).getCustomData());
            }
            availableTopics.add(hash);
        }
        return availableTopics;
    }

    static ArrayList<HashMap> convertChannelTagToMapList(ArrayList<ChannelTag> channelTags) throws JSONException {
        ArrayList<HashMap> availableTags = new ArrayList<>();
        for (int i = 0; i < channelTags.size(); i++) {
            HashMap<String, Object> hash = new HashMap<>();

            hash.put("id", channelTags.get(i).getId());
            hash.put("name", channelTags.get(i).getName());
            availableTags.add(hash);
        }
        return availableTags;
    }

    static ArrayList<HashMap> convertCustomAttributeToMapList(ArrayList<CustomAttribute> customAttributes) throws JSONException {
        ArrayList<HashMap> availableAttributes = new ArrayList<>();
        for (int i = 0; i < customAttributes.size(); i++) {
            HashMap<String, Object> hash = new HashMap<>();

            hash.put("id", customAttributes.get(i).getId());
            hash.put("name", customAttributes.get(i).getName());
            availableAttributes.add(hash);
        }
        return availableAttributes;
    }

    static HashMap<String, Object> convertNotificationOpenResultToMap(NotificationOpenedResult openResult) throws JSONException {
        HashMap<String, Object> hash = new HashMap<>();

        hash.put("notification", convertNotificationToMap(openResult.getNotification()));

        return hash;
    }

    static HashMap<String, Object> convertJSONObjectToHashMap(JSONObject object) throws JSONException {
        HashMap<String, Object> hash = new HashMap<>();

        if (object == null || object == JSONObject.NULL) {
            return hash;
        }

        Iterator<String> keys = object.keys();

        while (keys.hasNext()) {
            String key = keys.next();

            if (object.isNull(key))
                continue;

            Object val = object.get(key);

            if (val instanceof JSONArray) {
                val = convertJSONArrayToList((JSONArray)val);
            } else if (val instanceof JSONObject) {
                val = convertJSONObjectToHashMap((JSONObject)val);
            }

            hash.put(key, val);
        }

        return hash;
    }

    private static List<Object> convertJSONArrayToList(JSONArray array) throws JSONException {
        List<Object> list = new ArrayList<>();

        for (int i = 0; i < array.length(); i++) {
            Object val = array.get(i);

            if (val instanceof JSONArray)
                val = CleverPushSerializer.convertJSONArrayToList((JSONArray)val);
            else if (val instanceof JSONObject)
                val = convertJSONObjectToHashMap((JSONObject)val);

            list.add(val);
        }

        return list;
    }

    private static Date tryParseDate(String dateStr) {
        List<String> formats = Arrays.asList(
                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                "yyyy-MM-dd'T'HH:mm:ss'Z'",
                "yyyy-MM-dd HH:mm:ss",
                "MMM dd, yyyy hh:mm:ss a",
                "MMM dd, yyyy hh:mm a",
                "yyyy-MM-dd"
        );

        for (String format : formats) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(format, Locale.US);
                sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
                return sdf.parse(dateStr);
            } catch (Exception ignored) {}
        }

        return null;
    }
}
