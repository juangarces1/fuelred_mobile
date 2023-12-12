import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/cart/cart_new.dart';
import 'package:fuelred_mobile/Screens/cart/components/custom_appBar_cart.dart';
import 'package:fuelred_mobile/Screens/credito/select_cliente_credito.dart';
import 'package:fuelred_mobile/Screens/home/home_screen.dart';
import 'package:fuelred_mobile/Screens/test_print/testprint.dart';
import 'package:fuelred_mobile/components/boton_flotante.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/cliente.dart';
import 'package:fuelred_mobile/models/factura.dart';
import 'package:fuelred_mobile/models/sinpe.dart';
import 'package:fuelred_mobile/models/transferencia.dart';
import 'package:intl/intl.dart';

import '../../components/default_button.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';


class ProceeeCreditScreen extends StatefulWidget {
  final AllFact factura;
  // ignore: use_key_in_widget_constructors
  const ProceeeCreditScreen({   
    required this.factura,   
   });
  @override
  State<ProceeeCreditScreen> createState() => _ProceeeCreditScreen();
}

class _ProceeeCreditScreen extends State<ProceeeCreditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showLoader = false;
  bool placaTypeIdShowError =false;
  String placaTypeIdError ='';
  String placa = ''; 
  var kms = TextEditingController();  
  var obser = TextEditingController(); 
  final String _codigoError = '';
  final bool _codigoShowError = false;
  TestPrint testPrint = TestPrint();
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:  PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child:  Center(
            child: CustomAppBarCart(                    
              factura: widget.factura,
              press: () => goCart(),
            ),
          ),
        ),
        body: _body(),
        floatingActionButton: FloatingButtonWithModal(factura: widget.factura,),
      ),
    );
  }

  Widget _body() {     
    return SafeArea(
      child: Stack(
        children: [ SizedBox(
            width: double.infinity,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    Text("Factura Credito", style: headingStyleKprimary),
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    SelectClienteCredito(factura: widget.factura, ruta: 'Credito',),
                    signUpForm(),  
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    showTotal(), 
                  ],
                ),
              ),
            ),
          ),
          _showLoader ? const LoaderComponent(text: 'Creando...') : Container(),
        ],
      ),
    );
  }
 
  Widget signUpForm() {
     return Form(
      key: _formKey,
      child: Column(
        children: [
         showkms(),         
         showPlaca(), 
         showObser(), 
        ],
      ),
    );
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

  Widget showPlaca() {
    return Container(
         padding: const EdgeInsets.all(10),
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
 
  Widget showkms() {
    return Container(
          padding: const EdgeInsets.all(10),
          child: TextField(           
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: InputDecoration(
              hintText: 'Ingresa los kms',
              labelText: 'Kms',
              errorText: _codigoShowError ? _codigoError : null,             
              suffixIcon: const Icon(Icons.car_repair_rounded),           
            ),
            onChanged: (value) {
              kms.text = value;
            },
          ),
        );
 }
 
  Widget showObser() {
    return Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: obser,      
            keyboardType: TextInputType.text,            
            decoration: const InputDecoration(             
              labelText: 'Observaciones',                         
              suffixIcon: Icon(Icons.sms_outlined), 
            
            ),
            
          ),
        );
 }

  Widget showTotal() {
 return SafeArea(
  child: Padding(
    padding:
        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
    child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(           
            
            TextSpan(
              
              text: "Total:\n",
              children: [
                TextSpan(
                  text: "¢${NumberFormat("###,000", "en_US").format(widget.factura.cart!.total.toInt())}",
                  style: const TextStyle(fontSize: 20, color: kPrimaryColor, ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(190),
            child: DefaultButton(
              text: "Credito",
              press: () => _goFact(),
            ),
          ),
        ],
      ),
    ),
  );
}

 Future<void> _goFact()  async{
    if(widget.factura.formPago!.clientePaid.nombre=='') {
      Fluttertoast.showToast(
            msg: "Seleccione un cliente.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
      
      return;
    }
 
    setState(() {
      _showLoader = true;
    });      
      if (kms.text=='') {
        kms.text='0';
      }
      Map<String, dynamic> request = 
      {
        'products': widget.factura.cart!.products.map((e) => e.toApiProducJson()).toList(),
        'idCierre' : widget.factura.cierreActivo!.cierreFinal.idcierre,
        'cedualaUsuario' : widget.factura.cierreActivo!.usuario.cedulaEmpleado.toString(),
        'cedulaClienteFactura' : widget.factura.clienteFactura!.documento,
        'totalEfectivo' : widget.factura.formPago!.totalEfectivo,        
        'totalBac' : widget.factura.formPago!.totalBac,
        'totalDav' : widget.factura.formPago!.totalDav,
        'totalBn' : widget.factura.formPago!.totalBn,
        'totalSctia' : widget.factura.formPago!.totalSctia,
        'totalDollars' : widget.factura.formPago!.totalDollars,
        'totalCheques' : widget.factura.formPago!.totalCheques,
        'totalCupones' : widget.factura.formPago!.totalCupones,
        'totalPuntos' : widget.factura.formPago!.totalPuntos,
        'totalTransfer' : widget.factura.formPago!.totalTransfer,
        'saldo' : widget.factura.formPago!.saldo,
        'clientePaid' : widget.factura.formPago!.clientePaid.toJson(),
        'Transferencia' : widget.factura.formPago!.transfer.toJson(),
        'kms':kms.text,
        'observaciones' :obser.text,
        'placa':placa     

      };
      Response response = await ApiHelper.post("Api/Facturacion/CreditFactura", request);  

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

     var decodedJson = jsonDecode(response.result);
       Factura resdocFactura = Factura.fromJson(decodedJson);   
       resdocFactura.usuario = '${widget.factura.cierreActivo!.usuario.nombre} ${widget.factura.cierreActivo!.usuario.apellido1}';
    
   
      resetFactura();
      // ask the user if wants to print the factura
       if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Factura Creada Exitosamente'),
                content:  const Text('Desea imprimir la factura?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Si'),
                    onPressed: () {
                      Navigator.of(context).pop();
                   //  Impresion.printFactura(resdocFactura, 'FACTURA', 'CREDITO');
                      testPrint.ptrintFactura(resdocFactura, 'FACTURA', 'CREDITO');
                      _goHomeSuccess();
                    },
                  ),
                  TextButton(
                    child: const Text('No'),
                    onPressed: () => _goHomeSuccess(),
                  ),
                ],
              );
            },
          );
        }        
  }

  void goCart() async {
    setState(() {
        widget.factura.formPago!.showTotal=false;
        widget.factura.formPago!.showFact=true;
    });
    
    Navigator.push(context,  
          MaterialPageRoute(
            builder: (context) => CartNew(
            factura: widget.factura,
            
            )
      )
    );    
  }

  Future<void> _goHomeSuccess() async {  
    Navigator.push(context,  
     MaterialPageRoute(
        builder: (context) => HomeScreen(
           factura: widget.factura,
         )
        )
      );        
    }

   resetFactura() {
    setState(() {
      widget.factura.cart!.products.clear();
      widget.factura.formPago!.totalBac=0;
      widget.factura.formPago!.totalBn=0;
      widget.factura.formPago!.totalCheques=0;
      widget.factura.formPago!.totalCupones=0;
      widget.factura.formPago!.totalDav=0;
      widget.factura.formPago!.totalDollars=0;
      widget.factura.formPago!.totalEfectivo=0;
      widget.factura.formPago!.totalPuntos=0;
      widget.factura.formPago!.totalSctia=0;
      widget.factura.formPago!.transfer.totalTransfer=0;
      widget.factura.formPago!.totalSinpe=0;
      widget.factura.formPago!.transfer= Transferencia(cliente: Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: ''), transfers: [], monto: 0, totalTransfer: 0);
      widget.factura.clienteFactura=Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: '');
      widget.factura.clientePuntos=Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: '');
      widget.factura.formPago!.clientePaid=Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: '');
      widget.factura.formPago!.sinpe = Sinpe(numFact: '', fecha: DateTime.now(), id: 0, idCierre: 0, activo: 0, monto: 0, nombreEmpleado: '', nota: '', numComprobante: '');
      widget.factura.setSaldo(); 
      
    });
  }

}