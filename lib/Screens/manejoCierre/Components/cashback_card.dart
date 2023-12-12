import 'package:flutter/material.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/varios_helpers.dart';
import 'package:fuelred_mobile/models/cashback.dart';
import 'package:fuelred_mobile/sizeconfig.dart';

class CashbackCard extends StatelessWidget {
  final Cashback cashback;
  const CashbackCard({super.key, required this.cashback});

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
                                      image: AssetImage('assets/cbs.png'),
                                  ),
                        ),
                      ),
                    ),                         
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Banco Nacional',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 10),
                           Text.rich(
                              TextSpan(
                                text: 'Monto: ${VariosHelpers.formattedToCurrencyValue(cashback.monto.toString())}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: kPrimaryColor),
                                                          
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