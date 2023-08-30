// import 'package:adaptive_dialog/adaptive_dialog.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:fuelred_mobile/Screens/Details/product_screen.dart';
// import 'package:fuelred_mobile/components/loader_component.dart';
// import 'package:fuelred_mobile/helpers/api_helper.dart';
// import 'package:fuelred_mobile/models/cierreactivo.dart';
// import 'package:fuelred_mobile/models/product.dart';
// import 'package:fuelred_mobile/models/response.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../home/home_screen.dart';

// class ProductsScreen extends StatefulWidget {
//    final List<Product> cart;
//    final CierreActivo cierreActivo;
//    // ignore: use_key_in_widget_constructors
//    const ProductsScreen({ required this.cart, required this.cierreActivo });

//   @override
//   State<ProductsScreen> createState() => _ProductsScreenState();
// }

// class _ProductsScreenState extends State<ProductsScreen> {
//  List<Product> _products = [];
//   bool _showLoader = false;

 
//  @override  
//   void initState() {
//     super.initState();
//     _getProducts();
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: const Color(0xFF093094),
//         title: const Text('Productos'),              
//       ),
//       body: Center(
//         child: _showLoader ? const LoaderComponent(text: 'Por favor espere...') : _getContent(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () => _goAdd(),
//       ),              
//     );
//   }

//   Widget _noContent() {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.all(20),
//         child: const Text(
//            'No hay transacciones pendientes.',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold
//           ),
//         ),
//       ),
//     );
//   }

//    Widget _getContent() {
//     return _products.isEmpty 
//       ? _noContent()
//       : _getListView();
//   }

//    Widget _getListView() {
//     return RefreshIndicator(
//       onRefresh: _getProducts,
//       child: ListView(
//         children: _products.map((e) {
//           return Card(
//             child: InkWell(
//               onTap: () => _addToCart(e),
//               child: Container(                  
//                 margin: const EdgeInsets.all(10),
//                 padding: const EdgeInsets.all(5),
//                 child: Row(                  
//                   children: [
//                     ClipRRect(                     
//                       child: CachedNetworkImage(
//                         imageUrl: e.imageUrl,
//                         errorWidget: (context, url, error) => const Icon(Icons.error),
//                         fit: BoxFit.cover,
//                         height: 80,
//                         width: 80,
//                         placeholder: (context, url) => const Image(
//                           image: AssetImage('assets/Logo.png'),
//                           fit: BoxFit.cover,
//                           height: 80,
//                           width: 80,
//                         ),                         
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     e.detalle.toString(),
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold
//                                     ),
//                                   ),
//                                   const SizedBox(height: 5,),
//                                   Text(
//                                     'Inventario: ${e.inventario}', 
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold
//                                     ),
//                                   ),
//                                   const SizedBox(height: 5,),
//                                   Text(
//                                     'Precio: ${NumberFormat("###,000", "en_US").format(e.total)}', 
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold
//                                     ),
//                                   ),
//                                   const SizedBox(height: 5,),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const Icon(Icons.arrow_forward_ios),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }



//   Future<void> _getProducts() async {
//     setState(() {
//       _showLoader = true;
//     });
//     Response response = Response(isSuccess: false);
   
//     response = await ApiHelper.getProducts();
   

//     setState(() {
//       _showLoader = false;
//     });

//     if(!response.isSuccess){
//       await showAlertDialog(
//         context: context,
//         title: 'Error',
//         message: response.message,
//         actions: <AlertDialogAction>[
//           const AlertDialogAction(key: null, label: 'Aceptar'),
//           ]
//       );
//       return;
//     }   

//     setState(() {
//       _products = response.result;
//     });

//   }

//   _addToCart(Product e) {
//     e.images.add('assets/diesel.png');
//     e.images.add('assets/super.png');
//     e.images.add('assets/regular.png');
//     e.images.add('assets/exonerado.png');
//     e.colors.add(Colors.red);
//     e.colors.add(Colors.blueAccent); 

//     Navigator.pushReplacement(
//       context, 
//       MaterialPageRoute(
//         builder: (context) => ProductScreen(cart: widget.cart, product: e,)
//       )
//     );
//   }

//   _goAdd() {
//     // Navigator.pushReplacement(
//     //   context, 
//     //   MaterialPageRoute(
//     //     builder: (context) => HomeScreen(cierreActivo: widget.cierreActivo,)
//     //   )
//     // );
//   }
// }