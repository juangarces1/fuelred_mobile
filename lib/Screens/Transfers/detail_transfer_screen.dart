import 'package:flutter/material.dart';
import 'package:fuelred_mobile/Screens/Transfers/ciompoents/card_detail_transfer.dart';
import 'package:fuelred_mobile/Screens/Transfers/ciompoents/card_transfer.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/ad,min/transferfull.dart';

class DetailTransferScreen extends StatelessWidget {
  final TransferFull transfer;
  const DetailTransferScreen({super.key, required this.transfer});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 70, 72, 77),
        appBar: AppBar(
          foregroundColor: kPrimaryColor,
          title: const Text('Detalle de transferencia', style:  TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor
                ),),
        ),
        body: Column(
          children: <Widget>[
           Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CardTransfer(transfer: transfer, showDetail: false,),
              ),
            ),
             const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text('Movimientos de la transferencia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
            ),
            Expanded(
              flex: 2, // Ajusta la proporción si es necesario
              child: _getListView(),
            ),
          ],
        ),
      ),
      );
    
  }

   Widget _getListView() {
    return ListView(
      children: transfer.descuentos!.map((e) {
        return CardDetailTransfer(detailTransfer: e,);
      }).toList(),
    );
  }
}