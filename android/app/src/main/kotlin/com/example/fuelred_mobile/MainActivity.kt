package com.example.fuelred_mobile

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.net.wifi.WifiManager
import android.content.Context

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.fuelred_mobile/nativecode"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getWifiName") {
                    val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                    val wifiInfo = wifiManager.connectionInfo
                    if (wifiInfo != null && wifiInfo.ssid != null) {
                        result.success(wifiInfo.ssid)
                    } else {
                        result.error("UNAVAILABLE", "Wifi name not available.", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}


