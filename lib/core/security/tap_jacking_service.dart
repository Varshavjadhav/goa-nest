import 'package:flutter/services.dart';

class TapJackingService {
  static const MethodChannel _channel = MethodChannel('com.hindavigraphics.screen_protect');

  static void listen(Function onDetected) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "tapJackingDetected") {
        onDetected();
      }
    });
  }
}
