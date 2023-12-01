import 'package:fuelred_mobile/modelsAdmin/Consolidados/caja_almacen.dart';

class VentasAlmacen {
  List<CajaAlmacen> cierres;
  double depColones = 0.0;
  double depDolares = 0.0;
  double depCheques = 0.0;
  double tarjetasCanje = 0.0;
  double tarjetasEntrega = 0.0;
  double cashbacks = 0.0;
  double datafonos = 0.0;
  double transferencias = 0.0;
  double sinpes = 0.0;
  double total = 0.0;

  VentasAlmacen({required this.cierres});

  void totales() {
    for (var cierre in cierres) {
      depColones += cierre.colones;
      depDolares += cierre.dolares;
      depCheques += cierre.cheques;
      // ... Repetir para las demás propiedades
    }
  }

  void totalVentasDia() {
    total = depColones + depDolares +
            depCheques +
            tarjetasCanje +
            tarjetasEntrega +
            cashbacks +
            datafonos +
            transferencias +
            sinpes;
  }

  // Constructor de fábrica para crear una instancia desde un mapa
  factory VentasAlmacen.fromJson(Map<String, dynamic> json) {
    var cierresFromJson = json['cierres'] as List;
    List<CajaAlmacen> cierresList = cierresFromJson.map((i) => CajaAlmacen.fromJson(i)).toList();

    return VentasAlmacen(cierres: cierresList)
      ..depColones = json['depColones'].toDouble()
      ..depDolares = json['depDolares'].toDouble()
      ..depCheques = json['depCheques'].toDouble()
      ..tarjetasCanje = json['tarjetasCanje'].toDouble()
      ..tarjetasEntrega = json['tarjetasEntrega'].toDouble()
      ..cashbacks = json['cashbacks'].toDouble()
      ..datafonos = json['datafonos'].toDouble()
      ..transferencias = json['transferencias'].toDouble()
      ..sinpes = json['sinpes'].toDouble()
      ..total = json['total'].toDouble();
  }

  // Método para convertir la instancia en un mapa
  Map<String, dynamic> toJson() {
    List<Map> cierresToJson = cierres.map((i) => i.toJson()).toList();
    return {
      'cierres': cierresToJson,
      'depColones': depColones,
      'depDolares': depDolares,
      'depCheques': depCheques,
      'tarjetasCanje': tarjetasCanje,
      'tarjetasEntrega': tarjetasEntrega,
      'cashbacks': cashbacks,
      'datafonos': datafonos,
      'transferencias': transferencias,
      'sinpes': sinpes,
      'total': total,
    };
  }
}
