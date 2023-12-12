 import 'package:fl_chart/fl_chart.dart';
 import 'package:flutter/material.dart';
 import 'package:fuelred_mobile/modelsAdmin/SalesModels/product_sales.dart';
 import 'package:fuelred_mobile/modelsAdmin/SalesModels/sales_data.dart';
 class MyLineChart extends StatefulWidget {
   final SalesData salesData;
   final List<String> lista;
   const MyLineChart({super.key, required this.salesData, required this.lista});
   @override
   State<MyLineChart> createState() => _MyLineChartState();
 }
 class _MyLineChartState extends State<MyLineChart> {
   

   @override
   Widget build(BuildContext context) {
     return LineChart(
       LineChartData(
         gridData: const FlGridData(show: true,),
         titlesData:  FlTitlesData(
           // Configuración de títulos para los ejes
           leftTitles:  AxisTitles(
             sideTitles: SideTitles(
              showTitles: true,
                getTitlesWidget: (value, meta) {
                  int rounded = (value / 1000).ceil(); 
                  return Text('${rounded}k',  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold));                },
                reservedSize: 30,
                
              ),
           ),
           bottomTitles: AxisTitles(
             sideTitles: SideTitles(
               showTitles: true,
               getTitlesWidget: (value, meta) {            
              //   return const Text('28/12');
                   return Text(widget.lista[value.toInt()-1], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold));                 
               },
               reservedSize: 20,
               interval:1,
             ),
             ),
           ),
           lineTouchData: LineTouchData(
               touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                if (event is FlTapUpEvent && touchResponse != null) {
     
                 }
               },
               handleBuiltInTouches: true,
             ),
         borderData: FlBorderData(show: true, border:  Border.all(color:Colors.black, width: 1)),
         lineBarsData: [
           // Datos para el Producto 1
           LineChartBarData(
             spots: getSpotsForExo(), // Reemplaza con tus datos
             isCurved: true,
             barWidth: 3,
             color: Colors.blue,
           ),
           // Datos para el Producto 2
           LineChartBarData(
             spots: getSpotsForDiesel(), // Reemplaza con tus datos
             isCurved: true,
             barWidth: 3,
             color: Colors.green,
           ),
           // Datos para el Producto 3
           LineChartBarData(
             spots: getSpotsForRegular(), // Reemplaza con tus datos
             isCurved: true,
             barWidth: 3,
             color: Colors.red,
           ),
             LineChartBarData(
             spots: getSpotsForSuper(), // Reemplaza con tus datos
             isCurved: true,
             barWidth: 3,
             color: const Color.fromARGB(255, 244, 54, 187),
           ),
         ],
       ),
     );
   }
   // Genera FlSpot para cada producto
   List<FlSpot> getSpotsForDiesel() {
     List<FlSpot> spots = [];
     List<ProductSale> filtrarProductosDiesel = widget.salesData.data!.where((producto) => producto.product == 'Diesel').toList();
  
  
     for (var producto in filtrarProductosDiesel) {
       for (var venta in producto.sales) {
         spots.add(FlSpot(venta.number, venta.volumen));
       }
     }
     return spots;
   }
   List<FlSpot> getSpotsForSuper() {
     List<FlSpot> spots = [];
     List<ProductSale> filtrarProductosDiesel = widget.salesData.data!.where((producto) => producto.product == 'Super').toList();
  
  
     for (var producto in filtrarProductosDiesel) {
       for (var venta in producto.sales) {
         spots.add(FlSpot(venta.number, venta.volumen));
       }
     }
     return spots;
   }
   List<FlSpot> getSpotsForRegular() {
      List<FlSpot> spots = [];
     List<ProductSale> filtrarProductosDiesel = widget.salesData.data!.where((producto) => producto.product == 'Regular').toList();
  
  
     for (var producto in filtrarProductosDiesel) {
       for (var venta in producto.sales) {
         spots.add(FlSpot(venta.number, venta.volumen));
       }
     }
     return spots;
   }
   List<FlSpot> getSpotsForExo() {
      List<FlSpot> spots = [];
     List<ProductSale> filtrarProductosDiesel = widget.salesData.data!.where((producto) => producto.product == 'Exo').toList();
  
  
     for (var producto in filtrarProductosDiesel) {
       for (var venta in producto.sales) {
         spots.add(FlSpot(venta.number, venta.volumen));
       }
     }
     return spots;
   }

 }
