import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/components/default_button.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:fuelred_mobile/modelsAdmin/SalesModels/Invent.dart';

class InventFormScreen extends StatefulWidget {
  const InventFormScreen({super.key});

  @override
  _InventFormScreenState createState() => _InventFormScreenState();
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
       appBar: AppBar(
          title:   const Row(
            children: [  
             SizedBox(
              height: 70,
              width: 210,
              child: Image(image: AssetImage('assets/LogoSinFondo.png')
              ,fit: BoxFit.contain,
             
              )) 
            ],
          ),
          actions: const [
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.account_circle), // Ícono de perfil de usuario
            ),
          ],
          elevation: 8,
          shadowColor: Colors.blueAccent,
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
                      Text("Complete el Formulario", style: headingStyle),  
                
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
            showLoader ? const LoaderComponent(text: 'Por favor espere...') : Container(),
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

    await 
     Fluttertoast.showToast(
            msg: "Inventario Actualizado Correctamente.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 20, 91, 22),
            textColor: Colors.white,
            fontSize: 16.0
          ); 
    

   
  }

}