import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'dart:math';

import 'package:pfc/utility/utility.dart';

class BillList extends StatefulWidget {
  const BillList({Key? key}) : super(key: key);

  @override
  State<BillList> createState() => _BillListState();
}

List<String> entriesDropdownList = ["10", "20", "30", "40"];
List<String> ledgerList = ['Select Ledger', 'Not Assign', 'Assign'];

class _BillListState extends State<BillList> with Utility {

  String ledgerDropdownValue = ledgerList.first;
  String entriesDropdownValue = entriesDropdownList.first;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _data = List.generate(
      200,
          (index) => {
        "bill_no": 'bill $index',
        "ledger": 'customer ${Random().nextInt(99999)}',
        'vehicle': '-',
        'lr_number': '-',
        "amount": Random().nextInt(100000),
        "type": 'regular',
        "billing_date": 'date $index',
        "billed_by": 'person $index',
      });
  @override
  Widget build(BuildContext context) {
    // final DataTableSource data = MyData();
    return Scaffold(
      appBar: UiDecoration.appBar('Billing List'),
      body: Container(
        margin: const EdgeInsets.all(10),
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
                  // dropdown
                  Container(
                    height: 30,
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: ThemeColors.grey700)),
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
                  const Spacer(),
                  UiDecoration().dropDown(1, DropdownButton<String>(
                    borderRadius: BorderRadius.circular(5),
                    dropdownColor: ThemeColors.whiteColor,
                    underline: Container(
                      decoration: const BoxDecoration(border: Border()),
                    ),
                    isExpanded: true,
                    hint: const Text(
                      'Select Ledger',
                      style: TextStyle(color: ThemeColors.darkBlack),
                    ),
                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      color: ThemeColors.darkBlack,
                      size: 15,
                    ),
                    iconSize: 30,
                    value: ledgerDropdownValue,
                    elevation: 16,
                    style: TextDecorationClass().dropDownText(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        ledgerDropdownValue = newValue!;
                      });
                    },
                    items: ledgerList.map<DropdownMenuItem<String>>((String value) {
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
                  //   flex: 1,
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
                  //             fromDate.text = "$day-$month-${value.year}";
                  //           });
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                  widthBox10(),
                  // Expanded(
                  //   flex: 1,
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
                  //             toDate.text = "$day-$month-${value.year}";
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
                  // Search
                  // const Text('Search: '), Expanded(child: FormWidgets().textFormField('Search')),
                ],
              ),
            ),

            // buttons
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
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
                    flex: 1,
                    child: TextFormField(
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
                  // scrollDirection: Axis.horizontal,

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
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width, // Calculate the total width of your columns
                                  child: buildDataTable()),
                            )

                          // PaginatedDataTable(
                          //   columns: const [
                          //     DataColumn(label: Text('Bill No')),
                          //     DataColumn(label: Text('Ledger/Customer')),
                          //     DataColumn(label: Text('Vehicle')),
                          //     DataColumn(label: Text('LR Number')),
                          //     DataColumn(label: Text('Total Freight Amount')),
                          //     DataColumn(label: Text('Type')),
                          //     DataColumn(label: Text('Billing Date')),
                          //     DataColumn(label: Text('Billed By')),
                          //     DataColumn(label: Text('Action')),
                          //   ],
                          //   source: data,
                          //   showCheckboxColumn: false,
                          //   columnSpacing: 80,
                          //   horizontalMargin: 10,
                          //   rowsPerPage: int.parse(entriesDropdownValue),
                          //   showFirstLastButtons: true,
                          //   sortAscending: true,
                          //   sortColumnIndex: 0,
                          // ),
                        )
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
  Widget buildDataTable() {
    double totalDebit = 0;
    double totalCredit = 0;
    return
      /* transactionList.isEmpty ? const Center(child: Text("Select Leger"),) : */
      Expanded(
        child: DataTable(
          // columnSpacing: 90,
            columns: const [
              DataColumn(label: Text('Bill No ',overflow: TextOverflow.ellipsis,)),
              DataColumn(label: Text('Ledger/Customer ',overflow: TextOverflow.ellipsis,)),
              DataColumn(label: Text('Vehicle',overflow: TextOverflow.ellipsis,)),
              DataColumn(label: Text('LR Number',overflow: TextOverflow.ellipsis,)),
              DataColumn(label: Text('Total Freight Amount',overflow: TextOverflow.ellipsis,)),
              DataColumn(label: Text('Type',overflow: TextOverflow.ellipsis,)),
              DataColumn(label: Text('Billing Date',overflow: TextOverflow.ellipsis,)),
              DataColumn(label: Text('Billed By',overflow: TextOverflow.ellipsis,)),
              DataColumn(label: Text('Action',overflow: TextOverflow.ellipsis,)),

            ],
            rows:  List.generate(100, (index) {

              // Calculate totals
              // if (transactionList[0][index]['debit'] != null) {
              //   totalDebit += double.parse( transactionList[0][index]['debit'] == '' ? '0' : transactionList[0][index]['debit'] );
              // }
              // if (transactionList[0][index]['credit'] != null) {
              //   totalCredit += double.parse(transactionList[0][index]['credit'] == '' ? '0' : transactionList[0][index]['credit']);
              // }
              return DataRow(
                  color: index == 0 || index % 2 == 0? MaterialStatePropertyAll(ThemeColors.tableRowColor) : const MaterialStatePropertyAll(Colors.white),
                  cells: [
                    DataCell(Text(_data[index]['bill_no'].toString())),
                    DataCell(Text(_data[index]['ledger'].toString())),
                    DataCell(Text(_data[index]['vehicle'].toString())),
                    DataCell(Text(_data[index]['lr_number'].toString())),
                    DataCell(Text(_data[index]['amount'].toString())),
                    DataCell(Text(_data[index]['type'].toString())),
                    DataCell(Text(_data[index]['billed_date'].toString())),
                    DataCell(Text(_data[index]['billed_by'].toString())),
                    DataCell(Row(
                      children: [
                        UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                            padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
                        const SizedBox(width: 5),
                        UiDecoration().actionButton( ThemeColors.primary, IconButton(
                            padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(CupertinoIcons.link, size: 15, color: Colors.white,))),
                        const SizedBox(width: 5),
                        UiDecoration().actionButton( ThemeColors.orangeColor, IconButton(
                            padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.print_outlined, size: 15, color: Colors.white,))),
                        const SizedBox(width: 5),
                        UiDecoration().actionButton( ThemeColors.darkBlueColor, IconButton(
                            padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.menu, size: 15, color: Colors.white,))),
                        const SizedBox(width: 5),
                        UiDecoration().actionButton( ThemeColors.deleteColor, IconButton(
                            padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),
                      ],
                    )
                    ),

                  ]
              );
            }
            )
          //     +[
          //   DataRow(cells: [
          //     const DataCell(Text('')),
          //     const DataCell(Text('')),
          //     const DataCell(Text('')),
          //     const DataCell(Text('')),
          //     DataCell(
          //       Text(
          //         'Total Debit: $totalDebit',
          //         style: const TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //     DataCell(
          //       Text(
          //         'Total Credit: $totalCredit',
          //         style: const TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //     const DataCell(Text('')),
          //     const DataCell(Text('')),
          //   ],
          //   ),
          // ]
        ),
      );
  }
}

// class MyData extends DataTableSource {
//   final List<Map<String, dynamic>> _data = List.generate(
//       200,
//           (index) => {
//         "bill_no": 'bill $index',
//         "ledger": 'customer ${Random().nextInt(99999)}',
//         'vehicle': '-',
//         'lr_number': '-',
//         "amount": Random().nextInt(100000),
//         "type": 'regular',
//         "billing_date": 'date $index',
//         "billed_by": 'person $index',
//       });
//
//   @override
//   DataRow? getRow(int index) {
//     return DataRow(
//       color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
//       cells: [
//         DataCell(Text(_data[index]['bill_no'].toString())),
//         DataCell(Text(_data[index]['ledger'].toString())),
//         DataCell(Text(_data[index]['vehicle'].toString())),
//         DataCell(Text(_data[index]['lr_number'].toString())),
//         DataCell(Text(_data[index]['amount'].toString())),
//         DataCell(Text(_data[index]['type'].toString())),
//         DataCell(Text(_data[index]['billed_date'].toString())),
//         DataCell(Text(_data[index]['billed_by'].toString())),
//         DataCell(Row(
//           children: [
//             UiDecoration().actionButton( ThemeColors.editColor,IconButton(
//                 padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
//             const SizedBox(width: 5),
//             UiDecoration().actionButton( ThemeColors.primary, IconButton(
//                 padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(CupertinoIcons.link, size: 15, color: Colors.white,))),
//             const SizedBox(width: 5),
//             UiDecoration().actionButton( ThemeColors.orangeColor, IconButton(
//                 padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.print_outlined, size: 15, color: Colors.white,))),
//             const SizedBox(width: 5),
//             UiDecoration().actionButton( ThemeColors.darkBlueColor, IconButton(
//                 padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.menu, size: 15, color: Colors.white,))),
//             const SizedBox(width: 5),
//             UiDecoration().actionButton( ThemeColors.deleteColor, IconButton(
//                 padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),
//           ],
//         )
//         ),
//       ],
//     );
//   }
//
//   @override
//   // TODO: implement isRowCountApproximate
//   bool get isRowCountApproximate => false;
//
//   @override
//   // TODO: implement rowCount
//   int get rowCount => _data.length;
//
//   @override
//   // TODO: implement selectedRowCount
//   int get selectedRowCount => 0;
// }
