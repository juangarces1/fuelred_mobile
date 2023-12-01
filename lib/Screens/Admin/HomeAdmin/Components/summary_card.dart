import 'package:flutter/material.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/varios_helpers.dart';
import 'package:fuelred_mobile/sizeconfig.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData iconData;
  final Color color;

  const SummaryCard({super.key, 
    required this.title, 
    required this.value, 
    required this.iconData, 
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                  decoration: BoxDecoration(
                    color: kTextColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image(
                        image: title =='Inv Super' ?  const AssetImage('assets/super.png') : 
                              title =='Inv Regular' ? const AssetImage('assets/regular.png') : 
                              title =='Inv Exonerado' ? const AssetImage('assets/exonerado.png') :
                              const AssetImage('assets/diesel.png'),
                              fit: BoxFit.cover,
                    ),
                ),
              ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        trailing: Text(
          VariosHelpers.formattedToVolumenValue(value),
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


}
