

// ignore_for_file: deprecated_member_use


import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

import 'package:fuelred_mobile/models/paid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  final AllFact factura;
  final Paid paid;
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,   
    required this.factura, 
    required this.paid,   
  }) : super(key: key);

  final MenuState selectedMenu;

 

  @override
  Widget build(BuildContext context) {
   
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/Shop Icon.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset("assets/credit.png"),
                onPressed: () {},
              ),
              IconButton(
                icon: SvgPicture.asset("assets/Chat bubble Icon.svg"),
                onPressed: () {},
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/User Icon.svg",
                  color: factura.clienteFactura.nombre !=""
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),             
                
                onPressed: () => _showClient(context),
              ),
            ],
          )),
    );
  }

  void _showClient(context) {
     showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              factura.clienteFactura.nombre == "" ? const Expanded(child: Text(
                  "No hay un cliente Seleccionado",
                   style:  TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                          color: Color(0XFF4c0101),
                        ),


                )) 
                            : const Expanded (child:  Text("Cliente Contado")), 
              
            ]),
        content:factura.clienteFactura.nombre != "" ?
          Card(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40), // if you need this
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
            ),        
            elevation: 24.0,
            color: Colors.grey.shade200, 
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                height: 150,
                width: 350,
                child: Expanded(
                child:  Column(
                  children: [
                      Text(
                        factura.clienteFactura.nombre, 
                        style: const TextStyle(                        
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    const SizedBox(height: 5,),
                      Text(
                      'Documento: ${factura.clienteFactura.documento}',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                            color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5,),
                    Text(
                        'Email: ${factura.clienteFactura.email}',
                        style: const TextStyle(
                        fontSize: 14,
                          fontWeight: FontWeight.bold,
                            color: Colors.black87,
                        ),
                      ),
                  ]                   
                )               
              ),
              ),
          )  
          : Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                height: 0,
                width: 350,
          ),
        actions: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonTheme(
                        minWidth: 25.0,
                        height: 25.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text("Seleccione"),
                            
                            onPressed: () {})),
                    const SizedBox(width: 8.0),
                    ButtonTheme(
                        minWidth: 25.0,
                        height: 25.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                              child: const Text("Cerrar"),
                            onPressed: () {
                             Navigator.of(context).pop();
                            }))
                  ]))
        ]);
      }
     );
  }

  


}
