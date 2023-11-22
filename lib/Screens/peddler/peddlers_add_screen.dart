import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuelred_mobile/Screens/cart/cart_new.dart';
import 'package:fuelred_mobile/Screens/credito/select_cliente_credito.dart';
import 'package:fuelred_mobile/Screens/home/home_screen.dart';
import 'package:fuelred_mobile/clases/impresion.dart';
import 'package:fuelred_mobile/components/boton_flotante.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/cliente.dart';
import 'package:fuelred_mobile/models/peddler.dart';
import 'package:fuelred_mobile/models/sinpe.dart';
import 'package:fuelred_mobile/models/transferencia.dart';
import 'package:intl/intl.dart';

import '../../components/default_button.dart';
import '../../components/loader_component.dart';
import '../../constans.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';
import '../cart/components/custom_appBar_cart.dart';


class PeddlersAddScreen extends StatefulWidget {
  final AllFact factura;
 
  // ignore: use_key_in_widget_constructors
  const PeddlersAddScreen({   
    required this.factura,
   
    
   });

  @override
  State<PeddlersAddScreen> createState() => _PeddlersAddScreenState();
}

class _PeddlersAddScreenState extends State<PeddlersAddScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showLoader = false; 
  bool placaTypeIdShowError =false;
  var placaTypeIdError ='';
  String placa = ''; 
  var kms = TextEditingController();  
  var obser = TextEditingController();  
  var ch = TextEditingController();  
  var or = TextEditingController();
  bool chShowError=false;
  String chError="";
  bool obserShowError=false;
  String obserError="";
  bool orShowError=false;
  String orError="";
  bool kmShowError=false;
  String kmError="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child:  CustomAppBarCart(                 
          factura: widget.factura,
          press: () => goCart(),
        ),
      ),
      body: _body(),
      floatingActionButton: FloatingButtonWithModal(factura: widget.factura,)
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
                    // SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                    // Text("Digite Codigo Cliente", style: headingStyle),                
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    Text("Peddlers", style: headingStyle),
                         
                          
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

   void goCart() async {
    Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) =>  CartNew(factura: widget.factura, ))
    );
  }

  Widget signUpForm() {
     return Form(
      key: _formKey,
      child: Column(
        children: [
          SelectClienteCredito(factura: widget.factura, ruta: 'Credito'),
          showPlaca(), 
          showkms(),   
          showOrden(),
          showChofer(), 
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

  

  bool _validateFields() {
    bool isValid = true;  

    if (ch.text.isEmpty)
    {
        chShowError=true;
        chError="Debes Ingresar el nombre";
        isValid=false;        
    } 
     else {
      chShowError=false;
    }  
    
    if (kms.text.isEmpty)
    {
        kmShowError=true;
        kmError="Debes Ingresar el kilometraje";
        isValid=false;        
    } 
     else {
      kmShowError=false;
    } 

    if (or.text.isEmpty)
    {
        orShowError=true;
        orError="Debes Ingresar el numero de orden";
        isValid=false;        
    } 
     else {
      orShowError=false;
    } 


    if (placa.isEmpty)
    {
        placaTypeIdShowError=true;
        placaTypeIdError="Debes Seleccionar la placa";
        isValid=false;        
    } 
     else {
      placaTypeIdShowError=false;
    }  
   
    setState(() { });
    return isValid;
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
                  errorText: placaTypeIdShowError ? placaTypeIdError : null,
                 
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
              errorText: kmShowError ? kmError : null,             
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
            decoration:  InputDecoration(  
              hintText: 'Ingresa las Observaciones...',           
              labelText: 'Observaciones',         
              errorText: obserShowError ? obserError : null,                
              suffixIcon: const Icon(Icons.sms_outlined), 
           
            ),
            
          ),
        );
 }

  Widget showChofer() {
  return Container(
    padding: const EdgeInsets.all(10),
    child: TextField(
      controller: ch,      
      keyboardType: TextInputType.text,            
      decoration:  InputDecoration(  
        hintText: 'Ingresa el nombre...',           
        labelText: 'Chofer',         
        errorText: chShowError ? chError : null,                
        suffixIcon: const Icon(Icons.traffic_outlined,
      
      ),
      )  
    ),
  );
 }

  Widget showOrden() {
  return Container(
    padding: const EdgeInsets.all(10),
    child: TextField(
      controller: or,      
      keyboardType: TextInputType.text,            
      decoration:  InputDecoration(  
        hintText: 'Ingresa el numero...',           
        labelText: 'Orden',         
        errorText: orShowError ? orError : null,                
        suffixIcon: const Icon(Icons.numbers_outlined),
      
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
                  text: "\$${NumberFormat("###,000", "en_US").format(widget.factura.cart.total.toInt())}",
                  style: const TextStyle(fontSize: 20, color: kPrimaryColor, ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(190),
            child: DefaultButton(
              text: "Crear Peddler",
              press: () => _goPeddler(),
            ),
          ),
        ],
      ),
    ),
  );
}

  Future<void> _goPeddler() async{
    if(!_validateFields()){
      return;
    }
    setState(() {
      _showLoader=true;
    });

    Peddler request = Peddler(              
      chofer: ch.text,
      cliente: widget.factura.formPago.clientePaid,                      
      fecha: DateTime.now().toString(),
      id: 0,
      idcierre: widget.factura.cierreActivo.cierreFinal.idcierre,                       
      km: kms.text,                       
      observaciones: obser.text,
      orden: or.text,
      placa: placa,                       
      products:  widget.factura.cart.products,
      pistero: widget.factura.cierreActivo.usuario,
    );

    Response response = await ApiHelper.post('Api/Peddler/PostPeddler', request.toJson());
    
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
    resetFactura();
    // ask the user if wants to print the factura
    if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Peddler Creado Exitosamente'),
              content:  const Text('Desea imprimir el Peddler?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Si'),
                  onPressed: () {
                    Navigator.of(context).pop();
                   
                    Impresion.printPeddler(request, context);
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
      widget.factura.cart.products.clear();
      widget.factura.formPago.totalBac=0;
      widget.factura.formPago.totalBn=0;
      widget.factura.formPago.totalCheques=0;
      widget.factura.formPago.totalCupones=0;
      widget.factura.formPago.totalDav=0;
      widget.factura.formPago.totalDollars=0;
      widget.factura.formPago.totalEfectivo=0;
      widget.factura.formPago.totalPuntos=0;
      widget.factura.formPago.totalSctia=0;
      widget.factura.formPago.transfer.totalTransfer=0;
      widget.factura.formPago.totalSinpe=0;
      widget.factura.formPago.transfer= Transferencia(cliente: Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: ''), transfers: [], monto: 0, totalTransfer: 0);
      widget.factura.clienteFactura=Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: '');
      widget.factura.clientePuntos=Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: '');
      widget.factura.formPago.clientePaid=Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: '');
      widget.factura.formPago.sinpe = Sinpe(numFact: '', fecha: DateTime.now(), id: 0, idCierre: 0, activo: 0, monto: 0, nombreEmpleado: '', nota: '', numComprobante: '');
      widget.factura.setSaldo(); 
      
    });
  }

}
