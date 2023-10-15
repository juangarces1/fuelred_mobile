import 'package:fuelred_mobile/models/cliente.dart';
import 'package:fuelred_mobile/models/sinpe.dart';
import 'package:fuelred_mobile/models/transferencia.dart';


class Paid { 
  double totalEfectivo = 0; 
  double totalBac = 0; 
  double totalDav = 0; 
  double totalBn = 0; 
  double totalSctia = 0; 
  double totalDollars = 0; 
  double totalCheques = 0; 
  double totalCupones = 0; 
  double totalPuntos = 0; 
  double totalTransfer = 0;
  double totalSinpe = 0;
  double saldo = 0;
  String codigoTipoID = '';  
  String email = ''; 
  bool showTotal=false;  
  bool showFact=false;
  Cliente clientePaid = Cliente(
      nombre: "",
      documento: "",
      codigoTipoID: "",
      email: "",
      puntos: 0,
       codigo: '',
        telefono: '',
    );
    Sinpe sinpe = Sinpe(
      id: 0,
      numComprobante: '',
      nota: '',
      idCierre: 0,
      nombreEmpleado: '',
      fecha: DateTime.now(),
      numFact: '',
      activo: 0,
      monto: 0,
    );
  Transferencia transfer = Transferencia(cliente: Cliente(
      nombre: "",
      documento: "",
      codigoTipoID: "",
      email: "",
      puntos: 0,
       codigo: '',
        telefono: '',
    ),
     transfers: [], monto: 0, totalTransfer: 0); 
  
  Paid({
    required this.totalEfectivo,
    required this.totalBac,   
    required this.totalDav,
    required this.totalBn,    
    required this.totalSctia,   
    required this.totalDollars,
    required this.totalCheques,
    required this.totalCupones,   
    required this.totalPuntos,
    required this.totalTransfer,
    required this.saldo,
    required this.clientePaid,
    required this.transfer,
    required this.showTotal,
    required this.showFact,
    required this.totalSinpe,
    required this.sinpe,

  });

  Paid.fromJson(Map<String, dynamic> json) {  
    totalEfectivo = json['totalEfectivo'];
    totalBac = json['totalBac'];  
    totalDav = json['totalDav'];
    totalBn = json['totalBn'];  
    totalSctia = json['totalSctia'];
    totalDollars = json['totalDollars'];  
    totalCheques = json['totalCheques'];
    totalPuntos = json['totalPuntos'];   
    totalTransfer = json['totalTransfer'];
    saldo = json['saldo'];
    clientePaid= Cliente.fromJson(json['clientePaid']);
    transfer= Transferencia.fromJson(json['transfer']);
    sinpe = Sinpe.fromJson(json['sinpe']);
    totalSinpe = json['totalSinpe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};   
    data['totalEfectivo'] = totalEfectivo;  
    data['totalBac'] = totalBac;
    data['totalDav'] = totalDav;   
    data['totalBn'] = totalBn;
    data['totalSctia'] = totalSctia;  
    data['totalDollars'] = totalDollars;
    data['totalCheques'] = totalCheques;   
    data['totalPuntos'] = totalPuntos;
    data['totalTransfer'] = totalTransfer;   
    data['saldo'] = saldo;
    data['clientePaid'] = clientePaid.toJson();
    data['totalTransfer'] = transfer.toJson();
    data['sinpe'] = sinpe.toJson();
    data['totalSinpe'] = totalSinpe;
    return data;
  }

 
}