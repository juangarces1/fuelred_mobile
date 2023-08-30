import 'package:fuelred_mobile/Screens/login_screen.dart';
import 'package:flutter/material.dart';
void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
   
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

 
}