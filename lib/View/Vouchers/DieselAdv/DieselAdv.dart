import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class DieselAdv extends StatefulWidget {
  const DieselAdv({Key? key}) : super(key: key);

  @override
  State<DieselAdv> createState() => _DieselAdvState();
}

List<String> vehicleList2 = [];
List<String> bpclAdvList = [];
int totalRate=0;
class _DieselAdvState extends State<DieselAdv> with Utility{

  TextEditingController dayController = TextEditingController(text: GlobalVariable.displayDate.day.toString().padLeft(2,'0'));
  TextEditingController monthController = TextEditingController(text: GlobalVariable.displayDate.month.toString().padLeft(2,'0'));
  TextEditingController yearController = TextEditingController(text: GlobalVariable.displayDate.year.toString());


  TextEditingController amount = TextEditingController();
  TextEditingController dateApi = TextEditingController();
  TextEditingController dateUi = TextEditingController();
  TextEditingController remark = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController totalAmount = TextEditingController();
  TextEditingController litre = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  final _formKey = GlobalKey<FormState>();

  ValueNotifier<String> vehicleListValue = ValueNotifier("");
  ValueNotifier<String> ledgerDropdown = ValueNotifier("");

  List vehicleList = [];
  List<String> vehicleNumberList = [];

  List ledgerList = [];
  List<String> ledgerTitleList = [];

  int oppLedgerID = 0;

  int freshLoad = 0;

  var vehicleID;


  // API
  dieselTransactionApiFunc(){
    setStateMounted(() {freshLoad = 1;});
    dieselTransactionApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
        // clearing all fields
        vehicleListValue.value = "";
        ledgerDropdown.value = "";
        litre.text = "";
        rate.text = "";
        totalAmount.text = "";
        remark.text = "";
        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        setStateMounted(() {freshLoad = 0;});
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  // vehicle Dropdown api
  vehicleFetchApiFunc(){
    ServiceWrapper().vehicleFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        vehicleList.clear();
        vehicleNumberList.clear();

        vehicleList.addAll(info['data']);

        for(int i = 0; i < info['data'].length ; i++){
          vehicleNumberList.add(info['data'][i]['vehicle_number']);
        }

        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  // ledger/BPCL dropdown api
  ledgerFetchApiFunc(){
    ServiceWrapper().ledgerFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){

        ledgerList.clear();
        ledgerTitleList.clear();

        ledgerList.addAll(info['data']);
        for(int i = 0; i < info['data'].length; i++){
          ledgerTitleList.add(info['data'][i]['ledger_title']);
        }
        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  void initState() {
    totalRate = 0;
    vehicleFetchApiFunc();
    ledgerFetchApiFunc();
    UiDecoration().initialDateApi(setState, dateApi);
    UiDecoration().initialDateUi(setState, dateUi);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    totalAmount.text = totalRate.toString();
    return Scaffold(
      appBar: UiDecoration.appBar('Diesel Advance'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
          padding: const EdgeInsets.all(20),
          decoration: UiDecoration().formDecoration(color: const Color(0xffccffff)),
          child: Form(
            key: _formKey,
            child: FocusScope(
              child: FocusTraversalGroup(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Vehicle Dropdown
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1('Vehicle'),
                              ValueListenableBuilder(
                                valueListenable:vehicleListValue ,
                                builder: (context, value2, child) =>
                                    SearchDropdownWidget(
                                        dropdownList: vehicleNumberList,
                                        hintText: "Select Vehicle",
                                        onChanged: (value) {
                                          vehicleListValue.value = value!;
                                          // vehicle ID
                                          for(int i=0; i<vehicleList.length; i++){
                                            if(vehicleListValue.value == vehicleList[i]['vehicle_number']){
                                              vehicleID = vehicleList[i]['vehicle_id'];
                                            }
                                          }

                                        }, selectedItem: value2),
                              ),
                            ],
                          ),
                        ),

                        widthBox30(),

                        // Ledger Dropdown
                        Expanded  (
                          flex: 2,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass()
                                  .heading1('Ledger'),
                              ValueListenableBuilder(
                                valueListenable: ledgerDropdown,
                                builder: (context, value2, child) =>
                                    SearchDropdownWidget(
                                        dropdownList: ledgerTitleList,
                                        hintText: "Select Ledger",
                                        onChanged: (value) {
                                          ledgerDropdown.value = value!;

                                          // getting vehicle ID
                                          for(int i = 0; i<ledgerList.length; i++){
                                            if(ledgerList[i]['ledger_title'] == value){
                                              oppLedgerID = ledgerList[i]['ledger_id'];
                                            }
                                          }

                                        }, selectedItem: value2),
                              ),
                            ],
                          ),
                        ),

                        widthBox30(),

                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass()
                                  .heading1('Litre'),
                              TextFormField(
                                focusNode: focusNode1,
                                controller: litre,
                                decoration: UiDecoration().outlineTextFieldDecoration('Enter Litre', ThemeColors.primary),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (value) {
                                  setStateMounted(() {
                                    if(litre.text.isEmpty || rate.text.isEmpty){
                                      setStateMounted(() {
                                        totalRate = 0;
                                      });
                                    }else{
                                      setStateMounted((){
                                        totalRate = int.parse(litre.text)*int.parse(rate.text);
                                      });
                                    }

                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    AlertBoxes.flushBarErrorMessage("Enter Litre", context);
                                    return 'Enter Litre';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                        ),

                        widthBox30(),

                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass()
                                  .heading1('Rate'),
                              TextFormField(
                                controller: rate,
                                decoration: UiDecoration().outlineTextFieldDecoration('Enter Rate/litre', ThemeColors.primary),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (p0) {
                                  if(litre.text.isEmpty || rate.text.isEmpty){
                                    setStateMounted(() {
                                      totalRate = 0;
                                    });
                                  }else{
                                    setStateMounted(() {
                                      totalRate = int.parse(litre.text)*int.parse(rate.text);
                                    });
                                  }

                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    AlertBoxes.flushBarErrorMessage("Enter Rate", context);
                                    return 'Enter Rate';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                    heightBox20(),
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDecorationClass().heading1('Total Amount'),
                                TextFormField(
                                  controller: totalAmount,
                                  readOnly: true,
                                  decoration: UiDecoration().outlineTextFieldDecoration('Total Amount', ThemeColors.primaryColor),
                                ),
                              ],
                            )),
                        widthBox30(),
                        //Date Field
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TextDecorationClass().heading1('Date'),
                                  const Text("  dd-mm-yyyy" , style: TextStyle(fontSize: 12, color: Colors.grey),)
                                ],
                              ),
                              DateFieldWidget(dayController: dayController, monthController: monthController, yearController: yearController, dateControllerApi: dateApi),
                            ],
                          ),
                        ),
                        widthBox30(),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1('Remark'),
                              TextFormField(
                                decoration: UiDecoration().outlineTextFieldDecoration('Enter Remark', ThemeColors.primary),
                                controller: remark,
                              ),
                            ],
                          ),
                        ),
                        widthBox30(),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(''),
                              freshLoad == 1 ? const CircularProgressIndicator() : ElevatedButton(
                                style: ButtonStyles.customiseButton(ThemeColors.primary, ThemeColors.whiteColor, 100.0, 40.0),
                                onPressed: (){
                                  if(_formKey.currentState!.validate()){
                                    _formKey.currentState!.save();
                                    // api
                                    dieselTransactionApiFunc();
                                  }
                                },
                                child: const Text('Add Money'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // API

  Future dieselTransactionApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/DieselTransaction");
    var body = {
      'opp_ledger_id': oppLedgerID.toString(),
      'desile_rate': rate.text,
      'liters': litre.text,
      'amount': totalAmount.text,
      'entry_by': GlobalVariable.entryBy,
      'vehicle_id':vehicleID.toString(),
      'remark':remark.text,
      'date':dateApi.text
    };
    var response = await http.post(url , headers: headers , body: body);
    return response.body.toString();
  }

  setStateMounted(VoidCallback fn){
    if(mounted){
      setState(fn);
    }
  }
}
