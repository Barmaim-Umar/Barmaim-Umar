import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
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

class ExpensesVoucher extends StatefulWidget {
  const ExpensesVoucher({Key? key}) : super(key: key);

  @override
  State<ExpensesVoucher> createState() => _ExpensesVoucherState();
}

List<String> accountList = ['Select Ledger', '1', '2', '3'];
List<String> employeeNameList = [ '1', '2', '3' , '4'];
List<String> vehicleNumberList = [ '1', '2', '3' , '4'];
List totalList = [];
int totalAmount = 0;
class _ExpensesVoucherState extends State<ExpensesVoucher> with Utility {

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  TextEditingController dayController = TextEditingController(text: GlobalVariable.displayDate.day.toString().padLeft(2,'0'));
  TextEditingController monthController = TextEditingController(text: GlobalVariable.displayDate.month.toString().padLeft(2,'0'));
  TextEditingController yearController = TextEditingController(text: GlobalVariable.displayDate.year.toString());
  TextDecorationClass style = TextDecorationClass();
  TextEditingController dateControllerUI = TextEditingController();
  TextEditingController dateControllerApi = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController narrationController = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  /// Value Notifier
  ValueNotifier<String> vehicleNumberValue = ValueNotifier("");
  ValueNotifier<String> employeeNameValue = ValueNotifier("");
  ValueNotifier<String> ledgerValue = ValueNotifier("");
  ValueNotifier<String> oppLedgerValue = ValueNotifier("");
  List ledgerList = [];
  List<String> ledgerTitleList = [];
  List vehicleList = [];
  List<String> vehicleNumberList = [];
  var ledgerID;
  var oppLedgerID;
  var vehicleID;
  var employeeID;
  List idAndAmountList = []; // storing "ledger_id" and "amount"
  int freshLoad = 0;

  /// API
  transactionApiFunc(){
    setStateMounted(() {freshLoad =1;});
    transactionApi().then((value) {
      var info = jsonDecode(value);
      print('mnbvnb: $info');
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
        totalList.clear();
        totalAmount = 0;
        narrationController.clear();
        setState((){
          ledgerValue.value = "";
          vehicleNumberValue.value = "";
          employeeNameValue.value = "";
          oppLedgerValue.value = "";
        });
        amountController.clear();
        idAndAmountList.clear();
        setStateMounted(() {freshLoad =0;});
      } else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() {freshLoad =0;});
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

  // vehicle dropdown api
  vehicleFetchApiFunc(){
    ServiceWrapper().vehicleFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){

        vehicleList.clear();
        vehicleNumberList.clear();

        vehicleList.addAll(info['data']);
        for(int i=0; i<info['data'].length; i++){
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

  @override
  void initState() {

    totalAmount = 0;
    totalList.clear();

    ledgerFetchApiFunc();
    vehicleFetchApiFunc();

    UiDecoration().initialDateApi(setState, dateControllerApi);
    UiDecoration().initialDateUi(setState, dateControllerUI);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController totalPayment = TextEditingController(text: totalAmount.toString());
    final PaymentList paymentList = PaymentList(setState);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: UiDecoration.appBar('Expenses Voucher'),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 750,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
            decoration:  BoxDecoration(
              color: const Color(0xffffe6e1),
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.only(top: 30),
            child: Form(
              key: _formKey,
              child: FocusScope(
                child: FocusTraversalGroup(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// Select Vehicle
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1('Select Vehicle (Optional)'),
                              SizedBox(
                                width: 470,
                                child: ValueListenableBuilder(
                                  valueListenable: vehicleNumberValue,
                                  builder: (context, value2, child) {
                                    return SearchDropdownWidget(
                                      dropdownList: vehicleNumberList,
                                      hintText: "Select Vehicle",
                                      onChanged: (value) {

                                        vehicleNumberValue.value = value!;

                                        // for vehicle id
                                        for(int i = 0; i<vehicleList.length; i++){
                                          if(vehicleList[i]['vehicle_number'] == value){
                                            vehicleID = vehicleList[i]['vehicle_id'];
                                          }
                                        }

                                      },
                                      selectedItem: value2,
                                      optional: true,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          widthBox20(),

                          /// Date field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TextDecorationClass().heading1('Date'),
                                  const Text("  dd-mm-yyyy" , style: TextStyle(fontSize: 12, color: Colors.grey),)
                                ],
                              ),
                              DateFieldWidget(dayController: dayController, monthController: monthController, yearController: yearController, dateControllerApi: dateControllerApi),
                              // SizedBox(
                              //   width:170,
                              //   height: 35,
                              //   child:
                              //   TextFormField(
                              //     readOnly: true,
                              //     controller: dateControllerUI,
                              //     decoration: UiDecoration().dateFieldDecoration('Date'),
                              //     validator: (value) {
                              //       if (value == null || value.isEmpty) {
                              //         return 'Date Field Is Required';
                              //       }
                              //       return null;
                              //     },
                              //     onTap: (){
                              //       UiDecoration().showDatePickerDecoration(context).then((value){
                              //         setStateMounted(() {
                              //           String month = value.month.toString().padLeft(2, '0');
                              //           String day = value.day.toString().padLeft(2, '0');
                              //           dateControllerUI.text = "$day-$month-${value.year}";
                              //           dateControllerApi.text = "${value.year}-$month-$day";
                              //         });
                              //       });
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                      heightBox20(),

                      /// Cr
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// Cr
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1(''),
                              SizedBox(
                                width: 50,
                                child:
                                Container(
                                  height: 35,
                                  padding: const EdgeInsets.all(0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: ThemeColors.whiteColor,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: ThemeColors.textFormFieldColor)
                                  ),
                                  child: Text(
                                    'Cr.',
                                    style: TextStyle(color: ThemeColors.grey700),
                                  ),
                                ),

                              ),
                            ],
                          ),
                          widthBox20(),

                          /// Opp Ledger Dropdown
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1('Cash / Bank'),
                              SizedBox(
                                width: 400,
                                child:
                                ValueListenableBuilder(
                                  valueListenable: oppLedgerValue,
                                  builder: (context, value2, child) {
                                    return SearchDropdownWidget(
                                        dropdownList: ledgerTitleList,
                                        hintText: "Cash/Bank",
                                        onChanged: (value) {
                                          oppLedgerValue.value = value!;

                                          // getting opp ledger ID
                                          for(int i = 0; i<ledgerList.length; i++){
                                            if(ledgerList[i]['ledger_title'] == value){
                                              oppLedgerID = ledgerList[i]['ledger_id'];
                                            }
                                          }

                                        },
                                        selectedItem: value2);
                                  },
                                ),
                              ),
                            ],
                          ),
                          widthBox20(),

                          /// Total Amount
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1('Total Amount'),
                              Container(
                                width: 150,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(color: ThemeColors.textFormFieldColor),
                                    borderRadius: BorderRadius.circular(3)
                                ),
                                child: TextFormField(
                                  controller:  totalList.isEmpty ? amountController :  totalPayment,
                                  keyboardType: TextInputType.number,
                                  readOnly: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(8)
                                  ],
                                  decoration: UiDecoration()
                                      .textFieldDecoration('', Colors.transparent),
                                ),
                              ),
                            ],
                          ),

                          /// Date field
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     // Row(
                          //     //   children: [
                          //     //     TextDecoration().heading1('Date'),
                          //     //     const Text("  dd-mm-yyyy" , style: TextStyle(fontSize: 12, color: Colors.grey),)
                          //     //   ],
                          //     // ),
                          //     // DateFieldWidget(dayController: dayController, monthController: monthController, yearController: yearController, dateControllerApi: dateControllerApi),
                          //     // SizedBox(
                          //     //   width:170,
                          //     //   height: 35,
                          //     //   child:
                          //     //   TextFormField(
                          //     //     readOnly: true,
                          //     //     controller: dateControllerUI,
                          //     //     decoration: UiDecoration().dateFieldDecoration('Date'),
                          //     //     validator: (value) {
                          //     //       if (value == null || value.isEmpty) {
                          //     //         return 'Date Field Is Required';
                          //     //       }
                          //     //       return null;
                          //     //     },
                          //     //     onTap: (){
                          //     //       UiDecoration().showDatePickerDecoration(context).then((value){
                          //     //         setStateMounted(() {
                          //     //           String month = value.month.toString().padLeft(2, '0');
                          //     //           String day = value.day.toString().padLeft(2, '0');
                          //     //           dateControllerUI.text = "$day-$month-${value.year}";
                          //     //           dateControllerApi.text = "${value.year}-$month-$day";
                          //     //         });
                          //     //       });
                          //     //     },
                          //     //   ),
                          //     // ),
                          //   ],
                          // ),

                        ],
                      ),
                      heightBox20(),

                      /// Dr
                      Form(
                        key: _formKey2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // DR
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDecorationClass().heading1(''),
                                SizedBox(
                                  width: 50,
                                  child:
                                  Container(
                                    height: 35,
                                    padding: const EdgeInsets.all(0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: ThemeColors.whiteColor,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: ThemeColors.textFormFieldColor)
                                    ),
                                    child: Text(
                                      'Dr.',
                                      style: TextStyle(color: ThemeColors.grey700),
                                    ),
                                  ),

                                ),
                              ],
                            ),
                            widthBox20(),

                            // Select Account Ledger
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDecorationClass().heading1('Select Account'),
                                SizedBox(
                                  width: 350,
                                  child:
                                  // ledger dropdown
                                  ValueListenableBuilder(
                                    valueListenable: ledgerValue,
                                    builder: (context, value2, child) =>
                                        SearchDropdownWidget(
                                          dropdownList: ledgerTitleList,
                                          hintText: "Select Ledger",
                                          onChanged: (value) {
                                            ledgerValue.value = value!;

                                            // getting ledger ID
                                            for(int i = 0; i<ledgerList.length; i++){
                                              if(ledgerList[i]['ledger_title'] == value){
                                                ledgerID = ledgerList[i]['ledger_id'];
                                              }
                                            }

                                          },
                                          selectedItem: value2,),

                                  ),
                                ),
                              ],
                            ),
                            widthBox20(),

                            /// Select Vehicle
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     TextDecoration().heading1('Select Vehicle (Optional)'),
                            //     SizedBox(
                            //       width: 200,
                            //       child: ValueListenableBuilder(
                            //         valueListenable: vehicleNumberValue,
                            //         builder: (context, value2, child) {
                            //           return SearchDropdownWidget(
                            //             dropdownList: vehicleNumberList,
                            //             hintText: "Select Vehicle",
                            //             onChanged: (value) {
                            //
                            //               vehicleNumberValue.value = value!;
                            //
                            //               // for vehicle id
                            //               for(int i = 0; i<vehicleList.length; i++){
                            //                 if(vehicleList[i]['vehicle_number'] == value){
                            //                   vehicleID = vehicleList[i]['vehicle_id'];
                            //                 }
                            //               }
                            //
                            //             },
                            //             selectedItem: value2,
                            //             optional: true,
                            //           );
                            //         },
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // widthBox20(),

                            // Amount
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDecorationClass().heading1('Amount'),
                                SizedBox(
                                  width: 147,
                                  child: TextFormField(
                                    focusNode: focusNode1,
                                    controller: amountController,
                                    decoration: UiDecoration().outlineTextFieldDecoration('Amount', ThemeColors.primary),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        AlertBoxes.flushBarErrorMessage("Enter Amount", context);
                                        return 'Enter Amount';
                                      }
                                      return null;
                                    },
                                  ),
                                )
                              ],
                            ),
                            widthBox20(),

                            // add button
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDecorationClass().heading1(''),
                                Container(
                                  height: 33,
                                  width: 33,
                                  padding: const EdgeInsets.only(bottom: 0),
                                  decoration: BoxDecoration(
                                      color: ThemeColors.primaryColor,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        if( _formKey2.currentState!.validate()){

                                          setStateMounted(() {
                                            // to show in dataTable
                                            totalList.add({
                                              'employee_name' : employeeNameValue.value,
                                              'vehicle_number' : vehicleNumberValue.value,
                                              'account' : ledgerValue.value,
                                              'amount' : amountController.text,
                                            });

                                            totalAmount = int.parse(totalList[totalList.length-1]['amount'])+totalAmount;

                                            // for api
                                            idAndAmountList.add({
                                              'amount': amountController.text,
                                              'ledger_id': ledgerID.toString(),
                                              'vehicle_id': vehicleID.toString()
                                            });

                                          });
                                          amountController.clear();
                                          vehicleNumberValue.value = "";
                                          employeeNameValue.value = "";
                                        }
                                      },
                                      icon: const Icon(CupertinoIcons.add,size: 20,)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      heightBox20(),

                      totalList.isEmpty?const SizedBox():SizedBox(
                        width: 650,
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {
                                PointerDeviceKind.mouse,
                                PointerDeviceKind.trackpad,
                                PointerDeviceKind.touch
                              }),
                          child: SingleChildScrollView(
                            child: PaginatedDataTable(
                              showFirstLastButtons: false,
                              rowsPerPage: totalList.isEmpty?1:totalList.length,
                              source: paymentList,
                              columnSpacing: 0,
                              columns: const [
                                DataColumn(label: Text('Vehicle Number')),
                                DataColumn(label: Text('Account')),
                                DataColumn(label: Text('Amount')),
                                DataColumn(label: Text('')),
                              ],
                            ),
                          ),
                        ),
                      ),
                      totalList.isEmpty?const SizedBox():heightBox10(),

                      // Narration
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 646,
                            height: 100,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: ThemeColors.textFormFieldColor),
                                  borderRadius: BorderRadius.circular(3)
                              ),
                              child: TextFormField(
                                controller: narrationController,
                                decoration: UiDecoration().longtextFieldDecoration(
                                    'Narration', ThemeColors.primaryColor),
                                maxLines: 4,
                              ),
                            ),
                          ),


                        ],
                      ),
                      heightBox20(),

                      // Save Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Payment Button
                          freshLoad == 1 ? const Center(child: CircularProgressIndicator(color: ThemeColors.primaryColor),) : ElevatedButton(
                            style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor, 655.0, 50.0),
                            onPressed: () {
                              setStateMounted(() {

                                /// validating form
                                if( totalList.isNotEmpty && _formKey.currentState!.validate() || _formKey2.currentState!.validate() && _formKey.currentState!.validate()){
                                  _formKey.currentState!.save();

                                  if(totalList.isEmpty && amountController.text.isEmpty && totalPayment.text.isEmpty){
                                    AlertBoxes.flushBarErrorMessage('Enter Amount', context);
                                  }
                                  else {
                                    setStateMounted(() {
                                      // for api
                                      totalList.isEmpty ? idAndAmountList.add({
                                        'amount': amountController.text,
                                        'ledger_id': ledgerID.toString(),
                                        'vehicle_id': vehicleID.toString()
                                      }) : null ;

                                      print('qwd: $idAndAmountList');
                                      // API
                                      transactionApiFunc();

                                    });
                                  }
                                }

                              });
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// API
  Future transactionApi() async {

    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var url = Uri.parse("${GlobalVariable.baseURL}Account/PayableTransaction");

    var body = {
      'ledger_id': oppLedgerID.toString(),
      'opp_ledger_id': jsonEncode(idAndAmountList), // sending multiple {"ledger_id" and "amount" and "vehicle_id"} in "idAndAmountList"
      'total_amount':totalAmount.toString(),
      'entry_by': GlobalVariable.entryBy.toString(),
      'remark': narrationController.text,
      'date' : dateControllerUI.text,
      'voucher_type' : 'Expense'
    };
    print('nnnnnn: $idAndAmountList');

    var response = await http.post(url , headers: headers , body: body);

    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }

}

class PaymentList extends DataTableSource {
  Function setState;
  PaymentList(this.setState);

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(totalList[index]['vehicle_number'].toString())),
      DataCell(Text(totalList[index]['account'].toString())),
      DataCell(Text(totalList[index]['amount'].toString())),
      DataCell(UiDecoration().actionButton( ThemeColors.deleteColor,
          IconButton(padding: const EdgeInsets.all(0),onPressed: () {
            setState((){
              totalAmount = totalAmount - int.parse(totalList[index]['amount']);
              totalList.removeAt(index);
            });
            // print('amount ${total[index]['amount']}');
          }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => totalList.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}

