import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/cart/components/custom_appBar_cart.dart';
import 'package:fuelred_mobile/Screens/cart/components/item_cart.dart';
import 'package:fuelred_mobile/Screens/cart/components/show_payment.dart';
import 'package:fuelred_mobile/Screens/cart/components/show_process.dart';
import 'package:fuelred_mobile/Screens/cart/components/show_total.dart';
import 'package:fuelred_mobile/Screens/credito/credit_process_screen.dart';
import 'package:fuelred_mobile/Screens/home/home_screen.dart';
import 'package:fuelred_mobile/Screens/tickets/ticket_screen.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

import '../../components/loader_component.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';
import '../checkout/checkount.dart';


class CartNew extends StatefulWidget { 
  final AllFact factura; 
  const CartNew({
    super.key,
    required this.factura, 
    });

  @override
  State<CartNew> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartNew> {
  List<String> placas =[];
  bool _showLoader = false;
  bool _showProcess =false;
  bool _showPayment =false;
  bool _showTotal=false;
  bool showCredito =false;
  String placaNombre="";
  
  @override
  void initState() {
    super.initState();
    setState(() {
      _showTotal=widget.factura.formPago!.showTotal;
      _showPayment=widget.factura.formPago!.showFact;
     
    });
  }

  @override
 Widget build(BuildContext context) {
    widget.factura.cart!.setTotal();
    return SafeArea(
      child: Scaffold( 
        backgroundColor: kColorFondoOscuro,    
        appBar: PreferredSize(
          preferredSize:    const Size.fromHeight(65),
          child:  CustomAppBarCart(
            factura: widget.factura,          
            press: () => goHome(),
            title: 'Carrito',
            backgroundColor: kPrimaryColor,
          ),
        ),
        body: Stack(
          children: [ Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: 
          ListView.builder(
              itemCount: widget.factura.cart!.products.length,
              itemBuilder: (context, index) {
                final product = widget.factura.cart!.products[index];
                return CardCartItem(
                  product: product,
                  onIncreaseQuantity: (product) {
                    setState(() {
                        if (product.inventario > 0){
                          product.cantidad=product.cantidad + 1;
                          product.inventario=product.inventario - 1;                             
                          product.setTotal();
                          widget.factura.cart!.setTotal();
                        
                        }
                    });
                  },
                  onDecreaseQuantity: (product) {
                    setState(() {
                        if (product.cantidad > 1)    {
                            product.cantidad= product.cantidad -1;
                            product.inventario = product.inventario +1;                               
                            product.setTotal();
                            widget.factura.cart!.setTotal();
                        }
                    });
                  },
                  onDismissed: (product) {
                   setState(() {               
                    if(widget.factura.cart!.products[index].unidad=="L"){
                        widget.factura.transacciones.add(widget.factura.cart!.products[index]);
                    }
                    else{
                      for (var element in widget.factura.productos) {
                            if (element.codigoArticulo==widget.factura.cart!.products[index].codigoArticulo){                       
                              element.inventario=(element.inventario + element.cantidad).toInt();
                              element.cantidad=0;                         
                            }
                       }
                    }
                     widget.factura.cart!.products.removeAt(index);
                     widget.factura.cart!.setTotal();
                   });             
                  },
                );
              },
            ),
    
          ),
          _showLoader ? const LoaderComponent(text: 'Procesando...',) : Container(),
          ]
        ),
        
        bottomNavigationBar: 
          _showTotal ? ShowTotal(
                  factura: widget.factura,
                  onFacturarPressed: () => goPayment(),
                  onProcesarPressed: () => showProces(),
                )
         : _showProcess ? ShowProcessMenu(
                  onProcessSelected: (estado) => _goProcess(estado),
                  onBack: () => _goTotal(),
                ) 
         : _showPayment ? ShowPayment(
                factura: widget.factura,
                onCreditoPressed: () => _goCredito(),
                onContadoPressed: () => _goCheck(),
                onTicketPressed: () => goTicket(),
                onBackPressed: () => goPayment(),
              ) : Container(),    
          
         
         
      ),
    );
  }

 

 void _goCheck() async {
    if(widget.factura.cart!.products.isEmpty) {

      Fluttertoast.showToast(
          msg: "Seleccione algun producto.",
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
          msg: "Seleccione el cliente.",
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
       widget.factura.setSaldo();
     });
    Navigator.push(context,
    MaterialPageRoute(
        builder: (context) =>
          CheaOutScreen(factura: widget.factura,))
    ); 
 }

 Future<void> showMyDialog(BuildContext context, String title, String content) async {
  await Future.delayed(const Duration(seconds: 2));
  if (mounted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
  
  
}
 
 void _goCredito() async {
    
       Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) =>  ProceeeCreditScreen(factura: widget.factura,))
        );   
    }

 void goHome() async {
    Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) =>  HomeScreen(factura: widget.factura))
    );
 }

 Future<void> _goProcess(String estado) async {
  bool validate=false;
  bool validate2=false;
  if(estado=='Exonerado'){
  for (var item in widget.factura.cart!.products) {
      if (item.detalle!='Comb Exonerado'){
        validate=true;
        break;
      }     
    }
  }

  else{
    for (var item in widget.factura.cart!.products) {
      if (item.detalle=='Comb Exonerado'){
        validate2=true;
        break;
      }     
    }

  }
  if(validate){
       Fluttertoast.showToast(
          msg: "Todas las transacciones deben ser de Exonerado.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
    return;
  }

  if(validate2){
 
     Fluttertoast.showToast(
          msg: "La transaccion no corresponde exonerado.",
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
        'estado' : estado,       

      };
      Response response = await ApiHelper.post("Api/Facturacion/ProcessTransactions", request);  

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
          msg: "Transacciones Procesadas \n Correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 10, 75, 4),
          textColor: Colors.white,
          fontSize: 16.0
        );  

        setState(() {
          widget.factura.cart!.products.clear();
          widget.factura.cart!.setTotal();
         
        });
       Future.delayed(const Duration(milliseconds: 1200), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen(factura: widget.factura,)), // Reemplaza NewPage con la ruta a la que quieres navegar
          (Route<dynamic> route) => false,
        );
      });
 }

  showProces() {
        
    bool success = true;

     for (var item in widget.factura.cart!.products) {
        if (item.transaccion==0){
          success=false;
          break;
        }     
      }

      if(!success){
    
        Fluttertoast.showToast(
          msg: "Seleccione solo transacciones \n de Combustible.",
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
       _showProcess = true;
       _showPayment = false;
       _showTotal=false;
     });
  }

  _goTotal() { 
     setState(() {
       _showProcess = !_showProcess;       
       _showTotal=true;
     });
  }

 void goTicket() async {
  setState(() {
     widget.factura.setSaldo();
  });
 
    Navigator.push(context,
      MaterialPageRoute(
         builder: (context) =>  TicketScreen(factura: widget.factura))
     ); 
  }
  
 goPayment() {
    setState(() {
      _showTotal=!_showTotal;
      _showPayment = !_showPayment;
    });
  }
 
}
             