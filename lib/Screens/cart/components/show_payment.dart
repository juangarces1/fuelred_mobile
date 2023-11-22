import 'package:flutter/material.dart';
import 'package:fuelred_mobile/components/color_button.dart';
import 'package:fuelred_mobile/components/show_client.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/sizeconfig.dart';
import 'package:intl/intl.dart';

class ShowPayment extends StatelessWidget {
  final AllFact factura;
  final Function onCreditoPressed;
  final Function onContadoPressed;
  final Function onTicketPressed;
  final Function onBackPressed;

  const ShowPayment({
    Key? key,
    required this.factura,
    required this.onCreditoPressed,
    required this.onContadoPressed,
    required this.onTicketPressed,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      decoration: const BoxDecoration(
        color: kColorFondoOscuro,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
         boxShadow: [
          BoxShadow(
            offset: Offset(0, -4),
            blurRadius: 5,
            color: Colors.deepOrange
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShowClient(factura: factura, ruta: 'Cart'),
            SizedBox(height: getProportionateScreenHeight(15)),
            Row(
              children: [
               
                ColorButton(
                  text: "Contado",
                  press: onContadoPressed,
                  color: Colors.red,
                  ancho: 95,
                ),
                const Spacer(),
                ColorButton(
                  color: const Color.fromARGB(255, 6, 142, 76),
                  ancho: 80,
                  text: 'Ticket',
                  press: onTicketPressed,
                ),
                  const Spacer(),
                 ColorButton(
                  color: kBlueColorLogo,
                  ancho: 90,
                  text: 'Credito',
                  press: onCreditoPressed,
                ),
              
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "¢${NumberFormat("###,000", "en_US").format(factura.cart.total.toInt())}",
                        style: const TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                    onPressed: onBackPressed as void Function()?,
                    icon: const Icon(Icons.arrow_back,), // Icono de flecha hacia atrás
                    label: const Text('Atrás'), // Texto opcional, si quieres que el botón también tenga etiqueta
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white, // Color del texto y el icono
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Bordes redondeados del botón
                      ),
                      elevation: 2, // La sombra del botón
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // El espaciado interno del botón
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
