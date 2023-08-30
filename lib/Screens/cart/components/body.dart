
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import '../../../sizeconfig.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
 final AllFact factura;
 
  // ignore: use_key_in_widget_constructors
  const Body({ 
    required this.factura,  

   });
  @override
  // ignore: library_private_types_in_public_api
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: ListView.builder(
        itemCount: widget.factura.cart.products.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(widget.factura.cart.products[index].transaccion.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {   
              setState(() {               
                if(widget.factura.cart.products[index].unidad=="L"){
                    widget.factura.transacciones.add(widget.factura.cart.products[index]);
                   
                }
                else{
                  for (var element in widget.factura.productos) {
                        if (element.codigoArticulo==widget.factura.cart.products[index].codigoArticulo){                       
                          element.inventario+=(element.inventario+element.cantidad).toInt();
                          element.cantidad=0;   
                                     
                        }
                   }
                   
                }
                 widget.factura.cart.products.removeAt(index);
                 widget.factura.cart.setTotal();
              });
            },
            background: Container(              
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  SvgPicture.asset("assets/Trash.svg"),
                ],
              ),
            ),
            child: CartCard(product: widget.factura.cart.products[index]),
          ),
        ),
      ),
    );
  }
}
