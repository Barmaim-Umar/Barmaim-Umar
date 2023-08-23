import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'dart:math';
import 'package:pfc/utility/utility.dart';

class RateList extends StatefulWidget {
  const RateList({Key? key}) : super(key: key);

  @override
  State<RateList> createState() => _RateListState();
}

List<String> assignList = ['Select Ledger', 'Not Assign', 'Assign'];
List<String> entriesList = ["10", "20", "30", "40"];

class _RateListState extends State<RateList> with Utility {
  final DataTableSource _data = MyData();

  String entriesDropdownValue = entriesList.first;
  String assignDropdownValue = assignList.first;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Rate List"),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              alignment: Alignment.centerLeft,
              child: TextDecorationClass().heading('Freight Rate List'),
            ),

            const Divider(),

            // dropdown & search
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // dropdown
                  SizedBox(
                    width: 80,
                    child: SearchDropdownWidget(dropdownList: entriesList, hintText: entriesList.first, onChanged: (value) {
                      // This is called when the user selects an item.
                      setState(() {
                        entriesDropdownValue = value!;
                      });
                    }, selectedItem: entriesDropdownValue,
                      showSearchBox: false,
                      maxHeight: 200,
                    ),
                  ),
                  const Text(' entries'),

                  widthBox20(),

                  // Dropdown
                  Expanded(
                    child:
                    SearchDropdownWidget(dropdownList: assignList, hintText: "Select Ledger", onChanged: (value) {
                      // This is called when the user selects an item.
                      setState(() {
                        assignDropdownValue = value!;
                      });
                    }, selectedItem: assignDropdownValue),
                  ),

                  const SizedBox(width: 10,),
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

                  // from Date
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

                  // to Date
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

                  // filter button
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

                  // Search field
                  TextDecorationClass().subHeading2('Search : '),
                  Expanded(
                    child: TextFormField(
                        decoration: UiDecoration().outlineTextFieldDecoration(
                            'Search', ThemeColors.primaryColor)),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10,),

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
                          child: SizedBox(
                            width: double.maxFinite,

                            // DataTable
                            child: PaginatedDataTable(
                              columns: const [
                                DataColumn(label: Text('Ledger/Customer')),
                                DataColumn(label: Text('From-To')),
                                DataColumn(label: Text('Rate Matrix')),
                                DataColumn(label: Text('Quantity')),
                                DataColumn(label: Text('Type')),
                                DataColumn(label: Text('Rate')),
                                DataColumn(label: Text('Total Amount')),
                                DataColumn(label: Text('Freight Date')),
                                DataColumn(label: Text('Action')),
                              ],
                              source: _data,
                              showCheckboxColumn: false,
                              columnSpacing: 50,
                              horizontalMargin: 10,
                              rowsPerPage: int.parse(entriesDropdownValue),
                              showFirstLastButtons: true,
                              sortAscending: true,
                              sortColumnIndex: 0,
                            ),
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
        "customer": 'Customer $index',
        "from_to": "location $index-location $index+1",
        "rate_matrix": 'fixed',
        "Quantity": Random().nextInt(99),
        "type": "37FT HQ",
        "rate": Random().nextInt(10000),
        "total_amount": Random().nextInt(10000),
        "freight_date": '30-03-2023',
      });

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
      cells: [
        DataCell(Text(_data[index]['customer'].toString())),
        DataCell(Text(_data[index]['from_to'])),
        DataCell(Text(_data[index]['rate_matrix'].toString())),
        DataCell(Text(_data[index]['Quantity'].toString())),
        DataCell(Text(_data[index]['type'])),
        DataCell(Text(_data[index]['rate'].toString())),
        DataCell(Text(_data[index]['total_amount'].toString())),
        DataCell(Text(_data[index]['freight_date'])),
        DataCell(Row(
          children: [
            // Edit Icon
            UiDecoration().actionButton( ThemeColors.editColor, IconButton(
                padding: const EdgeInsets.all(0),onPressed: () {}, icon: UiDecoration().editIcon())),
            const SizedBox(width: 2,),

            // Add Button
            ElevatedButton(onPressed: () {},
                style: ButtonStyles.customiseButton(Colors.green, Colors.white, 40.0, 28.0),
                child: const Text("Add" ,style: TextStyle(fontSize: 13), )),
            const SizedBox(width: 2,),

            // History Button
            ElevatedButton(onPressed: () {},
                style: ButtonStyles.customiseButton(Colors.orange, Colors.white, 40.0, 28.0),
                child: const Text("History" ,style: TextStyle(fontSize: 13), )),
            const SizedBox(width: 2,),
            //Delete Icon
            UiDecoration().actionButton( ThemeColors.deleteColor, IconButton(
                padding: const EdgeInsets.all(0),onPressed: () {}, icon: UiDecoration().deleteIcon())),
          ],
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
