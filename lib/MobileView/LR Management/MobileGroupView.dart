import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class MobileGroupView extends StatefulWidget {
  const MobileGroupView({Key? key}) : super(key: key);

  @override
  State<MobileGroupView> createState() => _MobileGroupViewState();
}

List<String> list = ['Select Alliance', '1', '2', '3'];
List<String> groupLink = ['Select Link Group', '1', '2', '3', '4'];
List<String> entriesSelection = ['10', '20', '30', '40'];

class _MobileGroupViewState extends State<MobileGroupView> with Utility{
  TextEditingController searchController = TextEditingController();
  final DataTableSource _data = DataTableData();
  int numberOfPages = 10;
  TextDecorationClass textDecoration = TextDecorationClass();
  String dropdownValue = list.first;
  String dropdownValue2 = groupLink.first;
  String dropdownValue3 = entriesSelection.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // width: 500,
              height: 300,
              color: ThemeColors.whiteColor,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textDecoration.heading('New Group'),
                  heightBox20(),
                  Row(
                    children: [
                      textDecoration.subHeading('Group Name'),
                      widthBox16(),
                      UiDecoration()
                          .outlineField(350, 'Enter Group Name', 1, null)
                    ],
                  ),
                  heightBox10(),
                  heightBox5(),
                  Row(
                    children: [
                      textDecoration.subHeading('Alliance'),
                      widthBox50(),
                      widthBox5(),
                      Expanded(
                        child: Container(
                          height: 40,
                          width: 350,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ThemeColors.grey700)),
                          child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(5),
                            dropdownColor: ThemeColors.whiteColor,
                            underline: Container(
                              decoration:
                                  const BoxDecoration(border: Border()),
                            ),
                            isExpanded: true,
                            hint: const Text(
                              '',
                              style: TextStyle(color: ThemeColors.darkBlack),
                            ),
                            icon: const Icon(
                              CupertinoIcons.chevron_down,
                              color: ThemeColors.darkBlack,
                              size: 20,
                            ),
                            iconSize: 30,
                            value: dropdownValue,
                            elevation: 16,
                            style: const TextStyle(
                                color: ThemeColors.darkGreyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis),
                            onChanged: (String? newValue) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: list.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                  heightBox10(),
                  heightBox5(),
                  Row(
                    children: [
                      textDecoration.subHeading('Group Link'),
                      widthBox20(),
                      widthBox10(),
                      Expanded(
                        child: Container(
                          height: 40,
                          width: 350,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ThemeColors.grey700)),
                          child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(5),
                            dropdownColor: ThemeColors.whiteColor,
                            underline: Container(
                              decoration:
                                  const BoxDecoration(border: Border()),
                            ),
                            isExpanded: true,
                            hint: const Text(
                              '',
                              style: TextStyle(color: ThemeColors.darkBlack),
                            ),
                            icon: const Icon(
                              CupertinoIcons.chevron_down,
                              color: ThemeColors.darkBlack,
                              size: 20,
                            ),
                            iconSize: 30,
                            value: dropdownValue2,
                            elevation: 16,
                            style: const TextStyle(
                                color: ThemeColors.darkGreyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis),
                            onChanged: (String? newValue) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue2 = newValue!;
                              });
                            },
                            items: groupLink.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                  heightBox40(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyles.smallButton(
                            ThemeColors.backgroundColor,
                            ThemeColors.darkBlack),
                        child: const Text(
                          'Reset',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyles.smallButton(
                            ThemeColors.primaryColor, ThemeColors.whiteColor),
                        child: const Text(
                          'Create',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              color: ThemeColors.whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textDecoration.heading('Group List'),
                  heightBox20(),
                  Row(
                    children: [
                      textDecoration.subHeading2('Show '),
                      Container(
                        height: 40,
                        width: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ThemeColors.grey700)),
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(5),
                          dropdownColor: ThemeColors.whiteColor,
                          underline: Container(
                            decoration:
                                const BoxDecoration(border: Border()),
                          ),
                          isExpanded: true,
                          icon: const Icon(
                            CupertinoIcons.chevron_down,
                            color: ThemeColors.darkBlack,
                            size: 20,
                          ),
                          iconSize: 30,
                          value: dropdownValue3,
                          elevation: 16,
                          style: const TextStyle(
                              color: ThemeColors.darkGreyColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              overflow: TextOverflow.ellipsis),
                          onChanged: (String? newValue) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue3 = newValue!;
                            });
                          },
                          items: entriesSelection
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                            return DropdownMenuItem<String>(
                              value: value.toString(),
                              child: Center(child: Text(value)),
                            );
                          }).toList(),
                        ),
                      ),
                      textDecoration.subHeading2('entries'),
                      const Spacer(),
                      textDecoration.subHeading2('Search : '),
                      UiDecoration()
                          .outlineField(200, 'Search', 2, searchController)
                      // Expanded(
                      //   flex: 2,
                      //   child: TextFormField(
                      //     controller: searchController,
                      //     decoration: InputDecoration(
                      //         contentPadding: EdgeInsets.all(12),
                      //         isDense: true,
                      //         labelText: 'Search',
                      //         border:OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                      //     onChanged: (value) {
                      //     },
                      //   ),
                      // )
                    ],
                  ),
                  ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    }),
                    child: PaginatedDataTable(
                      source: _data,
                      showFirstLastButtons: true,
                      rowsPerPage: int.parse(dropdownValue3),
                      // horizontalMargin: 20,
                      columnSpacing: 200,
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Price')),
                      ],
                    ),
                  ),
                  // DataTable(
                  //     columns: [
                  //   DataColumn(
                  //     label: textDecoration.subHeading('Group'),
                  //     numeric: false,
                  //   ),
                  //   DataColumn(
                  //     label: textDecoration.subHeading('Linked Group'),
                  //   ),
                  //   DataColumn(
                  //     label: textDecoration.subHeading('Alliance'),
                  //   ),
                  //   DataColumn(
                  //     label: textDecoration.subHeading('Actions'),
                  //   ),
                  // ],
                  //     rows: [
                  //   DataRow(cells: [
                  //     DataCell(
                  //         textDecoration.subHeading2('Salary Advance Staff')),
                  //     DataCell(textDecoration
                  //         .subHeading2('Loans & Advances (Assets)')),
                  //     DataCell(textDecoration.subHeading2('Assets')),
                  //     DataCell(Row(
                  //       children: [
                  //         Icon(
                  //           Icons.edit,
                  //           color: Colors.green,
                  //         ),
                  //         Icon(
                  //           Icons.delete,
                  //           color: Colors.red,
                  //         ),
                  //       ],
                  //     ))
                  //   ]),
                  //   DataRow(cells: [
                  //     DataCell(textDecoration.subHeading2('FastTag')),
                  //     DataCell(textDecoration.subHeading2('Current Assets')),
                  //     DataCell(textDecoration.subHeading2('Assets')),
                  //     DataCell(Row(
                  //       children: [
                  //         Icon(
                  //           Icons.edit,
                  //           color: Colors.green,
                  //         ),
                  //         Icon(
                  //           Icons.delete,
                  //           color: Colors.red,
                  //         ),
                  //       ],
                  //     ))
                  //   ]),
                  //   DataRow(cells: [
                  //     DataCell(
                  //         textDecoration.subHeading2('Insurance Company')),
                  //     DataCell(textDecoration.subHeading2('Current Assets')),
                  //     DataCell(textDecoration.subHeading2('Assets')),
                  //     DataCell(Row(
                  //       children: [
                  //         Icon(
                  //           Icons.edit,
                  //           color: Colors.green,
                  //         ),
                  //         Icon(
                  //           Icons.delete,
                  //           color: Colors.red,
                  //         ),
                  //       ],
                  //     ))
                  //   ]),
                  //   DataRow(cells: [
                  //     DataCell(
                  //         textDecoration.subHeading2('RTO Document Fees')),
                  //     DataCell(
                  //         textDecoration.subHeading2('Indirect Expenses')),
                  //     DataCell(textDecoration.subHeading2('Expenses')),
                  //     DataCell(Row(
                  //       children: [
                  //         Icon(
                  //           Icons.edit,
                  //           color: Colors.green,
                  //         ),
                  //         Icon(
                  //           Icons.delete,
                  //           color: Colors.red,
                  //         ),
                  //       ],
                  //     ))
                  //   ]),
                  //   DataRow(cells: [
                  //     DataCell(textDecoration
                  //         .subHeading2('Other Party Accounts (Debtors)')),
                  //     DataCell(textDecoration.subHeading2('Current Assets')),
                  //     DataCell(textDecoration.subHeading2('Assets')),
                  //     DataCell(Row(
                  //       children: [
                  //         Icon(
                  //           Icons.edit,
                  //           color: Colors.green,
                  //         ),
                  //         Icon(
                  //           Icons.delete,
                  //           color: Colors.red,
                  //         ),
                  //       ],
                  //     ))
                  //   ]),
                  //   DataRow(cells: [
                  //     DataCell(textDecoration.subHeading2('Driver Advance')),
                  //     DataCell(textDecoration.subHeading2('Current Assets')),
                  //     DataCell(textDecoration.subHeading2('Assets')),
                  //     DataCell(Row(
                  //       children: [
                  //         Icon(
                  //           Icons.edit,
                  //           color: Colors.green,
                  //         ),
                  //         Icon(
                  //           Icons.delete,
                  //           color: Colors.red,
                  //         ),
                  //       ],
                  //     ))
                  //   ]),
                  //   DataRow(cells: [
                  //     DataCell(textDecoration
                  //         .subHeading2('Vehicle Loans Account')),
                  //     DataCell(textDecoration.subHeading2('-')),
                  //     DataCell(textDecoration.subHeading2('Liability')),
                  //     DataCell(Row(
                  //       children: [
                  //         Icon(
                  //           Icons.edit,
                  //           color: Colors.green,
                  //         ),
                  //         Icon(
                  //           Icons.delete,
                  //           color: Colors.red,
                  //         ),
                  //       ],
                  //     ))
                  //   ]),
                  //   DataRow(cells: [
                  //     DataCell(
                  //         textDecoration.subHeading2('Transport Account')),
                  //     DataCell(
                  //         textDecoration.subHeading2('Current Liabilities')),
                  //     DataCell(textDecoration.subHeading2('Liability')),
                  //     DataCell(Row(
                  //       children: [
                  //         Icon(
                  //           Icons.edit,
                  //           color: Colors.green,
                  //         ),
                  //         Icon(
                  //           Icons.delete,
                  //           color: Colors.red,
                  //         ),
                  //       ],
                  //     ))
                  //   ]),
                  //   DataRow(cells: [
                  //     DataCell(textDecoration
                  //         .subHeading2('Mechanic Bill Account')),
                  //     DataCell(
                  //         textDecoration.subHeading2('Current Liabilities')),
                  //     DataCell(textDecoration.subHeading2('Liability')),
                  //     DataCell(Row(
                  //       children: [
                  //         Icon(
                  //           Icons.edit,
                  //           color: Colors.green,
                  //         ),
                  //         Icon(
                  //           Icons.delete,
                  //           color: Colors.red,
                  //         ),
                  //       ],
                  //     ))
                  //   ]),
                  //   DataRow(cells: [
                  //     DataCell(
                  //         textDecoration.subHeading2('Maintenance Exp.')),
                  //     DataCell(textDecoration.subHeading2('Direct Expenses')),
                  //     DataCell(textDecoration.subHeading2('Expenses')),
                  //     DataCell(Row(
                  //       children: [
                  //         Icon(
                  //           Icons.edit,
                  //           color: Colors.green,
                  //         ),
                  //         Icon(
                  //           Icons.delete,
                  //           color: Colors.red,
                  //         ),
                  //       ],
                  //     ))
                  //   ]),
                  // ]),
                  // Row(
                  //   children: [
                  //     textDecoration
                  //         .subHeading2('Showing 1 to 10 of 42 entries'),
                  //     widthBox20(),
                  //     Expanded(
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           border: Border.all(color: Colors.grey)
                  //         ),
                  //         child: NumberPaginator(
                  //           initialPage: currentPage,
                  //           numberPages: numberOfPages,
                  //           onPageChange: (index) {
                  //             setState(() {
                  //               currentPage = index;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

class DataTableData extends DataTableSource {
  final List<Map<String, dynamic>> _data = List.generate(
      200,
      (index) => {
            'id': index,
            'title': 'Item $index',
            'price': Random().nextInt(1000)
          });

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['id'].toString())),
      DataCell(Text(_data[index]['title'].toString())),
      DataCell(Text(_data[index]['price'].toString())),
    ]);
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
