
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/tickets/ticket_screen.dart';
import 'package:fuelred_mobile/components/client_card.dart';
import 'package:fuelred_mobile/components/color_button.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

import 'package:fuelred_mobile/models/response.dart';
import 'package:flutter/material.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:flutter/services.dart';
import '../../components/custom_surfix_icon.dart';
import '../../components/default_button.dart';
import '../../sizeconfig.dart';
import '../checkout/checkount.dart';

class ClientesFrecScreen extends StatefulWidget {
  final AllFact factura; 
  final String ruta;


  // ignore: use_key_in_widget_constructors
  const ClientesFrecScreen({   
    required this.factura,   
    required this.ruta,
   });
  @override
  State<ClientesFrecScreen> createState() => _ClientesFrecScreen();
}

class _ClientesFrecScreen extends State<ClientesFrecScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showLoader = false;  
 
 
  
  var docuemntController = TextEditingController();

  String _documentError = '';
  bool _documentShowError = false;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kColorFondoOscuro,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title:  const Text("Buscar Cliente Frecuente", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {     
    return Container(
      color: kColorFondoOscuro,
      child: SafeArea(
        child: Stack(
          children:[
            SizedBox(
            width: double.infinity,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                    // Text("Digite Codigo Cliente", style: headingStyle),                
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    signUpForm(),             
                    
                  ],
                ),
              ),
            ),
          ),
           _showLoader ? const LoaderComponent(text: 'Buscando...') : Container(),
          ]
        ),
      ),
    );
  }

  Widget signUpForm() {

     return Form(
      key: _formKey,
      child: Column(
        children: [
          showDocument(),   
          const SizedBox(height: 10),       
          ColorButton(
            text: "Buscar",
            press: _getClient,
            ancho: 100,
            color: kPrimaryColor,
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.04),

          widget.factura.formPago.clientePaid.nombre.isEmpty ? Container() 
          : ClientCard(client: widget.factura.formPago.clientePaid,),
        
                  
           widget.factura.formPago.clientePaid.nombre.isEmpty ? Container() 
          :  DefaultButton(text: 'Select',press: () => _goCheckOut())
         
        ],
      ),
    );
  }
 
  Widget showDocument() {
    return Container(
           
           padding: const EdgeInsets.all(15),
           decoration: BoxDecoration(
             color: kContrateFondoOscuro,
             borderRadius: BorderRadius.circular(20)
           ),
          child: TextField( 
            maxLength: 7,       
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: InputDecoration(
              hintText: 'Ingresa el codigo',
              labelText: 'Codigo Cliente',
              errorText: _documentShowError ? _documentError : null,             
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/receipt.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
            onChanged: (value) {
              docuemntController.text = value;
            },
          ),
        );
 }








  Future<void> _getClient() async {
   
    if(!_validateFields()) {
      return;
    }
    
    setState(() {
      _showLoader=true;
    });

    
    Response response = await ApiHelper.getClientFrec(docuemntController.text);  

    setState(() {
      _showLoader = false;
    });

    if(!response.isSuccess){  
     
      Fluttertoast.showToast(
          msg: "No Encontrado",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );   
       
      return;
    }      
   
    setState(() {
      widget.factura.formPago.clientePaid= response.result;
     
    }); 

  }
    
 

  bool _validateFields() {
    bool isValid = true;  

     if (docuemntController.text.isEmpty){
        _documentShowError=true;
        _documentError="Debes Ingresar un Documento";
        isValid=false;
    } else if (docuemntController.text.length != 7 ) {      
      _documentShowError = true;
      _documentError = 'Debes ingresar un codigo de 7 carácteres.';
       isValid=false;
    } else {
      _documentShowError=false;
    }  

    

    setState(() { });
    return isValid;
  }

 

  void _goCheckOut() async {
      if(widget.factura.formPago.clientePaid.nombre ==""){
     await  Fluttertoast.showToast(
          msg: "Seleccione el Cliente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      return;
   }  

   if (widget.ruta == "Contado"){
      Navigator.pushReplacement(context,  
               MaterialPageRoute(
               builder: (context) => CheaOutScreen(
                  factura: widget.factura,
                 
                 )
               ),
    );  
   }
   else {
    Navigator.pushReplacement(context,  
               MaterialPageRoute(
               builder: (context) => TicketScreen(
                  factura: widget.factura,
                 
                 )
               ),
    );  

   }

    
  }
}