import 'package:flutter/material.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/varios_helpers.dart';
import 'package:fuelred_mobile/models/sinpe.dart';
import 'package:fuelred_mobile/sizeconfig.dart';

class SinpeCaed extends StatelessWidget {
  final Sinpe sinpe;
  const SinpeCaed({super.key , required this.sinpe});

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
                                      image: AssetImage('assets/sinpe.png'),
                                      fit: BoxFit.fill,
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
                            sinpe.activo == 1 ? 'Estado: Aplicado' : 'Estado: Disponible',
                            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
                            maxLines:1,
                          ),
                          Text(
                            'Fecha: ${VariosHelpers.formatYYYYmmDD(sinpe.fecha)}',
                            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
                            maxLines:1,
                          ),
                          Text(
                            'Pistero: ${sinpe.nombreEmpleado}',
                            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700),
                            maxLines:1,
                          ),
                       
                          Text.rich(
                            TextSpan(
                                text: 'Monto: ${VariosHelpers.formattedToCurrencyValue(sinpe.monto.toString())}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, color: kPrimaryColor),
                                                        
                            ),
                          ),
                             Text(
                            'Nota: ${sinpe.nota}',
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                            maxLines: 3,
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