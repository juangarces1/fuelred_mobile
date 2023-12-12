import 'package:flutter/material.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_calibracion_cierre.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_cashbac_cierre.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_cierre.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_cirredatafono_cierre.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_depositos.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_facturas_cierre.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_invntario_final_cierre.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_peddler_cierre.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_sinpes_cierre.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_tarjetas_cierre.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_transferencias_cierer.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_ventas_cierre.dart';
import 'package:fuelred_mobile/Screens/Admin/Cierres/Components/card_viatico_cierre.dart';
import 'package:fuelred_mobile/Screens/Admin/ComponentsShared/app_bar_custom.dart';
import 'package:fuelred_mobile/Screens/Admin/ReumenDia/Components/depositos_card.dart';
import 'package:fuelred_mobile/components/default_button.dart';
import 'package:fuelred_mobile/components/my_loader.dart';
import 'package:fuelred_mobile/components/no_contetnt.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/helpers/varios_helpers.dart';
import 'package:fuelred_mobile/models/cierreactivo.dart';
import 'package:fuelred_mobile/models/cierrefinal.dart';
import 'package:fuelred_mobile/models/empleado.dart';
import 'package:fuelred_mobile/models/factura.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/cierre_general.dart';

class CierreScreen extends StatefulWidget {
  const CierreScreen({super.key});

  @override
  State<CierreScreen> createState() => _CierreScreenState();
}

class _CierreScreenState extends State<CierreScreen>  with SingleTickerProviderStateMixin {
  CierreCajaGeneral cierre = CierreCajaGeneral();
  bool _showLoader = false;
  final bool _cierreShowError = false;
  final String _cierreError = 'Campo requerido';
  String _cierre = '';
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();
  List<CierreActivo> cierresDia = [];
  int? selectedValue;
  CierreActivo cierreActivo = CierreActivo(
      cierreFinal: CierreFinal(),
       cajero: Empleado(cedulaEmpleado: 0, nombre: '', apellido1: '', apellido2: '', turno: '', tipoempleado: ''),
       usuario:Empleado(cedulaEmpleado: 1, nombre: '', apellido1: '', apellido2: '', turno: '', tipoempleado: ''),
  );

  List<Factura> defaultFacturas=[];



  @override
  void initState() {
    
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
      return SafeArea(
      child: Scaffold(
        
        appBar:  MyCustomAppBar(
         
        title: 'Consultar Cierre',
        automaticallyImplyLeading: true,   
        backgroundColor: kPrimaryColor,
        elevation: 8.0,
        shadowColor: Colors.blueGrey,
        foreColor: Colors.white,
        actions: [ 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipOval(child:  Image.asset(
                  'assets/splash.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),), // Ícono de perfil de usuario
            ),
        ],
            bottom:  TabBar(
              indicatorColor: Colors.white,
              controller: _tabController,
              labelColor: Colors.white, // Color for selected tab
              unselectedLabelColor: Colors.grey, // Color for unselected tabs
              tabs:  const [
                Tab(text: 'Buscar Cierre'),
                Tab(text: 'Cierre'),
              ],
            ),      ),
        body:  TabBarView(
          controller: _tabController,
          children: [
            _buildFilterTab(),
            _getContent(),
          ],
        ),
       
       
      ),
    );
  }

  
 Widget _showCierresActivos() {
  return Column(
    children: [
      Container(
        color: Colors.white,
        child: Center(
          child: Text('Seleccione el Cierre', style: mySubHeadingStyleBlacb,),
        ),
      ),
      Container( height: 160,
        color: Colors.white,
        child: ListWheelScrollView.useDelegate(  
          perspective: 0.005,        
          itemExtent: 150,
          physics: const FixedExtentScrollPhysics(),
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              return CardCierre(
                showButton: true,
                cierre: cierresDia[index],
                onTapCallback: () {                 
                   setState(() {
                      cierreActivo = cierresDia[index];
                    });
                    getCierreByDia();
                   },
              );
            },
            childCount:  cierresDia.length,
          ),
        ),
      ),
    ],
  );
 }  
  
  Future<void> getCierre() async {

    setState(() {
     
      _showLoader = true;
    });   
   
    Response response = await ApiHelper.getCierre(_cierre);
    setState(() {
        _showLoader = false;
    });
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
      cierre = response.result;
      cierreActivo = cierre.cierre!;
     setState(() {
        cierre;
        cierreActivo;
      
        //navegate to secondf tab
        _tabController.animateTo(1);
     });

  }

   Widget _showCierre() {
    return Container(
       padding: const EdgeInsets.only(left: 50.0, right: 50),
       child: TextField(       
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Ingresa el Cierre',
          labelText: 'Cierre',
          errorText: _cierreShowError ? _cierreError : null,
          suffixIcon: const Icon(Icons.numbers),
         
        ),
        onChanged: (value) {
          _cierre = value;
        },
      ),
    );
  }

  _buildFilterTab() {
     return SizedBox(
    width: double.infinity, // Ocupa todo el ancho disponible
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Center(
                   child: Text(
                    'Seleccione el Dia',
                    style: mySubHeadingStyleBlacb,
                    ),
                 ),
                     
                 _showDatePcker(),              
               const SizedBox(height: 10),
                cierresDia.isNotEmpty ? _showCierresActivos() : const SizedBox(height: 10),
             
              const SizedBox(height: 40),
             
              const Divider(thickness: 3, color: kPrimaryColor,),
                  const SizedBox(height: 40),
               Center(
                   child: Text(
                    'Digite el Numero de Cierre',
                    style: mySubHeadingStyleBlacb,
                    ),
                 ),
                _showCierre(),
              const SizedBox(height: 10),
                Center(
                  child: DefaultButton(
                    text: 'Buscar',
                    press: () => getCierre(),
                  ),
                ),
              ],
            ),
          ),
          _showLoader ? const CustomActivityIndicator(loadingText: 'Procesando...',) : Container(),
        ],
      ),
    ),
   );
  }

  Widget _showDatePcker() {
    return   ListTile(
      title: Text('Dia: ${VariosHelpers.formatYYYYmmDD(selectedDate)}', style: myHeadingStylePrymary,),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            selectedDate = picked;
            
          });
          goFindCierres();
        }
      },
    );
  }
 
  _getContent() {
   return   cierre.cierre == null ? const MyNoContent(text: 'No hay Datos',) 
    : Container(
        color: kContrateFondoOscuro,
       child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
               const SizedBox(height: 15,),

               CardCierre(cierre: cierreActivo, showButton: false,),
               const SizedBox(height: 10,),
               cardResumen(),

                cierre.depositos != null && cierre.depositos!.isNotEmpty ?   CardDepositoCierre(
                  depositos: cierre.depositos!, 
                  baseColor: kPrimaryText, 
                  foreColor: Colors.white
                ): Container(),

                cierre.facturas != null && cierre.facturas!.isNotEmpty ?   CardFacturasCierre(
                  facturas: cierre.facturas!.where((factura) => factura.plazo != null && factura.plazo! > 0).toList(),
 
                  baseColor: kBlueColorLogo, 
                  foreColor: Colors.white,
                  title: 'Facturas Credito',
                ): Container(),

                 cierre.facturas != null && cierre.facturas!.isNotEmpty ?  CardFacturasCierre(
                  facturas: cierre.facturas!.where((factura) => factura.plazo != null && factura.plazo! == 0).toList(),
 
                  baseColor: const Color.fromARGB(255, 99, 3, 172), 
                  foreColor: Colors.white,
                  title: 'Facturas Contado',
                ): Container(),

                cierre.transferencias != null && cierre.transferencias!.isNotEmpty ?  CardTransferenciaCierre(
                  transfers: cierre.transferencias!,
 
                  baseColor: const Color.fromARGB(255, 66, 13, 62), 
                  foreColor: Colors.white,
                 
                ): Container(),

                  cierre.calibraciones != null && cierre.calibraciones!.isNotEmpty ?  CardCaliCierre(
                    calibraciones: cierre.calibraciones!,
                    baseColor: const Color.fromARGB(255, 2, 12, 39), 
                    foreColor: Colors.white,
                                  ): Container(),

                 cierre.cashbacks != null && cierre.cashbacks!.isNotEmpty ?  CardCashbackCierrre(
                    cashs: cierre.cashbacks!,
                    baseColor: const Color.fromARGB(255, 4, 150, 176), 
                    foreColor: Colors.white,
                                  ): Container(),
                 cierre.cierresDatafono != null && cierre.cierresDatafono!.isNotEmpty ?  CardCierredatafonosCierre(
                    cierredatafonos: cierre.cierresDatafono!,
                    baseColor: const Color.fromARGB(255, 2, 148, 34), 
                    foreColor: Colors.white,
                                  ): Container(),
                 cierre.viaticos != null && cierre.viaticos!.isNotEmpty ?  CardViaticoCierre(
                    viaticos: cierre.viaticos!,
                    baseColor: const Color.fromARGB(255, 46, 4, 28), 
                    foreColor: Colors.white,
                                  ): Container(),
                cierre.sinpes != null && cierre.sinpes!.isNotEmpty ?  CardSinpecierre(
                    sinpes: cierre.sinpes!,
                    baseColor: const Color.fromARGB(255, 2, 22, 49), 
                    foreColor: Colors.white,
                                  ): Container(),

                  cierre.tarjetas != null && cierre.tarjetas!.isNotEmpty ?  CardTarjetasCierre(
                    tarjetas: cierre.tarjetas!,
                    baseColor: const Color.fromARGB(214, 56, 47, 218),
                    foreColor: Colors.white,
                ) : Container(),                  
             
                 cierre.peddlers != null && cierre.peddlers!.isNotEmpty ?  CardPeddlerCierre(
                    peddlers: cierre.peddlers!,
                    baseColor: const Color.fromARGB(214, 56, 47, 218),
                    foreColor: Colors.white,
                ) : Container(),

                cierre.articulosVenta != null && cierre.articulosVenta!.isNotEmpty ?  CardVentasCierre(
                    ventas: cierre.articulosVenta!,
                    baseColor: const Color.fromARGB(213, 234, 115, 18),
                    foreColor: Colors.white,
                ) : Container(),    

                  cierre.inventariofinal != null && cierre.inventariofinal!.isNotEmpty ?  CardinventarioFinalCierre(
                    inventariofinal: cierre.inventariofinal!,
                    baseColor: kPrimaryColor,
                    foreColor: Colors.white,
                  ) : Container(),                                   

              ],
            ),
           ),
     );

  }
  
 Future<void> goFindCierres() async {
     setState(() {
       cierresDia.clear();
      _showLoader = true;
    });   
   
    Response response = await ApiHelper.getCierresByDia(selectedDate);
    setState(() {
        _showLoader = false;
    });
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
        cierresDia = response.result;   
       // print(cierresDia.length);    
        //navegate to secondf tab
        
     });
  }

  Future<void> getCierreByDia() async {
    setState(() {     
      _showLoader = true;
    });   
   
    Response response = await ApiHelper.getCierre(cierreActivo.cierreFinal.idcierre.toString());
    setState(() {
        _showLoader = false;
    });
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
        cierre = response.result;
       
        //navegate to secondf tab
        _tabController.animateTo(1);
     });

  }

   Widget cardResumen(){
     return Card(
      color: kPrimaryColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: ExpansionTile(
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        title: const Text('Resumen', style: TextStyle(color: Colors.white ,fontWeight: FontWeight.bold,)),
        children: [ 
          cierre.totalDepositosColon > 0 ?   DepositosCustomCard(
            title: 'Colones',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalDepositosColon,
            colorVariable: "aaaadfaaf"
          ): const SizedBox(height: 0,),
     
         cierre.totalDepositosCheque > 0 ?   DepositosCustomCard(
            title: 'Cheques',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalDepositosCheque,
            colorVariable: "gfdsfg"
          ): const SizedBox(height: 0,),
          
           cierre.totalDepositosDollar > 0 ?   DepositosCustomCard(
            title: 'Dolares',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalDepositosDollar,
            colorVariable: "ewrgdsfg"
          ): const SizedBox(height: 0,),

          cierre.totalDepositosCupones > 0 ?   DepositosCustomCard(
            title: 'Cuponees',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalDepositosDollar,
            colorVariable: "hfgwerwer"
          ): const SizedBox(height: 0,),

           cierre.totalDepositosCupones > 0 ?   DepositosCustomCard(
            title: 'Cuponees',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalDepositosDollar,
            colorVariable: "hfgwerwer"
          ): const SizedBox(height: 0,),

          cierre.totalFacturasCredito > 0 ?   DepositosCustomCard(
            title: 'Facturas Credito',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalFacturasCredito,
            colorVariable: "adsfgfr"
          ): const SizedBox(height: 0,),

          cierre.totalMontocashbacks > 0 ?   DepositosCustomCard(
            title: 'Cashbacks',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalMontocashbacks,
            colorVariable: "hdfghertds4354534gadfg"
          ): const SizedBox(height: 0,),

          cierre.totalMontoCalibraciones > 0 ?   DepositosCustomCard(
            title: 'Calibraciones',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalMontoCalibraciones,
            colorVariable: "adsfgfr"
          ): const SizedBox(height: 0,),

          cierre.totalMontotarjetas > 0 ?   DepositosCustomCard(
            title: 'Tarjetas Canje',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalMontotarjetas,
            colorVariable: "ytr465fg"
          ): const SizedBox(height: 0,),
           
          cierre.totalMontoCierresDatafono > 0 ?   DepositosCustomCard(
            title: 'Cierre Datafonos',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalMontoCierresDatafono,
            colorVariable: "ytr465fg"
          ): const SizedBox(height: 0,), 

         cierre.totalMontoTransferencias > 0 ?   DepositosCustomCard(
            title: 'Transferencias',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalMontoTransferencias,
            colorVariable: "fghjsgfgsfhgf"
          ): const SizedBox(height: 0,),  

         cierre.totalMontoViaticos > 0 ?   DepositosCustomCard(
            title: 'Viaticos',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalMontoViaticos,
            colorVariable: "jhgfertert345"
          ): const SizedBox(height: 0,),  

         cierre.totalSinpes > 0 ?   DepositosCustomCard(
            title: 'Sinpes',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalSinpes,
            colorVariable: "gdsfgew343545"
          ): const SizedBox(height: 0,), 

           cierre.totalCierre > 0 ?   DepositosCustomCard(
            title: 'Total Cierre',
            baseColor: kPrimaryColor, 
            foreColor: Colors.white, 
            valor: cierre.totalCierre,
            colorVariable: "aaasdferefd3"
          ): const SizedBox(height: 0,),  
          
            

        ],         
      ),
    );
   }


}


