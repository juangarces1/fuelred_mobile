
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/manejoCierre/viaticos_screen.dart';
import 'package:fuelred_mobile/components/default_button.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

import 'package:fuelred_mobile/models/cliente.dart';
import 'package:fuelred_mobile/models/viatico.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/loader_component.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';
import '../clientes/cliente_credito_screen.dart';

class AddViaticoScreen extends StatefulWidget {
final AllFact factura;


  // ignore: use_key_in_widget_constructors
  const AddViaticoScreen({ required this.factura});

  @override
  State<AddViaticoScreen> createState() => _AddViaticoScreenState();
}

class _AddViaticoScreenState extends State<AddViaticoScreen> {
  bool _showLoader = false;
  String monto = '';  
  String lote = '';  
  String montoError = '';
  bool montoShowError = false;
  String loteError = '';
  bool loteShowError = false;
  TextEditingController montoController = TextEditingController();
  TextEditingController loteController = TextEditingController();
  String datafonoNombre = '';
  String bancoTypeIdError = '';
  bool bancoTypeIdShowError = false;
  List<Viatico> viaticos = []; 

   bool placaTypeIdShowError =false;
  String placaTypeIdError ='';
  String placa = ''; 

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Nuevo Viatico', style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        color: kContrateFondoOscuro,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
              
                   SizedBox(height: SizeConfig.screenHeight * 0.04), 
                 showClient(),
                      SizedBox(height: SizeConfig.screenHeight * 0.04), 
                 showPlaca(),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                 _showMonto(),           
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  SizedBox(
                        width: getProportionateScreenWidth(190),
                        child: DefaultButton(
                          text: "Crear",
                          press: () => _goViatico(),
                        ),
                      ),
                ],
              ),
            ),
            _showLoader
                ? const LoaderComponent(
                    text: 'Por favor espere...',
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

   _goClientCredit() {
       Navigator.push
       (context,
           MaterialPageRoute(
             builder: (context) =>
               ClientesCreditoScreen(
                 factura: widget.factura,
                  
                  ruta: 'Viatico',)
            )
        ); 
  }

    Widget showClient() {
    return 
      Padding(
        padding: const EdgeInsets.only(left: 30 , right: 30),
        child: Row(
          children: [                   
            InkWell(
              onTap: () => _goClientCredit(),
              child: Container(
                padding: const EdgeInsets.all(10),
                height: getProportionateScreenWidth(40),
                width: getProportionateScreenWidth(40),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(10),
                ),
              child: SvgPicture.asset(
                "assets/User Icon.svg", 
                // ignore: deprecated_member_use
                color:  widget.factura.formPago.clientePaid.nombre == '' ? kTextColor 
                : kPrimaryColor,),
              ),
            ),
            const Spacer(),               
            Text(widget.factura.formPago.clientePaid.nombre == "" ? "Seleccione Un Cliente": widget.factura.formPago.clientePaid.nombre),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: kTextColor,
            )
          ],
        ),
      );
 }

  Widget showPlaca() {
    return Container(
         padding: const EdgeInsets.only(left: 30 , right: 30),
        child: DropdownButtonFormField(
                items: _getComboPlacas(),                
                value: placa,                
                onChanged: (option) {
                  setState(() {
                    placa = option as String;                   
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Seleccione una Placa...',
                  labelText: 'Placas',
                  errorText:
                      placaTypeIdShowError ? placaTypeIdError : null,
                 
                ),
                
              ));
  }

  List<DropdownMenuItem<String>> _getComboPlacas() {
    List<DropdownMenuItem<String>> list = [];

    list.add(const DropdownMenuItem(
      value: '',
      child: Text('Seleccione una Placa...'),
    ));

    for (var placa in widget.factura.placas) {
      list.add(DropdownMenuItem(
        value: placa.toString(),
        child: Text(placa.toString()),
      ));
    }

    return list;
  }


 
   Widget _showMonto() {
    return Container(
         padding: const EdgeInsets.only(left: 30 , right: 30),
      child: TextField(
        controller: montoController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Ingresa el Monto...',
          labelText: 'Monto',
          errorText: montoShowError ? montoError : null,
          suffixIcon: const Icon(Icons.attach_money_rounded),
         
        ),
        onChanged: (value) {
          monto =  value;
        },
      ),
    );
  }



  void _goViatico() async {
    if (!_validateFields()) {
      return;
    }

    _addViatico();
  }

  bool _validateFields() {
    bool isValid = true;

    if (monto.isEmpty) {
      isValid = false;
      montoShowError = true;
      montoError = 'Debes ingresar el monto.';
    } else {
      montoShowError = false;
    }   

   

    if (placa.isEmpty) {
      isValid = false;
      placaTypeIdShowError = true;
      placaTypeIdError = 'Debes seleccionar una Placa.';
    } else {
      bancoTypeIdShowError = false;
    }

    setState(() {});
    return isValid;
  }

  void _addViatico() async {
    
   
   if  (_validateFields()==false){
    
      return;

   }
   

    
    setState(() {
      _showLoader = true;
    });    
   

 
    

    Viatico viatico =  Viatico(idviatico: 0,
     monto: int.parse(monto),
     fecha: "2023-07-11T00:00:00",
     cedulaempleado:  widget.factura.cierreActivo.usuario.cedulaEmpleado,     
     idcierre: widget.factura.cierreActivo.cierreFinal.idcierre,
      idcliente:int.parse( widget.factura.formPago.clientePaid.codigo),
      placa: placa,
      estado: 'PENDIENTE',  





     );
   
   Map<String, dynamic> request = viatico.toJson();

    

    Response response = await ApiHelper.post(
      'api/Viaticos/',
      request,
    );

    setState(() {
      _showLoader = false;
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

    widget.factura.formPago.clientePaid= Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos:0, codigo: '',telefono: '');

    Fluttertoast.showToast(
            msg: "Viatico Creado Correctamente.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 20, 91, 22),
            textColor: Colors.white,
            fontSize: 16.0
          ); 
   

     // ignore: use_build_context_synchronously
     Navigator.pushReplacement(context,
                      MaterialPageRoute(
                          builder: (context) =>  ViaticosScreen(factura: widget.factura))
        );  
  }


}