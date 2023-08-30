// ignore: camel_case_types
import 'package:fuelred_mobile/models/product.dart';

// ignore: camel_case_types
class resdoc_facturas {
   String cliente='';
  String nFactura='';
  String? codigoCliente;
  String? descripCliente;
  DateTime? fechaFactura;
  DateTime fechaHoraTrans = DateTime.now();
  String? tipoDocumento;
  String? email;
  String? nPlaca;
  String? observaciones;
  String? clave;
  double? totalGravado;
  double totalFactura = 0;
  double? totalImpuesto;
  double? totalDescuento;
  double? totalExento;
  double? kilometraje;  
  int? plazo;
  String? employeeID;
  List<Product> detalles = [];

  resdoc_facturas(
  {    
    required this.cliente,
    required this.nFactura,
    this.codigoCliente,
    this.descripCliente,
    this.fechaFactura,
    required this.fechaHoraTrans,
    this.tipoDocumento,
    this.email,
    this.nPlaca,
    this.observaciones,
    this.clave,
    this.totalGravado,
    required this.totalFactura,
    this.totalImpuesto,
    this.totalDescuento,
    this.totalExento,
    this.kilometraje,        
    this.plazo,
    this.employeeID,
    required this.detalles
  });

  resdoc_facturas.fromJson(Map<String, dynamic> json) {
    cliente = json['descripCliente'];
    nFactura = json['nFactura'];
    codigoCliente = json['codigoCliente'];
    descripCliente = json['descripCliente'];
    fechaFactura =  DateTime.parse(json['fechaFactura']);
    fechaHoraTrans =  DateTime.parse(json['fechaHoraTrans']); 
    tipoDocumento = json['tipoDocumento'];
    email = json['email'];
    nPlaca = json['nPlaca'];
    observaciones = json['observaciones'];
    clave = json['clave'];
    totalGravado = json['totalGravado'];
    totalFactura = json['totalFactura'];
    totalImpuesto = json['totalImpuesto'];
    totalDescuento = json['totalDescuento'];
    totalExento = json['totalExento'];
    kilometraje = json['kilometraje'];   
    plazo = json['plazo'];
    employeeID = json['msgDetalle1'];
     if (json['detalles'] != null) {
      detalles = [];
      json['detalles'].forEach((d) {
        detalles.add(Product.fromJson(d));
      });
    }
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nFactura'] = nFactura;
    data['codigoCliente'] = codigoCliente;
    data['descripCliente'] = descripCliente;
    data['fechaFactura'] = fechaFactura;
    data['fechaHoraTrans'] = fechaHoraTrans;
    data['tipoDocumento'] = tipoDocumento;
    data['email'] = email;
    data['nPlaca'] = nPlaca;
    data['observaciones'] = observaciones;
    data['clave'] = clave;
    data['totalGravado'] = totalGravado;
    data['totalFactura'] = totalFactura;
    data['totalImpuesto'] = totalImpuesto;
    data['totalDescuento'] = totalDescuento;
    data['totalExento'] = totalExento;
    data['kilometraje'] = kilometraje;   
    data['plazo'] = plazo;
    data['msgDetalle1'] = employeeID;
    return data;
  }
}