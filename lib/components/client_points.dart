import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelred_mobile/Screens/clientes/cliente_frec_screen.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/sizeconfig.dart';

class ClientPoints extends StatelessWidget {
  final AllFact factura;
  final String ruta;
  const ClientPoints({super.key, required this.factura, required this.ruta});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context,  MaterialPageRoute(
                    builder: (context) => ClientesFrecScreen(
                      factura: factura,                      
                      ruta: ruta,
                    )
                    )),
      child: Container(
        color: kColorFondoOscuro,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [                   
              Container(
                padding: const EdgeInsets.all(10),
                height: getProportionateScreenWidth(50),
                width: getProportionateScreenWidth(50),
                decoration: BoxDecoration(
                  color: kContrateFondoOscuro,
                  borderRadius: BorderRadius.circular(10),
                ),
                // ignore: deprecated_member_use
                child: SvgPicture.asset("assets/User Icon.svg", color:  factura.formPago.clientePaid.nombre == "" ? kTextColor : kPrimaryColor,),
              ),
              const SizedBox(width: 10,),               
              Expanded(
                child: Text(
                  factura.formPago.clientePaid.nombre == "" 
                  ? 'Seleccione Cliente Frecuente' 
                  : '${factura.formPago.clientePaid.nombre}(${factura.formPago.clientePaid.puntos})',               
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                     color:Colors.white,
                  )),
              ),
             
              
            ],
          ),
        ),
      ),
    );     
  }
}