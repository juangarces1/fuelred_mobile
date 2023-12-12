import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuelred_mobile/Screens/Admin/ComponentsShared/app_bar_custom.dart';
import 'package:fuelred_mobile/Screens/Admin/ReumenDia/Components/custom_card.dart';
import 'package:fuelred_mobile/Screens/Admin/ReumenDia/Components/depositos_card.dart';
import 'package:fuelred_mobile/clases/impresion.dart';
import 'package:fuelred_mobile/components/default_button.dart';
import 'package:fuelred_mobile/components/my_loader.dart';
import 'package:fuelred_mobile/components/no_contetnt.dart';
import 'package:fuelred_mobile/constans.dart';
import 'package:fuelred_mobile/helpers/api_helper.dart';
import 'package:fuelred_mobile/helpers/varios_helpers.dart';
import 'package:fuelred_mobile/models/response.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/caja_avances_bn.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/caja_exo.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/consolidado.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/resumen_dia.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/total_general.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/ventas_almacen.dart';
import 'package:fuelred_mobile/modelsAdmin/Consolidados/ventas_pistas.dart';



class NewResumenDiaScreen extends StatefulWidget {
  const NewResumenDiaScreen({super.key});

  @override
  NewResumenDiaScreenState createState() => NewResumenDiaScreenState();
}

class NewResumenDiaScreenState extends State<NewResumenDiaScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  DateTime selectedDate = DateTime.now();
  bool showLoader = false;   
  late TextEditingController _controller;
  ResumenDia resumen = ResumenDia(
    ventaPistas: VentasPistas(cierres: []),
    ventasAlmacen: VentasAlmacen(cierres: []),
    avancesBn: CajaAvancesBN(),
    exonerado: CajaExo(),
    totalGeneral: TotalGeneral(),
    fecha: DateTime.now(),
    evaporacion: 0.0,
    cajaChica: 0.0,
    notas: '',
    depositoExo1: 0.0,
    depositoExo2: 0.0,
    comision: 0.0,
    depositoAvances: 0.0, 
    depositoSanGerardo: 0.0,
    depositoExonerado: 0.0,
    numeroConsolidado: 0
  );
  double cajaChicaBackup = 0.0;

   @override
  void initState() {    
    super.initState();    
    _controller = TextEditingController(text:  resumen.cajaChica.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          title: 'Resumen del Dia',
          foreColor: Colors.white,
          automaticallyImplyLeading: true,
           backgroundColor: kPrimaryColor,
          elevation: 8.0,
           actions: [ Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipOval(child:  Image.asset(
                    'assets/splash.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),), // Ícono de perfil de usuario
              ),],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children:  [
            tabSearch(),
            tab2Content(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Seleccione el Dia',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Consolidado del Dia',
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  Widget tabSearch() {
    return   Container(
    color: Colors.white,
    width: double.infinity, // Ocupa todo el ancho disponible
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Center(
                 child: Text(
                  'Seleccione el Dia',
                  style: myHeadingStylePrymary
                  ),
               ),
                const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10), // Adds some padding around the calendar
                decoration: BoxDecoration(
                  color: Colors.white, // Changes the background color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // Changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12), // Rounds the corners
                ),
                child: CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  onDateChanged: (newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
              ),

            const SizedBox(height: 10),
              Center(
                child: DefaultButton(
                  text: 'Buscar',
                  press: getResumenDia,
                ),
              ),
            ],
          ),
          showLoader ? const CustomActivityIndicator(loadingText: 'Procesando...',) : Container(),
        ],
      ),
    ),
   );
  }

  Widget tab2Content() {
     return resumen.numeroConsolidado == 0 ? const MyNoContent(text: 'Procesando...',) 
     : Container(
        color: kColorFondoOscuro,
       child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
               const SizedBox(height: 15,),
           
                Text(
                 'Dia: ${VariosHelpers.formatYYYYmmDD(selectedDate)}',
                  style: mySubHeadingStyleWhite,
                ),
               const SizedBox(height: 10,),
                MyCustomCard(
                  title: 'Ventas Pista',
                  details: resumen.ventaPistas.toJson(), 
                  baseColor: const Color.fromARGB(255, 96, 60, 155),
                  foreColor: Colors.white),
                MyCustomCard(
                  title: 'Caja Almacen', 
                  details: resumen.ventasAlmacen.toJson(), 
                  baseColor: Colors.orange,
                  foreColor: Colors.white),
                MyCustomCard(
                  title: 'Avances BN', 
                  details: resumen.avancesBn.toJson(), 
                  baseColor: kBlueColorLogo,
                  foreColor: Colors.white),
                MyCustomCard(
                  title: 'Exonerado', 
                  details: resumen.exonerado.toJson(), 
                  baseColor: const Color.fromARGB(255, 36, 146, 40),
                  foreColor: Colors.white),
                 MyCustomCard(
                  title: 'Total General', 
                  details: resumen.totalGeneral.toJson(), 
                  baseColor: const Color.fromARGB(255, 194, 35, 35),
                  foreColor: Colors.white),  
                cardDepositos(),
                
              ],
            ),
           ),
     );
  }

  Widget cardDepositos(){
     return Card(
      color: kPrimaryText,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: ExpansionTile(
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        title: const Text('Depositos', style: TextStyle(color: Colors.white ,fontWeight: FontWeight.bold,)),
        children: [ 
            DepositosCustomCard(
            title: 'Deposito Exo 1',
            baseColor: kPrimaryText, 
            foreColor: Colors.white, 
            valor: resumen.depositoExo1,
            colorVariable: "aaaadfaaf"
          ),
            DepositosCustomCard(
            title: 'Deposito Exo 2',
            baseColor: kPrimaryText, 
            foreColor: Colors.white, 
            valor: resumen.depositoExo2,
            colorVariable: "hdfghfg"
          ),
            DepositosCustomCard(
            title: 'Deposito Avances',
            baseColor: kPrimaryText, 
            foreColor: Colors.white, 
            valor: resumen.depositoAvances,
            colorVariable: "nhgfhn34sdfg"
          ),
            DepositosCustomCard(
            title: 'Deposito San Gerardo',
            baseColor: kPrimaryText, 
            foreColor: Colors.white, 
            valor: resumen.depositoSanGerardo,
            colorVariable: "hdfgfg"
          ),       
            DepositosCustomCard(
            title: 'Comisión',
            baseColor: kPrimaryText, 
            foreColor: Colors.white, 
            valor: resumen.comision,
            colorVariable: "aaafgfdfg5"
          ),
            Container(
              color: VariosHelpers.getShadedColor("aaasdfaaa", kPrimaryText), // Usa el color generado
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Caja Chica', style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Expanded(
                    child: Text(
                      VariosHelpers.formattedToCurrencyValue(resumen.cajaChica.toString()),                      
                      textAlign: TextAlign.right,
                      style:  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                    ),
                  ),
                  //make an icon to edit the text
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, ),
                    onPressed: () => mostrarEditarDialog(context, resumen),
                    tooltip: 'Editar Caja Chica',
                  ),
                ],
              ),
            ),      
            Container(
              color: kPrimaryText, // Usa el color generado
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                 
                  
                   IconButton(
                    icon: const Icon(Icons.calculate, color: Colors.white, size: 35,),
                    onPressed: () {
                       setState(() {
                        resumen.setDepositos();
                       });  
                       goSave();
                    },
                    tooltip: 'Calcular Depositos',
                  ),

                  IconButton(
                    icon: const Icon(Icons.print, color: Colors.white, size: 35,),
                    onPressed: () {
                          Impresion.generatePdf(resumen);                
                    },
                    tooltip: 'Imprimir',
                  ),

                  
                ],
              ),
            ),           
        ],         
      ),
    );
   }

  Future<void> mostrarEditarDialog(BuildContext context, ResumenDia resumen) async {
  TextEditingController controller = TextEditingController(text: resumen.cajaChica.toString());

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Editar Caja Chica'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true), // Teclado numérico con opción decimal
          // Puedes añadir más configuraciones aquí
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Cierra el diálogo sin guardar cambios
            },
          ),
          TextButton(
            child: const Text('Guardar'),
            onPressed: () {
              // Intenta convertir el texto a double y actualizar cajaChica
              double? valorActualizado = double.tryParse(controller.text);
              if (valorActualizado != null) {
                setState(() {
                   resumen.cajaChica = valorActualizado;
                });               
              }
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}

  Future<void> getResumenDia() async {
      setState(() {
        showLoader = true;
      });

      Response respose = await ApiHelper.getResumenDia(selectedDate.toString());

       setState(() {
        showLoader = false;
      });


      if (respose.isSuccess) {
        if (respose.message.isEmpty) {          
           Fluttertoast.showToast(
              msg: 'No se encontraron datos para esta fecha',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.amber,
              textColor: Colors.white,
              fontSize: 16.0
            ); 
           return;
        }
        setState(() {
          resumen = respose.result;
          cajaChicaBackup = resumen.cajaChica;
         
        });
         switchTab(1);
      } else {
        if (mounted) {       
             showDialog(
               context: context,
               builder: (BuildContext context) {
                 return AlertDialog(
                   title: const Text('Error'),
                   content:  Text(respose.message),
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
      }
     
     

  }

  void switchTab(int index) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  
  Future<void> goSave() async {
     
      if (cajaChicaBackup == resumen.cajaChica) {
        return;
      }
      
      setState(() {
        showLoader = true;
      });

      Consolidado aux = Consolidado(
        idConsolidado: resumen.numeroConsolidado,
        fecha: resumen.fecha,
        calibraciones: 'no',
        cajaChica: resumen.cajaChica.toInt(),
        notas: resumen.notas,
        evaporacion: resumen.evaporacion.toInt()
      );

      Response respose = await ApiHelper.put('Cierre', resumen.numeroConsolidado.toString(), aux.toJson());
       setState(() {
        showLoader = false;
      });
      if (respose.isSuccess) {
        cajaChicaBackup = resumen.cajaChica;
        Fluttertoast.showToast(
          msg: "Caja Chica Actualizada",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        ); 
      } else {
        if (mounted) {       
             showDialog(
               context: context,
               builder: (BuildContext context) {
                 return AlertDialog(
                   title: const Text('Error'),
                   content:  Text(respose.message),
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
      }
    
  }

}

