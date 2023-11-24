import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:fuelred_mobile/Screens/Admin/Cartera/cartera_screen.dart';
import 'package:fuelred_mobile/Screens/Transfers/add_transfer_screen.dart';
import 'package:fuelred_mobile/Screens/Transfers/list_transfers_screen.dart';
import 'package:fuelred_mobile/Screens/facturas/info_factura_screen.dart';
import 'package:fuelred_mobile/clases/show_alert_factura.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/graficas/my_line_chart.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/ad,min/dash.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:fuelred_mobile/sizeconfig.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}



class _DashboardScreenState extends State<DashboardScreen> {


  bool showLoader = false;
  Dash? dash;

  //make a initState method
  @override
  void initState() {
    
    super.initState();
    getData();
  }  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:   const Row(
            children: [  
             SizedBox(
              height: 70,
              width: 210,
              child: Image(image: AssetImage('assets/LogoSinFondo.png')
              ,fit: BoxFit.contain,
             
              )) 
            ],
          ),
          actions: const [
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.account_circle), // Ícono de perfil de usuario
            ),
          ],
          elevation: 8,
          shadowColor: Colors.blueAccent,
        ),
        drawer: menu(),
        body:    Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10,),
                   SummaryCard(
                    title: 'Inv Diesel', 
                    value: dash?.invDiesel?.toString() ?? '0',
                    iconData: FlutterIcons.sale_mco,
                    color: Colors.green,
                  ),
                     SummaryCard(
                    title: 'Inv Regular', 
                    value: dash?.invRegular?.toString() ?? '0',
                    iconData: FlutterIcons.sale_mco,
                    color: Colors.red,
                  ),
                     SummaryCard(
                    title: 'Inv Super', 
                     value: dash?.invSuper?.toString() ?? '0',
                    iconData: FlutterIcons.sale_mco,
                    color: Colors.indigo,
                  ),
                    SummaryCard(
                    title: 'Inv Exonerado', 
                     value: dash?.invExo?.toString() ?? '0',
                    iconData: FlutterIcons.sale_mco,
                    color: Colors.blue,
                  ),
    
               //  SalesBarChart(salesData: salesData),
                const SizedBox(height: 10,),
                const Text('Ventas Ultimos 7 dias', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor )),

                 Container(
                    height: 250,
                    padding: const EdgeInsets.all(16),
                    child: dash != null 
                      ? MyLineChart(salesData: dash!.salesData!)
                      : const Center(child: CircularProgressIndicator()), // Muestra un spinner mientras salesData es nulo
                  ),
                  // Agrega más tarjetas de resumen aquí
                ],
              ),
            ),
            showLoader ? const LoaderComponent(text: 'Cargando',) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

   Future<void>  getData() async {
     setState(() {
      showLoader = true;
    });

    
    Response response = await ApiHelper.getSales();

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
        dash = response.result;
     });

  }

    Widget menu() {
    return SafeArea(
      child: Drawer(        
        backgroundColor: const Color(0xff212529),
        child: ListView(
         itemExtent: 50,
          padding: EdgeInsets.zero,
          children: <Widget>[ const SizedBox(         
            height: 50,
            width: 120,         
            child: DrawerHeader(          
               margin: EdgeInsets.zero,
               padding: EdgeInsets.zero,
               decoration: BoxDecoration(               
               color: Color.fromARGB(255, 241, 244, 245), 
               image: DecorationImage(
                 scale: 5.5,
                 image:  AssetImage('assets/LogoSinFondo.png'))),
                   child: SizedBox()),
          ),     

           ListTile(
              textColor: kColorMenu,
              leading: const Icon(Icons.search , color: kColorMenu,),
              title: const Text('Buscar Factura'),
              onTap: () async {
                String? numberInput = await ShowAlertFactura.show(context);
                if (numberInput != null) {
                  // Haz algo con el número, por ejemplo, navegar a otra pantalla
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InfoFacturaScreen(numeroFactura: numberInput),
                  ));
                }
              },
            ),

            ListTile(
                textColor: kColorMenu,
              leading: const Icon(Icons.double_arrow_outlined , color: kColorMenu,),
              title: const Text('Crear Transferencia'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => const AddTransferScreen()
                   )
                 );
              },
            ),

           

           ListTile(
                textColor: kColorMenu,
              leading: const Icon(Icons.double_arrow_outlined , color: kColorMenu,),
              title: const Text('Lista Transferencia'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => const  ListTransferScreen()
                   )
                 );
              },
            ),

             ListTile(
                textColor: kColorMenu,
              leading: const Icon(Icons.wallet_outlined , color: kColorMenu,),
              title: const Text('Cartera'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => const  CarteraScreen()
                   )
                 );
              },
            ),

           

          
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData iconData;
  final Color color;

  const SummaryCard({super.key, 
    required this.title, 
    required this.value, 
    required this.iconData, 
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                  decoration: BoxDecoration(
                    color: kTextColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image(
                        image: title =='Inv Super' ?  const AssetImage('assets/super.png') : 
                              title =='Inv Regular' ? const AssetImage('assets/regular.png') : 
                              title =='Inv Exonerado' ? const AssetImage('assets/exonerado.png') :
                              const AssetImage('assets/diesel.png'),
                              fit: BoxFit.cover,
                    ),
                ),
              ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


}


