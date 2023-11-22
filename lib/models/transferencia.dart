

import 'package:fuelred_mobile/models/cliente.dart';
import 'package:fuelred_mobile/models/transparcial.dart';

class Transferencia {
  
   Cliente cliente = Cliente(
      nombre: "",
      documento: "",
      codigoTipoID: "",
      email: "",
      puntos: 0,
      codigo: '',
      telefono: '',
    ); 
  
    List<TransParcial> transfers = [];
    double monto = 0; 
    double totalTransfer = 0;

 

  Transferencia({

      required this.cliente,      
      required this.transfers,
      required this.monto,
      required this.totalTransfer,
  }); 
 
  Transferencia.fromJson(Map<String, dynamic> json) {    
    cliente = Cliente.fromJson(json['cliente']);
     if (json['transfers'] != null) {
      transfers = [];
      json['transfers'].forEach((d) {
        transfers.add(TransParcial.fromJson(d));
      });
    }
     monto = json['monto'];
    totalTransfer = json['totalTransfer'];
  }
   
   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};    
    data['cliente']=cliente.toJson();
    data['transfers'] = transfers.map((d) => d.toJson()).toList();
    data['monto'] = monto;   
    data['totalTransfer'] = totalTransfer;

    return data;
  } 

}