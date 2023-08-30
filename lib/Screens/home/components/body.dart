
import 'package:fuelred_mobile/Screens/home/components/transaction_product.dart';

import 'package:flutter/material.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import '../../../sizeconfig.dart';
import 'home_header.dart';
import 'popular_product.dart';

class Body extends StatefulWidget  {
  final AllFact factura;  
  // ignore: use_key_in_widget_constructors
  const Body({     
    required this.factura,    
  });
 @override
  State<Body> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<Body> { 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            HomeHeader(factura: widget.factura,),
            SizedBox(height: getProportionateScreenWidth(10)),
            PopularProducts(
                factura: widget.factura,
            ),
            SizedBox(height: getProportionateScreenWidth(40)),      
            TransactioProducts(
                factura: widget.factura,
            ),
          ],
        ),
      ),
    );
  } 
}
