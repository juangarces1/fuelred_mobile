
import 'package:fuelred_mobile/components/transaccion_card.dart';
import 'package:flutter/material.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import '../../../sizeconfig.dart';
import 'section_title.dart';

class TransactioProducts extends StatefulWidget {
 // ignore: use_key_in_widget_constructors
 const TransactioProducts({   
    required this.factura,  
  });
  final AllFact factura;
  @override
  State<TransactioProducts> createState() => _TransactioProductsState();
}

class _TransactioProductsState extends State<TransactioProducts> {
  @override
  Widget build(BuildContext context) {
    widget.factura.transacciones.sort((a, b) => b.transaccion.compareTo(a.transaccion));
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Combustible", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(10)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: 
            [
              ...List.generate(
                widget.factura.transacciones.length,
                (index) {                 
                    return TransactionCard(
                      product: widget.factura.transacciones[index],
                      factura: widget.factura,
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
