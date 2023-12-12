import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelred_mobile/Screens/cart/cart_new.dart';
import 'package:fuelred_mobile/Screens/checkout/checkount.dart';
import 'package:fuelred_mobile/Screens/clientes/clientes_add_screem.dart';
import 'package:fuelred_mobile/Screens/home/home_screen.dart';
import 'package:fuelred_mobile/Screens/tickets/ticket_screen.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/cliente.dart';

class ClientesNewScreen extends StatefulWidget {
  final AllFact factura; 
  final String ruta;

  const ClientesNewScreen({   
    Key? key,
    required this.factura,
    required this.ruta,
  }) : super(key: key);

  @override
  ClientesNewScreenState createState() => ClientesNewScreenState();
}

class ClientesNewScreenState extends State<ClientesNewScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Cliente> _users = [];
  final List<Cliente> _filterUsers = [];
  
  String _searchNombre = '';
  String _searchDocument = '';
  bool _isFiltered = false; 
 
  TextStyle baseStyle = const TextStyle(
    fontStyle: FontStyle.normal, 
    fontSize: 20,
    fontWeight: FontWeight.bold, 
    color: Colors.white
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Aquí va tu lógica inicial...
    setState(() {
      _users=widget.factura.clientesFacturacion;
      
   });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
   
      child: Scaffold(
        appBar:  AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 6.0,
          shadowColor: Colors.white,

            title:  Text('Cliente Contado', style: baseStyle,),
            
            leading: Padding(
                    padding: const EdgeInsets.all(8.0), // Adjust padding as needed
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
             ),),
         
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipOval(child:  Image.asset(
                    'assets/splash.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),), // Ícono de perfil de usuario
              ),
            ],
            bottom:  TabBar(
              indicatorColor: Colors.white,
              controller: _tabController,
              labelColor: Colors.white, // Color for selected tab
              unselectedLabelColor: Colors.grey, // Color for unselected tabs
              tabs:  const [
                Tab(text: 'Buscar Por'),
                Tab(text: 'Resultados'),
              ],
            ),
          ),

        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFilterTab(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: _getContent(),
            ),
          ],
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
 
  Widget _buildFilterTab() {
  return SizedBox(
    width: double.infinity, // Ocupa todo el ancho disponible
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
           Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '# Documento',
                     
                    ),
                    onChanged: (value) {
                      _searchDocument = value;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: kPrimaryColor,
                      elevation: 5.0,
                    ),
                    onPressed: _filterByDocument, 
                    child: const Text('Buscar'),
                  ),
                ),

                
              ],
            ),
            
            
          ),
           Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      
                    ),
                    onChanged: (value) {
                      _searchNombre = value;
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                      foregroundColor: kPrimaryColor,
                      elevation: 5.0,
                    ),
                    onPressed: _filterByName, 
                    child: const Text('Buscar'),
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

  void _filterByName() {
      setState(() {
         _isFiltered=true;
         _filterUsers.clear();
      });

     
   for (var cliente in _users) {
        if (cliente.nombre.toLowerCase().contains(_searchNombre.toLowerCase())) {
          _filterUsers.add(cliente);
        }
      }
   if (_filterUsers.isNotEmpty) {
        setState(() {
         _filterUsers;
        
        });
       _tabController.animateTo(1);
    } 
   }

  void _filterByDocument() {
   setState(() {
    _isFiltered=true;
    _filterUsers.clear();
   });
  
   for (var cliente in _users) {
      if (cliente.documento.contains(_searchDocument)) {
        _filterUsers.add(cliente);
      }
    }
 
   if (_filterUsers.isNotEmpty) {
        setState(() {
         _filterUsers;
        });
       _tabController.animateTo(1);
    } 
   }
   
  Widget _getContent() {
    return _filterUsers.isEmpty 
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
          itemCount: _filterUsers.length,
          separatorBuilder: (context, _) => const SizedBox(height: 8,),
          itemBuilder: (context, indice) => cardCLiente(_filterUsers[indice]),
          
      );
                         
  
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

  Future<void> _goBack() async {
  
  if(widget.ruta=='Cart'){
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
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                       color: kTextColorBlack,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                 
                                  Text(
                                    e.email, 
                                    style: const TextStyle(
                                      fontSize: 15,
                                       fontWeight: FontWeight.bold,
                                       color: kColorFondoOscuro,
                                    ),
                                  ),
                                 
                                  Text(
                                    e.documento, 
                                    style: const TextStyle(
                                      fontSize: 15,
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
}
