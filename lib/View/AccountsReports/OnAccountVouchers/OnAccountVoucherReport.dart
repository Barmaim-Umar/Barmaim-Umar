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
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:pfc/utility/utility.dart';

class OnAccountVoucherReport extends StatefulWidget {
  const OnAccountVoucherReport({Key? key}) : super(key: key);

  @override
  State<OnAccountVoucherReport> createState() => _OnAccountVoucherReportState();
}

List<String> entriesDropdownList = ["10", "20", "30", "40"];

class _OnAccountVoucherReportState extends State<OnAccountVoucherReport> with Utility {

  List onAccountDataColumn = [
    {
      'column_name': 'Date',
      'column_value':'accounts__transactions.transaction_date',
    },
    {
      'column_name': 'Voucher Number',
      'column_value': 'accounts__transactions.voucher_id'
    },
    {
      'column_name':'Particulars',
      'column_value':'acc_one.ledger_title'

    },
    {
      'column_name': 'Amount',
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
  List onAccount = [];
  int currentIndex = 2;
  var keyword;
  int freshLoad = 0;
  var vehicleId;
  List data= [];
  List<List<dynamic>> exportData = [];

  onAccountListApiFunc(){
    data.clear();
    exportData.clear();
    setStateMounted(() {
      freshLoad = 1;
    });
    onAccountListApi().then((source){
      var info = jsonDecode(source);
      if(info['success']==true){
        onAccount.clear();
        onAccount.addAll(info['data']);
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
    exportDataApi().then((source){
      var info = jsonDecode(source);
      if(info['success']==true){
        data.addAll(info['data']);
        setStateMounted(() {
          freshLoad = 0;
        });
      }else{

      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onAccountListApiFunc();
    GlobalVariable.currentPage = 1;
    GlobalVariable.totalRecords = 0;
    keyword = onAccountDataColumn[2]['column_value'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar('OnAccount Voucher Report'),
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
                        border: Border.all(color: Colors.grey.shade400)),
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
                        });
                        onAccountListApiFunc();
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
                      onAccountListApiFunc();
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
                  // const Spacer(),
                  // TextDecoration().subHeading2('Search : '),
                  // Expanded(
                  //   flex: 1,
                  //   child: TextFormField(
                  //     controller: searchController,
                  //       decoration: UiDecoration().outlineTextFieldDecoration(
                  //           'Search', ThemeColors.primaryColor)),
                  // )
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),

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
                          child: freshLoad == 1 ? const Center(child: CircularProgressIndicator()):SizedBox(
                            width: double.maxFinite,
                            child: DataTable(

                              columns: List.generate(onAccountDataColumn.length, (index) =>
                                  DataColumn(
                                    label: InkWell(
                                    focusColor: Colors.white,
                                    hoverColor: Colors.white,
                                    onTap: () {
                                      setState(() {
                                        currentIndex = index;
                                        keyword = onAccountDataColumn[index]['column_value'];
                                      });
                                    }, child: SearchDataTable(
                                      onFieldSubmitted: (p0) {
                                        onAccountListApiFunc();
                                      },
                                      isSelected: index==4 ? false : index == currentIndex,
                                      search: searchController,
                                      columnName: onAccountDataColumn[index]['column_name']),
                                  ),
                                  ),
                              ),
                              showCheckboxColumn: false,
                              columnSpacing: 1,
                              horizontalMargin: 10,
                              sortColumnIndex: 0,
                              rows: List.generate(onAccount.length, (index) => DataRow(
                                color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
                                cells: [
                                  DataCell(Text(UiDecoration().getFormattedDate(onAccount[index]['transaction_date'].toString() ))),
                                  DataCell(Text(onAccount[index]['voucher_id'].toString())),
                                  DataCell(Text(onAccount[index]['ledger_title'].toString())),
                                  DataCell(Text(onAccount[index]['credit']=="0"?onAccount[index]['debit']:onAccount[index]['credit'].toString())),
                                ],
                              )),
                            ),
                          ),
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
                    onAccountListApiFunc();
                  });

                }, icon: const Icon(Icons.first_page)),

                // Prev Button
                IconButton(
                    onPressed: GlobalVariable.prev == false ? null : () {
                      setState(() {
                        GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                        onAccountListApiFunc();
                      });
                    }, icon: const Icon(Icons.chevron_left)),

                const SizedBox(width: 30,),

                // Next Button
                IconButton  (
                    onPressed: GlobalVariable.next == false ? null : () {
                      setState(() {
                        GlobalVariable.currentPage++;
                        onAccountListApiFunc();
                      });
                    }, icon: const Icon(Icons.chevron_right)),

                // Last Page Button
                IconButton(onPressed: !GlobalVariable.next ? null : () {
                  setState(() {
                    GlobalVariable.currentPage = GlobalVariable.totalPages;
                    onAccountListApiFunc();
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


  onAccountListApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Account/OnAccountTransactionReport?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}&column=$keyword');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  exportDataApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Account/OnAccountTransactionReport?from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}&column=$keyword');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  setStateMounted(VoidCallback fn){
    if(mounted){
      setState(fn);
    }
  }
}

class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data = List.generate(
      200,
          (index) => {
        "date": 'date $index',
        "voucher_no": Random().nextInt(99999),
        'particulars': '-',
        "amount": Random().nextInt(100000),
      });

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text(_data[index]['date'].toString())),
        DataCell(Text(_data[index]['voucher_no'].toString())),
        DataCell(Text(_data[index]['particulars'].toString())),
        DataCell(Text(_data[index]['amount'].toString())),
        DataCell(Row(
          children: [
            UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
            const SizedBox(width: 5),
            UiDecoration().actionButton( ThemeColors.deleteColor, IconButton(
                padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),

          ],
        )),
      ],
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
