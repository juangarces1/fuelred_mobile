import 'package:flutter/material.dart';
import 'package:fuelred_mobile/helpers/varios_helpers.dart';
import 'package:intl/intl.dart';

class MyCustomCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> details;
  final Color baseColor; 
  final Color foreColor;

  const MyCustomCard({super.key, required this.title, required this.details, required this.baseColor, required this.foreColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: baseColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: ExpansionTile(
        collapsedIconColor: foreColor,
        iconColor: foreColor,
        title: Text(title, style: TextStyle(color: foreColor,fontWeight: FontWeight.bold,)),
        children: details.entries.map((entry) {
          if (entry.key != 'cierres' && entry.value != 0.0) {
            String formattedValue = entry.value is num
                ? NumberFormat.currency(locale: 'es_CR', symbol: '¢').format(entry.value)
                : entry.value.toString();
           return Container(
              color: VariosHelpers.getShadedColor(entry.key, baseColor), // Usa el color generado
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(VariosHelpers.convertCamelCaseToTitle(entry.key), style:  TextStyle(fontWeight: FontWeight.bold, color: foreColor)),
                  Expanded(
                    child: Text(
                       formattedValue,
                      
                      textAlign: TextAlign.right,
                      style:  TextStyle(color: foreColor,fontWeight: FontWeight.bold,),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(); // Retorna un contenedor vacío para 'cierres'
        }).toList(),
      ),
    );
  }

  

 

  

   




}
