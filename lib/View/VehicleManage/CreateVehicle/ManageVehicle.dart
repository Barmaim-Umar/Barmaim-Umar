import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class ManageVehicle extends StatefulWidget {
  const ManageVehicle({Key? key}) : super(key: key);

  @override
  State<ManageVehicle> createState() => _ManageVehicleState();
}

List<String> vehicleTypeList = [
  'Ten Tyres',
  'Sixteen Tyres',
  'Six Tyres'
];
List<String> wheelsTypeList = [
  '4 Tyres',
  '6 Tyres',
  '10 Tyres'
];
List<String> vehicleStatusList = [ 'Active', 'Inactive'];
List<String> vehicleStatus2List = [ 'booked', 'full', 'empty'];
List<String> adBlueVehicleList = ['None', 'Ok'];
List<String> typeList = ['Indoor', 'Outdoor'];
List<String> transportList = ['Truck', 'Tempo', 'Auto'];
List<String> entriesList = ['10', '20', '30', '40'];

class _ManageVehicleState extends State<ManageVehicle> with Utility {

  int currentPage = 1;
  var next;
  var prev;
  var totalPages;


  List vehicleFetchList = [];
  int freshLoad = 1;
  int vehicleID = 0;
  bool update = false;

  String vehicleTypeValue = vehicleTypeList.first;
  String vehicleStatusValue = vehicleStatusList.first;
  String typeValue = typeList.first;
  String transportValue = transportList.first;
  String adBlueVehicleValue = adBlueVehicleList.first;
  String wheelsTypeValue = wheelsTypeList.first;
  String vehicleStatus2Value = ""; // using for table filter dropdown
  String entriesValue = entriesList.first;
  TextEditingController vehicleNumberController = TextEditingController(text: "20219192");
  TextEditingController vehicleCompanyController = TextEditingController(text: "Ashok Leyland ");
  TextEditingController chassisNumberController = TextEditingController(text: "9879676394739");
  TextEditingController engineNumberController = TextEditingController(text: "3872937298798");
  TextEditingController mfgDateControllerUi = TextEditingController(text: "26-05-2022");
  TextEditingController mfgDateControllerApi = TextEditingController(text: "26-05-2022");
  TextEditingController registrationDateControllerUi = TextEditingController(text: "14-05-2023");
  TextEditingController registrationDateControllerApi = TextEditingController(text: "14-05-2023");
  TextEditingController onLoadAvgController = TextEditingController(text: "131231");
  TextEditingController emptyAvgController = TextEditingController(text: "212");
  TextEditingController rtoCityController = TextEditingController(text: "reg rto");
  TextEditingController perDaySalaryController = TextEditingController(text: "12312");
  TextEditingController vehicleOwnerController = TextEditingController(text: "OwnerName");
  TextEditingController perDayIncentiveController = TextEditingController(text: "2321");
  TextEditingController searchController = TextEditingController();
  TextEditingController dayControllerManufacturing = TextEditingController();
  TextEditingController monthControllerManufacturing = TextEditingController();
  TextEditingController yearControllerManufacturing = TextEditingController();
  TextEditingController manufacturingDateApi =TextEditingController();

  TextEditingController dayControllerRegistration = TextEditingController();
  TextEditingController monthControllerRegistration = TextEditingController();
  TextEditingController yearControllerRegistration = TextEditingController();
  TextEditingController registrationDateApi =TextEditingController();
  FocusNode focusNode1 = FocusNode();
  final formKey = GlobalKey<FormState>();

  // API
  vehicleCreateApiFunc(){
    vehicleCreateApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  vehicleFetchApiFunc(){
    vehicleFetchList.clear();
    vehicleFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        vehicleFetchList.addAll(info['data']);
        setStateMounted(() {

          GlobalVariable.totalRecords = info['total_records'];
          GlobalVariable.totalPages = info['total_pages'];
          GlobalVariable.currentPage = info['page'];
          GlobalVariable.next = info['next'];
          GlobalVariable.prev = info['prev'];

          freshLoad = 0;

        });
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  vehicleDeleteApiFunc(){
    vehicleDeleteApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  vehicleEditApiFunc(){
    vehicleEditApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){

        vehicleNumberController.text = info['data'][0]['vehicle_number'];
        vehicleCompanyController.text = info['data'][0]['company'];
        chassisNumberController.text = info['data'][0]['chassis_number'];
        engineNumberController.text = info['data'][0]['engine_number'];
        mfgDateControllerUi.text = UiDecoration().getFormattedDate(info['data'][0]['manu_date']);
        registrationDateControllerUi.text = UiDecoration().getFormattedDate(info['data'][0]['reg_date']);
        onLoadAvgController.text = info['data'][0]['on_load_avg'].toString();
        emptyAvgController.text = info['data'][0]['empty_avg'].toString();
        rtoCityController.text = info['data'][0]['reg_rto'];
        perDaySalaryController.text = info['data'][0]['driver_salary'].toString();
        vehicleOwnerController.text = info['data'][0]['vehicle_owner'];
        perDayIncentiveController.text = info['data'][0]['driver_salary_incentive'].toString();

        setStateMounted(() {
          freshLoad = 0;
        });
      }
    });
  }

  vehicleUpdateApiFunc(){
    vehicleUpdateApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
        vehicleNumberController.clear();
        vehicleCompanyController.clear();
        chassisNumberController.clear();
        engineNumberController.clear();
        mfgDateControllerUi.clear();
        registrationDateControllerUi.clear();
        onLoadAvgController.clear();
        emptyAvgController.clear();
        rtoCityController.clear();
        perDaySalaryController.clear();
        vehicleOwnerController.clear();
        perDayIncentiveController.clear();

        setStateMounted(() {
          update = false;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  void initState() {
    vehicleFetchApiFunc();
    
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      FocusScope.of(context).requestFocus(focusNode1);
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("New Vehicle"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Responsive(
          /// Mobile
          mobile: Column(
            children: [
              Expanded(
                child: vehicleForm(),
              ),
              widthBox10(),
              Expanded(
                child: vehicleList(),
              )
            ],
          ),

          /// Tablet
          tablet: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: vehicleForm(),
              ),
              widthBox10(),
              Expanded(
                flex: 1,
                child: vehicleList(),
              ),
            ],
          ),

          /// Desktop
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: vehicleForm(),
              ),
              widthBox10(),
              Expanded(
                flex: 3,
                child: vehicleList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  vehicleForm() {
    return Container(
      decoration: UiDecoration().formDecoration(),
      child: Form(
        key: formKey,
        child: FocusScope(
          child: FocusTraversalGroup(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                    child: TextDecorationClass().heading(update ? 'Edit Vehicle' : 'New Vehicle'),
                  ),
                ),
                const Divider(),
                // form
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 8, left: 8, bottom: 8, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormWidgets().alphanumericField('Vehicle Number', 'Enter Vehicle Number', vehicleNumberController, context , focusNode: focusNode1),


                          FormWidgets().onlyAlphabetField('Vehicle Company', 'Enter Vehicle Company', vehicleCompanyController, context),


                          FormWidgets().alphanumericField('Chassis Number', 'Enter Chassis Number', chassisNumberController, context),


                          FormWidgets().alphanumericField('Engine Number', 'Enter Engine Number', engineNumberController, context),


                          FormWidgets().formDetails2('Select Vehicle Type',SearchDropdownWidget(
                                dropdownList: vehicleTypeList,
                                hintText: 'Select Vehicle Type',
                                onChanged: (p0) {
                                  setState(() {
                                    vehicleTypeValue = p0!;
                                  });
                                },
                                maxHeight: 300,
                                selectedItem: vehicleTypeValue),),


                          FormWidgets().formDetails2('Select Number Of Wheels',SearchDropdownWidget(
                                dropdownList: wheelsTypeList,
                                hintText: 'Select Vehicle Type',
                                onChanged: (p0) {
                                  setState(() {
                                    wheelsTypeValue = p0!;
                                  });
                                },
                                maxHeight: 300,
                                selectedItem: wheelsTypeValue),),


                          FormWidgets().numberField('On Load Avg', 'On Load Avg', onLoadAvgController, context),


                          FormWidgets().numberField('Empty Avg', 'Empty Avg', emptyAvgController, context),


                          FormWidgets().formDetails2('Manufacturing Date', SizedBox(
                            height: 35,
                            child:
                            DateFieldWidget2(
                                dayController: dayControllerManufacturing,
                                monthController: monthControllerManufacturing,
                                yearController: yearControllerManufacturing,
                                dateControllerApi: manufacturingDateApi,
                            ),
                            // TextFormField(
                            //   readOnly: true,
                            //   controller: mfgDateControllerUi,
                            //   decoration: UiDecoration()
                            //       .dateFieldDecoration('Manufacturing Date'),
                            //   onTap: () {
                            //     UiDecoration()
                            //         .showDatePickerDecoration(context)
                            //         .then((value) {
                            //       setState(() {
                            //         String month = value.month
                            //             .toString()
                            //             .padLeft(2, '0');
                            //         String day =
                            //         value.day.toString().padLeft(2, '0');
                            //         mfgDateControllerUi.text = "$day-$month-${value.year}";
                            //         mfgDateControllerApi.text = "${value.year}-$month-$day";
                            //       });
                            //     });
                            //   },
                            // ),
                          )),


                          FormWidgets().formDetails2('Registration Date', SizedBox(
                            height: 35,
                            child:
                            DateFieldWidget2(
                                dayController: dayControllerRegistration,
                                monthController: monthControllerRegistration,
                                yearController: yearControllerRegistration,
                                dateControllerApi: registrationDateApi
                            ),
                            // TextFormField(
                            //   readOnly: true,
                            //   controller: registrationDateControllerUi,
                            //   decoration: UiDecoration()
                            //       .dateFieldDecoration('Registration Date'),
                            //   onTap: () {
                            //     UiDecoration()
                            //         .showDatePickerDecoration(context)
                            //         .then((value) {
                            //       setState(() {
                            //         String month = value.month
                            //             .toString()
                            //             .padLeft(2, '0');
                            //         String day =
                            //         value.day.toString().padLeft(2, '0');
                            //         registrationDateControllerUi.text = "$day-$month-${value.year}";
                            //         registrationDateControllerApi.text = "${value.year}-$month-$day";
                            //       });
                            //     });
                            //   },
                            // ),
                          )),


                          FormWidgets().onlyAlphabetField('Registration Rto City', 'Registration Rto City', rtoCityController, context),


                          FormWidgets().onlyAlphabetField('Vehicle Owner', 'Vehicle Owner', vehicleOwnerController, context),


                          FormWidgets().formDetails2('Vehicle Status', SearchDropdownWidget(maxHeight: 300, dropdownList: vehicleStatusList, hintText: 'Select Vehicle Status', onChanged: (p0) {
                            setState(() {
                              vehicleStatusValue = p0!;
                            });
                          }, selectedItem: vehicleStatusValue)),


                          FormWidgets().formDetails2('Indoor/Outdoor Vehicle', SearchDropdownWidget(maxHeight: 200, dropdownList: typeList, hintText: 'Indoor/Outdoor', onChanged: (p0) {
                            setState(() {
                              typeValue = p0!;
                            });
                          }, selectedItem: typeValue)),


                          FormWidgets().formDetails2('AdBlue Vehicle', SearchDropdownWidget(maxHeight: 170, dropdownList: adBlueVehicleList, hintText: 'AdBlue Vehicle', onChanged: (p0) {
                            setState(() {
                              adBlueVehicleValue = p0!;
                            });
                          }, selectedItem: adBlueVehicleValue)),


                          FormWidgets().formDetails2('Select Transport', SearchDropdownWidget(maxHeight: 200, dropdownList: transportList, hintText: 'Select Transport', onChanged: (p0) {
                            setState(() {
                              transportValue = p0!;
                            });
                          }, selectedItem: transportValue)),


                          FormWidgets().numberField('Per Day Salary', 'Enter Per Day Salary', perDaySalaryController, context),


                          FormWidgets().numberField('Per Day Incentive', 'Enter Per Day Incentive', perDayIncentiveController, context),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  vehicleNumberController.clear();
                                  formKey.currentState?.reset();
                                },
                                style: ButtonStyles.smallButton(
                                    ThemeColors.backgroundColor,
                                    ThemeColors.darkBlack),
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if(formKey.currentState!.validate()){
                                    formKey.currentState!.save();
                                   update == true ? vehicleUpdateApiFunc() : vehicleCreateApiFunc();
                                    vehicleFetchApiFunc();
                                  }
                                },
                                style: ButtonStyles.smallButton(
                                    ThemeColors.primaryColor,
                                    ThemeColors.whiteColor),
                                child:  Text(
                                  update == true ? 'Update' : 'Create',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  vehicleList() {
    return Container(
      decoration:UiDecoration().formDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, left: 10),
            alignment: Alignment.centerLeft,
            child:
            // TextDecoration().formTitle('Ledger List'),
            TextDecorationClass().heading('Vehicle List'),
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
                  child: SearchDropdownWidget(dropdownList: entriesList, hintText: entriesList.first,
                      onChanged: (String? newValue) {
                    // This is called when the user selects an item.
                    setState(() {
                      entriesValue = newValue!;
                      vehicleFetchApiFunc();
                    });
                  }
                  , selectedItem: entriesValue , showSearchBox: false , maxHeight: 200),
                ),
                const Text(' entries'),
                const Spacer(),
                Expanded(child: SearchDropdownWidget(dropdownList: vehicleStatus2List, hintText: "Please Select Value",
                  onChanged: (String? newValue) {
                  // This is called when the user selects an item.
                  setState(() {
                    vehicleStatus2Value = newValue!;
                  });
                }, selectedItem: vehicleStatus2Value ,
                  showSearchBox: false, maxHeight: 150,)),

                widthBox20(),
                // Search
                const Text('Search: '),
                Expanded(
                  child: TextFormField(
                      controller: searchController,
                      onFieldSubmitted: (value) {
                        vehicleFetchApiFunc();
                      },
                      onChanged: (value) {
                        vehicleFetchApiFunc();
                      },
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.mouse,
                              PointerDeviceKind.trackpad,
                              PointerDeviceKind.touch
                            }),
                        child:  SizedBox(
                            width: double.maxFinite,
                            child: buildDataTable()),
                      ),
                    ],
                  ))),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Text("Total Records: ${GlobalVariable.totalRecords}"),

              const SizedBox(width: 100,),

              // First Page Button
              IconButton(onPressed: !GlobalVariable.prev ? null : () {
                setState(() {
                  GlobalVariable.currentPage = 1;
                  vehicleFetchApiFunc();
                });

              }, icon: const Icon(Icons.first_page)),

              // Prev Button
              IconButton(
                  onPressed: GlobalVariable.prev == false ? null : () {
                    setState(() {
                      GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                      vehicleFetchApiFunc();
                    });
                  }, icon: const Icon(Icons.chevron_left)),

              const SizedBox(width: 30,),

              // Next Button
              IconButton  (
                  onPressed: GlobalVariable.next == false ? null : () {
                    setState(() {
                      GlobalVariable.currentPage++;
                      vehicleFetchApiFunc();
                    });
                  }, icon: const Icon(Icons.chevron_right)),

              // Last Page Button
              IconButton(onPressed: !GlobalVariable.next ? null : () {
                setState(() {
                  GlobalVariable.currentPage = GlobalVariable.totalPages;
                  vehicleFetchApiFunc();
                });

              }, icon: const Icon(Icons.last_page)),
            ],
          ),
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
                          vehicleFetchApiFunc();
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
                          vehicleFetchApiFunc();
                        });
                      },
                      icon: const Icon(Icons.chevron_left)),
                ],
              ),
              const SizedBox(
                width: 30,
              ),

              /// Next Button
              Row(
                children: [
                  IconButton(
                    onPressed: next == false
                        ? null
                        : () {
                      setState(() {
                        currentPage++;
                        vehicleFetchApiFunc();
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
                          vehicleFetchApiFunc();
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
    );
  }

  /// DATATABLE ===========================
  Widget buildDataTable() {
    return vehicleFetchList.isEmpty ? const Center(child: Text("vehicleFetchList.isEmpty \nUpdating List..."),) : DataTable(
        columns: [
          DataColumn(label: TextDecorationClass().dataColumnName("vehicle_id")),
          DataColumn(label: TextDecorationClass().dataColumnName("vehicle_number")),
          DataColumn(label: TextDecorationClass().dataColumnName("vehicle_type")),
          DataColumn(label: TextDecorationClass().dataColumnName("company")),
          DataColumn(label: TextDecorationClass().dataColumnName("Action")),
        ],
        rows:  List.generate(vehicleFetchList.length, (index) {
          return DataRow(
              color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
              cells: [
                DataCell(TextDecorationClass().dataRowCell(vehicleFetchList[index]['vehicle_id'].toString())),
                DataCell(TextDecorationClass().dataRowCell(vehicleFetchList[index]['vehicle_number'].toString())),
                DataCell(TextDecorationClass().dataRowCell(vehicleFetchList[index]['vehicle_type'].toString())),
                DataCell(TextDecorationClass().dataRowCell(vehicleFetchList[index]['company'].toString())),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // edit Icon
                    UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.edit, size: 15, color: Colors.white,), onPressed: () {
                      setState(() {
                        update = true;
                        vehicleID = vehicleFetchList[index]['vehicle_id'];
                        vehicleEditApiFunc();
                      });
                    },)),

                    // delete Icon
                    UiDecoration().actionButton( ThemeColors.deleteColor,IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                      vehicleID = vehicleFetchList[index]['vehicle_id'];
                      showDialog(context: context, builder: (context) {
                        return
                          AlertDialog(
                            title: const Text("Are you sure you want to delete"),
                            actions: [
                              TextButton(onPressed: () {
                                Navigator.pop(context);
                              }, child: const Text("Cancel")),

                              TextButton(onPressed: () {
                                setState(() {
                                  vehicleDeleteApiFunc();
                                  vehicleFetchApiFunc();
                                });
                                Navigator.pop(context);
                              }, child: const Text("Delete"))
                            ],
                          );
                      },);
                    }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),

                    // Info Icon
                    UiDecoration().actionButton( ThemeColors.infoColor,IconButton(
                        padding: const EdgeInsets.all(0),onPressed: () {
                      vehicleID = vehicleFetchList[index]['vehicle_id'];
                      vehicleEditApiFunc();
                      showInfoPopUp(index);
                    }, icon: const Icon(Icons.info_outlined, size: 15, color: Colors.white,))),
                  ],
                )),
              ]);
        })

    );
  }

  // INFO POPUP
  showInfoPopUp(index){
    showDialog(context: context, builder: (context) {
      return
        StatefulBuilder(
          builder: (context, setState) {
            return
              AlertDialog(

                content:Container(
                  width: 750,
                  decoration: UiDecoration().formDecoration(),
                  child: Form(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                            child:
                            TextDecorationClass().heading('Ledger Info'),
                          ),
                        ),
                        const Divider(),

                        // form
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, bottom: 8, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FormWidgets().infoField('Vehicle Number', 'Enter Vehicle Number', vehicleNumberController, context),

                                  heightBox10(),
                                  FormWidgets().infoField('Vehicle Company', 'Enter Vehicle Company', vehicleCompanyController, context),

                                  heightBox10(),
                                  FormWidgets().infoField('Chassis Number', 'Enter Chassis Number', chassisNumberController, context),

                                  heightBox10(),
                                  FormWidgets().infoField('Engine Number', 'Enter Engine Number', engineNumberController, context),

                                  heightBox10(),
                                  FormWidgets().infoField('Select Vehicle Type', 'Select Vehicle Type', TextEditingController(text: vehicleTypeValue), context),

                                  heightBox10(),
                                  FormWidgets().infoField('Select Number Of Wheels', 'Select Number Of Wheels', TextEditingController(text: wheelsTypeValue), context),

                                  heightBox10(),
                                  FormWidgets().infoField('On Load Avg', 'On Load Avg', onLoadAvgController, context),

                                  heightBox10(),
                                  FormWidgets().infoField('Empty Avg', 'Empty Avg', emptyAvgController, context),

                                  heightBox10(),
                                  FormWidgets().infoField('Empty Avg', 'Empty Avg', mfgDateControllerUi, context),

                                  heightBox10(),
                                  FormWidgets().infoField('Registration Date', 'Registration Date', registrationDateControllerUi, context),

                                  heightBox10(),
                                  FormWidgets().infoField('Registration Rto City', 'Registration Rto City', rtoCityController, context),

                                  heightBox10(),
                                  FormWidgets().infoField('Vehicle Owner', 'Vehicle Owner', vehicleOwnerController, context),

                                  heightBox10(),
                                  FormWidgets().infoField('Vehicle Status', 'Vehicle Status', TextEditingController(text: vehicleStatusValue), context),

                                  heightBox10(),
                                  FormWidgets().infoField('Indoor/Outdoor Vehicle', 'Indoor/Outdoor Vehicle', TextEditingController(text: typeValue), context),

                                  heightBox10(),
                                  FormWidgets().infoField('AdBlue Vehicle', 'AdBlue Vehicle', TextEditingController(text: adBlueVehicleValue), context),

                                  heightBox10(),
                                  FormWidgets().infoField('Select Transport', 'Select Transport', TextEditingController(text: transportValue), context),

                                  heightBox10(),
                                  FormWidgets().infoField('Per Day Salary', 'Enter Per Day Salary', perDaySalaryController, context),

                                  heightBox10(),
                                  FormWidgets().infoField('Per Day Incentive', 'Enter Per Day Incentive', perDayIncentiveController, context),
                                ],
                              ),
                            ),
                          ),
                        )

                        /// form
                        // Expanded(
                        //   child: SingleChildScrollView(
                        //     child: Container(
                        //       padding: const EdgeInsets.only(top: 8 , left: 8, bottom: 8 ,right: 20),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         children: [
                        //           FormWidgets().infoField('Ledger Name', 'Ledger Name' , ledgerNameController,context ,),
                        //           FormWidgets().infoField('Alias Name', 'Alias Name' , aliasNameController,context, ),
                        //           FormWidgets().infoField('Groups', 'select Groups' , TextEditingController(text: groupDropdownValue),context, ),
                        //           FormWidgets().infoField('Contact Number', 'Contact Number' , contactNumberController,context /*[FilteringTextInputFormatter.digitsOnly]*/, ),
                        //           FormWidgets().infoField('E-Mail Address', 'E-Mail Address' , emailController , context, ),
                        //           FormWidgets().infoField('Address', 'Address' , addressController , context, ),
                        //           FormWidgets().infoField('Address', 'Address' , TextEditingController(text: stateDropdownValue) , context, ),
                        //           FormWidgets().infoField('Country', 'INDIA' , countryController , context, ),
                        //           FormWidgets().infoField('GST Number', 'Enter Ledger GST Number (Optional)' , gstNumberController , context , optional: true, ),
                        //           FormWidgets().infoField('Credit Days', 'Enter Ledger Credit Days (Optional)' , creditDaysController ,context, optional: true, ),
                        //           FormWidgets().infoField('PAN Number', 'Enter Ledger PAN Number (Optional)' , panNumberController, context , optional: true, ),
                        //           FormWidgets().infoField('Bank Name', 'Enter Bank Name (Optional)' , bankNameController, context , optional: true, ),
                        //           FormWidgets().infoField('Bank Account Number', 'Enter Bank Account Number (Optional)' , bankAccNumberController , optional: true, context, ),
                        //           FormWidgets().infoField('Bank IFSC', 'Enter Bank IFSC (Optional)' , bankIFSCController, context , optional: true, ),
                        //           FormWidgets().infoField('Bank Branch', 'Enter Bank Branch (Optional)' , bankBranchController, context , optional: true, ),
                        //           FormWidgets().formDetails3('Opening Balance', TextFormField(
                        //             controller: TextEditingController(text: openingBalanceDropdownValue),
                        //             readOnly: true,
                        //             decoration: UiDecoration().outlineTextFieldDecoration("", ThemeColors.primaryColor,),) ,
                        //               'Enter Ledger Opening Balance (Optional)' , ledgerOpeningBalanceController , readOnly: true),
                        //
                        //           /// CheckBox
                        //           Column(
                        //             children: [
                        //               Row(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Expanded(child: TextDecoration().fieldTitle("Fixed")),
                        //                   const SizedBox(width: 20,),
                        //                   Expanded(
                        //                     flex: 4,
                        //                     child: Align(
                        //                       alignment: Alignment.topLeft,
                        //                       child: Transform.scale(
                        //                         scale: 1.2,
                        //                         child: Padding(
                        //                           padding: const EdgeInsets.only(bottom: 10.0),
                        //                           child: Checkbox(value: infoIsChecked == 1 ? false : true, onChanged: null, ),
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               const SizedBox(height: 15,),
                        //             ],
                        //           ),
                        //
                        //           // registered under gst?
                        //           Column(
                        //             children: [
                        //               Row(
                        //                 children: [
                        //                   Expanded(
                        //                     child: Container(),
                        //                   ),
                        //                   const SizedBox(width: 20,),
                        //                   Expanded(
                        //                     flex: 4,
                        //                     child: TextDecoration().fieldTitle2('Registered under GST ?'),
                        //                   ),
                        //                 ],
                        //               ),
                        //               // radioButton
                        //               Row(
                        //                 children: [
                        //                   Expanded(child: Container()),
                        //                   const SizedBox(width: 10,),
                        //                   Expanded(
                        //                     flex: 4,
                        //                     child: Row(
                        //                       children: [
                        //                         Radio(
                        //                           value: 'yes',
                        //                           groupValue: groupValue,
                        //                           onChanged: (value) {
                        //                             setState(() {
                        //                               ledgerRegistered = 1;
                        //                               groupValue = value!;
                        //                             });
                        //                           },
                        //                         ),
                        //                         const Text('Yes'),
                        //                         const SizedBox(width: 10,),
                        //                         Radio(
                        //                           value: 'no',
                        //                           groupValue: groupValue,
                        //                           onChanged: (value) {
                        //                             setState(() {
                        //                               ledgerRegistered = 0;
                        //                               groupValue = value!;
                        //                             });
                        //                           },
                        //                         ),
                        //                         const Text('No'),
                        //                       ],
                        //                     ),
                        //                   )
                        //                 ],
                        //               ),
                        //               const SizedBox(height: 15,),
                        //             ],
                        //           ),
                        //
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // )

                      ],
                    ),
                  ),
                ),

                actions: [
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: const Text("OK")),

                ],
              );
          },
        );
    },);
  }

  // API
  Future vehicleCreateApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Vehicle/VehicleStore");
    var body = {
      'vehicle_number': vehicleNumberController.text,
      'chassis_number': chassisNumberController.text,
      'engine_number': engineNumberController.text,
      'vehicle_type': vehicleTypeValue,
      'on_load_avg': onLoadAvgController.text,
      'empty_avg': emptyAvgController.text,
      'reg_date': registrationDateControllerUi.text,
      'company': vehicleCompanyController.text,
      'manu_date': mfgDateControllerUi.text,
      'vehicle_owner': vehicleOwnerController.text,
      'reg_rto': rtoCityController.text,
      'driver_id': '6',  // TODO : No TextField for it
      'vehicle_status': '6', // TODO :  Error: Vehicle Status Must be a Number
      'trip_status': 'trip_status', // TODO : No TextField
      'driver_salary': perDaySalaryController.text, // TODO = per day salary
      'driver_salary_incentive': perDayIncentiveController.text, // TODO = per day incentive
      'vehicle_owned_by': '3', // TODO : already has a parameter "vehicle_owner"
      'transporter_ledger_id': '66', // TODO : Select Transport Dropdown?
      'ad_blue': '6',// TODO :  Error: AdBlue Must be a Number
      'deactive': '0', // TODO ???
      'user_id': '2'  // TODO ??
    };
    var response = await http.post(url , headers: headers , body: body);
    return response.body.toString();
  }

  Future vehicleFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Vehicle/VehicleList?limit=$entriesValue&page=${GlobalVariable.currentPage}&keyword=${searchController.text}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future vehicleDeleteApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Vehicle/VehicleDelete?vehicle_id=$vehicleID");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future vehicleEditApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Vehicle/VehicleEdit?vehicle_id=$vehicleID");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future vehicleUpdateApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Vehicle/VehicleStore");
    var body = {
      'vehicle_number': vehicleNumberController.text,
      'chassis_number': chassisNumberController.text,
      'engine_number': engineNumberController.text,
      'vehicle_type': vehicleTypeValue,
      'on_load_avg': onLoadAvgController.text,
      'empty_avg': emptyAvgController.text,
      'reg_date': registrationDateControllerUi.text,
      'company': vehicleCompanyController.text,
      'manu_date': mfgDateControllerUi.text,
      'vehicle_owner': vehicleOwnerController.text,
      'reg_rto': rtoCityController.text,
      'driver_id': '6',  // TODO : No TextField for it
      'vehicle_status': '6', // TODO :  Error: Vehicle Status Must be a Number
      'trip_status': 'trip_status', // TODO : No TextField
      'driver_salary': perDaySalaryController.text, // TODO = per day salary
      'driver_salary_incentive': perDayIncentiveController.text, // TODO = per day incentive
      'vehicle_owned_by': '3', // TODO : already has a parameter "vehicle_owner"
      'transporter_ledger_id': '66', // TODO : Select Transport Dropdown?
      'ad_blue': '6',// TODO :  Error: AdBlue Must be a Number
      'deactive': '0', // TODO ???
      'user_id': '2', // TODO ??
      'vehicle_id': vehicleID.toString()
    };
    var response = await http.post(url , headers: headers , body: body);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }
}
