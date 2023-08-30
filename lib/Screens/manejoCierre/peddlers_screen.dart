
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/pedder_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/loader_component.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';

class PeddlersScreen extends StatefulWidget {
  final AllFact factura;
  const PeddlersScreen({ Key? key, required this.factura }) : super(key: key);

  @override
  State<PeddlersScreen> createState() => _PeddlersScreenState();
}

class _PeddlersScreenState extends State<PeddlersScreen> {
  List<PeddlerViewModel> peddlers = [];
  bool showLoader = false;
  late double total=0;

 
  @override

  void initState() {
    super.initState();
    _getPeddlers();
  }


 
   @override
  Widget build(BuildContext context) {
     return SafeArea(
       child: Scaffold(
     
        appBar: AppBar(
          backgroundColor: kBlueColorLogo,
          title: const Text('Peddlers', style: TextStyle(color: Colors.white),),
          
        ),
        body: showLoader ? const LoaderComponent(text: 'Cargando...',) : Container(
          color: kColorFondoOscuro,
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(10)),
          child: ListView.builder(
            
            itemCount: peddlers.length,
            itemBuilder: (context, index)  
            { 
              final item = peddlers[index].id.toString();
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
                  _goDelete(peddlers[index].id ?? 0);        
                  setState(() {
                        peddlers.removeAt(index);
                        total=0;                   
                        for (var element in peddlers) {
                          total+=element.cantidad??0;
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
                             Text(
                              'Cliente: ${peddlers[index].cliente}',
                              style: const TextStyle(color: Colors.black, fontSize: 16),
                              maxLines: 2,
                            ),
                       
                            Text.rich(
                              TextSpan(
                                text: 'Producto: ${peddlers[index].producto}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: kPrimaryColor),
                                                          
                              ),
                            ),
                             Text.rich(
                              TextSpan(
                                text: 'Cantidad: ${peddlers[index].cantidad}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, color: kPrimaryColor),
                                                          
                              ),
                            ),
                             Text.rich(
                              TextSpan(
                                text: 'Orden: ${peddlers[index].orden}',
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
       ),
     );

  }

   Future<void> _goDelete(int id) async {

     setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.delete('/api/Peddler/',id.toString());

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

  Future<void> _getPeddlers() async {
    setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.getPeddlersByCierre(widget.factura.cierreActivo.cierreFinal.idcierre ?? 0);

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
      peddlers=response.result;
      for (var element in peddlers) {
        total+=element.cantidad??0;
      } 
    });
  }
}