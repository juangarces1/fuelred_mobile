
import 'package:flutter/material.dart';
import 'package:fuelred_mobile/helpers/varios_helpers.dart';
import 'package:fuelred_mobile/models/factura.dart';
import 'package:fuelred_mobile/models/peddler.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/resumen_dia.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class Impresion {
  static Future<void> printFactura(Factura factura, String tipoDocumento, String tipoCliente) async {
     final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    
      DateFormat formateador = DateFormat('yyyy-MM-dd HH:mm');
     String fechaFormateada = formateador.format(factura.fechaHoraTrans);
      //make a loop for set numero in detalles
         int i = 1;
         for (final detalle in factura.detalles) {
           detalle.numero = i;
           i++;
         }
     // Create the PDF document
     //final pdf = pw.Document();
     // Define the font
     final font = await PdfGoogleFonts.nunitoMedium();
     final fontTitulo = await PdfGoogleFonts.nunitoBold();
     const fontSizeTitulos = 10.0;
     const fontSize = 9.0;
     const fontSizePeque = 8.0;
    
     pdf.addPage(pw.Page(
       pageFormat: PdfPageFormat.roll57,
       build: (pw.Context context) {
         return pw.Column(
           crossAxisAlignment: pw.CrossAxisAlignment.start,
           mainAxisAlignment: pw.MainAxisAlignment.center,
           children: [
             pw.Text('ESTACION SAN GERARDO', style: pw.TextStyle(font: fontTitulo,  fontSize : fontSizeTitulos)),
             pw.Text('GRUPO POJI S.A.', style: pw.TextStyle(font: font, fontSize : fontSize)),
             pw.Text('CED JUR:3-101-110670', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Text('CHOMES, PUNTARENAS', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Text('100 mts sur de la CCSS', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Text('email:info@estacionsangerardo.com', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Divider(),
             pw.Text(tipoDocumento, style: pw.TextStyle(font: fontTitulo,  fontSize : fontSizeTitulos)),
             pw.Text(factura.clave?.substring(21,40)??'', style: pw.TextStyle(font: font,  fontSize : fontSize)),
             pw.Divider(),
             pw.Text('CLAVE:', style: pw.TextStyle(font: font, fontSize : fontSize)),
             pw.Text(factura.clave!, style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
           //  pw.Text(widget.factura.clave!.substring(25,49), style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Divider(),
             pw.Text('NUMERO INTERNO ${factura.nFactura}', style: pw.TextStyle(font: font, fontSize : fontSizeTitulos)),
             pw.Divider(),
             pw.Text(tipoCliente == "CONTADO" ? 'FORMA PAGO: CONTADO' : 'FORMA PAGO: CREDITO', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Text('Fecha: $fechaFormateada', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Text('Pistero: ${factura.usuario}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Divider(),
             if (tipoDocumento !="TICKET")
               pw.Text('${factura.cliente} ', style: pw.TextStyle(font: fontTitulo,  fontSize : fontSizeTitulos)),
            if (tipoDocumento !="TICKET")
               pw.Text('# Identificacion: ${factura.identificacion}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
              if (tipoDocumento !="TICKET")
               pw.Text('Telefono: ${factura.telefono}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
              if (tipoDocumento !="TICKET")
               pw.Text('Email: ${factura.email}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),  
              if (tipoDocumento !="TICKET")      
               pw.Divider(),
             if (factura.nPlaca != '' && factura.nPlaca != null)
               pw.Text('Placa: ${factura.nPlaca}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             if (factura.kilometraje != 0 && factura.kilometraje != null)
               pw.Text('Kilometraje: ${factura.kilometraje}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             if(factura.observaciones != '' && factura.observaciones != null)
               pw.Text('Observaciones:', style: pw.TextStyle(font: font, fontSize : fontSize)),
               pw.Text(factura.observaciones ?? '', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
          
             if(factura.observaciones != '' && factura.observaciones != null) 
                pw.Divider(),
              pw.Text('Detalle Factura', style: pw.TextStyle(font: fontTitulo,  fontSize : fontSizeTitulos)),
             for (final detalle in factura.detalles)
             pw.Column(
               crossAxisAlignment: pw.CrossAxisAlignment.start,
               children: [           
               pw.Text('Articulo ${detalle.numero}: ${detalle.detalle}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),              
               pw.Row(
                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                 children: [                
                   pw.Text('Cant.', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold, fontSize : fontSizePeque)),
                   pw.Text('Precio', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold, fontSize : fontSizePeque)),
                   pw.Text('Sub-Total', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold, fontSize : fontSizePeque)),
                 ],
               ),
            
               pw.Row(
                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                 children: [                 
                   pw.Text(detalle.cantidad.toString(), style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                   pw.Text('¢${NumberFormat("###,000", "en_US").format(detalle.precioUnit)}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                   pw.Text('¢${NumberFormat("###,000", "en_US").format(detalle.subtotal)}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                 ],
               ),
                ],),
             pw.Divider(),
             pw.Row(
               mainAxisAlignment: pw.MainAxisAlignment.center,
               crossAxisAlignment: pw.CrossAxisAlignment.center,
               children: [
                 pw.Text('Sub-Total:', style: pw.TextStyle(font: fontTitulo, fontSize : fontSizeTitulos)),
                 pw.SizedBox(width: 8),
                 pw.Text('¢${NumberFormat("###,###.00", "en_US").format(factura.montoFactura)}', style: pw.TextStyle(font: fontTitulo, fontSize : fontSizeTitulos)),
               ],
             ),
             pw.Row(
               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
               children: [
                 pw.Text('Total Grabado:', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                 pw.Text('¢${NumberFormat("###,###.00", "en_US").format(factura.totalGravado)}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
               ],
             ),
             pw.Row(
               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
               children: [
                 pw.Text('Total Exento:', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                 pw.Text('¢${NumberFormat("###,###.00", "en_US").format(factura.totalExento)}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
               ],
             ),
             pw.Row(
               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
               children: [
                 pw.Text('Total Impuestos:', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                 pw.Text('¢${NumberFormat("###,###.00", "en_US").format(factura.totalImpuesto)}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
               ],
             ),
             pw.Row(
               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
               children: [
                 pw.Text('Total Descuentos:', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                 pw.Text('¢${NumberFormat("###,###.00", "en_US").format(factura.totalDescuento)}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
               ],
             ),
             pw.Row(
               mainAxisAlignment: pw.MainAxisAlignment.center,
               crossAxisAlignment: pw.CrossAxisAlignment.center,
               children: [
                 pw.Text('Total Factura:', style: pw.TextStyle(font: fontTitulo, fontSize : fontSizeTitulos)),
                   pw.SizedBox(width: 8),
                 pw.Text('¢${NumberFormat("###,###.0", "en_US").format(factura.totalFactura)}', style: pw.TextStyle(font: fontTitulo, fontWeight: pw.FontWeight.bold, fontSize : fontSizeTitulos)),
               ],
             ),
             pw.Divider(),
             pw.Text('Autorizado mediante resolucion DGT-R-48-2016', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Text('De fecha 12-12-2016 08:08:12 de la D. G. T. D.', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             if (tipoCliente =="CREDITO")
                pw.Divider(),
             if (tipoCliente =="CREDITO")
                pw.Text('FIRMA CLIENTE', style: pw.TextStyle(font: font, fontSize: 11)),
             if (tipoCliente =="CREDITO")
                pw.SizedBox(height: 10),
             if (tipoCliente =="CREDITO")
                pw.Divider(),
           ],
         );
       },
     ));

     

   // Print the PDF document
   
     await Printing.layoutPdf(
        format: PdfPageFormat.roll57,
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
  }

 

 static Future<void> printPeddler(Peddler peddler, BuildContext context) async {

 DateTime ahora = DateTime.now();
 DateFormat formateador = DateFormat('yyyy-MM-dd HH:mm');
 String fechaFormateada = formateador.format(ahora);
 double totalLitros = peddler.products!.map((c) => c.cantidad).reduce((a, b) => a + b);
 // Create the PDF document
 final pdf = pw.Document();
  const myFormat = PdfPageFormat(90 * PdfPageFormat.mm, 300 * PdfPageFormat.mm);
 // Define the font
 final font = await PdfGoogleFonts.robotoCondensedRegular();
 final fontTitulo = await PdfGoogleFonts.robotoCondensedBold();
 const fontSizeTitulos = 10.0;
 const fontSize = 9.0;  // Add the header
 pdf.addPage(pw.Page(
     pageFormat: myFormat,
   build: (pw.Context context) {
     return pw.Column(
       crossAxisAlignment: pw.CrossAxisAlignment.start,
       children: [
         pw.Text('ESTACION SAN GERARDO', style: pw.TextStyle(font: fontTitulo,  fontSize : fontSizeTitulos)),         
         pw.Text('email:info@estacionsangerardo.com', style: pw.TextStyle(font: font, fontSize : fontSize)),
         pw.Divider(),
         pw.Center(
           child: pw.Text('Orden de Despacho Peddler', style: pw.TextStyle(font: fontTitulo,  fontSize : fontSizeTitulos)), 
         ),
                
         pw.Divider(),
    
   
         pw.Text('Fecha: $fechaFormateada', style: pw.TextStyle(font: font, fontSize : fontSize)),
         pw.Text('Pistero: ${peddler.pistero!.nombre} ${peddler.pistero!.apellido1}', style: pw.TextStyle(font: font, fontSize : fontSize)),
         pw.Divider(),
         pw.Text('Cliente', style: pw.TextStyle(font: fontTitulo,  fontSize : fontSizeTitulos)),          
         pw.Text(peddler.cliente!.nombre, style: pw.TextStyle(font: font, fontSize : fontSize)),            
         pw.Text('# Identificacion: ${peddler.cliente!.documento}', style: pw.TextStyle(font: font, fontSize : fontSize)),          
         pw.Text('Telefono: ${peddler.cliente!.telefono}', style: pw.TextStyle(font: font, fontSize : fontSize)),           
         pw.Text('Email: ${peddler.cliente!.email}', style: pw.TextStyle(font: font, fontSize : fontSize)),
         pw.Divider(),
         pw.Text('Chofer:', style: pw.TextStyle(font: fontTitulo,  fontSize : fontSize)),
         pw.Text(peddler.chofer!, style: pw.TextStyle(font: font, fontSize : fontSize)), 
         pw.Text('Placa: ${peddler.placa}', style: pw.TextStyle(font: font, fontSize : fontSize)),
         pw.Text('Km: ${peddler.km}', style: pw.TextStyle(font: font, fontSize : fontSize)),
         pw.Text('Observaciones:', style: pw.TextStyle(font: font, fontSize : fontSize)),
         pw.Text(peddler.observaciones ?? '', style: pw.TextStyle(font: font, fontSize : fontSize)),
         pw.Divider(),
         for (final product in peddler.products!)
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
              pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Transaccion # #${product.transaccion}', style: pw.TextStyle(font: font, fontSize : fontSize)),              
              ],
            ),
      
          pw.Text(product.detalle, style: pw.TextStyle(font: font, fontSize : fontSize)),              
           pw.Text('Cantidad: ${NumberFormat("###,##0.000", "en_US").format(product.cantidad)}', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold, fontSize : fontSize)),
           pw.Divider(),      
      
         ],),
     
         pw.Row(
           mainAxisAlignment: pw.MainAxisAlignment.center,
           crossAxisAlignment: pw.CrossAxisAlignment.center,
           children: [
             pw.Text('Total Litros:', style: pw.TextStyle(font: fontTitulo, fontSize : fontSizeTitulos)),
             pw.SizedBox(width: 8),
             pw.Text('¢${NumberFormat("###,##0.000", "en_US").format(totalLitros)}', style: pw.TextStyle(font: fontTitulo, fontSize : fontSizeTitulos)),
           ],
         ),          
  
    
            pw.Divider(),
   
            pw.Text('FIRMA CLIENTE', style: pw.TextStyle(font: font, fontSize: 9)),
     
            pw.SizedBox(height: 10),
  
            pw.Divider(),
         ],
        );
      },
    ));

   

   // Print the PDF document
    await Printing.layoutPdf(
        format: PdfPageFormat.roll57,
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

    
  }



  static Future<void> generatePdf(ResumenDia resumen) async {
  
  pw.TextStyle styteTitulo =  pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 14,  
                            color: PdfColors.blue800,                          // Ajusta el tamaño de la fuente según tus necesidades
                          );
   
  final pdf = pw.Document();
  pdf.addPage(    
    pw.MultiPage(
      pageFormat: PdfPageFormat.letter.landscape,
      build: (pw.Context context) {
        return [
           pw.Header(
            level: 0,
            child: pw.Text('Resumen del Día ${VariosHelpers.formatYYYYmmDD(resumen.fecha)} -- Consolidado #${resumen.numeroConsolidado}',
             style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.redAccent700 )),
          ),
      
          pw.Table(
            border: pw.TableBorder.all(),
            children: [

              
              
              pw.TableRow(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8.0),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Ventas Pistas',
                          style: styteTitulo,
                        ),
                        pw.Divider(), ...resumen.ventaPistas.toJson().entries.map((entry) {
                        if (entry.key != 'cierres' && entry.value != 0.0) {
                          String formattedKey = VariosHelpers.convertCamelCaseToTitle(entry.key);
                          return pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                '$formattedKey:',
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                VariosHelpers.formattedToCurrencyValue(entry.value.toString()),
                              ),
                            ],
                          );
                        } else {
                          return pw.Container(); // Devuelve un contenedor vacío para 'cierres'
                        }
                      }).where((child) => child is! pw.Container), // Opcional: añade un divisor para una mejor separación visual
                      ],
                    ),
                  ),
                   pw.Container(
                    padding: const pw.EdgeInsets.all(8.0), // Añade un padding para un mejor diseño
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Exonerado',
                          style: styteTitulo,
                        ),
                        pw.Divider(), ...resumen.exonerado.toJson().entries.map((entry) {
                           if (entry.key != 'cierres' && entry.value != 0.0) {
                            String formattedKey = VariosHelpers.convertCamelCaseToTitle(entry.key);
                            return pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  '$formattedKey:',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  VariosHelpers.formattedToCurrencyValue(entry.value.toString()),
                                ),
                              ],
                            );
                          } else {
                            return pw.Container(); // Devuelve un contenedor vacío para 'cierres'
                          }
                        }).where((child) => child is! pw.Container), // Opcional: añade un divisor para una mejor separación visual
                      ], // Eliminar contenedores vacíos de la lista
                    ),
                  ),
                
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8.0), // Añade un padding para un mejor diseño
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Total General',
                          style: styteTitulo,
                        ),
                        pw.Divider(), ...resumen.totalGeneral.toJson().entries.map((entry) {
                           if (entry.key != 'cierres' && entry.value != 0.0) {
                            String formattedKey = VariosHelpers.convertCamelCaseToTitle(entry.key);
                            return pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  '$formattedKey:',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  VariosHelpers.formattedToCurrencyValue(entry.value.toString()),
                                ),
                              ],
                            );
                          } else {
                            return pw.Container(); // Devuelve un contenedor vacío para 'cierres'
                          }
                        }).where((child) => child is! pw.Container), // Opcional: añade un divisor para una mejor separación visual
                      ], // Eliminar contenedores vacíos de la lista
                    ),
                  ),
                ]
              ),
              
              pw.TableRow(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8.0), // Añade un padding para un mejor diseño
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Avances BN',
                          style: styteTitulo,
                        ),
                        pw.Divider(), ...resumen.avancesBn.toJson().entries.map((entry) {
                           if (entry.key != 'cierres' && entry.value != 0.0) {
                            String formattedKey = VariosHelpers.convertCamelCaseToTitle(entry.key);
                            return pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  '$formattedKey:',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  VariosHelpers.formattedToCurrencyValue(entry.value.toString()),
                                ),
                              ],
                            );
                          } else {
                            return pw.Container(); // Devuelve un contenedor vacío para 'cierres'
                          }
                        }).where((child) => child is! pw.Container), // Opcional: añade un divisor para una mejor separación visual
                      ], // Eliminar contenedores vacíos de la lista
                    ),
                  ),
                   pw.Container(
                    padding: const pw.EdgeInsets.all(8.0), // Añade un padding para un mejor diseño
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Ventas Almacen',
                          style: styteTitulo,
                        ),
                        pw.Divider(), ...resumen.ventasAlmacen.toJson().entries.map((entry) {
                           if (entry.key != 'cierres' && entry.value != 0.0) {
                            String formattedKey = VariosHelpers.convertCamelCaseToTitle(entry.key);
                            return pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  '$formattedKey:',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  VariosHelpers.formattedToCurrencyValue(entry.value.toString()),
                                ),
                              ],
                            );
                          } else {
                            return pw.Container(); // Devuelve un contenedor vacío para 'cierres'
                          }
                        }).where((child) => child is! pw.Container), // Opcional: añade un divisor para una mejor separación visual
                      ], // Eliminar contenedores vacíos de la lista
                    ),
                  ),
                 
                  // Deja el tercer contenedor vacío si así lo requieres
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8.0), // Añade un padding para un mejor diseño
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Depositos',
                          style: styteTitulo,
                        ),
                        pw.Divider(),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Deposito Exo 1:',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              VariosHelpers.formattedToCurrencyValue(resumen.depositoExo1.toString()),
                            ),
                          ],
                        ),

                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Deposito Exo 2:',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              VariosHelpers.formattedToCurrencyValue(resumen.depositoExo2.toString()),
                            ),
                          ],
                        ),

                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Dep San Gerardo:',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              VariosHelpers.formattedToCurrencyValue(resumen.depositoSanGerardo.toString()),
                            ),
                          ],
                        ),    

                        resumen.depositoAvances > 0 ? pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Deposito Avances BN:',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              VariosHelpers.formattedToCurrencyValue(resumen.depositoAvances.toString()),
                            ),
                          ],
                        ):  pw.Container(), 

                         resumen.comision > 0 ? pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Comisión:',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              VariosHelpers.formattedToCurrencyValue(resumen.comision.toString()),
                            ),
                          ],
                        ):  pw.Container(),                     
                                              
                       pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Evaporación:',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              VariosHelpers.formattedToCurrencyValue(resumen.evaporacion.toString()),
                            ),
                          ],
                        ),    

                        resumen.comision > 0 ? pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Caja Chica:',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              VariosHelpers.formattedToCurrencyValue(resumen.cajaChica.toString()),
                            ),
                          ],
                        ):  pw.Container(), 
                       
                        //pregunta si la caja chica es mayor a cero y si es asi la muestra
                       
                        
                      ], 
                    ),
                  ),
                ]
              ),
            ]
          ),
        ];
      },
    ),
  );

  // Guardar o imprimir el PDF
  await Printing.layoutPdf(
    format: PdfPageFormat.letter.landscape,
    onLayout: (PdfPageFormat format,) async => pdf.save(),
  );
}
}