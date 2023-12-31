
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/cliente.dart';
import 'package:flutter/material.dart';


class ClientCard extends StatelessWidget {
  final Cliente? client;
  const ClientCard({
       super.key,
      required this.client
     });

  @override 
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // if you need this
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
           width: 1,
        ),
        ),        
        elevation: 12.0,
         color: Colors.grey.shade200, 
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                 Text(
                   client?.nombre ?? "", 
                   style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                 ),
                const SizedBox(height: 5,),
                 Text(
                 client?.documento != null ? 'Documento: ${client?.documento}' : '',
                 style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                       color: Colors.black87,
                    ),
                 ),
                  const SizedBox(height: 5,),
                Text(
                    client?.email != null ? 'Email: ${client?.email}' : '',
                   style: const TextStyle(
                    fontSize: 16,
                     fontWeight: FontWeight.bold,
                       color: Colors.black87,
                   ),
                  ), 
              ]
               ),
          )
    );
  
  }
}