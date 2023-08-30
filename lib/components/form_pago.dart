import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/Transfers/transfer_screen.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/models/all_fact.dart';

class FormPago extends StatefulWidget {
  final AllFact factura;
  final Color fontColor;
  final Function(double) onSaldoChanged;
  final String ruta;
  const FormPago({super.key,
   required this.factura,
   required this.fontColor,
   required this.onSaldoChanged, 
   required this.ruta,
   });

  @override
  State<FormPago> createState() => _FormPagoState();
}

class _FormPagoState extends State<FormPago> {

  var cashController = TextEditingController();
  var transferController = TextEditingController();  
  var bacController = TextEditingController();
  var bnController = TextEditingController();
  var davController = TextEditingController();
  var sctiaController = TextEditingController();
  var pointsController = TextEditingController();
  var dollarController = TextEditingController();
  var chequeController = TextEditingController();
  var cuponController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    setValues();
    //calculateSaldo();
  }

  @override
  Widget build(BuildContext context) {
    return  Container( 
         
     decoration: BoxDecoration(
        color: const Color.fromARGB(255, 235, 230, 236),
         gradient: const LinearGradient(
           colors: [kBlueColorLogo, Color.fromARGB(255, 255, 255, 255)],
           begin: Alignment.centerRight,
           end:  Alignment(0.9, 0.0),
           tileMode: TileMode.clamp),
       border: Border.all(
       color: kSecondaryColor,
                   width: 1,
       ),
     ),
     child: Column(
       children: [
         Padding(
           padding: const EdgeInsets.only(right: 15),
           child: Container(
            height: 50,
            width: double.infinity,
            color: kContrateFondoOscuro,
             child:  Center(
               child: Text(
                 'Seleccione la Forma de Pago',
                 style: TextStyle(
                   color: widget.fontColor,
                   fontWeight: FontWeight.bold,
                   fontSize: 18,
                 ),
                     ),
             ),
           ),
         ),
          const SizedBox(height: 10,),   
           _showBac(),    
          const SizedBox(height: 10,), 
           _showBn(),      
          const SizedBox(height: 10,),                
          _showCash(),                  
          const SizedBox(height: 10,),
          _showDav(),
          const SizedBox(height: 10,),
          _showScotia(),   
          const SizedBox(height: 10,),
          _newPoint(),            
          const SizedBox(height: 10,),
           _showTransfers(),           
          const SizedBox(height: 10,),
          _showDollar(),          
          const SizedBox(height: 10,),
          _showCheque(),                  
          const SizedBox(height: 10,), 
          _showCupones(),    
           const SizedBox(height: 10,), 
          
         
       ],
     ),
   );
  }



  Widget _showCash() {
    return
      Container(
        padding: const EdgeInsets.only(left: 50.0, right: 50),
        child: Row(
          children: [
            Flexible(
              child: TextField(   
                controller: cashController,    
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                decoration: const InputDecoration(
                  hintText: 'Ingrese la cantidad',
                  labelText: 'Efectivo',         
                 
                
                ),
                onChanged: (value) {            
                 if (value.isNotEmpty){ 

                   setState(() {     
                         
                     widget.factura.formPago.totalEfectivo = double.parse(value);
                     widget.factura.setSaldo();
                      widget.onSaldoChanged(widget.factura.formPago.saldo);              
                     if(widget.factura.formPago.saldo < 0){                 
                       widget.factura.formPago.totalEfectivo = 0;
                       widget.factura.setSaldo(); 
                       widget.onSaldoChanged(widget.factura.formPago.saldo);
                       cashController.text= value.toString();
                      
                       Fluttertoast.showToast(
                        msg: " La cantidad es superior al saldo, por favor vuelva a ingresarla",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                      ); 
                     }
                  });  
                 
                }         
                },
              ),
            ),
             SizedBox(
            width: 60,
            child: GestureDetector(
              onTap: _goCashAll,
              child: AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Image(
                    image: AssetImage('assets/COLON.jpg'),
                  
                  )
                ),
              )
              ),
            ),


          ],
        ),
      );
  }

  Widget _showBac() {
    return
      Container(
        padding: const EdgeInsets.only(left: 50.0, right: 50),
        child: Row(
          children: [
            Flexible(
              child: TextField(  
                controller: bacController,      
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ingrese la cantidad',
                  labelText: 'Tarjeta Bac',          
                          
                ),
               onChanged: (value) {            
                 if (value.isNotEmpty){ 
                   setState(() {     
                              
                     widget.factura.formPago.totalBac = double.parse(value);
                       widget.factura.setSaldo();  
                        widget.onSaldoChanged(widget.factura.formPago.saldo);             
                     if(widget.factura.formPago.saldo < 0){                 
                       widget.factura.formPago.totalBac = 0;
                        widget.factura.setSaldo(); 
                         widget.onSaldoChanged(widget.factura.formPago.saldo);
                       bacController.text= value.toString();               
                       Fluttertoast.showToast(
                        msg: " La cantidad es superior al saldo, por favor vuelva a ingresarla",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                      ); 
                     }
                  });  
                }         
                },
              ),
            ),

             SizedBox(
            width: 60,
            child: GestureDetector(
              onTap: _goTarjetaBacAll,
              child: AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Image(
                    image: AssetImage('assets/Bac.png'),
                  
                  )
                ),
              )
              ),
            ),
          ],
        ),
      );
  }

  Widget _showBn() {
    return
      Container(
        padding: const EdgeInsets.only(left: 50.0, right: 50),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: bnController,        
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ingrese la cantidad',
                  labelText: 'Tarjeta BN',         
                           
                ),
               onChanged: (value) {            
                 if (value.isNotEmpty){ 
                   setState(() {     
                     widget.factura.formPago.saldo = widget.factura.cart.total;         
                     widget.factura.formPago.totalBn = double.parse(value);
                      widget.factura.setSaldo(); 
                       widget.onSaldoChanged(widget.factura.formPago.saldo); 
                     int valor= int.parse(value);
                     if(widget.factura.formPago.saldo < 0){                 
                       widget.factura.formPago.totalBn = 0;
                        widget.factura.setSaldo(); 
                          widget.onSaldoChanged(widget.factura.formPago.saldo);
                       bnController.text = valor.toString();                
                       Fluttertoast.showToast(
                        msg: " La cantidad es superior al saldo, por favor vuelva a ingresarla",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                      ); 
                     }
                  });  
                }         
                },
              ),
            ),

             SizedBox(
            width: 60,
            child: GestureDetector(
              onTap: _goTarjetaBN,
              child: AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Image(
                    image: AssetImage('assets/BN.jpg'),
                  
                  )
                ),
              )
              ),
            ),
          ],
        ),
      );
  }

  Widget _newPoint(){
    return Padding(
      padding: const EdgeInsets.only(left: 50.0, right: 50),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              readOnly: true,   
              controller: pointsController,    
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              decoration: const InputDecoration(
                hintText: 'Seleccione los puntos',
                labelText: 'Puntos', 
              ),          
            ),
          ),
          SizedBox(
            width: 60,
            child: GestureDetector(
              onTap: _goPoints,
              child: AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Image(
                    image: AssetImage('assets/points.jpg'),
                  
                  )
                ),
              )
              ),
            ),
        ],
      ),
    );
  
    
  }
  
  Widget _showScotia() {
    return
      Container(
        padding: const EdgeInsets.only(left: 50.0, right: 50),
        child: Row(
          children: [
            Flexible(
              child: TextField(   
                controller: sctiaController,    
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                decoration: const InputDecoration(
                  hintText: 'Ingrese la cantidad',
                  labelText: 'Tarjeta Scottia Bank',          
                  
                
                ),
                onChanged: (value) {            
                 if (value.isNotEmpty){ 
                   setState(() { 
                     widget.factura.formPago.totalSctia = double.parse(value);
                     widget.factura.setSaldo();   
                     widget.onSaldoChanged(widget.factura.formPago.saldo);            
                     if(widget.factura.formPago.saldo < 0){                 
                        widget.factura.formPago.totalSctia = 0;
                        widget.factura.setSaldo(); 
                        widget.onSaldoChanged(widget.factura.formPago.saldo);
                        sctiaController.text= value.toString();
                        Fluttertoast.showToast(
                          msg: " La cantidad es superior al saldo, por favor vuelva a ingresarla",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                        ); 
                     }
                  });  
                }         
                },
              ),
            ),

           SizedBox(
            width: 60,
            child: GestureDetector(
              onTap: _goTarjetaScotia,
              child: AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Image(
                    image: AssetImage('assets/Scottia.png'),
                  
                  )
                ),
              )
              ),
            ),
          ],
        ),
      );
  }
  
  Widget _showDav() {
    return
      Container(
        padding: const EdgeInsets.only(left: 50.0, right: 50),
        child: Row(
          children: [
            Flexible(
              child: TextField(   
                controller: davController,    
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                decoration: const InputDecoration(
                  hintText: 'Ingrese la cantidad',
                  labelText: 'Tarjeta Davivienda',            
                  
                
                ),
                onChanged: (value) {            
                 if (value.isNotEmpty){ 
                   setState(() {     
                         
                     widget.factura.formPago.totalDav = double.parse(value);
                     widget.factura.setSaldo();  
                     widget.onSaldoChanged(widget.factura.formPago.saldo);                 
                     if(widget.factura.formPago.saldo < 0){                 
                        widget.factura.formPago.totalDav = 0;
                        widget.factura.setSaldo(); 
                        widget.onSaldoChanged(widget.factura.formPago.saldo);
                        davController.text= value.toString();
                        Fluttertoast.showToast(
                          msg: "La cantidad es superior al saldo, por favor vuelva a ingresarla",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                        ); 
                     }
                  });  
                }         
                },
              ),
            ),
             SizedBox(
            width: 60,
            child: GestureDetector(
              onTap: _goTarjetaDav,
              child: AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Image(
                    image: AssetImage('assets/davicasa.png'),
                  
                  )
                ),
              )
              ),
            ),
          ],
        ),
      );
  }
  
  Widget _showDollar() {
    return
      Container(
        padding: const EdgeInsets.only(left: 50.0, right: 50),
        child: Row(
          children: [
            Flexible(
              child: TextField(   
                controller: dollarController,    
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                decoration: const InputDecoration(
                  hintText: 'Ingrese la cantidad',
                  labelText: 'Dollares',            
                  
                
                ),
                onChanged: (value) {            
                 if (value.isNotEmpty){ 
                   setState(() {     
                         
                     widget.factura.formPago.totalDollars = double.parse(value);
                      widget.factura.setSaldo();   
                        widget.onSaldoChanged(widget.factura.formPago.saldo);                 
                     if(widget.factura.formPago.saldo < 0){                 
                       widget.factura.formPago.totalDollars = 0;
                         widget.factura.setSaldo(); 
                          widget.onSaldoChanged(widget.factura.formPago.saldo);
                       dollarController.text= value.toString();
                       Fluttertoast.showToast(
                        msg: "La cantidad es superior al saldo, por favor vuelva a ingresarla",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                      ); 
                     }
                  });  
                }         
                },
              ),
            ),
             SizedBox(
            width: 60,
            child: GestureDetector(
              onTap: _goDollar,
              child: AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Image(
                    image: AssetImage('assets/dollar.png'),
                  
                  )
                ),
              )
              ),
            ),
          ],
        ),
      );
  }

  Widget _showCheque() {
    return
      Container(
        padding: const EdgeInsets.only(left: 50.0, right: 50),
        child: Row(
          children: [
            Flexible(
              child: TextField(   
                controller: chequeController,    
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                decoration: const InputDecoration(
                  hintText: 'Ingrese la cantidad',
                  labelText: 'Cheque',            
                  
                
                ),
                onChanged: (value) {            
                 if (value.isNotEmpty){ 
                   setState(() {     
                         
                     widget.factura.formPago.totalCheques = double.parse(value);
                      widget.factura.setSaldo();  
                       widget.onSaldoChanged(widget.factura.formPago.saldo);            
                     if(widget.factura.formPago.saldo < 0){                 
                       widget.factura.formPago.totalCheques = 0;
                         widget.factura.setSaldo(); 
                          widget.onSaldoChanged(widget.factura.formPago.saldo);
                       cashController.text= value.toString();
                       Fluttertoast.showToast(
                        msg: "La cantidad es superior al saldo, por favor vuelva a ingresarla",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                      ); 
                     }
                  });  
                }         
                },
              ),
            ),
             SizedBox(
            width: 60,
            child: GestureDetector(
              onTap: _goCheque,
              child: AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Image(
                    image: AssetImage('assets/CHEQUE.jpg'),
                  
                  )
                ),
              )
              ),
            ),
          ],
        ),
      );
  }

  Widget _showCupones() {
    return
      Container(
        padding: const EdgeInsets.only(left: 50.0, right: 50),
        child: Row(
          children: [
            Flexible(
              child: TextField(   
                controller: cuponController,    
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                decoration: const InputDecoration(
                  hintText: 'Ingrese la cantidad',
                  labelText: 'Cupones',            
                  
                
                ),
                onChanged: (value) {            
                 if (value.isNotEmpty){ 
                   setState(() {     
                         
                     widget.factura.formPago.totalCupones = double.parse(value);
                       widget.factura.setSaldo();
                        widget.onSaldoChanged(widget.factura.formPago.saldo);               
                     if(widget.factura.formPago.saldo < 0){                 
                       widget.factura.formPago.totalCupones = 0;
                         widget.factura.setSaldo();
                          widget.onSaldoChanged(widget.factura.formPago.saldo); 
                       cuponController.text= value.toString();
                       Fluttertoast.showToast(
                        msg: "La cantidad es superior al saldo, por favor vuelva a ingresarla",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                      ); 
                     }
                  });  
                }         
                },
              ),
            ),
             SizedBox(
            width: 60,
            child: GestureDetector(
              onTap: _goCupon,
              child: AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Image(
                    image: AssetImage('assets/CUPONES.png'),
                  
                  )
                ),
              )
              ),
            ),
          ],
        ),
      );
  }

  Widget _showTransfers() {
      if(widget.factura.formPago.transfer.totalTransfer > 0){
        transferController.text=  widget.factura.formPago.transfer.totalTransfer.toInt().toString(); 
      }
    return
      Container(
        padding: const EdgeInsets.only(left: 50.0, right: 50),
        child: Row(
          children: [
            Flexible(
              child: TextField(  
                readOnly: true, 
                controller: transferController,    
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Seleccione la transferencia',
                  labelText: 'Transferencias',            
                          
                ),          
              ),
            ),
            SizedBox(
            width: 60,
            child: GestureDetector(
              onTap: _goTransfers,
              child: AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Image(
                    image: AssetImage('assets/transferencia.png'),
                  
                  )
                ),
              )
              ),
            ),
          ],
        ),
      );
  }

  void _goCashAll() {
    if(widget.factura.formPago.saldo<=0){        
         Fluttertoast.showToast(
            msg: "La factura ya no tiene saldo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
        return;
    }
    
    setState(() {
        widget.factura.setSaldo(); 
      widget.factura.formPago.totalEfectivo += widget.factura.formPago.saldo;
      cashController.text= widget.factura.formPago.totalEfectivo.toInt().toString();
        widget.factura.setSaldo(); 
         widget.onSaldoChanged(widget.factura.formPago.saldo);
      
    });
  }

  void _goTarjetaBacAll() {
    if(widget.factura.formPago.saldo<=0){
        Fluttertoast.showToast(
            msg: "La factura ya no tiene saldo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
        return;
    }
    
    setState(() {
        widget.factura.setSaldo(); 
      widget.factura.formPago.totalBac += widget.factura.formPago.saldo;
      bacController.text=widget.factura.formPago.totalBac.toInt().toString();
       widget.factura.setSaldo(); 
       widget.onSaldoChanged(widget.factura.formPago.saldo);
    });
  }

  void _goTarjetaBN() {
    if(widget.factura.formPago.saldo<=0){
        Fluttertoast.showToast(
            msg: "La factura ya no tiene saldo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
        return;
    }
    
     setState(() {
        widget.factura.setSaldo(); 
      widget.factura.formPago.totalBn += widget.factura.formPago.saldo;
      bnController.text=widget.factura.formPago.totalBn.toInt().toString();
       widget.factura.setSaldo(); 
       widget.onSaldoChanged(widget.factura.formPago.saldo);
    });
  }

  void _goTarjetaScotia() {
    if(widget.factura.formPago.saldo<=0){
        Fluttertoast.showToast(
            msg: "La factura ya no tiene saldo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
        return;
    }
    
    setState(() {
        widget.factura.setSaldo(); 
        widget.factura.formPago.totalSctia += widget.factura.formPago.saldo;
        sctiaController.text= widget.factura.formPago.totalSctia.toInt().toString();
        widget.factura.setSaldo(); 
        widget.onSaldoChanged(widget.factura.formPago.saldo);
    });
  }

  void _goTarjetaDav() {
    if(widget.factura.formPago.saldo<=0){
        Fluttertoast.showToast(
            msg: "La factura ya no tiene saldo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
        return;
    }
    
    setState(() {
      widget.factura.setSaldo(); 
      widget.factura.formPago.totalDav += widget.factura.formPago.saldo;
      davController.text= widget.factura.formPago.totalDav.toInt().toString();
      widget.factura.setSaldo(); 
      widget.onSaldoChanged(widget.factura.formPago.saldo);
    });
  }

  void _goDollar() {
    if(widget.factura.formPago.saldo<=0){
        Fluttertoast.showToast(
            msg: "La factura ya no tiene saldo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
        return;
    }    
    setState(() {
       widget.factura.setSaldo(); 
      widget.factura.formPago.totalDollars += widget.factura.formPago.saldo;
      dollarController.text= widget.factura.formPago.totalDollars.toInt().toString();
        widget.factura.setSaldo();
         widget.onSaldoChanged(widget.factura.formPago.saldo);       
    });
  }

  void _goCheque() {
    if(widget.factura.formPago.saldo<=0){
        Fluttertoast.showToast(
            msg: "La factura ya no tiene saldo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
        return;
    }    
    setState(() {
       widget.factura.setSaldo(); 
      widget.factura.formPago.totalCheques += widget.factura.formPago.saldo;
      chequeController.text= widget.factura.formPago.totalCheques.toInt().toString();
        widget.factura.setSaldo();
         widget.onSaldoChanged(widget.factura.formPago.saldo);      
    });
  }

  void _goCupon() {
    if(widget.factura.formPago.saldo<=0){
       Fluttertoast.showToast(
            msg: "La factura ya no tiene saldo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
        return;
    }    
    setState(() {
        widget.factura.setSaldo(); 
      widget.factura.formPago.totalCupones += widget.factura.formPago.saldo;
      cuponController.text= widget.factura.formPago.totalCupones.toInt().toString();
       widget.factura.setSaldo();  
        widget.onSaldoChanged(widget.factura.formPago.saldo);    
    });
  }

  void _goPoints() {
     if(widget.factura.formPago.saldo<=0){
         Fluttertoast.showToast(
            msg: "La factura ya no tiene saldo",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
         return;
     }    
    
     if(widget.factura.formPago.clientePaid.nombre.isEmpty){
       Fluttertoast.showToast(
            msg: "Seleccione el Cliente Frecuente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
        return;
     }   

     if(widget.factura.formPago.clientePaid.puntos==0){
       Fluttertoast.showToast(
            msg: "El cliente no tiene puntos",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          ); 
        return;
     } 

      if(widget.factura.formPago.saldo < widget.factura.formPago.clientePaid.puntos){       
          widget.factura.formPago.totalPuntos = widget.factura.formPago.saldo;  
      }
      else{
        widget.factura.formPago.totalPuntos =  widget.factura.formPago.clientePaid.puntos.toDouble();
      }

      setState(() {          
           pointsController.text= widget.factura.formPago.totalPuntos.toInt().toString();
             widget.factura.setSaldo();  
              widget.onSaldoChanged(widget.factura.formPago.saldo);     
      });
    
  }
  
  void _goTransfers() {   
    transferController.text='';
    setState(() {
       widget.factura.setSaldo();         
       widget.onSaldoChanged(widget.factura.formPago.saldo);
       widget.factura.formPago.transfer.totalTransfer=widget.factura.formPago.saldo;
    });
   
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => TransferScreen(
          factura: widget.factura,
         
          ruta: widget.ruta,
        )));
  }
 
  void setValues() {
    setState(() {
      if(widget.factura.formPago.totalEfectivo>0){
        cashController.text= widget.factura.formPago.totalEfectivo.toInt().toString();
      }
      if(widget.factura.formPago.totalDollars>0){
        dollarController.text= widget.factura.formPago.totalDollars.toInt().toString();
      }
      if(widget.factura.formPago.totalCheques>0){
        chequeController.text= widget.factura.formPago.totalCheques.toInt().toString();
      }
      if(widget.factura.formPago.totalCupones>0){
        cuponController.text= widget.factura.formPago.totalCupones.toInt().toString();
      }
      if(widget.factura.formPago.totalPuntos>0){
        pointsController.text= widget.factura.formPago.totalPuntos.toInt().toString();
      }
      if(widget.factura.formPago.transfer.totalTransfer>0){
        transferController.text= widget.factura.formPago.transfer.totalTransfer.toInt().toString();
      }
      if(widget.factura.formPago.totalBac>0){
        bacController.text= widget.factura.formPago.totalBac.toInt().toString();
      }
      if(widget.factura.formPago.totalBn>0){
        bnController.text= widget.factura.formPago.totalBn.toInt().toString();
      }
      if(widget.factura.formPago.totalDav>0){
        davController.text= widget.factura.formPago.totalDav.toInt().toString();
      }
      if(widget.factura.formPago.totalSctia>0){
        sctiaController.text= widget.factura.formPago.totalSctia.toInt().toString();
      }
    
    });
  }

}