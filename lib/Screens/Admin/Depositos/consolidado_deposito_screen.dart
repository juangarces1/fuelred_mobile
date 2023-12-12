import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/Admin/ComponentsShared/app_bar_custom.dart';
import 'package:fuelred_mobile/Screens/Admin/Depositos/detail_deposits_screen.dart';
import 'package:fuelred_mobile/components/default_button.dart';
import 'package:fuelred_mobile/components/my_loader.dart';
import 'package:fuelred_mobile/components/no_contetnt.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:fuelred_mobile/modelsAdmin/DepostosConsolidado/consolidado_deposito.dart';
import 'package:fuelred_mobile/modelsAdmin/DepostosConsolidado/deposito_cierre.dart';
import 'package:fuelred_mobile/sizeconfig.dart';


class ConsolidadoDepositoScreen extends StatefulWidget {
  
  const ConsolidadoDepositoScreen({super.key, });

  @override
  State<ConsolidadoDepositoScreen> createState() => _ConsolidadoDepositoScreenState();
}

class _ConsolidadoDepositoScreenState extends State<ConsolidadoDepositoScreen> with SingleTickerProviderStateMixin {
  
  ConsolidadoDeposito consolidado =
   ConsolidadoDeposito(date: '', idConsolidado: 0, cierres: []);
  late TabController _tabController;
  bool showLoader = false;
  late int total=0;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
     _tabController = TabController(length: 2, vsync: this);
   
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        appBar:  MyCustomAppBar(
         
        title: 'Depositos',
        automaticallyImplyLeading: true,   
        backgroundColor: kPrimaryColor,
        elevation: 8.0,
        shadowColor: Colors.blueGrey,
        foreColor: Colors.white,
        actions: [ 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipOval(child:  Image.asset(
                  'assets/splash.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),), // Ícono de perfil de usuario
            ),
        ],
            bottom:  TabBar(
              indicatorColor: Colors.white,
              controller: _tabController,
              labelColor: Colors.white, // Color for selected tab
              unselectedLabelColor: Colors.grey, // Color for unselected tabs
              tabs:  const [
                Tab(text: 'Seleccione el Dia'),
                Tab(text: 'Cierres'),
              ],
            ),      ),
        body:  TabBarView(
          controller: _tabController,
          children: [
            _buildFilterTab(),
            _getContent(),
          ],
        ),
       
       
      ),
    );
  }

  Future<void> _getdepositos() async {
    setState(() {
      showLoader = true;
    });
    
   Response response = await ApiHelper.getDepositosByConsolidado(selectedDate.toString());

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

     if(response.message ==''){
       Fluttertoast.showToast(
          msg: 'No se encontraron datos para esta fecha',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.amber,
          textColor: Colors.white,
          fontSize: 16.0
        ); 
        return;
     }

   

    setState(() {
      consolidado = response.result;
       
       _tabController.animateTo(1);
      
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

  _getContent() {
   return   consolidado.idConsolidado == 0 ? const MyNoContent(text: 'No hay Datos',) 
    : Container(
  color: const Color.fromARGB(255, 226, 225, 223),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
        SizedBox(height: getProportionateScreenHeight(10)),
       Container(
          width: double.infinity,
        
        color: Colors.white,
         child: Center(
           child: Text(
            'Cierres dia: ${consolidado.date.substring(0,10)}', // Replace with your actual title
            style: myHeadingStylePrymary,
                 ),
         ),
       ),
      const SizedBox(height: 10), // Add a bit of spacing
      Expanded(
        child: ListView.builder(
          itemCount: consolidado.cierres.length,
          itemBuilder: (context, index) {
            final item = consolidado.cierres[index];
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 10, left: 10, right: 10),
              child: InkWell(
                onTap: () => goDetail(item),
                child: Card(
                  color: areAllDepositsSelected(item)
                      ? Colors.green
                      : const Color.fromARGB(255, 252, 251, 251),
                  shadowColor: const Color.fromARGB(255, 155, 172, 180),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)
                  ),
                  child: Padding(
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
          },
        ),
      ),
    ],
  ),
);

  }
  
  _buildFilterTab() {
     return SizedBox(
    width: double.infinity, // Ocupa todo el ancho disponible
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Center(
                 child: Text(
                  'Seleccione la fecha',
                  style: myHeadingStylePrymary
                  ),
               ),
                const SizedBox(height: 10),
               Container(
                padding: const EdgeInsets.all(10), // Adds some padding around the calendar
                decoration: BoxDecoration(
                  color: Colors.white, // Changes the background color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // Changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12), // Rounds the corners
                ),
                child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
              ),
            const SizedBox(height: 10),
              Center(
                child: DefaultButton(
                  text: 'Buscar',
                  press: _getdepositos,
                ),
              ),
            ],
          ),
          showLoader ? const CustomActivityIndicator(loadingText: 'Procesando...',) : Container(),
        ],
      ),
    ),
   );
  

  }

  


    
}