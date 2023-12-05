import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelred_mobile/Screens/checkout/checkount.dart';
import 'package:fuelred_mobile/Screens/tickets/ticket_screen.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:fuelred_mobile/models/sinpe.dart';
import 'package:fuelred_mobile/sizeconfig.dart';
import 'package:intl/intl.dart';

class ListaSinpesScreen extends StatefulWidget {
  final AllFact factura; 
  final String ruta;
  
  const ListaSinpesScreen({super.key , required this.factura, required this.ruta});

  @override
  State<ListaSinpesScreen> createState() => _ListaSinpesScreenState();
}

class _ListaSinpesScreenState extends State<ListaSinpesScreen> {
  List<Sinpe> sinpes =[];
  
 
  bool showLoader = false;
  
   @override
  void initState() {
    super.initState();
    _getSinpes();
  
  }
 
  
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:  const Size.fromHeight(75),
          child: appBar1(),
        ),
        body:  Stack(
          children: [
              getContent(),
              showLoader
                  ? const LoaderComponent(
                      text: 'Por favor espere...',
                    )
                  : Container(),
          ],
          
        ),
         
       
      ),
    );
  }
  

  
  Widget appBar1() {
   return Container(
     padding:
       EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20), vertical: getProportionateScreenHeight(10)),
    width: double.infinity,
    color: Colors.black,
     child: Row(          
       children: [
         SizedBox(
           height: getProportionateScreenWidth(40),
           width: getProportionateScreenWidth(40),
           child: TextButton(
             style: TextButton.styleFrom(
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(60),
               ),
              
               backgroundColor: const Color.fromARGB(255, 231, 225, 225),
               padding: EdgeInsets.zero,
             ),
            
             onPressed: () => _goBack(),  
             child: SvgPicture.asset(
               "assets/Back ICon.svg",
               height: 15,
               // ignore: deprecated_member_use
               color: kPrimaryColor,
             ),
           ),
         ),
         const Spacer(),
         Container(
           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
           decoration: BoxDecoration(
             color: Colors.black,
             borderRadius: BorderRadius.circular(14),
           ),
           child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
             children: [          
   
           
             Text('Saldo: ${NumberFormat("###,000", "en_US").format(widget.factura.formPago!.saldo)}',
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                             
             ],
           ),
         )
       ],
     ),
   );
 }

 void _goBack() async {
    widget.factura.formPago!.transfer.totalTransfer=0;
    widget.factura.formPago!.totalTransfer=0;
    setState(() {
      widget.factura.setSaldo();
    });
    if(widget.ruta=='Contado'){
        Navigator.push(context,  
          MaterialPageRoute(
          builder: (context) => CheaOutScreen(
            factura: widget.factura,
           
          )
        )
       ); 
    }
    else{
         Navigator.push(context,  
          MaterialPageRoute(
          builder: (context) => TicketScreen(
            factura: widget.factura,
           
          )
        )
       ); 
    }
    
  }
  
  _goAdd(Sinpe sinpe) {
         
     //show tast to say the saldo is not riagth
      if(sinpe.monto > widget.factura.formPago!.saldo){
        showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content:  const Text('El monto del sinpe no puede ser mayor que el saldo de la factura'),
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
        return;
      }


     setState(() {      
          
       
          widget.factura.formPago!.sinpe = sinpe;
          widget.factura.formPago!.totalSinpe = sinpe.monto;
          widget.factura.setSaldo();
      }); 

     if(widget.ruta=='Contado'){
        Navigator.push(context,  
          MaterialPageRoute(
          builder: (context) => CheaOutScreen(
            factura: widget.factura,
           
          )
        )
       ); 
    }
    else{
         Navigator.push(context,  
          MaterialPageRoute(
          builder: (context) => TicketScreen(
            factura: widget.factura,
           
          )
        )
       ); 
    } 
  }
  
  getContent() {
    return sinpes.isNotEmpty  ? _listSinpes() : _noContent();
  }

   Future<void> _getSinpes() async {
    setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.getSinpes(widget.factura.cierreActivo!.cierreFinal.idcierre ?? 0);

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
        sinpes=response.result;
        //remove the sinpes that are already paid
        sinpes.removeWhere((element) => element.activo==1);     
    });
  }
  
  _listSinpes() {
    return Container(
          color: kColorFondoOscuro,
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(10)),
          child: ListView.builder(
            
            itemCount: sinpes.length,
            itemBuilder: (context, index)  
            { 
             
              return Card(
                color: kContrateFondoOscuro,
                shadowColor: kPrimaryColor,
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _goAdd(sinpes[index]),
                      child: SizedBox(
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
                                        image: AssetImage('assets/sinpe.png'),
                                        fit: BoxFit.fill,
                                    ),
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
                            sinpes[index].activo == 1 ? 'Estado: Aplicado' : 'Estado: Disponible',
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
                            maxLines:1,
                          ),
                          Text(
                            'Fecha: ${DateFormat('dd/MM/yyyy').format(sinpes[index].fecha)}',
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
                            maxLines:1,
                          ),
                          Text(
                            'Pistero: ${sinpes[index].nombreEmpleado}',
                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
                            maxLines:1,
                          ),
                       
                          Text.rich(
                            TextSpan(
                              text: 'Monto : ¢  ${NumberFormat("###,000", "en_US").format(sinpes[index].monto)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, color: kPrimaryColor),
                                                        
                            ),
                          ),
                             Text(
                            'Nota: ${sinpes[index].nota}',
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
             ),
              );
            }        
          ),
          ),
        );
  }
  
  _noContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No hay sinpes Disponibles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            'assets/sinpe.png',
            width: 150,
            height: 150,
          ),
        ],
      ),
    );
  }
}