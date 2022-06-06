package com.cleverpush.flutter;

import android.content.Context;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.cleverpush.chat.ChatView;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

class CleverPushChatView implements PlatformView {
    @NonNull private final ChatView chatView;

    CleverPushChatView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        chatView = new ChatView(context);
    }

    @NonNull
    @Override
    public View getView() {
        return chatView;
    }

    @Override
    public void dispose() {}
}
