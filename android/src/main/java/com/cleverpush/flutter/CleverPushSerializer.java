package com.cleverpush.flutter;

import android.util.Log;
import com.cleverpush.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

class CleverPushSerializer {
    private static HashMap<String, Object> convertNotificationToMap(Notification payload) throws JSONException {
       HashMap<String, Object> hash = new HashMap<>();

        hash.put("_id", payload.getId());
        hash.put("title", payload.getTitle());
        hash.put("text", payload.getText());
        hash.put("url", payload.getUrl());
        hash.put("iconUrl", payload.getIconUrl());
        hash.put("mediaUrl", payload.getMediaUrl());
        hash.put("createdAt", payload.getCreatedAt());

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

    static ArrayList<HashMap> convertNotificationToMapList(ArrayList<Notification> notifications) throws JSONException {
        ArrayList<HashMap> notificationMapList = new ArrayList<>();
        for (int i = 0; i <notifications.size() ; i++) {
            HashMap<String, Object> hash = new HashMap<>();

            hash.put("_id", notifications.get(i).getId());
            hash.put("title", notifications.get(i).getTitle());
            hash.put("text", notifications.get(i).getText());
            hash.put("url", notifications.get(i).getUrl());
            hash.put("iconUrl", notifications.get(i).getIconUrl());
            hash.put("mediaUrl", notifications.get(i).getMediaUrl());
            hash.put("createdAt", notifications.get(i).getCreatedAt());

            ArrayList<HashMap> buttons = new ArrayList<>();

            if (notifications.get(i).getActions() != null) {
                for (int j = 0; j < notifications.get(i).getActions().length; j++) {
                    NotificationAction button = notifications.get(i).getActions()[j];

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

            if (notifications.get(i).getCustomData() != null)
                hash.put("customData", notifications.get(i).getCustomData());
            notificationMapList.add(hash);
        }

        return notificationMapList;
    }

    static ArrayList<HashMap> convertChannelTopicToMapList(ArrayList<ChannelTopic> channelTopics) throws JSONException {
        ArrayList<HashMap> availableTopics = new ArrayList<>();
        for (int i = 0; i <channelTopics.size() ; i++) {
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


    static HashMap<String, Object> convertNotificationOpenResultToMap(NotificationOpenedResult openResult) throws JSONException {
        HashMap<String, Object> hash = new HashMap<>();

        hash.put("notification", convertNotificationToMap(openResult.getNotification()));

        return hash;
    }

    static HashMap<String, Object> convertJSONObjectToHashMap(JSONObject object) throws JSONException {
        HashMap<String, Object> hash = new HashMap<>();

        if (object == null || object == JSONObject.NULL)
           return hash;

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
}
