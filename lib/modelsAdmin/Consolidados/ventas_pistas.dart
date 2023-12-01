import 'package:fuelred_mobile/modelsAdmin/Consolidados/cierre_caja.dart';

class VentasPistas {
  List<CierreCaja> cierres;
  double depColones = 0.0;
  double depDolares = 0.0;
  double depCheques = 0.0;
  double depCupones = 0.0;
  double factCreditos = 0.0;
  double calibraciones = 0.0;
  double cashbacks = 0.0;
  double tarjetasCanje = 0.0;
  double tarjetasEntrega = 0.0;
  double datafonos = 0.0;
  double transferencias = 0.0;
  double viaticos = 0.0;
  double sinpes = 0.0;
  double total = 0.0;

  VentasPistas({required this.cierres});

  void totales() {
    for (var cierre in cierres) {
      depColones += cierre.colones;
      depDolares += cierre.dolares;
      // ... Repetir para las demás propiedades
    }
  }

  void totalVentasDia() {
    total = depColones + depDolares +
            depCheques + depCupones + factCreditos +
            calibraciones + cashbacks +
            tarjetasCanje + tarjetasEntrega +
            datafonos + transferencias +
            viaticos + sinpes;
  }

  // Constructor de fábrica para crear una instancia desde un mapa
  factory VentasPistas.fromJson(Map<String, dynamic> json) {
    var cierresFromJson = json['cierres'] as List;
    List<CierreCaja> cierresList = cierresFromJson.map((i) => CierreCaja.fromJson(i)).toList();

    return VentasPistas(cierres: cierresList)
      ..depColones = json['depColones'].toDouble()
      ..depDolares = json['depDolares'].toDouble()
      ..depCheques = json['depCheques'].toDouble()
      ..depCupones = json['depCupones'].toDouble()
      ..factCreditos = json['factCreditos'].toDouble()
      ..calibraciones = json['calibraciones'].toDouble()
      ..cashbacks = json['cashbacks'].toDouble()
      ..tarjetasCanje = json['tarjetasCanje'].toDouble()
      ..tarjetasEntrega = json['tarjetasEntrega'].toDouble()
      ..datafonos = json['datafonos'].toDouble()
      ..transferencias = json['transferencias'].toDouble()
      ..viaticos = json['viaticos'].toDouble()
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
      'depCupones': depCupones,
      'factCreditos': factCreditos,
      'calibraciones': calibraciones,
      'cashbacks': cashbacks,
      'tarjetasCanje': tarjetasCanje,
      'tarjetasEntrega': tarjetasEntrega,
      'datafonos': datafonos,
      'transferencias': transferencias,
      'viaticos': viaticos,
      'sinpes': sinpes,
      'total': total,
    };
  }
}
