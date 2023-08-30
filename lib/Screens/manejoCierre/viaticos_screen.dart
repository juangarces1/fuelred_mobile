
import 'package:fuelred_mobile/Screens/manejoCierre/add_viatico_screen.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';

import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/viatico.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';

class ViaticosScreen extends StatefulWidget {
  final AllFact factura;
 
  // ignore: use_key_in_widget_constructors
  const ViaticosScreen({ required this.factura});
  
  @override
  State<ViaticosScreen> createState() => _ViaticosScreenState();
}

class _ViaticosScreenState extends State<ViaticosScreen> {
   List<Viatico> viaticos = [];
   bool showLoader = false;
    late double total=0;
  @override

  void initState() {
    super.initState();
    _getViaticos();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBlueColorLogo,
          title: const Text('Viaticos', style: TextStyle(color: Colors.white),),
          
        ),
        body: showLoader ? const LoaderComponent(text: 'Cargando...',) : Container(
          color: kColorFondoOscuro,
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical:  getProportionateScreenHeight(10)),
          child: ListView.builder(
            
            itemCount: viaticos.length,
            itemBuilder: (context, index)  
            { 
              final item = viaticos[index].idviatico.toString();
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
                  _goDelete(viaticos[index].idviatico ?? 0);        
                  setState(() {
                        viaticos.removeAt(index);
                        total=0;
                        for (var element in viaticos) {
                        total+=element.monto??0;
                    } 
                  });     
                  },
                  background: Container(              
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                   
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
                              color: const Color.fromARGB(255, 158, 163, 177),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child:  const Image(
                                        image: AssetImage('assets/viaticos.png'),
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
                              'Cliente: ${viaticos[index].clienteNombre}',
                              style: const TextStyle(color: Colors.black, fontSize: 16),
                              maxLines: 2,
                            ),
                             Text(
                              'Placa: ${viaticos[index].placa}',
                              style: const TextStyle(color: kTextColor, fontSize: 16),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                text: 'Monto : ¢  ${NumberFormat("###,000", "en_US").format(viaticos[index].monto)}',
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

  Future<void> _getViaticos() async {
    setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.getViaticosByCierre(widget.factura.cierreActivo.cierreFinal.idcierre ?? 0);

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
      viaticos=response.result;
      for (var element in viaticos) {
        total+=element.monto??0;
      } 
    });
  }

   Future<void> _goDelete(int id) async {

     setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.delete('/api/Viaticos/',id.toString());

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
        builder: (context) => AddViaticoScreen(
          factura: widget.factura,
          
          
        )
      )
    );
    if (result == 'yes') {
      _getViaticos();
    }
  }
}