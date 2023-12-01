import 'package:flutter/material.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/modelsAdmin/DepostosConsolidado/deposito_cierre.dart';
import 'package:fuelred_mobile/sizeconfig.dart';
import 'package:intl/intl.dart';

class DetailDepositsScreen extends StatefulWidget {
  final DepositoCierre cierre;
  final Function onDepositSelectionChanged;
  const DetailDepositsScreen({
      super.key,
      required this.cierre,
      required this.onDepositSelectionChanged,
   });

  @override
  State<DetailDepositsScreen> createState() => _DetailDepositsScreenState();
}

class _DetailDepositsScreenState extends State<DetailDepositsScreen> {
  
   bool showLoader = false;
   int total = 0;
 
 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
           foregroundColor: Colors.white,
          backgroundColor: kBlueColorLogo,
          title:  Text('Depositos Cierre #${widget.cierre.idCierre.toString()}', style: const TextStyle(color: Colors.white),),
         
        ),
        body:  Container(
          color: Colors.white70,
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10), vertical: getProportionateScreenHeight(10)),
          child: ListView.builder(
            
            itemCount: widget.cierre.depositos.length,
            itemBuilder: (context, index)  
            { 
             return 
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                       widget.cierre.depositos[index].selected = !widget.cierre.depositos[index].selected!;
                    });
                    widget.onDepositSelectionChanged();                    
                  },
                  child: Card(
                     color: widget.cierre.depositos[index].selected ?? false ? Colors.amber : Colors.white,
                     shadowColor: Colors.blueGrey,
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                                widget.cierre.depositos[index].moneda.toString(),
                                style: const TextStyle(color: Colors.black, fontSize: 16),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 10),
                              Text.rich(
                                TextSpan(
                                  text: 'Monto : ¢  ${NumberFormat("###,000", "en_US").format(widget.cierre.depositos[index].monto)}',
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
        ),
           
      
      ),
    );
  }

 
}