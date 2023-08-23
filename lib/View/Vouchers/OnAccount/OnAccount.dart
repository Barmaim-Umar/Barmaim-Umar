import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:http/http.dart' as http;

class OnAccount extends StatefulWidget {
  const OnAccount({Key? key}) : super(key: key);

  @override
  State<OnAccount> createState() => _OnAccountState();
}

List<String> vehicle = [];
List<String> type = ['Dr', 'Cr'];
List<String> ledger = [];
int totalPayment = 0;
class _OnAccountState extends State<OnAccount> {

  TextEditingController dayController = TextEditingController(text: GlobalVariable.displayDate.day.toString().padLeft(2,'0'));
  TextEditingController monthController = TextEditingController(text: GlobalVariable.displayDate.month.toString().padLeft(2,'0'));
  TextEditingController yearController = TextEditingController(text: GlobalVariable.displayDate.year.toString());

  ValueNotifier<String> vehicleDropdown = ValueNotifier('');
  ValueNotifier<String> accountDropdown = ValueNotifier('');
  ValueNotifier<String> ledgerDropdown = ValueNotifier('');

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController deductionTotalAmount = TextEditingController();
  TextEditingController narration = TextEditingController();
  List onAccountList = [];
  ScrollController scrollController = ScrollController();
  TextEditingController dateApi =TextEditingController();
  TextEditingController dateUi =TextEditingController();
  FocusNode focusNode1 = FocusNode();
  List vehicleList = [];
  List ledgerList = [];
  List addTransactionList = [];
  int freshLoad = 0;
  var vehicleId;
  var ledgerId;
  var oppLedgerId;

  createOnAccountTransactionApiFunc(){
    setStateMounted(() {freshLoad = 1;});
    createOnAccountTransactionApi().then((value) {
      var info = jsonDecode(value);
      if(info['success']==true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
        addTransactionList.clear();
        onAccountList.clear();
        totalPayment = 0;
        accountDropdown.value='';
        vehicleDropdown.value = '';
        ledgerDropdown.value = '';
        amount.clear();
        narration.text ='';
        setStateMounted(() { freshLoad = 0; });
      }
      else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() { freshLoad = 0; });
      }
    });
  }

  vehicleDropdownApiFunc() {
    setStateMounted(() {
      freshLoad = 1;
    });
    vehicleDropDownApi().then(
          (value) {
        var info = jsonDecode(value);
        if (info['success'].toString() == 'true') {
          vehicleList.clear();
          vehicle.clear();
          for (int i = 0; i < info['data'].length; i++) {
            vehicleList.add(info['data'][i]);
            vehicle.add(info['data'][i]['vehicle_number']);
          }
          setStateMounted(() {
            freshLoad = 0;
          });
        } else {
          setStateMounted(() {
            freshLoad = 1;
          });
        }
      },
    );
  }

  ledgerDropdownApiFunc() {
    setStateMounted(() {
      freshLoad = 1;
    });
    ledgerDropDownApi().then(
          (value) {
        var info = jsonDecode(value);
        if (info['success'].toString() == 'true') {
          ledger.clear();
          ledgerList.clear();
          for (int i = 0; i < info['data'].length; i++) {
            ledgerList.add(info['data'][i]);
            ledger.add(info['data'][i]['ledger_title']);
          }
          setState(() {
            freshLoad = 0;
          });
        } else {
          setState(() {
            freshLoad = 1;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    vehicleDropdownApiFunc();
    totalPayment = 0;
    ledgerDropdownApiFunc();
    UiDecoration().initialDateApi(setState, dateApi);
    UiDecoration().initialDateUi(setState, dateUi);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController totalAmount = TextEditingController(text: totalPayment.toString());
    return Scaffold(
      appBar: UiDecoration.appBar('On Account'),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 900,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: UiDecoration().formDecoration(color: const Color(0xffffffcc)),
            child: Form(
              key: _formKey,
              child: FocusScope(
                child: FocusTraversalGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Cr
                                  Expanded(
                                    flex: 0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextDecorationClass().heading1(''),
                                        Container(
                                          width: 40,
                                          height: 34,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(3),
                                              border: Border.all(color: Colors.grey.shade400)
                                          ),
                                          child: const Text('Cr',style: TextStyle(fontSize: 16),),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),

                                  // Vehicles(optional)
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextDecorationClass().heading1('Vehicles (optional)'),
                                        Container(
                                          color: Colors.white,
                                          child: ValueListenableBuilder(
                                            valueListenable: vehicleDropdown,
                                            builder: (BuildContext context, value, Widget? child) {

                                              return SearchDropdownWidget(
                                                dropdownList: vehicle,
                                                hintText: 'Select Vehicle',
                                                selectedItem: value,
                                                onChanged: (value2) {
                                                  vehicleDropdown.value = value2!;
                                                  getVehicleId();
                                                },
                                                optional: true,
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),

                                  // Ledger
                                  Form(
                                    key: _formKey2,
                                    child: Expanded(
                                      child: Row(
                                        children: [
                                          // ledger Dropdown
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextDecorationClass().heading1('Ledger'),
                                                ValueListenableBuilder(
                                                  valueListenable: ledgerDropdown,
                                                  builder: (BuildContext context, value, Widget? child) {
                                                    return SearchDropdownWidget(
                                                      dropdownList: ledger,
                                                      hintText: 'Select Ledger',
                                                      selectedItem: ledgerDropdown.value,
                                                      onChanged:(value2) {
                                                        ledgerDropdown.value = value2!;
                                                        getLedgerId();
                                                      },);
                                                  },
                                                )
                                              ],
                                            ),
                                          ),

                                          const SizedBox(width: 20),

                                          // Amount
                                          Expanded(flex: 1,
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
                                                    if (value == null || value.isEmpty) {
                                                      AlertBoxes.flushBarErrorMessage("Enter Amount", context);
                                                      return 'Enter Amount';
                                                    }
                                                    return null;
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 20),  
                                        ],
                                      ),
                                    ),
                                  ),


                                  // add button
                                  Column(
                                    children: [
                                      TextDecorationClass().heading1(''),
                                      Container(
                                        height: 33,
                                        width: 33,
                                        padding: const EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                            color: ThemeColors.primaryColor,
                                            borderRadius: BorderRadius.circular(3)),
                                        child: IconButton(
                                            color: Colors.white,
                                            onPressed: () {

                                              if(_formKey2.currentState!.validate()){

                                                setStateMounted(() {
                                                  // to show in datatable
                                                  addTransactionList.add({
                                                    'vehicle':vehicleDropdown.value,
                                                    'ledger': ledgerDropdown.value,
                                                    'amount': amount.text
                                                  });

                                                  // for api
                                                  onAccountList.add({
                                                    'vehicle_id':vehicleId,
                                                    "amount":amount.text,
                                                    'opp_ledger_id': ledgerId
                                                  });
                                                  totalPayment = int.parse(onAccountList[onAccountList.length-1]['amount'] )+ totalPayment;
                                                  vehicleDropdown.value = '';
                                                  ledgerDropdown.value = '';
                                                  amount.clear();
                                                });

                                              }

                                            },
                                            icon: const Icon(CupertinoIcons.add,size: 20,)),
                                      ),
                                    ],
                                  ),

                                  // const Spacer(),
                                ],
                              ),
                              const SizedBox(height: 10),

                              /// Bill List Divider
                              addTransactionList.isEmpty
                                  ? const SizedBox()
                                  : Row(
                                children: const [
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Text(
                                    "Bill List",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(flex: 12, child: Divider()),
                                  Spacer()
                                ],
                              ),
                              ListView.builder(
                                controller: scrollController,
                                itemCount: addTransactionList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      addTransactionList[index]
                                      ["vehicle"]
                                          .toString()==''?const SizedBox():Expanded(
                                          flex: 2,
                                          child: UiDecoration().addMore(
                                              addTransactionList[index]
                                              ["vehicle"]
                                                  .toString())),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: UiDecoration().addMore(
                                              addTransactionList[index]["ledger"]
                                                  .toString())),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: UiDecoration().addMore(
                                              addTransactionList[index]
                                              ["amount"]
                                                  .toString())),
                                      const SizedBox(
                                        width: 50,
                                      ),

                                      // delete button
                                      Container(
                                        decoration: BoxDecoration(
                                            color: ThemeColors.darkRedColor,
                                            borderRadius: BorderRadius.circular(5)),
                                        child: IconButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                totalPayment = totalPayment - int.parse(onAccountList[index]['amount']);
                                                onAccountList.removeAt(index);
                                                addTransactionList .removeAt(index);
                                              });
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.delete,
                                              size: 20,
                                            )),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 15,),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 00),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Dr
                                Expanded(
                                  flex: 0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextDecorationClass().heading1(''),
                                      Container(
                                        width: 40,
                                        height: 34,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: Colors.grey.shade400)
                                        ),
                                        child: const Text('Dr',style: TextStyle(fontSize: 16),),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 30),
                                // Cash/Bank
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextDecorationClass().heading1('Cash/Bank'),
                                      ValueListenableBuilder(
                                        valueListenable: accountDropdown,
                                        builder: (BuildContext context, value, Widget? child) {
                                          return SearchDropdownWidget(
                                            dropdownList: ledger,
                                            hintText: 'Cash/Bank',
                                            selectedItem: accountDropdown.value,
                                            onChanged: (value) {
                                              accountDropdown.value = value!;
                                              getOppLedgerId();
                                            },);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 30),
                                // Total Amount
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextDecorationClass().heading1('Total Amount'),
                                        TextFormField(
                                          controller: addTransactionList.isEmpty ? amount : totalAmount,
                                          readOnly: true,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          decoration: UiDecoration()
                                              .outlineTextFieldDecoration(
                                              "0", ThemeColors.primaryColor),
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Narration
                                Expanded(
                                  flex: 4 ,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextDecorationClass().heading1('Narration'),
                                      TextFormField(
                                        controller: narration,
                                        maxLines: 3,
                                        decoration: UiDecoration().longtextFieldDecoration2('Narration', ThemeColors.primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                // Date
                                Expanded(
                                  flex: 1,
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
                                      //   maxLines: 1,
                                      //   readOnly: true,
                                      //   controller: dateUi,
                                      //   decoration: UiDecoration().outlineTextFieldDecoration("Date", Colors.grey),
                                      //   validator: (value) {
                                      //     if (value == null || value.isEmpty) {
                                      //       return 'Date Field Is Required';
                                      //     }
                                      //     return null;
                                      //   },
                                      //   onTap: (){
                                      //     UiDecoration().showDatePickerDecoration(context).then((value){
                                      //       setState(() {
                                      //         String month = value.month.toString().padLeft(2, '0');
                                      //         String day = value.day.toString().padLeft(2, '0');
                                      //         dateApi.text = "${value.year}-$month-$day";
                                      //         dateUi.text = "$day-$month-${value.year}";
                                      //       });
                                      //     });
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 48.0,left: 20,right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Reset Button
                            ElevatedButton(
                              style: ButtonStyles.smallButton(Colors.grey, Colors.white),
                              onPressed: (){
                                setState(() {
                                  narration.text = '';
                                  vehicleDropdown.value = '';
                                  ledgerDropdown.value = '';
                                  accountDropdown.value = '';
                                  totalPayment = 0;
                                  onAccountList.clear();
                                  addTransactionList.clear();
                                  _formKey.currentState!.reset();
                                });
                              },
                              child: const Text('Reset'),
                            ),

                            // Save Button
                            freshLoad == 1 ? const Center(child: CircularProgressIndicator(color: ThemeColors.primaryColor),) : ElevatedButton(
                              style: ButtonStyles.smallButton(ThemeColors.primaryColor, Colors.white),
                              onPressed: (){

                                if(addTransactionList.isNotEmpty && _formKey.currentState!.validate() ||  _formKey2.currentState!.validate() && _formKey.currentState!.validate()){
                                  _formKey.currentState!.save();

                                  if(addTransactionList.isEmpty && amount.text.isEmpty  && totalAmount.text.isEmpty ){
                                    AlertBoxes.flushBarErrorMessage('Enter Amount', context);
                                  }
                                  else {

                                    setStateMounted(() {
                                      // onAccountList.clear();
                                      // for api
                                      addTransactionList.isEmpty ? onAccountList.add({
                                        'vehicle_id':vehicleId.toString(),
                                        'amount': amount.text,
                                        'opp_ledger_id': ledgerId.toString(),
                                      }) : null ;
                                      createOnAccountTransactionApiFunc();
                                      print(onAccountList);
                                    });
                                  }

                                }


                              },
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      )
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

  Future createOnAccountTransactionApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Account/OnAccountTransaction');
    var body = {
      'ledger_id': oppLedgerId.toString(),
      'opp_ledger_id': jsonEncode(onAccountList).toString(),
      'entry_by': GlobalVariable.entryBy,
      'remark': narration.text,
      'date': dateApi.text,
      // 'vehicle_id': vehicleId.toString()
    };
    var response = await http.post(url,headers: headers,body: body);
    return response.body.toString();
  }

  getVehicleId() {
    for (int i = 0; i < vehicleList.length; i++) {
      if (vehicleDropdown.value == vehicleList[i]['vehicle_number']) {
        vehicleId = vehicleList[i]['vehicle_id'];
      }
    }
  }

  vehicleDropDownApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse("${GlobalVariable.baseURL}Vehicle/VehicleFetch");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  getLedgerId() {
    for (int i = 0; i < ledgerList.length; i++) {
      if (ledgerDropdown.value == ledgerList[i]['ledger_title']) {
        ledgerId = ledgerList[i]['ledger_id'];
      }
    }
  }

  getOppLedgerId(){
    for (int i = 0; i < ledgerList.length; i++) {
      if (accountDropdown.value == ledgerList[i]['ledger_title']) {
        oppLedgerId = ledgerList[i]['ledger_id'];
      }
    }
  }

  ledgerDropDownApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse("${GlobalVariable.baseURL}Account/LedgersFetch");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }
}
