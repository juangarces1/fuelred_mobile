
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/Admin/ComponentsShared/app_bar_custom.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/varios_helpers.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/transaccion.dart';

import '../../components/loader_component.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';

class TransaccionesScreen extends StatefulWidget {
  final AllFact factura;

  // ignore: use_key_in_widget_constructors
  const TransaccionesScreen({ required this.factura});

  @override
  State<TransaccionesScreen> createState() => _TransaccionesScreenState();
}

class _TransaccionesScreenState extends State<TransaccionesScreen> {
  List<Transaccion> transacciones = [];
   bool showLoader = false;
    double aspectRetio = 1.02;

     double width = 140;
  @override

 void initState() {
    super.initState();
    _getTransacions();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          title: 'Transacciones',
          elevation: 6,
          shadowColor: kColorFondoOscuro,
          automaticallyImplyLeading: true,
          foreColor: Colors.white,
          backgroundColor: kBlueColorLogo,
          actions: <Widget>[
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipOval(child:  Image.asset(
                  'assets/splash.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),), // Ícono de perfil de usuario
            ),
          ],      
        ),
        body: showLoader ? const LoaderComponent(text: 'Cargando...',) : Container(
           color:  kContrateFondoOscuro,
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8), vertical: getProportionateScreenHeight(8), ),
          child: ListView.builder(        
            itemCount: transacciones.length,
            itemBuilder: (context, index)  
            { 
              final item = transacciones[index].idtransaccion.toString();
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(              
                      color:  const Color.fromARGB(255, 216, 219, 225),
                      shadowColor: const Color.fromARGB(255, 16, 38, 54),
                      elevation: 7,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),                
                      child: Dismissible(            
                        key: Key(item),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {              
                        _goDelete(transacciones[index]);        
                        setState(() {
                              transacciones.removeAt(index);
                        });     
                        },
                        background: Container(              
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              SvgPicture.asset("assets/Trash.svg"),
                            ],
                          ),
                        ),
                        child: Row(  
                          children: [
                             Container(                          
                               padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                               height: 120,
                               width: 120,                           
                               child: Ink.image(                        
                                 image: 
                                   transacciones[index].nombreproducto =='Super' ?  const AssetImage('assets/super.png') : 
                                   transacciones[index].nombreproducto=='Regular' ? const AssetImage('assets/regular.png') : 
                                   transacciones[index].nombreproducto=='Exonerado' ? const AssetImage('assets/exonerado.png') : 
                                   const AssetImage('assets/diesel.png'),
                                     fit: BoxFit.cover,
                                   ),
                               ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 const SizedBox(height: 5),
                                Text.rich(
                                  TextSpan(
                                    text: 'Numero: ${transacciones[index].idtransaccion}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, color: Colors.black),
                                                              
                                  ),
                                ),                      
                               
                                Text.rich(
                                  TextSpan(
                                    text: 'Forma Pago: ${transacciones[index].estado}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, color: Colors.black),
                                                              
                                  ),
                                ),
                               
                                Text.rich(
                                  TextSpan(
                                    text: 'Facturada: ${transacciones[index].facturada}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, color: Colors.black),
                                                              
                                  ),
                                ),
                              
                                Text.rich(
                                  TextSpan(
                                    text: 'Cantidad: ${transacciones[index].volumen}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, color: Colors.black),
                                                              
                                  ),
                                ),
                              
                                Text.rich(
                                  TextSpan(
                                      text: 'Monto: ${VariosHelpers.formattedToCurrencyValue(transacciones[index].total.toString())}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                                                              
                                  ),
                                ),
                                  const SizedBox(height: 5),
                              ],
                            )                        
                          ],
                          
                        )
                    
                  ),
                ),
              );
            }        
          ),
          ),
        ),
        
        
      ),
    );
  }

  Future<void> _getTransacions() async {
    setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.getTransaccionesByCierre(widget.factura.cierreActivo!.cierreFinal.idcierre ?? 0);

    setState(() {
      showLoader = false;
    });

     if (!response.isSuccess) {
        if (mounted) {       
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content:  Text(response.message),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }  
       return;
     }

    setState(() {
      transacciones = response.result;
       transacciones.sort(((a, b) => b.idtransaccion.compareTo(a.idtransaccion)));
    });
  }
    
  Future<void> _goDelete(Transaccion tr) async {
     if (tr.facturada=="si" || tr.facturada=="Si"){
      await  Fluttertoast.showToast(
            msg: "No se puede eliminar una transaccion facturada",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 196, 7, 7),
            textColor: Colors.white,
            fontSize: 16.0
          ); 
      return;
    } 

     setState(() {
      showLoader = true;
    });
    
    
    tr.idcierre=0;
    tr.estado='copiado';
    
     Map<String, dynamic> request = tr.toJson(); 
   
    Response response = await ApiHelper.put('/api/TransaccionesApi/', tr.idtransaccion.toString(), request);

    setState(() {
      showLoader = false;
    });

     if (!response.isSuccess) {
        if (mounted) {       
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content:  Text(response.message),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }  
       return;
     }  
    
  }

  
}