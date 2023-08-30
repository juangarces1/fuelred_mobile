

import 'package:fuelred_mobile/Screens/manejoCierre/entrega_efectivo_screen.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

import 'package:fuelred_mobile/models/deposito.dart';
import 'package:fuelred_mobile/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../constans.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';

class DepositosScreen extends StatefulWidget {
  final AllFact factura;
  const DepositosScreen({ Key? key, required this.factura }) : super(key: key);
  @override
  State<DepositosScreen> createState() => _DepositosScreenState();
}

class _DepositosScreenState extends State<DepositosScreen> {
   List<Deposito> depositos = [];
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
          backgroundColor: kBlueColorLogo,
          title: const Text('Depositos', style: TextStyle(color: Colors.white),),
         
        ),
        body:  Container(
          color: kColorFondoOscuro,
          child: Stack(
            children: [ Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(10)),
            child: ListView.builder(
              
              itemCount: depositos.length,
              itemBuilder: (context, index)  
              { 
                final item = depositos[index].iddeposito.toString();
                return 
                Card(
                  color: kContrateFondoOscuro,
                   shadowColor: Colors.blueGrey,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding
                  (
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Dismissible(            
                      key: Key(item),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {              
                      _goDelete(depositos[index].iddeposito ?? 0);        
                      setState(() {
                            depositos.removeAt(index);
                            total=0;
                            for (var element in depositos) {
                              total+=element.monto??0;
                            }
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
                          SizedBox(
                            width: 88,
                            child: AspectRatio(
                              aspectRatio: 0.88,
                              child: Container(
                                padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF392c74),
                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(15) , bottomLeft: Radius.circular(15))
                                ),
                                child:  const Image(
                                            image: AssetImage('assets/deposito.png'),
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
                                  depositos[index].moneda.toString(),
                                  style: const TextStyle(color: Colors.black, fontSize: 16),
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 10),
                                Text.rich(
                                  TextSpan(
                                    text: 'Monto : ¢  ${NumberFormat("###,000", "en_US").format(depositos[index].monto)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700, color: kPrimaryColor),
                                                              
                                  ),
                                )                      
                              ],
                            ),
                          )                
                        ],
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
           bottomNavigationBar: BottomAppBar(
          color: kBlueColorLogo,
          
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
              Text('Total: ¢${NumberFormat("###,000", "en_US").format(total)}', 
              style: const TextStyle(color: Colors.white,
               fontWeight: FontWeight.bold,
               fontSize: 20
               ),),
    
               ],          
             ),
          ),
         ), 
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () => _goAdd(),
          child: const Icon(Icons.add),
        )
      ),
    );
  }

  Future<void> _getdepositos() async {
    setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.getDepositos(widget.factura.cierreActivo.cierreFinal.idcierre ?? 0);

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

    total=0;
    depositos=response.result;
    for (var element in depositos) {
      total+=element.monto??0;
    } 

    setState(() {
      depositos;
      total;
    });
  }

   Future<void> _goDelete(int id) async {

     setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.delete('/api/Depositos/',id.toString());

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

  void _goAdd() async {
    String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => EntregaEfectivoScreen(
          factura: widget.factura,
        )
      )
    );
    if (result == 'yes') {
      _getdepositos();
    }
  }
}