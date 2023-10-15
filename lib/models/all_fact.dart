import 'package:fuelred_mobile/models/cart.dart';
import 'package:fuelred_mobile/models/cierreactivo.dart';
import 'package:fuelred_mobile/models/cierrefinal.dart';
import 'package:fuelred_mobile/models/cliente.dart';
import 'package:fuelred_mobile/models/empleado.dart';
import 'package:fuelred_mobile/models/paid.dart';
import 'package:fuelred_mobile/models/product.dart';
import 'package:fuelred_mobile/models/sinpe.dart';
import 'package:fuelred_mobile/models/transferencia.dart';

class AllFact {
   Cart cart = Cart(numOfItem: 0, products: []);
   List<Product> transacciones =[];
   List<Product> productos =[];
   String? placa;
   String? kms;
   int lasTr=0;
   String? observaciones;
   List<String> placas=[];
   CierreActivo cierreActivo = CierreActivo(
     cierreFinal: CierreFinal(idcierre: 0,
      fechafinalcierre: DateTime.now(),
      fechainiciocierre: DateTime.now(),
      horainicio: "",
      horafinal: "",
      cedulaempleado: 0,
      inventario: "",
      idzona: 0,
      estado: "",
      turno: "",
     ),
      cajero: Empleado(
         cedulaEmpleado: 0,
         nombre: "",
         apellido1: "",
         apellido2: "",
         turno: "",
         tipoempleado: "",
      ),
      usuario:  Empleado(
         cedulaEmpleado: 0,
         nombre: "",
         apellido1: "",
         apellido2: "",
         turno: "",
         tipoempleado: "",
    )
  );
   Cliente clienteFactura = Cliente(
    nombre: "",
    documento: "",
    codigoTipoID: "",
    email: "",
    puntos: 0,
    codigo: '',
    telefono: '',
   );
   Cliente clientePuntos = Cliente(
    nombre: "",
    documento: "",
    codigoTipoID: "",
    email: "",
    puntos: 0, 
     codigo: '',
     telefono: '',
   );
   Paid formPago = Paid(
        showTotal: true,
        showFact: false,
        totalEfectivo: 0,
        totalBac: 0,
        totalDav: 0,
        totalBn: 0,
        totalSctia: 0,
        totalDollars: 0,
        totalCheques: 0,
        totalCupones: 0,
        totalPuntos: 0,
        totalTransfer: 0,
        saldo: 0,
        totalSinpe: 0,
        sinpe: Sinpe(
          id: 0,
          monto: 0,
          numComprobante: '',
          nota: '',
          idCierre: 0,
          nombreEmpleado: '',
          fecha: DateTime.now(),
          numFact: '',
          activo: 0,
        ),
        clientePaid:   Cliente(
            nombre: "",
            documento: "",
            codigoTipoID: "",
            email: "",
            puntos: 0,
             codigo: '',
             telefono: '',),
        transfer:  Transferencia(
        cliente: Cliente(
                nombre: "",
                documento: "",
                codigoTipoID: "",
                email: "",
                puntos: 0,
                  codigo: '',
                  telefono: '',
            ),
            transfers: [],
            monto: 0,
            totalTransfer: 0),
  );

   void setSaldo(){
    
     formPago.saldo=
         cart.total
         -formPago.totalEfectivo
         -formPago.totalBac
         -formPago.totalDav
         -formPago.totalBn
         -formPago.totalSctia
         -formPago.totalDollars
         -formPago.totalCheques
         -formPago.totalCupones
         -formPago.totalPuntos
         -formPago.totalTransfer
         -formPago.totalSinpe;
   } 
   
      
}