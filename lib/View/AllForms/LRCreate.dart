import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
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

class LRCreate extends StatefulWidget {
  const LRCreate({Key? key}) : super(key: key);

  @override
  State<LRCreate> createState() => _LRCreateState();
}

List<String> vehicle = [];
List<String> type = ['Pushpak', 'Others'];
List<String> entriesSelection = ['10', '20', '30', '40'];
List<String> ledgerList = [];

class _LRCreateState extends State<LRCreate> with Utility {
  String dropdownValue = '';
  String lrTypeDropdownValue = "";
  String vehicleDropdownValue = '';
  String entries = entriesSelection.first;
  int groupValue = 0;
  TextEditingController loadingDate = TextEditingController();
  TextEditingController expectedDate = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController search = TextEditingController();
  TextEditingController fromLocation = TextEditingController();
  TextEditingController toLocation = TextEditingController();
  TextEditingController lrNumber = TextEditingController();
  TextEditingController invoiceNumber = TextEditingController();
  TextEditingController pallets = TextEditingController();
  TextEditingController consignor = TextEditingController();
  TextEditingController totalKms = TextEditingController();
  TextEditingController remark = TextEditingController();
  TextEditingController loadingDateDateApi = TextEditingController();
  TextEditingController expectedDateDateApi = TextEditingController();
  TextEditingController dayControllerExpectedDate = TextEditingController();
  TextEditingController monthControllerExpectedDate = TextEditingController();
  TextEditingController yearControllerExpectedDate = TextEditingController();
  TextEditingController dayControllerLoadingDate = TextEditingController();
  TextEditingController monthControllerLoadingDate = TextEditingController();
  TextEditingController yearControllerLoadingDate = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  final formKey = GlobalKey<FormState>();
  int freshLoad = 0;
  var ledgerId;
  var lrId;
  var vehicleId;
  List lrList = [];
  List lrList2 = [];
  List lrEdit = [];
  List vehicleList = [];
  bool update = false;

  lrListApiFunc() {
    lrList.clear();
    setStateMounted(() {
      freshLoad = 1;
    });
    lrListApi().then((source) {
      var info = jsonDecode(source);
      if (info['success'] == true) {
        lrList.addAll(info['data']);
         setStateMounted(() {
          freshLoad = 0;
          GlobalVariable.totalRecords = info['total_records'];
          GlobalVariable.totalPages = info['total_pages'];
          GlobalVariable.currentPage = info['page'];
          GlobalVariable.next = info['next'];
          GlobalVariable.prev = info['prev'];
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() {
          freshLoad = 1;
        });
      }
    });
  }

  addLedger() {
    setStateMounted(() {
      freshLoad = 1;
    });
    ledgerDropDownApi().then(
          (value) {
        var info = jsonDecode(value);
        if (info['success'].toString() == 'true') {
          ledgerList.clear();
          lrList2.clear();
          for (int i = 0; i < info['data'].length; i++) {
            lrList2.add(info['data'][i]);
            ledgerList.add(info['data'][i]['ledger_title']);
          }

          getLedgerId();
          setStateMounted(() {
            freshLoad = 0;
          });
        } else {
          setStateMounted(() {
            freshLoad = 1;
          });
        }
      },
    );
  }

  addVehicle() {
    setStateMounted(() {
      freshLoad = 1;
    });
    vehicleDropDownApi().then(
          (value) {
        var info = jsonDecode(value);
        if (info['success'].toString() == 'true') {
          vehicleList.clear();
          vehicle.clear();
          for (int i = 0; i < info['data'].length; i++) {
            vehicleList.add(info['data'][i]);
            vehicle.add(info['data'][i]['vehicle_number']);
          }
          // vehicleDropdownValue = vehicle.first;
          // GlobalVariable.vehicleDropdownValue == ""
          //     ? vehicleDropdownValue = vehicle.first
          //     : vehicleDropdownValue = GlobalVariable.vehicleDropdownValue;
          // GlobalVariable.vehicleDropdownValue = vehicleDropdownValue;
          getVehicleId();
          setStateMounted(() {
            freshLoad = 0;
          });
        } else {
          setStateMounted(() {
            freshLoad = 1;
          });
        }
      },
    );
  }

  lrDeleteApiFunc() {
    lrDeleteApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  lrCreateApiFunc() {
    lrCreateApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  lrEditApiFunc() {
    lrEditApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        lrEdit.addAll(info['data']);
        setStateMounted(() {
          update = true;
          getLedgerName();
          fromLocation.text = info['data'][0]['from_location'];
          toLocation.text = info['data'][0]['to_location'];
          getVehicleNumber();
          lrNumber.text = info['data'][0]['lr_number'];
          invoiceNumber.text = info['data'][0]['lr_invoice_number'];
          lrTypeDropdownValue = info['data'][0]['lr_type'] == 0 ? type.first : type.last;
          loadingDate.text = info['data'][0]['unloaded_date'];
          expectedDate.text = info['data'][0]['expected_date'];
          pallets.text = info['data'][0]['no_of_pallets'];
          consignor.text = info['data'][0]['to_consignor'];
          totalKms.text = info['data'][0]['expected_total_kms'];
          groupValue = info['data'][0]['multipoint_load_unloading'];
          remark.text = info['data'][0]['lr_remark'];
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  lrUpdateApiFunc() {
    lrUpdateApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        update = false;
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    lrListApiFunc();
    addLedger();
    addVehicle();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   FocusScope.of(context).requestFocus(focusNode1);
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Responsive(
              /// Mobile
              mobile: Column(
                children: [
                  lrCreateForm(),
                  heightBox10(),
                  lrListScreen()
                ],
              ),

              /// Tablet
              tablet: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: lrCreateForm(),
                  ),
                  widthBox10(),
                  Expanded(
                    flex: 1,
                    child: lrListScreen(),
                  ),
                ],
              ),

              /// Desktop
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2,child: lrCreateForm(),),
                  widthBox10(),
                  Expanded(flex: 3, child: lrListScreen())
                ],
              ),
            )),
      ),
    );
  }

  lrCreateForm() {
    return Form(
      key: formKey,
      child: Container(
        decoration: UiDecoration().formDecoration(),
        padding: const EdgeInsets.all(8.0),
        child: FocusScope(
          child: FocusTraversalGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextDecorationClass().heading('LR Create'),

                heightBox10(),
                FormWidgets().formDetails2("Select Ledger/Customer", SearchDropdownWidget(
                  dropdownList: ledgerList,
                  hintText: 'Select Ledger',
                  selectedItem: dropdownValue,
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value!;
                      getLedgerId();
                    });
                  },
                ),),

                FormWidgets().onlyAlphabetField("From Location", "Enter From Location", fromLocation, context),

                FormWidgets().onlyAlphabetField("To Location", "Enter From Location", toLocation, context),

                FormWidgets().formDetails2("Select Vehicle", SearchDropdownWidget(
                  dropdownList: vehicle,
                  hintText: 'Select Vehicle',
                  selectedItem: vehicleDropdownValue,
                  onChanged: (value) {
                    setState(() {
                      vehicleDropdownValue = value!;
                      getVehicleId();
                    });
                  },
                ),),

                FormWidgets().numberField("LR Number", "Enter LR Number", lrNumber, context),

                FormWidgets().numberField("Invoice Number", "Enter Invoice Number", invoiceNumber, context),

                FormWidgets().formDetails2("LR Type", SearchDropdownWidget(
                  dropdownList: type,
                  hintText: 'Select LR Type',
                  selectedItem: lrTypeDropdownValue,
                  onChanged: (value) {
                    setState(() {
                      lrTypeDropdownValue = value!;
                      getVehicleId();
                    });
                  },
                  showSearchBox: false,
                  maxHeight:  100,
                ),),

                FormWidgets().formDetails2('Loading Date'  ,
                  DateFieldWidget2(
                      dayController: dayControllerLoadingDate,
                      monthController: monthControllerLoadingDate,
                      yearController: yearControllerLoadingDate,
                      dateControllerApi: loadingDateDateApi
                  ),
                //   TextFormField(
                //   readOnly: true,
                //   controller: loadingDate,
                //
                //   decoration: UiDecoration().dateFieldDecoration('Loading Date'),
                //   onTap: (){
                //     UiDecoration().showDatePickerDecoration(context).then((value){
                //       setState(() {
                //         String month = value.month.toString().padLeft(2, '0');
                //         String day = value.day.toString().padLeft(2, '0');
                //         loadingDate.text = "${value.year}-$month-$day";
                //       });
                //     });
                //   },
                //
                //   validator: (value) {
                //     if(value == null || value == ''){
                //       return "Please Select Date";
                //     }
                //     return null;
                //   },
                // ),
                ),

                FormWidgets().formDetails2('Expected Date'  ,
                  DateFieldWidget2(
                      dayController: dayControllerExpectedDate,
                      monthController: monthControllerExpectedDate,
                      yearController: yearControllerExpectedDate,
                      dateControllerApi: expectedDateDateApi
                  ),
                //   TextFormField(
                //   readOnly: true,
                //   controller: expectedDate,
                //
                //   decoration: UiDecoration().dateFieldDecoration('Expected Date'),
                //   onTap: (){
                //     UiDecoration().showDatePickerDecoration(context).then((value){
                //       setState(() {
                //         String month = value.month.toString().padLeft(2, '0');
                //         String day = value.day.toString().padLeft(2, '0');
                //         expectedDate.text = "${value.year}-$month-$day";
                //       });
                //     });
                //   },
                //
                //   validator: (value) {
                //     if(value == null || value == ''){
                //       return "Please Select Date";
                //     }
                //     return null;
                //   },
                // ),
                ),

                FormWidgets().numberField("No Of Pallets/Articles", "Enter No Of Pallets/Articles", pallets, context),

                FormWidgets().onlyAlphabetField("To Consignor", "Enter To Consignor", consignor, context),

                FormWidgets().numberField("Total KMs", "Enter Total KMs", totalKms, context),

                heightBox10(),
                // Single Point | Multi Point
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Radio(
                            activeColor: ThemeColors.primaryColor,
                            value: 0,
                            groupValue: groupValue,
                            onChanged: (value) => setState(() {
                              groupValue = value!;
                            })),
                        TextDecorationClass().heading1('Single Point'),
                      ],
                    ),
                    const SizedBox(width: 30,),
                    Row(
                      children: [
                        Radio(
                            activeColor: ThemeColors.primaryColor,
                            value: 1,
                            groupValue: groupValue,
                            onChanged: (value) => setState(() {
                              groupValue = value!;
                            })),
                        TextDecorationClass().heading1('Multi Point'),
                      ],
                    ),
                  ],
                ),

                heightBox10(),
                FormWidgets().alphanumericField("Remark/Description", "Description", remark, context , maxLines: 4),

                heightBox10(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        formKey.currentState!.reset();
                      },
                      style: ButtonStyles.smallButton(
                          ThemeColors.backgroundColor, ThemeColors.darkBlack),
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          formKey.currentState!.save();

                          update == true ? lrUpdateApiFunc() : lrCreateApiFunc();
                          lrListApiFunc();
                        }

                      },
                      style: ButtonStyles.smallButton(
                          ThemeColors.primaryColor, ThemeColors.whiteColor),
                      child: Text(
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
      ),
    );
  }

  lrListScreen() {
    return Container(
      decoration: UiDecoration().formDecoration(),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextDecorationClass().heading('LR List'),
              const Spacer(),
              Expanded(
                child: SizedBox(
                  height: 35,
                  child: TextFormField(
                    readOnly: true,
                    controller: fromDate,
                    decoration: UiDecoration().dateFieldDecoration('From Date'),
                    onTap: () {
                      UiDecoration()
                          .showDatePickerDecoration(context)
                          .then((value) {
                        setState(() {
                          String month = value.month.toString().padLeft(2, '0');
                          String day = value.day.toString().padLeft(2, '0');
                          fromDate.text = "${value.year}-$month-$day";
                        });
                      });
                    },
                  ),
                ),
              ),
              widthBox10(),
              Expanded(
                child: SizedBox(
                  height: 35,
                  child: TextFormField(
                    readOnly: true,
                    controller: toDate,
                    decoration: UiDecoration().dateFieldDecoration('To Date'),
                    onTap: () {
                      UiDecoration()
                          .showDatePickerDecoration(context)
                          .then((value) {
                        setState(() {
                          String month = value.month.toString().padLeft(2, '0');
                          String day = value.day.toString().padLeft(2, '0');
                          toDate.text = "${value.year}-$month-$day";
                        });
                      });
                    },
                  ),
                ),
              ),
              widthBox10(),
              ElevatedButton(
                style: ButtonStyles.customiseButton(ThemeColors.primaryColor,
                    ThemeColors.whiteColor, 100.0, 42.0),
                onPressed: () {
                  lrListApiFunc();
                  setState(() {
                    fromDate.text = '';
                    toDate.text = '';
                  });
                },
                child: const Text("Filter"),
              ),
            ],
          ),
          const Divider(),
          heightBox10(),
          Row(
            children: [
              TextDecorationClass().subHeading2('Show '),
              Container(
                height: 30,
                width: 70,
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  icon: const Icon(
                    CupertinoIcons.chevron_down,
                    color: ThemeColors.darkBlack,
                    size: 20,
                  ),
                  iconSize: 30,
                  value: entries,
                  elevation: 16,
                  style: TextDecorationClass().dropDownText(),
                  onChanged: (String? newValue) {
                    // This is called when the user selects an item.
                    setState(() {
                      entries = newValue!;
                      lrListApiFunc();
                    });
                  },
                  items: entriesSelection
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Center(child: Text(value)),
                    );
                  }).toList(),
                ),
              ),
              TextDecorationClass().subHeading2(' entries'),
              const Spacer(),
              TextDecorationClass().subHeading2('Search: '),
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: search,
                  onChanged: (value) {
                    lrListApiFunc();
                  },
                  decoration: UiDecoration().outlineTextFieldDecoration(
                      'Search', ThemeColors.primaryColor),
                ),
              )
            ],
          ),
          heightBox10(),
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.touch
            }),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: freshLoad == 1
                  ? const Center(child: CircularProgressIndicator())
                  : DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('LR No')),
                  DataColumn(label: Text('Ledger Name')),
                  DataColumn(label: Text('From Location')),
                  DataColumn(label: Text('To Location')),
                  DataColumn(label: Text('Loading Date')),
                  DataColumn(label: Text('Expected Date')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: List.generate(lrList.length, (index) {
                  return DataRow(
                      color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
                      cells: [
                        DataCell(
                            Text(lrList[index]['lr_number'].toString())),
                        DataCell(Text(
                            lrList[index]['ledger_title'].toString())),
                        DataCell(Text(
                            lrList[index]['from_location'].toString())),
                        DataCell(Text(
                            lrList[index]['to_location'].toString())),
                        DataCell(Text(
                            lrList[index]['unloaded_date'].toString())),
                        DataCell(Text(
                            lrList[index]['expected_date'].toString())),
                        DataCell(Row(
                          children: [

                            // edit Icon
                            UiDecoration().actionButton(
                                ThemeColors.editColor,
                                IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        ledgerId = lrList[index]['ledger_id'];
                                        lrId = lrList[index]['lr_id'];
                                        vehicleId = lrList[index]['vehicle_id'];
                                        // getLedgerName();
                                        // getVehicleNumber();
                                        lrEditApiFunc();
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: Colors.white,
                                    ))),
                            UiDecoration().actionButton(
                                ThemeColors.deleteColor,
                                IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Are you sure you want to delete"),
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
                                                      lrId = lrList[index]
                                                      ['lr_id'];
                                                      lrDeleteApiFunc();
                                                      lrListApiFunc();
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
                          ],
                        )),
                      ]);
                }),
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
                  lrListApiFunc();
                });

              }, icon: const Icon(Icons.first_page)),

              // Prev Button
              IconButton(
                  onPressed: GlobalVariable.prev == false ? null : () {
                    setState(() {
                      GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                      lrListApiFunc();
                    });
                  }, icon: const Icon(Icons.chevron_left)),

              const SizedBox(width: 30,),

              // Next Button
              IconButton  (
                  onPressed: GlobalVariable.next == false ? null : () {
                    setState(() {
                      GlobalVariable.currentPage++;
                      lrListApiFunc();
                    });
                  }, icon: const Icon(Icons.chevron_right)),

              // Last Page Button
              IconButton(onPressed: !GlobalVariable.next ? null : () {
                setState(() {
                  GlobalVariable.currentPage = GlobalVariable.totalPages;
                  lrListApiFunc();
                });

              }, icon: const Icon(Icons.last_page)),
            ],
          ),

        ],
      ),
    );
  }

  getLedgerId() {
    for (int i = 0; i < lrList2.length; i++) {
      if (dropdownValue == lrList2[i]['ledger_title']) {
        ledgerId = lrList2[i]['ledger_id'];
      }
    }
  }

  getLedgerName() {
    for (int i = 0; i < lrList2.length; i++) {
      if (ledgerId == lrList2[i]['ledger_id']) {
        setState(() {
          dropdownValue = lrList2[i]['ledger_title'];
        });
      }
    }
  }

  getVehicleId() {
    for (int i = 0; i < vehicleList.length; i++) {
      if (vehicleDropdownValue == vehicleList[i]['vehicle_number']) {
        vehicleId = vehicleList[i]['vehicle_id'];
      }
    }
  }

  getVehicleNumber() {
    for (int i = 0; i < vehicleList.length; i++) {
      if (vehicleId == vehicleList[i]['vehicle_id']) {
        setState(() {
          vehicleDropdownValue = vehicleList[i]['vehicle_number'];
        });
      }
    }
  }

  Future lrCreateApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}LR/LRStore');
    var body = {
      'ledger_id': ledgerId.toString(),
      'to_consignor': consignor.text,
      'lr_number': lrNumber.text,
      'lr_invoice_number': invoiceNumber.text,
      'vehicle_id': vehicleId.toString(),
      'from_location': fromLocation.text,
      'to_location': toLocation.text,
      'lr_type': lrTypeDropdownValue == 'Pushpak' ? '0' : '1',
      'unloaded_date': loadingDate.text,
      'expected_date': expectedDate.text,
      'no_of_pallets': pallets.text,
      'multipoint_load_unloading': groupValue.toString(),
      'expected_total_kms': totalKms.text,
      'lr_remark': remark.text
    };

    var response = await http.post(url, headers: headers, body: body);
    return response.body.toString();
  }

  ledgerDropDownApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse("${GlobalVariable.baseURL}Account/LedgersFetch");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  vehicleDropDownApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse("${GlobalVariable.baseURL}Vehicle/VehicleFetch");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  lrDeleteApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse('${GlobalVariable.baseURL}LR/LRDelete?lr_id=$lrId');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  lrEditApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse('${GlobalVariable.baseURL}LR/LREdit?lr_id=$lrId');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  lrUpdateApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}LR/LRStore');
    var body = {
      'ledger_id': ledgerId.toString(),
      'lr_id': lrId.toString(),
      'to_consignor': consignor.text,
      'lr_number': lrNumber.text,
      'lr_invoice_number': invoiceNumber.text,
      'vehicle_id': vehicleId.toString(),
      'from_location': fromLocation.text,
      'to_location': toLocation.text,
      'lr_type': lrTypeDropdownValue == 'Pushpak' ? '0' : '1',
      'unloaded_date': loadingDate.text,
      'expected_date': expectedDate.text,
      'no_of_pallets': pallets.text,
      'multipoint_load_unloading': groupValue.toString(),
      'expected_total_kms': totalKms.text,
      'lr_remark': remark.text
    };
    var response = await http.post(url, headers: headers, body: body);
    return response.body.toString();
  }

  lrListApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.baseURL}LR/LRFetch?limit=${int.parse(entries)}&page=${GlobalVariable.currentPage}&keyword=${search.text}&from_date=${fromDate.text}&to_date=${toDate.text}');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }
}
