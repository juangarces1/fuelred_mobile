
import 'package:fuelred_mobile/models/cierrefinal.dart';
import 'package:fuelred_mobile/models/empleado.dart';

class CierreActivo {
   CierreFinal cierreFinal = CierreFinal(
   idcierre: 0,
   fechafinalcierre: DateTime.now(),
   fechainiciocierre: DateTime.now(),
   horainicio: "",
   horafinal: "",
   cedulaempleado: 0,
   inventario: "",
   idzona: 0,
   estado: "",
   turno: "",   
   
 );

  Empleado cajero = Empleado(
    cedulaEmpleado: 0,
    nombre: "",
    apellido1: "",
    apellido2: "",
    turno: "",
    tipoempleado: "",
  );

  Empleado usuario = Empleado(cedulaEmpleado: 0,
    nombre: "",
    apellido1: "",
    apellido2: "",
    turno: "",
    tipoempleado: "",
  );

  CierreActivo({required this.cierreFinal, required this.cajero, required this.usuario}); 
 
  CierreActivo.fromJson(Map<String, dynamic> json) {    
    cierreFinal = CierreFinal.fromJson(json['cierreFinal']);
    cajero = Empleado.fromJson(json['cajero']);
    usuario = Empleado.fromJson(json['usuario']);
  }
   
   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};    
    data['cierreFinal'] = cierreFinal.toJson();
    data['cajero'] = cajero.toJson();
    data['usuario'] = usuario.toJson();
    return data;
  } 

}