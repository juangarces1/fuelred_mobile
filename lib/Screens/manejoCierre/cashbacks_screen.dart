
import 'package:fuelred_mobile/Screens/manejoCierre/add_cashback_sceen.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/cashback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';

class CashbarksScreen extends StatefulWidget {
  final AllFact factura;

  // ignore: use_key_in_widget_constructors
  const CashbarksScreen({ required this.factura});

  @override
  State<CashbarksScreen> createState() => _CashbarksScreenState();
}

class _CashbarksScreenState extends State<CashbarksScreen> {
   List<Cashback> cashs = [];
   bool showLoader = false;
   late int total=0;
  @override

  void initState() {
    super.initState();
    _getcashsbacks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
    
        appBar: AppBar(
          backgroundColor: kBlueColorLogo,
          title: const Text('CashBacks', style: TextStyle(color: Colors.white),),
          
        ),
        body: showLoader ? const LoaderComponent(text: 'Cargando...',) : Container(
          color: kColorFondoOscuro,
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(10)),
          child: ListView.builder(
            
            itemCount: cashs.length,
            itemBuilder: (context, index)  
            { 
              final item = cashs[index].idcashback.toString();
              return Card(
                color: kContrateFondoOscuro,
                shadowColor: kPrimaryColor,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Dismissible(            
                  key: Key(item),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {              
                  _goDelete(cashs[index].idcashback ?? 0);        
                  setState(() {
                        cashs.removeAt(index);
                        total=0;                   
                        for (var element in cashs) {
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
                            padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6F9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child:  const Image(
                                        image: AssetImage('assets/cbs.png'),
                                    ),
                          ),
                        ),
                      ),                         
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Banco Nacional',
                              style: TextStyle(color: Colors.black, fontSize: 16),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                text: 'Monto : ¢  ${NumberFormat("###,000", "en_US").format(cashs[index].monto)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: kPrimaryColor),
                                                          
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
              Text('Total: ${ NumberFormat.currency(symbol: '¢').format(total)}', 
                  style: const TextStyle(
                    color: Colors.white,
                     fontWeight: FontWeight.bold,
                     fontSize: 20,
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
          
        ),
      
      ),
    );
  }

  Future<void> _getcashsbacks() async {
    setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.getCashBacks(widget.factura.cierreActivo.cierreFinal.idcierre ?? 0);

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
    cashs=response.result;
    for (var element in cashs) {
      total+=element.monto??0;
    } 
    setState(() {
      cashs;
      total;
      
    });
  }

   Future<void> _goDelete(int id) async {

     setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.delete('/api/Cashbacks/',id.toString());

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
        builder: (context) => CashbackScreen(
          factura: widget.factura,
        )
      )
    );
    if (result == 'yes') {
      _getcashsbacks();
    }
  }
}