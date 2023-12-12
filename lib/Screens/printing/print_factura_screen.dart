import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fuelred_mobile/models/factura.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintFacturaScreen extends StatefulWidget {
  const PrintFacturaScreen({ 
    super.key, 
    required this.factura,
    required this.tipoDocumento,
    required this.tipoCliente,
     
  });

  final Factura factura;
  final String tipoDocumento;
  final String tipoCliente;

  @override
  State<PrintFacturaScreen> createState() => _PrintFacturaScreenState();
}

class _PrintFacturaScreenState extends State<PrintFacturaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Imprimir Factura')),
        body: PdfPreview(
          build: (format) => printFactura(format, 'title')
        ),
      );
  }

   Future<Uint8List> printFactura(PdfPageFormat format, String title) async {

     final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
     
     DateFormat formateador = DateFormat('yyyy-MM-dd HH:mm');
     String fechaFormateada = formateador.format(widget.factura.fechaHoraTrans);
      //make a loop for set numero in detalles
         int i = 1;
         for (final detalle in widget.factura.detalles) {
           detalle.numero = i;
           i++;
         }
     // Create the PDF document
     //final pdf = pw.Document();
     // Define the font
     final font = await PdfGoogleFonts.nunitoMedium();
     final fontTitulo = await PdfGoogleFonts.nunitoBold();
     const fontSizeTitulos = 18.0;
     const fontSize = 16.0;
     const fontSizePeque = 12.0;
    
     pdf.addPage(pw.Page(
       pageFormat: PdfPageFormat.legal,
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
             pw.Text(widget.tipoDocumento, style: pw.TextStyle(font: fontTitulo,  fontSize : fontSizeTitulos)),
             pw.Text(widget.factura.clave?.substring(21,40)??'', style: pw.TextStyle(font: font,  fontSize : fontSize)),
             pw.Divider(),
             pw.Text('CLAVE:', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Text(widget.factura.clave!, style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
           //  pw.Text(widget.factura.clave!.substring(25,49), style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Divider(),
             pw.Text('NUMERO INTERNO ${widget.factura.nFactura}', style: pw.TextStyle(font: font, fontSize : fontSizeTitulos)),
             pw.Divider(),
             pw.Text(widget.tipoCliente == "CONTADO" ? 'FORMA PAGO: CONTADO' : 'FORMA PAGO: CREDITO', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Text('Fecha: $fechaFormateada', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Text('Pistero: ${widget.factura.usuario}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Divider(),
             if (widget.tipoDocumento !="TICKET")
               pw.Text('${widget.factura.cliente} ', style: pw.TextStyle(font: fontTitulo,  fontSize : fontSizeTitulos)),
            if (widget.tipoDocumento !="TICKET")
               pw.Text('# Identificacion: ${widget.factura.identificacion}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
              if (widget.tipoDocumento !="TICKET")
               pw.Text('Telefono: ${widget.factura.telefono}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
              if (widget.tipoDocumento !="TICKET")
               pw.Text('Email: ${widget.factura.email}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),  
              if (widget.tipoDocumento !="TICKET")      
               pw.Divider(),
             if (widget.factura.nPlaca != '' && widget.factura.nPlaca != null)
               pw.Text('Placa: ${widget.factura.nPlaca}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             if (widget.factura.kilometraje != 0 && widget.factura.kilometraje != null)
               pw.Text('Kilometraje: ${widget.factura.kilometraje}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             if(widget.factura.observaciones != '' && widget.factura.observaciones != null)
               pw.Text('Observaciones:', style: pw.TextStyle(font: font, fontSize : fontSize)),
               pw.Text(widget.factura.observaciones ?? '', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
          
             if(widget.factura.observaciones != '' && widget.factura.observaciones != null) 
                pw.Divider(),
              pw.Text('Detalle Factura', style: pw.TextStyle(font: fontTitulo,  fontSize : fontSizeTitulos)),
             for (final detalle in widget.factura.detalles)
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
                 pw.Text('¢${NumberFormat("###,###.00", "en_US").format(widget.factura.montoFactura)}', style: pw.TextStyle(font: fontTitulo, fontSize : fontSizeTitulos)),
               ],
             ),
             pw.Row(
               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
               children: [
                 pw.Text('Total Grabado:', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                 pw.Text('¢${NumberFormat("###,###.00", "en_US").format(widget.factura.totalGravado)}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
               ],
             ),
             pw.Row(
               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
               children: [
                 pw.Text('Total Exento:', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                 pw.Text('¢${NumberFormat("###,###.00", "en_US").format(widget.factura.totalExento)}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
               ],
             ),
             pw.Row(
               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
               children: [
                 pw.Text('Total Impuestos:', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                 pw.Text('¢${NumberFormat("###,###.00", "en_US").format(widget.factura.totalImpuesto)}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
               ],
             ),
             pw.Row(
               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
               children: [
                 pw.Text('Total Descuentos:', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                 pw.Text('¢${NumberFormat("###,###.00", "en_US").format(widget.factura.totalDescuento)}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
               ],
             ),
             pw.Row(
               mainAxisAlignment: pw.MainAxisAlignment.center,
               crossAxisAlignment: pw.CrossAxisAlignment.center,
               children: [
                 pw.Text('Total Factura:', style: pw.TextStyle(font: fontTitulo, fontSize : fontSizeTitulos)),
                   pw.SizedBox(width: 8),
                 pw.Text('¢${NumberFormat("###,###.0", "en_US").format(widget.factura.totalFactura)}', style: pw.TextStyle(font: fontTitulo, fontWeight: pw.FontWeight.bold, fontSize : fontSizeTitulos)),
               ],
             ),
             pw.Divider(),
             pw.Text('Autorizado mediante resolucion DGT-R-48-2016', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             pw.Text('De fecha 12-12-2016 08:08:12 de la D. G. T. D.', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
             if (widget.tipoCliente =="CREDITO")
                pw.Divider(),
             if (widget.tipoCliente =="CREDITO")
                pw.Text('FIRMA CLIENTE', style: pw.TextStyle(font: font, fontSize: 11)),
             if (widget.tipoCliente =="CREDITO")
                pw.SizedBox(height: 10),
             if (widget.tipoCliente =="CREDITO")
                pw.Divider(),
           ],
         );
       },
     ));

     

   // Print the PDF document
   
    return pdf.save();
  }

   // ignore: unused_element
   Future<Uint8List> _generatePdfMio(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
     final font = await PdfGoogleFonts.nunitoMedium();
     final fontTitulo = await PdfGoogleFonts.nunitoBold();
     const fontSizeTitulos = 10.0;
     const fontSize = 9.0;
     const fontSizePeque = 7.5;
     DateFormat formateador = DateFormat('yyyy-MM-dd HH:mm');
     // ignore: unused_local_variable
     String fechaFormateada = formateador.format(widget.factura.fechaHoraTrans);
      //make a loop for set numero in detalles
         int i = 1;
         for (final detalle in widget.factura.detalles) {
           detalle.numero = i;
           i++;
         }

   

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.legal,
        build: (context) {
          return pw.Column(
            children: [
                  pw.Text('ESTACION SAN GERARDO', style: pw.TextStyle(font: fontTitulo,  fontSize : fontSizeTitulos)),
                  pw.Text('GRUPO POJI S.A.', style: pw.TextStyle(font: font, fontSize : fontSize)),
                  pw.Text('CED JUR:3-101-110670', style: pw.TextStyle(font: font, fontSize : fontSize)),
                  pw.Text('CHOMES, PUNTARENAS', style: pw.TextStyle(font: font, fontSize : fontSize)),
                  pw.Text('100 mts sur de la CCSS', style: pw.TextStyle(font: font, fontSize : fontSize)),
                  pw.Text('email:info@estacionsangerardo.com', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                  pw.Divider(),
                  pw.Text(widget.tipoDocumento, style: pw.TextStyle(font: fontTitulo,  fontSize : fontSizeTitulos)),
                  pw.Text(widget.factura.clave?.substring(21,40)??'', style: pw.TextStyle(font: font,  fontSize : fontSize)),
                //  pw.Divider(),
                  // pw.Text('CLAVE:', style: pw.TextStyle(font: font, fontSize : fontSize)),
                  // pw.Text(widget.factura.clave!.substring(0,24), style: pw.TextStyle(font: font, fontSize : fontSize)),
                  // pw.Text(widget.factura.clave!.substring(25,49), style: pw.TextStyle(font: font, fontSize : fontSize)),
                  pw.Divider(),
                  pw.Text('NUMERO INTERNO ${widget.factura.nFactura}', style: pw.TextStyle(font: font, fontSize : fontSize)),
                  // pw.Divider(),
                  // pw.Text(widget.tipoCliente == "CONTADO" ? 'FORMA PAGO: CONTADO' : 'FORMA PAGO: CREDITO', style: pw.TextStyle(font: font, fontSize : fontSize)),
                  // pw.Text('Fecha: $fechaFormateada', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                  // pw.Text('Pistero: ${widget.factura.usuario}', style: pw.TextStyle(font: font, fontSize : fontSizePeque)),
                  // pw.Divider(),
               ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
class Product1 {
  final String id;
  final String name;
  final double price;

  Product1({required this.id, required this.name, required this.price});
}

class Client1 {
  final String id;
  final String name;
  final String email;

  Client1({required this.id, required this.name, required this.email});
}

class Ticket {
  final String id;
  final DateTime date;
  final String location;
  final Client1 client;
  final List<Product1> products;

  Ticket({required this.id, required this.date, required this.location, required this.client, required this.products});
}