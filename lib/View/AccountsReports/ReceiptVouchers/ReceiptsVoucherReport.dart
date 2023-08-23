import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/searchDataTable.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class ReceiptsVoucherReport extends StatefulWidget {
  const ReceiptsVoucherReport({Key? key}) : super(key: key);

  @override
  State<ReceiptsVoucherReport> createState() => _ReceiptsVoucherReportState();
}

List<String> entriesDropdownList = ["10", "20", "30", "40"];

class _ReceiptsVoucherReportState extends State<ReceiptsVoucherReport> with Utility {
  String entriesDropdownValue = entriesDropdownList.first;
  TextEditingController searchController = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List receiptList = [];
  int freshLoad = 0;

  List receiptVoucherReportColumns = [
    {
      'column_name' : 'Date',
      'column_value' : 'accounts__vouchers.entry_date'
    },
    {
      'column_name' : 'Voucher Number',
      'column_value' : 'accounts__vouchers.voucher_id'
    },
    {
      'column_name' : 'Particulars',
      'column_value' : 'acc_one.ledger_title',
    },
    {
      'column_name' : 'Amount',
      'column_value' : 'accounts__vouchers.amount',
    },
  ];
  var keyword;
  int currentIndex = 0;
  List data = [];
  List<List<dynamic>> exportData = [];
  // API
  receiptListApiFunc(){
    receiptListApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){

        receiptList.clear();

        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.totalPages = info['total_pages'];
        GlobalVariable.next = info['next'];
        GlobalVariable.prev = info['prev'];

        receiptList.addAll(info['data']);
        setState(() {
          freshLoad = 0;
        });

      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
    exportDataApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){

        data.clear();
        exportData.clear();

        data.addAll(info['data']);
        setState(() {
          freshLoad = 0;
        });

      }
    });
  }

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    receiptListApiFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar('Receipts Voucher Report'),
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
                  Container(
                    height: 30,
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ThemeColors.grey700)),
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(5),
                      dropdownColor: ThemeColors.whiteColor,
                      underline: Container(
                        decoration: const BoxDecoration(border: Border()),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Entries',
                        style: TextStyle(color: ThemeColors.darkBlack),
                      ),
                      icon: const Icon(
                        CupertinoIcons.chevron_down,
                        color: ThemeColors.darkBlack,
                        size: 20,
                      ),
                      iconSize: 30,
                      value: entriesDropdownValue,
                      elevation: 16,
                      style: TextDecorationClass().dropDownText(),
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          entriesDropdownValue = newValue!;
                          receiptListApiFunc();
                        });
                      },
                      items: entriesDropdownList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const Text(' entries'),
                  const Spacer(),
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
                  widthBox10(),
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(
                        ThemeColors.primaryColor,
                        ThemeColors.whiteColor,
                        100.0,
                        42.0),
                    onPressed: () {
                      receiptListApiFunc();
                    },
                    child: const Text("Filter"),
                  ),
                ],
              ),
            ),

            // buttons
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Wrap(
                      runSpacing: 5,
                      // spacing: 0,
                      children: [
                        BStyles().button(
                          'Excel', 'Export to Excel', "assets/excel.png",onPressed: () {
                          setState(() {
                            addDataToExport();
                          });
                          UiDecoration().excelFunc(exportData);
                        },),
                        const SizedBox(
                          width: 10,
                        ),
                        BStyles()
                            .button('PDF', 'Export to PDF', "assets/pdf.png",onPressed: () {
                          setState(() {
                            UiDecoration().pdfFunc(exportData);
                          });
                        },),
                        const SizedBox(
                          width: 10,
                        ),
                        BStyles().button('Print', 'Print', "assets/print.png",onPressed: () {
                          setState(() {
                            addDataToExport();
                          });
                          UiDecoration().generatePrintDocument(exportData);
                        },),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Expanded(
                child: SingleChildScrollView(
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
                            child:
                            SizedBox(
                              width: double.maxFinite,
                              child: DataTable(
                                  columns: List.generate(receiptVoucherReportColumns.length, (index) =>
                                      DataColumn(label: InkWell(
                                        focusColor: Colors.white,
                                        hoverColor: Colors.white,
                                        onTap: () {
                                          setState(() {
                                            currentIndex = index;
                                            keyword = receiptVoucherReportColumns[index]['column_value'];
                                          });
                                        },
                                        child: SearchDataTable(
                                          onFieldSubmitted: (value) {
                                            receiptListApiFunc();
                                          },
                                          isSelected: index == 4 ? false : index == currentIndex,
                                          search: searchController,
                                          columnName: receiptVoucherReportColumns[index]['column_name'],
                                        ),
                                      )
                                      )
                                  ),
                                  rows: List.generate(receiptList.length, (index) {
                                    return DataRow(cells: [
                                      DataCell(TextDecorationClass().dataRowCell(UiDecoration().getFormattedDate(receiptList[index]['entry_date'].toString()))),
                                      DataCell(TextDecorationClass().dataRowCell(receiptList[index]['voucher_id'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(receiptList[index]['ledger_title'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(receiptList[index]['amount'].toString())),
                                      // DataCell(Row(
                                      //   children: [
                                      //     UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                                      //         padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
                                      //     const SizedBox(width: 5),
                                      //     UiDecoration().actionButton( ThemeColors.deleteColor, IconButton(
                                      //         padding: const EdgeInsets.all(0),
                                      //         onPressed: () {
                                      //           setState((){
                                      //
                                      //           });
                                      //         },
                                      //         icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),
                                      //
                                      //   ],
                                      // )),
                                    ]);
                                  })
                              ),
                            )
                        )
                      ],
                    ))),
            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Text("Total Records: ${GlobalVariable.totalRecords}"),

                const SizedBox(width: 100,),

                // First Page Button
                IconButton(onPressed: !GlobalVariable.prev ? null : () {
                  setState(() {
                    GlobalVariable.currentPage = 1;
                    receiptListApiFunc();
                  });

                }, icon: const Icon(Icons.first_page)),

                // Prev Button
                IconButton(
                    onPressed: GlobalVariable.prev == false ? null : () {
                      setState(() {
                        GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                        receiptListApiFunc();
                      });
                    }, icon: const Icon(Icons.chevron_left)),

                const SizedBox(width: 30,),

                // Next Button
                IconButton  (
                    onPressed: GlobalVariable.next == false ? null : () {
                      setState(() {
                        GlobalVariable.currentPage++;
                        receiptListApiFunc();
                      });
                    }, icon: const Icon(Icons.chevron_right)),

                // Last Page Button
                IconButton(onPressed: !GlobalVariable.next ? null : () {
                  setState(() {
                    GlobalVariable.currentPage = GlobalVariable.totalPages;
                    receiptListApiFunc();
                  });

                }, icon: const Icon(Icons.last_page)),
              ],
            ),
          ],
        ),
      ),
    );
  }


  addDataToExport(){
    exportData.clear();
    exportData=[
      ['Date','Voucher Number','Particulars','Amount'],
    ];
    for (int index = 0; index < data.length; index++) {
      List<String> rowData = [
        data[index]['entry_date'].toString(),
        data[index]['voucher_id'].toString(),
        data[index]['ledger_title'].toString(),
        data[index]['amount'].toString(),
      ];
      exportData.add(rowData);
    }
  }


  // API
  Future receiptListApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/ReceiptTransactionList?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}&column=$keyword");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }
  Future exportDataApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/ReceiptTransactionList?from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}&column=$keyword");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

}

