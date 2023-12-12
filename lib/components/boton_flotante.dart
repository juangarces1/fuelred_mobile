
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
          child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: kPrimaryColor, // Ajusta el color como necesites
                borderRadius: BorderRadius.circular(10), // Los bordes redondeados
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Asegura que la imagen también tenga bordes redondeados
                child: Image.asset(
                  'assets/MyCart.png',
                  fit: BoxFit.cover, // Esto hace que la imagen se ajuste al tamaño del contenedor
                ),
              ),),
        );
  }
}