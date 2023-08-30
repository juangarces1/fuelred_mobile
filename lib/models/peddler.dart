class Peddler {
  int? id;
  int? transaccion;
  int? idcliente;
  String? fecha;
  bool? estado;
  int? idcierre;
  int? cedulaPistero;
  bool? subir;
  String? placa;
  String? km;
  String? observaciones;
  String? chofer;
  String? numFact;
  

  Peddler(
      {this.id,
      this.transaccion,
      this.idcliente,
      this.fecha,
      this.estado,
      this.idcierre,
      this.cedulaPistero,
      this.subir,
      this.placa,
      this.km,
      this.observaciones,
      this.chofer,
      this.numFact});

  Peddler.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transaccion = json['transaccion'];
    idcliente = json['idcliente'];
    fecha = json['fecha'];
    estado = json['estado'];
    idcierre = json['idcierre'];
    cedulaPistero = json['cedulaPistero'];
    subir = json['subir'];
    placa = json['placa'];
    km = json['km'];
    observaciones = json['observaciones'];
    chofer = json['chofer'];
    numFact = json['numFact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaccion'] = transaccion;
    data['idcliente'] = idcliente;
    data['fecha'] = fecha;
    data['estado'] = estado;
    data['idcierre'] = idcierre;
    data['cedulaPistero'] = cedulaPistero;
    data['subir'] = subir;
    data['placa'] = placa;
    data['km'] = km;
    data['observaciones'] = observaciones;
    data['chofer'] = chofer;
    data['numFact'] = numFact;
    return data;
  }
}