import 'package:flutter/material.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/ad,min/detail_transfer.dart';
import 'package:intl/intl.dart';

class CardDetailTransfer extends StatelessWidget {
   final DetailTransfer detailTransfer;
  const CardDetailTransfer({super.key, required this.detailTransfer});

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.only(right: 5, left: 5),
            child: Card(

               color:  Colors.white,
                    shadowColor: const Color.fromARGB(255, 147, 192, 224),
                    elevation: 7,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), 
              child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                         

                             Text(
                              'Fecha: ${detailTransfer.fecha}', 
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87
                              ),
                            ),
                         
                          
                          
                            Text(
                             'Monto: ¢ ${NumberFormat("###,000", "en_US").format(detailTransfer.monto)}', 
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                 color: kPrimaryColor
                              ),
                            ),
                         
                            Text(
                                'Pistero:  ${detailTransfer.pistero}', 
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                 color: kPrimaryText
                              ),
                            ),

                             Text(
                                'Cierre #:  ${detailTransfer.cierre}', 
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                 color: kBlueColorLogo
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
