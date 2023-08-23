import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class LastActivityReport extends StatefulWidget {
  const LastActivityReport({Key? key}) : super(key: key);

  @override
  State<LastActivityReport> createState() => _LastActivityReportState();
}

List<String> entriesList = ['10' , '20' , '30' , '40' , '50'];

class _LastActivityReportState extends State<LastActivityReport> {

  final List<Map> paidLRReportList = [
    {
      'mv_number': '1725892',
      'vehicle_type': 'types',
      'status': 'LR Pending',
      'from_location': 'location',
      'to_location': 'location',
      'activity_date': '02-12-2001',
      'expected_date': '02-12-2001'
    },
    {
      'mv_number': '1725892',
      'vehicle_type': 'types',
      'status': 'LR Pending',
      'from_location': 'location',
      'to_location': 'location',
      'activity_date': '02-12-2001',
      'expected_date': '02-12-2001'
    },
    {
      'mv_number': '1725892',
      'vehicle_type': 'types',
      'status': 'LR Pending',
      'from_location': 'location',
      'to_location': 'location',
      'activity_date': '02-12-2001',
      'expected_date': '02-12-2001'
    },
    {
      'mv_number': '1725892',
      'vehicle_type': 'types',
      'status': 'LR Pending',
      'from_location': 'location',
      'to_location': 'location',
      'activity_date': '02-12-2001',
      'expected_date': '02-12-2001'
    },
    {
      'mv_number': '1725892',
      'vehicle_type': 'types',
      'status': 'LR Pending',
      'from_location': 'location',
      'to_location': 'location',
      'activity_date': '02-12-2001',
      'expected_date': '02-12-2001'
    },
    {
      'mv_number': '1725892',
      'vehicle_type': 'types',
      'status': 'LR Pending',
      'from_location': 'location',
      'to_location': 'location',
      'activity_date': '02-12-2001',
      'expected_date': '02-12-2001'
    },
    {
      'mv_number': '1725892',
      'vehicle_type': 'types',
      'status': 'LR Pending',
      'from_location': 'location',
      'to_location': 'location',
      'activity_date': '02-12-2001',
      'expected_date': '02-12-2001'
    },
    {
      'mv_number': '1725892',
      'vehicle_type': 'types',
      'status': 'LR Pending',
      'from_location': 'location',
      'to_location': 'location',
      'activity_date': '02-12-2001',
      'expected_date': '02-12-2001'
    },
    {
      'mv_number': '1725892',
      'vehicle_type': 'types',
      'status': 'LR Pending',
      'from_location': 'location',
      'to_location': 'location',
      'activity_date': '02-12-2001',
      'expected_date': '02-12-2001'
    },
    {
      'mv_number': '1725892',
      'vehicle_type': 'types',
      'status': 'LR Pending',
      'from_location': 'location',
      'to_location': 'location',
      'activity_date': '02-12-2001',
      'expected_date': '02-12-2001'
    },
    {
      'mv_number': '1725892',
      'vehicle_type': 'types',
      'status': 'LR Pending',
      'from_location': 'location',
      'to_location': 'location',
      'activity_date': '02-12-2001',
      'expected_date': '02-12-2001'
    },
  ];

  String entriesValue = entriesList.first;
  TextEditingController search =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar('Last Activity Report'),
      body: Container(
        decoration: UiDecoration().formDecoration(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                      value: entriesValue,
                      elevation: 16,
                      style: TextDecorationClass().dropDownText(),
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          entriesValue = newValue!;
                        });
                      },
                      items: entriesList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const Text(' entries'),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
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
                  TextDecorationClass().subHeading2('search : '),
                  Expanded(
                    child: TextFormField(
                      controller: search,
                        decoration: UiDecoration().outlineTextFieldDecoration(
                            'Search', ThemeColors.primaryColor)),
                  ),
                ],
              ),
            ),
            const Divider(),
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
                                  DataColumn(label: Text('MV Number')),
                                  DataColumn(label: Text('Vehicle Type')),
                                  DataColumn(label: Text('Status')),
                                  DataColumn(label: Text('Activity Date')),
                                  DataColumn(label: Text('Expected Date')),
                                  DataColumn(label: Text('From Location')),
                                  DataColumn(label: Text('To Location')),
                                ],
                                showCheckboxColumn: false,
                                columnSpacing: 155,
                                horizontalMargin: 10,
                                sortAscending: true,
                                sortColumnIndex: 0,
                                rows: List.generate(paidLRReportList.length,
                                        (index) {
                                      return DataRow(
                                        color:MaterialStatePropertyAll( index == 0 || index % 2 == 0 ? ThemeColors.tableRowColor : Colors.white),
                                        cells: [
                                          DataCell(Text(paidLRReportList[index]
                                          ['mv_number']
                                              .toString())),
                                          DataCell(Text(paidLRReportList[index]
                                          ['vehicle_type'].toString())),
                                          DataCell(Text(paidLRReportList[index]
                                          ['status']
                                              .toString())),
                                          DataCell(Text(paidLRReportList[index]['activity_date'].toString())),
                                          DataCell(Text(paidLRReportList[index]['expected_date'].toString())),
                                          DataCell(Text(paidLRReportList[index]['from_location'].toString())),
                                          DataCell(Text(paidLRReportList[index]['to_location'].toString())),
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
                    GlobalVariable.next == false ?Text('Prev',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade700),):const SizedBox(),
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
                    GlobalVariable.next == false ?Text('Next',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade700),):const SizedBox()
                  ],
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
