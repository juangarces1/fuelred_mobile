import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/cart/cart_new.dart';
import 'package:fuelred_mobile/components/color_button.dart';
import 'package:fuelred_mobile/components/form_pago.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../constans.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';
import '../clientes/cliente_frec_screen.dart';
import '../login_screen.dart';

// ignore: must_be_immutable
class TicketScreen extends StatefulWidget {
  final AllFact factura; 
   // ignore: use_key_in_widget_constructors
  const TicketScreen({ 
    required this.factura,   
  }); 

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {  
  bool _showLoader =false;
  bool medioShowError = false;
  String mediodError ='';
  var obser = TextEditingController();
  double _saldo = 0; 

  @override
  void initState() {
    super.initState();
    _saldo = widget.factura.formPago.saldo;   
  } 
   
   @override
   Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: appBar1(),
        ),
        body: SafeArea(
          child: Container(
            color: kColorFondoOscuro,
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[  
                     _showClientPoint(),                     
                     FormPago(
                      factura: widget.factura,
                      fontColor: Colors.green,
                      onSaldoChanged:  _updateSaldo,
                      ruta: 'Ticket',
                    ),                                  
                       const SizedBox(height: 5,), 
                       signUpForm(), 
                    ],
                  ),
                ),     
                _showLoader ? const LoaderComponent(text: "Creando Ticket...") : Container(),     
              ],
            ),
          ),
        )
      ),
    );    
  }
  

  Future<void> goTicket() async {
    
    if(widget.factura.formPago.saldo!=0) {
      Fluttertoast.showToast(
            msg: "La factura aun tiene saldo.",
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
      
    Map<String, dynamic> request = 
    {
      'products': widget.factura.cart.products.map((e) => e.toApiProducJson()).toList(),
      'idCierre' : widget.factura.cierreActivo.cierreFinal.idcierre,
      'cedualaUsuario' : widget.factura.cierreActivo.usuario.cedulaEmpleado.toString(),
      'cedulaClienteFactura' : widget.factura.clienteFactura.documento,
      'totalEfectivo' : widget.factura.formPago.totalEfectivo,        
      'totalBac' : widget.factura.formPago.totalBac,
      'totalDav' : widget.factura.formPago.totalDav,
      'totalBn' : widget.factura.formPago.totalBn,
      'totalSctia' : widget.factura.formPago.totalSctia,
      'totalDollars' : widget.factura.formPago.totalDollars,
      'totalCheques' : widget.factura.formPago.totalCheques,
      'totalCupones' : widget.factura.formPago.totalCupones,
      'totalPuntos' : widget.factura.formPago.totalPuntos,
      'totalTransfer' : widget.factura.formPago.totalTransfer,
      'saldo' : widget.factura.formPago.saldo,
      'clientePaid' : widget.factura.formPago.clientePaid.toJson(),
      'Transferencia' : widget.factura.formPago.transfer.toJson(),
      'observaciones' : obser.text.isEmpty ? '' : obser.text,
      'ticketMedioPago': 'Efectivo',
      'placa':'',      

    };
    Response response = await ApiHelper.post("Api/Facturacion/Ticket", request);  

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
     Fluttertoast.showToast(
            msg: "Ticket Creado Correctamente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 20, 91, 22),
            textColor: Colors.white,
            fontSize: 16.0
          ); 
     
    Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen())
        );
    });  //  
  }

  Widget _showClientPoint() {
    return
    InkWell(
      onTap: () => Navigator.push(context,  MaterialPageRoute(
                    builder: (context) => ClientesFrecScreen(
                      factura: widget.factura,                     
                      ruta: 'Ticket',
                    )
                    )),
      child: Container(
        color: kColorFondoOscuro,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [                   
              Container(
                padding: const EdgeInsets.all(10),
                height: getProportionateScreenWidth(50),
                width: getProportionateScreenWidth(50),
                decoration: BoxDecoration(
                  color: kContrateFondoOscuro,
                  borderRadius: BorderRadius.circular(10),
                ),
                // ignore: deprecated_member_use
                child: SvgPicture.asset("assets/User Icon.svg", color:  widget.factura.formPago.clientePaid.nombre == "" ? kTextColor : kPrimaryColor,),
              ),
              const SizedBox(width: 10,),               
              Expanded(
                child: Text(
                  widget.factura.formPago.clientePaid.nombre == "" 
                  ? 'Seleccione Cliente Frecuente' 
                  : '${widget.factura.formPago.clientePaid.nombre}(${widget.factura.formPago.clientePaid.puntos})',               
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                     color:Colors.white,
                  )),
              ),
             
              
            ],
          ),
        ),
      ),
    );     
  }
 
  Widget appBar1() {
   return SafeArea(    
      child: Container(
        color: const Color.fromARGB(255, 219, 222, 224),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row( 
            mainAxisAlignment: MainAxisAlignment.spaceBetween,         
            children: [
              SizedBox(
                height: getProportionateScreenHeight(45),
                width: getProportionateScreenWidth(45),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(     
                      borderRadius: BorderRadius.circular(60),
                    ),
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => _goCart(),      
                  child: SvgPicture.asset(
                    "assets/Back ICon.svg",
                    height: 15,
                    // ignore: deprecated_member_use
                    color: kPrimaryColor,
                  ),
                ),
              ),
               const SizedBox(width: 10,),
              const Text('Ticket', style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),),
               const Spacer(),
              Container(               
                padding: const EdgeInsets.only(top: 8, right: 5),
                decoration: BoxDecoration(                 
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                   mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Total:${NumberFormat("###,000", "en_US").format(widget.factura.cart.total.toInt())}",
                      style: const TextStyle(
                        color: kTextColorBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      "Saldo:${NumberFormat("###,000", "en_US").format(_saldo)}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),                 
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
 } 

  Future<void> _goCart() async {
   setState(() {
     widget.factura.formPago.showTotal=false;
     widget.factura.formPago.showFact=true;
   });
    Navigator.push(context,  
        MaterialPageRoute(
          builder: (context) => CartNew(
          factura: widget.factura,
           
          )
    )
  );        
 }
 
  Widget showObser() {
    return Container(
           padding: const EdgeInsets.only(left: 50.0, right: 50),
          child: TextField(
            controller: obser,      
            keyboardType: TextInputType.text,            
            decoration: const InputDecoration(             
              labelText: 'Observaciones', 
                hintText: 'Ingrese las Observaciones',                        
              suffixIcon:  Icon(Icons.sms_outlined), 
            
            ),
            
          ),
        );
 }

  Widget signUpForm() {
     return Container( 
        padding: const EdgeInsets.only(top: 15),            
       decoration: BoxDecoration(
          color: const Color.fromARGB(255, 235, 230, 236),
           gradient: const LinearGradient(
             colors: [Colors.green, Color.fromARGB(255, 255, 255, 255)],
             begin: Alignment.centerRight,
             end:  Alignment(0.9, 0.0),
             tileMode: TileMode.clamp),
         border: Border.all(
         color: kSecondaryColor,
                     width: 1,
         ),
       ),
       child: Column(
         children: [
            const Text(
           'Información Ticket',
           style: TextStyle(
             color: kBlueColorLogo,
             fontWeight: FontWeight.bold,
             fontSize: 18,
           ),
        ),
          
           showObser(), 
           const SizedBox(height: 15,), 
           Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50, bottom: 15),
            child: ColorButton(
            text: "Ticket",
            press: () => goTicket(), 
            color: Colors.green,
            ancho: 90,             
            ),
          ),  
         ],
       ),
     );
  }
 
 void _updateSaldo(double nuevoSaldo)  {
    setState(() {
      _saldo = nuevoSaldo;
    });
  }  
}