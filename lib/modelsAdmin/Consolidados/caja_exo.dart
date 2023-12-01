class CajaExo {
  int cierre;
  double colones;
  double dolares;
  double cheques;
  double cashbacks;
  double datafonos;
  double transferencias;
  double compraBoleta;
  double compraCupon;
  double total;
  double totalVenta;
  double diferenciaEfectivo;
  double ltsMaquinas;
  double ltsVentas;
  double diferenciaLitros;

  CajaExo({
    this.cierre = 0,
    this.colones = 0.0,
    this.dolares = 0.0,
    this.cheques = 0.0,
    this.cashbacks = 0.0,
    this.datafonos = 0.0,
    this.transferencias = 0.0,
    this.compraBoleta = 0.0,
    this.compraCupon = 0.0,
    this.total = 0.0,
    this.totalVenta = 0.0,
    this.diferenciaEfectivo = 0.0,
    this.ltsMaquinas = 0.0,
    this.ltsVentas = 0.0,
    this.diferenciaLitros = 0.0,
  });

  // Constructor de fábrica para crear una instancia desde un mapa
  factory CajaExo.fromJson(Map<String, dynamic> json) {
    return CajaExo(
      cierre: json['cierre'],
      colones: json['colones'].toDouble(),
      dolares: json['dolares'].toDouble(),
      cheques: json['cheques'].toDouble(),
      cashbacks: json['cashbacks'].toDouble(),
      datafonos: json['datafonos'].toDouble(),
      transferencias: json['transferencias'].toDouble(),
      compraBoleta: json['compraBoleta'].toDouble(),
      compraCupon: json['compraCupon'].toDouble(),
      total: json['total'].toDouble(),
      totalVenta: json['totalVenta'].toDouble(),
      diferenciaEfectivo: json['diferenciaEfectivo'].toDouble(),
      ltsMaquinas: json['ltsMaquinas'].toDouble(),
      ltsVentas: json['ltsVentas'].toDouble(),
      diferenciaLitros: json['diferenciaLitros'].toDouble(),
    );
  }

  // Método para convertir la instancia en un mapa
  Map<String, dynamic> toJson() {
    return {
      'cierre': cierre,
      'colones': colones,
      'dolares': dolares,
      'cheques': cheques,
      'cashbacks': cashbacks,
      'datafonos': datafonos,
      'transferencias': transferencias,
      'compraBoleta': compraBoleta,
      'compraCupon': compraCupon,
      'total': total,
      'totalVenta': totalVenta,
      'diferenciaEfectivo': diferenciaEfectivo,
      'ltsMaquinas': ltsMaquinas,
      'ltsVentas': ltsVentas,
      'diferenciaLitros': diferenciaLitros,
    };
  }

  void setTotal() {
    total = colones + cheques + dolares + cashbacks + datafonos + transferencias + compraBoleta + compraCupon;
    diferenciaEfectivo = total - totalVenta;
    diferenciaLitros = ltsMaquinas - ltsVentas;
  }
}
