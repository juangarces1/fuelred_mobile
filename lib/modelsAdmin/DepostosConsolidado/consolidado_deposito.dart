import 'package:fuelred_mobile/modelsAdmin/DepostosConsolidado/deposito_cierre.dart';

class ConsolidadoDeposito {
  String date;
  int idConsolidado;
  List<DepositoCierre> cierres;

  ConsolidadoDeposito({
    required this.date,
    required this.idConsolidado,
    required this.cierres,
  });

  factory ConsolidadoDeposito.fromJson(Map<String, dynamic> json) {
     var listaCierresRaw = json['cierres'];
    List<DepositoCierre> cierreLista = [];

    if (listaCierresRaw != null && listaCierresRaw.isNotEmpty) {
      cierreLista = List.from(listaCierresRaw).map((i) => DepositoCierre.fromJson(i)).toList();
    }

    return ConsolidadoDeposito(
      date: json['date'],
      idConsolidado: json['idConsolidado'],
      cierres: cierreLista,
    );
  }
}
