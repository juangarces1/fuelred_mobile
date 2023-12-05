import 'package:flutter/material.dart';
import 'package:fuelred_mobile/components/color_button.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:intl/intl.dart';

class ShowTotal extends StatelessWidget {
  final AllFact factura;
  final Function onFacturarPressed;
  final Function onProcesarPressed;

  const ShowTotal({
    Key? key,
    required this.factura,
    required this.onFacturarPressed,
    required this.onProcesarPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 216, 216, 218),
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                text: "Total: \n",
                style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: "¢${NumberFormat("###,###", "en_US").format(factura.cart!.total)}",
                    style: const TextStyle(fontSize: 21, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ColorButton(
              text: 'Facturar',
              press: onFacturarPressed,
              color: kPrimaryColor,
              ancho: 100,
            ),
            const SizedBox(width: 10,),
            ColorButton(color: kBlueColorLogo, ancho: 100, text: 'Procesar', press: onProcesarPressed,),
          ],
        ),
      ),
    );
  }
}
