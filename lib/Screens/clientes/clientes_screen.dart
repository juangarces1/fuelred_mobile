
import 'package:flutter_svg/svg.dart';
import 'package:fuelred_mobile/Screens/cart/cart_new.dart';
import 'package:fuelred_mobile/Screens/checkout/checkount.dart';

import 'package:fuelred_mobile/Screens/clientes/clientes_add_screem.dart';
import 'package:fuelred_mobile/Screens/home/home_screen.dart';
import 'package:fuelred_mobile/Screens/tickets/ticket_screen.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';

import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/cliente.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:flutter/material.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/sizeconfig.dart';


class ClientesScreen extends StatefulWidget {
  final AllFact factura; 
  final String ruta;
  // ignore: use_key_in_widget_constructors
  const ClientesScreen({   
    required this.factura,
 
    required this.ruta,
   });
  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  List<Cliente> _users = [];
  List<Cliente> _backup = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
   
  static const values=<String>['Nombre','Documento'];
  String seletedValue=values.first;
  
  @override  
  void initState() {
    super.initState();
    _getUsers();
  }

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: appBar1(),
        ),
        body: Center(
          child: _showLoader ? const LoaderComponent(text: 'Cargando...') 
          : Container(
            color: kContrateFondoOscuro,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _getContent(),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () => _goAdd(),
          child: const Icon(Icons.add,
           color: Colors.white,
           size: 30,
           ),
        ),            
      ),
    );
  }

  Future<void> _getUsers() async {
    setState(() {
      _showLoader = true;
    });

    Response response = await ApiHelper.getClienteContado();

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
      _users = response.result;
      _backup = response.result;
    });
  }

   Widget _getContent() {
    return _users.isEmpty 
      ? _noContent()
      : _getListView();
  }
   
   Widget _noContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'No hay Usuarios con ese criterio de búsqueda.'
          : 'No hay Usuarios registradas.',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _getListView() {
    return ListView.separated(
       
          scrollDirection: Axis.vertical,                  
          itemCount: _users.length,
          separatorBuilder: (context, _) => const SizedBox(height: 5,),
          itemBuilder: (context, indice) => cardCLiente(_users[indice]),
          
      );
                         
  
  }
 
  Widget cardCLiente(Cliente e) {
    return  Card(
              color: kContrateFondoOscuro,
               shadowColor: kPrimaryColor,
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: InkWell(
                onTap: ()=> _goInfoUser(e),
                child: Container(
                  margin:  const EdgeInsets.all(10),
                  padding:  const EdgeInsets.all(5),
                  child: Column(
                    children: [                                     
                     Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    e.nombre, 
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                       color: kTextColorBlack,
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                    e.email, 
                                    style: const TextStyle(
                                      fontSize: 14,
                                       fontWeight: FontWeight.bold,
                                       color: kColorFondoOscuro,
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                    e.documento, 
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                       color: kColorFondoOscuro,
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
            ),
          );
  }
  
   Future  _showFilter() => showDialog(
     context: context,
     builder: (context) => StatefulBuilder(
       builder: (context, setState) => AlertDialog(
         shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Center(child: Text('Buscar Por...')),
         
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[            
               const SizedBox(height: 3,),                
                  const Divider(color: Colors.black, height: 11,),
                Column(
                  children: values.map(
                    (value) {
                      return  RadioListTile<String>(
                                value: value,
                                  groupValue: seletedValue,
                                  title:  Text(value),
                                  onChanged: (value) => setState(() => seletedValue = value as String),
                      );
                    }
                  ).toList(),
                ),
                 const Divider(color: Colors.black, height: 11,),            
                           
               const SizedBox(height: 10,),

              TextField(                            
                              
                decoration:  const InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: Icon(Icons.search,),
                 
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
              child: const Text(
                'Cancelar',
               )
            ),
            TextButton(
              onPressed: () => _filter(), 
              child: const Text(
                'Filtrar',
               )
            ),
          ],
        ),
       ),
   );

   void _removeFilter() {
    setState(() {
      _isFiltered = false;
      _users = _backup;
    });
  }

  void _filter() {
   if (_search.isEmpty) {
      return;
    }
    List<Cliente> filteredList = [];
    if(seletedValue=='Nombre'){
      for (var procedure in _users) {
        if (procedure.nombre.toLowerCase().contains(_search.toLowerCase())) {
          filteredList.add(procedure);
        }
      }
    }
    else{
       for (var procedure in _users) {
        if (procedure.documento.contains(_search)) {
          filteredList.add(procedure);
        }
      }
    }
    setState(() {
      _users = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }
 
 void _goInfoUser(Cliente clienteSel) async {
   
   widget.factura.clienteFactura=clienteSel;
   _goBack();
    
  }

  _goAdd() {
     Navigator.push(
       context,  
       MaterialPageRoute(
          builder: (context) =>  ClietesAddScreen(
            factura: widget.factura,  
            ruta: widget.ruta,         
          )
       ),
    );

  }

   Widget appBar1() {
   return Container(
    
     color: const Color.fromARGB(255, 219, 222, 224),
     child: Padding(
       padding:
           EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
            vertical: getProportionateScreenHeight(5)
            ),
       child: Row( 
         mainAxisAlignment: MainAxisAlignment.start,         
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
               onPressed: () => _goBack(),      
               child: SvgPicture.asset(
                 "assets/Back ICon.svg",
                 height: 15,
                 // ignore: deprecated_member_use
                 color: kPrimaryColor,
               ),
             ),
           ),
            const SizedBox(width: 20,),
           const Text('Cliente Contado', style: TextStyle(
             fontSize: 24,
             fontWeight: FontWeight.bold,
             color: kPrimaryColor,
           ),),
           const Spacer(),
               _isFiltered
           ?  IconButton(
               onPressed: _removeFilter, 
               icon: const Icon(Icons.filter_none)
             )
           :  IconButton(
               onPressed: _showFilter, 
               icon: const Icon(Icons.filter_alt)
             )
         ],
       ),
     ),
   );
 } 
 
 
 Future<void> _goBack() async {
  
  if(widget.ruta=='Cart'){
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
   if(widget.ruta=='Contado') {
     Navigator.pushReplacement(context,  
               MaterialPageRoute(
               builder: (context) => CheaOutScreen(
                  factura: widget.factura,                  
                 )
               ),
    );   
   }
    if(widget.ruta=='Home') {
     Navigator.pushReplacement(context,  
               MaterialPageRoute(
               builder: (context) => HomeScreen(
                  factura: widget.factura,                  
                 )
               ),
    );   
   }

   if(widget.ruta=='Ticket') {
     Navigator.pushReplacement(context,  
               MaterialPageRoute(
               builder: (context) => TicketScreen(
                  factura: widget.factura,                  
                 )
               ),
    );   
   }
  
 }


  Widget buildRadios() => Column(
    children: values.map(
      (value) {
        return  RadioListTile<String>(
                   value: value,
                    groupValue: seletedValue,
                    title:  Text(value),
                     onChanged: (value) => setState(() => seletedValue = value as String),
        );
      }
    ).toList(),
  );
}



    