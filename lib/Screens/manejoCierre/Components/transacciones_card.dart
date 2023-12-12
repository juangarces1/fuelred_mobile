import 'package:flutter/material.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/varios_helpers.dart';
import 'package:fuelred_mobile/models/transaccion.dart';
import 'package:fuelred_mobile/sizeconfig.dart';

class TransaccionCard extends StatelessWidget {
  final Transaccion transaccion;
  const TransaccionCard({super.key , required this.transaccion});

  @override
  Widget build(BuildContext context) {
     return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(              
                      color:  const Color.fromARGB(255, 216, 219, 225),
                      shadowColor: const Color.fromARGB(255, 16, 38, 54),
                      elevation: 7,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),                
                      child: Row(  
                        children: [
                           Container(                          
                             padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                             height: 120,
                             width: 120,                           
                             child: Ink.image(                        
                               image: 
                                 transaccion.nombreproducto =='Super' ?  const AssetImage('assets/super.png') : 
                                 transaccion.nombreproducto=='Regular' ? const AssetImage('assets/regular.png') : 
                                 transaccion.nombreproducto=='Exonerado' ? const AssetImage('assets/exonerado.png') : 
                                 const AssetImage('assets/diesel.png'),
                                   fit: BoxFit.cover,
                                 ),
                             ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               const SizedBox(height: 5),
                              Text.rich(
                                TextSpan(
                                  text: 'Numero: ${transaccion.idtransaccion}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.black),
                                                            
                                ),
                              ),                      
                             
                              Text.rich(
                                TextSpan(
                                  text: 'Forma Pago: ${transaccion.estado}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.black),
                                                            
                                ),
                              ),
                             
                              Text.rich(
                                TextSpan(
                                  text: 'Facturada: ${transaccion.facturada}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.black),
                                                            
                                ),
                              ),
                            
                              Text.rich(
                                TextSpan(
                                  text: 'Cantidad: ${transaccion.volumen}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, color: Colors.black),
                                                            
                                ),
                              ),
                            
                              Text.rich(
                                TextSpan(
                                    text: 'Monto: ${VariosHelpers.formattedToCurrencyValue(transaccion.total.toString())}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                                                            
                                ),
                              ),
                                const SizedBox(height: 5),
                            ],
                          )                        
                        ],
                        
                      ),
                ),
              );
         
        
  }
}