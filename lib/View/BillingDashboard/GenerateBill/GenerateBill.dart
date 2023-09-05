import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  String? ledgerID = '';
  String? ledgerIDDropdown = '';
  String? oppLedgerID;
  List ledgerList = [];
  List payList = [];
  List<String> ledgerTitleList = [];
  ValueNotifier<String> ledgerDropdownValue = ValueNotifier('');
  ValueNotifier<String> ledgerDropdownValue2 = ValueNotifier('');
  TextEditingController dateControllerApi = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  String? ledgerIDDropdown2 = '';

  // ### Vehiclelist Dropdown ###
  List vehicleDropdown = [];
  List<String> vehicleNoList = [];
  String vehicleDropdownValue = '';

  final _formKey = GlobalKey<FormState>();
  getReceivedLRsApiFunc() {
    setState(() {
      freshload = 1;
    });
    getReceivedLRsApi().then((value) {
      var info = jsonDecode(value);
      print(info);
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

      if (info['success'] == true) {
        vehicleDropdown.addAll(info['data']);

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
              builder: (context) =>
               UpdateBillDetailsAndLRList( billNumber: billNumber.text),
            ));

      }
      else {
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
    final DataTableSource data = MyData(context, setState);
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
                        dropdownList: vehicleNoList,
                        hintText: "Select Vehicle",
                        onChanged: (value) {
                          // This is called when the user selects an item.
                          setState(() {
                            vehicleDropdownValue = value!;
                            // vehicleWiseReportApiFunc();
                          });
                        },
                        selectedItem: vehicleDropdownValue),
                  ),
                  // UiDecoration().dropDown(
                  //     1,
                  //     DropdownButton<String>(
                  //       borderRadius: BorderRadius.circular(5),
                  //       dropdownColor: ThemeColors.dropdownColor,
                  //       underline: Container(
                  //         decoration: const BoxDecoration(border: Border()),
                  //       ),
                  //       isExpanded: true,
                  //       hint: Text(
                  //         'Select Vehicle Type',
                  //         style:
                  //         TextStyle(color: ThemeColors.dropdownTextColor),
                  //       ),
                  //       icon: DropdownDecoration().dropdownIcon(),
                  //       value: vehicleTypeDropdownValue,
                  //       elevation: 16,
                  //       style: DropdownDecoration().dropdownTextStyle(),
                  //       onChanged: (String? newValue) {
                  //         // This is called when the user selects an item.
                  //         setState(() {
                  //           vehicleTypeDropdownValue = newValue!;
                  //         });
                  //       },
                  //       items: vehicleTypeList
                  //           .map<DropdownMenuItem<String>>((String value) {
                  //         return DropdownMenuItem<String>(
                  //           value: value.toString(),
                  //           child: Center(child: Text(value)),
                  //         );
                  //       }).toList(),
                  //     )),
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
                  // Expanded(
                  //   child: SearchDropdownWidget(
                  //     dropdownList:  ledgerList,
                  //     hintText:  'Select Ledger',
                  //     onChanged: (String? newValue) {
                  //       // This is called when the user selects an item.
                  //       setState(() {
                  //         ledgerDropdownValue = newValue!;
                  //       });
                  //     },
                  //     selectedItem:  ledgerDropdownValue,
                  //     maxHeight: 150,
                  //     showSearchBox: false,
                  //   ),
                  // ),
                  // UiDecoration().dropDown(
                  //     1,
                  //     DropdownButton<String>(
                  //       borderRadius: BorderRadius.circular(5),
                  //       dropdownColor: ThemeColors.dropdownColor,
                  //       underline: Container(
                  //         decoration: const BoxDecoration(border: Border()),
                  //       ),
                  //       isExpanded: true,
                  //       hint: Text(
                  //         'Select Ledger',
                  //         style:
                  //         TextStyle(color: ThemeColors.dropdownTextColor),
                  //       ),
                  //       icon: DropdownDecoration().dropdownIcon(),
                  //       value: ledgerDropdownValue,
                  //       elevation: 16,
                  //       style: DropdownDecoration().dropdownTextStyle(),
                  //       onChanged: (String? newValue) {
                  //         // This is called when the user selects an item.
                  //         setState(() {
                  //           ledgerDropdownValue = newValue!;
                  //         });
                  //       },
                  //       items: ledgerList
                  //           .map<DropdownMenuItem<String>>((String value) {
                  //         return DropdownMenuItem<String>(
                  //           value: value.toString(),
                  //           child: Center(child: Text(value)),
                  //         );
                  //       }).toList(),
                  //     )),

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
                  // fromDate
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: fromDateController,
                  //       decoration:
                  //       UiDecoration().dateFieldDecoration('From Date'),
                  //       onTap: () {
                  //         UiDecoration()
                  //             .showDatePickerDecoration(context)
                  //             .then((value) {
                  //           setState(() {
                  //             String month =
                  //             value.month.toString().padLeft(2, '0');
                  //             String day = value.day.toString().padLeft(2, '0');
                  //             fromDateController.text =
                  //             "$day-$month-${value.year}";
                  //           });
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                  widthBox10(),
                  // toDate
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: toDateController,
                  //       decoration:
                  //       UiDecoration().dateFieldDecoration('To Date'),
                  //       onTap: () {
                  //         UiDecoration()
                  //             .showDatePickerDecoration(context)
                  //             .then((value) {
                  //           setState(() {
                  //             String month =
                  //             value.month.toString().padLeft(2, '0');
                  //             String day = value.day.toString().padLeft(2, '0');
                  //             toDateController.text =
                  //             "$day-$month-${value.year}";
                  //           });
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                  widthBox10(),
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(
                        ThemeColors.primaryColor,
                        ThemeColors.whiteColor,
                        100.0,
                        42.0),
                    onPressed: () {},
                    child: const Text("Filter"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(ThemeColors.orangeColor,
                        ThemeColors.whiteColor, 150.0, 40.0),
                    onPressed: () {
                      print(
                          '4r3li3srdafdasf; ${selectedReceivedLRIdsList.join(",")}');
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            scrollable: true,
                            titlePadding: const EdgeInsets.all(10),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextDecorationClass().heading('Generate Bill'),
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
                                          valueListenable: ledgerDropdownValue2,
                                          builder: (context, value2, child) =>
                                              SearchDropdownWidget(
                                            dropdownList: ledgerTitleList,
                                            hintText: "Select Ledger",
                                            onChanged: (value) {
                                              ledgerDropdownValue2.value =
                                                  value!;

                                              // getting ledger id
                                              for (int i = 0;
                                                  i < ledgerList.length;
                                                  i++) {
                                                if (ledgerDropdownValue2
                                                        .value ==
                                                    ledgerList[i]
                                                        ['ledger_title']) {
                                                  ledgerIDDropdown2 =
                                                      ledgerList[i]['ledger_id']
                                                          .toString();
                                                }
                                              }
                                            },
                                            selectedItem: value2,
                                            showSearchBox: true,
                                          ),
                                        ),
                                      ),
                                      // UiDecoration().dropDown(
                                      //   0,
                                      //   DropdownButton<String>(
                                      //     borderRadius:
                                      //     BorderRadius.circular(5),
                                      //     dropdownColor: ThemeColors.whiteColor,
                                      //     underline: Container(
                                      //       decoration: const BoxDecoration(
                                      //           border: Border()),
                                      //     ),
                                      //     isExpanded: true,
                                      //     icon: const Icon(
                                      //       CupertinoIcons.chevron_down,
                                      //       color: ThemeColors.darkBlack,
                                      //       size: 20,
                                      //     ),
                                      //     iconSize: 30,
                                      //     value: billingLedgerDropdownValue,
                                      //     elevation: 16,
                                      //     style:
                                      //     TextDecorationClass().dropDownText(),
                                      //     onChanged: (String? newValue) {
                                      //       // This is called when the user selects an item.
                                      //       setState(() {
                                      //         billingLedgerDropdownValue =
                                      //         newValue!;
                                      //       });
                                      //     },
                                      //     items: billingLedgerList
                                      //         .map<DropdownMenuItem<String>>(
                                      //             (String value) {
                                      //           return DropdownMenuItem<String>(
                                      //             value: value.toString(),
                                      //             child: Text(value),
                                      //           );
                                      //         }).toList(),
                                      //   ),
                                      // ),
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
                                          monthController: monthControllerBill,
                                          yearController: yearControllerBill,
                                          dateControllerApi: apiControllerBill),
                                      // TextFormField(
                                      //   readOnly: true,
                                      //   controller: billingDate,
                                      //   decoration: UiDecoration()
                                      //       .outlineTextFieldDecoration(
                                      //       "Billing Date", Colors.grey),
                                      //   validator: (value) {
                                      //     if (value == null || value.isEmpty) {
                                      //       return 'Tenure To Field is Required';
                                      //     }
                                      //     return null;
                                      //   },
                                      //   onTap: () {
                                      //     UiDecoration()
                                      //         .showDatePickerDecoration(context)
                                      //         .then((value) {
                                      //       setState(() {
                                      //         String month = value.month
                                      //             .toString()
                                      //             .padLeft(2, '0');
                                      //         String day = value.day
                                      //             .toString()
                                      //             .padLeft(2, '0');
                                      //         billingDate.text =
                                      //         "$day-$month-${value.year}";
                                      //       });
                                      //     });
                                      //   },
                                      // ),
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
                          onPressed: () {},
                          'Excel',
                          'Export to Excel',
                          "assets/excel.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button(
                          onPressed: () {},
                          'PDF',
                          'Export to PDF',
                          "assets/pdf.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button(
                          onPressed: () {},
                          'Print',
                          'Print',
                          "assets/print.png"),
                    ],
                  ),
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search : '),
                  Expanded(
                    child: TextFormField(
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
            ? Center(child: CircularProgressIndicator())
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
                        DataCell(Text(
                            receivedLrTable[index]['vehicle_id'].toString())),
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
                          child: const Text('Doc 1'),
                        )),
                      ]);
                })
                //     +[
                //   DataRow(cells: [
                //     const DataCell(Text('')),
                //     const DataCell(Text('')),
                //     const DataCell(Text('')),
                //     const DataCell(Text('')),
                //     DataCell(
                //       Text(
                //         'Total Debit: $totalDebit',
                //         style: const TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //     DataCell(
                //       Text(
                //         'Total Credit: $totalCredit',
                //         style: const TextStyle(fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //     const DataCell(Text('')),
                //     const DataCell(Text('')),
                //   ],
                //   ),
                // ]
                );
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
    var url = Uri.parse(
        '${GlobalVariable.billingBaseURL}Reports/GetReceivedLRs?limit=${entriesDropdownValue}&page=${GlobalVariable.currentPage}&from_date&to_date=&ledger_id&vehcicle_type&keyword');
    var headers = {'token': Auth.token};
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  /// #####  getGenerateBillApi   ####
  ///
  Future getGenerateBillApi() async {
    var url = Uri.parse('${GlobalVariable.billingBaseURL}Billing/GenerateBill?'
        'lr_ids=${selectedReceivedLRIdsList.join(",")}&'
        'ledger_id=$ledgerIDDropdown2&'
        'bill_number=${billNumber.text}&'
        'total_freight_amount=23000&'
        'billed_by=${GlobalVariable.entryBy}&'
        'billing_date=${apiControllerBill.text}');
    var headers = {'token': Auth.token};
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }
}

class MyData extends DataTableSource {
  final BuildContext context;
  Function setState;
  List ind = [0, 2, 2, 0, 5, 0, 2, 6, 8, 10];

  MyData(this.context, this.setState);

  final List<Map<String, dynamic>> _data = List.generate(
      200,
      (index) => {
            "date": "27-09-2018",
            "particulars": "HDFC Bank ATM A/C",
            "voucher_no": Random().nextInt(10000),
            "voucher_type": "BPCL",
            "debit": "${Random().nextInt(7354)}",
            "credit": Random().nextInt(10000),
            "narration": "-",
            "entry_by": "Naveed Khan",
          });

  @override
  DataRow? getRow(int index) {
    Widget isChecked(bool isChecked, onChanged) {
      return Checkbox(
        fillColor: const MaterialStatePropertyAll(ThemeColors.primaryColor),
        value: isChecked,
        onChanged: onChanged,
      );
    }

    return DataRow(
      color: MaterialStatePropertyAll(index == 0 || index % 2 == 0
          ? ThemeColors.tableRowColor
          : Colors.white),
      cells: [
        DataCell(onTap: () {
          setState(() {
            ind.add(index);
            print(ind);
          });
        },
            isChecked(index == ind[index], (value) {
              setState(() {
                // ind = index;
                print("$ind");
              });
            })
            // Checkbox(
            //   fillColor: const MaterialStatePropertyAll(ThemeColors.primaryColor),
            //   value: isChecked,
            //   onChanged: (value) {
            //     setState((){
            //       print(index);
            //       isChecked = value!;
            //     });
            //   },)
            ),
        DataCell(Text(_data[index]['lr_no'].toString())),
        DataCell(Text(_data[index]['ledger'].toString())),
        DataCell(Text(_data[index]['vehicle_no'].toString())),
        DataCell(Text(_data[index]['from_location'].toString())),
        DataCell(Text(_data[index]['to_location'].toString())),
        DataCell(Text(_data[index]['lr_date'].toString())),
        DataCell(Text(_data[index]['received_date'].toString())),
        DataCell(ElevatedButton(
          style: ButtonStyles.customiseButton(
              ThemeColors.primary, ThemeColors.whiteColor, 70.0, 35.0),
          onPressed: () {},
          child: const Text('Doc 1'),
        )),
      ],
      onSelectChanged: (value) {},
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _data.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
