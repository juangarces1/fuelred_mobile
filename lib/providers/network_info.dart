import 'package:flutter/material.dart';

class NetworkInfo with ChangeNotifier {
  static final NetworkInfo _instance = NetworkInfo._internal();
  factory NetworkInfo() => _instance;
  NetworkInfo._internal();

  bool _isLocal = false;

  bool get isLocal => _isLocal;

  void checkNetwork(String ssid) {
    //_isLocal = ssid == "AndroidWifi"; 

    if (ssid == "\"MAXIGARCES_PLUS\"" || ssid == "\"AndroidWifi\"") {
      _isLocal = true;
    } else {
      _isLocal = false;
    }
    //_isLocal = ssid == "\"MAXIGARCES_PLUS\"";
       
      

    // Reemplaza 'TuSSIDLocal' con el SSID de tu red local
    notifyListeners();
  }
}