import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/components/loader_component.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/models/cliente.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:fuelred_mobile/modelsAdmin/cuenta_banco.dart';
import 'package:fuelred_mobile/modelsAdmin/transfer_admin.dart';
import 'package:fuelred_mobile/sizeconfig.dart';
import 'package:intl/intl.dart';


class AddTransferScreen extends StatefulWidget {
  const AddTransferScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTransferScreenState createState() => _AddTransferScreenState();
}

class _AddTransferScreenState extends State<AddTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final TransferenciaAdmin transferencia = TransferenciaAdmin(cuenta: '', idTransferencia: 0);
  DateTime? selectedDate;
  CuentaBanco? selectedCuenta; // Variable para almacenar la cuenta seleccionada
  List<CuentaBanco> cuentasBancoList = []; // Lista de cuentas de banco
  Cliente? selectedCliente;
  List<Cliente> clientesList = []; // Lista de clientes
  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    // Aquí deberías cargar las cuentas bancarias, por ejemplo, de una API o base de datos
    _getcuentas();
    _getClientes();
  }

  

   Future<void> _getcuentas() async {   
    Response response = await ApiHelper.getCuentasBancos();
    if (!response.isSuccess) {
        if (mounted) {       
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content:  Text(response.message),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }  
       return;
     }
    setState(() {
      cuentasBancoList = response.result;
    }); 
  }

    Future<void> _getClientes() async {   
    Response response = await ApiHelper.getClientesTransfer();
    if (!response.isSuccess) {
        if (mounted) {       
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content:  Text(response.message),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }  
       return;
     }
    setState(() {
      clientesList = response.result;
    }); 
  }

  void _updateSelectedCliente(Cliente clienteSeleccionado) {
    setState(() {
      selectedCliente = clienteSeleccionado; 
    });
  }

Widget _buildClientePopupMenu() {
  return PopupMenuButton<Cliente>(
    onSelected: _updateSelectedCliente,
    itemBuilder: (BuildContext context) {
      return clientesList.map((Cliente cliente) {
        return PopupMenuItem<Cliente>(
          value: cliente,
          child: Text(cliente.nombre),
        );
      }).toList();
    },
    child: ListTile(
      key: ValueKey(selectedCliente), // Cambia la clave cuando el cliente seleccionado cambia
      title: Text(selectedCliente?.nombre ?? 'Seleccione un cliente'),
      trailing: const Icon(Icons.arrow_drop_down),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kContrateFondoOscuro,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text('Agregar Transferencia', style: TextStyle(color: Colors.white)),
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                       SizedBox(height: SizeConfig.screenHeight * 0.02),
                        Text("Complete los Datos", style: headingStyle),
                      _buildClientePopupMenu(),
    
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 25),
                      child: DropdownButtonFormField<CuentaBanco>(
                        decoration: const InputDecoration(labelText: 'Cuenta'),
                        value: selectedCuenta,
                        items: cuentasBancoList.map<DropdownMenuItem<CuentaBanco>>((CuentaBanco cuenta) {
                          return DropdownMenuItem<CuentaBanco>(
                            value: cuenta,
                            child: Text(cuenta.numeroCuenta),
                          );
                        }).toList(),
                        onChanged: (CuentaBanco? newValue) {
                          setState(() {
                            selectedCuenta = newValue;
                            transferencia.cuenta = newValue?.numeroCuenta ?? '';
                          });
                        },
                        validator: (value) => value == null ? 'Por favor seleccione una cuenta' : null,
                      ),
                    ),
                   
                    // Otros campos aquí
                   
                    ListTile(
                      title: Text('Fecha: ${selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate??DateTime.now()) : 'No seleccionada'}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2025),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                            transferencia.fechaTransferencia = picked;
                          });
                        }
                      },
                    ),
                 
                    Padding(
                       padding: const EdgeInsets.only(left: 15, right: 25),
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Monto'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          transferencia.monto = int.tryParse(value!);
                        },
                         validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es requerido';
                          } else if (num.tryParse(value) == null) {
                            return 'Por favor, introduce un número válido';
                           }
                          // Aquí puedes agregar más condiciones de validación
                          return null; // Si el campo es válido
                        },
                      ),
                    ),
                   
                    Padding(
                       padding: const EdgeInsets.only(left: 15, right: 25),
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Número de Depósito'),
                        onSaved: (value) {
                          transferencia.numeroDeposito = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Este campo es requerido';
                          }
                          // Aquí puedes agregar más condiciones de validación
                          return null; // Si el campo es válido
                        },
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.only(left: 15, right: 25),
                      child: TextFormField(
                         
                        decoration: const InputDecoration(labelText: 'Notas'),
                        onSaved: (value) {
                          transferencia.notas = value;
                        },
                      ),
                    ),
                  
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedCliente == null) {
                             Fluttertoast.showToast(
                              msg: "Seleccione un cliente",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                            ); 
                            return;
                         }
    
                          if (selectedDate == null) {
                             Fluttertoast.showToast(
                              msg: "Seleccione una fecha",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                            ); 
                            return;
                         }
    
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Procesa la información de la transferencia
                          _goTransfer();
                        } 
                        
                      },
                      child: const Text('Agregar Transferencia'),
                    ),
                  ],
                ),
              ),
            ),
            _showLoader ? const LoaderComponent(text: 'Por favor espere...',) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
  
  Future<void> _goTransfer() async {
   setState(() {
     _showLoader = true;
   });

   TransferenciaAdmin transferenciaAdmin = TransferenciaAdmin(
     idTransferencia: 0,
     idCliente: int.parse( selectedCliente!.codigo),
     cuenta: selectedCuenta!.numeroCuenta,
     fechaTransferencia: selectedDate!,
     monto: transferencia.monto,
     numeroDeposito: transferencia.numeroDeposito,
     notas: transferencia.notas,
     idBanco: selectedCuenta!.idBanco,
     estado: 'ACTIVA',
   ); 

   Response response = await ApiHelper.post('Api/Transferencias/', transferenciaAdmin.toJson());
   
    setState(() {
      _showLoader = false;
    });

     if (!response.isSuccess) {
       showDialog(
         context: context,
         builder: (BuildContext context) {
           return AlertDialog(
             title: const Text('Error'),
             content:  Text(response.message),
             actions: <Widget>[
               TextButton(
                 child: const Text('Aceptar'),
                 onPressed: () {
                   Navigator.of(context).pop();
                 },
               ),
             ],
           );
         },
       );
       return;
     }
    showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text('Éxito'),
           content:  const Text('Transferencia agregada correctamente'),
           actions: <Widget>[
             TextButton(
               child: const Text('Aceptar'),
               onPressed: () {
                 Navigator.of(context).pop();
                 Navigator.of(context).pop();
               },
             ),
           ],
         );
       },
     );

  }
}
