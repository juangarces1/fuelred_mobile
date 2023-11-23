
import 'package:flutter/material.dart';
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
        appBar: AppBar(
          foregroundColor: kPrimaryColor,
          title: const Text('Transferencias',
           style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor
                ),),
          actions: <Widget>[
            IconButton(
            icon: Icon(_isFiltered ? Icons.filter_list : Icons.search),
            onPressed: _showSearchDialog,
          ),
          ],
        ),
        body: Container(
          color:   const Color.fromARGB(255, 70, 72, 77),
          child: Center(
            child: _showLoader ? const LoaderComponent(text: 'Por favor espere...') 
            : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _getContent(),
            ),
          ),
        ),
      
      
      ),
    );
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




