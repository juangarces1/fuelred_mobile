// En el archivo native_code_helper.dart
import 'package:flutter/services.dart';

class NativeCodeHelper {
  static const platform = MethodChannel('com.example.fuelred_mobile/nativecode');

  static Future<String> getWifiName() async {
    String wifiName = '';
    try {
      wifiName = await platform.invokeMethod('getWifiName');
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print("Error: ${e.message}");
    }
    
    return wifiName;
  }
}
