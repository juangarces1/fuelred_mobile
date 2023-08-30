
import 'package:fuelred_mobile/models/all_fact.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constans.dart';
import '../../../sizeconfig.dart';

class CustomAppBarCart extends StatefulWidget {
  
  final AllFact factura;  
  final Function? press;

  // ignore: use_key_in_widget_constructors
  const CustomAppBarCart({  
   
    required this.factura,   
    this.press,
   
  });

  @override
  State<CustomAppBarCart> createState() => _CustomAppBarCartState();
}

class _CustomAppBarCartState extends State<CustomAppBarCart> {
  // AppBar().preferredSize.height provide us the height that appy on our app bar
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
         color: const Color.fromARGB(255, 144, 144, 145),



        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(5)),
          child: Row(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(45),
                width: getProportionateScreenWidth(45),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                   
                    backgroundColor:  Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: widget.press as void Function()?,             
                                            
                  child: SvgPicture.asset(
                    "assets/Back ICon.svg",
                    height: 15,
                    // ignore: deprecated_member_use
                    color: kPrimaryColor,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(
                      "Productos(${widget.factura.cart.products.length.toString()})",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 5),
                    
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

 
}