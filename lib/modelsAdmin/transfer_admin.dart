class TransferenciaAdmin {
  String cuenta;
  int idTransferencia;
  int? idCliente;
  DateTime? fechaTransferencia;
  int? idBanco;
  int? monto;
  String? notas;
  String? numeroDeposito;
  String? estado;

  TransferenciaAdmin({
    required this.cuenta,
    required this.idTransferencia,
    this.idCliente,
    this.fechaTransferencia,
    this.idBanco,
    this.monto,
    this.notas,
    this.numeroDeposito,
    this.estado,
  });

  factory TransferenciaAdmin.fromJson(Map<String, dynamic> json) => TransferenciaAdmin(
        cuenta: json['Cuenta'],
        idTransferencia: json['Idtransferencia'],
        idCliente: json['Idcliente'],
        fechaTransferencia: json['Fechatransferencia'] != null
            ? DateTime.parse(json['Fechatransferencia'])
            : null,
        idBanco: json['Idbanco'],
        monto: json['Monto'],
        notas: json['Notas'],
        numeroDeposito: json['Numerodeposito'],
        estado: json['Estado'],
      );

  Map<String, dynamic> toJson() => {
        'Cuenta': cuenta,
        'Idtransferencia': idTransferencia,
        'Idcliente': idCliente,
        'Fechatransferencia': fechaTransferencia?.toIso8601String(),
        'Idbanco': idBanco,
        'Monto': monto,
        'Notas': notas,
        'Numerodeposito': numeroDeposito,
        'Estado': estado,
      };
}
