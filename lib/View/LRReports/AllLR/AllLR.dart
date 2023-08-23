import 'dart:convert';
import 'package:flutter/foundation.dart';
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

class AllLR extends StatefulWidget {
  const AllLR({Key? key}) : super(key: key);

  @override
  State<AllLR> createState() => _AllLRState();
}

List<String> selectLedgerNameList = [];
List selectLedgerList = [];
List<String> fromLocationList = ['Location1' , 'Location2' , 'Location3' , 'Location4' , 'Location5'];
List<String> toLocationList = ['Location1' , 'Location2' , 'Location3' , 'Location4' , 'Location5'];
List<String> assignDropdownList = ['Select Vehicle','All Vehicle' , 'Not Assign' , 'Assign'];
List<String> vehicleTypeList = ['Select Vehicle Type' , '1' , '2' , '3' , '4'];
List<String> statusList = ['Select Status' , 'On Road' , 'Unloaded' , 'Empty'];
List<String> entriesDropdownList = ["10" ,"20" ,"30" ,"40"];

class _AllLRState extends State<AllLR> with Utility{

  int freshLoad = 0;

  String selectLedgerValue = "";
  String fromLocationValue = fromLocationList.first;
  String toLocationValue = toLocationList.first;
  String vehicleTypeValue = vehicleTypeList.first;
  String statusValue = statusList.first;
  String assignDropdownValue = assignDropdownList.first;
  String entriesDropdownValue = entriesDropdownList.first;
  TextEditingController fromDateUi = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController toDateUi = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? ledgerID;
  List allLRList = [];
  List data = [];
  List<List<dynamic>> exportData = [];
  var lrID;

  // API
  lrFetchApiFunc(){
    setStateMounted(() {
      freshLoad = 1;
    });
    lrFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        allLRList.clear();
        allLRList.addAll(info['data']);
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
        exportData.clear();
        data.clear();
        data.addAll(info['data']);
        setStateMounted(() {
          freshLoad = 0;
          addDataToExport();
        });
      }else{
        setStateMounted(() {
          freshLoad = 0;
        });
      }
    });
  }

  lrDeleteApiFunc(){
    lrDeleteApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  ledgerFetchApiFunc(){
    ServiceWrapper().ledgerFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        selectLedgerList.addAll(info['data']);

        for(int i=0; i<info['data'].length; i++){
          selectLedgerNameList.add(info['data'][i]['ledger_title']);
        }
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    ledgerFetchApiFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("All LR"),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              alignment: Alignment.centerLeft,
              child: TextDecorationClass().heading('All LR'),
            ),
            const Divider(),
            // dropdown & search
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // entries dropdown
                      const Text('Show '),
                      SizedBox(
                        width: 80,
                        child: SearchDropdownWidget(
                            showSearchBox: false,
                            maxHeight: 200,
                            dropdownList: entriesDropdownList,
                            hintText: entriesDropdownList.first,
                            onChanged: (value) {
                              entriesDropdownValue = value!;
                              setState(() {
                                lrFetchApiFunc();
                              });
                            },
                            selectedItem: entriesDropdownValue
                        ),
                      ),
                      const Text(' entries'),
                      widthBox20(),

                      // Select Ledger / Customer
                      Expanded(
                        child: SearchDropdownWidget(
                          dropdownList: selectLedgerNameList,
                          hintText: "Select Ledger",
                          onChanged: (value) {
                            selectLedgerValue = value!;
                            lrFetchApiFunc();
                            // get ledger id
                            for(int i=0; i<selectLedgerList.length; i++){
                              if(selectLedgerValue == selectLedgerList[i]['ledger_title']){
                                ledgerID = selectLedgerList[i]['ledger_id'];
                              }
                            }

                          },
                          selectedItem: selectLedgerValue,
                        ),
                      ),
                      widthBox20(),

                      // Select From Location
                      Expanded(
                        child: SearchDropdownWidget(
                            dropdownList: fromLocationList,
                            hintText: "Select From Location",
                            onChanged: (value) {
                              fromLocationValue = value!;
                            },
                            selectedItem: fromLocationValue),
                      ),
                      widthBox20(),

                      // Select To Location
                      Expanded(
                        child: SearchDropdownWidget(
                            dropdownList: toLocationList,
                            hintText: "Select To Location",
                            onChanged: (value) {
                              toLocationValue = value!;
                            },
                            selectedItem: toLocationValue
                        ),
                      ),
                      widthBox20(),

                      // Vehicle type dropdown
                      Expanded(
                        child: SearchDropdownWidget(
                            dropdownList: assignDropdownList,
                            hintText: "Select Vehicle",
                            onChanged: (value) {
                              assignDropdownValue = value!;
                            },
                            selectedItem: assignDropdownValue),
                        // child: Container(
                        //   height: 35,
                        //   width: 400,
                        //   padding: const EdgeInsets.symmetric(horizontal: 10),
                        //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
                        //   child: DropdownButton<String>(
                        //     borderRadius: BorderRadius.circular(5),
                        //     dropdownColor: ThemeColors.whiteColor,
                        //     underline: Container(
                        //       decoration: const BoxDecoration(border: Border()),
                        //     ),
                        //     isExpanded: true,
                        //     hint: const Text(
                        //       'All Vehicles',
                        //       style: TextStyle(color: ThemeColors.darkBlack),
                        //     ),
                        //     icon: const Icon(
                        //       CupertinoIcons.chevron_down,
                        //       color: ThemeColors.darkBlack,
                        //       size: 15,
                        //     ),
                        //     iconSize: 30,
                        //     value: assignDropdownValue,
                        //     elevation: 16,
                        //     style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                        //     onChanged: (String? newValue) {
                        //       // This is called when the user selects an item.
                        //       setState(() {
                        //         assignDropdownValue = newValue!;
                        //       });
                        //     },
                        //     items: assignDropdownList.map<DropdownMenuItem<String>>((String value) {
                        //       return DropdownMenuItem<String>(
                        //         value: value.toString(),
                        //         child: Center(child: Text(value)),
                        //       );
                        //     }).toList(),
                        //   ),
                        // ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      // Vehicle type dropdown
                      Expanded(
                        child: SearchDropdownWidget(
                            dropdownList: vehicleTypeList,
                            hintText: "Select Vehicle Type",
                            onChanged: (value) {
                              vehicleTypeValue = value!;
                            },
                            selectedItem: vehicleTypeValue
                        ),

                      ),
                      widthBox10(),

                      // Vehicle Status dropdown
                      Expanded(
                        child: SearchDropdownWidget(
                            dropdownList: statusList,
                            hintText: "Select Vehicle Status",
                            onChanged: (value) {
                              statusValue = value!;
                            },
                            selectedItem: statusValue
                        ),
                      ),
                      widthBox10(),
                      /// to date
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
                        style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor,100.0,42.0),
                        onPressed: () {
                          setState(() {
                            lrFetchApiFunc();
                          });
                        },
                        child: const Text("Filter"),
                      ),
                    ],
                  )
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
                      BStyles().button('Excel', 'Export to Excel', "assets/excel.png",onPressed: () {
                        setState(() {
                          addDataToExport();
                        });
                        UiDecoration().excelFunc(exportData);
                      },),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button('PDF', 'Export to PDF', "assets/pdf.png",onPressed: () {
                        setState(() {
                          addDataToExport();
                        });
                        pdfFunc();
                      },),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button('Print', 'Print', "assets/print.png",onPressed: () {
                        ledgerFetchApiFunc();
                        UiDecoration().generatePrintDocument(exportData);
                      },),
                    ],
                  ),
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search : '),
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      decoration:
                      UiDecoration().outlineTextFieldDecoration('Search',ThemeColors.primaryColor),
                      onChanged: (value) {
                        lrFetchApiFunc();
                      },
                    ),
                  ),
                  const SizedBox(width: 10,)
                ],
              ),
            ),

            const SizedBox(height: 20,),

            // All LRs | All Time Record
            Container(
              margin: const EdgeInsets.only(left: 10 , right: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration:  BoxDecoration(color: ThemeColors.primaryColor , borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("All LRs | All Time Records" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                ],),
            ),
            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                          child:

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: freshLoad==1? const Center(child: CircularProgressIndicator(),): DataTable(
                                columns: const [
                                  DataColumn(label: Text('LR No.')),
                                  DataColumn(label: Text('LR Date')),
                                  DataColumn(label: Text('Ledger')),
                                  DataColumn(label: Text('Vehicle No.')),
                                  DataColumn(label: Text('From Location')),
                                  DataColumn(label: Text('To Location')),
                                  DataColumn(label: Text('Reported Date')),
                                  DataColumn(label: Text('Unloaded Date')),
                                  DataColumn(label: Text('Bill No')),
                                  DataColumn(label: Text('LR Remark')),
                                  DataColumn(label: Text('Bill Status')),
                                  DataColumn(label: Text('Trip Status')),
                                  DataColumn(label: Text("Actions"),),
                                ],
                                rows: List.generate(allLRList.length, (index) {
                                  return  DataRow(
                                      cells: [
                                        DataCell(Text(allLRList[index]['lr_number'].toString())),
                                        DataCell(Text(allLRList[index]['lr_date'].toString())),
                                        DataCell(Text(allLRList[index]['ledger_id'].toString())),
                                        DataCell(Text(allLRList[index]['vehicle_id'].toString())),
                                        DataCell(Text(allLRList[index]['from_location'].toString())),
                                        DataCell(Text(allLRList[index]['to_location'].toString())),
                                        // Reported date
                                        DataCell(Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(allLRList[index]['reported_date'].toString()),
                                            // edit Icon
                                            Container(
                                                height: 20,
                                                width:20,
                                                margin: const EdgeInsets.all(1),
                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                                                child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
                                          ],)),
                                        // Unloaded date
                                        DataCell(Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(allLRList[index]['unloaded_date'].toString()),
                                            // edit Icon
                                            Container(
                                                height: 20,
                                                width:20,
                                                margin: const EdgeInsets.all(1),
                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                                                child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
                                          ],)),
                                        DataCell(Text(allLRList[index]['bill_id'].toString())),
                                        // LR Remark
                                        DataCell(Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(allLRList[index]['lr_remark'].toString()),
                                            // edit Icon
                                            Container(
                                                height: 20,
                                                width:20,
                                                margin: const EdgeInsets.all(1),
                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                                                child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
                                          ],)),
                                        // Bill Status
                                        DataCell(
                                            allLRList[index]['lr_status'] == 0 ?
                                            Container(padding: const EdgeInsets.only(left: 8 , right: 8 , bottom: 6 , top: 4),decoration: BoxDecoration(color: Colors.grey , borderRadius: BorderRadius.circular(4)),
                                              child: const Text("Pending",style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500 , fontSize: 13),),)
                                                : // If lr_status == 1
                                            Container(padding: const EdgeInsets.only(left: 8 , right: 8 , bottom: 6 , top: 4),decoration: BoxDecoration(color: Colors.green , borderRadius: BorderRadius.circular(4)),
                                              child: const Text("Done",style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500 , fontSize: 13),),)
                                        ),
                                        // Trip Status
                                        DataCell(Container(padding: const EdgeInsets.only(left: 8 , right: 8 , bottom: 6 , top: 4),decoration: BoxDecoration(color: Colors.grey , borderRadius: BorderRadius.circular(4)),
                                          child: const Text("Pending",style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500 , fontSize: 13),),)),
                                        // Action Button
                                        // delete Icon
                                        DataCell(Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 20,
                                                width: 20,
                                                margin: const EdgeInsets.all(1),
                                                decoration: BoxDecoration(color: ThemeColors.darkRedColor, borderRadius: BorderRadius.circular(5)),
                                                child: IconButton(padding: const EdgeInsets.all(0),
                                                    onPressed: () {
                                                      lrID = allLRList[index]['lr_id'];

                                                      setState(() {
                                                        lrFetchApiFunc();
                                                        lrDeleteApiFunc();
                                                      });
                                                    },
                                                    icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),
                                          ],
                                        ),),
                                      ]
                                  );
                                })
                            ),
                          ),

                        ),

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
                                lrFetchApiFunc();
                              });

                            }, icon: const Icon(Icons.first_page)),

                            // Prev Button
                            IconButton(
                                onPressed: GlobalVariable.prev == false ? null : () {
                                  setState(() {
                                    GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                                    lrFetchApiFunc();
                                  });
                                }, icon: const Icon(Icons.chevron_left)),

                            const SizedBox(width: 30,),

                            // Next Button
                            IconButton  (
                                onPressed: GlobalVariable.next == false ? null : () {
                                  setState(() {
                                    GlobalVariable.currentPage++;
                                    lrFetchApiFunc();
                                  });
                                }, icon: const Icon(Icons.chevron_right)),

                            // Last Page Button
                            IconButton(onPressed: !GlobalVariable.next ? null : () {
                              setState(() {
                                GlobalVariable.currentPage = GlobalVariable.totalPages;
                                lrFetchApiFunc();
                              });

                            }, icon: const Icon(Icons.last_page)),
                          ],
                        ),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
  uploadDocuments(){
    return  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextDecorationClass().heading("New Order"),
            const Divider(),
          ],
        ),
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: const [

            ],
          );
        }),
        actions: <Widget>[
          // Cancel Button
          TextButton(
            onPressed: (){
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Cancel'),
          ),
          // OK Button
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
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

  Future<void> pdfFunc() async {
    if (kIsWeb) {
      UiDecoration().generatePDFWeb(exportData);
    } else {
      UiDecoration().generatePDFDesktop(exportData);
    }
  }

  // API
  Future lrFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}LR/LRFetch?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }


  Future exportDataApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}LR/LRFetch?from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future lrDeleteApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}LR/LRDelete?lr_id=$lrID");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }

}

