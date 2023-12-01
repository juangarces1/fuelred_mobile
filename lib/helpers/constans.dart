import 'package:fuelred_mobile/providers/network_info.dart';

class Constans {
    static String get remoteAPI => 'http://200.91.130.215:9091'; 
    static String get apiUrl => 'http://192.168.1.3:9091'; 
    static String get localAPI => 'http://192.168.1.165:8081'; 
    static String get apiHacienda => 'https://api.hacienda.go.cr/fe/ae'; 
    static String  getAPIUrl () {
      return NetworkInfo().isLocal ? localAPI : remoteAPI;
    }

    static String imagenesUrlRemoto = 'http://200.91.130.215:9091/photos'; 
    static String imagenesUrlLocal = 'http://192.168.1.3:9091/photos';   
    // const String imagenesUrl = 'http://192.168.1.165:8081/photos'; 

    static String  getImagenesUrl () {
      return NetworkInfo().isLocal ? imagenesUrlLocal : imagenesUrlRemoto;
    }
}