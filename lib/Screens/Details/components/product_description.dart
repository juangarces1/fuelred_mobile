import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/product.dart';
import 'package:flutter/material.dart';

import '../../../sizeconfig.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    super.key,
    required this.product,
    this.pressOnSeeMore,
  });

  final Product product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Center(
            child: Text(
              product.detalle,
              style: const TextStyle(color: kContrateFondoOscuro, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        
        
      ],
    );
  }
}