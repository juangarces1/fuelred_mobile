// factura_helper.dart

import 'package:fuelred_mobile/models/all_fact.dart';
import 'package:fuelred_mobile/models/transferencia.dart';
import 'package:fuelred_mobile/models/cliente.dart';
import 'package:fuelred_mobile/models/sinpe.dart';

void resetFactura(AllFact factura) {
  factura.cart.products.clear();
  factura.formPago.totalBac = 0;
  factura.formPago.totalBn = 0;
   factura.formPago.totalCheques=0;
     factura.formPago.totalCupones=0;
      factura.formPago.totalDav=0;
     factura.formPago.totalDollars=0;
     factura.formPago.totalEfectivo=0;
     factura.formPago.totalPuntos=0;
     factura.formPago.totalSctia=0;
     factura.formPago.transfer.totalTransfer=0;
     factura.formPago.totalSinpe=0;
  // ... Resto de los campos a resetear
  factura.formPago.transfer = Transferencia(
    cliente: Cliente(
      nombre: '', 
      documento: '', 
      codigoTipoID: '', 
      email: '', 
      puntos: 0, 
      codigo: '', 
      telefono: ''
    ), 
    transfers: [], 
    monto: 0, 
    totalTransfer: 0
  );
   factura.clienteFactura=Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: '');
   factura.clientePuntos=Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: '');
   factura.formPago.clientePaid=Cliente(nombre: '', documento: '', codigoTipoID: '', email: '', puntos: 0, codigo: '', telefono: '');
   factura.formPago.sinpe = Sinpe(numFact: '', fecha: DateTime.now(), id: 0, idCierre: 0, activo: 0, monto: 0, nombreEmpleado: '', nota: '', numComprobante: '');
      
  // ... Continuar con el reseteo de los campos necesarios
  factura.setSaldo(); 
}
