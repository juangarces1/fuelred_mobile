import 'package:flutter/material.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/cliente.dart';


class ShowAlertCliente {
  static Future<void> showAlert(
    BuildContext context,
    Cliente client,
    Function? press,
      ) async {
    return  showDialog(
    context: context,
    builder: (context) {
        return AlertDialog(
          title: const Center(child: Text(
            'Cliente Contado',
            style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                      color: kPrimaryText,
                  ),
            )),
          content:  client.nombre == "" 
          ? const SizedBox(
              height: 50,
            child: Center(
              child: Text('No Hay Cliente Seleccionado')))
          :  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [              
                Text(
                 'Nombre: ${client.nombre}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                      color: Colors.black87,
                  ),
                ),
              
              const Divider(height: 10, thickness: 1, color: kColorFondoOscuro,),
                Text(
                'Documento: ${client.documento}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                      color: Colors.black87,
                  ),
                ),
               const Divider(height: 10, thickness: 1, color: kColorFondoOscuro,),
              Text(
                  'Email: ${client.email}',
                  style: const TextStyle(
                  fontSize: 14,
                    fontWeight: FontWeight.bold,
                      color: Colors.black87,
                  ),
                ),
            ]                   
          ),
          actions: <Widget>[
            TextButton(
              onPressed: press as void Function()?, 
              child:  client.nombre == "" ? const Text('Seleccionar') : const Text('Cambiar')
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text('Salir')
            ),
          ],

        );
    } 
  );
  }

  
  
}
