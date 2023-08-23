import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'dart:math';

import 'package:pfc/utility/utility.dart';

class SalaryReport extends StatefulWidget {
  const SalaryReport({Key? key}) : super(key: key);

  @override
  State<SalaryReport> createState() => _SalaryReportState();
}

List<String> employeeList = [
  'Select Employee',
  'Mushtaq Khan',
  'Akbar Patel',
  'Name3',
  'Name4'
];
List<String> vouchersList = ['Select Voucher', 'BPCL', 'Cash', 'ATM'];
List<String> entriesList = ["10", "20", "30", "40"];

class _SalaryReportState extends State<SalaryReport> with Utility {
  // final DataTableSource _data = MyData();

  String employeeDropdownValue = employeeList.first;
  String entriesDropdownValue = entriesList.first;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
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
      appBar: UiDecoration.appBar("Salary Report"),
      body: Container(
        margin: const EdgeInsets.all(8),
        // padding: const EdgeInsets.only(top: 10 , left: 10),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // dropdown & search
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // entries dropdown
                  DropdownDecoration()
                      .dropdownDecoration2(DropdownButton<String>(
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
                        child: Text(value),
                      );
                    }).toList(),
                  )),
                  const Text(' entries'),
                  widthBox30(),
                  const SizedBox(
                    width: 10,
                  ),
                  // Names dropdown
                  DropdownDecoration()
                      .dropdownDecoration(DropdownButton<String>(
                    borderRadius: BorderRadius.circular(5),
                    dropdownColor: ThemeColors.dropdownColor,
                    underline: Container(
                      decoration: const BoxDecoration(border: Border()),
                    ),
                    isExpanded: true,
                    hint: Text(
                      'Select Employee',
                      style: TextStyle(color: ThemeColors.dropdownTextColor),
                    ),
                    icon: DropdownDecoration().dropdownIcon(),
                    value: employeeDropdownValue,
                    elevation: 16,
                    style: DropdownDecoration().dropdownTextStyle(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        employeeDropdownValue = newValue!;
                      });
                    },
                    items: employeeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value),
                      );
                    }).toList(),
                  )),

                  const SizedBox(
                    width: 10,
                  ),
                  Spacer(),
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
                  //           UiDecoration().dateFieldDecoration('From Date'),
                  //       onTap: () {
                  //         UiDecoration()
                  //             .showDatePickerDecoration(context)
                  //             .then((value) {
                  //           setState(() {
                  //             String month =
                  //                 value.month.toString().padLeft(2, '0');
                  //             String day = value.day.toString().padLeft(2, '0');
                  //             fromDateController.text =
                  //                 "${value.year}-$month-$day";
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
                  //           UiDecoration().dateFieldDecoration('To Date'),
                  //       onTap: () {
                  //         UiDecoration()
                  //             .showDatePickerDecoration(context)
                  //             .then((value) {
                  //           setState(() {
                  //             String month =
                  //                 value.month.toString().padLeft(2, '0');
                  //             String day = value.day.toString().padLeft(2, '0');
                  //             toDateController.text =
                  //                 "${value.year}-$month-$day";
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
                ],
              ),
            ),

            // buttons
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
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
                  ),
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search : '),
                  Expanded(
                    child: TextFormField(
                        controller: searchController,
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
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Employee')),
                              DataColumn(label: Text('Month of')),
                              DataColumn(label: Text('Basic Salary')),
                              DataColumn(label: Text('Incentive')),
                              DataColumn(label: Text('PF')),
                              DataColumn(label: Text('ESIC')),
                              DataColumn(label: Text('PT')),
                              DataColumn(label: Text('Leave')),
                              DataColumn(label: Text('Net')),
                              DataColumn(label: Text('Generated Date')),
                              DataColumn(label: Text('Print')),
                            ],
                            source: data,
                            showCheckboxColumn: false,
                            columnSpacing: 70,
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

  MyData(this.context, this.setState);

  final List<Map<String, dynamic>> _data = List.generate(
      200,
          (index) => {
        "id": "-",
        "employee": "Naveed Khan",
        "date": "27-09-2018",
        "basic_salary": Random().nextInt(10000),
        "incentive": Random().nextInt(1000),
        "pf": Random().nextInt(1000),
        "esic": Random().nextInt(1000),
        "pt": Random().nextInt(1000),
        "leave": Random().nextInt(10),
        "net": '17600',
      });

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
      cells: [
        DataCell(Text(_data[index]['id'].toString())),
        DataCell(Text(_data[index]['employee'].toString())),
        DataCell(Text(_data[index]['date'].toString())),
        DataCell(Text(_data[index]['basic_salary'].toString())),
        DataCell(Text(_data[index]['incentive'].toString())),
        DataCell(Text(_data[index]['pf'].toString())),
        DataCell(Text(_data[index]['esic'].toString())),
        DataCell(Text(_data[index]['pt'].toString())),
        DataCell(Text(_data[index]['leave'].toString())),
        DataCell(Text(_data[index]['net'].toString())),
        DataCell(Text(_data[index]['date'].toString())),
        DataCell(BStyles().button('Print', 'Print', "assets/print.png"),)
      ],
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
