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

class CashAdv extends StatefulWidget {
  const CashAdv({Key? key}) : super(key: key);

  @override
  State<CashAdv> createState() => _CashAdvState();
}

List<String> vehicleList2 = ['Select Vehicle',"10", "20", "30", "40"];
List<String> bpclAdvList = ['Select Type', 'BPCL', 'Cash', 'ATM'];

class _CashAdvState extends State<CashAdv> with Utility{

  TextEditingController dayController = TextEditingController(text: GlobalVariable.displayDate.day.toString().padLeft(2,'0'));
  TextEditingController monthController = TextEditingController(text: GlobalVariable.displayDate.month.toString().padLeft(2,'0'));
  TextEditingController yearController = TextEditingController(text: GlobalVariable.displayDate.year.toString());


  ValueNotifier<String> vehicleListValue = ValueNotifier("");
  ValueNotifier<String> ledgerDropdown = ValueNotifier("");
  TextEditingController amount = TextEditingController();
  TextEditingController dateUi = TextEditingController();
  TextEditingController dateApi = TextEditingController();
  TextEditingController remark = TextEditingController();
  FocusNode focusNode1 = FocusNode();

  final _formKey = GlobalKey<FormState>();

  List vehicleList = [];
  List<String> vehicleNumberList = [];

  List ledgerList = [];
  List<String> ledgerTitleList = [];

  int oppLedgerID = 0;

  int freshLoad = 0;

  var vehicleID;

  // API
  cashTransactionApiFunc(){
    setStateMounted(() {freshLoad = 1;});
    cashTransactionApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
        vehicleListValue.value = "";
        ledgerDropdown.value = "";
        amount.text = "";
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

        setState(() {
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
        setState(() {
          freshLoad = 0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  void initState() {
    vehicleFetchApiFunc();
    ledgerFetchApiFunc();
    UiDecoration().initialDateUi(setState, dateUi);
    UiDecoration().initialDateApi(setState, dateApi);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar('Cash Advance'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
          padding: const EdgeInsets.all(20),
          decoration: UiDecoration().formDecoration(color: const Color(0xffccffe6)),
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
                                valueListenable: vehicleListValue,
                                builder: (context, value2, child) =>
                                    SearchDropdownWidget(
                                        dropdownList: vehicleNumberList,
                                        hintText: "Select Vehicle",
                                        onChanged: (value) {
                                          vehicleListValue.value = value!;

                                          // Vehicle ID
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

                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1('Ledger'),
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
                              )
                            ],
                          ),
                        ),

                        widthBox30(),

                        // Amount
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1('Amount'),
                              TextFormField(
                                focusNode: focusNode1,
                                controller: amount,
                                decoration: UiDecoration().outlineTextFieldDecoration('Amount', ThemeColors.primary),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    AlertBoxes.flushBarErrorMessage("Enter Amount", context);
                                    return "Enter Amount";
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
                        // Date Field
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
                              // TextDecoration().heading1("Date"),
                              // TextFormField(
                              //   readOnly: true,
                              //   controller: dateUi,
                              //   decoration: UiDecoration().outlineTextFieldDecoration("Date", Colors.grey),
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return 'Field is Required';
                              //     }
                              //     return null;
                              //   },
                              //   onTap: (){
                              //     UiDecoration().showDatePickerDecoration(context).then((value){
                              //       setState(() {
                              //         String month = value.month.toString().padLeft(2, '0');
                              //         String day = value.day.toString().padLeft(2, '0');
                              //         dateUi.text = "$day-$month-${value.year}";
                              //         dateApi.text = "${value.year}-$month-$day";
                              //       });
                              //     });
                              //   },
                              // ),
                            ],
                          ),
                        ),

                        widthBox30(),

                        // Remark field
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              const Text(''),
                              TextFormField(
                                decoration: UiDecoration().outlineTextFieldDecoration('Enter Remark', ThemeColors.primary),
                                controller: remark,
                              ),
                            ],
                          ),
                        ),

                        widthBox30(),

                        // Add Money Button
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
                                    cashTransactionApiFunc();
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
  Future cashTransactionApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/CashTransaction");
    var body = {
      'opp_ledger_id': oppLedgerID.toString(),
      'amount': amount.text,
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
