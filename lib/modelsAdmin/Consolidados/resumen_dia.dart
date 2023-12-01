import 'package:fuelred_mobile/modelsAdmin/Consolidados/caja_avances_bn.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/caja_exo.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/total_general.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/ventas_almacen.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/ventas_pistas.dart';

class ResumenDia {
  VentasPistas ventaPistas;
  VentasAlmacen ventasAlmacen;
  CajaAvancesBN avancesBn;
  CajaExo exonerado;
  TotalGeneral totalGeneral;
  DateTime fecha;
  double evaporacion;
  double cajaChica;
  String notas;
  double depositoExo1;
  double depositoExo2;
  double comision;
  double depositoAvances;
  double depositoSanGerardo;
  double depositoExonerado;
  int numeroConsolidado;

  int comi;
  int precioexo;
  int litrosVentaNormal;
  int litrosVentaMayor;
  int precioventaNormal;
  int total;

  ResumenDia({
    required this.ventaPistas,
    required this.ventasAlmacen,
    required this.avancesBn,
    required this.exonerado,
    required this.totalGeneral,
    required this.fecha,
    this.evaporacion = 0.0,
    this.cajaChica = 0.0,
    this.notas = '',
    this.depositoExo1 = 0.0,
    this.depositoExo2 = 0.0,
    this.comision = 0.0,
    this.depositoAvances = 0.0,
    this.depositoSanGerardo = 0.0,
    this.depositoExonerado = 0.0,
    this.numeroConsolidado = 0,
    this.comi = 0,
    this.precioexo = 0,
    this.litrosVentaNormal = 0,
    this.litrosVentaMayor = 0,
    this.precioventaNormal = 0,
    this.total = 0,

  });

  // ... Métodos existentes ...

  // Constructor de fábrica para crear una instancia desde un mapa
  factory ResumenDia.fromJson(Map<String, dynamic> json) {
    return ResumenDia(
      ventaPistas: VentasPistas.fromJson(json['ventaPistas']),
      ventasAlmacen: VentasAlmacen.fromJson(json['ventasAlmacen']),
      avancesBn: CajaAvancesBN.fromJson(json['avancesBn']),
      exonerado: CajaExo.fromJson(json['exonerado']),
      totalGeneral: TotalGeneral.fromJson(json['totalGeneral']),
      fecha: DateTime.parse(json['fecha']),
      evaporacion: json['evaporacion'].toDouble(),
      cajaChica: json['cajaChica'].toDouble(),
      notas: json['notas'],
      depositoExo1: json['depositoExo1'].toDouble(),
      depositoExo2: json['depositoExo2'].toDouble(),
      comision: json['comision'].toDouble(),
      depositoAvances: json['depositoAvances'].toDouble(),
      depositoSanGerardo: json['depositoSanGerardo'].toDouble(),
      depositoExonerado: json['depositoExonerado'].toDouble(),
      numeroConsolidado: json['numeroConsolidado'],
      comi: json['comi'],
      precioexo: json['precioexo'],
      litrosVentaNormal: json['litrosVentaNormal'],
      litrosVentaMayor: json['litrosVentaMayor'],
      precioventaNormal: json['precioventaNormal'],
      total: json['total'],

    );
  }

  // Método para convertir la instancia en un mapa
  Map<String, dynamic> toJson() {
    return {
      'ventaPistas': ventaPistas.toJson(),
      'ventasAlmacen': ventasAlmacen.toJson(),
      'avancesBn': avancesBn.toJson(),
      'exonerado': exonerado.toJson(),
      'totalGeneral': totalGeneral.toJson(),
      'fecha': fecha.toIso8601String(),
      'evaporacion': evaporacion,
      'cajaChica': cajaChica,
      'notas': notas,
      'depositoExo1': depositoExo1,
      'depositoExo2': depositoExo2,
      'comision': comision,
      'depositoAvances': depositoAvances,
      'depositoSanGerardo': depositoSanGerardo,
      'depositoExonerado': depositoExonerado,
      'numeroConsolidado': numeroConsolidado,
      'comi': comi,
      'precioexo': precioexo,
      'litrosVentaNormal': litrosVentaNormal,
      'litrosVentaMayor': litrosVentaMayor,
      'precioventaNormal': precioventaNormal,
      'total': total,
    };
  }

  void setDepositos() {
    
    int totalPlataExonerado = exonerado.total.toInt();
    int MENOR = totalPlataExonerado - 1000;
    int MAYOR = totalPlataExonerado + 1000;

    if (total >= MENOR && total <= MAYOR) {
      depositoExonerado = ((comi + precioexo) * exonerado.ltsVentas);
      comision = exonerado.total - depositoExonerado;
      int EFECTIVO = totalGeneral.colones.toInt() - evaporacion.toInt();
      if (cajaChica != 0) {
        depositoSanGerardo = EFECTIVO - depositoExonerado - comision - cajaChica;
      } else {
        depositoSanGerardo = EFECTIVO - depositoExonerado - comision;
      }
      depositoExo1 = precioexo * exonerado.ltsVentas;
      depositoExo2 = comi * exonerado.ltsVentas;
      depositoSanGerardo += totalGeneral.dolares.toInt();
      // Suponiendo que tienes una función llamada ActualizarCajaChicaNota
     
    } else {
      int DIFERENCIA = totalPlataExonerado - total;
      if (DIFERENCIA < 0) {
        DIFERENCIA *= -1;
        double AUX = DIFERENCIA / precioventaNormal;
        litrosVentaNormal -= AUX.toInt();
        total = (litrosVentaMayor + litrosVentaNormal) * (comi + precioexo);
        int EFECTIVO = totalGeneral.colones.toInt() - evaporacion.toInt();
        depositoExonerado = total.toDouble();
        comision = exonerado.total.toInt() - depositoExonerado;
        if (cajaChica != 0) {
          depositoSanGerardo = EFECTIVO - depositoExonerado - comision - cajaChica;
        } else {
          depositoSanGerardo = EFECTIVO - depositoExonerado - comision;
        }
        depositoExo1 = (precioexo * (litrosVentaMayor + litrosVentaNormal)).toDouble();
        depositoExo2 = (comi * (litrosVentaMayor + litrosVentaNormal)).toDouble();
        depositoSanGerardo += totalGeneral.dolares.toInt();
        
      } else {
        double AUX = DIFERENCIA / precioventaNormal;
        litrosVentaNormal += AUX.toInt();
        total = (litrosVentaMayor + litrosVentaNormal) * (comi + precioexo);
        int EFECTIVO = totalGeneral.colones.toInt() - evaporacion.toInt();
        depositoExonerado = total.toDouble();
        comision = exonerado.total.toInt() - depositoExonerado;
        if (cajaChica != 0) {
          depositoSanGerardo = EFECTIVO - depositoExonerado - comision - cajaChica;
        } else {
          depositoSanGerardo = EFECTIVO - depositoExonerado - comision;
        }
        depositoExo1 = (precioexo * (litrosVentaMayor + litrosVentaNormal)).toDouble();
        depositoExo2 = (comi * (litrosVentaMayor + litrosVentaNormal)).toDouble();
        depositoSanGerardo += totalGeneral.dolares.toInt();
        
      }
    }
    depositoAvances = avancesBn.colones;
    
  }

}
