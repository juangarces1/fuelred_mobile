import 'package:fuelred_mobile/modelsAdmin/SalesModels/sales_data.dart';

class Dash {
  SalesData? salesData;
  double? invDiesel;
  double? invRegular;
  double? invSuper;
  double? invExo;
  List<String>? dates;

  Dash({
    this.salesData,
    this.invDiesel,
    this.invRegular,
    this.invSuper,
    this.invExo,
    this.dates,
  });

  factory Dash.fromJson(Map<String, dynamic> json) => Dash(
      salesData: json['salesData'] != null ? SalesData.fromJson(json['salesData']) : null,
        invDiesel: (json['invDiesel'] as num?)?.toDouble(),
        invRegular: (json['invRegular'] as num?)?.toDouble(),
        invSuper: (json['invSuper'] as num?)?.toDouble(),
        invExo: (json['invExo'] as num?)?.toDouble(),
        dates: List<String>.from(json['dates'].map((x) => x)), 
      );
  
}
