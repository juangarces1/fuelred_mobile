
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
 
 
  bool _showLoader = false;
  final bool _isFiltered = false;
  bool showTransfer = true;


  @override
  void initState() {
    super.initState();
    _getTransfers();
   // setUpTransfer();
  }
  
  @override
 Widget build(BuildContext context) {  
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: kPrimaryColor,
          title: const Text('Transferencias', style: TextStyle(color: kPrimaryColor),),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              color:   const Color.fromARGB(255, 70, 72, 77),
              child: Center(
                child: _showLoader ? const LoaderComponent(text: 'Por favor espere...') 
                : _getContent(),
              ),
            ),
            _showLoader ? const LoaderComponent(text: 'Por favor espere...') : Container(),
          ],
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




