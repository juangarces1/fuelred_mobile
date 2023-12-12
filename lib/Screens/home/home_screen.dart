
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/Sinpes/sinpes_screen.dart';
import 'package:fuelred_mobile/Screens/cart/cart_new.dart';
import 'package:fuelred_mobile/Screens/clientes/cliestes_new_screen.dart';
import 'package:fuelred_mobile/Screens/facturas/facturas_screen.dart';
import 'package:fuelred_mobile/Screens/login_screen.dart';
import 'package:fuelred_mobile/Screens/manejoCierre/cashbacks_screen.dart';
import 'package:fuelred_mobile/Screens/manejoCierre/cierre_datafonos_screen.dart';
import 'package:fuelred_mobile/Screens/manejoCierre/depositos_screen.dart';
import 'package:fuelred_mobile/Screens/manejoCierre/peddlers_screen.dart';
import 'package:fuelred_mobile/Screens/manejoCierre/transferencias_screen.dart';
import 'package:fuelred_mobile/Screens/manejoCierre/viaticos_screen.dart';
import 'package:fuelred_mobile/Screens/transacciones/transacciones_screen.dart';
import 'package:fuelred_mobile/clases/show_alert_cliente.dart';
import 'package:fuelred_mobile/components/my_loader.dart';
import 'package:fuelred_mobile/components/product_card.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/product.dart';
import 'package:intl/intl.dart';

import '../../constans.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';
import 'components/icon_btn_with_counter.dart';

class HomeScreen extends StatefulWidget {  
  const HomeScreen({ 
    Key? key, 
    required this.factura,
     
  }) : super(key: key);

  final AllFact factura; 
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> { 
  bool _showLoader = false;  
  bool _showFilter = false;
  double width = 140;
  double alto = 140;
  double aspectRetio = 1.02;
  String _search = ''; 
  // ignore: non_constant_identifier_names
  List<Product> backup_products = []; 
  // ignore: non_constant_identifier_names
  List<Product> backup_transacciones = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Timer _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});

  @override
  void initState() {
    super.initState(); 
    _orderTransactions();
    // _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _updateTransactions());
  }

  @override
  void dispose() {
   // _timer.cancel();
    super.dispose();
  }

  @override
  
  
  @override
 Widget build(BuildContext context) {
     return SafeArea( 
       child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kColorFondoOscuro,         
        body: content(context),
          drawer: _getAdminMenu(),
       ),
     );
}

 Widget content(context){
   TextStyle baseStyle = const TextStyle(
      fontStyle: FontStyle.normal, 
      fontSize: 16,
      fontWeight: FontWeight.bold, 
      color: Colors.white
    );
  return  Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                decoration:  BoxDecoration(
                  gradient: kGradientHome, 
                   boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 148, 143, 143).withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Cambios de posición de la sombra
                      ),
                    ],       
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        Text('User: ${widget.factura.cierreActivo!.usuario.nombre} ${widget.factura.cierreActivo!.usuario.apellido1}', style: baseStyle),
                        Text('Cajero: ${widget.factura.cierreActivo!.cajero.nombre} ${widget.factura.cierreActivo!.cajero.apellido1}', style: baseStyle),               
                      ],       
                    ),
                    const Spacer(),
                   
                    SizedBox(
                      height: getProportionateScreenHeight(40),
                      width: getProportionateScreenWidth(40),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          
                            backgroundColor:  Colors.white,
                            padding: EdgeInsets.zero,
                          ),
                          onPressed:  () => _showNewCliente(context),        
                                                    
                          child:  SvgPicture.asset("assets/User Icon.svg",
                          // ignore: deprecated_member_use
                          color:  widget.factura.clienteFactura!.nombre == '' 
                            ? Colors.black
                              : kPrimaryColor, 
                          ),
                        ),
                    ),
                    const SizedBox(width: 10,),
                    IconBtnWithCounter(
                      svgSrc: "assets/Cart Icon.svg",  
                      numOfitem: widget.factura.cart!.products.length,  
                      press: goCart,                     
                    ), 
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              combustibles(context),
              const Divider(height: 40, thickness: 2, color: kTextColor), 
              searchBarCartIcon(context),
              const Divider(height: 40, thickness: 2, color: kTextColor), 
              aceitesProductos(context),
              SizedBox(height: getProportionateScreenHeight(10)),
            ],
          ),
        ),
        _showLoader ? const CustomActivityIndicator(loadingText: "Actualizando...") : const SizedBox.shrink(),
      ],
    );

}

 Widget aceitesProductos(context){
  return  Column( 
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Aceites & Otros(${widget.factura.productos.length})",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  color: kContrateFondoOscuro,
                ),
              ),
                GestureDetector(
              onTap: _updateProducts,
              child: const Text(
                "Actualizar",
                style: TextStyle(color: kContrateFondoOscuro),
              ),
            ),        
            ],
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(10)),
        SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: 
          [
            ...List.generate(
            widget.factura.productos.length,
              (index) {      
                  return ProductCard(
                    product: widget.factura.productos[index],
                    factura: widget.factura,                     
                  );                 
              },
            ),
            SizedBox(width: getProportionateScreenWidth(20)),
          ],
        ),
        ),


      ],
    );

}

Widget searchBarCartIcon(context){
return Padding(
    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: SizeConfig.screenWidth * 0.6,
          decoration: BoxDecoration(
            color: kContrateFondoOscuro,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            // ignore: avoid_print
            controller: TextEditingController(text: _search),
            onChanged: (value) => _search = value,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                    vertical: getProportionateScreenWidth(9)),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "Buscar Producto",
            ),
          ),
        ),
        const SizedBox(width: 10,),
        InkWell(            
          borderRadius: BorderRadius.circular(100),
          onTap: () => _filter(),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(12)),
                height: getProportionateScreenWidth(46),
                width: getProportionateScreenWidth(46),
                decoration: const BoxDecoration(
                  color: kContrateFondoOscuro,
                  shape: BoxShape.circle,
                ),
                // ignore: deprecated_member_use
                child: SvgPicture.asset("assets/Search Icon.svg", color: kTextColorBlack,),
              ),
            ],
          ),
        ),
        const Spacer(),
        _showFilter ?  IconBtnWithCounter(
          svgSrc: "assets/filter-slash-svgrepo-com.svg",  
          numOfitem:  widget.factura.productos.length,  
                  
          press: removeFilter,                     
            
        ) : Container(),
      ],
    ),
  );
 }

 void goCart () {
  setState(() {
    widget.factura.formPago!.showTotal=true;
     widget.factura.formPago!.showFact=false;
  });
    if (widget.factura.cart!.products.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartNew(
            factura: widget.factura,
            
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(
            msg: "No hay productos en el carrito",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(251, 231, 235, 6),
            textColor: const Color.fromARGB(255, 14, 13, 13),
            fontSize: 16.0
          ); 
    }
   
                    
 }

 Widget combustibles(context){
  return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            Text(
              "Combustibles(${widget.factura.transacciones.length})",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                color: Colors.white,
              ),
            ),
            const Spacer(),
          GestureDetector(
            onTap: _updateTransactions,
            child: const Text(
              "Actualizar",
              style: TextStyle(color: kContrateFondoOscuro),
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(10)),
         ],
        ),
     SizedBox(height: getProportionateScreenWidth(10)),          
  
       widget.factura.transacciones.isNotEmpty ?    Container(
            padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
            height: getProportionateScreenHeight(200),
            child: ListView.separated(
            
              scrollDirection: Axis.horizontal,                  
              itemCount: widget.factura.transacciones.length,
              separatorBuilder: (context, _) => const SizedBox(width: 0,),
              itemBuilder: (context, indice) => buildCard(product: widget.factura.transacciones[indice]),
              
                  ),
          ): _noTr(),
        SizedBox(width: getProportionateScreenWidth(20)),
    ],
  );
 }

 Widget _getAdminMenu() {
    return SafeArea(
      child: Drawer(        
        backgroundColor: kColorFondoOscuro,
        child: ListView(
         itemExtent: 50,
          padding: EdgeInsets.zero,
          children: <Widget>[ const SizedBox(         
            height: 50,
            width: 120,         
            child: DrawerHeader(          
               margin: EdgeInsets.zero,
               padding: EdgeInsets.zero,
               decoration: BoxDecoration(               
               color: Color.fromARGB(255, 241, 244, 245), 
               image: DecorationImage(
                 scale: 5.5,
                 image:  AssetImage('assets/LogoSinFondo.png'))),
                   child: SizedBox()),
          ),           
            ListTile(
                textColor: kColorMenu,
              leading:   Container(
                width: 35,
                padding: EdgeInsets.all(getProportionateScreenWidth(4)),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:  const Image(
                            image: AssetImage('assets/cbs.png'),
                            fit: BoxFit.contain,
                        ),
              ),  
              title: const Text('CashBacks'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => CashbarksScreen(factura: widget.factura)
                   )
                 );
              },
            ),

             ListTile(
                textColor: kColorMenu,
              leading:  Container(
                width: 35,
                padding: EdgeInsets.all(getProportionateScreenWidth(3)),
                decoration:  BoxDecoration(
                  color: kContrateFondoOscuro,
                    borderRadius: BorderRadius.circular(8),
                ),
                child:  const Image(
                            image: AssetImage('assets/deposito.png'),
                        ),
              ),  
              title: const Text('Depositos'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) =>  DepositosScreen(factura: widget.factura)
                   )
                 );
              },
            ),

             ListTile(
             textColor:kColorMenu,
              leading:  Container(
                width: 35,
                padding: EdgeInsets.all(getProportionateScreenWidth(4)),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:  const Image(
                            image: AssetImage('assets/data.png'),
                        ),
              ),     
              title: const Text('Cierre Datafonos'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => CierreDatafonosScreen(factura: widget.factura)
                   )
                 );
              },
            ),

             ListTile(
                textColor: kColorMenu,
                leading:  Container(
                width: 35,
                padding: EdgeInsets.all(getProportionateScreenWidth(1)),
                decoration: BoxDecoration(
                  color: kContrateFondoOscuro,
                  borderRadius: BorderRadius.circular(8),
                ),
                child:  const Image(
                            image: AssetImage('assets/viaticos.png'),
                        ),
              ),   
              title: const Text('Viaticos'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => ViaticosScreen(factura: widget.factura,)
                   )
                 );
              },
            ),

              ListTile(
                textColor: kColorMenu,
                leading: Container(
                  width: 35,
                  padding: EdgeInsets.all(getProportionateScreenWidth(2)),
                  decoration: BoxDecoration(
                    color: kContrateFondoOscuro,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  const Image(
                              image: AssetImage('assets/peddler.png'),
                          ),
                ),   
              title: const Text('Peddlers'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => PeddlersScreen(factura: widget.factura,)
                   )
                 ).then((value) {
                      _orderTransactions();
                  });
              },
            ),


           ListTile(
                textColor: kColorMenu,
              leading: Container(
                  width: 35,
                  padding: EdgeInsets.all(getProportionateScreenWidth(2)),
                  decoration: BoxDecoration(
                    color: kContrateFondoOscuro,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  const Image(
                              image: AssetImage('assets/NoTr.png'),
                          ),
                ),   
              title: const Text('Transacciones'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => TransaccionesScreen(factura: widget.factura)
                   )
                 );
              },
            ),

             ListTile(
                textColor:kColorMenu,
              leading:  Container(
                  width: 35,
                  padding: EdgeInsets.all(getProportionateScreenWidth(2)),
                  decoration: BoxDecoration(
                    color: kContrateFondoOscuro,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  const Image(
                              image: AssetImage('assets/tr9.png'),
                          ),
                ),   
              title: const Text('Transferencias'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => TransferenciasScreen(factura: widget.factura)
                   )
                 );
              },
            ),

              ListTile(
              textColor:kColorMenu,
              leading: Container(
                  width: 35,
                  padding: EdgeInsets.all(getProportionateScreenWidth(4)),
                  decoration: BoxDecoration(
                    color: kContrateFondoOscuro,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  const Image(
                              image: AssetImage('assets/sinpe.png'),
                          ),
                ),   
              title: const Text('Sinpes'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => SinpesScreen(all: widget.factura)
                   )
                 );
              },
            ),

            ListTile(
                 textColor:kColorMenu,
              leading: Container(
                  width: 35,
                  padding: EdgeInsets.all(getProportionateScreenWidth(2)),
                  decoration: BoxDecoration(
                    color: kContrateFondoOscuro,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  const Image(
                              image: AssetImage('assets/factura.png'),
                          ),
                ),   
              title: const Text('Facturas Contado'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => FacturasScreen(factura: widget.factura, tipo: 'Contado',)
                   )
                 ).then((value) {
                      _orderTransactions();
                      
                  });
              },
            ),

              ListTile(
                  textColor: kColorMenu,
              leading:  Container(
                  width: 35,
                  padding: EdgeInsets.all(getProportionateScreenWidth(2)),
                  decoration: BoxDecoration(
                    color: kContrateFondoOscuro,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  const Image(
                              image: AssetImage('assets/factura.png'),
                          ),
                ),   
              title: const Text('Facturas Credito'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => FacturasScreen(factura: widget.factura,  tipo: 'Credito',)
                   )
                 ).then((value) {
                      _orderTransactions();
                  });
              },
            ),

             ListTile(
                 textColor: kColorMenu,
              leading: Container(
                  width: 35,
                  padding: EdgeInsets.all(getProportionateScreenWidth(2)),
                  decoration: BoxDecoration(
                    color: kContrateFondoOscuro,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  const Image(
                              image: AssetImage('assets/salir.png'),
                              fit: BoxFit.contain,
                          ),
                ),   
              title: const Text('Cerrar Sesión'),
              onTap: () => { 
                 Navigator.pushReplacement(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => const LoginScreen()
                   )
                 ),
              },
            ),
          ],
        ),
      ),
    );
  }

 void _orderTransactions() {
  if (widget.factura.transacciones.isEmpty) return;
  widget.factura.transacciones.sort(((b, a) => a.transaccion.compareTo(b.transaccion)));
  
    setState(() {
      backup_products = widget.factura.productos;
      
    });
  }
  
 void mainTicker() async {
  Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTransactions());
} 

  Widget buildCard({
  required Product product
  }) => Hero(
    tag: '${product.transaccion}-${product.codigoArticulo}',
    child: SizedBox(
      width: getProportionateScreenWidth(width),   
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [           
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Material(                
                color: kColorFondoOscuro,
                child: Ink.image(                        
                  image: product.detalle =='Super' ?  const AssetImage('assets/super.png') : 
                    product.detalle=='Regular' ? const AssetImage('assets/regular.png') : 
                    product.detalle=='Exonerado' ? const AssetImage('assets/exonerado.png') :
                    const AssetImage('assets/diesel.png'),
                    fit: BoxFit.cover,
                    child: InkWell(
                      onTap: () => addToCart(product),
                    ),
                  ),
                ),
              ),
            ),
            Text(
            "Disp: ${product.dispensador.toString()}",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(16),
              fontWeight: FontWeight.normal,
              color: kColorMenu,
            ),
          ),       
               
        Text(
          "Cant: ${product.cantidad.toString()}",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(16),
            fontWeight: FontWeight.normal,
            color: kColorMenu,
          ),
        ),
        Text(
          "¢${NumberFormat("###,000", "en_US").format(product.total.toInt())}",
          style:  TextStyle(
            fontSize: getProportionateScreenWidth(18),
            fontWeight: FontWeight.w600,
            color: kPrimaryText,
          ),
        )
      ]),
  ),
  );

  // Future<void> _updateTransactions() async {
  //     setState(() {
  //       _showLoader=true;
  //     });
  //     Response rsponseTransacciones = await ApiHelper.getTransaccionesAsProduct(widget.factura.cierreActivo!.cierreFinal.idzona);     
  //      setState(() {
  //       _showLoader=false;
  //     });
  //     if (rsponseTransacciones.isSuccess){
  //       backup_transacciones.clear();
  //       backup_transacciones = rsponseTransacciones.result;
  //       if (backup_transacciones.isEmpty) return;
  //       backup_transacciones.sort(((b, a) => a.transaccion.compareTo(b.transaccion)));
  //      if(backup_transacciones.first.transaccion > widget.factura.lasTr){
  //        setState(() {
  //         for (var item in backup_transacciones) {
  //             if(item.transaccion > widget.factura.lasTr){
  //               widget.factura.transacciones.add(item);
  //             }
  //         }
           
  //         widget.factura.lasTr = backup_transacciones.first.transaccion;
  //         _orderTransactions();
  //        });         
  //       }
  //     } 
        
  //   }

     Future<void> _updateTransactions() async {
      setState(() {
        _showLoader=true;
      });
      Response rsponseTransacciones = await ApiHelper.getTransaccionesAsProduct(widget.factura.cierreActivo!.cierreFinal.idzona);     
       setState(() {
        _showLoader=false;
      });
      if (rsponseTransacciones.isSuccess){
         setState(() {
          widget.factura.transacciones = rsponseTransacciones.result; 
          backup_transacciones = rsponseTransacciones.result;
          _orderTransactions();
          widget.factura.lasTr = backup_transacciones.first.transaccion;
         
         });   
      } 
        
    }

  void _updateProducts() async {
    setState(() {
      _showLoader =true;
    });
      
    Response response = await ApiHelper.getProducts(widget.factura.cierreActivo!.cierreFinal.idzona);
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

    widget.factura.productos=response.result;

    for (var item in widget.factura.productos) {
      item.images.add(item.imageUrl);     
    }

    
    if (widget.factura.cart!.products.isNotEmpty){
     for (var cartProduct in widget.factura.cart!.products) {
        for (var productitem in widget.factura.productos) {
          if (cartProduct.codigoArticulo==productitem.codigoArticulo){
              productitem.cantidad=cartProduct.cantidad;
              productitem.inventario=cartProduct.inventario;
          }
        }
      }
    }
    setState(() {
      widget.factura.productos;
      _showLoader=false;
    });
  }

  addToCart(Product product) {     
      setState(() {
        widget.factura.cart!.products.add(product);
        widget.factura.transacciones.remove(product);       
      });   
      goCart();
  }
   
  void _filter() {
    if (_search.isEmpty) {      
      return;
    }
    
    
    List<Product> filteredList = [];
    for (Product product in widget.factura.productos) {
      if (product.detalle.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(product);
      }
    }

   

    setState(() {
      widget.factura.productos = filteredList;  
     _showFilter = ! _showFilter;
      
    });   
  }

 void _showNewCliente(context) {
   ShowAlertCliente.showAlert(context, widget.factura.clienteFactura!, _goClientes);

}

 void _goClientes() {
    Navigator.of(context).pop();
    Navigator.push(context,  
      MaterialPageRoute(
        builder: 
        (context) => ClientesNewScreen(factura: widget.factura,ruta: 'Home',)
      )
    );
  }
 
 Widget _noTr(){
  return Column(
    children: [
      
      Center(
        child: Container(
          padding: EdgeInsets.all(getProportionateScreenWidth(10)),
          height: 100,
          width: 100,
          color: kColorFondoOscuro,
          child: AspectRatio(
              aspectRatio: aspectRetio,
              child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                  decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                  ),
                  child:  const Image(
                        image: AssetImage('assets/NoTr.png'),
                        fit: BoxFit.cover,
                        height: 70,
                        width: 70,
                      ),                         
              ),
            ),
                    
            
        ),
      ),
      Center(
        child: Text(
          'No Hay Transacciones',
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            fontWeight: FontWeight.bold,
            color: kContrateFondoOscuro,
          ),
        ),),
    ],

  );
 }
  
  removeFilter() {
     setState(() {
      _search = "";
      widget.factura.productos = backup_products;  
     _showFilter = ! _showFilter;
      
    });  
  }
}