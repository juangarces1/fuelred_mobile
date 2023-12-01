class TotalGeneral {
  double colones;
  double dolares;
  double cheques;
  double cupones;
  double factCreditos;
  double calibraciones;
  double cashbacks;
  double tarjetasCanje;
  double tarjetaEntrega;
  double datafonos;
  double transferencias;
  double viaticos;
  double sinpes;
  double evaporacion;
  double bnMovimientos;
  double total;

  TotalGeneral({
    this.colones = 0.0,
    this.dolares = 0.0,
    this.cheques = 0.0,
    this.cupones = 0.0,
    this.factCreditos = 0.0,
    this.calibraciones = 0.0,
    this.cashbacks = 0.0,
    this.tarjetasCanje = 0.0,
    this.tarjetaEntrega = 0.0,
    this.datafonos = 0.0,
    this.transferencias = 0.0,
    this.viaticos = 0.0,
    this.sinpes = 0.0,
    this.evaporacion = 0.0,
    this.bnMovimientos = 0.0,
    this.total = 0.0,
  });

  void setTotal() {
    total = colones + dolares + cheques + factCreditos - evaporacion + calibraciones + cashbacks + tarjetasCanje + tarjetaEntrega + datafonos + transferencias + viaticos + sinpes + bnMovimientos;
  }

  // Constructor de fábrica para crear una instancia desde un mapa
  factory TotalGeneral.fromJson(Map<String, dynamic> json) {
    return TotalGeneral(
      colones: json['colones'].toDouble(),
      dolares: json['dolares'].toDouble(),
      cheques: json['cheques'].toDouble(),
      cupones: json['cupones'].toDouble(),
      factCreditos: json['factCreditos'].toDouble(),
      calibraciones: json['calibraciones'].toDouble(),
      cashbacks: json['cashbacks'].toDouble(),
      tarjetasCanje: json['tarjetasCanje'].toDouble(),
      tarjetaEntrega: json['tarjetaEntrega'].toDouble(),
      datafonos: json['datafonos'].toDouble(),
      transferencias: json['transferencias'].toDouble(),
      viaticos: json['viaticos'].toDouble(),
      sinpes: json['sinpes'].toDouble(),
      evaporacion: json['evaporacion'].toDouble(),
      bnMovimientos: json['bnMovimientos'].toDouble(),
      // El total se recalcula usando setTotal después de la deserialización
    )..setTotal();
  }

  // Método para convertir la instancia en un mapa
  Map<String, dynamic> toJson() {
    return {
      'colones': colones,
      'dolares': dolares,
      'cheques': cheques,
      'cupones': cupones,
      'factCreditos': factCreditos,
      'calibraciones': calibraciones,
      'cashbacks': cashbacks,
      'tarjetasCanje': tarjetasCanje,
      'tarjetaEntrega': tarjetaEntrega,
      'datafonos': datafonos,
      'transferencias': transferencias,
      'viaticos': viaticos,
      'sinpes': sinpes,
      'evaporacion': evaporacion,
      'bnMovimientos': bnMovimientos,
      'total': total,
    };
  }
}
