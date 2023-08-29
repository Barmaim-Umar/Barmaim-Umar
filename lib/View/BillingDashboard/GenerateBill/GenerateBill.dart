import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'dart:math';

import 'package:pfc/utility/utility.dart';

import '../../AllForms/UpdateBillDetails & LRList/UpdateBillDetailsAndLRList.dart';

class GenerateBill extends StatefulWidget {
  const GenerateBill({Key? key}) : super(key: key);

  @override
  State<GenerateBill> createState() => _GenerateBillState();
}

List<String> ledgerList = [
  'Select Ledger',
  'Mushtaq Khan',
  'Akbar Patel',
  'Name3',
  'Name4'
];
List<String> billingLedgerList = [
  'Select Billing Ledger',
  'Mushtaq Khan',
  'Akbar Patel',
  'Name3',
  'Name4'
];
List<String> vehicleTypeList = ['Select Vehicle Type', 'BPCL', 'Cash', 'ATM'];
List<String> entriesList = ["10", "20", "30", "40"];
bool isChecked = false;

class _GenerateBillState extends State<GenerateBill> with Utility {
  String ledgerDropdownValue = ledgerList.first;
  String billingLedgerDropdownValue = billingLedgerList.first;
  String vehicleTypeDropdownValue = vehicleTypeList.first;
  String entriesDropdownValue = entriesList.first;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController billingDate = TextEditingController();
  TextEditingController billNumber = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    final DataTableSource data = MyData(context, setState);
    return Scaffold(
      appBar: UiDecoration.appBar("Generate Bill"),
      body: Container(
        margin: const EdgeInsets.all(8),
        // padding: const EdgeInsets.only(top: 10 , left: 10),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  UiDecoration().dropDown(
                      1,
                      DropdownButton<String>(
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: ThemeColors.dropdownColor,
                        underline: Container(
                          decoration: const BoxDecoration(border: Border()),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Select Vehicle Type',
                          style:
                          TextStyle(color: ThemeColors.dropdownTextColor),
                        ),
                        icon: DropdownDecoration().dropdownIcon(),
                        value: vehicleTypeDropdownValue,
                        elevation: 16,
                        style: DropdownDecoration().dropdownTextStyle(),
                        onChanged: (String? newValue) {
                          // This is called when the user selects an item.
                          setState(() {
                            vehicleTypeDropdownValue = newValue!;
                          });
                        },
                        items: vehicleTypeList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Center(child: Text(value)),
                          );
                        }).toList(),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  UiDecoration().dropDown(
                      1,
                      DropdownButton<String>(
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: ThemeColors.dropdownColor,
                        underline: Container(
                          decoration: const BoxDecoration(border: Border()),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Select Ledger',
                          style:
                          TextStyle(color: ThemeColors.dropdownTextColor),
                        ),
                        icon: DropdownDecoration().dropdownIcon(),
                        value: ledgerDropdownValue,
                        elevation: 16,
                        style: DropdownDecoration().dropdownTextStyle(),
                        onChanged: (String? newValue) {
                          // This is called when the user selects an item.
                          setState(() {
                            ledgerDropdownValue = newValue!;
                          });
                        },
                        items: ledgerList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Center(child: Text(value)),
                          );
                        }).toList(),
                      )),

                  const SizedBox(
                    width: 10,
                  ),
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
                  // fromDate
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: fromDateController,
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
                  //             fromDateController.text =
                  //             "$day-$month-${value.year}";
                  //           });
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                  widthBox10(),
                  // toDate
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: toDateController,
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
                  //             toDateController.text =
                  //             "$day-$month-${value.year}";
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
                    onPressed: () {},
                    child: const Text("Filter"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(ThemeColors.orangeColor,
                        ThemeColors.whiteColor, 150.0, 40.0),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            scrollable: true,
                            titlePadding: const EdgeInsets.all(10),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextDecorationClass().heading('Generate Bill'),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    CupertinoIcons.xmark,
                                    color: Colors.grey,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            contentPadding: const EdgeInsets.all(20),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ThemeColors.primary
                                ),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateBillDetailsAndLRList(),));
                                },
                                child: const Text('Generate'),
                              ),
                              ElevatedButton(
                                style: ButtonStyles.customiseButton(ThemeColors.grey200, ThemeColors.grey, 100.0, 37.0),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: const Text('Close'),
                              ),
                            ],
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      TextDecorationClass()
                                          .heading1('Select Billing Ledger'),
                                      UiDecoration().dropDown(
                                        0,
                                        DropdownButton<String>(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          dropdownColor: ThemeColors.whiteColor,
                                          underline: Container(
                                            decoration: const BoxDecoration(
                                                border: Border()),
                                          ),
                                          isExpanded: true,
                                          icon: const Icon(
                                            CupertinoIcons.chevron_down,
                                            color: ThemeColors.darkBlack,
                                            size: 20,
                                          ),
                                          iconSize: 30,
                                          value: billingLedgerDropdownValue,
                                          elevation: 16,
                                          style:
                                          TextDecorationClass().dropDownText(),
                                          onChanged: (String? newValue) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              billingLedgerDropdownValue =
                                              newValue!;
                                            });
                                          },
                                          items: billingLedgerList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value.toString(),
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                widthBox30(),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      TextDecorationClass().heading1("Billing Date"),
                                      TextFormField(
                                        readOnly: true,
                                        controller: billingDate,
                                        decoration: UiDecoration()
                                            .outlineTextFieldDecoration(
                                            "Billing Date", Colors.grey),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Tenure To Field is Required';
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          UiDecoration()
                                              .showDatePickerDecoration(context)
                                              .then((value) {
                                            setState(() {
                                              String month = value.month
                                                  .toString()
                                                  .padLeft(2, '0');
                                              String day = value.day
                                                  .toString()
                                                  .padLeft(2, '0');
                                              billingDate.text =
                                              "$day-$month-${value.year}";
                                            });
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                widthBox30(),
                                Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        TextDecorationClass()
                                            .heading1('Bill Number'),
                                        TextFormField(
                                          controller: billNumber,
                                          decoration: UiDecoration()
                                              .outlineTextFieldDecoration(
                                              "Bill Number",
                                              ThemeColors.primaryColor),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Generate Bill'),
                  ),
                ],
              ),
            ),

            // buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // entries dropdown
                  Container(
                    height: 35,
                    width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade400)),
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(5),
                      dropdownColor: ThemeColors.dropdownColor,
                      underline: Container(
                        decoration: const BoxDecoration(border: Border()),
                      ),
                      isExpanded: true,
                      hint: Text(
                        'Select Entries',
                        style: TextStyle(color: ThemeColors.dropdownTextColor),
                      ),
                      icon: DropdownDecoration().dropdownIcon(),
                      value: entriesDropdownValue,
                      elevation: 16,
                      style: DropdownDecoration().dropdownTextStyle(),
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          entriesDropdownValue = newValue!;
                        });
                      },
                      items: entriesList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Center(child: Text(value)),
                        );
                      }).toList(),
                    ),
                  ),
                  const Text(' entries'),
                  widthBox20(),
                  Wrap(
                    runSpacing: 5,
                    // spacing: 0,
                    children: [
                      // BStyles()
                      //     .button('CSV', 'Export to CSV', "assets/csv2.png"),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      BStyles().button(onPressed: () {

                      },
                          'Excel', 'Export to Excel', "assets/excel.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles()
                          .button(onPressed:() {

                          } ,'PDF', 'Export to PDF', "assets/pdf.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button(onPressed: () {

                      },'Print', 'Print', "assets/print.png"),
                    ],
                  ),
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search : '),
                  Expanded(
                    child: TextFormField(
                        controller: searchController,
                        decoration: UiDecoration().outlineTextFieldDecoration(
                            'Search', ThemeColors.primaryColor)),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Transaction Report
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
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// DataTable
                        ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse,
                                PointerDeviceKind.trackpad
                              }),
                          child: PaginatedDataTable(
                            columns: const [
                              DataColumn(label: Text('Mark')),
                              DataColumn(label: Text('LR No.')),
                              DataColumn(label: Text('Ledger')),
                              DataColumn(label: Text('Vehicle No.')),
                              DataColumn(label: Text('From Location')),
                              DataColumn(label: Text('To Location')),
                              DataColumn(label: Text('LR Date')),
                              DataColumn(label: Text('Received Date')),
                              DataColumn(label: Text('Scanned')),
                            ],
                            source: data,
                            showCheckboxColumn: false,
                            columnSpacing: 100,
                            horizontalMargin: 10,
                            rowsPerPage: int.parse(entriesDropdownValue),
                            showFirstLastButtons: true,
                            sortAscending: true,
                            sortColumnIndex: 0,
                          ),
                        ),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  final BuildContext context;
  Function setState;
  List ind = [0, 2, 2, 0, 5, 0, 2, 6, 8, 10];

  MyData(this.context, this.setState);

  final List<Map<String, dynamic>> _data = List.generate(
      200,
          (index) => {
        "date": "27-09-2018",
        "particulars": "HDFC Bank ATM A/C",
        "voucher_no": Random().nextInt(10000),
        "voucher_type": "BPCL",
        "debit": "${Random().nextInt(7354)}",
        "credit": Random().nextInt(10000),
        "narration": "-",
        "entry_by": "Naveed Khan",
      });

  @override
  DataRow? getRow(int index) {
    Widget isChecked(bool isChecked, onChanged) {
      return Checkbox(
        fillColor: const MaterialStatePropertyAll(ThemeColors.primaryColor),
        value: isChecked,
        onChanged: onChanged,
      );
    }

    return DataRow(
      color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
      cells: [
        DataCell(onTap: () {
          setState(() {
            ind.add(index);
            print(ind);
          });
        },
            isChecked(index == ind[index], (value) {
              setState(() {
                // ind = index;
                print("$ind");
              });
            })
          // Checkbox(
          //   fillColor: const MaterialStatePropertyAll(ThemeColors.primaryColor),
          //   value: isChecked,
          //   onChanged: (value) {
          //     setState((){
          //       print(index);
          //       isChecked = value!;
          //     });
          //   },)
        ),
        DataCell(Text(_data[index]['lr_no'].toString())),
        DataCell(Text(_data[index]['ledger'].toString())),
        DataCell(Text(_data[index]['vehicle_no'].toString())),
        DataCell(Text(_data[index]['from_location'].toString())),
        DataCell(Text(_data[index]['to_location'].toString())),
        DataCell(Text(_data[index]['lr_date'].toString())),
        DataCell(Text(_data[index]['received_date'].toString())),
        DataCell(ElevatedButton(
          style: ButtonStyles.customiseButton(
              ThemeColors.primary, ThemeColors.whiteColor, 70.0, 35.0),
          onPressed: () {},
          child: const Text('Doc 1'),
        )),
      ],
      onSelectChanged: (value) {},
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
