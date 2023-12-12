
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/components/default_button.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

import 'package:fuelred_mobile/models/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../constans.dart';
import '../../../sizeconfig.dart';
import '../../login_screen.dart';

class CheckoutCard extends StatefulWidget {
 
  final AllFact factura;   
  const CheckoutCard({    
    super.key,  
    required this.factura,  
 
  });

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  bool _showLoader = false;
  @override
  Widget build(BuildContext context) {   
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: 
          SafeArea(
          child: Stack(
            children:[ 
              _showLoader ?  const LoaderComponent(text: 'Creando Factura...') : const SizedBox(width: 0, height: 0,),              
              Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                   
                    InkWell(
                     
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: getProportionateScreenWidth(40),
                        width: getProportionateScreenWidth(40),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset("assets/User Icon.svg"),
                      ),
                    ),
                    const Spacer(),               
                    Text(widget.factura.clienteFactura!.nombre == "" ? "Seleccione Un Cliente": widget.factura.clienteFactura!.nombre),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: kTextColor,
                    )
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "Total:\n",
                        children: [
                          TextSpan(
                            text: "\$${NumberFormat("###,000", "en_US").format(widget.factura.cart!.total.toInt())}",
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(190),
                      child: DefaultButton(
                        text: "Check Out",
                        press: () => _goCheck(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ]
          ),
        ),      
    );
  }

  _goCheck() {
     if(widget.factura.cart!.products.isEmpty) {
      Fluttertoast.showToast(
          msg: "Agregue algun producto a la lista",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        ); 
    
      return;
    }
    
    if(widget.factura.clienteFactura!.nombre=="") {
       Fluttertoast.showToast(
          msg: " Seleccione un cliente para facturar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        ); 
      return;
    }
   

  }

  Future<void> goFact() async {
    if(widget.factura.cart!.products.isEmpty) {
    
      Fluttertoast.showToast(
          msg: "Agregue algun producto a la lista",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      return;
    }

    if(widget.factura.clienteFactura!.nombre=="") {
     
      Fluttertoast.showToast(
          msg: "Seleccione un cliente para facturar",
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
        'products': widget.factura.cart!.products.map((e) => e.toApiProducJson()).toList(),
        'idCierre' : widget.factura.cierreActivo!.cierreFinal.idcierre,
        'cedualaUsuario' : widget.factura.cierreActivo!.usuario.cedulaEmpleado.toString(),
        'cedulaclienteFactura!' : widget.factura.clienteFactura!.documento,
      };
      Response response = await ApiHelper.post("Api/Facturacion/PostFactura", request);  

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
          msg: "Factura Creada Correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );  
    Future.delayed(const Duration(milliseconds: 1200), () {
        Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen())
        );   

    });
    //  


  }
}
