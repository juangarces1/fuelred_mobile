import 'package:fuelred_mobile/models/cart.dart';
import 'package:fuelred_mobile/models/cierreactivo.dart';
import 'package:fuelred_mobile/models/cliente.dart';
import 'package:fuelred_mobile/models/paid.dart';
import 'package:fuelred_mobile/models/product.dart';


class AllFact {
  Cart? cart;
  List<Product> transacciones = [];
  List<Product> productos = [];
  String? placa;
  int? kms;  
  int lasTr=0;
  String? observaciones;
  List<String> placas = [];
  CierreActivo? cierreActivo;
  Cliente? clienteFactura;
  Cliente? clientePuntos;
  Paid? formPago;
  List<Cliente> clientesFacturacion = [];

  AllFact({
    this.cart,
    this.transacciones = const [],
    this.productos = const [],
    this.placa,
    this.kms,
    required this.lasTr,
    this.observaciones,
    this.placas = const [],
    this.cierreActivo,
    this.clienteFactura,
    this.clientePuntos,
    this.formPago,
    this.clientesFacturacion = const [],
  });

  factory AllFact.fromJson(Map<String, dynamic> json) {
    return AllFact(
      cart: null,
      transacciones: json['transacciones'] != null ? (json['transacciones'] as List).map((i) => Product.fromJson(i)).toList() : [],
      productos: json['productos'] != null ? (json['productos'] as List).map((i) => Product.fromJson(i)).toList() : [],
      placa: '',
      kms: 0,
      lasTr: 0,
      observaciones: '',
      placas: [],
      cierreActivo: json['cierreActivo'] != null ? CierreActivo.fromJson(json['cierreActivo']) : null,
      clienteFactura:  null,
      clientePuntos:  null,
      formPago:  null,
      clientesFacturacion: json['clientesFacturacion'] != null ? (json['clientesFacturacion'] as List).map((i) => Cliente.fromJson(i)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart': cart,
      'transacciones': transacciones.map((i) => i.toJson()).toList(),
      'productos': productos.map((i) => i.toJson()).toList(),
      'placa': placa,
      'kms': kms,
      'lasTr': lasTr,
      'observaciones': observaciones,
      'placas': placas,
      'cierreActivo': cierreActivo?.toJson(),
      'clienteFactura': clienteFactura,
      'clientePuntos': clientePuntos,
      'formPago': formPago,
      'clientesFacturacion': clientesFacturacion.map((i) => i.toJson()).toList(),
    };
  }

  // You might also want to add a toJson method, just in case!
   void setSaldo(){    
     formPago!.saldo =
         cart!.total
         -formPago!.totalEfectivo
         -formPago!.totalBac
         -formPago!.totalDav
         -formPago!.totalBn
         -formPago!.totalSctia
         -formPago!.totalDollars
         -formPago!.totalCheques
         -formPago!.totalCupones
         -formPago!.totalPuntos
         -formPago!.totalTransfer
         -formPago!.totalSinpe;
   } 
}
