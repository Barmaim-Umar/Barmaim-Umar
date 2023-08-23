import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:http/http.dart' as http;
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/Widgets/searchDataTable.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class AdvanceAtmList extends StatefulWidget {
  const AdvanceAtmList({Key? key}) : super(key: key);

  @override
  State<AdvanceAtmList> createState() => _AdvanceAtmListState();
}

List<String> vehicleList = [];
List<String> entriesDropdownList = ["10", "20", "30", "40"];

class _AdvanceAtmListState extends State<AdvanceAtmList> with Utility {
  List advAtmTransactionList = [];
  List advAtmTransactionColumnName = [
    {'column_name': 'Date', 'column_value': 'accounts__transactions.transaction_date'},
    {'column_name': 'Vehicle Number', 'column_value': 'vehicles.vehicle_number'},
    {'column_name': 'Driver Name', 'column_value': 'vehicles__drivers_profile.driver_name'},
    {'column_name': 'Total', 'column_value': 'amount'},
    {'column_name': 'Status', 'column_value': 'accounts__transactions.transaction_status'},
    {'column_name': 'Remark', 'column_value': 'accounts__transactions.remark'},
    {'column_name': 'Entry By', 'column_value': 'accounts__transactions.entry_by'},
    {'column_name': 'Action', 'column_value': 'vehicles__drivers_group.drivers_group_id'}
  ];
  String vehicleDropdownValue = '';
  String entriesDropdownValue = entriesDropdownList.first;
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var vehicleId = '';
  var next;
  var prev;
  var totalPages;
  var keyword;
  int currentPage = 1;
  var currentIndex = 2;
  int freshLoad = 0;
  List vehicleList2 = [];
  ValueNotifier<String> vehicle = ValueNotifier("");
  TextEditingController searchController = TextEditingController();
  List data = [];
  List<List<dynamic>> exportData = [];

  advAtmTransactionListApiFunc() {
    setStateMounted(() {
      freshLoad = 1;
    });
    advAtmTransactionListApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        advAtmTransactionList.clear();
        advAtmTransactionList.addAll(info['data']);
        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.totalPages = info['total_pages'];
        GlobalVariable.currentPage = info['page'];
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
    exportDataApi().then((value) {
      data.clear();
      exportData.clear();
      var info = jsonDecode(value);
      if (info['success'] == true) {
        data.addAll(info['data']);
        setStateMounted(() {
          freshLoad = 0;
        });
      }
    });
  }

  vehicleDropdownApiFunc() {
    vehicleDropdownApi().then((value) {
      vehicleList2.clear();
      vehicleList.clear();
      var info = jsonDecode(value);
      if (info['success'] == true) {
        for (int i = 0; i < info['data'].length; i++) {
          vehicleList.add(info['data'][i]['vehicle_number']);
        }
        vehicleList2.addAll(info['data']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    GlobalVariable.currentPage = 1;
    GlobalVariable.totalRecords = 0;
    advAtmTransactionListApiFunc();
    vehicleDropdownApiFunc();
    keyword = advAtmTransactionColumnName[2]['column_value'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Advance Atm List"),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // dropdown | From date | To Date
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // entries dropdown
                  Container(
                    height: 35,
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade400)),
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
                        setStateMounted(() {
                          entriesDropdownValue = newValue!;
                          advAtmTransactionListApiFunc();
                        });
                      },
                      items: entriesDropdownList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const Text(' entries'),
                  widthBox20(),
                  const Spacer(),
                  // Vehicle type dropdown
                  Expanded(
                    flex: 1,
                    child: SearchDropdownWidget(
                      maxHeight: 500,
                      dropdownList: vehicleList,
                      hintText: 'Select Vehicle',
                      onChanged: (p0) {
                        setStateMounted(() {
                          vehicleDropdownValue = p0!;
                          for (int i = 0; i < vehicleList2.length; i++) {
                            if (vehicleDropdownValue == vehicleList2[i]['vehicle_number']) {
                              vehicleId = vehicleList2[i]['vehicle_id'];
                            }
                          }
                          advAtmTransactionListApiFunc();
                        });
                      },
                      selectedItem: vehicleDropdownValue,
                    ),
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
                      setStateMounted(() {
                        vehicle.value = "";
                      });

                      searchController.clear();
                      advAtmTransactionListApiFunc();
                    },
                    child: const Text("Filter"),
                  ),
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
                    children: [
                      BStyles().button(
                        'Excel',
                        'Export to Excel',
                        "assets/excel.png",
                        onPressed: () {
                          setStateMounted(() {
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
                          setStateMounted(() {
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
                          setStateMounted(() {
                            addDataToExport();
                          });
                          UiDecoration().generatePrintDocument(exportData);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // All LRs | All Time Record
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: ThemeColors.primaryColor, borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Atm Advance List",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            heightBox20(),
            // DataTable
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: freshLoad == 1
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: DataTable(
                              columns: List.generate(
                                advAtmTransactionColumnName.length,
                                (index) => DataColumn(
                                  label: InkWell(
                                    focusColor: Colors.white,
                                    hoverColor: Colors.white,
                                    onTap: () {
                                      setStateMounted(() {
                                        currentIndex = index;
                                        keyword = advAtmTransactionColumnName[index]['column_value'];
                                      });
                                    },
                                    child: SearchDataTable(
                                        onFieldSubmitted: (p0) {
                                          advAtmTransactionListApiFunc();
                                        },
                                        isSelected: index == 7 ? false : index == currentIndex,
                                        search: searchController,
                                        columnName: advAtmTransactionColumnName[index]['column_name']),
                                  ),
                                ),
                              ),
                              showCheckboxColumn: false,
                              columnSpacing: 0,
                              horizontalMargin: 10,
                              sortAscending: true,
                              sortColumnIndex: 0,
                              rows: List.generate(advAtmTransactionList.length, (index) {
                                return DataRow(
                                  color: MaterialStatePropertyAll(index == 0 || index % 2 == 0 ? ThemeColors.tableRowColor : Colors.white),
                                  cells: [
                                    DataCell(Text(UiDecoration().getFormattedDate( advAtmTransactionList[index]
                                    ['transaction_date']
                                        .toString()))),
                                    // DataCell(Text(advAtmTransactionList[index]['transaction_date'].toString())),
                                    DataCell(Text(advAtmTransactionList[index]['vehicle_number'].toString())),
                                    DataCell(Text(advAtmTransactionList[index]['driver_name'].toString())),
                                    DataCell(Text(advAtmTransactionList[index]['credit'] == '0' ? advAtmTransactionList[index]['debit'] : advAtmTransactionList[index]['credit'].toString())),
                                    DataCell(Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: advAtmTransactionList[index]['transaction_status'] == 1 ? ThemeColors.greenColor : Colors.orange,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        advAtmTransactionList[index]['transaction_status'] == 1 ? 'Success' : 'Pending',
                                        style: const TextStyle(color: ThemeColors.whiteColor, fontWeight: FontWeight.w500, fontSize: 15),
                                      ),
                                    )),
                                    DataCell(Text(advAtmTransactionList[index]['remark'].toString())),
                                    DataCell(Text(advAtmTransactionList[index]['user_name'].toString())),
                                    DataCell(
                                      Row(
                                        children: [
                                          UiDecoration().actionButton(
                                            ThemeColors.deleteColor,
                                            IconButton(
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          )
                        ],
                      ),
              ),
            ),
            // Pagination
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
                              advAtmTransactionListApiFunc();
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
                              advAtmTransactionListApiFunc();
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
                              advAtmTransactionListApiFunc();
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
                              advAtmTransactionListApiFunc();
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

  addDataToExport() {
    exportData.clear();
    exportData = [
      ['Date', 'Voucher Number', 'Particulars', 'Amount'],
    ];
    for (int index = 0; index < data.length; index++) {
      List<String> rowData = [
        data[index]['transaction_date'].toString(),
        data[index]['vehicle_number'].toString(),
        data[index]['driver_name'].toString(),
        data[index]['credit'] == '0' ? data[index]['debit'] : data[index]['credit'].toString(),
        data[index]['transaction_status'] == 1 ? 'Success' : 'Pending',
        data[index]['remark'].toString(),
        data[index]['entry_by'].toString(),
      ];
      exportData.add(rowData);
    }
  }

  Future advAtmTransactionListApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.baseURL}Account/ATMTransactionReport?limit=$entriesDropdownValue&from_date=${fromDateApi.text}&to_date=${toDateApi.text}&page=${GlobalVariable.currentPage}&keyword=${searchController.text}&column=$keyword&filter=$vehicleId');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  Future exportDataApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.baseURL}Account/ATMTransactionReport?limit=$entriesDropdownValue&from_date=${fromDateApi.text}&to_date=${toDateApi.text}&page=${GlobalVariable.currentPage}&keyword=${searchController.text}&column=$keyword&filter=$vehicleId');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  Future vehicleDropdownApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse('${GlobalVariable.baseURL}Vehicle/VehicleFetch');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
