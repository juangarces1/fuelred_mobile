import 'package:flutter/material.dart';
import 'package:fuelred_mobile/constans.dart';


class ShowAlertFactura {
  static Future<String?> show(BuildContext context) async {
    TextEditingController textFieldController = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Buscar Factura',
              style: TextStyle(
                color: kBlueColorLogo, // Personaliza según tu tema
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: TextField(
            controller: textFieldController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Escribe aquí el número",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Color del texto
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, // Color del texto
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(textFieldController.text);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
