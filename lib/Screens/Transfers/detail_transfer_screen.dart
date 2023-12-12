import 'package:flutter/material.dart';
import 'package:fuelred_mobile/Screens/Admin/ComponentsShared/app_bar_custom.dart';
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
        backgroundColor: kContrateFondoOscuro,
        appBar:  MyCustomAppBar(
        title: 'Cartera San Gerardo',
        automaticallyImplyLeading: true,   
        backgroundColor: kPrimaryColor,
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
        body: Column(
          children: <Widget>[
           Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CardTransfer(transfer: transfer, showDetail: false,),
              ),
            ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text('Movimientos de la transferencia',
                    style: myHeadingStyleBlack),
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