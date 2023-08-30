import 'package:fuelred_mobile/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import '../../../sizeconfig.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
 // ignore: use_key_in_widget_constructors
 const PopularProducts({   
    required this.factura,   
  });
  final AllFact factura;  
  @override
  Widget build(BuildContext context) {    
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Aceites & Otros", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(10)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: 
            [
              ...List.generate(
                factura.productos.length,
                (index) {                 
                    return ProductCard(
                      product: factura.productos[index],
                      factura: factura,                     
                    );                 
                },
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        )
      ],
    );
  }
}
