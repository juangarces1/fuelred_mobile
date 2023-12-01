class Consolidado {
  int idConsolidado;
  DateTime? fecha;
  String? calibraciones;
  int? cajaChica;
  String? notas;
  int? evaporacion;

  Consolidado({
    required this.idConsolidado,
    this.fecha,
    this.calibraciones,
    this.cajaChica,
    this.notas,
    this.evaporacion,
  });

  // Convertir un objeto Consolidado a un mapa JSON
  Map<String, dynamic> toJson() => {
        'idConsolidado': idConsolidado,
        'fecha': fecha?.toIso8601String(),
        'calibraciones': calibraciones,
        'cajaChica': cajaChica,
        'notas': notas,
        'evaporacion': evaporacion,
      };

  // Crear un objeto Consolidado desde un mapa JSON
  factory Consolidado.fromJson(Map<String, dynamic> json) => Consolidado(
        idConsolidado: json['idConsolidado'] as int,
        fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : null,
        calibraciones: json['calibraciones'] as String?,
        cajaChica: json['cajaChica'] as int?,
        notas: json['notas'] as String?,
        evaporacion: json['evaporacion'] as int?,
      );
}
