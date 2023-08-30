
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/cierredatafono.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../constans.dart';
import '../../helpers/api_helper.dart';

import '../../models/response.dart';
import '../../sizeconfig.dart';
import 'add_datafono_screen.dart';



class CierreDatafonosScreen extends StatefulWidget {

  final AllFact factura;
  // ignore: use_key_in_widget_constructors
  const CierreDatafonosScreen({ required this.factura});

  @override
  State<CierreDatafonosScreen> createState() => _CierreDatafonosScreenState();
}

class _CierreDatafonosScreenState extends State<CierreDatafonosScreen> {
  List<CierreDatafono> cierres = [];
   bool showLoader = false;
    late double total=0;

  
  @override

  void initState() {
    super.initState();
    _getcierres();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueColorLogo,
          title: const Text('Cierres Datafonos', style: TextStyle(color: Colors.white),),
          
        ),
        body: showLoader ? const LoaderComponent(text: 'Cargando...',) : Container(
          color: kColorFondoOscuro,
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(10)),
          child: ListView.builder(
            
            itemCount: cierres.length,
            itemBuilder: (context, index)  
            { 
              final item = cierres[index].idcierre.toString();
              return Card(
                color: kContrateFondoOscuro,
               shadowColor: Colors.blueGrey,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Dismissible(            
                  key: Key(item),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {              
                  _goDelete(cierres[index].idregistrodatafono ?? 0);        
                  setState(() {
                    cierres.removeAt(index);
                    total=0;               
                    for (var element in cierres) {
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
                                        image: AssetImage('assets/data.png'),
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
                              cierres[index].banco ?? "",
                              style: const TextStyle(color: Colors.black, fontSize: 16),
                              maxLines: 2,
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Datafono: ${cierres[index].terminal}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: kTextColor),
                                                          
                              ),
                            ),
                             Text.rich(
                              TextSpan(
                                text: 'Lote : ${cierres[index].idcierredatafono}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: kTextColor),
                                                          
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Monto: ¢${NumberFormat("###,000", "en_US").format(cierres[index].monto)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: kPrimaryColor),
                                                          
                              ),
                            ),
                           
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
              Text('Total: ¢${NumberFormat("###,000", "en_US").format(total)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
    
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

  Future<void> _getcierres() async {
    setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.getCierresDatafonos(widget.factura.cierreActivo.cierreFinal.idcierre ?? 0);

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
    cierres=response.result;
    for (var element in cierres) {
      total+=element.monto??0;
    } 

    setState(() {
      cierres;
      total;
    });
  }

   Future<void> _goDelete(int id) async {

     setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.delete('/api/CierreDatafonos/',id.toString());

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
        builder: (context) => DatafonoScreen(
          factura: widget.factura,
        )
      )
    );
    if (result == 'yes') {
      _getcierres();
    }
  }
}