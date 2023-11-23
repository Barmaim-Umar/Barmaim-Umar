import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/View/AllForms/UpdateBillDetails%20&%20LRList/UpdateBillDetailsAndLRList.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'dart:math';

import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class BillList extends StatefulWidget {
  const BillList({Key? key}) : super(key: key);

  @override
  State<BillList> createState() => _BillListState();
}

List<String> entriesDropdownList = ["10", "20", "30", "40"];
List ledgerList = [];

class _BillListState extends State<BillList> with Utility {

  // String ledgerDropdownValue = ledgerList.first;
  String entriesDropdownValue = entriesDropdownList.first;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  List<List<dynamic>> exportData = [];
  List billsdataTable = [];

/// ####LedgerList dropdown ###
  String? ledgerIDDropdown = '';
  List<String> ledgerTitleList = [];
  ValueNotifier<String> ledgerDropdownValue = ValueNotifier('');

  // String? ledgerIDDropdownPopup = '';




  int freshload = 0;

  /// get bills Api Function
  getBillsApiFunc() {
    setState(() {
      freshload = 1;
    });
    getBillsApi().then((value) {
      var info = jsonDecode(value);
      // print(info);
      if (info['success'] == true) {
        billsdataTable.clear();
        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.prev = info['prev'];
        GlobalVariable.next = info['next'];
        GlobalVariable.totalPages = info['total_pages'];
        billsdataTable.addAll(info['data']);
        // print('dfdsf  : $billsdataTable');
        setState(() {
          freshload = 0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  /// ledger api
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

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    GlobalVariable.totalRecords = 0;
    ledgerFetchApiFunc();

    getBillsApiFunc();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final DataTableSource data = MyData();
    return Scaffold(
      appBar: UiDecoration.appBar('Billing List'),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // dropdown & search
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // dropdown
                  SizedBox(
                    width: 100,
                    child: SearchDropdownWidget(
                      dropdownList: entriesDropdownList,
                      hintText: 'Select Entries',
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          entriesDropdownValue = newValue!;
                          getBillsApiFunc();
                        });
                      },
                      selectedItem: entriesDropdownValue,
                      maxHeight: 150,
                      showSearchBox: false,
                    ),
                  ),
                  const Text(' entries'),
                  const Spacer(),
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
                  widthBox20(),
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
                      getBillsApiFunc();
                    },
                    child: const Text("Filter"),
                  ),
                  // Search
                  // const Text('Search: '), Expanded(child: FormWidgets().textFormField('Search')),
                ],
              ),
            ),

            // buttons
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Wrap(
                      runSpacing: 5,
                      // spacing: 0,
                      children: [
                        BStyles().button(onPressed: () {
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
                  ),
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search : '),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                        decoration: UiDecoration().outlineTextFieldDecoration(
                            'Search', ThemeColors.primaryColor)),
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Expanded(
                child: SingleChildScrollView(
                    // scrollDirection: Axis.horizontal,

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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                        width: MediaQuery.of(context)
                            .size
                            .width, // Calculate the total width of your columns
                        child: buildDataTable()),
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
                            getBillsApiFunc();
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
                            getBillsApiFunc();
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
                            getBillsApiFunc();
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
                            getBillsApiFunc();
                          });
                        },
                        icon: const Icon(Icons.last_page)),
                  ],
                ),
              ],
            )
                )
            ),
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
        DataTable(
            // columnSpacing: 90,
            columns: const [
          DataColumn(
              label: Text(
            'Bill No ',
            overflow: TextOverflow.ellipsis,
          )),
          DataColumn(
              label: Text(
            'Ledger/Customer ',
            overflow: TextOverflow.ellipsis,
          )),
          // DataColumn(
          //     label: Text(
          //   'Vehicle',
          //   overflow: TextOverflow.ellipsis,
          // )),
          // DataColumn(
          //     label: Text(
          //   'LR Number',
          //   overflow: TextOverflow.ellipsis,
          // )),
          DataColumn(
              label: Text(
            'Total Freight Amount',
            overflow: TextOverflow.ellipsis,
          )),
          DataColumn(
              label: Text(
            'Type',
            overflow: TextOverflow.ellipsis,
          )),
          DataColumn(
              label: Text(
            'Billing Date',
            overflow: TextOverflow.ellipsis,
          )),
          DataColumn(
              label: Text(
            'Billed By',
            overflow: TextOverflow.ellipsis,
          )),
          DataColumn(
              label: Text(
            'Action',
            overflow: TextOverflow.ellipsis,
          )),
        ],
            rows: List.generate(billsdataTable.length, (index) {
              // Calculate totals
              // if (transactionList[0][index]['debit'] != null) {
              //   totalDebit += double.parse( transactionList[0][index]['debit'] == '' ? '0' : transactionList[0][index]['debit'] );
              // }
              // if (transactionList[0][index]['credit'] != null) {
              //   totalCredit += double.parse(transactionList[0][index]['credit'] == '' ? '0' : transactionList[0][index]['credit']);
              // }
              return DataRow(
                  color: index == 0 || index % 2 == 0
                      ? MaterialStatePropertyAll(ThemeColors.tableRowColor)
                      : const MaterialStatePropertyAll(Colors.white),
                  cells: [
                    DataCell(Text(billsdataTable[index]['bill_id'].toString())),
                    DataCell(
                        Text(billsdataTable[index]['ledger_title'].toString())),
                    // DataCell(Text(_data[index]['vehicle'].toString())),
                    // DataCell(Text(_data[index]['lr_number'].toString())),
                    DataCell(Text(billsdataTable[index]['total_freight_amount']
                        .toString())),
                    DataCell(
                        Text(billsdataTable[index]['bill_type'].toString())),
                    DataCell(
                        Text(billsdataTable[index]['billing_date'].toString())),
                    DataCell(
                        Text(billsdataTable[index]['billed_by'].toString())),
                    DataCell(Row(
                      children: [
                        UiDecoration().actionButton(
                            ThemeColors.editColor,
                            IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateBillDetailsAndLRList(),));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 15,
                                  color: Colors.white,
                                ))),
                        const SizedBox(width: 5),
                        UiDecoration().actionButton(
                            ThemeColors.primary,
                            IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                icon: const Icon(
                                  CupertinoIcons.link,
                                  size: 15,
                                  color: Colors.white,
                                ))),
                        const SizedBox(width: 5),
                        UiDecoration().actionButton(
                            ThemeColors.orangeColor,
                            IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.print_outlined,
                                  size: 15,
                                  color: Colors.white,
                                ))),
                        const SizedBox(width: 5),
                        UiDecoration().actionButton(
                            ThemeColors.darkBlueColor,
                            IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.menu,
                                  size: 15,
                                  color: Colors.white,
                                ))),
                        const SizedBox(width: 5),
                        UiDecoration().actionButton(
                            ThemeColors.deleteColor,
                            IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.delete,
                                  size: 15,
                                  color: Colors.white,
                                ))),
                      ],
                    )),
                  ]);
            })

            );
  }

  addDataToExport() {
    exportData.clear();
    exportData = [
      [
        'Bill No',
        'Ledger/Customer',
        'Total Freight Amount',
        'Type',
        'Billing Date',
        'Billed By'
      ],
    ];
    for (int index = 0; index < billsdataTable.length; index++) {
      List<String> rowData = [
        billsdataTable[index]['bill_id'].toString(),
        billsdataTable[index]['ledger_title'].toString(),
        billsdataTable[index]['total_freight_amount'].toString(),
        billsdataTable[index]['bill_type'].toString(),
        billsdataTable[index]['billing_date'].toString(),
        billsdataTable[index]['billed_by'].toString(),
      ];
      exportData.add(rowData);
    }
  }

  /// Get Bills Api
  Future getBillsApi() async {
    var url = Uri.parse('${GlobalVariable.billingBaseURL}Reports/GetBills?'
        'limit=${entriesDropdownValue}&'
        'page=${GlobalVariable.currentPage}');
    var headers = {'token': Auth.token};
    print(url);
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }
}

// class MyData extends DataTableSource {
//   final List<Map<String, dynamic>> _data = List.generate(
//       200,
//           (index) => {
//         "bill_no": 'bill $index',
//         "ledger": 'customer ${Random().nextInt(99999)}',
//         'vehicle': '-',
//         'lr_number': '-',
//         "amount": Random().nextInt(100000),
//         "type": 'regular',
//         "billing_date": 'date $index',
//         "billed_by": 'person $index',
//       });
//
//   @override
//   DataRow? getRow(int index) {
//     return DataRow(
//       color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
//       cells: [
//         DataCell(Text(_data[index]['bill_no'].toString())),
//         DataCell(Text(_data[index]['ledger'].toString())),
//         DataCell(Text(_data[index]['vehicle'].toString())),
//         DataCell(Text(_data[index]['lr_number'].toString())),
//         DataCell(Text(_data[index]['amount'].toString())),
//         DataCell(Text(_data[index]['type'].toString())),
//         DataCell(Text(_data[index]['billed_date'].toString())),
//         DataCell(Text(_data[index]['billed_by'].toString())),
//         DataCell(Row(
//           children: [
//             UiDecoration().actionButton( ThemeColors.editColor,IconButton(
//                 padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
//             const SizedBox(width: 5),
//             UiDecoration().actionButton( ThemeColors.primary, IconButton(
//                 padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(CupertinoIcons.link, size: 15, color: Colors.white,))),
//             const SizedBox(width: 5),
//             UiDecoration().actionButton( ThemeColors.orangeColor, IconButton(
//                 padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.print_outlined, size: 15, color: Colors.white,))),
//             const SizedBox(width: 5),
//             UiDecoration().actionButton( ThemeColors.darkBlueColor, IconButton(
//                 padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.menu, size: 15, color: Colors.white,))),
//             const SizedBox(width: 5),
//             UiDecoration().actionButton( ThemeColors.deleteColor, IconButton(
//                 padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),
//           ],
//         )
//         ),
//       ],
//     );
//   }
//
//   @override
//   // TODO: implement isRowCountApproximate
//   bool get isRowCountApproximate => false;
//
//   @override
//   // TODO: implement rowCount
//   int get rowCount => _data.length;
//
//   @override
//   // TODO: implement selectedRowCount
//   int get selectedRowCount => 0;
// }
