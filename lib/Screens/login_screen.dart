import 'package:flutter/material.dart';
import 'package:fuelred_mobile/Screens/Admin/HomeAdmin/dashboard_screen.dart';
import 'package:fuelred_mobile/components/my_loader.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/cart.dart';
import 'package:fuelred_mobile/models/cliente.dart';
import 'package:fuelred_mobile/models/empleado.dart';
import 'package:fuelred_mobile/models/paid.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:fuelred_mobile/models/sinpe.dart';
import 'package:fuelred_mobile/models/transferencia.dart';
import 'package:fuelred_mobile/sizeconfig.dart';

import 'home/home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({ super.key });

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String _zona = '';
  String _zonaError = '';
  bool _zonaShowError = false;

  String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;

 // bool _rememberme = true;
  bool _passwordShow = false;
  bool _showLoader = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double con1 = MediaQuery.of(context).size.height / 2;
    double con2 = MediaQuery.of(context).size.height / 6;
    return  Scaffold(
      body: Stack(          
          children: <Widget>[
            Container(             
            color: kBlueColorLogo,
           ),
           Container( 
            height: con1,
            color: kPrimaryColor,
           ),
          
          ListView(            
            children:  <Widget>[
            SizedBox(height: con2,),
              _showLogo(),
           const SizedBox(height: 20,),
           Padding(
             padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
             child: Container(
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(20),
                 boxShadow: const [ BoxShadow(
                   color: kPrimaryColor,
                   blurRadius: 10,
                   offset: Offset(0,5)
       
                 )]
               ),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                     padding: const EdgeInsets.all(10),
                     child: const Text('FuelRed', style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 25,
                       color: kPrimaryColor,
                     ),),
                   ),
                  
                 _showZona(),
                  const SizedBox(height: 5,),
                  _showPassword(),
                    const SizedBox(height: 30,),
                    InkWell(
                     onTap: () =>_login(),
                     child: Container(
                       decoration: const BoxDecoration(
                         color:kPrimaryColor,
                         borderRadius: BorderRadius.only(
                           bottomLeft: Radius.circular(20),
                           bottomRight: Radius.circular(20),
                         )
                       ),
                       child:  const Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Padding(padding: EdgeInsets.all(20),
                           child: Text('ENTRAR', style: TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                             color: Colors.white
                           ),),
                           ),
                        
                         ],

                       ),
                     ),
                    ),    
                    //make a button to print 
                   
                    
               ]),
             ),
           )
             ],
           )   ,
 
            _showLoader ?  const CustomActivityIndicator(loadingText: 'Cargando...',) : Container(),
          ],
        ),
    );
    
  }

  Widget _showLogo() {
    return  const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [ Image(
        image: AssetImage('assets/LogoLogin.png'),
        width: 130,
        fit: BoxFit.fill,
      ),
      ]
    );
  }

  Widget _showZona() {
    return Container(
       padding: const EdgeInsets.only(left: 50.0, right: 50),
       child: TextField(       
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
        //   enabledBorder: const OutlineInputBorder(
        //   //  borderSide:  BorderSide(color: kSecondaryColor, width: 1.0),
        //    borderRadius:  BorderRadius.all(Radius.circular(30.0))
        
        // ),
           
          hintText: 'Ingresa la Zona',
          labelText: 'Zona',
          errorText: _zonaShowError ? _zonaError : null,
          suffixIcon: const Icon(Icons.map_outlined),
         
        ),
        onChanged: (value) {
          _zona = value;
        },
      ),
    );
  }
 
  Widget _showPassword() {
    return Container(
      padding: const EdgeInsets.only(left: 50.0, right: 50),
      child: TextField(
        keyboardType: TextInputType.number,
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Ingrese la Cedula',
          labelText: 'Cedula',
          errorText: _passwordShowError ? _passwordError : null,        
          suffixIcon: IconButton(
            icon: _passwordShow ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            }, 
          ),          
          // enabledBorder: const OutlineInputBorder(
          //  borderSide:  BorderSide(color: kSecondaryColor, width: 1.0),
          //  borderRadius:  BorderRadius.all(Radius.circular(30.0))        
          // ),
        ),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  void _login() async {

    if(!_validateFields()) {
      return;
    }

    if(_zona.isEmpty){
      goLoginAdmin();
      return;
    }
    
    else {
      if (int.parse(_zona) < 1 || int.parse(_zona) > 2)
      {
          _zonaShowError=true;
          _zonaError="La zona debe estar entre 1 y 2.";
          return;
      }
      else{
        _zonaShowError=false;
      }
    }

    setState(() {
      _showLoader = true;
    });   
   
    Response response = await ApiHelper.getLogIn(int.parse(_zona), int.parse(_password));
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


    AllFact factura = response.result;
    factura.cart = Cart(products: [], numOfItem: 0);
    factura.clienteFactura = Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: '');
    factura.clientePuntos = Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: '');
    factura.formPago = Paid(
      totalEfectivo: 0,
      totalBac: 0, 
      totalDav: 0, 
      totalBn: 0, 
      totalSctia: 0, 
      totalDollars: 0, 
      totalCheques: 0, 
      totalCupones: 0, 
      totalPuntos: 0, 
      totalTransfer: 0, 
      saldo: 0, 
      clientePaid: Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: ''), 
      transfer: Transferencia(
        cliente: Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: ''),
        transfers: [],
        monto: 0,
        totalTransfer: 0
      ), 
      showTotal: false, 
      showFact: false, 
      totalSinpe: 0, 
      sinpe: Sinpe(
        id: 0, 
        numComprobante: '', 
        nota: '', 
        idCierre: 0, 
        nombreEmpleado: '', 
        fecha: DateTime.now(), 
        numFact: '', 
        activo: 0, 
        monto: 0
      ));
    factura.placa='';
    factura.kms=0;
    factura.observaciones='';
    factura.placas=[];
    factura.lasTr=0;
   
    //ordenamos las transacciones de mayor a menor y adjudicamos la ultima transaccion
    if(factura.transacciones.isNotEmpty){
     factura.transacciones.sort(((b, a) => a.transaccion.compareTo(b.transaccion)));
     factura.lasTr=factura.transacciones.first.transaccion;
    }    
    
    goHome(factura);
  }

  void goHome (AllFact factura) {  
     Navigator.pushReplacement(
       context, 
       MaterialPageRoute(
         builder: (context) => HomeScreen(factura: factura,
             )
       )
     );
  }

  bool _validateFields() {
    bool isValid = true;

    

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar tu contraseña.';
    } 
    else {
      _passwordShowError = false;
    }

    setState(() { });
    return isValid;
  }
  
  void goAdminMenu(Empleado empleado) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) =>  DashboardScreen(empleado: empleado,)
      )
    );
  }
  
  void goLoginAdmin() async {
    setState(() {
      _showLoader = true;
    });
    Response response = await ApiHelper.getLoginAdmin(_password);
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
    goAdminMenu(response.result);
  }
  
  
 

 



 
}