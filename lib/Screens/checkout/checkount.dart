import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/cart/cart_new.dart';
import 'package:fuelred_mobile/Screens/home/home_screen.dart';
import 'package:fuelred_mobile/Screens/test_print/testprint.dart';
import 'package:fuelred_mobile/components/boton_flotante.dart';
import 'package:fuelred_mobile/components/client_points.dart';
import 'package:fuelred_mobile/components/form_pago.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/components/show_client.dart';
import 'package:fuelred_mobile/helpers/factura_helper.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/factura.dart';
import 'package:fuelred_mobile/models/product.dart';
import 'package:intl/intl.dart';

import '../../components/default_button.dart';
import '../../constans.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';

// ignore: must_be_immutable
class CheaOutScreen extends StatefulWidget {
  final AllFact factura; 
  
  // ignore: use_key_in_widget_constructors
  const CheaOutScreen({ 
    required this.factura,   
  }); 

  @override
  State<CheaOutScreen> createState() => _CheaOutScreenState();
}

class _CheaOutScreenState extends State<CheaOutScreen> { 
  
  bool _showLoader = false;
  var kms = TextEditingController();
  var obser = TextEditingController();
  var placa = TextEditingController();  
  double _saldo = 0;
  final GlobalKey<FormPagoState> formPagoKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  TestPrint testPrint = TestPrint();
 
  void callGoRefresh() {
    formPagoKey.currentState?.goRefresh();
  }
 
  @override
  void initState() {
    super.initState();
    _saldo = widget.factura.formPago!.saldo;   
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
        body: Container(
          color: kColorFondoOscuro,
          child: Stack(
            children: <Widget>[
              RefreshIndicator(
                onRefresh: () async {
                  callGoRefresh();
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[                  
                        
                       ClientPoints(factura: widget.factura, ruta: 'Contado'), 
                      
                       FormPago(
                          key: formPagoKey,
                        factura: widget.factura,
                         fontColor: kTextColorBlack,
                          onSaldoChanged:  _updateSaldo,
                          ruta: 'Contado',
                         ),
                                  
                       const SizedBox(height: 5,), 
                      signUpForm()                 
                     
                    ],
                  ),
                ),
              ),     
              _showLoader ? const LoaderComponent(text: "Creando Factura...") : Container(),     
            ],
          ),
        ),
        floatingActionButton: FloatingButtonWithModal(factura: widget.factura,)
      ),
    );    
  }

  Widget signUpForm() {
     return Container( 
        padding: const EdgeInsets.only(top: 15),            
       decoration: BoxDecoration(
          color: const Color.fromARGB(255, 235, 230, 236),
           gradient: const LinearGradient(
             colors: [kPrimaryColor, Color.fromARGB(255, 255, 255, 255)],
             begin: Alignment.centerRight,
             end:  Alignment(0.95, 0.0),
             tileMode: TileMode.clamp),
         border: Border.all(
         color: kSecondaryColor,
                     width: 1,
         ),
       ),
       child: Column(
         children: [
            const Text(
           'Información Factura',
           style: TextStyle(
             color: kBlueColorLogo,
             fontWeight: FontWeight.bold,
             fontSize: 20,
           ),
        ),
          const SizedBox(height: 10,),
           ShowClient(
            factura: widget.factura,
             ruta: 'Contado',
             padding: const EdgeInsets.only(left: 40.0, right: 40),
          ),
           showkms(),           
           showPlaca(),
           showObser(), 
           const SizedBox(height: 15,), 
           Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50, bottom: 15),
            child: DefaultButton(
            text: "Facturar",
            press: () => goFact(),              
            ),
          ),  
         ],
       ),
     );
  }

  Widget showkms() {
    return Container(
           padding: const EdgeInsets.only(left: 50.0, right: 50),
          child: TextField(  
            controller: kms,           
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(
              hintText: 'Ingrese los kms',
              labelText: 'Kms',                         
              suffixIcon: Icon(Icons.car_repair_rounded),           
            ),
            
          ),
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

  Widget showPlaca() {
    return Container(
          padding: const EdgeInsets.only(left: 50.0, right: 50),
          child: TextField(
            controller: placa,      
            keyboardType: TextInputType.text,            
            decoration: const InputDecoration(             
              labelText: 'Placa',      
               hintText: 'Ingrese la Placa',                      
              suffixIcon:  Icon(Icons.sms_outlined), 
            
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
              const Text.rich(
                TextSpan(
                  text: "Contado",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ),
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
                      "Total:${NumberFormat("###,000", "en_US").format(widget.factura.cart!.total.toInt())}",
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
                        color: kPrimaryColor,
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

  Future<void> goFact() async {
    if(widget.factura.formPago!.saldo!=0) {
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
      // int i=1;
      // for (var elemnt in widget.factura.cart!.products){
      //     elemnt.numero =i;
      //     i++;
      // }
      
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
        'totalSinpe' : widget.factura.formPago!.totalSinpe,
        'totalDollars' : widget.factura.formPago!.totalDollars,
        'totalCheques' : widget.factura.formPago!.totalCheques,
        'totalCupones' : widget.factura.formPago!.totalCupones,
        'totalPuntos' : widget.factura.formPago!.totalPuntos,
        'totalTransfer' : widget.factura.formPago!.totalTransfer,
        'saldo' : widget.factura.formPago!.saldo,
        'clientePaid' : widget.factura.formPago!.clientePaid.toJson(),
        'Transferencia' : widget.factura.formPago!.transfer.toJson(), 
        'kms': kms.text.isEmpty ? '0' : kms.text,       
        'placa': placa.text.isEmpty ? '' : placa.text,  
        'sinpe': widget.factura.formPago!.sinpe.toJson(),
        'observaciones' : obser.text.isEmpty ? '' : obser.text,
      };
     /// print(request);
      Response response = await ApiHelper.post("Api/Facturacion/PostFactura", request);  
      // ignore: avoid_print
     print(response.message);
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
    
     setState(() {
        for (var prod in widget.factura.cart!.products)  {       
          if(prod.unidad!="L"){  
              Product art = widget.factura.productos
              .firstWhere((element) => element.codigoArticulo == prod.codigoArticulo, orElse:
               () => Product(
                codigoArticulo: prod.codigoArticulo,
                detalle: prod.detalle,
                precioUnit: prod.precioUnit,
                cantidad: 0,
                unidad: prod.unidad,
                tipoArticulo: "",
                montoTotal: 0,
                descuento: 0,
                nDescuento: 0,
                subtotal: 0,
                tasaImp: 0,
                impMonto: 0,
                taxid: 0,
                rateid: 0,
                factor: 0,
                precioCompra: 0,
                codigoCabys: "",
                transaccion: 0,
                dispensador: 0,
                imageUrl: "",
                inventario: 0,
                images: [],
                colors: [],
                total: 0));

             if (art.cantidad != 0){
              // art.inventario = art.inventario - prod.cantidad.toInt();
               art.cantidad = 0;
             }  
          }         
        
        }
     });
      
      var decodedJson = jsonDecode(response.result);
      Factura resdocFactura = Factura.fromJson(decodedJson);   
      resdocFactura.usuario = '${widget.factura.cierreActivo!.usuario.nombre} ${widget.factura.cierreActivo!.usuario.apellido1}';
       
      resetFactura(widget.factura);
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
                      testPrint.ptrintFactura(resdocFactura,'FACTURA','CONTADO');
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

  Future<void> _goCart() async {
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

  void _updateSaldo(double nuevoSaldo) {
    if (mounted) {
        setState(() {
         _saldo = nuevoSaldo;
       });
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

 




  

  Future<void> goRefresh() async {
  }
}



