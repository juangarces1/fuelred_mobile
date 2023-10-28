
import 'package:fuelred_mobile/models/resdoc_facturas.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Impresion {
  static Future<void> printFacturaContado(resdoc_facturas factura, String tipoCLIENTE, String tipoDocumento) async {

     //make a loop for set numero in detalles
        int i = 1;
        for (final detalle in factura.detalles) {
          detalle.numero = i;
          i++;
        }
    // Create the PDF document
    final pdf = pw.Document();

    // Define the font
    final font = await PdfGoogleFonts.robotoCondensedRegular();
     final fontTitulo = await PdfGoogleFonts.robotoCondensedBold();

    // Add the header
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('ESTACION SAN GERARDO', style: pw.TextStyle(font: fontTitulo,  fontSize: 10)),
            pw.Text('GRUPO POJI S.A.', style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Text('CED JUR:3-101-110670', style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Text('CHOMES, PUNTARENAS', style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Text('100 mts sur de la CCSS', style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Text('email:info@estacionsangerardo.com', style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Divider(),
            pw.Text(tipoDocumento =='FACTURA' ? 'FACTURA ELECTRONICA NUMERO ' : 'TICKET ELECTRONICO NUMERO', style: pw.TextStyle(font: fontTitulo,  fontSize: 10)),
            pw.Text(factura.clave?.substring(21,40)??'', style: pw.TextStyle(font: font,  fontSize: 8)),
            pw.Divider(),
            pw.Text('CLAVE:', style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Text(factura.clave!.substring(0,24), style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Text(factura.clave!.substring(24,49), style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Divider(),
            pw.Text('NUMERO INTERNO ${factura.nFactura}', style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Divider(),
            pw.Text(tipoCLIENTE == "CONTADO" ? 'FORMA PAGO: CONTADO' : 'FORMA PAGO: CREDITO', style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Divider(),
            pw.Text('Fecha: ${factura.fechaHoraTrans}', style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Text('Pistero: ${factura.usuario}', style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Divider(),

            if (tipoDocumento =="FACTURA")
              pw.Text('Cliente', style: pw.TextStyle(font: fontTitulo,  fontSize: 10)),
            if (tipoDocumento =="FACTURA")
              pw.Text(factura.cliente, style: pw.TextStyle(font: font, fontSize: 8)),
            if (tipoDocumento =="FACTURA")
              pw.Text('# Identificacion: ${factura.identificacion}', style: pw.TextStyle(font: font, fontSize: 8)),
            if (tipoDocumento =="FACTURA")
              pw.Text('Telefono: ${factura.telefono}', style: pw.TextStyle(font: font, fontSize: 8)),
            if (tipoDocumento =="FACTURA")
              pw.Text('Email: ${factura.email}', style: pw.TextStyle(font: font, fontSize: 8)),  
            if (tipoDocumento =="FACTURA")         
              pw.Divider(),

            if (factura.nPlaca != '')
              pw.Text('PLACA: ${factura.nPlaca}', style: pw.TextStyle(font: font, fontSize: 8)),

            if (factura.kilometraje != 0)
              pw.Text('KILOMETRAJE: ${factura.kilometraje}', style: pw.TextStyle(font: font, fontSize: 8)),

            if(factura.observaciones != '')
              pw.Text('OBSERVACIONES:', style: pw.TextStyle(font: font, fontSize: 8)),
              pw.Text(factura.observaciones ?? '', style: pw.TextStyle(font: font, fontSize: 8)),
             
            pw.Divider(),
           
            for (final detalle in factura.detalles)
            pw.Column(
               crossAxisAlignment: pw.CrossAxisAlignment.start,
               children: [
              pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Articulo #${detalle.numero}', style: pw.TextStyle(font: font, fontSize: 8)),              
              ],
            ),
             pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(detalle.detalle, style: pw.TextStyle(font: font, fontSize: 8)),              
              ],
            ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [                
                  pw.Text('CANT', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold, fontSize: 8)),
                  pw.Text('PRECIO', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold, fontSize: 8)),
                  pw.Text('SUB-TOTAL', style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold, fontSize: 8)),
                ],
              ),
              
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [                 
                  pw.Text(NumberFormat("###,##0.000", "en_US").format(detalle.cantidad), style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text('¢${NumberFormat("###,000", "en_US").format(detalle.precioUnit)}', style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text('¢${NumberFormat("###,000", "en_US").format(detalle.subtotal)}', style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
               ],),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Sub-Total:', style: pw.TextStyle(font: fontTitulo, fontSize: 10)),
                pw.SizedBox(width: 8),
                pw.Text('¢${NumberFormat("###,000", "en_US").format(factura.montoFactura)}', style: pw.TextStyle(font: fontTitulo, fontSize: 10)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Mercancias Grabadas:', style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text('¢${NumberFormat("###,000", "en_US").format(factura.totalGravado)}', style: pw.TextStyle(font: font, fontSize: 8)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Mercancias Exentas:', style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text('¢${NumberFormat("###,000", "en_US").format(factura.totalExento)}', style: pw.TextStyle(font: font, fontSize: 8)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Impuestos:', style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text('¢${NumberFormat("###,000", "en_US").format(factura.totalImpuesto)}', style: pw.TextStyle(font: font, fontSize: 8)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Descuentos:', style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text('¢${NumberFormat("###,000", "en_US").format(factura.totalDescuento)}', style: pw.TextStyle(font: font, fontSize: 8)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Total Factura:', style: pw.TextStyle(font: fontTitulo, fontSize: 10)),
                  pw.SizedBox(width: 8),
                pw.Text('¢${NumberFormat("###,000", "en_US").format(factura.totalFactura)}', style: pw.TextStyle(font: fontTitulo, fontWeight: pw.FontWeight.bold, fontSize: 10)),
              ],
            ),
            pw.Divider(),
            pw.Text('Autorizado mediante resolucion DGT-R-48-2016', style: pw.TextStyle(font: font, fontSize: 8)),
            pw.Text('De fecha 12-12-2016 08:08:12 de la D. G. T. D.', style: pw.TextStyle(font: font, fontSize: 8)),
            if (tipoCLIENTE =="CREDITO")
               pw.Divider(),
            if (tipoCLIENTE =="CREDITO")
               pw.Text('FIRMA CLIENTE', style: pw.TextStyle(font: font, fontSize: 9)),
            if (tipoCLIENTE =="CREDITO")
               pw.SizedBox(height: 10),
            if (tipoCLIENTE =="CREDITO")
               pw.Divider(),


          ],
        );
      },
    ));

   

    // Print the PDF document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}