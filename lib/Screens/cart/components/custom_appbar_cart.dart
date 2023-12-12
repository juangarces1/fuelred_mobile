
import 'package:fuelred_mobile/models/all_fact.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constans.dart';
import '../../../sizeconfig.dart';

class CustomAppBarCart extends StatefulWidget {
  
  final AllFact factura;  
  final Function? press;
  final String? title;
  final Color? backgroundColor;
  // ignore: use_key_in_widget_constructors
  const CustomAppBarCart({  
   
    required this.factura,   
    this.press,
    this.title,
    this.backgroundColor,
  });

  @override
  State<CustomAppBarCart> createState() => _CustomAppBarCartState();
}

class _CustomAppBarCartState extends State<CustomAppBarCart> {
  // AppBar().preferredSize.height provide us the height that appy on our app bar
 // Size get preferredSize => const Size.fromHeight(70);

 

  @override
  Widget build(BuildContext context) {
    return Container(
      //add elevation and shadow
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? kBlueColorLogo,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
     

      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20), vertical: getProportionateScreenHeight(10)),
        child: Row(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(40),
              width: getProportionateScreenWidth(40),
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
                const SizedBox(width: 10),
              widget.title != null ?  Text(
              widget.title!,
              style: mySubHeadingStyleWhite
              ) : Container(),
            
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
                    "Productos(${widget.factura.cart!.products.length.toString()})",
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
    );
  }

 
}