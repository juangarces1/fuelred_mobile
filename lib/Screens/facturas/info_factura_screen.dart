import 'package:flutter/material.dart';
import 'package:fuelred_mobile/Screens/Admin/ComponentsShared/app_bar_custom.dart';
import 'package:fuelred_mobile/Screens/cart/components/cart_card.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/resdoc_facturas.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:intl/intl.dart';

class InfoFacturaScreen extends StatefulWidget {
  final String numeroFactura;
  const InfoFacturaScreen({super.key, required this.numeroFactura});

  @override
  State<InfoFacturaScreen> createState() => _InfoFacturaScreenState();
}

class _InfoFacturaScreenState extends State<InfoFacturaScreen> {
 bool showLoader = false;  
 resdoc_facturas factura= resdoc_facturas(
  //plazo:0,
  cliente: '',
  nFactura: '',
  fechaHoraTrans: DateTime.now(),
  detalles: [],
  totalImpuesto: 0,
  totalFactura: 0,

  // Otros campos pueden ser dejados como null o proporcionar un valor por defecto
);

   @override
   void initState() {   
     super.initState();
     getFactura();
   }

  @override
  Widget build(BuildContext context) {
    return   SafeArea(
      child:Scaffold(
        appBar:  MyCustomAppBar(
          title: widget.numeroFactura,
          automaticallyImplyLeading: true,   
          backgroundColor: kBlueColorLogo,
          elevation: 8.0,
          shadowColor: Colors.blueGrey,
          foreColor: Colors.white,
      ),
        body: Container(
          color: kColorFondoOscuro,
          child: Center(
            child: showLoader 
              ? const LoaderComponent(text: 'Por favor espere...',) 
              : factura.cliente != '' ? _getContent() : _noContent(),
          ),
        ),      
       
      ),
    );
  }

    Widget _getContent() {
     return Container(
       color: const Color.fromARGB(255, 243, 239, 239),
       child: Column(
         children: <Widget>[          
           const SizedBox(height: 5,),     
           _showHeader(),
           const SizedBox(height: 5,),    
          factura.detalles.isEmpty
           ? Container() 
           : const Text('Detalle de la Factura',
               style: TextStyle(
                 fontSize: 20,
                 fontWeight: FontWeight.bold,
                 color: kPrimaryColor,
               ),
             ),
           Expanded(
             child: factura.detalles.isEmpty ? _noContent() : _getProducts(),
           ),
         ],
       ),
     );
   }

  _showHeader() {
   return Padding(
     padding: const EdgeInsets.all(10.0),
       child: Card(
         color: kColorFondoOscuro,
          shadowColor: const Color.fromARGB(255, 0, 2, 3),
                 elevation: 8,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
         child: InkWell(        
           child: Container(
             margin: const EdgeInsets.all(10),
             padding: const EdgeInsets.all(5),
         
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               children: <Widget> [ 
                 const Center(child: Text('Info Factura', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.white),)),
                 const SizedBox(height: 5,),
                 Row(                        
                   children: [                          
                     const Text(
                       'Cliente: ', 
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                           color: Color(0xFFE5E8EC),
                       ),
                     ),
                     Expanded(
                       child: Text(
                         factura.cliente, 
                         style: const TextStyle(
                           fontSize: 14,                      
                           color: Color(0xFFE5E8EC),
                         ),
                       ),
                     ),
                  
                   ],
                 ),
                 const SizedBox(height: 5,),
                          Row(                        
               children: [                          
                 const Text(
                   'Email: ', 
                   style: TextStyle(
                         fontWeight: FontWeight.bold,
                         color: Color(0xFFE5E8EC),
                     ),
                   ),
                   Expanded(
                     child: Text(
                       factura.email??'', 
                       style: const TextStyle(
                         fontSize: 14,                      
                         color: Color(0xFFE5E8EC),
                       ),
                     ),
                   ),
                
                 ],
               ),
             const SizedBox(height: 5,),
             Row(
                
                   children: [
                     const Text(
                       'Fecha: ', 
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                            color: Color(0xFFE5E8EC),
                       ),
                     ),
                     Text(
                      DateFormat.yMd().add_jm().format(factura.fechaHoraTrans),    
                       style: const TextStyle(
                         fontSize: 14,
                          color: Color(0xFFE5E8EC),
                       ),
                     ),
                  
                   ],
                 ),
                 const SizedBox(height: 5,),
                 Row(                        
                   children: [
                     const Text(
                       'Kilometraje: ', 
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                            color: Color(0xFFE5E8EC),
                       ),
                     ),
                     Text(
                      factura.kilometraje.toString(), 
                       style: const TextStyle(
                         fontSize: 14,
                          color: Color(0xFFE5E8EC),
                       ),
                     ),                          
                   ],
                 ),
                 const SizedBox(height: 5,),
                 Row(                        
                   children: [
                     const Text(
                       'Placa: ', 
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                            color: Color(0xFFE5E8EC),
                       ),
                     ),
                     Text(
                       factura.nPlaca.toString(), 
                       style: const TextStyle(
                         fontSize: 14,
                          color: Color(0xFFE5E8EC),
                       ),
                     ),                          
                   ],
                 ),
                 const SizedBox(height: 5,),
                 Row(                         
                   children: [
                     const Text(
                       'Impuesto: ', 
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                            color: Color(0xFFE5E8EC),
                       ),
                     ),
                     Text(
                     NumberFormat.currency(symbol: '¢').format(factura.totalImpuesto), 
                       style: const TextStyle(
                         fontSize: 14,
                          color: Color(0xFFE5E8EC),
                       ),
                     ),                          
                   ],
                 ),
                 const SizedBox(height: 5,),
                 Row(                        
                   children: [
                     const Text(
                       'Total: ', 
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                         fontSize: 17,

                            color: Color(0xFFE5E8EC),
                       ),
                     ),
                     Text(
                       NumberFormat.currency(symbol: '¢').format(factura.totalFactura),
                       style: const TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                          color: kPrimaryText,
                       ),
                     ),                          
                   ],
                 ),    
                factura.plazo! > 0 ? Row(                        
                   children: [
                     const Text(
                       'Saldo: ', 
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                         fontSize: 17,

                            color: Color(0xFFE5E8EC),
                       ),
                     ),
                     Text(
                       NumberFormat.currency(symbol: '¢').format(factura.totalFactura),
                       style: const TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                       ),
                     ),                          
                   ],
                 ) : Container(),    
                   factura.plazo! > 0 ? Row(                        
                   children: [
                     const Text(
                       'Dias en Mora: ', 
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                         fontSize: 17,

                            color: Color(0xFFE5E8EC),
                       ),
                     ),
                     Text(
                       factura.diasEnMora.toString(),
                       style: const TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                          color:  Color(0xFFE5E8EC),
                       ),
                     ),                          
                   ],
                 ) : Container(),                       
            
             
               ],
             ),
           ),
         ),
       ),
     );
   }

    Widget _noContent() {
     return Center(
       child: Container(
         margin: const EdgeInsets.all(20),
         child: const Text(          
            'No hay factura con ese numero.',
           style: TextStyle(
             fontSize: 16,
             fontWeight: FontWeight.bold,
              color: Colors.white,
           ),
         ),
       ),
     );
   }

  Widget _getProducts() {
     return Padding(
       padding: const EdgeInsets.all(10.0),
       child: Container(
     
         decoration: BoxDecoration(
             border: Border.all(
               color: const Color.fromARGB(255, 136, 133, 133),
               width: 2.0,
               style: BorderStyle.solid
             ),
             borderRadius: BorderRadius.circular(20),
             color: kColorFondoOscuro
           ),
         padding: const EdgeInsets.all(10),
     
         child: ListView.builder(
           itemCount: factura.detalles.length,
           itemBuilder: (context, index) {
            return Padding(
             padding: const EdgeInsets.symmetric(vertical: 10),
             child: 
              CartCard(product: factura.detalles[index],)
            );  
           },    
         ),
       ),
     );
   }
  
  Future<void> getFactura() async {
     setState(() {
       showLoader = true;
     });
       Response response = await ApiHelper.getFactura(widget.numeroFactura);
      setState(() {
          showLoader = false;
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
            factura = response.result;
          });
      }
}