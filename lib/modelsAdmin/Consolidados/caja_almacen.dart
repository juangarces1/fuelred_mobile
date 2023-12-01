class CajaAlmacen {
  double cierre;
  double colones;
  double dolares;
  double cheques;
  double datafonos;
  double cashbacks;
  double transferencias;
  double sinpes;
  double tarjetasCanje;
  double tarjetaEntrega;
  double total;

  CajaAlmacen({
    this.cierre = 0.0,
    this.colones = 0.0,
    this.dolares = 0.0,
    this.cheques = 0.0,
    this.datafonos = 0.0,
    this.cashbacks = 0.0,
    this.transferencias = 0.0,
    this.sinpes = 0.0,
    this.tarjetasCanje = 0.0,
    this.tarjetaEntrega = 0.0,
    this.total = 0.0,
  });

  // fromJson constructor
  CajaAlmacen.fromJson(Map<String, dynamic> json)
      : cierre = json['cierre'].toDouble(),
        colones = json['colones'].toDouble(),
        dolares = json['dolares'].toDouble(),
        cheques = json['cheques'].toDouble(),
        datafonos = json['datafonos'].toDouble(),
        cashbacks = json['cashbacks'].toDouble(),
        transferencias = json['transferencias'].toDouble(),
        sinpes = json['sinpes'].toDouble(),
        tarjetasCanje = json['tarjetasCanje'].toDouble(),
        tarjetaEntrega = json['tarjetaEntrega'].toDouble(),
        total = json['total'].toDouble();

  // toJson method
  Map<String, dynamic> toJson() => {
        'cierre': cierre,
        'colones': colones,
        'dolares': dolares,
        'cheques': cheques,
        'datafonos': datafonos,
        'cashbacks': cashbacks,
        'transferencias': transferencias,
        'sinpes': sinpes,
        'tarjetasCanje': tarjetasCanje,
        'tarjetaEntrega': tarjetaEntrega,
        'total': total,
      };

  void setTotal() {
    total = colones + dolares + cheques + cashbacks + datafonos + transferencias + sinpes + tarjetasCanje + tarjetaEntrega;
  }
}
