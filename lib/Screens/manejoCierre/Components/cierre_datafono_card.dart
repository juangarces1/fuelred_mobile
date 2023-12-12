import 'package:flutter/material.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/varios_helpers.dart';
import 'package:fuelred_mobile/models/cierredatafono.dart';
import 'package:fuelred_mobile/sizeconfig.dart';

class CierreDatafonoCard extends StatelessWidget {
  final CierreDatafono cierre;
  const CierreDatafonoCard({super.key , required this.cierre});

  @override
  Widget build(BuildContext context) {
     return Card(
                color: kContrateFondoOscuro,
               shadowColor: Colors.blueGrey,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 88,
                      child: AspectRatio(
                        aspectRatio: 0.88,
                        child: Container(
                          padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6F9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child:  const Image(
                                      image: AssetImage('assets/data.png'),
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
                            cierre.banco ?? "",
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                            maxLines: 2,
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Datafono: ${cierre.terminal}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, color: kTextColor),
                                                        
                            ),
                          ),
                           Text.rich(
                            TextSpan(
                              text: 'Lote : ${cierre.idcierredatafono}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, color: kTextColor),
                                                        
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                               text: 'Monto: ${VariosHelpers.formattedToCurrencyValue(cierre.monto.toString())}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, color: kPrimaryColor),
                                                        
                            ),
                          ),
                         
                        ],
                      ),
                    )
                  ],
                ),
             ),
              );
  }
}