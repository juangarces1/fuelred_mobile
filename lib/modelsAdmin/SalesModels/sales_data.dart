import 'package:fuelred_mobile/modelsAdmin/SalesModels/product_sales.dart';

class SalesData {
  DateTime? date;
  List<ProductSale>? data;

  SalesData({required this.date, required this.data});

  Map<String, dynamic> toJson() => {
        'date': date!.toIso8601String(),
        'data': data!.map((x) => x.toJson()).toList(),
      };

  factory SalesData.fromJson(Map<String, dynamic> json) => SalesData(
        date: DateTime.parse(json['date']),
        data: List<ProductSale>.from(json['data'].map((x) => ProductSale.fromJson(x))),
      );
}