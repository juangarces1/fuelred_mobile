import 'dart:convert';

import 'package:fuelred_mobile/models/ad,min/dash.dart';
import 'package:fuelred_mobile/models/ad,min/transferfull.dart';
import 'package:fuelred_mobile/models/bank.dart';
import 'package:fuelred_mobile/models/cashback.dart';
import 'package:fuelred_mobile/models/cierreactivo.dart';
import 'package:fuelred_mobile/models/cierredatafono.dart';
import 'package:fuelred_mobile/models/cliente.dart';
import 'package:fuelred_mobile/models/clientecredito.dart';
import 'package:fuelred_mobile/models/datafono.dart';
import 'package:fuelred_mobile/models/deposito.dart';
import 'package:fuelred_mobile/models/money.dart';
import 'package:fuelred_mobile/models/peddler.dart';
import 'package:fuelred_mobile/models/product.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:fuelred_mobile/models/sinpe.dart';
import 'package:fuelred_mobile/models/tranferview.dart';
import 'package:fuelred_mobile/models/transaccion.dart';
import 'package:fuelred_mobile/models/transparcial.dart';
import 'package:fuelred_mobile/models/viatico.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/resumen_dia.dart';
import 'package:fuelred_mobile/modelsAdmin/DepostosConsolidado/consolidado_deposito.dart';
import 'package:fuelred_mobile/modelsAdmin/cuenta_banco.dart';
import 'package:http/http.dart' as http;

import '../models/resdoc_facturas.dart';
import 'constans.dart';

class ApiHelper {

static Future<Response> getCierreActivo(int? zona, int? cedula) async {  

    var url = Uri.parse('${Constans.getAPIUrl()}/api/users/GetCierreByZona/$zona-$cedula');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );

    var body = response.body;
   
    if (response.statusCode >= 400) {
      if (body.length < 2)
      {
        body="No hay Cierre Abierto";

        } 
        else{
           body="Contraseña Incorrecta";

        }
       return Response(isSuccess: false, message: body);
    }

   
    var decodedJson = jsonDecode(body);
   

    return Response(isSuccess: true, result: CierreActivo.fromJson(decodedJson));
 }

 

 static Future<Response> getDepositosByConsolidado(String dia) async {  
  var url = Uri.parse('${Constans.getAPIUrl()}/api/Cierre/GetDepositosConsolidado/$dia');
  
  try {
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );

    // Check for 200 OK response
    if (response.statusCode == 200) {
      try {
          var decodedJson = jsonDecode(response.body);
           return Response(isSuccess: true, result: ConsolidadoDeposito.fromJson(decodedJson));
          // Rest of your code...
        } catch (e) {
          print('Error parsing JSON: $e');
           return Response(isSuccess: false, message: "Exception: ${e.toString()}");
          // Handle the error or return a custom error message
        }
     
    } else if (response.statusCode == 204) {
      // No content
      return Response(isSuccess: true, message: '', result: []);
    } else {
      // Handle other statuses, maybe something went wrong
      return Response(isSuccess: false, message: "Error: ${response.statusCode}");
    }
  } catch (e) {
    // Catch any other errors, like JSON parsing errors
    return Response(isSuccess: false, message: "Exception: ${e.toString()}");
  }
}


 static Future<Response> getResumenDia(String dia) async {  

    var url = Uri.parse('${Constans.getAPIUrl()}/api/Cierre/GetResumenDia/$dia');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );

    var body = response.body;
   
    if (response.statusCode >= 400) {
     
       return Response(isSuccess: false, message: body);
    }

   
    var decodedJson = jsonDecode(body);
   

    return Response(isSuccess: true, result: ResumenDia.fromJson(decodedJson));
 }

static Future<Response> getClienteCredito(String id) async {      
   var url = Uri.parse('${Constans.getAPIUrl()}/api/Users/GetClienteCredito/$id');
   
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    ClienteCredito cliente = ClienteCredito();
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){      

      cliente=ClienteCredito.fromJson(decodedJson);
     }
     return Response(isSuccess: true, result: cliente);    
 }

 static Future<Response> getFactura(String id) async {      
   var url = Uri.parse('${Constans.getAPIUrl()}/api/Facturacion/GetFacturaByNum/$id');
   
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    resdoc_facturas? fact;
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){      

      fact=resdoc_facturas.fromJson(decodedJson);
     }
     return Response(isSuccess: true, result: fact);    
 }

 static Future<Response> getClientesCredito() async {      
   var url = Uri.parse('${Constans.getAPIUrl()}/api/Users/GetClientesCredito');
   
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<ClienteCredito> clientes =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){      

       for (var item in decodedJson){
        clientes.add(ClienteCredito.fromJson(item));
      }
     
     }
     return Response(isSuccess: true, result: clientes);    
 }

static Future<Response> getTransacciones(int? zona) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/TransaccionesApi/GetTransaccionesByZona/$zona');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Transaccion> transacciones =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        transacciones.add(Transaccion.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: transacciones);    
 }

 static Future<Response> getCuentasBancos() async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Otros/GetCuentasBancos');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<CuentaBanco> cuentaBancos =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        cuentaBancos.add(CuentaBanco.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: cuentaBancos);    
 }

 static Future<Response> getFacturasByCierre(int? cierre) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Facturacion/GetFacturasByCierre/$cierre');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<resdoc_facturas> facturas =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        facturas.add(resdoc_facturas.fromJson(item));
      }
     }

    for (var fact in facturas) {
       for (var element in fact.detalles) {
          element.images.add(element.imageUrl);
       }
    }
  

     return Response(isSuccess: true, result: facturas);    
 }

 static Future<Response> getFacturasByCliente(String id) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Facturacion/GetFacturasByCliente/$id');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<resdoc_facturas> facturas =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        facturas.add(resdoc_facturas.fromJson(item));
      }
     }

    for (var fact in facturas) {
       for (var element in fact.detalles) {
          element.images.add(element.imageUrl);
       }
    }
  

     return Response(isSuccess: true, result: facturas);    
 }

  static Future<Response> getFacturasCredito(int? cierre) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Facturacion/GetFacturasCreditByCierre/$cierre');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<resdoc_facturas> facturas =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        facturas.add(resdoc_facturas.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: facturas);    
 }

 static Future<Response> getTransaccionesByCierre(int? cierre) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/TransaccionesApi/GetTransaccionesByCierre/$cierre');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Transaccion> transacciones =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        transacciones.add(Transaccion.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: transacciones);    
 }

static Future<Response> getPeddlersByCierre(int? cierre) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Peddler/$cierre');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Peddler> peddlers =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        peddlers.add(Peddler.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: peddlers);    
 }

static Future<Response> getCierresDatafonos(int cierre) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/CierreDatafonos/$cierre');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<CierreDatafono> cierres =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        cierres.add(CierreDatafono.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: cierres);    
 }

 static Future<Response> getViaticosByCierre(int cierre) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Viaticos/GetViaticoByCierre/$cierre');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Viatico> viaticos =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        viaticos.add(Viatico.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: viaticos);    
 }

static Future<Response> getCashBacks(int cierre) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Cashbacks/$cierre');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Cashback> cashbacks =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        cashbacks.add(Cashback.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: cashbacks);    
 }

 static Future<Response> getSinpes(int cierre) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Sinpes/$cierre');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Sinpe> sinpes =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        sinpes.add(Sinpe.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: sinpes);    
 }

static Future<Response> getDepositos(int cierre) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Depositos/$cierre');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Deposito> depositos =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        depositos.add(Deposito.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: depositos);    
 }

static Future<Response> getBanks() async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Cashbacks/GetBanks');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Bank> banks =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        banks.add(Bank.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: banks);    
 }

 static Future<Response> getDatafonos() async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/CierreDatafonos/GetDatafonos');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Datafono> datafonos =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        datafonos.add(Datafono.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: datafonos);    
 }

 static Future<Response> getMoneys() async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Depositos/GetMoneys');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Money> moneys =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        moneys.add(Money.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: moneys);    
 }

 static Future<Response> getTransfes() async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Transferencias/GetTransfers');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Transferview> transfers =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        transfers.add(Transferview.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: transfers);    
 }

 static Future<Response> getTransferfull() async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Transferencias/GetTransfersFull');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<TransferFull> transfers =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        transfers.add(TransferFull.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: transfers);    
 }

  static Future<Response> getTransfesByCierre(int cierre) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/Transferencias/GetTransfersByCierre/$cierre');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<TransParcial> transfers =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        transfers.add(TransParcial.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: transfers);    
 }

  static Future<Response> getTransaccionesAsProduct(int? zona) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/TransaccionesApi/GetTransaccionesByZonaAsProducts/$zona');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Product> transacciones =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        transacciones.add(Product.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: transacciones);    
 }

  static Future<Response> getProducts(int? zona) async {
    var url = Uri.parse('${Constans.getAPIUrl()}/api/TransaccionesApi/GetProducts/$zona');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Product> products =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        products.add(Product.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: products);    
 }

  static Future<Response> getClienteContado() async {
   var url = Uri.parse('${Constans.getAPIUrl()}/api/TransaccionesApi/GetClientsContado');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Cliente> clientes =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        clientes.add(Cliente.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: clientes);    
 }

 static Future<Response> getSales() async {
   var url = Uri.parse('${Constans.getAPIUrl()}/api/Sales/');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    Dash? data;
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      data = Dash.fromJson(decodedJson);
     }
     return Response(isSuccess: true, result: data);    
 }

   static Future<Response> getClientesTransfer() async {
   var url = Uri.parse('${Constans.getAPIUrl()}/api/Otros/GetClientesSanGerardo');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    List<Cliente> clientes =[];
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){
      for (var item in decodedJson){
        clientes.add(Cliente.fromJson(item));
      }
     }
     return Response(isSuccess: true, result: clientes);    
 }

 static Future<Response> getClientFrec(String codigo) async {      
   var url = Uri.parse('${Constans.getAPIUrl()}/api/TransaccionesApi/GetClientFrecuente/?codigo=$codigo');
   
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },        
    );
    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }
    Cliente cliente =Cliente(nombre: "", documento: "", codigoTipoID: "", email: "", puntos: 0,  codigo: '', telefono: '');
    var decodedJson = jsonDecode(body);
     if(decodedJson != null){      

      cliente=Cliente.fromJson(decodedJson);
     }
     return Response(isSuccess: true, result: cliente);    
 }

static Future<Response> getClienteFromHacienda(String document) async {
   
    var url = Uri.parse('${Constans.apiHacienda}?identificacion=$document');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },
     
    );
     var body = response.body;
    if(response.statusCode >= 400){
      return Response(isSuccess: false, message: body);
    }
     
     Cliente cliente = Cliente(
      nombre: "",
      documento: document,
      codigoTipoID: "",
      email: "",
      puntos: 0,
      codigo: '',
      telefono: '',
      );
     var decodedJson = jsonDecode(body);
     if(decodedJson != null){
       
        cliente= Cliente.fromHaciendaJson(decodedJson);
     }
     cliente.documento=document;
     return Response(isSuccess: true, result: cliente);
  }

static Future<Response> put(String controller, String id, Map<String, dynamic> request) async {
        
    var url = Uri.parse('${Constans.getAPIUrl()}/api/$controller/$id');
    var response = await http.put(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',        
      },
      body: jsonEncode(request)
    );
     
    if(response.statusCode>= 400){
      return Response(isSuccess: false, message: response.body);
    }
    return Response(isSuccess: true);
  }

static Future<Response> post(String controller, Map<String, dynamic> request) async {        
    var url = Uri.parse('${Constans.getAPIUrl()}/$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',       
      },
      body: jsonEncode(request)
    );    

    if(response.statusCode >= 400){
      return Response(isSuccess: false, message: response.body);
    }     
     return Response(isSuccess: true, result: response.body, );
  }

  static Future<Response> postNoRequest(String controller) async {        
    var url = Uri.parse('${Constans.getAPIUrl()}/$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',       
      },      
    );    

    if(response.statusCode >= 400){
      return Response(isSuccess: false, message: response.body);
    }     
     return Response(isSuccess: true, result: response.body);
  }

static Future<Response> delete(String controller, String id) async { 
    
    var url = Uri.parse('${Constans.getAPIUrl()}$controller$id');
    var response = await http.delete(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',       
      },
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }  
}

