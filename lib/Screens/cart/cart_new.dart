import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/cart/components/custom_appBar_cart.dart';
import 'package:fuelred_mobile/Screens/credito/credit_process_screen.dart';
import 'package:fuelred_mobile/Screens/home/home_screen.dart';
import 'package:fuelred_mobile/Screens/tickets/ticket_screen.dart';
import 'package:fuelred_mobile/components/show_client.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/product.dart';
import 'package:intl/intl.dart';
import '../../components/color_button.dart';
import '../../components/loader_component.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';
import '../checkout/checkount.dart';
import '../login_screen.dart';


class CartNew extends StatefulWidget { 
  final AllFact factura; 
  
 
  const CartNew({
    Key? key,
    required this.factura, 
   
     
    }) : super(key: key);

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
      _showTotal=widget.factura.formPago.showTotal;
      _showPayment=widget.factura.formPago.showFact;
    });
  }

  @override
 Widget build(BuildContext context) {
    widget.factura.cart.setTotal();
    return Scaffold( 
      backgroundColor: kColorFondoOscuro,    
      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(AppBar().preferredSize.height),
        child:  CustomAppBarCart(
          factura: widget.factura,          
          press: () => goHome(),
        ),
      ),
      body: Stack(
        children: [ Padding(
        padding:
        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: 
        ListView.builder(
          itemCount: widget.factura.cart.products.length,
          itemBuilder: (context, index) {
            final item = widget.factura.cart.products[index].transaccion == 0
             ? widget.factura.cart.products[index].codigoArticulo 
             : widget.factura.cart.products[index].transaccion.toString();
           return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Dismissible(
              key: Key(item),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {              
                setState(() {               
                  if(widget.factura.cart.products[index].unidad=="L"){
                      widget.factura.transacciones.add(widget.factura.cart.products[index]);
                  }
                  else{
                    for (var element in widget.factura.productos) {
                          if (element.codigoArticulo==widget.factura.cart.products[index].codigoArticulo){                       
                            element.inventario=(element.inventario + element.cantidad).toInt();
                            element.cantidad=0;                         
                          }
                     }
                  }
                   widget.factura.cart.products.removeAt(index);
                   widget.factura.cart.setTotal();
                });             
              },
              background: Container(              
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE6E6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    SvgPicture.asset("assets/Trash.svg"),
                  ],
                ),
              ),
              child: newCardCart(widget.factura.cart.products[index]),
              
            ),
           );  
          },    
        ),
        ),
        _showLoader ? const LoaderComponent(text: 'Procesando...',) : Container(),
        ]
      ),
      
      bottomNavigationBar: 
        _showTotal ? showTotal() 
       : _showProcess ? showProcessMenu() 
       : _showPayment ? showPayment() : Container(),    
        
       
       
    );
  }

 Widget showTotal() {
   return Container(
         color: const Color.fromARGB(255, 216, 216, 218),

        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            
             Text.rich(
                TextSpan(
                  text: "Total: \n",
                    style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                  
                  children: [
                    TextSpan(
                      text: "¢${NumberFormat("###,000", "en_US").format(widget.factura.cart.total)}",
                      style: const TextStyle(fontSize: 21, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ColorButton(                        
                text: 'Facturar',   
                press: () => goPayment(),
                color: kPrimaryColor,
                ancho: 100,                  
              ),
              const SizedBox(width: 10,),
               ColorButton(color:kBlueColorLogo, ancho: 100, text: 'Procesar', press: () => showProces(),),         
          ]),
        ),
       );
  }
 
 Widget showPayment() {
  return  Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: const BoxDecoration(
        color: kTextColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -1),
            blurRadius: 5,
            color: Colors.deepOrange
          )
        ],
      ),
      child: 
          SafeArea(
          child: Stack(
            children:[ 
               const SizedBox(width: 0, height: 0,),              
              Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                      ColorButton(
                       color: const Color.fromARGB(255, 215, 170, 7), 
                       ancho: 90, 
                       text: 'Credito',   
                       press: () => _goCredito(),                  
                      ),
                     const Spacer(), 
                       SizedBox(
                      width: getProportionateScreenWidth(100),
                      child: ColorButton(
                        text: "Contado",
                        press: () => _goCheck(),
                        color: Colors.red,
                        ancho: 20,
                      ),
                    ),
                    
                     const Spacer(),  
                     ColorButton(color: const Color.fromARGB(255, 6, 142, 76), ancho: 80, text: 'Ticket', press: () => goTicket(),),

                  ],
                ),
                 SizedBox(height: getProportionateScreenHeight(10)),
               // showClient1(context),
                ShowClient(factura: widget.factura, ruta: 'Cart',),
                SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "Total:\n",
                          style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                        
                        children: [
                          TextSpan(
                            text: "¢${NumberFormat("###,000", "en_US").format(widget.factura.cart.total.toInt())}",
                            style: const TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                     
                     SizedBox(
                      width: getProportionateScreenWidth(90),
                      child: ColorButton(
                        text: "Atras",
                        press: () => goPayment(),
                        color: kBlueColorLogo,
                        ancho: 20,
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

 Widget showProcessMenu() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: const BoxDecoration(
        color: kColorFondoOscuro,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -1),
            blurRadius: 20,
            color:Color.fromARGB(255, 80, 3, 3),
          )
        ],
      ),
      child: 
          SafeArea(
          child: Stack(
            children:[ 
               const SizedBox(width: 0, height: 0,),              
              Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: 
                  [                   
                      ColorButton(color: kBlueColorLogo, ancho: 100, press:() => _goProcess('Efectivo'), text: 'Efecivo',),
                      const Spacer(), 
                       ColorButton(color: kBlueColorLogo, ancho: 100, press:() => _goProcess('Tarjeta_Bac'), text: 'Tar BAC',),
                       
                      const Spacer(), 
                        ColorButton(color: kBlueColorLogo, ancho: 100, press:() => _goProcess('Cheque'), text: 'Cheque',),
                      const Spacer(),   
                  ]
                ),

                  
               
                 SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  children: [                   
                      ColorButton(color: kBlueColorLogo, ancho: 100, press:() => _goProcess('Calibracion'), text: 'Cali',),
                    const Spacer(), 
                     ColorButton(color: kBlueColorLogo, ancho: 100, press:() => _goProcess('Exonerado'), text: 'Exo',),
                    const Spacer(), 
                     ColorButton(color: kBlueColorLogo, ancho: 100, press:() => _goProcess('Cupones'), text: 'Cupon',),
                    const Spacer(),   
                  ]
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      ColorButton(color: kBlueColorLogo, ancho: 100, press:() => _goProcess('Tarjeta_Dav'), text: 'Tar DAV',),
                    const Spacer(), 
                     ColorButton(color: kBlueColorLogo, ancho: 100, press: () =>_goProcess('Tarjeta_Scotia'), text: 'Tar SCO',),
                    const Spacer(), 
                     ColorButton(color: kBlueColorLogo, ancho: 100, press:() => _goProcess('Tarjeta_Bn'), text: 'Tar BN',),
                    const Spacer(),   
                  ]
                ),
                 SizedBox(height: getProportionateScreenHeight(10)),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                 
                   ColorButton(color: kBlueColorLogo, ancho: 100, press: () =>_goProcess('Dollar'), text: 'Dollar',),
                    const Spacer(),  
                  ColorButton(color: kPrimaryColor, ancho: 200, press:() => _goTotal(), text: 'Atras',),
                   ]
                ),
              ],
            ),        
            ]
          )
        ),
    );      
  }

 void _goCheck() async {
    if(widget.factura.cart.products.isEmpty) {

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

     if(widget.factura.clienteFactura.nombre=="") {
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
  for (var item in widget.factura.cart.products) {
      if (item.detalle!='Comb Exonerado'){
        validate=true;
        break;
      }     
    }
  }

  else{
    for (var item in widget.factura.cart.products) {
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
        'products': widget.factura.cart.products.map((e) => e.toApiProducJson()).toList(),
        'idCierre' : widget.factura.cierreActivo.cierreFinal.idcierre,
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
    Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(context,
                      MaterialPageRoute(
       
                          builder: (context) => const LoginScreen()));
      });
 }

  showProces() {
        
    bool success = true;

     for (var item in widget.factura.cart.products) {
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

  Widget newCardCart(Product product){
  return  Column(
      children: [
         Row(
        children: [
          SizedBox(
            width: 100,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 106, 106, 107),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: product.unidad == "Unid" ? CachedNetworkImage(
                    imageUrl:'$imagenesUrl/${product.imageUrl}',
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                    placeholder: (context, url) => const Image(
                      image: AssetImage('assets/Logo.png'),
                      fit: BoxFit.cover,
                      height: 80,
                      width: 80,
                    ),                         
                    ) : Image(
                        image: product.detalle =='Comb Super' ?  const AssetImage('assets/super.png') : 
                              product.detalle=='Comb Regular' ? const AssetImage('assets/regular.png') : 
                              product.detalle=='Comb Exonerado' ? const AssetImage('assets/exonerado.png') :
                              const AssetImage('assets/diesel.png'),
                    ),
              ),
            ),
          ),       
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.detalle,
                  style: const TextStyle(color: kContrateFondoOscuro, fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                ),
               
                Text.rich(
                  TextSpan(
                    text: "Sub-Total ¢${NumberFormat("###,000", "en_US").format(product.montoTotal)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: kContrateFondoOscuro),
                    children: [
                      TextSpan(
                          text: " - Cant ${product.cantidad}",
                          style: const TextStyle(
                           fontWeight: FontWeight.w600, color: kContrateFondoOscuro)),
                    ],
                  ),
                ),
               
                product.unidad == "Unid" ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => {
                        setState(() {
                            if (product.inventario > 0){
                              product.cantidad=product.cantidad + 1;
                              product.inventario=product.inventario - 1;                             
                              product.setTotal();
                              widget.factura.cart.setTotal();
                            
                            }
                        }),
                      },
                      icon: const Icon(
                        Icons.add_circle, 
                         color: Colors.green,
                         size: 30,
                        )),
                    IconButton(
                      onPressed: () => {
                        setState(() {
                            if (product.cantidad > 1)    {
                                product.cantidad= product.cantidad -1;
                                product.inventario = product.inventario +1;                               
                                product.setTotal();
                                widget.factura.cart.setTotal();
                            }
                        }),
                      },
                      icon: const Icon(Icons.remove_circle, color: kPrimaryColor, size: 30,)),
                  ],
                ) : const SizedBox(height: 0),
              ],
            ),
          )
        ],
      ),
      const Divider(
            height: 2,
            thickness: 2,
            color: kTextColor,
      ),
      ]
    );
 }  
 



 
  
}
             