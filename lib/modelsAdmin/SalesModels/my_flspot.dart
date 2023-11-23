class MyFlSpot {
  double number=0;
  double volumen =0;

  MyFlSpot({required this.number, required this.volumen});

  Map<String, dynamic> toJson() => {
        'number': number.toDouble(),
        'volume': volumen.toDouble(),
      };

  MyFlSpot.fromJson(Map<String, dynamic> json) {
    number = (json['number'] as num?)?.toDouble() ?? 0;
    volumen = (json['volumen'] as num?)?.toDouble() ?? 0; 
}
}