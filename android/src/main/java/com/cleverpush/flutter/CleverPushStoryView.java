package com.cleverpush.flutter;

import android.content.Context;
import android.graphics.Color;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.cleverpush.stories.StoryView;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

class CleverPushStoryView implements PlatformView, MethodChannel.MethodCallHandler {
  private final StoryView storyView;
  private final MethodChannel methodChannel;

    CleverPushStoryView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, BinaryMessenger messenger) {
    storyView = new StoryView(context, null);
    methodChannel = new MethodChannel(messenger, "cleverpush-story-view_" + id);
    methodChannel.setMethodCallHandler(this);
    if (creationParams != null) {
      setParams(creationParams);
    }
    storyView.setOpenedListener((url) -> {
      methodChannel.invokeMethod("onOpened", url);
    });
  }

  private void setParams(Map<String, Object> params) {
    if (params.containsKey("widgetId")) {
      storyView.setWidgetId((String) params.get("widgetId"));
    }
    if (params.containsKey("backgroundColor")) {
      storyView.setBackgroundColor(Color.parseColor((String) params.get("backgroundColor")));
    }
    if (params.containsKey("backgroundColorDarkMode")) {
      storyView.setBackgroundColorDarkMode(Color.parseColor((String) params.get("backgroundColorDarkMode")));
    }
    if (params.containsKey("textColor")) {
      storyView.setTextColor(Color.parseColor((String) params.get("textColor")));
    }
    if (params.containsKey("textColorDarkMode")) {
      storyView.setTextColorDarkMode(Color.parseColor((String) params.get("textColorDarkMode")));
    }
    if (params.containsKey("storyViewHeight")) {
      storyView.setStoryViewHeight((int) params.get("storyViewHeight"));
    }
    if (params.containsKey("storyViewWidth")) {
      storyView.setStoryViewWidth((int) params.get("storyViewWidth"));
    }
    if (params.containsKey("fontFamily")) {
      storyView.setFontFamily((String) params.get("fontFamily"));
    }
    if (params.containsKey("titleVisibility")) {
      storyView.setTitleVisibility((int) params.get("titleVisibility"));
    }
    if (params.containsKey("titlePosition")) {
      storyView.setTitlePosition((int) params.get("titlePosition"));
    }
    if (params.containsKey("titleTextSize")) {
      storyView.setTitleTextSize((int) params.get("titleTextSize"));
    }
    if (params.containsKey("titleMinTextSize")) {
      storyView.setTitleMinTextSize((int) params.get("titleMinTextSize"));
    }
    if (params.containsKey("titleMaxTextSize")) {
      storyView.setTitleMaxTextSize((int) params.get("titleMaxTextSize"));
    }
    if (params.containsKey("storyIconHeight")) {
      storyView.setStoryIconHeight((int) params.get("storyIconHeight"));
    }
    if (params.containsKey("storyIconHeightPercentage")) {
      storyView.setStoryIconHeightPercentage((int) params.get("storyIconHeightPercentage"));
    }
    if (params.containsKey("storyIconWidth")) {
      storyView.setStoryIconWidth((int) params.get("storyIconWidth"));
    }
    if (params.containsKey("storyIconCornerRadius")) {
      storyView.setStoryIconCornerRadius(((Double) params.get("storyIconCornerRadius")).floatValue());
    }
    if (params.containsKey("storyIconSpace")) {
      storyView.setStoryIconSpace(((Double) params.get("storyIconSpace")).floatValue());
    }
    if (params.containsKey("storyIconShadow")) {
      storyView.setStoryIconShadow((boolean) params.get("storyIconShadow"));
    }
    if (params.containsKey("borderVisibility")) {
      storyView.setBorderVisibility((int) params.get("borderVisibility"));
    }
    if (params.containsKey("borderMargin")) {
      storyView.setBorderMargin(((Double) params.get("borderMargin")).floatValue());
    }
    if (params.containsKey("borderWidth")) {
      storyView.setBorderWidth((int) params.get("borderWidth"));
    }
    if (params.containsKey("borderColor")) {
      storyView.setBorderColor(Color.parseColor((String) params.get("borderColor")));
    }
    if (params.containsKey("borderColorDarkMode")) {
      storyView.setBorderColorDarkMode(Color.parseColor((String) params.get("borderColorDarkMode")));
    }
    if (params.containsKey("borderColorLoading")) {
      storyView.setBorderColorLoading(Color.parseColor((String) params.get("borderColorLoading")));
    }
    if (params.containsKey("borderColorLoadingDarkMode")) {
      storyView.setBorderColorLoadingDarkMode(Color.parseColor((String) params.get("borderColorLoadingDarkMode")));
    }
    if (params.containsKey("subStoryUnreadCountVisibility")) {
      storyView.setSubStoryUnreadCountVisibility((int) params.get("subStoryUnreadCountVisibility"));
    }
    if (params.containsKey("subStoryUnreadCountBackgroundColor")) {
      storyView.setSubStoryUnreadCountBackgroundColor(Color.parseColor((String) params.get("subStoryUnreadCountBackgroundColor")));
    }
    if (params.containsKey("subStoryUnreadCountBackgroundColorDarkMode")) {
      storyView.setSubStoryUnreadCountBackgroundColorDarkMode(Color.parseColor((String) params.get("subStoryUnreadCountBackgroundColorDarkMode")));
    }
    if (params.containsKey("subStoryUnreadCountTextColor")) {
      storyView.setSubStoryUnreadCountTextColor(Color.parseColor((String) params.get("subStoryUnreadCountTextColor")));
    }
    if (params.containsKey("subStoryUnreadCountTextColorDarkMode")) {
      storyView.setSubStoryUnreadCountTextColorDarkMode(Color.parseColor((String) params.get("subStoryUnreadCountTextColorDarkMode")));
    }
    if (params.containsKey("subStoryUnreadCountBadgeHeight")) {
      storyView.setSubStoryUnreadCountBadgeHeight((int) params.get("subStoryUnreadCountBadgeHeight"));
    }
    if (params.containsKey("subStoryUnreadCountBadgeWidth")) {
      storyView.setSubStoryUnreadCountBadgeWidth((int) params.get("subStoryUnreadCountBadgeWidth"));
    }
    if (params.containsKey("restrictToItems")) {
      storyView.setRestrictToItems((int) params.get("restrictToItems"));
    }
    if (params.containsKey("closeButtonPosition")) {
      storyView.setCloseButtonPosition((int) params.get("closeButtonPosition"));
    }
    if (params.containsKey("sortToLastIndex")) {
      storyView.setSortToLastIndex((int) params.get("sortToLastIndex"));
    }
    if (params.containsKey("darkModeEnabled")) {
      storyView.setDarkModeEnabled((boolean) params.get("darkModeEnabled"));
    }
  }

  @NonNull
  @Override
  public View getView() {
    return storyView;
  }

  @Override
  public void dispose() {
    methodChannel.setMethodCallHandler(null);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    // No methods to call from Flutter to native for now
  }
}