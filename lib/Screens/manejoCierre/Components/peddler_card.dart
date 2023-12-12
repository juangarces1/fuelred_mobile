import 'package:flutter/material.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/peddler.dart';

class PeddlerCard extends StatelessWidget {
  final Peddler peddler;
  const PeddlerCard({super.key , required this.peddler});

  @override
  Widget build(BuildContext context) {
    return Card(
                color: kContrateFondoOscuro,
                shadowColor: kPrimaryColor,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [    
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              'Cliente: ${peddler.cliente!.nombre}',
                              style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16),
                              maxLines: 2,
                            ),
                                             
                            Text.rich(
                              TextSpan(
                                text: 'Producto: ${peddler.products![0].detalle}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: kPrimaryColor),
                                                          
                              ),
                            ),
                               Text.rich(
                              TextSpan(
                                text: 'Transaccion #: ${peddler.products![0].transaccion}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: kBlueColorLogo),
                                                          
                              ),
                            ),
                             Text.rich(
                              TextSpan(
                                text: 'Cantidad: ${peddler.products![0].cantidad}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: Colors.black),
                                                          
                              ),
                            ),
                             Text.rich(
                              TextSpan(
                                text: 'Orden: ${peddler.orden}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: Colors.black),
                                                          
                              ),
                            ),
                             Text.rich(
                              TextSpan(
                                text: 'Chofer: ${peddler.chofer}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: kPrimaryColor),
                                                          
                              ),
                            ),
                             Text.rich(
                              TextSpan(
                                text: 'Observaciones: ${peddler.observaciones}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: Colors.black),
                                                          
                              ),
                            ),
                             Text.rich(
                              TextSpan(
                                text: 'Km: ${peddler.km}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: Colors.black),
                                                          
                              ),
                            ),
                             Text.rich(
                              TextSpan(
                                text: 'Placa: ${peddler.placa}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: kBlueColorLogo),
                                                          
                              ),
                            ),
                           
                          ],
                        ),
                      ),
                    )
                  ],
                ),
             ),
              );
  }
}