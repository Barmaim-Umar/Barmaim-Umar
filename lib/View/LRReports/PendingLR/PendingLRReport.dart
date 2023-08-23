import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/Widgets/searchDataTable.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class PendingLRReport extends StatefulWidget {
  const PendingLRReport({Key? key}) : super(key: key);

  @override
  State<PendingLRReport> createState() => _PendingLRReportState();
}

List<String> vehicleTypeList = ['Not Assign', 'Assign'];
List<String> receivedByList = [
  'Nasir Pathan',
  'Mohammed Bajaman',
  'Sayyed Sohil'
];
List<String> selectLedgerNameList = [];
List<String> entriesDropdownList = ["10", "20", "30", "40"];

class _PendingLRReportState extends State<PendingLRReport> with Utility {
  List driverColumnName = [
    {
      'column_name': 'LR No.',
      'column_value':'lr_id',
    },
    {
      'column_name': 'LR Date',
      'column_value': 'lr.lr_date'
    },
    {
      'column_name':'Ledger',
      'column_value':'ledger.ledger_title'

    },
    {
      'column_name': 'Vehicle No.',
      'column_value':'lr.vehicle_id'
    },
    {
      'column_name': 'From Location',
      'column_value': 'lr.from_location'
    },
    {
      'column_name': 'To Location',
      'column_value':'lr.to_location'
    },
    {
      'column_name': 'Reported Date',
      'column_value': 'lr.reported_date'
    },
    {
      'column_name': 'Unloaded Date',
      'column_value': 'lr.unloaded_date'
    },
    {
      'column_name': 'Action',
      'column_value': ''
    },
  ];
  String vehicleTypeDropdownValue = "";
  String selectLedgerValue = "";
  String entriesDropdownValue = entriesDropdownList.first;
  String receivedByDropdownValue = receivedByList.first;
  TextEditingController fromDateUi = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController toDateUi = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController receivedDate = TextEditingController();
  TextEditingController haltDays = TextEditingController();
  TextEditingController totalHaltAmount = TextEditingController();
  TextEditingController unloadingCharges = TextEditingController();
  TextEditingController remark = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int currentIndex = 2;
  List selectLedgerList = [];
  List pendingLRReportList = [];
  List data = [];
  List<List<dynamic>> exportData = [];
  var ledger_id;

  int freshLoad = 0;

  var keyword;

  // API
  pendingLRFetchApiFunc(){
    setStateMounted(() {
      freshLoad = 1;
    });
    pendingLRFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        pendingLRReportList.clear();
        pendingLRReportList.addAll(info['data']);
        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.totalPages = info['total_pages'];
        GlobalVariable.currentPage = info['page'];
        GlobalVariable.next = info['next'];
        GlobalVariable.prev = info['prev'];

        setStateMounted(() {
          freshLoad = 0;
        });
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);

        setStateMounted(() {
          freshLoad = 0;
        });
      }
    });
    exportDataApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        data.clear();
        exportData.clear();
        data.addAll(info['data']);
        setStateMounted(() {
          freshLoad = 0;
        });
      }else{
        setStateMounted(() {
          freshLoad = 0;
        });
      }
    });
  }

  // ledger dropdown api
  ledgerDropdownApiFunc(){
    ServiceWrapper().ledgerFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        selectLedgerList.addAll(info['data']);
        for(int i=0; i<info['data'].length; i++){
          selectLedgerNameList.add(info['data'][i]['ledger_title']);
        }
      }
    });
  }

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    pendingLRFetchApiFunc();
    ledgerDropdownApiFunc();
    keyword = driverColumnName[2]['column_value'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Pending LR Report"),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
                  SizedBox(
                    width: 80,
                    child: SearchDropdownWidget(
                      dropdownList: entriesDropdownList,
                      hintText: entriesDropdownList.first,
                      onChanged:(value) {
                        entriesDropdownValue = value!;
                        pendingLRFetchApiFunc();
                      },
                      selectedItem: entriesDropdownValue,
                      maxHeight: 200,
                      showSearchBox: false,
                    ),
                  ),

                  const Text(' entries'),
                  widthBox20(),

                  // Select Ledger / Customer
                  Expanded(child: SearchDropdownWidget(
                      dropdownList: selectLedgerNameList,
                      hintText: "Select Ledger",
                      onChanged: (value) {
                        selectLedgerValue = value!;
                        getLedgerId();
                        pendingLRFetchApiFunc();
                      },
                      selectedItem: selectLedgerValue)
                  ),

                  const SizedBox(width: 10,),

                  // Vehicle type dropdown
                  Expanded(child: SearchDropdownWidget(
                    dropdownList: vehicleTypeList,
                    hintText: "Please Select Value",
                    onChanged: (value) {
                      vehicleTypeDropdownValue = value!;

                    },
                    selectedItem: vehicleTypeDropdownValue,
                    showSearchBox: false,
                    maxHeight: 100,
                  )),

                  const SizedBox(width: 10,),

                  /// From Date
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: fromDateUi,
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
                  //             fromDateUi.text = "$day-$month-${value.year}";
                  //             fromDateApi.text = "${value.year}-$month-$day";
                  //           });
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),

                  widthBox10(),
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
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: toDateUi,
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
                  //             toDateUi.text = "$day-$month-${value.year}";
                  //             toDateApi.text = "${value.year}-$month-$day";
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
                    onPressed: () {
                      pendingLRFetchApiFunc();
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
                        // ExclForWeb().exportToExcelWeb(exportData);
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
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search : '),
                  // Search
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      decoration: UiDecoration().outlineTextFieldDecoration('Search', ThemeColors.primaryColor),
                      onChanged: (value) {
                        pendingLRFetchApiFunc();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),

            const SizedBox(height: 20,),

            // All LRs | All Time Record
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
            heightBox20(),
            // DataTable
            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                            child:  freshLoad == 1 ? const Center(child: CircularProgressIndicator(),) :  DataTable(
                                columns:List.generate(driverColumnName.length, (index) =>
                                    DataColumn(label: InkWell(
                                      focusColor: Colors.white,
                                      hoverColor: Colors.white,
                                      onTap: () {
                                        setState(() {
                                          searchController.text='';
                                          currentIndex = index;
                                          keyword = driverColumnName[index]['column_value'];
                                        });
                                      }, child: SearchDataTable(
                                        onFieldSubmitted: (p0) {
                                          pendingLRFetchApiFunc();
                                        },
                                        isSelected: index==9||index==1?false:index == currentIndex,
                                        search: searchController,
                                        columnName: driverColumnName[index]['column_name']),
                                    ),
                                    ),
                                ),
                                showCheckboxColumn: false,
                                columnSpacing: 90,
                                horizontalMargin: 10,
                                sortAscending: true,
                                sortColumnIndex: 0,
                                rows: List.generate(pendingLRReportList.length,
                                        (index) {
                                      return DataRow(
                                        color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
                                        cells: [
                                          // LR No.
                                          DataCell(

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(pendingLRReportList[index]['lr_number'].toString()),
                                                  UiDecoration().actionButton(
                                                      ThemeColors.editColor,
                                                      IconButton(
                                                          padding:const EdgeInsets.all(0),
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            size: 15,
                                                            color: Colors.white,
                                                          )))
                                                ],
                                              )),

                                          // LR Date
                                          DataCell(
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(pendingLRReportList[index]['lr_date'].toString()),
                                                  UiDecoration().actionButton(
                                                      ThemeColors.editColor,
                                                      IconButton(
                                                          padding: const EdgeInsets.all(0),
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            size: 15,
                                                            color: Colors.white,
                                                          )))
                                                ],
                                              )),

                                          // Ledger
                                          DataCell(Text(pendingLRReportList[index]['ledger_title'].toString())),

                                          // Vehicle No.
                                          DataCell(Text(pendingLRReportList[index]['vehicle_id'].toString())),

                                          // From Location.
                                          DataCell(Text(pendingLRReportList[index]['from_location'])),

                                          // To Location
                                          DataCell(Text(pendingLRReportList[index]['to_location'].toString())),

                                          // Reported Date
                                          DataCell(Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(pendingLRReportList[index]['reported_date'].toString()),
                                              UiDecoration().actionButton(
                                                  ThemeColors.editColor,
                                                  IconButton(
                                                      padding: const EdgeInsets.all(0),
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        size: 15,
                                                        color: Colors.white,
                                                      )))
                                            ],
                                          )),

                                          // Unloaded Date
                                          DataCell(Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(pendingLRReportList[index]['unloaded_date'].toString()),
                                              UiDecoration().actionButton(
                                                  ThemeColors.editColor,
                                                  IconButton(
                                                      padding: const EdgeInsets.all(0),
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        size: 15,
                                                        color: Colors.white,
                                                      )))
                                            ],
                                          )),

                                          // Action
                                          DataCell(InkWell(
                                            onTap: () {
                                              receivedLRDialogue();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                              child: const Text('Received LR',
                                                style: TextStyle(
                                                    color: ThemeColors.whiteColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ))
                                        ],
                                        onSelectChanged: (value) {},
                                      );
                                    })),
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
                    pendingLRFetchApiFunc();
                  });

                }, icon: const Icon(Icons.first_page)),

                // Prev Button
                IconButton(
                    onPressed: GlobalVariable.prev == false ? null : () {
                      setState(() {
                        GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                        pendingLRFetchApiFunc();
                      });
                    }, icon: const Icon(Icons.chevron_left)),

                const SizedBox(width: 30,),

                // Next Button
                IconButton  (
                    onPressed: GlobalVariable.next == false ? null : () {
                      setState(() {
                        GlobalVariable.currentPage++;
                        pendingLRFetchApiFunc();
                      });
                    }, icon: const Icon(Icons.chevron_right)),

                // Last Page Button
                IconButton(onPressed: !GlobalVariable.next ? null : () {
                  setState(() {
                    GlobalVariable.currentPage = GlobalVariable.totalPages;
                    pendingLRFetchApiFunc();
                  });

                }, icon: const Icon(Icons.last_page)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  receivedLRDialogue() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextDecorationClass().heading('Received LR'),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    CupertinoIcons.xmark,
                    size: 15,
                    color: Colors.grey,
                  )),
            ],
          ),
          contentPadding: const EdgeInsets.only(top: 8,right: 8,left: 8,bottom: 50),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextDecorationClass().heading1("Received Date"),
                          TextFormField(
                            decoration: UiDecoration().outlineTextFieldDecoration(
                                'Received Date', ThemeColors.primaryColor),
                            // controller: fromDate,
                            onTap: () {
                              UiDecoration()
                                  .showDatePickerDecoration(context)
                                  .then((value) {
                                setState(() {
                                  // String month =
                                  //     value.month.toString().padLeft(2, '0');
                                  // String day =
                                  //     value.day.toString().padLeft(2, '0');
                                  // fromDate.text = "${value.year}-$month-$day";
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextDecorationClass().heading1("No Of Halt Days"),
                          TextFormField(
                            controller: haltDays,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: UiDecoration().outlineTextFieldDecoration(
                                'No Of Halt Days  ', ThemeColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextDecorationClass().heading1("Total Halt Amount"),
                          TextFormField(
                            controller: totalHaltAmount,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: UiDecoration().outlineTextFieldDecoration(
                                'Total Halt Amount', ThemeColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                heightBox10(),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextDecorationClass().heading1("Unloading Charges"),
                          TextFormField(
                            controller: unloadingCharges,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: UiDecoration().outlineTextFieldDecoration(
                                'Unloading Charges', ThemeColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextDecorationClass().heading1("Remark"),
                          TextFormField(
                            controller: remark,
                            decoration: UiDecoration().outlineTextFieldDecoration(
                                'Remark', ThemeColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextDecorationClass().heading1("Received By"),
                          UiDecoration().dropDown(
                            0,
                            DropdownButton<String>(
                              borderRadius: BorderRadius.circular(5),
                              dropdownColor: ThemeColors.whiteColor,
                              underline: Container(
                                decoration: const BoxDecoration(border: Border()),
                              ),
                              isExpanded: true,
                              hint: const Text(
                                'Received By',
                                style: TextStyle(color: ThemeColors.darkBlack),
                              ),
                              icon: const Icon(
                                CupertinoIcons.chevron_down,
                                color: ThemeColors.darkBlack,
                                size: 15,
                              ),
                              iconSize: 30,
                              value: receivedByDropdownValue,
                              elevation: 16,
                              style: const TextStyle(
                                  color: ThemeColors.darkGreyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis),
                              onChanged: (String? newValue) {
                                // This is called when the user selects an item.
                                setState(() {
                                  receivedByDropdownValue = newValue!;
                                });
                              },
                              items: receivedByList
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: Center(child: Text(value)),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyles.customiseButton(ThemeColors.primary, ThemeColors.whiteColor, 100.0, 40.0),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Received'),
            ),
            ElevatedButton(
              style: ButtonStyles.customiseButton(ThemeColors.grey, ThemeColors.whiteColor, 100.0, 40.0),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  addDataToExport(){
    exportData.clear();
    exportData=[
      ['LR No.','LR Date','Ledger','Vehicle No.','From Location','To Location','Reported Date','Unloaded Date','Bill No','LR Remark','Bill Status'],
    ];
    for (int index = 0; index < data.length; index++) {
      List<String> rowData = [
        data[index]['lr_number'].toString(),
        data[index]['lr_date'].toString(),
        data[index]['ledger_id'].toString(),
        data[index]['vehicle_id'].toString(),
        data[index]['from_location'].toString(),
        data[index]['to_location'].toString(),
        data[index]['reported_date'].toString(),
        data[index]['unloaded_date'].toString(),
        data[index]['bill_id'].toString(),
        data[index]['lr_remark'].toString(),
        data[index]['lr_status'] == 0 ?'Pending':'Done'
      ];
      exportData.add(rowData);
    }
  }

  // API
  Future pendingLRFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}LR/PendingLR?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}&filter=$ledger_id&column=$keyword");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }


  Future exportDataApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}LR/PendingLR?from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}&filter=$ledger_id&column=$keyword");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }

  getLedgerId(){
    for(int i=0; i<selectLedgerList.length;i++){
      if(selectLedgerValue==selectLedgerList[i]['ledger_title']){
        ledger_id = selectLedgerList[i]['ledger_id'];
        print(ledger_id);
      }
    }
  }

}
