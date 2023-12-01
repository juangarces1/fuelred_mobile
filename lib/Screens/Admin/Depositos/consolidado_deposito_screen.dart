import 'package:flutter/material.dart';
import 'package:fuelred_mobile/Screens/Admin/Depositos/detail_deposits_screen.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:fuelred_mobile/modelsAdmin/DepostosConsolidado/consolidado_deposito.dart';
import 'package:fuelred_mobile/modelsAdmin/DepostosConsolidado/deposito_cierre.dart';
import 'package:fuelred_mobile/sizeconfig.dart';


class ConsolidadoDepositoScreen extends StatefulWidget {
  final String dia;
  const ConsolidadoDepositoScreen({super.key, required this.dia});

  @override
  State<ConsolidadoDepositoScreen> createState() => _ConsolidadoDepositoScreenState();
}

class _ConsolidadoDepositoScreenState extends State<ConsolidadoDepositoScreen> {
  
   ConsolidadoDeposito consolidado = ConsolidadoDeposito(date: '', idConsolidado: 0, cierres: []);

   bool showLoader = false;
   late int total=0;
 
  @override

  void initState() {
    super.initState();
    _getdepositos();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
           foregroundColor: const Color.fromARGB(255, 199, 190, 190),
          backgroundColor: kBlueColorLogo,
          title: const Text('Cierres', style: TextStyle(color: Colors.white),),
         
        ),
        body:  Container(
          color: const Color.fromARGB(255, 226, 225, 223),
          child: Stack(
            children: [ Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(10)),
            child: ListView.builder(
              
              itemCount: consolidado.cierres.length,
              itemBuilder: (context, index)  
              { 
                final item = consolidado.cierres[index];
                return 
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => goDetail(item),
                    child: Card(
                      color: areAllDepositsSelected(consolidado.cierres[index]) ? Colors.green : kContrateFondoOscuro,
                       shadowColor: Colors.blueGrey,
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      child: Padding
                      (
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 88,
                              child: AspectRatio(
                                aspectRatio: 0.88,
                                child: Container(
                                  padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(15) , bottomLeft: Radius.circular(15))
                                  ),
                                  child:  const Image(
                                              image: AssetImage('assets/cierre1.png'),
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
                                   'Cierre #: ${consolidado.cierres[index].idCierre.toString()}',
                                    style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                    Text(
                                   'Cajero: ${consolidado.cierres[index].empleado}',
                                    style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                   Text(
                                   'Zona: ${consolidado.cierres[index].lugar}',
                                    style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                
                                  Text(
                                    
                                       '${consolidado.cierres[index].depositos.length} Depositos',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700, color: kPrimaryColor),
                                                                
                                    ),
                                                       
                                ],
                              ),
                            ),
                           // make an icon indicates to click and show more info
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.arrow_forward_ios),
                            )             
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }        
            ),
          ),
          showLoader ? const LoaderComponent(text: 'Cargando..,',) :Container()
            ]
          ),
        ),
       
       
      ),
    );
  }

  Future<void> _getdepositos() async {
    setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.getDepositosByConsolidado(widget.dia);

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
      consolidado = response.result;
   
    });
  }

  goDetail(DepositoCierre item) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) =>  DetailDepositsScreen(
          cierre: item,
           onDepositSelectionChanged: () => setState(() {}),
        )
      )
    );
  }

  bool areAllDepositsSelected(DepositoCierre cierre) {
  return cierre.depositos.every((deposito) => deposito.selected ?? false);
}

  


    
}