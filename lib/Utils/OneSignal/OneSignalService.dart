import 'package:gkmarts/Utils/SharedPrefHelper/shared_local_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static const String oneSignalAppId = "7da1b882-fbed-4feb-a589-cf3cab38f6df";
  static Map<String, dynamic>? pendingNotificationData;
  static Future<void> init() async {
    // Initialize OneSignal
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(oneSignalAppId);

    // Ask for permission
    OneSignal.Notifications.requestPermission(true);

    await _waitForPlayerId();

    // ✅ Foreground notification handler (you cannot suppress notifications anymore via `.complete()`)
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      final title = event.notification.title;
      final body = event.notification.body;
      print("🔔 Foreground Notification - $title: $body");

     
    });

    // ✅ Notification tap/click listener
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      print("🔗 Notification Clicked! Extra: $data");

      // Store the data, navigate later
      pendingNotificationData = data;
    });
  }

  static Future<void> _waitForPlayerId() async {
    const int maxRetries = 10;
    const Duration retryInterval = Duration(seconds: 1);

    String? playerId;
    int attempts = 0;

    while (playerId == null && attempts < maxRetries) {
      await Future.delayed(retryInterval);
      playerId = OneSignal.User.pushSubscription.id;
      attempts++;
    }

    if (playerId != null) {
      print("✅ OneSignal Player ID: $playerId");
      await SharedPrefHelper.setOneSignalPlayerId(playerId);
    } else {
      print("⚠️ OneSignal Player ID not available after $maxRetries attempts.");
    }
  }
}



class NotificationType {
  static const String booking = "booking";
  static const String general = "notification";
}