import 'package:fuelred_mobile/Screens/Details/components/body.dart';
import 'package:fuelred_mobile/Screens/Details/components/custum_appbar.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

import 'package:fuelred_mobile/models/product.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget { 
  final Product product;
  final AllFact factura;
  
  // ignore: use_key_in_widget_constructors
  const ProductScreen({   
    required this.factura,   
    required this.product,    
  });
 
  @override
  Widget build(BuildContext context) {   
    return SafeArea(
     
      child: Scaffold(
        backgroundColor: kColorFondoOscuro,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child:  CustomAppBar(
           
            factura: factura,),
        ),
        body: Body(
          product: product,
          factura: factura,
        ),      
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}



