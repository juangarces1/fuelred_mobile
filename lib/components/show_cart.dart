import 'package:flutter/material.dart';
import 'package:fuelred_mobile/Screens/cart/components/cart_card.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

class ShowCart extends StatelessWidget {
  final AllFact factura;
  const ShowCart({super.key, required this.factura});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
       
        decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 136, 133, 133),
              width: 2.0,
              style: BorderStyle.solid
            ),
            borderRadius: BorderRadius.circular(20),
            color: kColorFondoOscuro
          ),
        padding: const EdgeInsets.all(10),
       
        child: ListView.builder(
          itemCount: factura.cart!.products.length,
          itemBuilder: (context, index) {
           return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: 
             CartCard(product: factura.cart!.products[index],)
           );  
          },    
        ),
      ),
    );
  }
}