package com.cleverpush.flutter;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.plugin.common.StandardMessageCodec;

class CleverPushStoryViewFactory extends PlatformViewFactory {
  private final BinaryMessenger messenger;

  CleverPushStoryViewFactory(BinaryMessenger messenger) {
    super(StandardMessageCodec.INSTANCE);
    this.messenger = messenger;
  }

  @NonNull
  @Override
  public PlatformView create(@NonNull Context context, int viewId, @Nullable Object args) {
    Map<String, Object> creationParams = (Map<String, Object>) args;
    return new CleverPushStoryView(context, viewId, creationParams, messenger);
  }
}
