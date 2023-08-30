
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/transparcial.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';

class TransferenciasScreen extends StatefulWidget {
   final AllFact factura;
  const TransferenciasScreen({ Key? key, required this.factura }) : super(key: key);

  @override
  State<TransferenciasScreen> createState() => _TransferenciasScreenState();
}

class _TransferenciasScreenState extends State<TransferenciasScreen> {
  List<TransParcial> transfers = [];
   bool showLoader = false;
  late double total=0;

 
  @override

  void initState() {
    super.initState();
    _getTransfers();
  }


 
   @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueColorLogo,
          title: const Text('Transferencias', style: TextStyle(color: Colors.white),),
         
        ),
        body:  Container(
          color: kColorFondoOscuro,
          child: Stack(
            children: [ Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(10)),
            child: ListView.builder(
              
              itemCount: transfers.length,
              itemBuilder: (context, index)  
              { 
                
                return 
                Card(
                  color: kContrateFondoOscuro,
                   shadowColor: kPrimaryColor,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 88,
                        child: AspectRatio(
                          aspectRatio: 0.80,
                          child: Container(
                            padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                            decoration: const BoxDecoration(
                              color: kTextColor,
                               borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                 bottomLeft: Radius.circular(24))
                            ),
                            child:  const Image(
                                        image: AssetImage('assets/tr9.png'),
                                    ),
                          ),
                        ),
                      ),                         
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                             transfers[index].cliente.toString(),
                              style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                         
                            Text.rich(
                              TextSpan(
                                text: 'Aplicado: ¢${NumberFormat("###,000", "en_US").format(transfers[index].aplicado)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, color: kPrimaryColor),
                                                          
                              ),
                            ),
                             Text.rich(
                              TextSpan(
                                text: 'Deposito #:${transfers[index].numeroDeposito}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, color: kTextColor),
                                                          
                              ),
                            ),
                             Text.rich(
                              TextSpan(
                                text: 'Saldo: ¢${NumberFormat("###,000", "en_US").format(transfers[index].saldo)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, color: kTextColor),
                                                          
                              ),
                            )                                
                          ],
                        ),
                      )                
                    ],
                  ),
                );
              }        
            ),
          ),
          showLoader ? const LoaderComponent(text: 'Cargando..,',) :Container()
            ]
          ),
        ),      
         bottomNavigationBar: BottomAppBar(
          color: kBlueColorLogo,
          shape: const CircularNotchedRectangle(),
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                tooltip: 'Open navigation menu',
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
              Text('Total: ¢${NumberFormat("###,000", "en_US").format(total)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
    
               ],          
             ),
          ),
         ), 
      ),
    );
  }

  Future<void> _getTransfers() async {
    setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.getTransfesByCierre(widget.factura.cierreActivo.cierreFinal.idcierre ?? 0);

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
      total=0;
      transfers=response.result;
      for (var element in transfers) {
        total+=element.aplicado;
      } 
    });
  }
}