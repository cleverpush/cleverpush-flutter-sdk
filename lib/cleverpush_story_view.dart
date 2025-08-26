import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

/// Story view size (height/width)
enum CleverPushStoryViewSize {
  fillParent,   // -1
  matchParent,  // -1
  wrapContent,  // -2
}

extension CleverPushStoryViewSizeExtension on CleverPushStoryViewSize {
  int get toNativeValue {
    switch (this) {
      case CleverPushStoryViewSize.fillParent:
      case CleverPushStoryViewSize.matchParent:
        return -1;
      case CleverPushStoryViewSize.wrapContent:
        return -2;
    }
  }
}

/// Visibility options
enum CleverPushVisibility {
  visible,     // 0
  invisible,   // 4
  gone,        // 8
}

extension CleverPushVisibilityExtension on CleverPushVisibility {
  int get toNativeValue {
    switch (this) {
      case CleverPushVisibility.visible:
        return 0;
      case CleverPushVisibility.invisible:
        return 4;
      case CleverPushVisibility.gone:
        return 8;
    }
  }
}

/// Title position
enum CleverPushStoryTitlePosition {
  positionDefault,       // 0
  positionInsideBottom,  // 1
  positionInsideTop,     // 2
}

extension CleverPushStoryTitlePositionExtension
on CleverPushStoryTitlePosition {
  int get toNativeValue {
    switch (this) {
      case CleverPushStoryTitlePosition.positionDefault:
        return 0;
      case CleverPushStoryTitlePosition.positionInsideBottom:
        return 1;
      case CleverPushStoryTitlePosition.positionInsideTop:
        return 2;
    }
  }
}

/// Close button position
enum CleverPushStoryCloseButtonPosition {
  left,   // 0
  right,  // 1
}

extension CleverPushStoryCloseButtonPositionExtension
on CleverPushStoryCloseButtonPosition {
  int get toNativeValue {
    switch (this) {
      case CleverPushStoryCloseButtonPosition.left:
        return 0;
      case CleverPushStoryCloseButtonPosition.right:
        return 1;
    }
  }
}

/// Sort to last index
enum CleverPushStorySortToLastIndex {
  positionDefault, // 0
  positionEnd,     // 1
}

extension CleverPushStorySortToLastIndexExtension
on CleverPushStorySortToLastIndex {
  int get toNativeValue {
    switch (this) {
      case CleverPushStorySortToLastIndex.positionDefault:
        return 0;
      case CleverPushStorySortToLastIndex.positionEnd:
        return 1;
    }
  }
}

class CleverPushStoryView extends StatefulWidget {
  final String widgetId;
  final String? backgroundColor;
  final String? backgroundColorDarkMode;
  final String? textColor;
  final String? textColorDarkMode;
  final CleverPushStoryViewSize? storyViewHeight;
  final CleverPushStoryViewSize? storyViewWidth;
  final String? fontFamily;
  final CleverPushVisibility? titleVisibility;
  final CleverPushStoryTitlePosition? titlePosition;
  final int? titleTextSize;
  final int? titleMinTextSize;
  final int? titleMaxTextSize;
  final int? storyIconHeight;
  final int? storyIconHeightPercentage;
  final int? storyIconWidth;
  final double? storyIconCornerRadius;
  final double? storyIconSpace;
  final bool? storyIconShadow;
  final CleverPushVisibility? borderVisibility;
  final double? borderMargin;
  final int? borderWidth;
  final String? borderColor;
  final String? borderColorDarkMode;
  final String? borderColorLoading;
  final String? borderColorLoadingDarkMode;
  final CleverPushVisibility? subStoryUnreadCountVisibility;
  final String? subStoryUnreadCountBackgroundColor;
  final String? subStoryUnreadCountBackgroundColorDarkMode;
  final String? subStoryUnreadCountTextColor;
  final String? subStoryUnreadCountTextColorDarkMode;
  final int? subStoryUnreadCountBadgeHeight;
  final int? subStoryUnreadCountBadgeWidth;
  final int? restrictToItems;
  final CleverPushStoryCloseButtonPosition? closeButtonPosition;
  final CleverPushStorySortToLastIndex? sortToLastIndex;
  final bool? darkModeEnabled;
  final void Function(String url)? onOpened;
  final bool? storyWidgetShareButtonVisibility;
  final bool? allowAutoRotation;
  final bool? autoTrackShown;

  const CleverPushStoryView({
    Key? key,
    required this.widgetId,
    this.backgroundColor,
    this.backgroundColorDarkMode,
    this.textColor,
    this.textColorDarkMode,
    this.storyViewHeight,
    this.storyViewWidth,
    this.fontFamily,
    this.titleVisibility,
    this.titlePosition,
    this.titleTextSize,
    this.titleMinTextSize,
    this.titleMaxTextSize,
    this.storyIconHeight,
    this.storyIconHeightPercentage,
    this.storyIconWidth,
    this.storyIconCornerRadius,
    this.storyIconSpace,
    this.storyIconShadow,
    this.borderVisibility,
    this.borderMargin,
    this.borderWidth,
    this.borderColor,
    this.borderColorDarkMode,
    this.borderColorLoading,
    this.borderColorLoadingDarkMode,
    this.subStoryUnreadCountVisibility,
    this.subStoryUnreadCountBackgroundColor,
    this.subStoryUnreadCountBackgroundColorDarkMode,
    this.subStoryUnreadCountTextColor,
    this.subStoryUnreadCountTextColorDarkMode,
    this.subStoryUnreadCountBadgeHeight,
    this.subStoryUnreadCountBadgeWidth,
    this.restrictToItems,
    this.closeButtonPosition,
    this.sortToLastIndex,
    this.darkModeEnabled,
    this.onOpened,
    this.storyWidgetShareButtonVisibility,
    this.allowAutoRotation,
    this.autoTrackShown,
  }) : super(key: key);

  @override
  _CleverPushStoryViewState createState() => _CleverPushStoryViewState();
}

class _CleverPushStoryViewState extends State<CleverPushStoryView> {
  MethodChannel? _channel;

  @override
  void dispose() {
    _channel?.setMethodCallHandler(null);
    _channel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'widgetId': widget.widgetId,
      'backgroundColor': widget.backgroundColor,
      'backgroundColorDarkMode': widget.backgroundColorDarkMode,
      'textColor': widget.textColor,
      'textColorDarkMode': widget.textColorDarkMode,
      'storyViewHeight': widget.storyViewHeight?.toNativeValue,
      'storyViewWidth': widget.storyViewWidth?.toNativeValue,
      'fontFamily': widget.fontFamily,
      'titleVisibility': widget.titleVisibility?.toNativeValue,
      'titlePosition': widget.titlePosition?.toNativeValue,
      'titleTextSize': widget.titleTextSize,
      'titleMinTextSize': widget.titleMinTextSize,
      'titleMaxTextSize': widget.titleMaxTextSize,
      'storyIconHeight': widget.storyIconHeight,
      'storyIconHeightPercentage': widget.storyIconHeightPercentage,
      'storyIconWidth': widget.storyIconWidth,
      'storyIconCornerRadius': widget.storyIconCornerRadius,
      'storyIconSpace': widget.storyIconSpace,
      'storyIconShadow': widget.storyIconShadow,
      'borderVisibility': widget.borderVisibility?.toNativeValue,
      'borderMargin': widget.borderMargin,
      'borderWidth': widget.borderWidth,
      'borderColor': widget.borderColor,
      'borderColorDarkMode': widget.borderColorDarkMode,
      'borderColorLoading': widget.borderColorLoading,
      'borderColorLoadingDarkMode': widget.borderColorLoadingDarkMode,
      'subStoryUnreadCountVisibility': widget.subStoryUnreadCountVisibility?.toNativeValue,
      'subStoryUnreadCountBackgroundColor': widget.subStoryUnreadCountBackgroundColor,
      'subStoryUnreadCountBackgroundColorDarkMode': widget.subStoryUnreadCountBackgroundColorDarkMode,
      'subStoryUnreadCountTextColor': widget.subStoryUnreadCountTextColor,
      'subStoryUnreadCountTextColorDarkMode': widget.subStoryUnreadCountTextColorDarkMode,
      'subStoryUnreadCountBadgeHeight': widget.subStoryUnreadCountBadgeHeight,
      'subStoryUnreadCountBadgeWidth': widget.subStoryUnreadCountBadgeWidth,
      'restrictToItems': widget.restrictToItems,
      'closeButtonPosition': widget.closeButtonPosition?.toNativeValue,
      'sortToLastIndex': widget.sortToLastIndex?.toNativeValue,
      'darkModeEnabled': widget.darkModeEnabled,
      'storyWidgetShareButtonVisibility': widget.storyWidgetShareButtonVisibility,
      'allowAutoRotation': widget.allowAutoRotation,
      'autoTrackShown': widget.autoTrackShown,
    };
    
    creationParams.removeWhere((key, value) => value == null);

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'cleverpush-story-view',
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
        },
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'cleverpush-story-view',
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
        },
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }

    return const Text('StoryView is only available on Android and iOS.');
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('cleverpush-story-view_' + id.toString());
    _channel!.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onOpened') {
        final dynamic args = call.arguments;
        final String url = args is String ? args : '';
        if (widget.onOpened != null) {
          widget.onOpened!(url);
        }
      }
      return null;
    });
  }
}
