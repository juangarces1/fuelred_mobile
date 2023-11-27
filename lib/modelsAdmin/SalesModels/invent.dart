class Invent {
  double invDiesel;
  double invExonerado;
  double invRegular;
  double invSuper;
  DateTime fecha;
  int id;

  Invent({
    required this.invDiesel,
    required this.invExonerado,
    required this.invRegular,
    required this.invSuper,
    required this.fecha,
    required this.id,
  });

  // Convertir un objeto Invent a un Map para JSON
  Map<String, dynamic> toJson() {
    return {
      'invDiesel': invDiesel,
      'invExonerado': invExonerado,
      'invRegular': invRegular,
      'invSuper': invSuper,
      'fecha': fecha.toIso8601String(), // Convertir DateTime a String
      'id': id,
    };
  }

  // Crear un objeto Invent a partir de un Map de JSON
  factory Invent.fromJson(Map<String, dynamic> json) {
    return Invent(
      invDiesel: json['invDiesel']?.toDouble() ?? 0.0,
      invExonerado: json['invExonerado']?.toDouble() ?? 0.0,
      invRegular: json['invRegular']?.toDouble() ?? 0.0,
      invSuper: json['invSuper']?.toDouble() ?? 0.0,
      fecha: DateTime.parse(json['fecha']),
      id: json['id'],
    );
  }
}
