import 'package:flutter/material.dart';

class NetworkInfo with ChangeNotifier {
  static final NetworkInfo _instance = NetworkInfo._internal();
  factory NetworkInfo() => _instance;
  NetworkInfo._internal();

  bool _isLocal = false;

  bool get isLocal => _isLocal;

  void checkNetwork(String ssid) {
    //_isLocal = ssid == "AndroidWifi"; 
    _isLocal = ssid == "\"MAXIGARCES\"";
       
      

    // Reemplaza 'TuSSIDLocal' con el SSID de tu red local
    notifyListeners();
  }
}