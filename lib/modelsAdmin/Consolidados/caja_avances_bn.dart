class CajaAvancesBN {
  int cierre;
  double colones;
  double dolares;
  double cheques;
  double cashbacks;
  double datafonos;
  double devCashBacks;
  double totalAvances;
  double bnMovimientos;
  double diferencia;

  CajaAvancesBN({
    this.cierre = 0,
    this.colones = 0.0,
    this.dolares = 0.0,
    this.cheques = 0.0,
    this.cashbacks = 0.0,
    this.datafonos = 0.0,
    this.devCashBacks = 0.0,
    this.totalAvances = 0.0,
    this.bnMovimientos = 0.0,
    this.diferencia = 0.0,
  });

  // fromJson constructor
  CajaAvancesBN.fromJson(Map<String, dynamic> json)
      : cierre = json['cierre'],
        colones = json['colones'].toDouble(),
        dolares = json['dolares'].toDouble(),
        cheques = json['cheques'].toDouble(),
        cashbacks = json['cashbacks'].toDouble(),
        datafonos = json['datafonos'].toDouble(),
        devCashBacks = json['devCashBacks'].toDouble(),
        totalAvances = json['totalAvances'].toDouble(),
        bnMovimientos = json['bnMovimientos'].toDouble(),
        diferencia = json['diferencia'].toDouble();

  // toJson method
  Map<String, dynamic> toJson() => {
        'cierre': cierre,
        'colones': colones,
        'dolares': dolares,
        'cheques': cheques,
        'cashbacks': cashbacks,
        'datafonos': datafonos,
        'devCashBacks': devCashBacks,
        'totalAvances': totalAvances,
        'bnMovimientos': bnMovimientos,
        'diferencia': diferencia,
      };

  void total() {
    totalAvances = colones + dolares + cheques + datafonos;
    diferencia = colones + cheques + dolares - bnMovimientos;
  }
}
