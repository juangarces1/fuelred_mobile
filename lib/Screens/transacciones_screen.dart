
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/cierreactivo.dart';
import 'package:fuelred_mobile/models/product.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransaccionesScreen extends StatefulWidget {
  final CierreActivo cierreAct;
  final List<Product> cart;
  // ignore: use_key_in_widget_constructors
  const TransaccionesScreen({ required this.cierreAct, required this.cart});

  @override
  State<TransaccionesScreen> createState() => _TransaccionesScreenState();
}

class _TransaccionesScreenState extends State<TransaccionesScreen> {
  List<Product> _transacciones = [];
  bool _showLoader = false;

 @override  
  void initState() {
    super.initState();
    _getTransacciones();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFF093094),
        title: const Text('Transacciones'),              
      ),
      body: Center(
        child: _showLoader ? const LoaderComponent(text: 'Por favor espere...') : _getContent(),
      ),
                     
    );
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: const Text(
           'No hay transacciones pendientes.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

   Widget _getContent() {
    return _transacciones.isEmpty 
      ? _noContent()
      : _getListView();
  }

 
   Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getTransacciones,
      child: ListView(
        children: _transacciones.map((e) {
          return Card(
            child: InkWell(
              onTap: () => _addToCart(e),
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    ClipRRect(                     
                      child:   Image(
                        image: e.detalle =='Comb Super' ?  const AssetImage('assets/super.png') : 
                               e.detalle=='Comb Regular' ? const AssetImage('assets/regular.png') : 
                               e.detalle=='Comb Exonerado' ? const AssetImage('assets/exonerado.png') :
                               const AssetImage('assets/diesel.png'),
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80, 
                        
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dispensador: ${e.dispensador.toString()}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  'Cantidad: ${NumberFormat("###,000.000", "en_US").format(e.cantidad)}', 
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text(
                                  'Total: ${NumberFormat("###,000", "en_US").format(e.total)}', 
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                const SizedBox(height: 5,),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }



  Future<void> _getTransacciones() async {
    setState(() {
      _showLoader = true;
    });
    Response response = Response(isSuccess: false);
   
    response = await ApiHelper.getTransaccionesAsProduct(widget.cierreAct.cierreFinal.idzona);
   

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
      _transacciones = response.result;
    });
  }

  _addToCart(Product e) {   
    widget.cart.add(e);
  }

  getProportionateScreenHeight(int i) {}

  
}
