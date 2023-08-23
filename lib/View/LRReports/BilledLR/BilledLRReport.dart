import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class BilledLRReport extends StatefulWidget {
  const BilledLRReport({Key? key}) : super(key: key);

  @override
  State<BilledLRReport> createState() => _BilledLRReportState();
}

List<String> vehicleTypeList = ['Select Vehicle Type', 'Not Assign', 'Assign'];
List<String> selectLedgerList = [
  'Select Ledger/Customer',
  'Ledger1',
  'Ledger2',
  'Ledger3'
];
List<String> entriesDropdownList = ["10", "20", "30", "40"];

class _BilledLRReportState extends State<BilledLRReport> with Utility {
  final List<Map> paidLRReportList = [
    {
      'lr_number': '1725892',
      'bill_no': '02122001',
      'ledger': 'Ledger 1',
      'lr_ledger': 'Ledger 1',
      'vehicle_number': 'MH20DR9546',
      'from_location': 'location',
      'to_location': 'location',
      'lr_date': '02-12-2001',
      'billed_date': '02-12-2001'
    },
    {
      'lr_number': '1725892',
      'bill_no': '02122001',
      'ledger': 'Ledger 1',
      'lr_ledger': 'Ledger 1',
      'vehicle_number': 'MH20DR9546',
      'from_location': 'location',
      'to_location': 'location',
      'lr_date': '02-12-2001',
      'billed_date': '02-12-2001'
    },
    {
      'lr_number': '1725892',
      'bill_no': '02122001',
      'ledger': 'Ledger 1',
      'lr_ledger': 'Ledger 1',
      'vehicle_number': 'MH20DR9546',
      'from_location': 'location',
      'to_location': 'location',
      'lr_date': '02-12-2001',
      'billed_date': '02-12-2001'
    },
    {
      'lr_number': '1725892',
      'bill_no': '02122001',
      'ledger': 'Ledger 1',
      'lr_ledger': 'Ledger 1',
      'vehicle_number': 'MH20DR9546',
      'from_location': 'location',
      'to_location': 'location',
      'lr_date': '02-12-2001',
      'billed_date': '02-12-2001'
    },
    {
      'lr_number': '1725892',
      'bill_no': '02122001',
      'ledger': 'Ledger 1',
      'lr_ledger': 'Ledger 1',
      'vehicle_number': 'MH20DR9546',
      'from_location': 'location',
      'to_location': 'location',
      'lr_date': '02-12-2001',
      'billed_date': '02-12-2001'
    },
    {
      'lr_number': '1725892',
      'bill_no': '02122001',
      'ledger': 'Ledger 1',
      'lr_ledger': 'Ledger 1',
      'vehicle_number': 'MH20DR9546',
      'from_location': 'location',
      'to_location': 'location',
      'lr_date': '02-12-2001',
      'billed_date': '02-12-2001'
    },
    {
      'lr_number': '1725892',
      'bill_no': '02122001',
      'ledger': 'Ledger 1',
      'lr_ledger': 'Ledger 1',
      'vehicle_number': 'MH20DR9546',
      'from_location': 'location',
      'to_location': 'location',
      'lr_date': '02-12-2001',
      'billed_date': '02-12-2001'
    },
    {
      'lr_number': '1725892',
      'bill_no': '02122001',
      'ledger': 'Ledger 1',
      'lr_ledger': 'Ledger 1',
      'vehicle_number': 'MH20DR9546',
      'from_location': 'location',
      'to_location': 'location',
      'lr_date': '02-12-2001',
      'billed_date': '02-12-2001'
    },
    {
      'lr_number': '1725892',
      'bill_no': '02122001',
      'ledger': 'Ledger 1',
      'lr_ledger': 'Ledger 1',
      'vehicle_number': 'MH20DR9546',
      'from_location': 'location',
      'to_location': 'location',
      'lr_date': '02-12-2001',
      'billed_date': '02-12-2001'
    },
    {
      'lr_number': '1725892',
      'bill_no': '02122001',
      'ledger': 'Ledger 1',
      'lr_ledger': 'Ledger 1',
      'vehicle_number': 'MH20DR9546',
      'from_location': 'location',
      'to_location': 'location',
      'lr_date': '02-12-2001',
      'billed_date': '02-12-2001'
    },
    {
      'lr_number': '1725892',
      'bill_no': '02122001',
      'ledger': 'Ledger 1',
      'lr_ledger': 'Ledger 1',
      'vehicle_number': 'MH20DR9546',
      'from_location': 'location',
      'to_location': 'location',
      'lr_date': '02-12-2001',
      'billed_date': '02-12-2001'
    },
    {
      'lr_number': '1725892',
      'bill_no': '02122001',
      'ledger': 'Ledger 1',
      'lr_ledger': 'Ledger 1',
      'vehicle_number': 'MH20DR9546',
      'from_location': 'location',
      'to_location': 'location',
      'lr_date': '02-12-2001',
      'billed_date': '02-12-2001'
    },
  ];

  String vehicleTypeDropdownValue = vehicleTypeList.first;
  String selectLedgerValue = selectLedgerList.first;
  String entriesDropdownValue = entriesDropdownList.first;
  TextEditingController fromDate = TextEditingController();
  TextEditingController receivedDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController haltDays = TextEditingController();
  TextEditingController totalHaltAmount = TextEditingController();
  TextEditingController unloadingCharges = TextEditingController();
  TextEditingController remark = TextEditingController();
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
    return Scaffold(
      appBar: UiDecoration.appBar("Billed LR Report"),
      body: Container(
        margin: const EdgeInsets.all(8),
        // padding: const EdgeInsets.only(top: 10 , left: 10),
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

                  // Select Ledger / Customer
                  UiDecoration().dropDown(
                    1,
                    DropdownButton<String>(
                      borderRadius: BorderRadius.circular(5),
                      dropdownColor: ThemeColors.whiteColor,
                      underline: Container(
                        decoration: const BoxDecoration(border: Border()),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Select Ledger / Customer',
                        style: TextStyle(color: ThemeColors.darkBlack),
                      ),
                      icon: const Icon(
                        CupertinoIcons.chevron_down,
                        color: ThemeColors.darkBlack,
                        size: 15,
                      ),
                      iconSize: 30,
                      value: selectLedgerValue,
                      elevation: 16,
                      style: TextDecorationClass().dropDownText(),
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          selectLedgerValue = newValue!;
                        });
                      },
                      items: selectLedgerList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Center(child: Text(value)),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // Vehicle type dropdown
                  UiDecoration().dropDown(
                    1,
                    DropdownButton<String>(
                      borderRadius: BorderRadius.circular(5),
                      dropdownColor: ThemeColors.whiteColor,
                      underline: Container(
                        decoration: const BoxDecoration(border: Border()),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Select Vehicle Type',
                        style: TextStyle(color: ThemeColors.darkBlack),
                      ),
                      icon: const Icon(
                        CupertinoIcons.chevron_down,
                        color: ThemeColors.darkBlack,
                        size: 15,
                      ),
                      iconSize: 30,
                      value: vehicleTypeDropdownValue,
                      elevation: 16,
                      style: TextDecorationClass().dropDownText(),
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
                    ),
                  ),
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
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: fromDate,
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
                  //             fromDate.text = "${value.year}-$month-$day";
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
                  //       controller: toDate,
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
                  //             toDate.text = "${value.year}-$month-$day";
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
                  widthBox10(),
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(
                        ThemeColors.orangeColor,
                        ThemeColors.whiteColor,
                        200.0,
                        42.0),
                    onPressed: () {},
                    child: const Text("Generate Bill"),
                  ),
                ],
              ),
            ),

            // buttons
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // entries dropdown
                  Container(
                    height: 35,
                    width: 80,
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
                  SizedBox(width: 20),
                  Wrap(
                    runSpacing: 5,
                    // spacing: 0,
                    children: [
                      BStyles()
                          .button('CSV', 'Export to CSV', "assets/csv2.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button(
                          'Excel', 'Export to Excel', "assets/excel.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles()
                          .button('PDF', 'Export to PDF', "assets/pdf.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button('Print', 'Print', "assets/print.png"),
                    ],
                  ),
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search : '),
                  // Search
                  Expanded(
                    child: TextFormField(
                        decoration: UiDecoration().outlineTextFieldDecoration(
                            'Search', ThemeColors.primaryColor)),
                  ),
                  const SizedBox(
                    width: 10,
                  )
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
            // DataTable
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('LR No.')),
                                  DataColumn(label: Text('Bill Number')),
                                  DataColumn(label: Text('Ledger')),
                                  DataColumn(label: Text('LR Ledger')),
                                  DataColumn(label: Text('Vehicle Number')),
                                  DataColumn(label: Text('From Location')),
                                  DataColumn(label: Text('To Location')),
                                  DataColumn(label: Text('LR Date')),
                                  DataColumn(label: Text('Billed Date')),
                                ],
                                showCheckboxColumn: false,
                                columnSpacing: 105,
                                horizontalMargin: 10,
                                sortAscending: true,
                                sortColumnIndex: 0,
                                rows: List.generate(paidLRReportList.length,
                                        (index) {
                                      return DataRow(
                                        color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
                                        cells: [
                                          DataCell(Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(paidLRReportList[index]
                                              ['lr_number']
                                                  .toString()),
                                            ],
                                          )),
                                          DataCell(Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(paidLRReportList[index]
                                              ['bill_no']),
                                            ],
                                          )),
                                          DataCell(Text(paidLRReportList[index]
                                          ['ledger']
                                              .toString())),
                                          DataCell(Text(paidLRReportList[index]
                                          ['lr_ledger']
                                              .toString())),
                                          DataCell(Text(paidLRReportList[index]
                                          ['vehicle_number'])),
                                          DataCell(Text(paidLRReportList[index]
                                          ['from_location']
                                              .toString())),
                                          DataCell(Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(paidLRReportList[index]
                                              ['to_location']
                                                  .toString()),
                                            ],
                                          )),
                                          DataCell(Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(paidLRReportList[index]
                                              ['lr_date']
                                                  .toString()),
                                            ],
                                          )),
                                          DataCell(Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(paidLRReportList[index]
                                              ['billed_date']
                                                  .toString()),
                                            ],
                                          )),
                                        ],
                                      );
                                    })),
                          ),
                        )
                      ],
                    ))),
            Row(
              children: [
                /// Prev Button
                Row(
                  children: [
                    GlobalVariable.next == false ?Text('Prev',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade700),):SizedBox(),
                    IconButton(
                        onPressed: GlobalVariable.prev == false ? null : () {
                          setState(() {
                            GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                          });
                        }, icon: const Icon(Icons.chevron_left)),
                  ],
                ),
                const SizedBox(width: 30,),
                /// Next Button
                Row(
                  children: [
                    IconButton(
                      onPressed: GlobalVariable.next == false ? null : () {
                        setState(() {
                          GlobalVariable.currentPage++;
                        });
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                    GlobalVariable.next == false ?Text('Next',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade700),):SizedBox()
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
