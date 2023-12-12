

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:fuelred_mobile/Screens/test_print/printerebun.dart';
import 'package:fuelred_mobile/models/factura.dart';
import 'package:intl/intl.dart';

///Test printing
class TestPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

     sample() async {
          bluetooth.isConnected.then((isConnected) {
            if (isConnected == true) { 
                 bluetooth.printNewLine();
                 bluetooth.printCustom('ESTACION SAN GERARDO', Size.boldLarge.val, Align.center.val);
                 bluetooth.printCustom('GRUPO POJI S.A.', Size.boldLarge.val, Align.center.val);
                 bluetooth.printNewLine();
            } 
          });
     }

   ptrintFactura(Factura factura, String tipoDocumento, String tipoCliente) async {
    //image max 300px X 300px
     DateFormat formateador = DateFormat('yyyy-MM-dd HH:mm');
     String fechaFormateada = formateador.format(factura.fechaHoraTrans);
     
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {         
         bluetooth.printCustom('ESTACION SAN GERARDO', Size.boldLarge.val, Align.center.val);
         bluetooth.printCustom('GRUPO POJI S.A.', Size.boldLarge.val, Align.center.val);
         bluetooth.printNewLine();
         bluetooth.printCustom('Ced Jur : 3-101-110670', Size.bold.val, Align.center.val);
         bluetooth.printCustom('Chomes, Puntarenas', Size.bold.val, Align.center.val);
         bluetooth.printCustom('100 mts sur de la CCSS', Size.bold.val, Align.center.val);
         bluetooth.printCustom('info@estacionsangerardo.com', Size.medium.val, Align.center.val);
         bluetooth.printNewLine();
         bluetooth.printCustom(tipoDocumento, Size.boldMedium.val, Align.center.val);      
         bluetooth.printCustom(factura.clave!.substring(21,40), Size.medium.val, Align.center.val);
         bluetooth.printNewLine();
         bluetooth.printCustom('CLAVE', Size.boldMedium.val, Align.center.val);        
         bluetooth.printCustom(factura.clave!, Size.medium.val, Align.left.val);
         bluetooth.printNewLine();
         bluetooth.printCustom('NUMERO INTERNO', Size.boldMedium.val, Align.center.val);
         bluetooth.printCustom(factura.nFactura, Size.bold.val, Align.center.val);
         bluetooth.printNewLine(); 
         bluetooth.printCustom(
            tipoCliente == "CONTADO" ? 'Forma Pago: Contado' : 'Forma Pago: Credito',
            Size.bold.val, Align.center.val);
         bluetooth.printCustom('Fecha: $fechaFormateada', Size.bold.val, Align.center.val);
           bluetooth.printCustom('Pistero: ${factura.usuario}', Size.bold.val, Align.center.val);
         bluetooth.printNewLine();
         if(tipoDocumento !='TICKET'){         
           bluetooth.printCustom('Cliente:', Size.bold.val, Align.left.val);
           bluetooth.printCustom(factura.cliente, Size.bold.val, Align.left.val);
           bluetooth.printCustom('# Identificacion: ${factura.identificacion}', Size.bold.val, Align.left.val);
           bluetooth.printCustom('Telefono: ${factura.telefono}', Size.medium.val, Align.left.val);
           bluetooth.printCustom('Email: ${factura.email}', Size.medium.val, Align.left.val);
           bluetooth.printNewLine();
         }
        if(  factura.nPlaca != null &&  factura.nPlaca != ''){
            bluetooth.printCustom('Placa: ${factura.nPlaca}', Size.bold.val, Align.left.val);
        }
        if(factura.kilometraje != null && factura.kilometraje != 0){
            bluetooth.printCustom('Kilometraje: ${factura.kilometraje}', Size.bold.val, Align.left.val);
        }  
        if(factura.observaciones != null && factura.observaciones != ''){
            bluetooth.printCustom('Observaciones: ${factura.observaciones}', Size.bold.val, Align.left.val);
        }
        bluetooth.printNewLine();
       
        bluetooth.printCustom('Detalle', Size.bold.val, Align.center.val);
        for (final detalle in factura.detalles) {
          bluetooth.printCustom(detalle.detalle, Size.medium.val, Align.left.val);
          bluetooth.print3Column('Sub-Total', 'Precio', 'Cant.', Size.medium.val,  format: "%-9s %9s %10s %n" );
          bluetooth.print3Column(
              NumberFormat("###,###.00", "en_US").format(detalle.subtotal),
              NumberFormat("###,###", "en_US").format(detalle.precioUnit,),
              detalle.cantidad.toString(),
              Size.medium.val,
               format: "%-9s %9s %10s %n" 
           );
        }

      
       bluetooth.printNewLine();
  
         bluetooth.printLeftRight(
           'Sub-Total',
            NumberFormat("###,###.00", "en_US").format(factura.montoFactura,),
            Size.bold.val);
         if(factura.totalGravado! > 0){
           bluetooth.printLeftRight(
           'Total Grabado:',
             NumberFormat("###,###.00", "en_US").format(factura.totalGravado,),
            Size.bold.val);
         }   
          if(factura.totalExento! > 0){
               bluetooth.printLeftRight(
           'Total Exento:',
             NumberFormat("###,###.00", "en_US").format(factura.totalExento,),
            Size.bold.val);
          }
        bluetooth.printLeftRight(
           'Total Impuestos:',
             NumberFormat("###,###.00", "en_US").format(factura.totalImpuesto,),
            Size.bold.val);
         if(factura.totalDescuento! > 0){
            bluetooth.printLeftRight(
           'Total Descuentos:',
             NumberFormat("###,###.00", "en_US").format(factura.totalDescuento,),
            Size.bold.val);
          }
     
              bluetooth.printNewLine();
         bluetooth.printLeftRight(
           'Total Factura:',
             NumberFormat("###,###.00", "en_US").format(factura.totalFactura,),
            Size.boldLarge.val);   
          bluetooth.printNewLine();
          bluetooth.printCustom(
           'Autorizado mediante resolucion DGT-R-48-2016 De fecha 12-12-2016  08:08:12 de la D.G.T.D.',
            Size.medium.val,
            Align.left.val
           );
      
    
         if (tipoCliente =="CREDITO"){
            bluetooth.printCustom('Firma Cliente:', Size.boldMedium.val, Align.center.val);
             bluetooth.printNewLine();
             bluetooth.printNewLine();
             bluetooth.printNewLine();
         }
        bluetooth.paperCut();



      }
    });
  }


}