import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/Widgets/searchDataTable.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:http/http.dart' as http;
import 'package:pfc/utility/utility.dart';

class PaymentVoucherReport extends StatefulWidget {
  const PaymentVoucherReport({Key? key}) : super(key: key);

  @override
  State<PaymentVoucherReport> createState() => _PaymentVoucherReportState();
}

List<String> entriesDropdownList = ["10", "20", "30", "40"];
List paymentTransactionReportList = [];

class _PaymentVoucherReportState extends State<PaymentVoucherReport> with Utility {
  List paymentDataColumn = [
    {
      'column_name': 'Date',
      'column_value':'accounts__vouchers.entry_date',
    },
    {
      'column_name': 'Voucher Number',
      'column_value': 'accounts__vouchers.voucher_id'
    },
    {
      'column_name':'Particulars',
      'column_value':'acc_one.ledger_title'

    },
    {
      'column_name': 'Amount',
      'column_value':'accounts__vouchers.amount'
    },
    {
      'column_name': 'Action',
      'column_value':'accounts__vouchers.amount'
    },
  ];
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
  int freshLoad = 0;
  int currentIndex = 2;
  var keyword;
  List data = [];
  List<List<dynamic>> exportData = [];

  paymentTransactionListApiFunc(){
    setState(() {
      freshLoad = 1;
      paymentTransactionReportList.clear();
      data.clear();
      exportData.clear();
    });
    paymentTransactionListApi().then((value){
      var info = jsonDecode(value);
      if(info['success'] == true){

        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.totalPages = info['total_pages'];
        GlobalVariable.next = info['next'];
        GlobalVariable.prev = info['prev'];

        setState(() {
          paymentTransactionReportList.addAll(info['data']);
          freshLoad = 0;
        });
      }
      else{
        setState(() {
          freshLoad = 0;
        });
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
    exportDataApi().then((value){
      var info = jsonDecode(value);
      if(info['success'] == true){
        setState(() {
          data.addAll(info['data']);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    GlobalVariable.currentPage = 1;
    paymentTransactionListApiFunc();
    keyword = paymentDataColumn[2]['column_value'];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar('Payment Voucher Report'),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // dropdown , date field and filterButton
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // entries dropdown
                  SizedBox(
                    width: 80,
                    child: SearchDropdownWidget(dropdownList: entriesDropdownList, hintText: entriesDropdownList.first, onChanged: (value) {
                      // This is called when the user selects an item.
                      setState(() {
                        entriesDropdownValue = value!;
                        paymentTransactionListApiFunc();
                      });
                    }, selectedItem: entriesDropdownValue ,
                      showSearchBox: false,
                      maxHeight: 200,
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

                  // Filter Button
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(
                        ThemeColors.primaryColor,
                        ThemeColors.whiteColor,
                        100.0,
                        42.0),
                    onPressed: () {
                      paymentTransactionListApiFunc();
                    },
                    child: const Text("Filter"),
                  ),

                ],
              ),
            ),

            // buttons & Search
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Row(
                children: [

                  // Buttons
                  Expanded(
                    child: Wrap(
                      runSpacing: 5,
                      // spacing: 0,
                      children: [
                        BStyles().button(
                          'Excel', 'Export to Excel', "assets/excel.png",onPressed: () {
                          setState(() {                                addDataToExport();
                          });
                          UiDecoration().excelFunc(exportData);
                        },),
                        const SizedBox(
                          width: 10,
                        ),
                        BStyles()
                            .button('PDF', 'Export to PDF', "assets/pdf.png",onPressed: () {
                          setState(() {
                            addDataToExport();
                          });
                          UiDecoration().pdfFunc(exportData);
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

                  const Spacer(),

                  // Search
                  TextDecorationClass().subHeading2('Search : '),
                  Expanded(
                    child: TextFormField(
                        controller: searchController,
                        onFieldSubmitted: (value) {
                          paymentTransactionListApiFunc();
                        },
                        decoration: UiDecoration().outlineTextFieldDecoration(
                            'Search', ThemeColors.primaryColor)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10,),

            freshLoad == 1 ? const Center(child: CircularProgressIndicator(),):Expanded(
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
                                  columns: List.generate(paymentDataColumn.length, (index) =>
                                      DataColumn(label: InkWell(
                                        focusColor: Colors.white,
                                        hoverColor: Colors.white,
                                        onTap: () {
                                          setState(() {
                                            currentIndex = index;
                                            keyword = paymentDataColumn[index]['column_value'];
                                          });
                                        }, child: SearchDataTable(
                                          onFieldSubmitted: (p0) {
                                            paymentTransactionListApiFunc();
                                          },
                                          isSelected: index==4?false:index == currentIndex,
                                          search: searchController,
                                          columnName: paymentDataColumn[index]['column_name']),
                                      ),
                                      ),
                                  ),
                                  rows: List.generate(paymentTransactionReportList.length, (index){
                                    return DataRow(
                                        color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
                                        cells: [
                                          DataCell(Text(UiDecoration().getFormattedDate(paymentTransactionReportList[index]['entry_date'].toString()))),
                                          DataCell(Text(paymentTransactionReportList[index]['voucher_id'].toString())),
                                          DataCell(Text(paymentTransactionReportList[index]['ledger_title'].toString())),
                                          DataCell(Text(paymentTransactionReportList[index]['amount'].toString())),
                                          DataCell(Row(
                                            children: [
                                              // edit icon
                                              // UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                                              //     padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
                                              const SizedBox(width: 5),
                                              // delete icon
                                              UiDecoration().actionButton( ThemeColors.deleteColor, IconButton(
                                                  padding: const EdgeInsets.all(0),
                                                  onPressed: () {
                                                    setState((){

                                                    });
                                                  },
                                                  icon: const Icon(Icons.delete, size: 15, color: Colors.white,),),),

                                            ],
                                          )),
                                        ]);
                                  })
                              ),
                            )

                        )
                      ],
                    ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Text("${GlobalVariable.totalRecords} Total Records"),
                const SizedBox(width: 30,),

                // First Page Button
                IconButton(onPressed: !GlobalVariable.prev ? null : () {

                  setState(() {
                    GlobalVariable.currentPage = 1;
                    paymentTransactionListApiFunc();
                  });

                }, icon: const Icon(Icons.first_page)),

                // Previous Button
                IconButton(onPressed: !GlobalVariable.prev ? null : () {

                  setState(() {
                    GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                    paymentTransactionListApiFunc();
                  });

                }, icon: const Icon(CupertinoIcons.left_chevron)),

                const SizedBox(width: 30,),

                // Next Button
                IconButton(onPressed: !GlobalVariable.next ? null : () {

                  setState(() {
                    GlobalVariable.currentPage < GlobalVariable.totalPages ? GlobalVariable.currentPage++  :
                    GlobalVariable.currentPage = GlobalVariable.totalPages;
                    paymentTransactionListApiFunc();
                  });

                }, icon: const Icon(CupertinoIcons.right_chevron)),

                // Last Page Button
                IconButton(onPressed: !GlobalVariable.next ? null : () {

                  setState(() {
                    GlobalVariable.currentPage = GlobalVariable.totalPages;
                    paymentTransactionListApiFunc();
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

  paymentTransactionListApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse(
        '${GlobalVariable.baseURL}Account/PaymentTransactionList?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}&column=$keyword'
    );
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }
  exportDataApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse(
        '${GlobalVariable.baseURL}Account/PaymentTransactionList?from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}&column=$keyword'
    );
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }


}

