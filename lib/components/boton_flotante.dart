
import 'package:flutter/material.dart';
import 'package:fuelred_mobile/components/show_cart.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

class FloatingButtonWithModal extends StatelessWidget {
  final AllFact factura;

  const FloatingButtonWithModal({super.key, required this.factura});

  
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
          onPressed: () =>showModalBottomSheet(
            backgroundColor: kColorFondoOscuro,
            context: context,
            builder: (context) {
              return ShowCart(factura: factura);
            },
          ),
          backgroundColor: kContrateFondoOscuro,
           elevation: 8,
          child: const Icon(Icons.shopping_cart, size: 30, color: Colors.black,),
        );
  }
}