## 1.24.29 (22.12.2025)
* Fixed a CPTopic mapping issue (parentTopic on iOS vs parentTopicId on Android) to ensure compatibility with both payloads.
* Updated native iOS + Android SDKs

## 1.24.28 (05.12.2025)
* Updated native iOS + Android SDKs

## 1.24.27 (26.11.2025)
* Updated native iOS + Android SDKs

## 1.24.26 (18.11.2025)
* Implemented `SubscriptionHandler` to provide success and failure results during the subscription flow.
* Added a `CPTopic` class for topics, including implementations for `hashCode`, `equals`, `toString`, `copyWith`, and additional helper methods.
* Updated native iOS + Android SDKs

## 1.24.25 (16.09.2025)
* Updated native iOS + Android SDKs

## 1.24.24 (12.09.2025)
* Implemented `StoryView` for Android and iOS.

## 1.24.23 (11.08.2025)
* Added `setRead` methods to the `Notification` class, allowing notifications to be marked as read or unread.
* Updated native iOS + Android SDKs

## 1.24.22 (23.07.2025)
* Updated Android Gradle Plugin and dependencies to support API Level 35

## 1.24.21 (21.07.2025)
* Fixed an issue where `setNotificationReceivedHandler`, `setNotificationOpenedHandler`, and `setSubscribedHandler` were not working when using WorkManager.

## 1.24.20 (11.07.2025)
* Updated native iOS + Android SDKs

## 1.24.19 (08.07.2025)
* Updated native iOS + Android SDKs

## 1.24.18 (07.07.2025)
* createdAt date should be in ISO format in `getNotifications` method.

## 1.24.17 (06.06.2025)
* implemented `setMaximumNotificationCount` method

## 1.24.16 (04.06.2025)
* Optimized `init`

## 1.24.15 (30.05.2025)
* Created a new method `showAppBanner` with `AppBannerClosedListener`.
* Fixed an issue where `setSubscriptionTopics` always returned `null` on Android.
* Updated native iOS + Android SDKs

## 1.24.14 (15.04.2025)
* Resolved the issue where `setSubscriptionTopics` and `getSubscriptionTopics` should not be updated if the API call fails in iOS.

## 1.24.13 (09.04.2025)
* Optimize the `colorWithHexString` function to prevent crashes when providing an invalid color code in iOS.

## 1.24.12 (06.04.2025)
* Updated native Android SDK

## 1.24.11 (05.04.2025)
* Updated native iOS SDK

## 1.24.10 (03.04.2025)
* Updated native iOS SDK

## 1.24.9 (25.03.2025)
* Updated native iOS SDK
* Optimized `init` and `setSubscriptionTopics` error handling.

## 1.24.8 (12.03.2025)
* Updated native iOS + Android SDKs

## 1.24.7 (10.03.2025)
* Fixed `id` field for `getNotifications`

## 1.24.6 (10.03.2025)
* Updated native iOS + Android SDKs

## 1.24.5 (06.03.2025)
* Updated native iOS + Android SDKs

## 1.24.4 (06.03.2025)
* Updated native Android SDKs

## 1.24.3 (05.03.2025)
* Updated native iOS + Android SDKs

## 1.24.2 (05.03.2025)
* Updated native iOS + Android SDKs

## 1.24.1 (24.02.2025)
* Updated native iOS SDK

## 1.24.0 (24.02.2025)
* Updated native iOS SDK

## 1.23.40 (19.02.2025)
* Fixed `setAutoRequestNotificationPermission` implementation for Android

## 1.23.39 (18.02.2025)
* Added `setAutoRequestNotificationPermission` method
* Updated native iOS + Android SDKs

## 1.23.38 (12.02.2025)
* Updated native iOS + Android SDKs
* Resolved Android Type warnings.
* Resolved accessing push notification data on iOS

## 1.23.37 (22.11.2024)
* Updated native iOS + Android SDKs

## 1.23.36 (18.11.2024)
* Updated native iOS SDK to fix an issue with opening notifications with action buttons

## 1.23.35 (16.11.2024)
* Some futures were resolved too early, this has been fixed.
* Updated native iOS + Android SDKs

## 1.23.34 (26.09.2024)
* Implemented `setIgnoreDisabledNotificationPermission`
* Updated native iOS + Android SDKs

## 1.23.33 (18.09.2024)
* Updated native iOS + Android SDKs

## 1.23.32 (29.08.2024)
* Updated native iOS + Android SDKs

## 1.23.31 (19.08.2024)
* Updated native iOS + Android SDKs

## 1.23.30 (09.08.2024)
* Updated native iOS + Android SDKs

## 1.23.29 (23.07.2024)
* Updated native iOS + Android SDKs

## 1.23.28 (12.07.2024)
* Updated native iOS + Android SDKs

## 1.23.27 (12.06.2024)
* Updated native iOS + Android SDKs

## 1.23.26 (29.05.2024)
* Updated native iOS + Android SDKs

## 1.23.25 (23.05.2024)
* Added `appBanner` field to CPNotification

## 1.23.24 (21.05.2024)
* Added `showAppBanner` method

## 1.23.23 (10.05.2024)
* Updated native iOS + Android SDKs

## 1.23.22 (19.04.2024)
* Updated native iOS + Android SDKs

## 1.23.21 (10.04.2024)
* Updated native iOS + Android SDKs

## 1.23.20 (29.03.2024)
* Updated native iOS + Android SDKs

## 1.23.19 (22.03.2024)
* Updated native iOS + Android SDKs

## 1.23.18 (29.02.2024)
* Updated native Android SDKs
* Optimized `dictionaryWithPropertiesOfObject` method while the object type is an array in iOS.

## 1.23.17 (28.02.2024)
* Updated native iOS + Android SDKs
* Optimized `getNotifications` and `getNotificationsWithApi` method
* Optimised `getAvailableTags` method for preventing a crash in iOS.

## 1.23.16 (02.02.2024)
* Fixed crash on iOS in `getAvailableTopics` method

## 1.23.15 (25.01.2024)
* Fixed issue on Android with `getSubscriptionAttribute` and `getSubscriptionAttribute` method

## 1.23.14 (05.01.2024)
* Fixed build issue on Android for v8

## 1.23.13 (03.01.2024)
* Updated native iOS SDK

## 1.23.12 (02.01.2024)
* Resolved crashed issue in the `getNotificationsWithApi` method in iOS.

## 1.23.11 (28.12.2023)
* integrated `pushSubscriptionAttributeValue` and `pullSubscriptionAttributeValue` methods

## 1.23.10
* Fixed issue on iOS with `setAppBannerOpenedHandler` method

## 1.23.9
* Updated native iOS + Android SDKs

## 1.23.8
* Updated native iOS + Android SDKs

## 1.23.7
* Optimized `getDeviceToken` for iOS + Android

## 1.23.6
* Fixed issue on iOS with `getReceivedNotifications` method

## 1.23.5 (18.11.2023)
* Implemented `setAuthorizerToken` method
* Updated native iOS + Android SDKs

## 1.23.4
* Updated native Android SDK
* Updated native iOS SDK

## 1.23.3
* Fixed issue on iOS with `getAvailableAttributes` method

## 1.23.2
* Updated native Android SDK
* Updated native iOS SDK

## 1.23.1
* Updated native iOS SDK

## 1.23.0
* Implemented `setAppBannerShownHandler` and `setAppBannerOpenedHandler`

## 1.22.4
* Updated native Android SDK

## 1.22.3
* Updated native iOS + Android SDKs

## 1.22.2
* Updated native iOS + Android SDKs

## 1.22.1
* Updated native iOS + Android SDKs

## 1.22.0
* Updated native iOS + Android SDKs

## 1.21.8
* Updated native Android SDK

## 1.21.7
* Updated native Android SDK

## 1.21.6
* Updated native iOS + Android SDKs

## 1.21.5
* Updated native iOS + Android SDKs

## 1.21.4
* Updated native iOS + Android SDKs

## 1.21.3
* Fixed `chatNotification` flag support for Android

## 1.21.2
* Added `chatNotification` flag support for Android
* Updated native iOS + Android SDKs

## 1.21.1
* Fixed `trackEvent` for Android and support `properties` argument

## 1.21.0
* Upgrade native iOS + Android SDKs

## 1.20.5
* Make `handleNotificationReceived` behaviour same for Android + iOS.

## 1.20.4
* Fixed `setShowNotificationsInForeground` for Android

## 1.20.3
* Resolve future for `showTopicsDialog` after user has seen the dialog.

## 1.20.2
* Hotfix for Android build

## 1.20.1
* Updated Android SDK version
* Added `getDeviceToken` method

## 1.20.0
* Added `areNotificationsEnabled` method
* Updated iOS & Android SDK version

## 1.19.2
* Updated Android SDK version

## 1.19.1
* Fixed issue with `subscribe` activity on Android

## 1.19.0
* Improved return values for `subscribe` and implemented new method `getSubscriptionId`

## 1.18.1
* Added new arguments to methods `trackEvent` and `triggerFollowUpEvent`

## 1.18.0
* Added new methods: `setSubscriptionLanguage`, `setSubscriptionCountry`, `trackEvent`, `triggerFollowUpEvent`
* Updated Android & iOS SDK version

## 1.17.9
* Updated Android SDK version

## 1.17.8
* Updated Android SDK version

## 1.17.7
* Updated Android SDK version

## 1.17.6
* Updated Android SDK version

## 1.17.5
* Updated iOS SDK version
* Implemented `trackPageView` method for automatically assigning tags

## 1.17.4
* Fixed iOS SDK version

## 1.17.3
* Updated Android SDK to fix potential App Banner crash

## 1.17.2
* Updated iOS SDK

* ## 1.17.1
* Updated iOS SDK

## 1.17.0
* Android 13 support

## 1.16.1
* Updated Android SDK

## 1.16.0
* Implemented `setLogListener`

## 1.15.4
* Updated Android & iOS SDKs

## 1.15.3
* Implemented `setBrandingColor` and `setChatUrlOpenedHandler`

## 1.15.2
* Updated Android SDK

## 1.15.1
* Updated Android SDK and fixed App Banner display bug

## 1.15.0
* Added CleverPush chat view

## 1.14.0
* Updated Android + iOS SDKs

## 1.13.0
* Implemented Tracking Consent methods

## 1.12.3
* Fixed `setShowNotificationsInForeground` and Notification Opened Handler for iOS

## 1.12.2
* Implemented `setShowNotificationsInForeground` for iOS

## 1.12.1
* Implemented `setShowNotificationsInForeground` for Android

## 1.12.0
* Added Tags & Attributes methods

## 1.11.1
* iOS: Updated native SDK

## 1.11.0
* iOS: Updated native SDK

## 1.10.2
* iOS: Fixed crash in `getNotifications` method

## 1.10.1
* Android: Updated to latest native SDK

## 1.10.0
* Android: Updated to latest native SDK which includes a fix for Android 12

## 1.9.7
* Android: Added Handler instead of `runInUiThread` to prevent a crash when we do not get an Activity context from Flutter

## 1.9.6
* Android: Updated native SDK

## 1.9.5
* iOS: Updated native SDK
* Android: Updated native SDK

## 1.9.4
* iOS: Updated native SDK

## 1.9.3
* iOS: Updated native SDK

## 1.9.2
* Android: Fixed final argument error in getAvailableTopics

## 1.9.1
* Added nullability checks in example
* Fixed Notification Opened Handler on iOS when app was killed

## 1.9.0
* Added new Method: getNotifications
* Added new Method: getSubscriptionTopics
* Added new Method: setSubscriptionTopics
* Added new Method: getAvailableTopics

## 1.8.2
* Fixed handleSubscribed handler for iOS

## 1.8.1
* Updated to latest iOS SDK
* Updated to latest Android SDK

## 1.8.0
* Support for sound null safety

## 1.7.0
* Fixed issue with Notification handlers on iOS
* Updated to latest iOS SDK
* Updated to latest Android SDK

## 1.6.1
* Updated to latest Android SDK

## 1.6.0
* Fixed Subscribed Handler for Android and updated example project

## 1.5.4
* Updated to latest Android SDK

## 1.5.3
* Updated to latest Android SDK

## 1.5.2
* Updated to latest Android SDK

## 1.5.1
* Updated to latest Android SDK

## 1.5.0
* Updated to latest iOS & Android SDK

## 1.4.0
* Updated to latest iOS & Android SDK

## 1.3.3
* Updated to latest Android SDK

## 1.3.2
* Updated to latest Android SDK

## 1.3.1
* Updated to latest Android SDK
* Fixed Topics Dialog theme

## 1.3.0
* Updated to latest Android + iOS SDKs

## 1.2.1
* Fix showTopicsDialog

## 1.2.1
* Show notification when app is in foreground

## 1.2.0
* Fixed NotificationOpened/Received handlers on Android

## 1.1.1
* Several bug fixes
