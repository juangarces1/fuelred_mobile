import 'package:fuelred_mobile/modelsAdmin/SalesModels/my_flspot.dart';

class ProductSale {
  String product;
  List<MyFlSpot> sales;

  ProductSale({required this.product, required this.sales});

  Map<String, dynamic> toJson() => {
        'producto': product,
        'ventas': sales.map((x) => x.toJson()).toList(),
      };

  factory ProductSale.fromJson(Map<String, dynamic> json) => ProductSale(
        product: json['producto'],
        sales: List<MyFlSpot>.from(json['ventas'].map((x) => MyFlSpot.fromJson(x))),
      );
}