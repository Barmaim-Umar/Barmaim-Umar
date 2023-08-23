import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

class FasTagAdvReport extends StatefulWidget {
  const FasTagAdvReport({Key? key}) : super(key: key);

  @override
  State<FasTagAdvReport> createState() => _FasTagAdvReportState();
}

List<String> assignDropdownList = ['All Vehicle', 'Not Assign', 'Assign'];
List<String> entriesDropdownList = ["10", "20", "30", "40"];

class _FasTagAdvReportState extends State<FasTagAdvReport> with Utility {
  // using to export data --> pdf , excel , etc
  List data = [];
  List<List<dynamic>> exportData = [];
  int freshLoad = 0;
  List fasTagTableList = [];
  List<String> vehicleNoList = [];
  List vehicleDropdown = [];
  String vehicleDropdownValue = '';
  String assignDropdownValue = assignDropdownList.first;
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

  // API
  advFasTagFetchApiFunc() {
    setStateMounted(() {
      freshLoad = 1;
    });
    advFasTagFetchApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        fasTagTableList.clear();
        fasTagTableList.addAll(info['data']);
        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.totalPages = info['total_pages'];
        GlobalVariable.currentPage = info['page'];
        GlobalVariable.next = info['next'];
        GlobalVariable.prev = info['prev'];
        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        setStateMounted(() {
          freshLoad = 0;
        });
        AlertBoxes.flushBarErrorMessage(info['message'], context);
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

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    GlobalVariable.totalRecords = 0;
    advFasTagFetchApiFunc();
    vehicleDropdownApiFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Advance FasTag List"),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              alignment: Alignment.centerLeft,
              child: TextDecorationClass().heading('Advance FasTag List'),
            ),
            const Divider(),
            // dropdown & search
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // entries dropdown
                  SizedBox(
                    width: 80,
                    child: SearchDropdownWidget(
                        dropdownList: entriesDropdownList,
                        hintText: "10",
                        onChanged: (value) {
                          entriesDropdownValue = value!;
                          advFasTagFetchApiFunc();
                        },
                        selectedItem: entriesDropdownValue,
                        showSearchBox: false,
                        maxHeight: 200),
                  ),
                  const Text(' entries'),
                  widthBox30(),
                  // Select Ledger / Customer
                  const SizedBox(
                    width: 10,
                  ),
                  const Spacer(),
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

                  const SizedBox(width: 10),
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
                    style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor, 100.0, 42.0),
                    onPressed: () {
                      advFasTagFetchApiFunc();
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
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Wrap(
                    runSpacing: 5,
                    // spacing: 0,
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
                      const SizedBox(width: 10),
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
                      const SizedBox(width: 10),
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
                  TextDecorationClass().subHeading2('Search : '),
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      decoration: UiDecoration().outlineTextFieldDecoration('Search', ThemeColors.primaryColor),
                      onChanged: (value) {
                        advFasTagFetchApiFunc();
                      },
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Cash Advance List
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: ThemeColors.primaryColor, borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "FasTag Advance List",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                      child: SizedBox(
                        width: double.maxFinite,

                        /// DataTable
                        child: freshLoad == 1
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : buildDataTable(),
                      ),
                    ),
                    // Pagination
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Total Records: ${GlobalVariable.totalRecords}"),

                        const SizedBox(width: 100),

                        // First Page Button
                        IconButton(
                            onPressed: !GlobalVariable.prev
                                ? null
                                : () {
                                    setState(() {
                                      GlobalVariable.currentPage = 1;
                                      advFasTagFetchApiFunc();
                                    });
                                  },
                            icon: const Icon(Icons.first_page)),

                        // Prev Button
                        IconButton(
                            onPressed: GlobalVariable.prev == false
                                ? null
                                : () {
                                    setState(() {
                                      GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                                      advFasTagFetchApiFunc();
                                    });
                                  },
                            icon: const Icon(Icons.chevron_left)),

                        const SizedBox(width: 30),

                        // Next Button
                        IconButton(
                            onPressed: GlobalVariable.next == false
                                ? null
                                : () {
                                    setState(() {
                                      GlobalVariable.currentPage++;
                                      advFasTagFetchApiFunc();
                                    });
                                  },
                            icon: const Icon(Icons.chevron_right)),

                        // Last Page Button
                        IconButton(
                            onPressed: !GlobalVariable.next
                                ? null
                                : () {
                                    setState(() {
                                      GlobalVariable.currentPage = GlobalVariable.totalPages;
                                      advFasTagFetchApiFunc();
                                    });
                                  },
                            icon: const Icon(Icons.last_page)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// DATATABLE ===========================
  Widget buildDataTable() {
    return /* cashTableList.isEmpty ? const Center(child: Text("cashTableList.isEmpty \nUpdating List..."),) : */
        DataTable(
            columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Vehicle Number')),
          DataColumn(label: Text('Driver Name')),
          DataColumn(label: Text('Total')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Remark')),
          DataColumn(label: Text('Entry By')),
          DataColumn(label: Text('Action')),
        ],
            rows: List.generate(fasTagTableList.length, (index) {
              return DataRow(color: MaterialStatePropertyAll(index == 0 || index % 2 == 0 ? ThemeColors.tableRowColor : Colors.white), cells: [
                DataCell(Text(UiDecoration().getFormattedDate(fasTagTableList[index]["transaction_date"].toString()))),
                DataCell(Text(fasTagTableList[index]['vehicle_number'].toString())),
                DataCell(Text(fasTagTableList[index]['driver_name'].toString())),
                const DataCell(Text('800')),
                DataCell(Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    color: fasTagTableList[index]['transaction_status'] == 1 ? ThemeColors.greenColor : Colors.orange,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    fasTagTableList[index]['transaction_status'] == 1 ? 'Success' : 'Pending',
                    style: const TextStyle(color: ThemeColors.whiteColor, fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                )),
                DataCell(Row(
                  children: [
                    // edit Icon
                    Container(
                        height: 20,
                        width: 20,
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              size: 15,
                              color: Colors.white,
                            ))),
                    Text(fasTagTableList[index]['remark'] ?? '_'),
                  ],
                )),
                DataCell(Text(fasTagTableList[index]['entry_by'].toString())),
                DataCell(Row(
                  children: [
                    // delete Icon
                    Container(
                        height: 20,
                        width: 20,
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(color: ThemeColors.darkRedColor, borderRadius: BorderRadius.circular(4)),
                        child: IconButton(
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
            }));
  }

  addDataToExport() {
    exportData.clear();
    exportData = [
      ['Date', 'Vehicle Number', 'Driver Name', 'Total', 'Status', 'Remark', 'Entry By'],
    ];
    for (int index = 0; index < data.length; index++) {
      List<String> rowData = [
        data[index]['transaction_date'].toString(),
        data[index]['vehicle_id'].toString(),
        'Santosh',
        '800',
        'Pending',
        data[index]['remark'].toString(),
        'ZK',
      ];
      exportData.add(rowData);
    }
  }

  // API
  Future advFasTagFetchApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        "${GlobalVariable.baseURL}Account/FastTagTransactionReport?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&keyword=${searchController.text}&from_date=${fromDateApi.text}&to_date=${toDateApi.text}");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  Future exportDataApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        "${GlobalVariable.baseURL}Account/FastTagTransactionReport?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&keyword=${searchController.text}&from_date=${fromDateApi.text}&to_date=${toDateApi.text}");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
