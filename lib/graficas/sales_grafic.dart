import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesBarChart extends StatelessWidget {
  final List<List<double>> salesData; // Datos de ventas por artículo y día

  const SalesBarChart({Key? key, required this.salesData}) : super(key: key);
   


  @override
  Widget build(BuildContext context) {
      
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                  if (value.isNaN) {
                    return const Text('');
                  }
                  if (value.isInfinite) {
                    // Manejar valores infinitos si es necesario
                    return const Text('Inf');
                  }
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(color: Colors.black, fontSize: 10),
                  );
                },
              // Otras configuraciones para títulos del eje X...
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                // Personaliza aquí el widget del título para el eje Y
                return Text(
                  value.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                );
              },
              interval: 1,  // Ajusta este valor según sea necesario
              // Otras configuraciones para títulos del eje Y...
            ),
          ),
        ),

        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        minY: 1, // Ajusta según tus datos
        barTouchData: BarTouchData(enabled: true),
      
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(salesData.length, (dayIndex) {
          return BarChartGroupData(
            x: dayIndex,
            barRods: List.generate(salesData[dayIndex].length, (itemIndex) {
              return BarChartRodData(
                toY: salesData[dayIndex][itemIndex],
                
              );
            }),
          );
        }),
      ),
    );
  }
}
