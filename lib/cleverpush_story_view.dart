import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Story view size (height/width)
enum CleverPushStoryViewSize {
  matchParent,  // -1
  wrapContent,  // -2
}

extension CleverPushStoryViewSizeExtension on CleverPushStoryViewSize {
  int get toNativeValue {
    switch (this) {
      case CleverPushStoryViewSize.matchParent:
        return -1;
      case CleverPushStoryViewSize.wrapContent:
        return -2;
    }
  }
}

/// Visibility options
enum CleverPushVisibility {
  visible,     // 0 (Android), true (iOS)
  gone,        // 8 (Android), false (iOS)
}

extension CleverPushVisibilityExtension on CleverPushVisibility {
  int get toNativeValue {
    switch (this) {
      case CleverPushVisibility.visible:
        return 0;
      case CleverPushVisibility.gone:
        return 8;
    }
  }

  dynamic get toPlatformValue {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      switch (this) {
        case CleverPushVisibility.visible:
          return true;
        case CleverPushVisibility.gone:
          return false;
      }
    }
    return toNativeValue;
  }
}

/// Title position
enum CleverPushStoryTitlePosition {
  positionDefault,       // 0 (Android), 0 (iOS)
  positionInsideBottom,  // 1 (Android), 2 (iOS)
  positionInsideTop,     // 2 (Android), 1 (iOS)
}

extension CleverPushStoryTitlePositionExtension
    on CleverPushStoryTitlePosition {
  int get toNativeValue {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      switch (this) {
        case CleverPushStoryTitlePosition.positionDefault:
          return 0;
        case CleverPushStoryTitlePosition.positionInsideTop:
          return 1;
        case CleverPushStoryTitlePosition.positionInsideBottom:
          return 2;
      }
    } else {
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
  positionDefault, // 0 (Android), false (iOS)
  positionEnd,     // 1 (Android), true (iOS)
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

  dynamic get toPlatformValue {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      switch (this) {
        case CleverPushStorySortToLastIndex.positionDefault:
          return false;
        case CleverPushStorySortToLastIndex.positionEnd:
          return true;
      }
    }
    return toNativeValue;
  }
}

class CleverPushStoryView extends StatefulWidget {
  final String widgetId;
  final String? backgroundColor;
  final String? backgroundColorDarkMode;
  final String? textColor;
  final String? textColorDarkMode;
  final Object? storyViewHeightAndroid;
  final Object? storyViewWidthAndroid;
  final int? storyViewHeightiOS;
  final int? storyViewWidthiOS;
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
    this.storyViewHeightAndroid,
    this.storyViewWidthAndroid,
    this.storyViewHeightiOS,
    this.storyViewWidthiOS,
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
  })  : assert(storyViewHeightAndroid == null ||
            storyViewHeightAndroid is int ||
            storyViewHeightAndroid is CleverPushStoryViewSize),
        assert(storyViewWidthAndroid == null ||
            storyViewWidthAndroid is int ||
            storyViewWidthAndroid is CleverPushStoryViewSize),
        super(key: key);

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
    final media = MediaQuery.maybeOf(context);
    final textScaler = media?.textScaler ?? const TextScaler.linear(1.0);
    final double textScale = textScaler.scale(16.0) / 16.0;
    final double devicePixelRatio = media?.devicePixelRatio ?? 2.0;
    const double baseFactor = 13 / 38; // Anchor example: Android 38 -> iOS 13
    final double dynamicFactor =
        (baseFactor * (2.0 / devicePixelRatio)) / textScale;
    int? _iOSNormalizeTitleSize(int? androidSize) {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        int computed = (androidSize! * dynamicFactor).round();
        if (widget.storyIconHeight != null) {
          final int maxByIcon = (widget.storyIconHeight! * 0.5).round();
          if (computed > maxByIcon) computed = maxByIcon;
        }
        return computed;
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        return androidSize;
      }
      return null;
    }

    int? _androidViewDimension(Object? value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is CleverPushStoryViewSize) return value.toNativeValue;
      return null;
    }

    final Map<String, dynamic> creationParams = <String, dynamic>{
      'widgetId': widget.widgetId,
      'backgroundColor': widget.backgroundColor,
      'backgroundColorDarkMode': widget.backgroundColorDarkMode,
      'textColor': widget.textColor,
      'textColorDarkMode': widget.textColorDarkMode,
      'storyViewHeightAndroid': _androidViewDimension(widget.storyViewHeightAndroid),
      'storyViewWidthAndroid': _androidViewDimension(widget.storyViewWidthAndroid),
      'storyViewHeightiOS': widget.storyViewHeightiOS,
      'storyViewWidthiOS': widget.storyViewWidthiOS,
      'fontFamily': widget.fontFamily,
      'titleVisibility': widget.titleVisibility?.toPlatformValue,
      'titlePosition': widget.titlePosition?.toNativeValue,
      'titleTextSize': _iOSNormalizeTitleSize(widget.titleTextSize),
      'titleMinTextSize': widget.titleMinTextSize,
      'titleMaxTextSize': widget.titleMaxTextSize,
      'storyIconHeight': widget.storyIconHeight,
      'storyIconHeightPercentage': widget.storyIconHeightPercentage,
      'storyIconWidth': widget.storyIconWidth,
      'storyIconCornerRadius': widget.storyIconCornerRadius,
      'storyIconSpace': widget.storyIconSpace,
      'storyIconShadow': widget.storyIconShadow,
      'borderVisibility': widget.borderVisibility?.toPlatformValue,
      'storyIconBorderVisibility': widget.borderVisibility?.toPlatformValue,
      'borderMargin': widget.borderMargin,
      'borderWidth': widget.borderWidth,
      'borderColor': widget.borderColor,
      'borderColorDarkMode': widget.borderColorDarkMode,
      'borderColorLoading': widget.borderColorLoading,
      'borderColorLoadingDarkMode': widget.borderColorLoadingDarkMode,
      'subStoryUnreadCountVisibility': widget.subStoryUnreadCountVisibility?.toPlatformValue,
      'unreadStoryCountVisibility': widget.subStoryUnreadCountVisibility?.toPlatformValue,
      'subStoryUnreadCountBackgroundColor': widget.subStoryUnreadCountBackgroundColor,
      'subStoryUnreadCountBackgroundColorDarkMode': widget.subStoryUnreadCountBackgroundColorDarkMode,
      'subStoryUnreadCountTextColor': widget.subStoryUnreadCountTextColor,
      'subStoryUnreadCountTextColorDarkMode': widget.subStoryUnreadCountTextColorDarkMode,
      'subStoryUnreadCountBadgeHeight': widget.subStoryUnreadCountBadgeHeight,
      'subStoryUnreadCountBadgeWidth': widget.subStoryUnreadCountBadgeWidth,
      'restrictToItems': widget.restrictToItems,
      'closeButtonPosition': widget.closeButtonPosition?.toNativeValue,
      'sortToLastIndex': widget.sortToLastIndex?.toPlatformValue,
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
      final Widget platformView = UiKitView(
        viewType: 'cleverpush-story-view',
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
        },
        onPlatformViewCreated: _onPlatformViewCreated,
      );
      final double? _width = widget.storyViewWidthiOS?.toDouble();
      final double? _height = widget.storyViewHeightiOS?.toDouble();
      if (_width != null || _height != null) {
        return SizedBox(
          width: _width,
          height: _height,
          child: platformView,
        );
      }
      return platformView;
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
