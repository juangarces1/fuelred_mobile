import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelred_mobile/Screens/clientes/cliestes_new_screen.dart';
import 'package:fuelred_mobile/clases/show_alert_cliente.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/sizeconfig.dart';

class ShowClient extends StatefulWidget {
  final AllFact factura;
  final String ruta;
  final EdgeInsets? padding;
  const ShowClient({
       super.key,
      required this.factura,
      required this.ruta,
      this.padding,
     });

  @override
  State<ShowClient> createState() => _ShowClientState();
}

class _ShowClientState extends State<ShowClient> {
  @override
  Widget build(BuildContext context) {
    return Container(
       padding:  widget.padding ?? const EdgeInsets.all(0),
       decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () => _showNewCliente(context),
        child: Container(        
          decoration: const BoxDecoration(color: kColorFondoOscuro,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
    
          ),),
          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,        
            children: [                   
              Container(
                padding: const EdgeInsets.all(10),
                height: 50,
                width: getProportionateScreenWidth(40),
                decoration: const BoxDecoration(
                  color: kContrateFondoOscuro,
                    borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(3),
                  ),
                ),
                child: SvgPicture.asset(
                  "assets/User Icon.svg", 
                  // ignore: deprecated_member_use
                  color: widget.factura.clienteFactura!.nombre == '' ? kTextColorBlack 
                  : kPrimaryColor,),
                  
              ),
              const SizedBox(width: 10,),        
              Flexible(
                child: Text(
                  widget.factura.clienteFactura!.nombre == "" ? "Seleccione Un Cliente": widget.factura.clienteFactura!.nombre ,
                    style:  const TextStyle(
                    color: kContrateFondoOscuro),),
              ),
              
             
            ],
          ),
        ),
      ),
    );
  }

void _showNewCliente(context) async {
  if(widget.factura.clienteFactura!.nombre == ""){
    _goClientes();
  }
  else{
  ShowAlertCliente.showAlert(context, widget.factura.clienteFactura!, _goClientes);
  }
}

 void _goClientes() {
    Navigator.of(context).pop();
    Navigator.push(context,  
      MaterialPageRoute(
        builder: 
        (context) => ClientesNewScreen(factura: widget.factura,ruta: widget.ruta,)
      )
    );
  }
  
}