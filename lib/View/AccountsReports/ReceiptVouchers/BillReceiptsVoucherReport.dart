import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'dart:math';

import 'package:pfc/utility/utility.dart';

class BillReceiptsVoucherReport extends StatefulWidget {
  const BillReceiptsVoucherReport({Key? key}) : super(key: key);

  @override
  State<BillReceiptsVoucherReport> createState() => _BillReceiptsVoucherReportState();
}

List<String> entriesDropdownList = ["10", "20", "30", "40"];

class _BillReceiptsVoucherReportState extends State<BillReceiptsVoucherReport> with Utility {
  String entriesDropdownValue = entriesDropdownList.first;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final DataTableSource data = MyData();
    return Scaffold(
      appBar: UiDecoration.appBar('Bill Receipts Voucher Report'),
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
                  Spacer(),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 35,
                      child: TextFormField(
                        readOnly: true,
                        controller: fromDate,
                        decoration:
                        UiDecoration().dateFieldDecoration('From Date'),
                        onTap: () {
                          UiDecoration()
                              .showDatePickerDecoration(context)
                              .then((value) {
                            setState(() {
                              String month =
                              value.month.toString().padLeft(2, '0');
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
                    flex: 1,
                    child: SizedBox(
                      height: 35,
                      child: TextFormField(
                        readOnly: true,
                        controller: toDate,
                        decoration:
                        UiDecoration().dateFieldDecoration('To Date'),
                        onTap: () {
                          UiDecoration()
                              .showDatePickerDecoration(context)
                              .then((value) {
                            setState(() {
                              String month =
                              value.month.toString().padLeft(2, '0');
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
                          child: PaginatedDataTable(
                            columns: const [
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Voucher Number')),
                              DataColumn(label: Text('Particulars')),
                              DataColumn(label: Text('Amount')),
                              DataColumn(label: Text('Action')),
                            ],
                            source: data,
                            showCheckboxColumn: false,
                            columnSpacing: 200,
                            horizontalMargin: 10,
                            rowsPerPage: int.parse(entriesDropdownValue),
                            showFirstLastButtons: true,
                            sortAscending: true,
                            sortColumnIndex: 0,
                          ),
                        )
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data = List.generate(
      200,
          (index) => {
        "date": 'date $index',
        "voucher_no": Random().nextInt(99999),
        'particulars': '-',
        "amount": Random().nextInt(100000),
      });

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
      cells: [
        DataCell(Text(_data[index]['date'].toString())),
        DataCell(Text(_data[index]['voucher_no'].toString())),
        DataCell(Text(_data[index]['particulars'].toString())),
        DataCell(Text(_data[index]['amount'].toString())),
        DataCell(Row(
          children: [
            UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
            const SizedBox(width: 5),
            UiDecoration().actionButton( ThemeColors.deleteColor, IconButton(
                padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),

          ],
        )),
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
