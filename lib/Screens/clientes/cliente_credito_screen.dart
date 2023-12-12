
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/Admin/ComponentsShared/app_bar_custom.dart';
import 'package:fuelred_mobile/Screens/credito/credit_process_screen.dart';
import 'package:fuelred_mobile/Screens/manejoCierre/add_viatico_screen.dart';
import 'package:fuelred_mobile/Screens/peddler/peddlers_add_screen.dart';
import 'package:fuelred_mobile/components/client_card.dart';
import 'package:fuelred_mobile/components/color_button.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/clientecredito.dart';
import 'package:fuelred_mobile/models/response.dart';

import '../../components/custom_surfix_icon.dart';
import '../../models/cliente.dart';
import '../../sizeconfig.dart';

class ClientesCreditoScreen extends StatefulWidget {
  final AllFact factura;  
  final String ruta;


  // ignore: use_key_in_widget_constructors
  const ClientesCreditoScreen({   
    required this.factura,   
     required this.ruta,
   });
  @override
  State<ClientesCreditoScreen> createState() => _ClientesCreditoScreen();
}

class _ClientesCreditoScreen extends State<ClientesCreditoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showLoader = false;   
  var codigoController = TextEditingController();  
  String _codigoError = '';
  bool _codigoShowError = false;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kContrateFondoOscuro,
        appBar:  MyCustomAppBar(
          title: 'Cliente Credito',
          elevation: 6,
          shadowColor: kColorFondoOscuro,
          automaticallyImplyLeading: true,
          foreColor: Colors.white,
          backgroundColor: kPrimaryColor,
          actions: <Widget>[
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipOval(child:  Image.asset(
                  'assets/splash.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),), // Ícono de perfil de usuario
            ),
          ],      
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {     
    return Stack(
      children:  [ SizedBox(
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
      _showLoader ? const LoaderComponent(text: 'Cargando...',) : Container(),
      ],
    );
  }

  Widget signUpForm() {

     return Form(
      key: _formKey,
      child: Column(
        children: [
          showCodigo(),  
          const SizedBox(height: 10),        
          ColorButton(
            text: "Buscar",
            press: _getClient,
            ancho: 100,
            color: kPrimaryColor,
          ),

             SizedBox(height: SizeConfig.screenHeight * 0.04),

          widget.factura.formPago!.clientePaid.nombre.isEmpty ? Container() 
          : InkWell(
             onTap: _goBack,
            child: ClientCard(client: widget.factura.formPago!.clientePaid,)),
        
        ],
      ),
    );
  }
 
  Widget showCodigo() {
    return  Container(
           
           padding: const EdgeInsets.all(15),
           decoration: BoxDecoration(
             color: kContrateFondoOscuro,
             borderRadius: BorderRadius.circular(20)
           ),
          child: TextFormField( 
            maxLength: 4,       
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: InputDecoration(
              hintText: 'Ingresa el codigo',
              labelText: 'Codigo',
              errorText: _codigoShowError ? _codigoError : null,             
              suffixIcon: const CustomSurffixIcon(svgIcon: "assets/receipt.svg"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
            
            onChanged: (value) {
              codigoController.text = value;
            },
            validator: (value) {
                if (value == null || value.length != 4) {
                  return 'Introduce 4 dígitos';
                }
                return null;
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

    
    Response response = await ApiHelper.getClienteCredito(codigoController.text);  

    setState(() {
      _showLoader = false;
    });

    if(!response.isSuccess){  
     
      Fluttertoast.showToast(
          msg: "No se encontro el cliente.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );   
       
      return;
    }  

    ClienteCredito cliente = response.result;

    Cliente clientePaid = Cliente(
      nombre: cliente.nombre ??"",
      documento: cliente.documento??"",
      codigoTipoID: cliente.codigoTipoID?? "",
      email: cliente.email?? "",
      puntos: 0,
      codigo: cliente.codigo ?? '',
      tipo: cliente.tipo,
      telefono: '',
    );    
   
    setState(() {
      widget.factura.formPago!.clientePaid= clientePaid;
      widget.factura.placas=cliente.placas??[];
     
     
    }); 

  }

  void _goBack() async {
   if(widget.factura.formPago!.clientePaid.nombre ==""){
     await Fluttertoast.showToast(
          msg: "Debe buscar el cliente primero.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      return;
   }  

   if(widget.factura.formPago!.clientePaid.tipo == 'Peddler'){
   Navigator.pushReplacement(context,  
               MaterialPageRoute(
               builder: (context) => PeddlersAddScreen(
                  factura: widget.factura,                 
                 )
               ),
    );    
  }
  else{

      if(widget.ruta == 'Credito'){
      Navigator.pushReplacement(context,  
                  MaterialPageRoute(
                  builder: (context) => ProceeeCreditScreen(
                      factura: widget.factura,
                      
                    )
                  ),
        );    
      }
      else {
        Navigator.pushReplacement(context,  
                  MaterialPageRoute(
                  builder: (context) => AddViaticoScreen(
                      factura: widget.factura,
                      
                      
                    )
                  ),
        );    
      }
    }
  }
 
  bool _validateFields() {
    bool isValid = true;  

     if (codigoController.text.isEmpty){
        _codigoShowError=true;
        _codigoError="Debes Ingresar un Codigo";
        isValid=false;
    } else if (codigoController.text.length != 4 ) {      
      _codigoShowError = true;
      _codigoError = 'Debes ingresar un codigo de 4 carácteres.';
       isValid=false;
    } else {
      _codigoShowError=false;
    }  

    

    setState(() { });
    return isValid;
  }

}