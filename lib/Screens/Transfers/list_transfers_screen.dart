
import 'package:flutter/material.dart';
import 'package:fuelred_mobile/Screens/Admin/ComponentsShared/app_bar_custom.dart';
import 'package:fuelred_mobile/Screens/Transfers/add_transfer_screen.dart';
import 'package:fuelred_mobile/Screens/Transfers/ciompoents/card_transfer.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/ad,min/transferfull.dart';

import '../../components/loader_component.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';


class ListTransferScreen extends StatefulWidget {


  // ignore: use_key_in_widget_constructors
  const ListTransferScreen();

  @override
  State<ListTransferScreen> createState() => _ListTransferScreenState();
}

 class _ListTransferScreenState extends State<ListTransferScreen> {
  List<TransferFull> _transfers =[];
   // Controlador para el TextField de búsqueda
  final TextEditingController _searchController = TextEditingController();

  // Lista para almacenar las transferencias filtradas
  List<TransferFull> _filteredTransfers = [];
   List<TransferFull> _backupLits = [];
 
 
  bool _showLoader = false;
  bool _isFiltered = false;
  bool showTransfer = true;
  double total = 0;


  @override
  void initState() {
    super.initState();
    _getTransfers();
    

    // Agrega un listener al controlador para actualizar _filteredTransfers
    // cada vez que el usuario cambie la consulta de búsqueda
    _searchController.addListener(_searchTransfers);
  }

   @override
  void dispose() {
    // No olvides deshacerte del controlador cuando ya no lo necesites
    _searchController.dispose();
    super.dispose();
  }

  void _searchTransfers() {
    String query = _searchController.text;

    // Filtra las transferencias basándote en la consulta de búsqueda
    _filteredTransfers = _transfers.where((transfer) {
      return transfer.cliente!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Actualiza el estado para reflejar los cambios en la UI
    setState(() {
      _transfers = _filteredTransfers;
       _isFiltered = query.isNotEmpty;
    });
  }

  void _showSearchDialog() {
  if (_isFiltered) {
    // Si la lista está filtrada, restablece la lista y el icono
    setState(() {
      _transfers = _backupLits;
      _isFiltered = false;
      _searchController.clear();
    });
  } else {
    // Si la lista no está filtrada, muestra el diálogo de búsqueda
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Buscar por cliente'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Nombre del cliente',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Buscar'),
              onPressed: () {
                _searchTransfers();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
  
  @override
 Widget build(BuildContext context) {  
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
        title: 'Transferencias',
        automaticallyImplyLeading: true,   
        backgroundColor: kBlueColorLogo,
        elevation: 8.0,
        shadowColor: const Color.fromARGB(255, 216, 223, 226),
        foreColor: Colors.white,
         actions: [
            IconButton(
              icon: Icon(_isFiltered ? Icons.filter_alt_off : Icons.filter_alt, color: Colors.white,),
              onPressed: _showSearchDialog,
            ),
           Padding(
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
          color:   kContrateFondoOscuro,
          child: Center(
            child: _showLoader ? const LoaderComponent(text: 'Por favor espere...') 
            : Padding(
              padding: const EdgeInsets.only(top: 15),
              child: _getContent(),
            ),
          ),
        ),
        
       
        floatingActionButton: FloatingActionButton(
          
          backgroundColor: kPrimaryColor,
          onPressed: () => _goAdd(),
          
          child: const Icon(Icons.add, size: 35, color: Colors.white,),
          
        ),
      
      ),
    );
  }

   void _goAdd() async {
    final resultado = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTransferScreen()),
        );

        // Si se recibe un dato de retorno, recargar la lista
        if (resultado != null) {
          _getTransfers();
        }
  }
 
 Future<void> _getTransfers() async {
    setState(() {
      _showLoader = true;
    });

   
    Response response = await ApiHelper.getTransferfull();

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
      _transfers = response.result;
      _backupLits = response.result;
    });
   
  }

 Widget _getContent() {
    return _transfers.isEmpty 
      ? _noContent() : _getListView();
     
  }

 Widget _noContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'No hay transferencias con ese criterio de búsqueda.'
          : 'No hay transferencias registradas.',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

 Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getTransfers,
      child: ListView(
        children: _transfers.map((e) {
          return CardTransfer(transfer: e, showDetail: true,);
        }).toList(),
      ),
    );
  }
 
  void orderTransfer() {
    _transfers.sort((a, b) {
      return a.cliente!.compareTo(b.cliente!);
    });
  }
  
}




