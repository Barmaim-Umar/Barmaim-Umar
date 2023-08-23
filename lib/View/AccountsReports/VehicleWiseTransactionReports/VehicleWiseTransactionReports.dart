import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/Widgets/searchDataTable.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class VehicleWiseTransactionReports extends StatefulWidget {
  const VehicleWiseTransactionReports({Key? key}) : super(key: key);

  @override
  State<VehicleWiseTransactionReports> createState() => _VehicleWiseTransactionReportsState();
}

List<String> vehicleNoList = [];
List<String> entriesList = ["10" ,"20" ,"30" ,"40"];

class _VehicleWiseTransactionReportsState extends State<VehicleWiseTransactionReports> with Utility{

  // for ledger dropdown
  List ledgerList = [];
  List<String> ledgerTitleList = [];
  var ledgerID;
  var vehicleId;
  String ledgerDropdownValue = "";
  String vehicleDropdownValue = '';
  String entriesDropdownValue = entriesList.first;
  TextEditingController searchController = TextEditingController();
  TextEditingController pageNoController = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List vehicleWiseReportList = [];
  List vehicleDropdown = [];
  List <List<dynamic>>exportData = [];
  List data = [];
  int freshLoad = 1;

  List transactionReportColumns = [
    {
      'column_name' : 'Date',
      'column_value' : 'accounts__transactions.transaction_date'
    },
    {
      'column_name' : 'Particulars',
      'column_value' : 'acc_two.ledger_title'
    },
    {
      'column_name' : 'Voucher No.',
      'column_value' : 'accounts__transactions.voucher_id',
    },
    {
      'column_name' : 'Vehicle No.',
      'column_value' : 'accounts__transactions.voucher_id',
    },
    {
      'column_name' : 'Voucher Type',
      'column_value' : 'accounts__transactions.voucher_type',
    },
    {
      'column_name' : 'Debit',
      'column_value' : 'accounts__transactions.debit',
    },
    {
      'column_name' : 'Credit',
      'column_value' : 'accounts__transactions.credit',
    },
    {
      'column_name' : 'Narration',
      'column_value' : 'accounts__transactions.remark',
    },
    {
      'column_name' : 'Entry By',
      'column_value' : 'accounts__transactions.entry_by',
    },
  ];
  var keyword;
  int currentIndex = 1;

  // API
  vehicleWiseReportApiFunc(){
    data.clear();
    exportData.clear();
    vehicleWiseReportApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
    vehicleWiseReportList.clear();
        setStateMounted(() {
          vehicleWiseReportList.add(info['data']);
          GlobalVariable.totalRecords = info['total_records'];
          GlobalVariable.totalPages = info['total_pages'];
          GlobalVariable.currentPage = info['page'];
          GlobalVariable.next = info['next'];
          GlobalVariable.prev = info['prev'];
          freshLoad = 0;
        });
      } else{
        setStateMounted(() {
          freshLoad = 0;
        });
        debugPrint("SUCCESS FALSE");
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
    exportDataApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        setStateMounted(() {
          data.addAll(info['data']);
          freshLoad = 0;
        });
      }
    });
  }

  // dropdown api
  ledgerFetchApiFunc(){
    ServiceWrapper().ledgerFetchApi().then((value) {
      var info = jsonDecode(value);

      if(info['success'] == true){
        ledgerList.addAll(info['data']);

        // adding ledger title in "$ledgerTitleList" for dropdown
        for(int i=0; i<info['data'].length; i++){
          ledgerTitleList.add(info['data'][i]['ledger_title']);
        }

        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage("${info['message']}", context);
      }
    });
  }
  vehicleDropdownApiFunc(){
    ServiceWrapper().vehicleFetchApi().then((value) {
      var info = jsonDecode(value);

      if(info['success'] == true){
        vehicleDropdown.addAll(info['data']);

        // adding ledger title in "$ledgerTitleList" for dropdown
        for(int i=0; i<info['data'].length; i++){
          vehicleNoList.add(info['data'][i]['vehicle_number']);
        }

        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage("${info['message']}", context);
      }
    });
  }

  @override
  void initState() {
    vehicleDropdownApiFunc();
    GlobalVariable.currentPage = 1;
    keyword = transactionReportColumns[1]['column_value'];
    ledgerFetchApiFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Vehicle Wise Transaction Report"),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              alignment: Alignment.centerLeft,
              child: TextDecorationClass().heading('Transaction Report'),
            ),
            const Divider(),

            // dropdown & dateField & filter button
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // entries dropdown
                  SizedBox(
                    width: 80,
                    child: SearchDropdownWidget(dropdownList: entriesList, hintText: entriesList.first, onChanged: (value) {
                      // This is called when the user selects an item.
                      setStateMounted(() {
                        entriesDropdownValue = value!;
                        vehicleWiseReportApiFunc();
                      });
                    }, selectedItem: entriesDropdownValue,
                      showSearchBox: false,
                      maxHeight: 200.0,
                    ),
                  ),
                  const Text(' entries'),

                  widthBox30(),

                  const SizedBox(width: 10,),

                  // Names / Ledger dropdown
                  Expanded(
                    child: SearchDropdownWidget(dropdownList: ledgerTitleList, hintText: "Please Select Ledger", onChanged: (value) {

                      // This is called when the user selects an item.
                      setStateMounted(() {
                        ledgerDropdownValue = value!;

                        // getting ledger ID
                        for(int i = 0; i<ledgerList.length; i++){
                          if(ledgerList[i]['ledger_title'] == ledgerDropdownValue){
                            ledgerID = ledgerList[i]['ledger_id'];
                          }
                        }

                        keyword = transactionReportColumns[1]['column_value'];
                        searchController.text = ledgerDropdownValue;
                      });
                    }, selectedItem: ledgerDropdownValue),
                  ),

                  const SizedBox(width: 10,),

                  // Vehicle dropdown
                  Expanded(
                    child: SearchDropdownWidget(
                        dropdownList: vehicleNoList,
                        hintText: "Select Vehicle",
                        onChanged: (value) {
                      // This is called when the user selects an item.
                      setStateMounted(() {
                        vehicleDropdownValue = value!;
                        // vehicleWiseReportApiFunc();
                      });
                    }, selectedItem: vehicleDropdownValue),
                  ),

                  const SizedBox(width: 10,),

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

                  // filter button
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor,100.0,42.0),
                    onPressed: () {
                      setStateMounted(() {
                        vehicleWiseReportApiFunc();
                      });
                    },
                    child: const Text("Filter"),
                  ),
                ],
              ),
            ),

            // buttons & search
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  // buttons
                  Expanded(
                    child: Wrap(
                      runSpacing: 5,
                      // spacing: 0,
                      children: [
                        BStyles().button('Excel', 'Export to Excel', "assets/excel.png",onPressed: () {
                          setStateMounted(() {
                            addDataToExport();
                          });
                          UiDecoration().excelFunc(exportData);
                        },),
                        const SizedBox(
                          width: 10,
                        ),
                        BStyles().button('PDF', 'Export to PDF', "assets/pdf.png",onPressed: () async {
                          setStateMounted(() {
                            addDataToExport();
                          });
                          UiDecoration().pdfFunc(exportData);
                        },),
                        const SizedBox(
                          width: 10,
                        ),
                        BStyles().button('Print', 'Print', "assets/print.png",onPressed: () {
                          setStateMounted(() {
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

            const SizedBox(height: 20,),

            // Transaction Report
            Container(
              margin: const EdgeInsets.only(left: 10 , right: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration:  BoxDecoration(color: ThemeColors.primaryColor , borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$ledgerDropdownValue | From: ${fromDateApi.text} | To: ${toDateApi.text} Records" , style: const TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                ],),
            ),

            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Dr Opening Amount
                        Row(
                          children: [
                            Expanded(child: UiDecoration().totalAmountLabel("Opening Amount")),
                            Expanded(child: UiDecoration().totalAmount("0.00")),
                          ],
                        ),

                        /// DataTable
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5 , vertical: 5),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: ThemeColors.whiteColor,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: freshLoad == 1 ? const Center(child: Text("FreshLoad = 1 \nPlease Wait..."),) : buildDataTable(),
                        ),
                        const Divider(),

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
                                vehicleWiseReportApiFunc();
                              });

                            }, icon: const Icon(Icons.first_page)),

                            // Prev Button
                            IconButton(
                                onPressed: GlobalVariable.prev == false ? null : () {
                                  setState(() {
                                    GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                                    vehicleWiseReportApiFunc();
                                  });
                                }, icon: const Icon(Icons.chevron_left)),

                            const SizedBox(width: 30,),

                            // Next Button
                            IconButton  (
                                onPressed: GlobalVariable.next == false ? null : () {
                                  setState(() {
                                    GlobalVariable.currentPage++;
                                    vehicleWiseReportApiFunc();
                                  });
                                }, icon: const Icon(Icons.chevron_right)),

                            // Last Page Button
                            IconButton(onPressed: !GlobalVariable.next ? null : () {
                              setState(() {
                                GlobalVariable.currentPage = GlobalVariable.totalPages;
                                vehicleWiseReportApiFunc();
                              });

                            }, icon: const Icon(Icons.last_page)),
                          ],
                        ),
                        /// Dr Closing Amount
                        Row(
                          children: [
                            Expanded(child: UiDecoration().totalAmountLabel("Closing Amount")),
                            Expanded(child: UiDecoration().totalAmount("0.0")),
                          ],
                        ),

                      ],
                    ))),
          ],
        ),
      ),
    );
  }

  // DataTable
  Widget buildDataTable() {
    double totalDebit = 0;
    double totalCredit = 0;
    return vehicleWiseReportList.isEmpty ? const Center(child: Text("Select Leger"),) : DataTable(

        columnSpacing: 10,
        columns: List.generate(transactionReportColumns.length, (index) =>
            DataColumn(
                label: InkWell(
                  onTap: () {
                    setStateMounted((){
                      currentIndex = index;
                      searchController.clear();
                      keyword = transactionReportColumns[index]['column_value'];
                    });

                  },
                  child: SearchDataTable(
                      onFieldSubmitted: (p0) {
                        vehicleWiseReportApiFunc();
                      },
                      isSelected: index == currentIndex,
                      search: searchController,
                      columnName: transactionReportColumns[index]['column_name']),
                )
            ),
        ),
        rows:  List.generate(vehicleWiseReportList[0].length, (index) {

          // Calculate totals
          if (vehicleWiseReportList[0][index]['debit'] != null) {
            totalDebit += double.parse(vehicleWiseReportList[0][index]['debit']);
          }
          if (vehicleWiseReportList[0][index]['credit'] != null) {
            totalCredit += double.parse(vehicleWiseReportList[0][index]['credit']);
          }

          return DataRow(
              color: index == 0 || index % 2 == 0? MaterialStatePropertyAll(ThemeColors.tableRowColor) : const MaterialStatePropertyAll(Colors.white),
              cells: [
                DataCell(TextDecorationClass().dataRowCell(UiDecoration().getFormattedDate(vehicleWiseReportList[0][index]['transaction_date'].toString())),),
                DataCell(TextDecorationClass().dataRowCell(vehicleWiseReportList[0][index]['opp_ledger_title'].toString())),
                DataCell(TextDecorationClass().dataRowCell(vehicleWiseReportList[0][index]['voucher_id'].toString())),
                DataCell(TextDecorationClass().dataRowCell(vehicleWiseReportList[0][index]['vehicle_number'].toString())),
                DataCell(TextDecorationClass().dataRowCell(vehicleWiseReportList[0][index]['voucher_type'] ?? "_")),
                DataCell(TextDecorationClass().dataRowCell(vehicleWiseReportList[0][index]['debit'] ?? "_")),
                DataCell(TextDecorationClass().dataRowCell(vehicleWiseReportList[0][index]['credit'] ?? "_")),
                DataCell(SingleChildScrollView(
                  child: SizedBox(
                      width: 150,
                      child: TextDecorationClass().dataRowCell(vehicleWiseReportList[0][index]['remark'] ?? "_")),
                )),
                DataCell(TextDecorationClass().dataRowCell(vehicleWiseReportList[0][index]['user_name'] ?? "_")),
              ]);
        })+
            [
              DataRow(cells: [
                const DataCell(Text('')),
                const DataCell(Text('')),
                const DataCell(Text('')),
                const DataCell(Text('')),
                const DataCell(Text('')),
                DataCell(
                  Text(
                    'Total Debit: $totalDebit',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataCell(
                  Text(
                    'Total Credit: $totalCredit',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const DataCell(Text('')),
                const DataCell(Text('')),
              ],
              ),
            ]
    );
  }


  addDataToExport(){
    exportData.clear();
    exportData = [
      ['Date', 'Particulars', 'Voucher No.','Voucher Type','Debit','Credit','Narration','Entry By'],
    ];

    for (int index = 0; index < data.length; index++) {
      List<String> rowData = [
        data[index]['transaction_date'],
        data[index]['ledger_title'].toString(),
        data[index]['voucher_id'].toString(),
        data[index]['vehicle_number'].toString(),
        data[index]['voucher_type'],
        data[index]['debit'],
        data[index]['credit'],
        data[index]['narration'].toString(),
        data[index]['entry_by'],
      ];
      exportData.add(rowData);
    }
  }

  // API
  Future vehicleWiseReportApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/VehicleWiseReport?to_date=${toDateApi.text}&from_date=${fromDateApi.text}&vehicle_id=$vehicleId&limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&filter=$vehicleDropdownValue&keyword=${searchController.text}&column=$keyword&ledger_id=$ledgerID");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future exportDataApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/VehicleWiseReport?from_date=${fromDateApi.text}&vehicle_id=$vehicleId&to_date=${toDateApi.text}&filter=$vehicleDropdownValue&keyword=${searchController.text}&column=$keyword");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  pw.Document generatePDF(List<List<dynamic>> data) {
    final pdf = pw.Document();

    // Determine the number of pages required
    const int itemsPerPage = 29;
    final int pageCount = (data.length / itemsPerPage).ceil();

    // Generate pages
    for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
      final startItemIndex = pageIndex * itemsPerPage;
      final endItemIndex = (startItemIndex + itemsPerPage < data.length)
          ? startItemIndex + itemsPerPage
          : data.length;
      final pageItems = data.sublist(startItemIndex, endItemIndex);
      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) {

            final table = pw.Table.fromTextArray(
              // headers: headers,
              data: pageItems,
            );
            // Add data to the page
            // for (String item in pageItems) {
            //   content.add(pw.Text(item, style: pw.TextStyle(fontSize: 12)));
            //   content.add(pw.SizedBox(height: 10)); // Add spacing between items
            // }

            return [
              pw.Center(
                child: table,
              ),
            ];
          },
        ),
      );
    }

    return pdf;
  }

  Future<void> generateAndDownloadPDF(List<List<dynamic>> dataList) async {
    final pdf = pw.Document();

    const int itemsPerPage = 29;
    final int pageCount = (dataList.length / itemsPerPage).ceil();

    for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
      final startItemIndex = pageIndex * itemsPerPage;
      final endItemIndex = (startItemIndex + itemsPerPage < dataList.length)
          ? startItemIndex + itemsPerPage
          : dataList.length;
      final pageItems = dataList.sublist(startItemIndex, endItemIndex);

      // Filter out empty or null values from pageItems
      final filteredPageItems = pageItems.where((row) => row.isNotEmpty).toList();

      if (filteredPageItems.isNotEmpty) {
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              final List<pw.Widget> content = [];

              final table = pw.Table.fromTextArray(
                data: filteredPageItems.map((row) => row.map((item) => item.toString()).toList()).toList(),
              );

              content.add(pw.Center(child: table));

              return pw.Column(children: content);
            },
          ),
        );
      }
    }

    final pdfData = await pdf.save();

    final blob = html.Blob([pdfData], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'example.pdf';

    html.document.body?.children.add(anchor);

    anchor.click();

    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future<void> pdfFunc() async {
    if (kIsWeb) {
      generateAndDownloadPDF(exportData);
    } else {
      UiDecoration().generatePDFDesktop(exportData);
    }
  }

  getVehicleId(){
    for(int i=0; i<vehicleDropdown.length;i++){
      if(vehicleDropdownValue == vehicleDropdown[i]['vehicle_number']){
        vehicleId = vehicleDropdown[i]['vehicle_id'];
      }
    }
  }

  setStateMounted(VoidCallback fn){
    if(mounted){
      setState(fn);
    }
  }

}
