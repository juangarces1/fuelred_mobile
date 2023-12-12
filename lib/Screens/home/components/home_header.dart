import 'package:fuelred_mobile/Screens/home/components/search_field.dart';

import 'package:flutter/material.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

import '../../../sizeconfig.dart';
import 'icon_btn_with_counter.dart';


class HomeHeader extends StatelessWidget {  
  final AllFact factura;  
  const HomeHeader({
    super.key,   
    required this.factura 
  });

  @override
  Widget build(BuildContext context) {
    factura.cart!.setTotal();
    factura.cart!.cargaritems();
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SearchField(),
          IconBtnWithCounter(
            svgSrc: "assets/Cart Icon.svg",  
            numOfitem: factura.cart!.products.length,          
            press: () {},
          ),         
        ],
      ),
    );
  }
}
