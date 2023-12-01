class CierreCaja {
  double cierre;
  double colones;
  double dolares;
  double cheques;
  double cupones;
  double creditos;
  double calibraciones;
  double cashbacks;
  double tarjetasCanje;
  double tarjetaEntrega;
  double datafonos;
  double transferencias;
  double viaticos;
  double sinpes;
  double totalCierre;

  CierreCaja({
    this.cierre = 0.0,
    this.colones = 0.0,
    this.dolares = 0.0,
    this.cheques = 0.0,
    this.cupones = 0.0,
    this.creditos = 0.0,
    this.calibraciones = 0.0,
    this.cashbacks = 0.0,
    this.tarjetasCanje = 0.0,
    this.tarjetaEntrega = 0.0,
    this.datafonos = 0.0,
    this.transferencias = 0.0,
    this.viaticos = 0.0,
    this.sinpes = 0.0,
    this.totalCierre = 0.0,
  });

  // Constructor de fábrica para crear una instancia desde un mapa
  factory CierreCaja.fromJson(Map<String, dynamic> json) {
    return CierreCaja(
      cierre: json['cierre'].toDouble(),
      colones: json['colones'].toDouble(),
      dolares: json['dolares'].toDouble(),
      cheques: json['cheques'].toDouble(),
      cupones: json['cupones'].toDouble(),
      creditos: json['creditos'].toDouble(),
      calibraciones: json['calibraciones'].toDouble(),
      cashbacks: json['cashbacks'].toDouble(),
      tarjetasCanje: json['tarjetasCanje'].toDouble(),
      tarjetaEntrega: json['tarjetaEntrega'].toDouble(),
      datafonos: json['datafonos'].toDouble(),
      transferencias: json['transferencias'].toDouble(),
      viaticos: json['viaticos'].toDouble(),
      sinpes: json['sinpes'].toDouble(),
      totalCierre: json['totalCierre'].toDouble(),
    );
  }

  // Método para convertir la instancia en un mapa
  Map<String, dynamic> toJson() {
    return {
      'cierre': cierre,
      'colones': colones,
      'dolares': dolares,
      'cheques': cheques,
      'cupones': cupones,
      'creditos': creditos,
      'calibraciones': calibraciones,
      'cashbacks': cashbacks,
      'tarjetasCanje': tarjetasCanje,
      'tarjetaEntrega': tarjetaEntrega,
      'datafonos': datafonos,
      'transferencias': transferencias,
      'viaticos': viaticos,
      'sinpes': sinpes,
      'totalCierre': totalCierre,
    };
  }
}
