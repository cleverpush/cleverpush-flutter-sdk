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
