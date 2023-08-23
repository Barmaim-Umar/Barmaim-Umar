import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class PayableReport extends StatefulWidget {
  const PayableReport({Key? key}) : super(key: key);

  @override
  State<PayableReport> createState() => _PayableReportState();
}


List<String> entriesDropdownList = ["10" ,"20" ,"30" ,"40"];
List<String> selectCashBankList = ["Bank1" , "Bank2" , "Bank3"];

class _PayableReportState extends State<PayableReport> with Utility{

  List selectedRows = [];
  List selectedPayableIdsList = [];
  int selectedPayableId = -1;
  List selectedLedgerIds = [];
  List<TextEditingController> amountControllerList = [];
  ValueNotifier<String> entriesDropdownValue = ValueNotifier(entriesDropdownList.first);
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController paymentDateUI = TextEditingController();
  TextEditingController paymentDateApi = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String selectedItem1 = '';
  String selectedItem3 = '';
  String selectedItem4 = '';
  String selectedItem5 = '';
  int freshLoad = 0;
  List payableTableList = [];
  List payListPayableIdAndAmount = [];
  double totalAmount = 0;
  // ledger list Dropdown
  String? ledgerID ;
  String? oppLedgerID;
  List ledgerList = [];
  List payList = [];
  List<String> ledgerTitleList = [];
  ValueNotifier<String> ledgerDropdownValue = ValueNotifier('');
  ValueNotifier<String> ledgerDropdownValue2 = ValueNotifier('');

  // using to export data --> pdf , excel , etc
  List data = [];
  List<List<dynamic>> exportData = [];

  // API Func
  payableListApiFunc(){
    setStateMounted(() {
      freshLoad = 1;
    });
    payableListApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        payableTableList.clear();
        payableTableList.addAll(info['data']);
        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.totalPages = info['total_pages'];
        GlobalVariable.next = info['next'];
        GlobalVariable.prev = info['prev'];
        setStateMounted(() {
          freshLoad = 0;
          print("mhtrf: ${payableTableList}");
        });
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() {
          freshLoad = 0;
        });
      }
    });

    // Export Data
    exportDataApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        data.clear();
        exportData.clear();
        data.addAll(info['data']);
        setStateMounted(() {
          freshLoad = 0;
        });
      }else{
        setStateMounted(() {
          freshLoad = 0;
        });
      }
    });
  }

  ledgerFetchApiFunc(){
    ServiceWrapper().ledgerFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        ledgerList.addAll(info['data']);

        // adding ledger title in ledgerTitleList
        for(int i=0; i<info['data'].length; i++){
          ledgerTitleList.add(info['data'][i]['ledger_title']);
        }

      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  getPayableLedgersApiFunc(){
    getPayableLedgersApi().then((value) {
      var info = jsonDecode(value);
      if(info['success']==true){
        payList.clear();
        payList.addAll(info['data']);
        amountControllerList.clear();
        for(int i=0; i<info['data'].length; i++){
        amountControllerList.add(TextEditingController(text: info['data'][i]['paid_amount'].toString() == "0" ? "0" : info['data'][i]['paid_amount'].toString()));
        }

        showPaymentPopup();
      }
      else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  payableHistoryTransactionApiFunc(){
    payableHistoryTransactionApi().then((value) {
      var info = jsonDecode(value);
      print('payableInfo: $info');
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
        payableListApiFunc();
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        payableListApiFunc();
      }
    });
  }

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    GlobalVariable.totalRecords = 0;
    ledgerFetchApiFunc(); // for dropdown filter
    payableListApiFunc(); // datatable
    selectedRows = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Payable Reports"),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              alignment: Alignment.centerLeft,
              child: TextDecorationClass().heading('Payable Reports'),
            ),

            const Divider(),

            // dropdown | Select Ledger | From date | To Date
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // entries dropdown
                  SizedBox(
                    width: 80,
                    child: ValueListenableBuilder(
                      valueListenable: entriesDropdownValue,
                      builder: (context, value2, child) =>
                          SearchDropdownWidget(
                            dropdownList: entriesDropdownList,
                            hintText: "10",
                            onChanged: (value) {
                              entriesDropdownValue.value = value!;
                              payableListApiFunc();
                            },
                            selectedItem: value2 ,
                            showSearchBox: false,
                            maxHeight: 200,
                          ),
                    ),
                  ),
                  const Text(' entries'),
                  widthBox20(),
                  const Spacer(),

                  // Select Ledger / Customer
                  SizedBox(
                    width: 300,
                    child: ValueListenableBuilder(
                      valueListenable: ledgerDropdownValue,
                      builder: (context, value2, child) =>
                          SearchDropdownWidget(
                            dropdownList: ledgerTitleList,
                            hintText: "Select Ledger",
                            onChanged: (value) {
                              ledgerDropdownValue.value = value!;

                              // getting ledger id
                              for(int i=0; i<ledgerList.length; i++){
                                if(ledgerDropdownValue.value == ledgerList[i]['ledger_title']){
                                  ledgerID = ledgerList[i]['ledger_id'].toString();
                                }
                              }
                            },
                            selectedItem: value2,
                            showSearchBox: true,
                          ),
                    ),
                  ),
                  const SizedBox(width: 30,),

                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("From : "),
                            DateFieldWidget2(
                                dayController: dayControllerFrom,
                                monthController: monthControllerFrom,
                                yearController: yearControllerFrom,
                                dateControllerApi: fromDateApi
                            ),
                          ],
                        ),
                        widthBox20(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("To : "),
                            Column(
                              children: [
                                DateFieldWidget2(
                                    dayController: dayControllerTo,
                                    monthController: monthControllerTo,
                                    yearController: yearControllerTo,
                                    dateControllerApi: toDateApi
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  widthBox30(),
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor,100.0,42.0),
                    onPressed: () {
                      payableListApiFunc();
                    },
                    child: const Text("Filter"),
                  ),
                ],
              ),
            ),

            // buttons | Search
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Wrap(
                    runSpacing: 5,
                    // spacing: 0,
                    children: [
                      // BStyles().button('CSV', 'Export to CSV', "assets/csv2.png"),
                      // const SizedBox(width: 10),
                      BStyles().button('Excel', 'Export to Excel', "assets/excel.png", onPressed: () {
                        setState(() {
                          addDataToExport();
                        });
                        UiDecoration().excelFunc(exportData);
                      },),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button('PDF', 'Export to PDF', "assets/pdf.png", onPressed: () {
                        setState(() {
                          addDataToExport();
                        });
                        UiDecoration().pdfFunc(exportData);
                      },),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button('Print', 'Print', "assets/print.png", onPressed: () {
                        setState(() {
                          addDataToExport();
                        });
                        UiDecoration().generatePrintDocument(exportData);
                      },),
                    ],
                  ),
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search '),
                  // Search
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                        controller: searchController,
                        decoration:
                        UiDecoration().outlineTextFieldDecoration('Search',ThemeColors.primaryColor)
                    ),
                  ),
                  const SizedBox(width: 10,)
                ],
              ),
            ),

            const SizedBox(height: 20,),

            // DataTable
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                        child:
                        SizedBox(
                          width: double.maxFinite,
                          child: freshLoad == 1 ? const Center(child: CircularProgressIndicator()) : DataTable(
                              showCheckboxColumn: true,
                              columns: [
                                const DataColumn(label: Text('Date')),
                                const DataColumn(label: Text('Payable ID.')),
                                const DataColumn(label: Text('Voucher Type')),
                                const DataColumn(label: Text('Ledger')),
                                const DataColumn(label: Text('Amount')),
                                const DataColumn(label: Text('Paid')),
                                const DataColumn(label: Text('Balance')),
                                DataColumn(label: Row(
                                  children: [
                                    const Text('Action'),
                                    const SizedBox(width: 10,),
                                    // Pay Button
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                        onPressed: () {
                                        if(selectedPayableIdsList.isEmpty || selectedPayableId < 1){
                                          AlertBoxes.flushBarErrorMessage('Select Ledger', context);
                                        }
                                        else if(checkSameLedgersSelected()){
                                          getPayableLedgersApiFunc();
                                        } else{
                                          AlertBoxes.flushBarErrorMessage('Select Same Ledger', context);
                                        }
                                      },
                                      icon: const Icon(Icons.currency_rupee),
                                      label: const Text("Pay"),
                                    )
                                  ],
                                )),
                              ],
                              rows: List.generate(payableTableList.length, (index) {
                                double amount = double.parse(payableTableList[index]['total_amount'].toString() == '' || payableTableList[index]['total_amount'] == null ? '0' : payableTableList[index]['total_amount'].toString());
                                double paid = double.parse(payableTableList[index]['paid_amount'].toString() == '' || payableTableList[index]['paid_amount'] == null ? '0' : payableTableList[index]['paid_amount'].toString());
                                return DataRow(
                                  // selected checkbox
                                    selected: selectedRows.contains(index),
                                    // check \ uncheck
                                    onSelectChanged: (value) {
                                      onSelectedRow(value!, index);
                                    },
                                    color: MaterialStatePropertyAll(index == 0 || index % 2 == 0 ? ThemeColors.tableRowColor : Colors.white),
                                    cells: [
                                      DataCell(Text(payableTableList[index]['created_date'].toString())),
                                      DataCell(Text(payableTableList[index]['payable_id'].toString())),
                                      DataCell(Text(payableTableList[index]['voucher_type'].toString())),
                                      DataCell(Text(payableTableList[index]['ledger_title'] ?? '-')),
                                      DataCell(Text(payableTableList[index]['total_amount'].toString())),
                                      DataCell(Text(payableTableList[index]['paid_amount'].toString())),
                                      DataCell(Text('${amount-paid}')),
                                      DataCell(
                                        // Details Button
                                          ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                // padding: const EdgeInsets.only(left: 3 , right: 3),
                                                  backgroundColor: ThemeColors.primary,
                                                  minimumSize: const Size(30, 35)
                                              ),
                                              onPressed: () {

                                              }, icon: const Icon(Icons.info_outlined , size: 17,), label: const Text("Details"))),
                                    ]);
                              })
                          ),
                        )
                    )
                  ],
                ),),),

            /// Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Text("Total Records: ${GlobalVariable.totalRecords}"),

                const SizedBox(width: 100,),

                // First Page Button
                IconButton(onPressed: !GlobalVariable.prev ? null : () {
                  setState(() {
                    GlobalVariable.currentPage = 1;
                    payableListApiFunc();
                  });

                }, icon: const Icon(Icons.first_page)),

                // Prev Button
                IconButton(
                    onPressed: GlobalVariable.prev == false ? null : () {
                      setState(() {
                        GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                        payableListApiFunc();
                      });
                    }, icon: const Icon(Icons.chevron_left)),

                const SizedBox(width: 30,),

                // Next Button
                IconButton  (
                    onPressed: GlobalVariable.next == false ? null : () {
                      setState(() {
                        GlobalVariable.currentPage++;
                        payableListApiFunc();
                      });
                    }, icon: const Icon(Icons.chevron_right)),

                // Last Page Button
                IconButton(onPressed: !GlobalVariable.next ? null : () {
                  setState(() {
                    GlobalVariable.currentPage = GlobalVariable.totalPages;
                    payableListApiFunc();
                  });
                }, icon: const Icon(Icons.last_page)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // for checkbox
  onSelectedRow(bool selected , int index) {
    setState(() {
      if(selected){
        selectedRows.add(index);
        selectedPayableIdsList.add(payableTableList[index]['payable_id']);
        selectedPayableId = payableTableList[index]['payable_id'];
      }else{
        selectedRows.remove(index);
        selectedPayableIdsList.remove(payableTableList[index]['payable_id']);
        // selectedPayableId = -1;
      }
    });
  }

  // Pay Button Popup
  showPaymentPopup(){
    totalAmount = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              title:  Container(
                height: 70,
                decoration: BoxDecoration(
                    color: const Color(0xfffd96e7),
                    borderRadius: BorderRadius.circular(4)
                ),
                child: const Padding(
                  padding:  EdgeInsets.all(12.0),
                  child:  Text("Payment Voucher" , style: TextStyle(fontSize: 25),),
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      // Selected List
                      selectedRows.isEmpty ?
                      const Center(child: Text("Please Select Ledger" , style: TextStyle(color: ThemeColors.darkRedColor),),)
                          : SizedBox(
                        width: 400,
                        height: 400,
                        child: ListView.builder(
                          itemCount: payList.length + 1,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index == payList.length) {
                              // This is the widget that will be shown at the end of the list.
                              return Text('Total Amount: $totalAmount');
                            } else {
                              // This is the rest of the list payList.
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // ledger name
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(3)
                                      ),
                                      child: Text('${payList[index]['ledger_title']}'),
                                    ),
                                  ),

                                  const SizedBox(width: 20,),

                                  // Amount
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 1,
                                      controller: amountControllerList[index],
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      validator: (value) {
                                        if(value == null || value == ''){
                                          AlertBoxes.flushBarErrorMessage("Please fill Amount", context);
                                          return '';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setTotalAmount(index);
                                        setState(() {});
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                          isDense: true,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey.shade300)
                                          ),
                                        enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                            )
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 20,),

                                  // Delete Button
                                  Container(
                                    height: 28,
                                    width:28,
                                    margin: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(color: ThemeColors.deleteColor, borderRadius: BorderRadius.circular(5)),
                                    child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                                      showDialog(context: context, builder: (context) {
                                        return
                                          AlertDialog(
                                            title: const Text("Are you sure you want to delete"),
                                            actions: [
                                              TextButton(onPressed: () {
                                                Navigator.pop(context);
                                              }, child: const Text("Cancel")),

                                              TextButton(onPressed: () {
                                                setState(() {
                                                  selectedRows.remove(selectedRows[index]);
                                                });
                                                Navigator.pop(context);
                                              }, child: const Text("Delete"))
                                            ],
                                          );
                                      },
                                      );
                                    },
                                        icon: const Icon(Icons.delete, size: 20, color: Colors.white,)),
                                  ),
                                ],
                              );
                            }

                            // return
                            //   Row(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       // Payable ID
                            //       Expanded(
                            //         flex: 2,
                            //         child: Container(
                            //           padding: const EdgeInsets.symmetric(horizontal: 10),
                            //           alignment: Alignment.center,
                            //           margin: const EdgeInsets.only(bottom: 10),
                            //           decoration: BoxDecoration(
                            //               color: Colors.grey.shade300,
                            //               borderRadius: BorderRadius.circular(3)
                            //           ),
                            //           child: Text('${payList[index]['ledger_title']}'),
                            //         ),
                            //       ),
                            //
                            //       const SizedBox(width: 20,),
                            //
                            //       // Amount
                            //       Expanded(
                            //         flex: 2,
                            //         child: SizedBox(
                            //           height: 30,
                            //           width: 150,
                            //           child: TextFormField(
                            //             controller: amountControllerList[index],
                            //             onChanged: (value) {
                            //
                            //
                            //             },
                            //             decoration: InputDecoration(
                            //                 contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            //                 border: OutlineInputBorder(
                            //                     borderSide: BorderSide(color: Colors.grey.shade300)
                            //                 )
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //
                            //       const SizedBox(width: 20,),
                            //
                            //       // Delete Button
                            //       Container(
                            //         height: 28,
                            //         width:28,
                            //         margin: const EdgeInsets.all(1),
                            //         decoration: BoxDecoration(color: ThemeColors.deleteColor, borderRadius: BorderRadius.circular(5)),
                            //         child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                            //           showDialog(context: context, builder: (context) {
                            //             return
                            //               AlertDialog(
                            //                 title: const Text("Are you sure you want to delete"),
                            //                 actions: [
                            //                   TextButton(onPressed: () {
                            //                     Navigator.pop(context);
                            //                   }, child: const Text("Cancel")),
                            //
                            //                   TextButton(onPressed: () {
                            //                     setState(() {
                            //                       selectedRows.remove(selectedRows[index]);
                            //                     });
                            //                     Navigator.pop(context);
                            //                   }, child: const Text("Delete"))
                            //                 ],
                            //               );
                            //           },);
                            //         },
                            //             icon: const Icon(Icons.delete, size: 20, color: Colors.white,)),
                            //       ),
                            //     ],
                            //   );
                          },
                        ),
                      ),

                      const SizedBox(height: 10,),
                      const Divider(),
                      const SizedBox(height: 10,),
                      // Dropdown
                      SizedBox(
                        width: 500,
                        child: ValueListenableBuilder(
                          valueListenable: ledgerDropdownValue2,
                          builder: (context, value2, child) =>
                              SearchDropdownWidget(
                                dropdownList: ledgerTitleList,
                                hintText: "Select Ledger",
                                onChanged: (value) {
                                  ledgerDropdownValue2.value = value!;

                                  // getting oppLedgerId
                                  for(int i=0; i<ledgerList.length; i++){
                                    if(ledgerDropdownValue2.value == ledgerList[i]['ledger_title']){
                                      oppLedgerID = ledgerList[i]['ledger_id'].toString();
                                    }
                                  }
                                },
                                selectedItem: value2,
                                showSearchBox: true,
                                optional: false,
                              ),
                        ),
                      ),

                      const SizedBox(height: 40,),

                      // Remark and Date
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: FormWidgets().formDetails8("Remark", "Remark", remarkController , maxLines: 4)),

                          const SizedBox(width: 20,),

                          FormWidgets().formDetails10("Date", SizedBox(
                            height: 35,
                            width: 150,
                            child: TextFormField(
                              readOnly: true,
                              controller: paymentDateUI,
                              decoration: UiDecoration().dateFieldDecoration('Date'),
                              onTap: (){
                                UiDecoration().showDatePickerDecoration(context).then((value){
                                  setState(() {
                                    String months = value.month.toString().padLeft(2, '0');
                                    String days = value.day.toString().padLeft(2, '0');
                                    paymentDateUI.text = "$days-$months-${value.year}";
                                    paymentDateApi.text = "${value.year}-$months-$days";
                                  });
                                });
                              },
                            ),
                          ),)
                        ],
                      ),

                      const SizedBox(height: 40,),

                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                    onPressed: () {
                      ledgerDropdownValue2.value = '';
                      Navigator.pop(context);

                    },
                    child: const Text("Close")),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                    ),
                    onPressed: () {

                      if(_formKey2.currentState!.validate()){
                        payListPayableIdAndAmount.clear();
                        totalAmount = 0;
                        for(int i = 0; i<payList.length; i++){
                          // adding ledger_id and amount to send in api
                          payListPayableIdAndAmount.add({"amount" : amountControllerList[i].text, "payable_id":payList[i]['payable_id']});
                          totalAmount += double.parse(amountControllerList[i].text.isEmpty ? '0' : amountControllerList[i].text);
                        }
                        payableHistoryTransactionApiFunc();

                        Navigator.pop(context);

                      }

                    }, child: const Text("Pay" , style: TextStyle(color: Colors.white),))
              ],
            );
          },

        );
      },
    );
  }

  // check if same ledgers are selected or not
  bool checkSameLedgersSelected(){
    for(int i=0; i<selectedRows.length; i++){
      if(payableTableList[selectedRows[0]]['opp_ledger_id'] != payableTableList[selectedRows[i]]['opp_ledger_id']){
        return false;
      }
    }
      return true;
  }

  // summing all text field
  void setTotalAmount(int index) {
    totalAmount = 0;
    print('::::: ${amountControllerList.length}');
    for(int i=0; i<amountControllerList.length; i++ ){
      totalAmount += double.parse(amountControllerList[i].text.isEmpty ? '0' : amountControllerList[i].text);
    }
  }

  addDataToExport(){
    exportData.clear();
    exportData=[
      ['Date', 'Payable ID', 'Voucher Type', 'Ledger', 'Amount', 'Paid', 'Balance' ],
    ];
    for (int index = 0; index < data.length; index++) {
      List<String> rowData = [
        data[index]['created_date'].toString(),
        data[index]['payable_id'].toString(),
        data[index]['voucher_type'].toString(),
        data[index]['ledger_title'].toString(),
        data[index]['total_amount'].toString(),
        data[index]['paid_amount'].toString(),
        data[index]['paid_amount'].toString(),
      ];
      exportData.add(rowData);
    }
  }

  // API
  Future payableListApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/PayableTransactionReport?limit=${entriesDropdownValue.value}&page=${GlobalVariable.currentPage}&from_date=${fromDateApi.text}&to_date=${toDateApi.text}"); //
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future getPayableLedgersApi() async {
    var url = Uri.parse('${GlobalVariable.baseURL}Account/GetPayableLedgers?limit=10&page=1');
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var body = {
      // 'payable_id' : selectedPayableId.toString(),
      'payable_id' : selectedPayableIdsList.toString(),
    };
    var response = await http.post(url,headers: headers,body: body);
    return response.body.toString();
  }

  Future payableHistoryTransactionApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/PayableHistoryTransaction");
    var body = {
      // 'ledger_id': '[{"amount":"1221","ledger_id":29},{"amount":"2121","ledger_id":30},{"amount":"111","ledger_id":33}]',
      'ledger_id': selectedPayableId.toString(),
      'payable_id': jsonEncode(payListPayableIdAndAmount),
      'opp_ledger_id': oppLedgerID,
      'remark': remarkController.text,
      'entry_by': GlobalVariable.entryBy,
      'date': paymentDateApi.text,
      'total_amount': totalAmount.toString()
    };
    print('uuuuui: $payListPayableIdAndAmount');
    var response = await http.post(url, headers: headers, body: body);
    return response.body.toString();
  }

  Future payableTransactionApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Account/PayableTransaction');
    var body = {
      'payable_id': jsonEncode(selectedPayableIdsList),
      'opp_ledger_id': oppLedgerID,
      'amount': '500',
      'entry_by': '2',
      'remark': 'remark for Payment transaction',
      'date': '2023-05-02'
    };
    var response = await http.post(url,headers: headers,body: body);
    return response.body.toString();
  }

  Future exportDataApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/PayableTransactionReport?from_date=${fromDateApi.text}&to_date=${toDateApi.text}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn){
    if(mounted){
      setState(fn);
    }
  }

}

