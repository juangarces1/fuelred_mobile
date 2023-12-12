import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

import '../../components/loader_component.dart';
import '../../components/process_button.dart';

import '../../sizeconfig.dart';
import '../cart/components/cart_card.dart';

class ProcessScreen extends StatefulWidget {
 final AllFact factura; 
  const ProcessScreen({
    super.key,
    required this.factura,   
    });

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  final bool _showLoader = false;

  get kPrimaryColor => null;
  @override
  Widget build(BuildContext context) {
    widget.factura.cart!.setTotal();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: Container()
      ),
      body: Padding(
      padding:
      EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: ListView.builder(
        itemCount: widget.factura.cart!.products.length,
        itemBuilder: (context, index) {
          final item = widget.factura.cart!.products[index].transaccion == 0 ? widget.factura.cart!.products[index].codigoArticulo : widget.factura.cart!.products[index].transaccion.toString();
         return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: Key(item),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {              
              setState(() {               
                if(widget.factura.cart!.products[index].unidad=="L"){
                    widget.factura.transacciones.add(widget.factura.cart!.products[index]);
                }
                else{
                  for (var element in widget.factura.productos) {
                        if (element.codigoArticulo==widget.factura.cart!.products[index].codigoArticulo){                       
                          element.inventario=(element.inventario + element.cantidad).toInt();
                          element.cantidad=0;                         
                        }
                   }
                }
                 widget.factura.cart!.products.removeAt(index);
                 widget.factura.cart!.setTotal();
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
            child: CartCard(product: widget.factura.cart!.products[index]),
            
          ),
         );  
        },    
      ),
      ),
      bottomNavigationBar: Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: 
          SafeArea(
          child: Stack(
            children:[ 
              _showLoader ?  const LoaderComponent(text: 'Procesando...') : const SizedBox(width: 0, height: 0,),              
              Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [  
                 SizedBox(height: getProportionateScreenHeight(20)),
                 Row(
                  children: [
                    ProcessButton(
                        text: "Colones",
                        press: () => _goProcess(),
                      ),
                    ProcessButton(
                        text: "Dolares",
                        press: () => _goProcess(),
                      ),  
                      ProcessButton(
                        text: "Cheque",
                        press: () => _goProcess(),
                      ),
                    ]
                  ),
                    
                     SizedBox(height: getProportionateScreenHeight(20)),
                Row(
                   children: [
                    ProcessButton(
                        text: "Colones",
                        press: () => _goProcess(),
                      ),
                    ProcessButton(
                        text: "Dolares",
                        press: () => _goProcess(),
                      ),  
                      ProcessButton(
                        text: "Cheque",
                        press: () => _goProcess(),
                      ),
                    ]
                  
                ),
                ],
              
               

               
             
            ),
            ]
          ),
        ),      
      )       
    );
    
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      title: Column(
        children: [
          const Text(
            "Tu Carro",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "${widget.factura.cart!.products.length} Producto(s)",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  _goProcess() {

  }
}  