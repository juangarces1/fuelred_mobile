import 'package:flutter/material.dart';

class Product{
     int? numero =0;
     double cantidad =0;
     String tipoArticulo =""; 
     String codigoArticulo =""; 
     String unidad ="";  
     String detalle ="";  
     double precioUnit =0; 
     double montoTotal =0; 
     int descuento =0; 
     int nDescuento =0; 
     double subtotal =0; 
     double tasaImp =0; 
     double impMonto =0; 
     double total =0; 
     int rateid =0; 
     int taxid =0; 
     double precioCompra = 0; 
     String codigoCabys =""; 
     int transaccion = 0; 
     double factor = 0; 
     int dispensador = 0; 
     String imageUrl ="";
     int inventario=0;
     List<String> images= [];
     List<Color> colors= [];
     bool isFavourite=false;
     bool isPopular=false; 

     Product({this.numero,
              required this.cantidad,
              required this.tipoArticulo,
              required this.codigoArticulo,
              required this.unidad,
              required this.detalle,
              required this.precioUnit,
              required this.montoTotal,
              required this.descuento,
              required this.nDescuento,
              required this.subtotal,
              required this.tasaImp,
              required this.impMonto,
              required this.total,
              required this.rateid,
              required this.taxid,
              required this.precioCompra,
              required this.codigoCabys,
              required this.transaccion,
              required this.factor,
              required this.dispensador,
              required this.imageUrl,
              required this.inventario,
              required this.images,
              required this.colors,
              this.isFavourite =false,
              this.isPopular=false,

     });

     Product.fromJson(Map<String, dynamic> json) {
        codigoArticulo = json['codigo_articulo'];
        numero = json['numero'];
        cantidad = json['cantidad'].toDouble();
        tipoArticulo = json['tipo_articulo'];
        unidad = json['unidad'];
        detalle = json['detalle'];
        precioUnit = json['precio_unit'].toDouble();
        montoTotal = json['monto_total'].toDouble();
        descuento = json['descuento'];
        nDescuento = json['n_descuento'];
        subtotal = json['subtotal'].toDouble();
        tasaImp = json['tasa_imp'].toDouble();
        impMonto = json['imp_monto'].toDouble();
        total = json['total'].toDouble();
        rateid = json['rateid'];
        taxid = json['taxid'];
        precioCompra = json['precio_compra'].toDouble();
        codigoCabys = json['codigoCabys'];
        transaccion = json['transaccion'];
        factor = json['factor'].toDouble();
        dispensador = json['dispensador'];
        imageUrl=json['imageUrl'];
        inventario=json['inventario'];        
      }

  get numeroLinea => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codigo_articulo'] = codigoArticulo;
    data['numero'] = numero;
    data['cantidad'] = cantidad;
    data['tipo_articulo'] = tipoArticulo;
    data['unidad'] = unidad;
    data['detalle'] = detalle;
    data['precio_unit'] = precioUnit;
    data['monto_total'] = montoTotal;
    data['descuento'] = descuento;
    data['n_descuento'] = nDescuento;
    data['subtotal'] = subtotal;
    data['tasa_imp'] = tasaImp;
    data['imp_monto'] = impMonto;
    data['total'] = total;
    data['rateid'] = rateid;
    data['taxid'] = taxid;
    data['precio_compra'] = precioCompra;
    data['codigoCabys'] = codigoCabys;
    data['transaccion'] = transaccion;
    data['factor'] = factor;
    data['dispensador'] = dispensador;
    data['imageUrl'] = imageUrl;
    data['inventario'] = inventario;
    return data;
  }

  Map<String, dynamic> toApiProducJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codigo_articulo'] = codigoArticulo;
    data['numero'] = numero;
    data['cantidad'] = cantidad;
    data['tipo_articulo'] = tipoArticulo;
    data['unidad'] = unidad;
    data['detalle'] = detalle;
    data['precio_unit'] = precioUnit;
    data['monto_total'] = montoTotal;
    data['descuento'] = descuento;
    data['n_descuento'] = nDescuento;
    data['subtotal'] = subtotal;
    data['tasa_imp'] = tasaImp;
    data['imp_monto'] = impMonto;
    data['total'] = total;
    data['rateid'] = rateid;
    data['taxid'] = taxid;
    data['precio_compra'] = precioCompra;
    data['codigoCabys'] = codigoCabys;
    data['transaccion'] = transaccion;
    data['factor'] = factor;
    data['dispensador'] = dispensador;
    data['imageUrl'] = imageUrl;
    data['inventario'] = inventario;   
    return data;
  }

   void setTotal(){
   
      montoTotal = total * cantidad;
    }

}