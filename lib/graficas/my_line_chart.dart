import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyLineChart extends StatelessWidget {
  const MyLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData:  FlTitlesData(
          // Configuración de títulos para los ejes
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // switch (value.toInt()) {
                //   case 1: return const Text('Dia 1');
                //   case 2: return const Text('Dia 2');
                //   case 3: return const Text('Dia 3');
                //   case 4: return const Text('Dia 4');
                //   default: return const Text('');
                // }
                return Text(' ${value.toInt()}');
              },
              reservedSize: 30,
            ),
            ),
          ),
          lineTouchData: LineTouchData(
              touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                // Aquí puedes manejar eventos de toque si es necesario
                // Por ejemplo, puedes comprobar si es un evento de toque y actuar en consecuencia
                if (event is FlTapUpEvent && touchResponse != null) {
                  // Manejo de un evento de toque
                  // Puedes usar touchResponse para obtener detalles sobre el punto tocado
                }
              },
              handleBuiltInTouches: true,
            ),
        borderData: FlBorderData(show: true, border:  Border.all(color: Colors.blueAccent, width: 2)),
        lineBarsData: [
          // Datos para el Producto 1
          LineChartBarData(
            spots: getSpotsForProduct1(), // Reemplaza con tus datos
            isCurved: true,
            barWidth: 3,
            color: Colors.blue,
          ),
          // Datos para el Producto 2
          LineChartBarData(
            spots: getSpotsForProduct2(), // Reemplaza con tus datos
            isCurved: true,
            barWidth: 3,
            color: Colors.green,
          ),
          // Datos para el Producto 3
          LineChartBarData(
            spots: getSpotsForProduct3(), // Reemplaza con tus datos
            isCurved: true,
            barWidth: 3,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  // Genera FlSpot para cada producto
  List<FlSpot> getSpotsForProduct1() {
    return [
      // Aquí debes reemplazar con tus datos (x, y)
      const FlSpot(1, 2),
      const FlSpot(2, 3.5),
       const FlSpot(3, 2),
      const FlSpot(4, 3.5),
       const FlSpot(5, 4.5),
      // ... más datos
    ];
  }

  List<FlSpot> getSpotsForProduct2() {
    return [
      // Aquí debes reemplazar con tus datos (x, y)
      const FlSpot(1, 3),
      const FlSpot(2, 2.5),
       const FlSpot(3, 4.3),
      const FlSpot(4, 5.5),
       const FlSpot(5, 4.5),
      // ... más datos
    ];
  }

  List<FlSpot> getSpotsForProduct3() {
    return [
      // Aquí debes reemplazar con tus datos (x, y)
      const FlSpot(1, 1),
      const FlSpot(2, 4.5),
       const FlSpot(3, 6),
      const FlSpot(4, 1.5),
       const FlSpot(5, 2.5),
      // ... más datos
    ];
  }
}
