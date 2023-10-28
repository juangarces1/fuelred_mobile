
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/facturas/detale_factura_screen.dart';
import 'package:fuelred_mobile/clases/impresion.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:intl/intl.dart';

import '../../components/appbarbottom.dart';
import '../../components/loader_component.dart';


import '../../models/resdoc_facturas.dart';
import '../../models/response.dart';
import '../login_screen.dart';

class FacturasScreen extends StatefulWidget {
  final AllFact factura;

  final String tipo;
  // ignore: use_key_in_widget_constructors
  const FacturasScreen({   
    required this.factura,
  
    required this.tipo,
   });

  @override
  State<FacturasScreen> createState() => _FacturasScreenState();
}

class _FacturasScreenState extends State<FacturasScreen> {
  List<resdoc_facturas> _facturas = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  double _saldo = 0;  
  final bool _showNotch = true;
  final FloatingActionButtonLocation _fabLocation = FloatingActionButtonLocation.endDocked;
  

  @override
   void initState() {
    super.initState();    
    _getFacturas();
  }

 
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlueColorLogo,
        title:  Text('Facturas ${widget.tipo}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
        actions: <Widget>[
          _isFiltered
          ?  IconButton(
              onPressed: _removeFilter, 
              icon: const Icon(Icons.filter_none, color: Colors.white,)
            )
          :  IconButton(
              onPressed: _showFilter, 
              icon: const Icon(Icons.filter_alt, color: Colors.white,)
            )
        ],      
      ),
      body: Container(
        color: const Color.fromARGB(255, 70, 72, 77),
        child: Center(
          child: _showLoader ? const LoaderComponent(text: 'Por favor espere...') : Padding(
            padding: const EdgeInsets.all(8.0),
            child: _getContent(),
          ),
        ),
      ), 

       
     
      bottomNavigationBar: DemoBottomAppBar(
          fabLocation: _fabLocation,
          shape: _showNotch ? const CircularNotchedRectangle() : null, 
          total: _saldo,
        ),    
    );
  }

  
  Future<void> _getFacturas() async {
    setState(() {
      _showLoader = true;
    });
    Response response = Response(isSuccess: false);

    if(widget.tipo=='Contado'){
      response = await ApiHelper.getFacturasByCierre(widget.factura.cierreActivo.cierreFinal.idcierre);

    }
    else{
       response = await ApiHelper.getFacturasCredito(widget.factura.cierreActivo.cierreFinal.idcierre);
    }
   
    
   

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
      _facturas = response.result;
      

    });  
    double aux=0;
    
    for(var i=0; i<_facturas.length; i++){
      if(_facturas[i].tipoDocumento=="00003"){
          aux +=  _facturas[i].totalFactura??0;
      }         
    }

    setState(() {
      _saldo = aux;      
    }); 

  }

   Widget _getContent() {
    return _facturas.isEmpty 
      ? _noContent()
      : _getListView();
   }
   
   Widget _noContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'No hay facturas con ese criterio de búsqueda.'
          : 'No hay facturas registradas.',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
   }

  _getListView() {
      return RefreshIndicator(
      onRefresh: _getFacturas,
      child: ListView.builder(
       
      
         scrollDirection: Axis.vertical,      
       
          itemCount: _facturas.length,
          itemBuilder:  (context, index) => buildCard(index)
         
          
      ),
    );
  }

  Widget buildCard(int index){
    return Card(              
        shadowColor: const Color.fromARGB(255, 0, 2, 3),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
        
          padding:  const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 204, 202, 219),
            borderRadius: BorderRadius.circular(20), 
          
          ),
          child: Column(
            children: [                                     
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      _facturas[index].cliente=='' ?        const Text('Ticket Electronico' ,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ):
                           Text(
                           _facturas[index].cliente, 
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            'Numero: ${_facturas[index].nFactura}', 
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:kTextColorBlack,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            'Fecha: ${_facturas[index].fechaHoraTrans}', 
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:kTextColorBlack,
                            ),
                          ),
                        
                          const SizedBox(height: 5,),
                          Text(
                            'Productos: ${_facturas[index].detalles.length}', 
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:kTextColorBlack,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            'Total: ${NumberFormat.currency(symbol: '¢').format(_facturas[index].totalFactura)}', 
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kTextColorBlack,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[                                       
                                
                              MaterialButton( 
                                onPressed: () => _goInfoFactura(_facturas[index]),                                    
                                color: kBlueColorLogo,
                                padding: const EdgeInsets.all(5),
                                shape: const CircleBorder(),
                                child:    const Icon( 
                                  Icons.list_outlined,
                                  size: 20,
                                  color: Colors.white,),
                                ),
                              MaterialButton( 
                                onPressed: () => _printFactura(_facturas[index]),                                    
                                color: Colors.blueGrey,
                                padding: const EdgeInsets.all(5),
                                shape: const CircleBorder(),
                                child:    const Icon( 
                                  Icons.print_outlined,
                                  size: 20,
                                  color: Colors.white,),
                                ),
                                  MaterialButton( 
                                onPressed: () => _showConfirm(_facturas[index].nFactura),                                    
                                color: kPrimaryColor,
                                padding: const EdgeInsets.all(5),
                                shape: const CircleBorder(),
                                child:    const Icon( 
                                  Icons.arrow_back,
                                  size: 20,
                                  color: Colors.white,),
                                ),                                   
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),                    
          ],
        ),
        ),
    );
  }

  
  void _showFilter() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Filtrar Facturas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Escriba los primeros numeros'),
              const SizedBox(height: 10,),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: Icon(Icons.search)
                ),
                onChanged: (value) {
                  _search = value;
                },
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text('Cancelar')
            ),
            TextButton(
              onPressed: () => _filter(), 
              child: const Text('Filtrar')
            ),
          ],
        );
      });
  }

   void _showConfirm(String numfact) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Devolucion Factura'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
               Text('Desea realizar la devolucion de la factura # $numfact?'),
              const SizedBox(height: 10,),
             
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text('Cancelar')
            ),
            TextButton(
              onPressed: () => _goDevolucion(numfact), 
              child: const Text('Aceptar')
            ),
          ],
        );
      });
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getFacturas();
  }

 

  void _filter() {
    if (_search.isEmpty) {
      return;
    }

    List<resdoc_facturas> filteredList = [];
    for (var procedure in _facturas) {
      if (procedure.nFactura.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(procedure);
      }
    }

    setState(() {
      _facturas = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  _goInfoFactura(resdoc_facturas e) {
     Navigator.push(
        context, 
        MaterialPageRoute(
            builder: (context) => DetalleFacturaScreen(factura: e,)
        )
      );
  }

  Future<void> _goDevolucion(String num) async {
    Navigator.of(context).pop();
    var n = int.parse(num);
    if(n  >6000000000 && n < 6999999999){
       
        if (mounted) {         
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content:  const Text('No se puede hacer devolución sobre una devolución'),
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
      _showLoader = true;
    });  

      Response response = await ApiHelper.postNoRequest('Api/Facturacion/Devolucion/$num');  

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
          msg: "Devolucion creada con exito",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
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
  
  _printFactura(resdoc_facturas e) {
    e.usuario ='${widget.factura.cierreActivo.usuario.nombre} ${widget.factura.cierreActivo.usuario.apellido1}'; 
    String tipoDocumento = e.cliente=='' ? 'TICKET' : 'FACTURA';
    String tipoPago = e.plazo==0 ? 'CONTADO' : 'CREDITO';
    Impresion.printFacturaContado(e, tipoPago , tipoDocumento);
  }
}
