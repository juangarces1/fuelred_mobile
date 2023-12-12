

import 'package:flutter/material.dart';
import 'package:fuelred_mobile/Screens/Admin/Cartera/cliente_cartera_screen.dart';
import 'package:fuelred_mobile/Screens/Admin/ComponentsShared/app_bar_custom.dart';
import 'package:fuelred_mobile/components/my_loader.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/clientecredito.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:intl/intl.dart';

class CarteraScreen extends StatefulWidget {
  const CarteraScreen({super.key});

  @override
  State<CarteraScreen> createState() => _CarteraScreenState();
}

class _CarteraScreenState extends State<CarteraScreen> {

  List<ClienteCredito>? clientes;
  bool showLoader = false;
  bool isFiltered = false;
  double total=0;

  @override
  void initState() {
   
    super.initState();
    getClientes();
  }

  double getTotalSaldoPendiente() {
    return clientes!.fold(0, (total, cliente) => total + (cliente.saldoPendiente ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
        title: 'Cartera San Gerardo',
        automaticallyImplyLeading: true,   
        backgroundColor: kBlueColorLogo,
        elevation: 8.0,
        shadowColor: const Color.fromARGB(255, 207, 214, 218),
        foreColor: Colors.white,
         actions: [ Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipOval(child:  Image.asset(
                  'assets/splash.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),), // Ícono de perfil de usuario
            ),],
      ),
         body: Container(
          color: const Color.fromARGB(255, 70, 72, 77),
          child: Center(
            child: showLoader ? const CustomActivityIndicator(loadingText: 'Por favor espere...') : Padding(
              padding: const EdgeInsets.all(8.0),
              child: _getContent(),
            ),
          ),
        ), 

        bottomNavigationBar: Container(
             height: 50,
             color: kBlueColorLogo,
             child: Center(
               child: Text('Total: ${NumberFormat.currency(symbol: '¢').format(total)}', 
                   style: const TextStyle(
                     color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      ),),
             ),
           ), 
    ),
    );
  }

   Widget _getContent() {
    return clientes!.isEmpty 
      ? _noContent()
      : _getListView();
   }
   
   Widget _noContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Text(
          isFiltered
          ? 'No hay Clientes con ese criterio de búsqueda.'
          : 'No hay Clientes.',
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
      onRefresh: getClientes,
      child: ListView.builder(
       
      
         scrollDirection: Axis.vertical,      
       
          itemCount: clientes!.length,
          itemBuilder:  (context, index) => buildListTile(index)
         
          
      ),
    );
  }

  Widget buildListTile(int index){
    return  Card(
      elevation: 4, // Agrega sombra a la tarjeta
      margin: const EdgeInsets.all(5), // Espaciado alrededor de cada tarjeta
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.blueAccent), // Icono del usuario
        title: Text(
          clientes![index].nombre ?? 'Nombre no disponible',
          style: const TextStyle(fontWeight: FontWeight.bold), // Fuente personalizada para el nombre
        ),
        subtitle: Text(
          'Saldo Pendiente: ${NumberFormat.currency(symbol: '¢').format(clientes![index].saldoPendiente)}', 
          style: const TextStyle(color:kPrimaryText, fontWeight: FontWeight.bold), // Color personalizado para el subtítulo
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey), // Icono de flecha
        onTap: () => goDetails(index),
      ),
    );
  }
  
  Future<void> getClientes() async {
    setState(() {
      showLoader = true;
    });
    
    Response response = await ApiHelper.getClientesCredito();

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
      clientes = response.result;
      total = getTotalSaldoPendiente();
    });  

  }
  
  goDetails(int index) {
     Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => ClienteCarteraScreen(
         cliente: clientes![index],
       )),
     );
  }
}