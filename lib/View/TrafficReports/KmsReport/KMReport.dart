import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'dart:math';

import 'package:pfc/utility/utility.dart';

class KMReport extends StatefulWidget {
  const KMReport({Key? key}) : super(key: key);

  @override
  State<KMReport> createState() => _KMReportState();
}

List<String> assignDropdownList = ['Select Action','All Vehicle' , 'Not Assign' , 'Assign'];
List<String> entriesDropdownList = ["10" ,"20" ,"30" ,"40"];

class _KMReportState extends State<KMReport> with Utility{
  final DataTableSource _data = MyData();

  String assignDropdownValue = assignDropdownList.first;
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("KM Report"),
      body: Container(
        margin: const EdgeInsets.all(8),
        // padding: const EdgeInsets.only(top: 10 , left: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              alignment: Alignment.centerLeft,
              child: TextDecorationClass().heading('KM Report'),
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
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
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
                      style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          entriesDropdownValue = newValue!;
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
                  widthBox20(),
                  Expanded(
                    child: Container(
                      height: 35,
                      width: 400,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: ThemeColors.whiteColor,
                        underline: Container(
                          decoration: const BoxDecoration(border: Border()),
                        ),
                        isExpanded: true,
                        hint: const Text(
                          'All Vehicles',
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
                        style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
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
                      ),
                    ),
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
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: fromDate,
                  //       decoration: UiDecoration().dateFieldDecoration('From Date'),
                  //       onTap: (){
                  //         UiDecoration().showDatePickerDecoration(context).then((value){
                  //           setState(() {
                  //             String month = value.month.toString().padLeft(2, '0');
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
                  //       decoration: UiDecoration().dateFieldDecoration('To Date'),
                  //       onTap: (){
                  //         UiDecoration().showDatePickerDecoration(context).then((value){
                  //           setState(() {
                  //             String month = value.month.toString().padLeft(2, '0');
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
                    style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor,100.0,42.0),
                    onPressed: () {},
                    child: const Text("Submit"),
                  ),
                  // Search
                  // const Text('Search: '), Expanded(child: FormWidgets().textFormField('Search')),
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
                      BStyles().button('CSV', 'Export to CSV', "assets/csv2.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button('Excel', 'Export to Excel', "assets/excel.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button('PDF', 'Export to PDF', "assets/pdf.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      BStyles().button('Print', 'Print', "assets/print.png"),
                    ],
                  ),
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search : '),
                  Expanded(
                    child: TextFormField(
                        decoration:
                        UiDecoration().outlineTextFieldDecoration('Search',ThemeColors.primaryColor)
                    ),
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
                          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                          child: PaginatedDataTable(
                            columns: const [
                              DataColumn(label: Text('MV No.')),
                              DataColumn(label: Text('Type')),
                              DataColumn(label: Text('Total KM')),
                              DataColumn(label: Text('Avg Per Day KM')),
                            ],
                            source: _data,

                            // header: const Center(
                            //   child: Text('My Products'),
                            // ),
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
        "id": index,
        "title": "Item $index",
        "price": Random().nextInt(10000),
        "id1": index,

      });

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color: MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
      cells: [
        DataCell(Text(_data[index]['id'].toString())),
        DataCell(Text(_data[index]['title'])),
        DataCell(Text(_data[index]['price'].toString())),
        DataCell(Text(_data[index]['id'].toString())),
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
