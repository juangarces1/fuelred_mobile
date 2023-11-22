class CuentaBanco {
  int idCuenta;
  String numeroCuenta;
  int? idBanco;
  int? idMoneda;
  String titular;

  CuentaBanco({
    required this.idCuenta,
    required this.numeroCuenta,
    this.idBanco,
    this.idMoneda,
    required this.titular,
  });

  // Método para convertir un mapa a una instancia de CuentasBanco
  factory CuentaBanco.fromJson(Map<String, dynamic> json) => CuentaBanco(
        idCuenta: json['idcuenta'],
        numeroCuenta: json['numerocuenta'],
        idBanco: json['idbanco'],
        idMoneda: json['idmoneda'],
        titular: json['titular'],
      );

  // Método para convertir una instancia de CuentasBanco a un mapa
  Map<String, dynamic> toJson() => {
        'Idcuenta': idCuenta,
        'Numerocuenta': numeroCuenta,
        'Idbanco': idBanco,
        'Idmoneda': idMoneda,
        'Titular': titular,
      };
}
