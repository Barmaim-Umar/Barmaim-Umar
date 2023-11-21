import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/View/SideBar/SideBar.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:pfc/utility/utility.dart';

import '../../AllForms/UpdateBillDetails & LRList/UpdateBillDetailsAndLRList.dart';

class GenerateBill extends StatefulWidget {
  const GenerateBill({Key? key}) : super(key: key);

  @override
  State<GenerateBill> createState() => _GenerateBillState();
}

List<String> billingLedgerList = [
  'Mushtaq Khan',
  'Akbar Patel',
  'Name3',
  'Name4'
];
List<String> vehicleTypeList = ['BPCL', 'Cash', 'ATM'];
List<String> entriesList = ["10", "20", "30", "40"];
bool isChecked = false;

class _GenerateBillState extends State<GenerateBill> with Utility {
  // String ledgerDropdownValue ='';
  String billingLedgerDropdownValue = '';
  String vehicleTypeDropdownValue = '';
  String entriesDropdownValue = entriesList.first;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController billingDate = TextEditingController();
  TextEditingController billNumber = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  // ########################
  TextEditingController dayControllerBill = TextEditingController();
  TextEditingController monthControllerBill = TextEditingController();
  TextEditingController yearControllerBill = TextEditingController();
  TextEditingController apiControllerBill = TextEditingController();

  List receivedLrTable = [];
  int freshload = 0;

  List selectedRows = [];
  List selectedReceivedLRIdsList = [];
  int selectedReceivedLRId = -1;

  // ####LedgerList dropdown ###
  String? ledgerIDDropdown = '';
  String? oppLedgerID;
  List ledgerList = [];
  List payList = [];
  List<String> ledgerTitleList = [];
  ValueNotifier<String> ledgerDropdownValue = ValueNotifier('');
  ValueNotifier<String> ledgerDropdownValuePopup = ValueNotifier('');
  TextEditingController dateControllerApi = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  String? ledgerIDDropdownPopup = '';

  // ### Vehiclelist Dropdown ###
  List vehicleNoListWithId = [];
  List<String> vehicleNoList = [];
  String vehicleDropdownValue = '';
  var vehicleId = '';
  List<List<dynamic>> exportData = [];

  final _formKey = GlobalKey<FormState>();

  getReceivedLRsApiFunc() {
    setState(() {
      freshload = 1;
    });
    getReceivedLRsApi().then((value) {
      var info = jsonDecode(value);
      // print(info);
      if (info['success'] == true) {
        receivedLrTable.clear();
        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.prev = info['prev'];
        GlobalVariable.next = info['next'];
        GlobalVariable.totalPages = info['total_pages'];
        receivedLrTable.addAll(info['data']);
        setState(() {
          freshload = 0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  // ##### LedgerAPi Function ###
  ledgerFetchApiFunc() {
    ServiceWrapper().ledgerFetchApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        ledgerList.clear();
        ledgerTitleList.clear();
        ledgerList.addAll(info['data']);

        // adding ledger title in ledgerTitleList

        for (int i = 0; i < info['data'].length; i++) {
          ledgerTitleList.add(info['data'][i]['ledger_title']);
        }
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  // vehicle dropdown API
  vehicleDropdownApiFunc() {
    ServiceWrapper().vehicleFetchApi().then((value) {
      var info = jsonDecode(value);
      // print(info);

      if (info['success'] == true) {
        vehicleNoListWithId.clear();
        vehicleNoList.clear();

        vehicleNoListWithId.addAll(info['data']);

        // adding ledger title in "$ledgerTitleList" for dropdown
        for (int i = 0; i < info['data'].length; i++) {
          vehicleNoList.add(info['data'][i]['vehicle_number']);
        }
      } else {
        AlertBoxes.flushBarErrorMessage("${info['message']}", context);
      }
    });
  }

  getGenerateBillApiFunc() {
    getGenerateBillApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateBillDetailsAndLRList(
                billNumber: billNumber.text,
                ledger: ledgerDropdownValuePopup.value,
                date:
                    "${dayControllerBill.text}-${monthControllerBill.text}-${yearControllerBill.text}",
              ),
            ));
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    GlobalVariable.totalRecords = 0;
    vehicleDropdownApiFunc();
    ledgerFetchApiFunc();

    getReceivedLRsApiFunc();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Generate Bill"),
      body: Container(
        margin: const EdgeInsets.all(8),
        // padding: const EdgeInsets.only(top: 10 , left: 10),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  /// Vehicle dropdown
                  Expanded(
                    child: SearchDropdownWidget(
                      maxHeight: 500,
                      dropdownList: vehicleNoList,
                      hintText: 'Select Vehicle',
                      onChanged: (value) {
                        setStateMounted(() {
                          vehicleDropdownValue = value!;
                          for (int i = 0; i < vehicleNoListWithId.length; i++) {
                            if (vehicleDropdownValue ==
                                vehicleNoListWithId[i]['vehicle_number']) {
                              vehicleId = vehicleNoListWithId[i]['vehicle_id']
                                  .toString();
                            }
                          }
                          // print('dsafadsf::::$vehicleId');

                          // advAtmTransactionListApiFunc();
                          getReceivedLRsApiFunc();
                        });
                      },
                      selectedItem: vehicleDropdownValue,
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  /// ledger drop down
                  SizedBox(
                    width: 300,
                    child: ValueListenableBuilder(
                      valueListenable: ledgerDropdownValue,
                      builder: (context, value2, child) => SearchDropdownWidget(
                        dropdownList: ledgerTitleList,
                        hintText: "Select Ledger",
                        onChanged: (value) {
                          ledgerDropdownValue.value = value!;

                          // getting ledger id
                          for (int i = 0; i < ledgerList.length; i++) {
                            if (ledgerDropdownValue.value ==
                                ledgerList[i]['ledger_title']) {
                              ledgerIDDropdown =
                                  ledgerList[i]['ledger_id'].toString();
                            }
                          }
                        },
                        selectedItem: value2,
                        showSearchBox: true,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),
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
                                dateControllerApi: fromDateApi),
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
                                    dateControllerApi: toDateApi),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  widthBox10(),
                  widthBox10(),
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(
                        ThemeColors.primaryColor,
                        ThemeColors.whiteColor,
                        100.0,
                        42.0),
                    onPressed: () {
                      getReceivedLRsApiFunc();
                      // print('sdfgsdg:${toDateApi.text}');
                    },
                    child: const Text("Filter"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(ThemeColors.orangeColor,
                        ThemeColors.whiteColor, 150.0, 40.0),
                    onPressed: () {

                      if (selectedRows.isEmpty) {
                        AlertBoxes.flushBarErrorMessage(
                            "Please Select Atleast One LR", context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              scrollable: true,
                              titlePadding: const EdgeInsets.all(10),
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextDecorationClass()
                                      .heading('Generate Bill'),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      CupertinoIcons.xmark,
                                      color: Colors.grey,
                                      size: 15,
                                    ),
                                  )
                                ],
                              ),
                              contentPadding: const EdgeInsets.all(20),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeColors.primary),
                                  onPressed: () {
                                    getGenerateBillApiFunc();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Generate'),
                                ),
                                ElevatedButton(
                                  style: ButtonStyles.customiseButton(
                                      ThemeColors.grey200,
                                      ThemeColors.grey,
                                      100.0,
                                      37.0),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ///Billing Ledger
                                        TextDecorationClass()
                                            .heading1('Select Billing Ledger'),
                                        SizedBox(
                                          width: 300,
                                          child: ValueListenableBuilder(
                                            valueListenable:
                                                ledgerDropdownValuePopup,
                                            builder: (context, value2, child) =>
                                                SearchDropdownWidget(
                                              dropdownList: ledgerTitleList,
                                              hintText: "Select Ledger",
                                              onChanged: (value) {
                                                ledgerDropdownValuePopup.value =
                                                    value!;

                                                // getting ledger id
                                                for (int i = 0;
                                                    i < ledgerList.length;
                                                    i++) {
                                                  if (ledgerDropdownValuePopup
                                                          .value ==
                                                      ledgerList[i]
                                                          ['ledger_title']) {
                                                    ledgerIDDropdownPopup =
                                                        ledgerList[i]
                                                                ['ledger_id']
                                                            .toString();
                                                  }
                                                }
                                              },
                                              selectedItem: value2,
                                              showSearchBox: true,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widthBox30(),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextDecorationClass()
                                            .heading1("Billing Date"),
                                        DateFieldWidget2(
                                            dayController: dayControllerBill,
                                            monthController:
                                                monthControllerBill,
                                            yearController: yearControllerBill,
                                            dateControllerApi:
                                                apiControllerBill),

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
                                              .heading1('Bill Number'),
                                          TextFormField(
                                            controller: billNumber,
                                            decoration: UiDecoration()
                                                .outlineTextFieldDecoration(
                                                    "Bill Number",
                                                    ThemeColors.primaryColor),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: const Text('Generate Bill'),
                  ),
                ],
              ),
            ),

            // buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // entries dropdown
                  SizedBox(
                    width: 100,
                    child: SearchDropdownWidget(
                      dropdownList: entriesList,
                      hintText: 'Select Entries',
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          entriesDropdownValue = newValue!;
                          getReceivedLRsApiFunc();
                        });
                      },
                      selectedItem: entriesDropdownValue,
                      maxHeight: 150,
                      showSearchBox: false,
                    ),
                  ),
                  const Text(' entries'),
                  widthBox20(),
                  Wrap(
                    runSpacing: 5,
                    // spacing: 0,
                    children: [
                      // BStyles()
                      //     .button('CSV', 'Export to CSV', "assets/csv2.png"),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      BStyles().button(
                          onPressed: () {
                        setState(() {
                          addDataToExport();
                        });
                        UiDecoration().excelFunc(exportData);
                      }, 'Excel', 'Export to Excel', "assets/excel.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button(onPressed: () {
                        setState(() {
                          addDataToExport();
                        });
                        UiDecoration().pdfFunc(exportData);
                      }, 'PDF', 'Export to PDF', "assets/pdf.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button(onPressed: () {
                        setState(() {
                          addDataToExport();
                        });
                        UiDecoration().generatePrintDocument(exportData);
                      }, 'Print', 'Print', "assets/print.png"),
                    ],
                  ),
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search : '),
                  Expanded(
                    child: TextFormField(
                        onChanged: (value) {
                          getReceivedLRsApiFunc();
                        },
                        controller: searchController,
                        decoration: UiDecoration().outlineTextFieldDecoration(
                            'Search', ThemeColors.primaryColor)),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Transaction Report
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: ThemeColors.primaryColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "All LRs | All Time Records",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// DataTable
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad
                      }),
                  child: Container(
                    width: double.maxFinite,
                    // width: MediaQuery.of(context).size.width, // Calculate the total width of your columns
                    child: SingleChildScrollView(child: buildDataTable()),
                  ),
                ),

                // pagination
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Total Records: ${GlobalVariable.totalRecords}"),

                    const SizedBox(
                      width: 100,
                    ),

                    // First Page Button
                    IconButton(
                        onPressed: !GlobalVariable.prev
                            ? null
                            : () {
                                setState(() {
                                  GlobalVariable.currentPage = 1;
                                  getReceivedLRsApiFunc();
                                });
                              },
                        icon: const Icon(Icons.first_page)),

                    // Prev Button
                    IconButton(
                        onPressed: GlobalVariable.prev == false
                            ? null
                            : () {
                                setState(() {
                                  GlobalVariable.currentPage > 1
                                      ? GlobalVariable.currentPage--
                                      : GlobalVariable.currentPage = 1;
                                  getReceivedLRsApiFunc();
                                });
                              },
                        icon: const Icon(Icons.chevron_left)),

                    const SizedBox(
                      width: 30,
                    ),

                    // Next Button
                    IconButton(
                        onPressed: GlobalVariable.next == false
                            ? null
                            : () {
                                setState(() {
                                  GlobalVariable.currentPage++;
                                  getReceivedLRsApiFunc();
                                });
                              },
                        icon: const Icon(Icons.chevron_right)),

                    // Last Page Button
                    IconButton(
                        onPressed: !GlobalVariable.next
                            ? null
                            : () {
                                setState(() {
                                  GlobalVariable.currentPage =
                                      GlobalVariable.totalPages;
                                  getReceivedLRsApiFunc();
                                });
                              },
                        icon: const Icon(Icons.last_page)),
                  ],
                ),
              ],
            ))),
          ],
        ),
      ),
    );
  }

  Widget buildDataTable() {
    double totalDebit = 0;
    double totalCredit = 0;
    return
        /* transactionList.isEmpty ? const Center(child: Text("Select Leger"),) : */
        freshload == 1
            ? const Center(child: CircularProgressIndicator())
            : DataTable(
                columnSpacing: 55,
                showCheckboxColumn: true,
                columns: const [
                  // DataColumn(label: Text('Mark',overflow: TextOverflow.ellipsis,)),
                  DataColumn(
                      label: Text(
                    'LR No ',
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    'Ledger',
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    'vehicle No',
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    'From Location',
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    'TO Location',
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    'LR Date',
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    'Received Date',
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    'Scanned',
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
                rows: List.generate(receivedLrTable.length, (index) {
                  // Calculate totals
                  // if (transactionList[0][index]['debit'] != null) {
                  //   totalDebit += double.parse( transactionList[0][index]['debit'] == '' ? '0' : transactionList[0][index]['debit'] );
                  // }
                  // if (transactionList[0][index]['credit'] != null) {
                  //   totalCredit += double.parse(transactionList[0][index]['credit'] == '' ? '0' : transactionList[0][index]['credit']);
                  // }
                  return DataRow(
                      selected: selectedRows.contains(index),
                      onSelectChanged: (value) {
                        onSelectedRow(value!, index);
                      },
                      color: index == 0 || index % 2 == 0
                          ? MaterialStatePropertyAll(ThemeColors.tableRowColor)
                          : const MaterialStatePropertyAll(Colors.white),
                      cells: [
                        // DataCell(Text("data")),
                        DataCell(Text(
                            receivedLrTable[index]['lr_number'].toString())),
                        DataCell(Text(
                            receivedLrTable[index]['ledger_title'].toString())),
                        DataCell(Text(receivedLrTable[index]['vehicle_number']
                            .toString())),
                        DataCell(Text(receivedLrTable[index]['from_location']
                            .toString())),
                        DataCell(Text(
                            receivedLrTable[index]['to_location'].toString())),
                        DataCell(
                            Text(receivedLrTable[index]['lr_date'].toString())),
                        DataCell(Text(receivedLrTable[index]['received_date']
                            .toString())),

                        DataCell(ElevatedButton(
                          style: ButtonStyles.customiseButton(
                              ThemeColors.primary,
                              ThemeColors.whiteColor,
                              70.0,
                              35.0),
                          onPressed: () {},
                          child: const Text('Documents'),
                        )),
                      ]);
                }));
  }

  addDataToExport() {
    exportData.clear();
    exportData = [
      [
        'LR No',
        'Ledger',
        'Vehicle No',
        'From Location',
        'To Location',
        'Received Date'
      ],
    ];
    for (int index = 0; index < receivedLrTable.length; index++) {
      List<String> rowData = [
        receivedLrTable[index]['lr_number'].toString(),
        receivedLrTable[index]['ledger_title'].toString(),
        receivedLrTable[index]['vehicle_number'].toString(),
        receivedLrTable[index]['from_location'].toString(),
        receivedLrTable[index]['to_location'].toString(),
        receivedLrTable[index]['received_date'].toString(),
      ];
      exportData.add(rowData);
    }
  }

  // for checkbox
  onSelectedRow(bool selected, int index) {
    setState(() {
      if (selected) {
        selectedRows.add(index);
        selectedReceivedLRIdsList.add(receivedLrTable[index]['lr_id']);
        selectedReceivedLRId = receivedLrTable[index]['lr_id'];
      } else {
        selectedRows.remove(index);
        selectedReceivedLRIdsList.remove(receivedLrTable[index]['lr_id']);
        // selectedPayableId = -1;
      }
    });
  }

  /// Received Lr Api
  Future getReceivedLRsApi() async {
    var url =
        Uri.parse('${GlobalVariable.billingBaseURL}Reports/GetReceivedLRs?'
            'limit=${entriesDropdownValue}&'
            'page=${GlobalVariable.currentPage}&'
            'from_date=${fromDateApi.text}&'
            'to_date=${toDateApi.text}&'
            'ledger_id=$ledgerIDDropdown&'
            'vehicle_id=$vehicleId&'
            'keyword=${searchController.text}');
    var headers = {'token': Auth.token};
    print(url);
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  /// #####  getGenerateBillApi   ####
  //
  Future getGenerateBillApi() async {
    var url = Uri.parse('${GlobalVariable.billingBaseURL}Billing/GenerateBill?'
        'lr_ids=${selectedReceivedLRIdsList.join(",")}&'
        'ledger_id=$ledgerIDDropdownPopup&'
        'bill_number=${billNumber.text}&'
        'total_freight_amount=23000&'
        'billed_by=${GlobalVariable.entryBy}&'
        'billing_date=${apiControllerBill.text}');
    var headers = {'token': Auth.token};
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
