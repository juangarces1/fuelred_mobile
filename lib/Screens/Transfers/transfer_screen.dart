
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/tickets/ticket_screen.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/tranferview.dart';
import 'package:fuelred_mobile/models/transparcial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/api_helper.dart';
import '../../models/response.dart';
import '../../sizeconfig.dart';
import '../checkout/checkount.dart';


class TransferScreen extends StatefulWidget {

  final AllFact factura; 
  final String ruta;
  // ignore: use_key_in_widget_constructors
  const TransferScreen({
     required this.factura,     
     required this.ruta,
   });

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

 class _TransferScreenState extends State<TransferScreen> {
  List<Transferview> _transfers =[];
  final List<Transferview> _transferenciasAux =[];
 
  bool _showLoader = false;
  final bool _isFiltered = false;
  bool showTransfer = true;


  @override
  void initState() {
    super.initState();
    _getTransfers();
   // setUpTransfer();
  }
  
  @override
 Widget build(BuildContext context) {  
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: appBar1(),
        ),
        body: Container(
          color:   const Color.fromARGB(255, 70, 72, 77),
          child: Center(
            child: _showLoader ? const LoaderComponent(text: 'Por favor espere...') 
            : _getContent(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: const Icon(Icons.arrow_forward_ios),
          onPressed: () => _goAdd(),
        ),    
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
         bottomNavigationBar: Container(
          height: 80,
          color: Colors.black,          
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
            child: Row(
              children: [               
                  SizedBox(
                    width: 70,
                    child: GestureDetector(
                      onTap: () {
                      setState(() {
                        showTransfer = !showTransfer;
                      });
                    },    
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Image(
                              image: AssetImage('assets/transferencia.png'),
                          
                          )
                        ),
                      )
                      ),
                    ),
              ],
            )
          ),
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
            
   
             Text('Transferencias(${widget.factura.formPago.transfer.transfers.length})',
              style: const TextStyle(color: kPrimaryColor, fontSize: 14, fontWeight: FontWeight.bold),),
              
             Text('Saldo: ${NumberFormat("###,000", "en_US").format(widget.factura.formPago.saldo)}',
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
              
               
             ],
           ),
         )
       ],
     ),
   );
 }

 void _goBack() async {
    widget.factura.formPago.transfer.totalTransfer=0;
    widget.factura.formPago.totalTransfer=0;
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

 Future<void> _getTransfers() async {
    setState(() {
      _showLoader = true;
    });

   
    Response response = await ApiHelper.getTransfes();

    setState(() {
      _showLoader = false;
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
      _transfers = response.result;
    });
    setUpTransfer();
  }

 Widget _getContent() {
    return _transfers.isEmpty 
      ? _noContent()
      : newContent();
  }

 Widget _noContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'No hay transferencias con ese criterio de búsqueda.'
          : 'No hay transferencias registradas.',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

 Widget _getContentTP() {
    return widget.factura.formPago.transfer.transfers.isEmpty 
      ? _noContentTp()
      : _parcialTransferList();
  }

 Widget _noContentTp() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: const Text(        
         
          'No hay transferencias Seleccionadas.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

 Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getTransfers,
      child: ListView(
        children: _transfers.map((e) {
          return Padding(
            padding: const EdgeInsets.only(right: 5, left: 5),
            child: Card(

               color:  const Color.fromARGB(255, 198, 201, 209),
                    shadowColor: const Color.fromARGB(255, 16, 38, 54),
                    elevation: 7,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), 
              child: InkWell(
                onTap: () => _addTRansfer(e),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [                    
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.cliente, 
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      'Deposito: ${e.numeroDeposito}', 
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: kTextColor
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                     'Monto: ¢ ${NumberFormat("###,000", "en_US").format(e.monto)}', 
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                         color: kTextColor
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                        'Saldo: ¢ ${NumberFormat("###,000", "en_US").format(e.saldo)}', 
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                         color: kPrimaryColor
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
 
 Widget cardTranser(TransParcial tr) {
    return Card( 
      color:  const Color.fromARGB(255, 198, 201, 209),
      shadowColor: const Color.fromARGB(255, 16, 38, 54),
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), 
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [                    
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr.cliente, 
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            'Deposito: ${tr.numeroDeposito}', 
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kTextColor
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                           'Aplicado: ¢ ${NumberFormat("###,000", "en_US").format(tr.aplicado)}', 
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                               color: kTextColor
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                              'Saldo: ¢ ${NumberFormat("###,000", "en_US").format(tr.saldo)}', 
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                               color: kPrimaryColor
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
           
          ],
        ),
      ),

    );
  }

 Widget _parcialTransferList() {
    return  Padding(
        padding:
        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: 
        ListView.builder(
          itemCount: widget.factura.formPago.transfer.transfers.length,
          itemBuilder: (context, index) {
            final item = widget.factura.formPago.transfer.transfers[index].numeroDeposito;
           return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Dismissible(
              key: Key(item),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {              
                setState(() {               
                  _transfers.add(_transferenciasAux[index]);
                  widget.factura.formPago.transfer.transfers.removeAt(index);
                  _transferenciasAux.removeAt(index);
                  orderTransfer();
                  widget.factura.setSaldo();
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
              child: cardTranser(widget.factura.formPago.transfer.transfers[index]),
              
            ),
           );  
          },    
        ),
        );
  }
 
 void _addTRansfer(Transferview e) async {
    if (!IsClientRigth(e)){
       Fluttertoast.showToast(
            msg: "Seleccione transferencias del mismo cliente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 215, 27, 17),
            textColor: Colors.white,
            fontSize: 16.0
          ); 
      
      return;
    }
    //Creamos la transferencia parcial
    TransParcial transParcial = TransParcial(
      id: e.id,
      saldo: e.saldo,
      aplicado: 0,
      cuenta: e.cuenta,
      numeroDeposito: e.numeroDeposito,
      cliente: e.cliente
    );
    //Agregamos la tranferencia parcial a la lista de transferencias parciales
    widget.factura.formPago.transfer.transfers.add(transParcial);

    //Removemos la transferencia de la lista de transferencias
    setState(() {
      _transferenciasAux.add(e);
      _transfers.remove(e);
      showTransfer = !showTransfer;
    });
    
  }

  // ignore: non_constant_identifier_names
 bool IsClientRigth(Transferview trans){
      if (widget.factura.formPago.transfer.transfers.isEmpty){
         return true;
      }
      else {
        if (widget.factura.formPago.transfer.transfers.last.cliente != trans.cliente){
          return false;
        }
      }


      return true;
  }

 void _goAdd() async {

     if (widget.factura.formPago.transfer.transfers.isEmpty){
       Fluttertoast.showToast(
            msg: "Seleccione al menos una transferencia",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 207, 10, 10),
            textColor: Colors.white,
            fontSize: 16.0
          );  
       return;
     }
     double saldo = widget.factura.formPago.saldo;   
     setState(() {       
          
        for (var element in widget.factura.formPago.transfer.transfers) {            
            saldo -= element.saldo;
           // widget.factura.formPago.transfer.transfers.add(element); 
          }
            
          if(saldo > 0 ){
            widget.factura.formPago.transfer.totalTransfer-=saldo;
          }
          widget.factura.formPago.transfer.monto = widget.factura.formPago.transfer.totalTransfer;
          widget.factura.formPago.totalTransfer = widget.factura.formPago.transfer.totalTransfer;
          widget.factura.setSaldo();
      }); 

     if(widget.ruta=='factura'){
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
  
 Widget newContent() {   
    return Container(
      child: showTransfer ? _getListView() : _getContentTP(),
    );
  }
 
  void orderTransfer() {
    _transfers.sort((a, b) {
      return a.cliente.compareTo(b.cliente);
    });
  }
 
 void setUpTransfer() {
   for (var element in widget.factura.formPago.transfer.transfers) {
     Transferview transferview = Transferview(
       id: element.id,
       saldo: element.saldo,
       cuenta: element.cuenta,
       numeroDeposito: element.numeroDeposito,
       cliente: element.cliente,
       monto: element.saldo,
     );
     _transferenciasAux.add(transferview);

     //search and remove from _transfers where numerodeposito = element.numerodeposito
     if(_transfers.isNotEmpty){
        Transferview tr = _transfers.firstWhere((elemento) => elemento.numeroDeposito == transferview.numeroDeposito);
       _transfers.remove(tr);
     }
    
   }
  }

}