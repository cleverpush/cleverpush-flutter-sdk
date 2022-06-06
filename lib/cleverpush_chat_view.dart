import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class CleverPushChatView extends StatelessWidget {
  const CleverPushChatView({ Key? key }) : super(key: key);

  Widget build(BuildContext context) {
    const String viewType = 'cleverpush-chat-view';
    const Map<String, dynamic> creationParams = <String, dynamic>{};

    switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          return PlatformViewLink(
            viewType: viewType,
            surfaceFactory:
                (context, controller) {
              return AndroidViewSurface(
                controller: controller as AndroidViewController,
                gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
              );
            },
            onCreatePlatformView: (params) {
              return PlatformViewsService.initSurfaceAndroidView(
                id: params.id,
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () {
                  params.onFocusChanged(true);
                },
              )
                ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                ..create();
            },
          );
        case TargetPlatform.iOS:
          return UiKitView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
          );
        default:
          throw UnsupportedError('Unsupported platform view');
      }
  }
}
