import 'package:fuelred_mobile/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fuelred_mobile/native_code_helper.dart';
import 'package:fuelred_mobile/providers/network_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NetworkInfo(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({ super.key });

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfLocal();
    });
  
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fuelred Mobile',

      theme: ThemeData(
        useMaterial3: true,
        

        ),
     
        
      home:  const LoginScreen(),
    );
  }

   void _checkIfLocal() async {
    String wifiName = await checkPermissionsAndGetWifiName(); // Asegúrate de que esta función maneje la asincronía correctamente
    WidgetsBinding.instance.addPostFrameCallback((_) {
       Provider.of<NetworkInfo>(context, listen: false).checkNetwork(wifiName);
    });
   
  }

  Future<String> checkPermissionsAndGetWifiName() async {
  var status = await Permission.location.status;
  if (status.isDenied) {
    // Los permisos no están concedidos, solicitarlos aquí.
    if (await Permission.location.request().isGranted) {
      // Los permisos fueron concedidos, llama a getWifiName.
      return await NativeCodeHelper.getWifiName();
    } else {
      // Manejar el caso cuando el usuario no concede los permisos.
      return '';
    }
  } else if (status.isGranted) {
    // Los permisos ya están concedidos.
     return await NativeCodeHelper.getWifiName();
  } else  { 
    return '';
  }
} 
}