import 'package:fuelred_mobile/constans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoaderComponent extends StatelessWidget {
  final String text;

  // ignore: use_key_in_widget_constructors
  const LoaderComponent({this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Center(      
        child: Container(          
          width: 210,
          height: 150,
          decoration: BoxDecoration(
            color:  kColorFondoOscuro,
            borderRadius: BorderRadius.circular(10),
            border:  Border.all(color: kPrimaryColor),
          ),
          child: Column(            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpinKitCubeGrid(
                color: kContrateFondoOscuro,
              ),
              const SizedBox(height: 20,),
              Text(text, style: const TextStyle(fontSize: 18, color: kContrateFondoOscuro),),
            ],
          ),
        ),
      );    
  }
}