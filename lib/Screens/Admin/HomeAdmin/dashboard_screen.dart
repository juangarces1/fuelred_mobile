import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:fuelred_mobile/Screens/Admin/Cartera/cartera_screen.dart';
import 'package:fuelred_mobile/Screens/Admin/Depositos/consolidado_deposito_screen.dart';
import 'package:fuelred_mobile/Screens/Admin/HomeAdmin/Components/summary_card.dart';
import 'package:fuelred_mobile/Screens/Admin/Inventario/invent_form_screen.dart';
import 'package:fuelred_mobile/Screens/Admin/ReumenDia/resumen_dia_screen.dart';
import 'package:fuelred_mobile/Screens/Transfers/list_transfers_screen.dart';
import 'package:fuelred_mobile/Screens/facturas/info_factura_screen.dart';
import 'package:fuelred_mobile/Screens/login_screen.dart';
import 'package:fuelred_mobile/clases/show_alert_factura.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/graficas/my_line_chart.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/ad,min/dash.dart';
import 'package:fuelred_mobile/models/response.dart';

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
        backgroundColor: const Color.fromARGB(209, 245, 241, 241),
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
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                      ],
                     
                     
                        // Agrega más tarjetas de resumen aquí
                     
                    ),
                  ),
                ),
                 Expanded(
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
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
                              :  Container(), // Muestra un spinner mientras salesData es nulo
                          ),
                        ],
                       
                       
                        
                       
                      ),
                    ),
                  ),
                ),
              ],
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
              leading: const Icon(Icons.money , color: kColorMenu,),
              title: const Text('Depositos'),
              onTap: () => showDatePickerDialog(context, 'deposito'),
            ),

            ListTile(
              textColor: kColorMenu,
              leading: const Icon(Icons.reset_tv , color: kColorMenu,),
              title: const Text('Resumen del dia'),
              onTap: () => showDatePickerDialog(context, 'resumen'),
            ),


           

           ListTile(
                textColor: kColorMenu,
              leading: const Icon(Icons.double_arrow_outlined , color: kColorMenu,),
              title: const Text('Transferencias'),
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

             ListTile(
                textColor: kColorMenu,
              leading: const Icon(Icons.update_outlined , color: kColorMenu,),
              title: const Text('Actualizar Inventario'),
              onTap: () { 
                 Navigator.push(
                   context, 
                   MaterialPageRoute(
                     builder: (context) => const  InventFormScreen()
                   )
                 );
              },
            ),
              ListTile(
                textColor: kColorMenu,
                leading: const Icon(Icons.logout, color: kColorMenu,),
                title: const Text('Cerrar Sesión'),
                onTap: () => { 
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen()
                    )
                  ),
                },
            ),
           

          
          ],
        ),
      ),
    );
  }

  void navigateToNextPage(BuildContext context, DateTime selectedDate, String ruta) {
  if (ruta=='resumen'){
    Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ResumenDiaScreen(date: selectedDate.toString()),
    ),
  );
  }
  else{
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ConsolidadoDepositoScreen(dia: selectedDate.toString()),
        ),
      );
  }
  
  
}

   void showDatePickerDialog(BuildContext context, String ruta) {
  DateTime selectedDate = DateTime.now();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Seleccione una fecha'),
        content: SizedBox(
          height: 200,
          width: double.maxFinite,
          child: CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime(2017),
            lastDate: DateTime(2030),
            onDateChanged: (newDate) {
              selectedDate = newDate;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el AlertDialog
              navigateToNextPage(context, selectedDate, ruta); // Navegar a la nueva página
            },
          ),
        ],
      );
    },
  );

  
}

}



