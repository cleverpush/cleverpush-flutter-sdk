package com.cleverpush.example;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    com.facebook.FacebookSdk.setApplicationId("1706957412766995");
    com.facebook.FacebookSdk.sdkInitialize(getApplicationContext());
    GeneratedPluginRegistrant.registerWith(this);
  }
}
