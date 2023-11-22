import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:fuelred_mobile/Screens/Transfers/add_transfer_screen.dart';
import 'package:fuelred_mobile/Screens/Transfers/list_transfers_screen.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/graficas/my_line_chart.dart';



class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [  
              Text('FuelRed App'),
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
        body:    SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10,),
              const SummaryCard(
                title: 'Ventas Diesel', 
                value: '1200',
                iconData: FlutterIcons.sale_mco,
                color: Colors.green,
              ),
                const SummaryCard(
                title: 'Ventas Regular', 
                value: '1500',
                iconData: FlutterIcons.sale_mco,
                color: Colors.red,
              ),
                const SummaryCard(
                title: 'Ventas Super', 
                value: '1200',
                iconData: FlutterIcons.sale_mco,
                color: Colors.indigo,
              ),
                const SummaryCard(
                title: 'Ventas Exonerado', 
                value: '1200',
                iconData: FlutterIcons.sale_mco,
                color: Colors.blue,
              ),
    
           //  SalesBarChart(salesData: salesData),
             Container(
                height: 250,
                 padding: const EdgeInsets.all(16),
              child: const MyLineChart()),
              // Agrega más tarjetas de resumen aquí
            ],
          ),
        ),
      ),
    );
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
        leading: Icon(iconData, color: color),
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

// No olvides reemplazar los íconos y colores según tu necesidad.
