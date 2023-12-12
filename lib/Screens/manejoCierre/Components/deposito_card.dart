import 'package:flutter/material.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/varios_helpers.dart';
import 'package:fuelred_mobile/models/deposito.dart';
import 'package:fuelred_mobile/sizeconfig.dart';

class DepositoCard extends StatelessWidget {
  final Deposito deposito;
  const DepositoCard({super.key , required this.deposito});

  @override
  Widget build(BuildContext context) {
    return Card(
                  color: kContrateFondoOscuro,
                   shadowColor: Colors.blueGrey,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding
                  (
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 88,
                          child: AspectRatio(
                            aspectRatio: 0.88,
                            child: Container(
                              padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                              decoration: const BoxDecoration(
                                color: Color(0xFF392c74),
                                 borderRadius: BorderRadius.only(topLeft: Radius.circular(15) , bottomLeft: Radius.circular(15))
                              ),
                              child:  const Image(
                                          image: AssetImage('assets/deposito.png'),
                                      ),
                            ),
                          ),
                        ),                         
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deposito.moneda.toString(),
                                style: const TextStyle(color: Colors.black, fontSize: 16),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 10),
                              Text.rich(
                                TextSpan(
                                  text: 'Monto: ${VariosHelpers.formattedToCurrencyValue(deposito.monto.toString())}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700, color: kPrimaryColor),
                                                            
                                ),
                              )                      
                            ],
                          ),
                        )                
                      ],
                    ),
                  ),
                );
  }
}