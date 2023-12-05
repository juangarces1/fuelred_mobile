import 'package:flutter/material.dart';
import 'package:fuelred_mobile/Screens/Admin/ComponentsShared/app_bar_custom.dart';
import 'package:fuelred_mobile/components/default_button.dart';
import 'package:fuelred_mobile/components/my_loader.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:fuelred_mobile/modelsAdmin/SalesModels/Invent.dart';

class InventFormScreen extends StatefulWidget {
  const InventFormScreen({super.key});

  @override
  State<InventFormScreen> createState() => _InventFormScreenState();
}

class _InventFormScreenState extends State<InventFormScreen> {
   final _formKey = GlobalKey<FormState>();
  double invDiesel = 0.0;
  double invExonerado = 0.0;
  double invRegular = 0.0;
  double invSuper = 0.0;
  DateTime fecha = DateTime.now(); 
  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       appBar:  MyCustomAppBar(
        title: 'Actualizar Inventario',
        automaticallyImplyLeading: true,   
        backgroundColor: kBlueColorLogo,
        elevation: 8.0,
        shadowColor: Colors.blueGrey,
        foreColor: Colors.white,
         actions: [ Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipOval(child:  Image.asset(
                  'assets/splash.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),), // Ícono de perfil de usuario
            ),],
      ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text("Inventario Actual", style: myHeadingStyleBlack),  
                
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Diesel '),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          invDiesel = double.tryParse(value) ?? 0.0;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por Favor Ingrese un Volumen.';
                          }
                          return null;
                        },
                      ),
                    
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Regular '),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          invRegular = double.tryParse(value) ?? 0.0;
                        },
                         validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por Favor Ingrese un Volumen.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Super '),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          invSuper = double.tryParse(value) ?? 0.0;
                        },
                         validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por Favor Ingrese un Volumen.';
                          }
                          return null;
                        },
                      ),
                        TextFormField(
                        decoration: const InputDecoration(labelText: 'Exonerado '),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          invExonerado = double.tryParse(value) ?? 0.0;
                        },
                         validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por Favor Ingrese un Volumen.';
                          }
                          return null;
                        },
                      ),
                     
                      const SizedBox(height: 10,),
                      DefaultButton(
                        text: "Crear",
                        press: () {
                          if (_formKey.currentState!.validate()) {
                            // Save the data
                            _addInvent();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            showLoader ?  const CustomActivityIndicator(loadingText: 'Por favor espere...') : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> _addInvent() async {
    setState(() {
      showLoader = true;
    });    

    Invent invent = Invent(
      invDiesel: invDiesel,
      invExonerado: invExonerado,
      invRegular: invRegular,
      invSuper: invSuper,
      fecha: fecha,
      id: 0,
    );

  
   
   Map<String, dynamic> request1 = invent.toJson();

    

    Response response = await ApiHelper.post(
      'api/Sales/PostInvent',
      request1,
    );

    setState(() {
      showLoader = false;
    });

    if (!response.isSuccess) {
        if (mounted) {       
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content:  Text(response.message),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }  
       return;
     }
  }
}