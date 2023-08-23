import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/View/VehicleManage/DriverAssignHistory/DriverHistory.dart';
import 'package:pfc/View/VehicleManage/NewDriver/DriverDetails.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/Widgets/searchDataTable.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/View/VehicleManage/DriverTimeline/TimelinePostAndList.dart';
import 'package:http/http.dart' as http;
import 'package:pfc/utility/utility.dart';

class DriversList extends StatefulWidget {
  const DriversList({Key? key}) : super(key: key);

  @override
  State<DriversList> createState() => _DriversListState();
}

List<String> assignDropdownList = ['Assign' , 'Not Assign' , 'Assign/Not Assign'];
List<String> entriesDropdownList = ["10" ,"20" ,"30" ,"40"];
List<String> docTypeList = ['Doc1' , 'Doc2' , 'Doc3' , 'Doc4'];

class _DriversListState extends State<DriversList> with Utility{
  ValueNotifier<String> docTypeValue = ValueNotifier("");
  List driverColumnName = [
    {
      'column_name': 'ID No',
      'column_value':'vehicles__drivers_profile.driver_id',
    },
    {
      'column_name': 'Photo',
      'column_value': 'vehicles__drivers_profile.driver_id'
    },
    {
      'column_name':'Driver Name',
      'column_value':'vehicles__drivers_profile.driver_name'

    },
    {
      'column_name': 'Contact Number',
      'column_value':'vehicles__drivers_profile.driver_mobile_number'
    },
    {
      'column_name': 'Guarantor',
      'column_value': 'vehicles__drivers_guarantee.guarantor_name'
    },
    {
      'column_name': 'Licence Number',
      'column_value':'vehicles__drivers_profile.driver_license_number'
    },
    {
      'column_name': 'Licence Expiry',
      'column_value': 'vehicles__drivers_profile.driver_license_validity_to'
    },
    {
      'column_name': 'Vehicle Number',
      'column_value': 'vehicles.vehicle_number'
    },
    {
      'column_name': 'Group',
      'column_value': 'vehicles__drivers_group.drivers_group_id'
    },
    {
      'column_name': 'Action',
      'column_value': 'vehicles__drivers_group.drivers_group_id'
    }
  ];
  String assignDropdownValue = assignDropdownList.first;
  String entriesDropdownValue = entriesDropdownList.first;

  TextEditingController searchController = TextEditingController();
  TextEditingController fromDateUi = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController toDateUi = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController timelineWriteController = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool search = false;
  bool search2 = false;
  bool search3 = false;
  bool search4 = false;
  bool search5 = false;
  bool search6 = false;
  bool search7 = false;
  bool search8 = false;
  int currentIndex = 2;
  var keyword;
  int currentPage = 1;
  int freshLoad = 0;
  var vehicleId;
  var next;
  var prev;
  var totalPages;
  var driverId;
  List driverList = [];
  List data = [];
  List<List<dynamic>> exportData = [];

  driverListApiFunc() {
    driverList.clear();
    setStateMounted(() {
      freshLoad = 1;
    });
    driverListApi().then((source) {
      var info = jsonDecode(source);
      if (info['success'] == true) {
        driverList.addAll(info['data']);
        setStateMounted(() {
          freshLoad = 0;
          currentPage = info['page'];
          prev = info['prev'];
          next = info['next'];
          totalPages = info['total_pages'];
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setState(() {
          freshLoad = 1;
        });
      }
    });
    exportDataApi().then((source) {
      var info = jsonDecode(source);
      if (info['success'] == true) {
        data.clear();
        exportData.clear();
        data.addAll(info['data']);
        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        setState(() {
          freshLoad = 1;
        });
      }
    });
  }

  driverDeleteApiFunc() {
    driverDeleteApi().then((source) {
      var info = jsonDecode(source);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  driverEditApiFunc() {
    driverEditApi().then((value) {
      var info = jsonDecode(value);
      if(info['success']==true){

      }
    });
  }

  @override
  void initState() {
    super.initState();
    driverListApiFunc();
    keyword = driverColumnName[2]['column_value'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar('Driver List'),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10,right: 10),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  UiDecoration().dropDown(1, DropdownButton<String>(
                    borderRadius: BorderRadius.circular(5),
                    dropdownColor: ThemeColors.whiteColor,
                    underline: Container(
                      decoration: const BoxDecoration(border: Border()),
                    ),
                    isExpanded: true,
                    hint: const Text(
                      'Assign',
                      style: TextStyle(color: ThemeColors.darkBlack),
                    ),
                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      color: ThemeColors.darkBlack,
                      size: 15,
                    ),
                    iconSize: 30,
                    value: assignDropdownValue,
                    elevation: 16,
                    style: TextDecorationClass().dropDownText(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        assignDropdownValue = newValue!;
                      });
                    },
                    items: assignDropdownList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Center(child: Text(value)),
                      );
                    }).toList(),
                  ),),
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
                  //     child:
                  //     TextFormField(
                  //       readOnly: true,
                  //       controller: fromDateUi,
                  //       decoration: UiDecoration().dateFieldDecoration('From Date'),
                  //       onTap: () {
                  //         UiDecoration()
                  //             .showDatePickerDecoration(context)
                  //             .then((value) {
                  //           setState(() {
                  //             String month = value.month.toString().padLeft(2, '0');
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
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: toDateUi,
                  //       decoration: UiDecoration().dateFieldDecoration('To Date'),
                  //       onTap: () {
                  //         UiDecoration()
                  //             .showDatePickerDecoration(context)
                  //             .then((value) {
                  //           setState(() {
                  //             String month = value.month.toString().padLeft(2, '0');
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
                    style: ButtonStyles.customiseButton(ThemeColors.primaryColor,
                        ThemeColors.whiteColor, 100.0, 42.0),
                    onPressed: () {
                      setState(() {
                        searchController.text='';
                      });
                      driverListApiFunc();
                    },
                    child: const Text("Filter"),
                  ),
                ],
              ),
            ),
            const Divider(),
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
                        setState(() {
                          entriesDropdownValue = newValue!;
                          driverListApiFunc();
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
                  const Spacer(),
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
                ],
              ),
            ),
            const Divider(),

            const SizedBox(height: 10,),

            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        freshLoad==1?const Center(child: CircularProgressIndicator()):ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child:

                            DataTable(
                              columns:List.generate(driverColumnName.length, (index) =>
                                  DataColumn(label: InkWell(
                                    focusColor: Colors.white,
                                    hoverColor: Colors.white,
                                    onTap: () {
                                      setState(() {
                                        currentIndex = index;
                                        keyword = driverColumnName[index]['column_value'];
                                      });
                                    }, child: SearchDataTable(
                                      onFieldSubmitted: (p0) {
                                        driverListApiFunc();
                                      },
                                      isSelected: index==9||index==1?false:index == currentIndex,
                                      search: searchController,
                                      columnName: driverColumnName[index]['column_name']),
                                  ),
                                  ),
                              ),
                              rows: List.generate(driverList.length, (index) => DataRow(
                                color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
                                cells: [
                                  DataCell(Text(driverList[index]['driver_id'].toString())),
                                  DataCell(driverList[index]['driver_photo']==''?const Text('No Image Found'):
                                  CachedNetworkImage(
                                    width: 50,
                                    imageUrl: '${GlobalVariable.baseURL}public/Driver_Documents/${driverList[index]['driver_photo']}',
                                    errorWidget: (context, url, error) =>  const Icon(Icons.error,color: Colors.grey,),
                                    placeholder: (context, url) =>  const CircularProgressIndicator(),
                                  ),
                                  ),
                                  DataCell(Text(driverList[index]['driver_name'].toString())),
                                  DataCell(Text(driverList[index]['driver_mobile_number'].toString())),
                                  DataCell(Text(driverList[index]['guarantor_name'].toString())),
                                  DataCell(Text(driverList[index]['driver_license_number'])),
                                  DataCell(Text(driverList[index]['driver_license_validity_to'])),
                                  DataCell(Text(driverList[index]['vehicle_number'].toString())),
                                  DataCell(Text(driverList[index]['drivers_group_id'].toString())),
                                  DataCell(Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Edit Icon
                                          UiDecoration().actionButton(ThemeColors.editColor,IconButton(
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {
                                                setState(() {
                                                  driverId = driverList[index]['driver_id'];
                                                  GlobalVariable.driverId = driverList[index]['driver_id'];
                                                  GlobalVariable.driverGroupId = driverList[index]['drivers_group_id'];
                                                  GlobalVariable.edit = true;
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverDetails(),));
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 15,
                                                color: Colors.white,
                                              ))),

                                          // Delete Icon
                                          UiDecoration().actionButton(ThemeColors.deleteColor,IconButton(
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text("Are you sure you want to delete"),
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
                                                                driverId = driverList[index]['driver_id'];
                                                                driverDeleteApiFunc();
                                                                driverListApiFunc();
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
                                                size: 15,
                                                color: Colors.white,
                                              ))),

                                          // Print Icon
                                          Container(
                                              height: 20,
                                              width: 20,
                                              margin: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(color: ThemeColors.darkBlueColor, borderRadius: BorderRadius.circular(5)),
                                              child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.print, size: 15, color: Colors.white,))),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          // ViewDocuments Icon
                                          Container(
                                              height: 20,
                                              width:20,
                                              margin: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                                              child: IconButton(padding: const EdgeInsets.all(0),onPressed: viewDocuments, icon: const Icon(Icons.contact_page_outlined, size: 15, color: Colors.white,))),
                                          // Driver Time Line Icon
                                          Container(
                                              height: 20,
                                              width: 20,
                                              margin: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(color: ThemeColors.yellowColor, borderRadius: BorderRadius.circular(5)),
                                              child: IconButton(padding: const EdgeInsets.all(0),onPressed: driverTimeLine, icon: const Icon(Icons.timeline, size: 15, color: Colors.white,))),
                                          // Driver History Icon
                                          Container(
                                              height: 20,
                                              width: 20,
                                              margin: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                                              child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                                                Navigator.push(context,
                                                  MaterialPageRoute(builder:
                                                      (context) => const DriverHistory(),),);},
                                                  icon: const Icon(Icons.history_rounded, size: 15, color: Colors.white,))),
                                        ],
                                      ),

                                    ],
                                  )),

                                ],
                              )),
                              showCheckboxColumn: false,
                              sortAscending: true,
                              sortColumnIndex: 0,
                            ),
                          ),
                        ),
                      ],
                    ))),
            Row(
              children: [
                /// Prev Button
                Row(
                  children: [
                    const SizedBox(
                      width: 3,
                    ),
                    prev == true
                        ? InkWell(
                        onTap: () {
                          setState(() {
                            currentPage = 1;
                            driverListApiFunc();
                          });
                        },
                        child: const Text(
                          'First Page',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ))
                        : const SizedBox(),
                    const SizedBox(width: 10),
                    prev == true
                        ? Text(
                      'Prev',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade700),
                    )
                        : const SizedBox(),
                    IconButton(
                        onPressed: prev == false
                            ? null
                            : () {
                          setState(() {
                            currentPage > 1
                                ? currentPage--
                                : currentPage = 1;
                            driverListApiFunc();
                          });
                        },
                        icon: const Icon(Icons.chevron_left)),
                  ],
                ),
                const SizedBox(width: 30,),

                /// Next Button
                Row(
                  children: [
                    IconButton(
                      onPressed: next == false
                          ? null
                          : () {
                        setState(() {
                          currentPage++;
                          driverListApiFunc();
                        });
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                    next == true
                        ? Text(
                      'Next',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade700),
                    )
                        : const SizedBox(),
                    const SizedBox(
                      width: 10,
                    ),
                    next == true
                        ? InkWell(
                        onTap: () {
                          setState(() {
                            currentPage = totalPages;
                            driverListApiFunc();
                          });
                        },
                        child: const Text(
                          'Last Page',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ))
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void viewDocuments(){
    showDialog(context: context, builder: (context) {
      return
        SingleChildScrollView(
          child: AlertDialog(
            title: const Text("Documents Manage"),
            content:  SizedBox(
              width: 680,
              child: Column(
                children: [
                  const Divider(),
                  /// doc type dropdown
                  FormWidgets().formDetails2("Select Document Type", ValueListenableBuilder(
                    valueListenable: docTypeValue,
                    builder: (context, value2, child) =>
                        SearchDropdownWidget(
                            dropdownList: docTypeList,
                            hintText: "Please Select Document Type ",
                            onChanged: (value) {
                              docTypeValue.value = value!;
                            },
                            selectedItem: value2
                        ),
                  ),),

                  /// browse files
                  FormWidgets().formDetails2("Attach Scanned Image Copy", Container(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: ThemeColors.primaryColor
                      ),
                      child: const Text("Browse File"),
                    ),
                  )),
                  const SizedBox(height: 10,),
                  const Divider(),

                  /// DataTable
                  SingleChildScrollView(
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                      child: DataTable(

                          columns: const [
                            DataColumn(label: Text("Document")),
                            DataColumn(label: Text("Action")),
                          ],
                          rows: List.generate(6, (index) {
                            return
                              DataRow(
                                  color: MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
                                  cells: [
                                    const DataCell(Text('Aadhaar Card')),
                                    DataCell(
                                      Row(
                                        children: [
                                          // Download Icon
                                          UiDecoration().actionButton( Colors.green,IconButton(
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {},
                                              icon: const Icon(Icons.download_rounded, size: 15, color: Colors.white,))),

                                          // Delete Icon
                                          UiDecoration().actionButton( ThemeColors.darkRedColor,IconButton(
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {},
                                              icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),
                                        ],
                                      ),
                                    ),
                                  ]);
                          })
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Divider(),
                  /// close button
                  ElevatedButton(
              onPressed: (){Navigator.pop(context); },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    minimumSize: const Size(50, 40),
                    side: BorderSide(color: Colors.grey.shade400 , width: .5)
                ),
                child: const Text('Close', style: TextStyle(color: Colors.black),),
              ),
                ],
              )
            ],
          ),
        );
    },);

  }

  void driverTimeLine(){
    showDialog(
        context: context,
        builder: (context){
          return SingleChildScrollView(
            child: Center(
              child: AlertDialog(
                title: const Text('Timeline'),

                content:  Column(
                  children: [
                    const Divider(),
                    FormWidgets().onlyAlphabetField(
                        'Timeline Write POST', "Enter Timeline Write POST",
                        timelineWriteController,
                        context ,
                        maxLines: 4
                    )
                  ],
                ),

                actions: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade200,
                                minimumSize: const Size(50, 40),
                                side: BorderSide(color: Colors.grey.shade400 , width: .5)
                            ),
                            child: const Text('Close', style: TextStyle(color: Colors.black),),
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeColors.primary,
                              minimumSize: const Size(50, 40),
                              // side: BorderSide(color: Colors.grey.shade400 , width: .5)
                            ),
                            child: const Text('Post', style: TextStyle(color: Colors.white),),
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const TimelinePostAndList(),));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(50, 40),
                              // side: BorderSide(color: Colors.grey.shade400 , width: .5)
                            ),
                            child: const Text('History', style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }


  addDataToExport(){
    exportData.clear();
    exportData=[
      ['ID No.','Driver Name','Contact No.','Guarantor','Licence Number','Licence Expiry','Vehicle Number','Group'],
    ];
    for (int index = 0; index < data.length; index++) {
      List<String> rowData = [
        data[index]['driver_id'].toString(),
        data[index]['driver_name'].toString(),
        data[index]['driver_mobile_number'].toString(),
        data[index]['guarantor_name'].toString(),
        data[index]['driver_license_number'].toString(),
        data[index]['driver_license_validity_to'].toString(),
        data[index]['vehicle_number'].toString(),
        data[index]['drivers_group_id'].toString(),
      ];
      exportData.add(rowData);
    }
  }


  // API
  Future driverListApi() async{
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}VehicleDriver/ProfileList?limit=${int.parse(entriesDropdownValue)}&page=$currentPage&from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}&column=$keyword');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  Future exportDataApi() async{
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}VehicleDriver/ProfileList?from_date=${fromDateApi.text}&to_date=${toDateApi.text}&keyword=${searchController.text}&column=$keyword');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  Future driverDeleteApi() async{
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}VehicleDriver/ProfileDelete?driver_id=$driverId');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  Future driverEditApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}VehicleDriver/ProfileEdit?driver_id=$driverId');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }

}
