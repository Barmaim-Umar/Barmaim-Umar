import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';

import 'package:pfc/auth/auth.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget.dart';
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

List<String> entriesDropdownList = ["10", "20", "30", "40"];
List<String> selectCashBankList = ["Bank1", "Bank2", "Bank3"];

class _PayableReportState extends State<PayableReport> with Utility {
  int freshLoad = 0;
  int freshLoad2 = 0;
  List selectedRows = [];
  List selectedPayableIdsList = [];
  int selectedPayableId = -1;
  List selectedLedgerIds = [];
  List<TextEditingController> amountControllerList = [];
  ValueNotifier<String> entriesDropdownValue =
      ValueNotifier(entriesDropdownList.first);
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
  List payableTableList = [];
  List payListPayableIdAndAmount = [];
  double totalAmount = 0;

  // ledger list Dropdown
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
  int payableId = -1;
  List payableDetailsList = [];

  // using to export data --> pdf , excel , etc
  List data = [];
  List<List<dynamic>> exportData = [];
  List<List<dynamic>> exportDataAmountDetails = [];

  // API Func
  payableListApiFunc() {
    setStateMounted(() {
      freshLoad = 1;
    });
    payableListApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        payableTableList.clear();
        payableTableList.addAll(info['data']);
        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.totalPages = info['total_pages'];
        GlobalVariable.next = info['next'];
        GlobalVariable.prev = info['prev'];
        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() {
          freshLoad = 0;
        });
      }
    });

    // Export Data
    exportDataApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        data.clear();
        exportData.clear();
        data.addAll(info['data']);
        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        setStateMounted(() {
          freshLoad = 0;
        });
      }
    });
  }

  ledgerFetchApiFunc() {
    ServiceWrapper().ledgerFetchApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
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

  getPayableLedgersApiFunc() {
    getPayableLedgersApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        payList.clear();
        payList.addAll(info['data']);
        amountControllerList.clear();
        for (int i = 0; i < info['data'].length; i++) {
          amountControllerList.add(TextEditingController(
              text: info['data'][i]['paid_amount'].toString() == "0"
                  ? "0"
                  : info['data'][i]['paid_amount'].toString()));
        }
        showPaymentPopup();
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  payableHistoryTransactionApiFunc() {
    payableHistoryTransactionApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
        payableListApiFunc();
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        payableListApiFunc();
      }
    });
  }

  payableDetailsApiFunc(int index) {
    setStateMounted(() {
      freshLoad2 = 1;
    });
    payableDetailsApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        payableDetailsList.clear();
        payableDetailsList.add(info['data']);
        setStateMounted(() {
          freshLoad2 = 0;
          // ShowPayableDetails(
          //   payableTableList: payableTableList,
          //   payableDetailsList: payableDetailsList,
          //   exportDataAmountDetails: exportDataAmountDetails,
          //   setState: (fn) {
          //   },
          // ).showDetails(index, context);
          _showDetails(index);
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() {
          freshLoad2 = 0;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    GlobalVariable.currentPage = 1;
    GlobalVariable.totalRecords = 0;
    ledgerFetchApiFunc(); // for dropdown filter
    payableListApiFunc(); // datatable
    selectedRows = [];
    // setting current date
    dayController.text = DateTime.now().day.toString();
    monthController.text = '07';
    yearController.text = DateTime.now().year.toString();
    dateControllerApi.text = DateTime.now().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Payable Reports"),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
                      builder: (context, value2, child) => SearchDropdownWidget(
                        dropdownList: entriesDropdownList,
                        hintText: "10",
                        onChanged: (value) {
                          entriesDropdownValue.value = value!;
                          payableListApiFunc();
                        },
                        selectedItem: value2,
                        showSearchBox: false,
                        maxHeight: 200,
                      ),
                    ),
                  ),
                  const Text(' entries'),
                  const Spacer(),
                  // Select Ledger / Customer
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
                    width: 20,
                  ),

                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        // from date
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

                        // to date
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
                  widthBox20(),
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(
                        ThemeColors.primaryColor,
                        ThemeColors.whiteColor,
                        100.0,
                        42.0),
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
                    children: [
                      BStyles().button(
                        'Excel',
                        'Export to Excel',
                        "assets/excel.png",
                        onPressed: () {
                          setState(() {
                            addDataToExport();
                          });
                          UiDecoration().excelFunc(exportData);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button(
                        'PDF',
                        'Export to PDF',
                        "assets/pdf.png",
                        onPressed: () {
                          setState(() {
                            addDataToExport();
                          });
                          UiDecoration().pdfFunc(exportData);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button(
                        'Print',
                        'Print',
                        "assets/print.png",
                        onPressed: () {
                          setState(() {
                            addDataToExport();
                          });
                          UiDecoration().generatePrintDocument(exportData);
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search '),
                  // Search
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: searchController,
                      decoration: UiDecoration().outlineTextFieldDecoration(
                          'Search', ThemeColors.primaryColor),
                      onChanged: (value) {
                        payableListApiFunc();
                      },
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // DataTable
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                              PointerDeviceKind.trackpad
                            }),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: freshLoad == 1
                              ? const Center(child: CircularProgressIndicator())
                              : DataTable(
                                  columnSpacing: 2,
                                  checkboxHorizontalMargin: 0,
                                  showCheckboxColumn: true,
                                  columns: [
                                    const DataColumn(label: Text('Date')),
                                    const DataColumn(
                                        label: Text('Payable ID.')),
                                    const DataColumn(
                                        label: Text('Voucher Type')),
                                    const DataColumn(label: Text('Ledger')),
                                    const DataColumn(label: Text('Amount')),
                                    const DataColumn(label: Text('Paid')),
                                    const DataColumn(label: Text('Balance')),
                                    DataColumn(
                                        label: Row(
                                          children: [
                                            const Text('Action'),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            // Pay Button
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.green),
                                              onPressed: () {
                                                if (selectedPayableIdsList
                                                        .isEmpty ||
                                                    selectedPayableId < 1) {
                                                  AlertBoxes
                                                      .flushBarErrorMessage(
                                                          'Select Ledger',
                                                          context);
                                                } else if (checkSameLedgersSelected()) {
                                                  getPayableLedgersApiFunc();
                                                  // print(selectedPayableIdsList.toString());
                                                } else {
                                                  AlertBoxes
                                                      .flushBarErrorMessage(
                                                          'Select Same Ledger',
                                                          context);
                                                }
                                              },
                                              icon: const Icon(
                                                  Icons.currency_rupee),
                                              label: const Text("Pay"),
                                            )
                                          ],
                                        ),
                                        numeric: true),
                                  ],
                                  rows: List.generate(payableTableList.length,
                                      (index) {
                                    double amount = double.parse(
                                        payableTableList[index]['total_amount']
                                                        .toString() ==
                                                    '' ||
                                                payableTableList[index]
                                                        ['total_amount'] ==
                                                    null
                                            ? '0'
                                            : payableTableList[index]
                                                    ['total_amount']
                                                .toString());
                                    double paid = double.parse(
                                        payableTableList[index]['paid_amount']
                                                        .toString() ==
                                                    '' ||
                                                payableTableList[index]
                                                        ['paid_amount'] ==
                                                    null
                                            ? '0'
                                            : payableTableList[index]
                                                    ['paid_amount']
                                                .toString());
                                    return DataRow(
                                        // selected checkbox
                                        selected: selectedRows.contains(index),
                                        // check \ uncheck
                                        onSelectChanged: (value) {
                                          onSelectedRow(value!, index);
                                        },
                                        color: MaterialStatePropertyAll(
                                            index == 0 || index % 2 == 0
                                                ? ThemeColors.tableRowColor
                                                : Colors.white),
                                        cells: [
                                          DataCell(Text(payableTableList[index]
                                                  ['created_date']
                                              .toString())),
                                          DataCell(Text(payableTableList[index]
                                                  ['payable_id']
                                              .toString())),
                                          DataCell(Text(payableTableList[index]
                                                  ['voucher_type']
                                              .toString())),
                                          DataCell(Text(payableTableList[index]
                                                  ['ledger_title'] ??
                                              '-')),
                                          DataCell(Text(payableTableList[index]
                                                  ['total_amount']
                                              .toString())),
                                          DataCell(Text(payableTableList[index]
                                                  ['paid_amount']
                                              .toString())),
                                          DataCell(Text('${amount - paid}')),
                                          DataCell(
                                            // Details Button
                                            ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                    // padding: const EdgeInsets.only(left: 3 , right: 3),
                                                    backgroundColor:
                                                        ThemeColors.primary,
                                                    minimumSize:
                                                        const Size(30, 35)),
                                                onPressed: () {
                                                  payableId =
                                                      payableTableList[index]
                                                          ['payable_id'];
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const PayableDetails(),));
                                                  // payableHistoryApiFunc(index);
                                                  payableDetailsApiFunc(index);
                                                },
                                                icon: const Icon(
                                                  Icons.info_outlined,
                                                  size: 17,
                                                ),
                                                label: const Text("Details")),
                                          ),
                                        ]);
                                  })),
                        ))
                  ],
                ),
              ),
            ),

            /// Pagination
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
                              payableListApiFunc();
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
                              payableListApiFunc();
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
                              payableListApiFunc();
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
                              payableListApiFunc();
                            });
                          },
                    icon: const Icon(Icons.last_page)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // for checkbox
  onSelectedRow(bool selected, int index) {
    setState(() {
      if (selected) {
        selectedRows.add(index);
        selectedPayableIdsList.add(payableTableList[index]['payable_id']);
        selectedPayableId = payableTableList[index]['payable_id'];
        ledgerID = payableTableList[index]['ledger_id'].toString();
      } else {
        selectedRows.remove(index);
        selectedPayableIdsList.remove(payableTableList[index]['payable_id']);
        // selectedPayableId = -1;
      }
    });
  }

  // Pay Button Popup
  showPaymentPopup() {
    totalAmount = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              titlePadding: const EdgeInsets.all(0),
              title: Container(
                height: 70,
                decoration: BoxDecoration(
                    color: const Color(0xfffd96e7),
                    borderRadius: BorderRadius.circular(4)),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Payment Voucher",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      // Selected List
                      selectedRows.isEmpty
                          ? const Center(
                              child: Text(
                                "Please Select Ledger",
                                style:
                                    TextStyle(color: ThemeColors.darkRedColor),
                              ),
                            )
                          : SizedBox(
                              width: 400,
                              height: 400,
                              child: ListView.builder(
                                // reverse: true,
                                itemCount: payList.length + 1,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (index == payList.length) {
                                    // This is the widget that will be shown at the end of the list.
                                    return Text('Total Amount: $totalAmount');
                                  } else {
                                    // This is the rest of the list payList.
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // ledger name
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            child: Text(
                                                '${payList[index]['ledger_title']}'),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            child: Text(
                                                '${payList[index]['payable_id']}'),
                                          ),
                                        ),

                                        const SizedBox(
                                          width: 20,
                                        ),

                                        // Amount
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            minLines: 1,
                                            maxLines: 1,
                                            controller:
                                                amountControllerList[index],
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value == '') {
                                                AlertBoxes.flushBarErrorMessage(
                                                    "Please fill Amount",
                                                    context);
                                                return '';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              setTotalAmount(index);
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 7),
                                                isDense: true,
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300)),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey
                                                                .shade300))),
                                          ),
                                        ),

                                        const SizedBox(
                                          width: 20,
                                        ),

                                        // Delete Button
                                        Container(
                                          height: 28,
                                          width: 28,
                                          margin: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                              color: ThemeColors.deleteColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: IconButton(
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Are you sure you want to delete"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Cancel")),
                                                        TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                selectedRows.remove(
                                                                    selectedRows[
                                                                        index]);
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Delete"))
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 20,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),

                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
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
                              for (int i = 0; i < ledgerList.length; i++) {
                                if (ledgerDropdownValue2.value ==
                                    ledgerList[i]['ledger_title']) {
                                  oppLedgerID =
                                      ledgerList[i]['ledger_id'].toString();
                                }
                              }
                            },
                            selectedItem: value2,
                            showSearchBox: true,
                            optional: false,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      // Remark and Date
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: FormWidgets().formDetails8(
                                  "Remark", "Remark", remarkController,
                                  maxLines: 4)),
                          const SizedBox(
                            width: 10,
                          ),
                          // Date field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TextDecorationClass().heading1('Date'),
                                  const Text(
                                    "  dd-mm-yyyy",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )
                                ],
                              ),
                              DateFieldWidget(
                                  dayController: dayController,
                                  monthController: monthController,
                                  yearController: yearController,
                                  dateControllerApi: dateControllerApi),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      if (_formKey2.currentState!.validate()) {
                        payListPayableIdAndAmount.clear();
                        totalAmount = 0;
                        for (int i = 0; i < payList.length; i++) {
                          // adding ledger_id and amount to send in api
                          payListPayableIdAndAmount.add({
                            "amount": amountControllerList[i].text,
                            "payable_id": payList[i]['payable_id']
                          });
                          totalAmount += double.parse(
                              amountControllerList[i].text.isEmpty
                                  ? '0'
                                  : amountControllerList[i].text);
                        }
                        payableHistoryTransactionApiFunc();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      "Pay",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            );
          },
        );
      },
    );
  }

  // check if same ledgers are selected or not
  bool checkSameLedgersSelected() {
    for (int i = 0; i < selectedRows.length; i++) {
      if (payableTableList[selectedRows[0]]['ledger_id'] !=
          payableTableList[selectedRows[i]]['ledger_id']) {
        return false;
      }
    }
    return true;
  }

  // summing all text field
  void setTotalAmount(int index) {
    totalAmount = 0;
    for (int i = 0; i < amountControllerList.length; i++) {
      totalAmount += double.parse(amountControllerList[i].text.isEmpty
          ? '0'
          : amountControllerList[i].text);
    }
  }

  _showDetails(int index) {
    int totalPaid = 0;
    int totalPayable = 0;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // payable amount details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date: ${payableTableList[index]['created_date']}"),
                    Text(
                        "${payableTableList[index]['ledger_title']} : ${payableTableList[index]['total_amount']}/-"),
                    const SizedBox(
                      height: 5,
                    ),

                    ///==========================
                    // buttons
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Row(
                        children: [
                          Wrap(
                            runSpacing: 5,
                            children: [
                              BStyles().button(
                                'Excel',
                                'Export to Excel',
                                "assets/excel.png",
                                onPressed: () {
                                  setState(() {
                                    addDataToExportAmountDetails();
                                  });
                                  UiDecoration().excelFunc(
                                      exportDataAmountDetails,
                                      header: true);
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              BStyles().button(
                                'PDF',
                                'Export to PDF',
                                "assets/pdf.png",
                                onPressed: () {
                                  setState(() {
                                    addDataToExportAmountDetails();
                                  });
                                  UiDecoration()
                                      .pdfFunc(exportDataAmountDetails);
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              BStyles().button(
                                'Print',
                                'Print',
                                "assets/print.png",
                                onPressed: () {
                                  setState(() {
                                    addDataToExportAmountDetails();
                                  });
                                  UiDecoration().generatePrintDocument(
                                      exportDataAmountDetails);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    ///==========================
                    const SizedBox(height: 5),
                    Container(
                      height: .3,
                      width: 400,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Payable Details",
                      style: TextStyle(
                          color: ThemeColors.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      // width:400,
                      child: DataTable(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ThemeColors.textFormFieldColor)),
                          headingRowHeight: 40,
                          columnSpacing: 10,
                          horizontalMargin: 8,
                          columns: const [
                            DataColumn(label: Text("Ledger")),
                            DataColumn(label: Text("Amount"), numeric: true),
                          ],
                          rows: List.generate(
                                  payableDetailsList[0]['payables'].length,
                                  (index) {
                                totalPayable += int.parse(payableDetailsList[0]
                                        ['payables'][index]['payable']
                                    .toString());
                                return DataRow(
                                    color: MaterialStatePropertyAll(
                                        index == 0 || index % 2 == 0
                                            ? ThemeColors.tableRowColor
                                            : Colors.white),
                                    cells: [
                                      DataCell(SingleChildScrollView(
                                          child: Container(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 300, minWidth: 300),
                                              child: Text(payableDetailsList[0]
                                                          ['payables'][index]
                                                      ['payable_to']
                                                  .toString())))),
                                      DataCell(Text(payableDetailsList[0]
                                              ['payables'][index]['payable']
                                          .toString())),
                                    ]);
                              }) +
                              [
                                DataRow(cells: [
                                  const DataCell(Text(
                                    'Total',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )),
                                  DataCell(Text(
                                    totalPayable.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )),
                                ])
                              ]),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
                // paid amount details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 77),

                    ///==========================
                    const SizedBox(height: 5),
                    Container(
                      height: .3,
                      width: 400,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Paid Details",
                      style: TextStyle(
                          color: ThemeColors.primary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      // width:400,
                      child: DataTable(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ThemeColors.textFormFieldColor)),
                          headingRowHeight: 40,
                          columnSpacing: 10,
                          horizontalMargin: 8,
                          columns: const [
                            DataColumn(label: Text("Ledger")),
                            DataColumn(label: Text("Date")),
                            DataColumn(label: Text("Amount"), numeric: true),
                          ],
                          rows: List.generate(
                                  payableDetailsList[0]['paids'].length,
                                  (index) {
                                totalPaid += int.parse(payableDetailsList[0]
                                        ['paids'][index]['paid']
                                    .toString());
                                return DataRow(
                                    color: MaterialStatePropertyAll(
                                        index == 0 || index % 2 == 0
                                            ? ThemeColors.tableRowColor
                                            : Colors.white),
                                    cells: [
                                      DataCell(SingleChildScrollView(
                                          child: Container(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 250, minWidth: 250),
                                              child: Text(payableDetailsList[0]
                                                          ['paids'][index]
                                                      ['payable_to']
                                                  .toString())))),
                                      DataCell(Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 110),
                                          child: Text(payableDetailsList[0]
                                                      ['paids'][index]
                                                  ['created_date']
                                              .toString()))),
                                      DataCell(Text(payableDetailsList[0]
                                              ['paids'][index]['paid']
                                          .toString())),
                                    ]);
                              }) +
                              [
                                DataRow(cells: [
                                  const DataCell(Text('')),
                                  const DataCell(Text(
                                    'Total',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )),
                                  DataCell(Text(
                                    totalPaid.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )),
                                ])
                              ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  addDataToExport() {
    exportData.clear();
    exportData = [
      [
        'Date',
        'Payable ID',
        'Voucher Type',
        'Ledger',
        'Amount',
        'Paid',
        'Balance'
      ],
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

  addDataToExportAmountDetails() {
    int payableTotal = 0;
    int paidsTotal = 0;
    int ind = 0;
    int payables = payableDetailsList[0]['payables'].length;
    int paids = payableDetailsList[0]['paids'].length;
    exportDataAmountDetails.clear();
    exportDataAmountDetails = [
      ['Payable Details', '  ', '  ', 'Paid Details'],
      ['Ledger', 'Amount', '    ', 'Ledger', 'Date', 'Amount'],
    ];

    // checking greater index
    if (payables > paids) {
      ind = payables;
    } else {
      ind = paids;
    }

    for (int index = 0; index < ind; index++) {
      if (payables > paids && index <= paids - 1) {
        payableTotal += int.parse(
            payableDetailsList[0]['payables'][index]['payable'].toString());
        paidsTotal +=
            int.parse(payableDetailsList[0]['paids'][index]['paid'].toString());
        List<String> rowData = [
          payableDetailsList[0]['payables'][index]['payable_to'].toString(),
          payableDetailsList[0]['payables'][index]['payable'].toString(),
          '         ', // empty string
          payableDetailsList[0]['paids'][index]['payable_to'].toString(),
          payableDetailsList[0]['paids'][index]['created_date'].toString(),
          payableDetailsList[0]['paids'][index]['paid'].toString(),
        ];
        exportDataAmountDetails.add(rowData);
      } else if (payables < paids && index <= payables - 1) {
        payableTotal += int.parse(
            payableDetailsList[0]['payables'][index]['payable'].toString());
        paidsTotal +=
            int.parse(payableDetailsList[0]['paids'][index]['paid'].toString());
        List<String> rowData = [
          payableDetailsList[0]['payables'][index]['payable_to'].toString(),
          payableDetailsList[0]['payables'][index]['payable'].toString(),
          '         ', // empty string
          payableDetailsList[0]['paids'][index]['payable_to'].toString(),
          payableDetailsList[0]['paids'][index]['created_date'].toString(),
          payableDetailsList[0]['paids'][index]['paid'].toString(),
        ];
        exportDataAmountDetails.add(rowData);
      } else if (payables > paids && index >= paids) {
        payableTotal += int.parse(
            payableDetailsList[0]['payables'][index]['payable'].toString());
        List<String> rowData = [
          payableDetailsList[0]['payables'][index]['payable_to'].toString(),
          payableDetailsList[0]['payables'][index]['payable'].toString(),
          '         ', // empty string
        ];
        exportDataAmountDetails.add(rowData);
      } else if (payables < paids && index >= payables) {
        paidsTotal +=
            int.parse(payableDetailsList[0]['paids'][index]['paid'].toString());
        List<String> rowData = [
          '         ',
          '         ',
          '         ', // empty string
          payableDetailsList[0]['paids'][index]['payable_to'].toString(),
          payableDetailsList[0]['paids'][index]['created_date'].toString(),
          payableDetailsList[0]['paids'][index]['paid'].toString(),
        ];
        exportDataAmountDetails.add(rowData);
      } else {
        payableTotal += int.parse(
            payableDetailsList[0]['payables'][index]['payable'].toString());
        paidsTotal +=
            int.parse(payableDetailsList[0]['paids'][index]['paid'].toString());
        List<String> rowData = [
          payableDetailsList[0]['payables'][index]['payable_to'].toString(),
          payableDetailsList[0]['payables'][index]['payable'].toString(),
          '         ', // empty string
          payableDetailsList[0]['paids'][index]['payable_to'].toString(),
          payableDetailsList[0]['paids'][index]['created_date'].toString(),
          payableDetailsList[0]['paids'][index]['paid'].toString(),
        ];
        exportDataAmountDetails.add(rowData);
      }
    }

    // adding total amount row
    exportDataAmountDetails.add([
      'Total:',
      '$payableTotal',
      '         ', // empty string
      '         ', // empty string
      'Total:',
      '$paidsTotal'
    ]);
  }

  // API
  Future payableListApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        "${GlobalVariable.baseURL}Account/PayableTransactionReport?limit=${entriesDropdownValue.value}&page=${GlobalVariable.currentPage}&from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}&ledger_id=$ledgerIDDropdown&column=ledger_title"); //
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  Future getPayableLedgersApi() async {
    var url = Uri.parse(
        '${GlobalVariable.baseURL}Account/GetPayableLedgers?limit=10&page=1');
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var body = {
      'payable_id': selectedPayableIdsList.toString(),
    };
    var response = await http.post(url, headers: headers, body: body);

    return response.body.toString();
  }

  Future payableHistoryTransactionApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url =
        Uri.parse("${GlobalVariable.baseURL}Account/PayableHistoryTransaction");
    var body = {
      'ledger_id': ledgerID.toString(),
      'items': jsonEncode(payListPayableIdAndAmount),
      'opp_ledger_id': oppLedgerID,
      'remark': remarkController.text,
      'entry_by': GlobalVariable.entryBy,
      'date': dateControllerApi.text,
      'total_amount': totalAmount.toString(),
    };
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
      'entry_by': GlobalVariable.entryBy,
      'remark': 'remark for Payment transaction',
      'date': '2023-05-02'
    };
    var response = await http.post(url, headers: headers, body: body);
    return response.body.toString();
  }

  Future exportDataApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        "${GlobalVariable.baseURL}Account/PayableTransactionReport?from_date=${fromDateApi.text}&to_date=${toDateApi.text}");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  // details button
  Future payableDetailsApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        "${GlobalVariable.baseURL}Account/PayableDetails?payable_id=$payableId");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
