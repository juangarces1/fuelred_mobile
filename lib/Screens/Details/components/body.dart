

import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/Details/components/product_description.dart';
import 'package:fuelred_mobile/Screens/Details/components/product_images.dart';
import 'package:fuelred_mobile/Screens/Details/components/top_rounded_container.dart';
import 'package:fuelred_mobile/Screens/cart/cart_new.dart';
import 'package:fuelred_mobile/components/default_button.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

import 'package:fuelred_mobile/models/product.dart';
import 'package:flutter/material.dart';
import '../../../sizeconfig.dart';
import 'color_dots.dart';

class Body extends StatelessWidget {
  final AllFact factura;
  final Product product;
  

  const Body({Key? key,
   required this.product,
    required this.factura,
   
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 10,),
        ProductImages(product: product),
        TopRoundedContainer(
          color: kTextColor,
          child: Column(
            children: [
              ProductDescription(
                product: product,
                pressOnSeeMore: () {},
              ),
              TopRoundedContainer(
                color: kSecondaryColor,
                child: Column(
                  children: [
                    ColorDots(product: product),
                    TopRoundedContainer(
                      color: kColorFondoOscuro,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.20,
                          right: SizeConfig.screenWidth * 0.20,
                          bottom: getProportionateScreenWidth(1),
                          top: getProportionateScreenWidth(1),
                        ),
                        child: DefaultButton(
                          text: "Agregar",
                          press: () {
                              if(product.cantidad > 0){
                                bool exists =false;                             
                                for (var element in factura.cart.products) {
                                  if(element.codigoArticulo == product.codigoArticulo){                                   
                                      exists=true;
                                  }
                                }
                                if (!exists)                            
                                {
                                  factura.cart.products.add(product);                                  
                                }                               
                                Navigator.pushReplacement(context,  
                                  MaterialPageRoute(
                                    builder: (context) => CartNew(
                                    factura: factura,)
                                  )
                                );
                              }
                              else{
                                Fluttertoast.showToast(
                                  msg: "Por favor seleccione una cantidad",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                                );                              
                              }                               
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  } 
}

