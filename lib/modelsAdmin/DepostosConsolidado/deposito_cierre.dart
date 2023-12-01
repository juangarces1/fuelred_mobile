import 'package:fuelred_mobile/models/deposito.dart';

class DepositoCierre {
  int idCierre;
  String lugar;
  String empleado;
  List<Deposito> depositos;

  DepositoCierre({
    required this.idCierre,
    required this.lugar,
    required this.empleado,
    required this.depositos,
  });

  factory DepositoCierre.fromJson(Map<String, dynamic> json) {
     var listaDepositosJson = json['depositos'] as List<dynamic>?;
    List<Deposito> depositosLista = [];

    if (listaDepositosJson != null && listaDepositosJson.isNotEmpty) {
      depositosLista = listaDepositosJson.map((depositoJson) => Deposito.fromJson(depositoJson)).toList();
    }

    return DepositoCierre(
       idCierre: json['idCierre'] ?? 0, // Proporciona un valor predeterminado en caso de nulo
       lugar: json['lugar'] ?? '', // Proporciona un valor predeterminado en caso de nulo
        empleado: json['empleado'] ?? '', // Proporciona
      depositos: depositosLista,
    );
  }
}
