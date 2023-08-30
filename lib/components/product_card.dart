import 'package:cached_network_image/cached_network_image.dart';
import 'package:fuelred_mobile/Screens/Details/product_screen.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

import 'package:fuelred_mobile/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constans.dart';
import '../sizeconfig.dart';


class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 0.7,
    required this.product,
    required this.factura, 
   
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;
  final AllFact factura;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(          
          onTap: () => Navigator.push(
           context,
            MaterialPageRoute(
              builder: (context) => ProductScreen(
                factura: factura,
                product: product,               
              )
            )
          ),       
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: aspectRetio,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Hero(
                    tag: product.codigoArticulo.toString(),
                    child: CachedNetworkImage(
                        imageUrl:'$imagenesUrl/${product.imageUrl}',
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 70,
                        width: 70,
                        placeholder: (context, url) => const Image(
                          image: AssetImage('assets/Logo.png'),
                          fit: BoxFit.cover,
                          height: 70,
                          width: 70,
                        ),                         
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.detalle,
                style: const TextStyle(color: kContrateFondoOscuro),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                     "¢${NumberFormat("###,000", "en_US").format(product.total.toInt())}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w600,
                      color: kPrimaryText,
                    ),
                  ),                  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }  
}
