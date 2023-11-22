import 'package:flutter/material.dart';
import 'package:fuelred_mobile/components/color_button.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/sizeconfig.dart';

class ShowProcessMenu extends StatelessWidget {
  final Function(String estado) onProcessSelected;
  final Function onBack;

  const ShowProcessMenu({
    Key? key,
    required this.onProcessSelected,
    required this.onBack,
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
            Row(
              children: [
                ColorButton(
                  color: kBlueColorLogo,
                  ancho: 100,
                  text: 'Efectivo',
                  press: () => onProcessSelected('Efectivo'),
                ),
                const Spacer(),
                ColorButton(
                  color: kBlueColorLogo,
                  ancho: 100,
                  text: 'Tar BAC',
                  press: () => onProcessSelected('Tarjeta_Bac'),
                ),
                const Spacer(),
                ColorButton(
                  color: kBlueColorLogo,
                  ancho: 100,
                  text: 'Cheque',
                  press: () => onProcessSelected('Cheque'),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Row(
              children: [
                ColorButton(
                  color: kBlueColorLogo,
                  ancho: 100,
                  text: 'Cali...',
                  press: () => onProcessSelected('Calibracion'),
                ),
                const Spacer(),
                ColorButton(
                  color: kBlueColorLogo,
                  ancho: 100,
                  text: 'Exo',
                  press: () => onProcessSelected('Exonerado'),
                ),
                const Spacer(),
                ColorButton(
                  color: kBlueColorLogo,
                  ancho: 100,
                  text: 'Cupones',
                  press: () => onProcessSelected('Cupones'),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Row(
              children: [
                ColorButton(
                  color: kBlueColorLogo,
                  ancho: 100,
                  text: 'Tar DAV',
                  press: () => onProcessSelected('Tarjeta_Dav'),
                ),
                const Spacer(),
                ColorButton(
                  color: kBlueColorLogo,
                  ancho: 100,
                  text: 'Tar SCO',
                  press: () => onProcessSelected('Tarjeta_Scotia'),
                ),
                const Spacer(),
                ColorButton(
                  color: kBlueColorLogo,
                  ancho: 100,
                  text: 'Tar BN',
                  press: () => onProcessSelected('Tarjeta_Bn'),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Row(
              children: [
                ColorButton(
                  color: kBlueColorLogo,
                  ancho: 100,
                  text: 'Dollar',
                  press: () => onProcessSelected('Dollar'),
                ),
                const Spacer(),
                ElevatedButton.icon(
                    onPressed: onBack as void Function()?,
                    icon: const Icon(Icons.arrow_back), // Icono de flecha hacia atrás
                    label: const Text('Atrás'), // Texto opcional, si quieres que el botón también tenga etiqueta
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white, // Color del texto y el icono
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Bordes redondeados del botón
                      ),
                      elevation: 2, // La sombra del botón
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // El espaciado interno del botón
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
