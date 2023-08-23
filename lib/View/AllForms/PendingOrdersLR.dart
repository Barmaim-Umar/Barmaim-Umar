import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class PendingOrderLR extends StatefulWidget {
  const PendingOrderLR({Key? key}) : super(key: key);

  @override
  State<PendingOrderLR> createState() => _PendingOrderLRState();
}

List<String> entriesSelection = ['10', '20', '30', '40'];

class _PendingOrderLRState extends State<PendingOrderLR> with Utility {
  String dropdownValue8 = entriesSelection.first;
  final PendingOrderLr _pendingOrderLr =PendingOrderLr();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Responsive(
            /// Mobile
            mobile: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pendingOrder(),
              widthBox10(),
              ordersList()
            ],
          ),

            /// Tablet
            tablet: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child:
                  pendingOrder(),
                ),
                widthBox10(),
                Expanded(
                  flex: 1,
                  child:
                  ordersList(),
                ),
              ],
            ),

            /// Desktop
            desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: pendingOrder(),
              ),
              widthBox10(),
              Expanded(
                flex: 2,
                child: ordersList(),
              )
            ],
          ),
            ),
        ),
      ),
    );
  }

  pendingOrder(){
    final screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextDecorationClass().heading('Pending Orders For LR'),
          heightBox10(),
          SizedBox(
            height: screenSize.height,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TextDecorationClass().subHeading2('MH20BD${Random().nextInt(9999)} | ',fontSize: 14.0),
                                  TextDecorationClass().subHeading2('Order Date: ${Random().nextInt(31)}-${Random().nextInt(12)}-${Random().nextInt(2050)}',fontSize: 14.0),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    'Hyderabad',
                                    style: TextStyle(color: Colors.orangeAccent),
                                  ),
                                  Icon(
                                    Icons.arrow_right_alt_outlined,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    'Ahmednagar',
                                    style: TextStyle(color: Colors.orangeAccent),
                                  ),
                                ],
                              ),
                              TextDecorationClass().subHeading2('Balaji Transport - Hyderabad',fontSize: 15.0),
                              const SizedBox(height: 10,)
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor, 45.0, 40.0),
                              onPressed: () {},
                              child: const Text('LR',style: TextStyle(fontSize: 15),),
                            ),
                            widthBox5(),
                            ElevatedButton(
                              style: ButtonStyles.customiseButton(ThemeColors.darkRedColor, ThemeColors.whiteColor, 45.0,40.0),
                              onPressed: () {},
                              child: const Icon(Icons.delete,color: Colors.white,size: 17,),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider()
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  ordersList(){
   return Container(
     color: Colors.white,
     margin: const EdgeInsets.all(0),
     padding: const EdgeInsets.all(10),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             TextDecorationClass().heading('Orders'),
             ElevatedButton(
               style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor, 100.0, 50.0),
               onPressed: (){},
               child: const Text('New Order'),
             )
           ],
         ),
         heightBox10(),
         Row(
           children: [
             TextDecorationClass().subHeading2('Show '),
             Container(
               height: 30,
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
                 value: dropdownValue8,
                 elevation: 16,
                 style: const TextStyle(
                     color: ThemeColors.darkGreyColor,
                     fontSize: 16,
                     fontWeight: FontWeight.w700,
                     overflow: TextOverflow.ellipsis),
                 onChanged: (String? newValue) {
                   // This is called when the user selects an item.
                   setState(() {
                     dropdownValue8 = newValue!;
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
             TextDecorationClass().subHeading2(' entries'),
           ],
         ),
         heightBox10(),
         ScrollConfiguration(
           behavior: ScrollConfiguration.of(context).copyWith(
               dragDevices: {
                 PointerDeviceKind.mouse,
                 PointerDeviceKind.trackpad,
                 PointerDeviceKind.touch
               }),
           child: PaginatedDataTable(
             dataRowHeight: 60,
             showFirstLastButtons: true,
             columnSpacing: 10,
             source: _pendingOrderLr,
             rowsPerPage: int.parse(dropdownValue8),
             columns: const [
               DataColumn(label: Text('Ledger')),
               DataColumn(label: Text('From Location')),
               DataColumn(label: Text('To Location')),
               DataColumn(label: Text('No. of Vehicle')),
               DataColumn(label: Text('Assigned Vehicle')),
               DataColumn(label: Text('Order Date')),
               DataColumn(label: Text('Entry By')),
               DataColumn(label: Text('Actions')),
             ],
           ),
         ),
       ],
     ),
   );
  }

}

class PendingOrderLr extends DataTableSource {
  final List<Map<String, dynamic>> _orderData = List.generate(
      100,
          (index) => {
        'ledger': 'PEPSICO INDIA HOLDINGS',
        'from_location': 'Ranjangaon',
        'to_location': 'Ahmedabad',
        'number_of_vehicles': '${Random().nextInt(9)+1}',
        'assigned_vehicles': '${Random().nextInt(10)}',
        'order_date': '${Random().nextInt(31)}-${Random().nextInt(12)}-${Random().nextInt(2050)}',
        'entry_by': 'Person $index',
      });

  @override
  DataRow? getRow(int index) {
    return DataRow(
        color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
        cells: [
      DataCell(Text(_orderData[index]['ledger'].toString())),
      DataCell(Text(_orderData[index]['from_location'].toString())),
      DataCell(Text(_orderData[index]['to_location'].toString())),
      DataCell(Text(_orderData[index]['number_of_vehicles'].toString())),
      DataCell(Text(_orderData[index]['assigned_vehicles'].toString())),
      DataCell(Text(_orderData[index]['order_date'].toString())),
      DataCell(Text(_orderData[index]['entry_by'].toString())),
      DataCell(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              ElevatedButton(
                style: ButtonStyles.customiseButton(ThemeColors.darkRedColor, ThemeColors.whiteColor, 50.0,35.0),
                onPressed: (){},
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor, 50.0,35.0),
                onPressed: (){},
                child: const Text('Assign'),
              ),
            ],
          ),
          const SizedBox(height: 3),
          ElevatedButton(
            style: ButtonStyles.customiseButton(Colors.orangeAccent, ThemeColors.whiteColor, 135.0,35.0),
            onPressed: (){},
            child: const Text('Assign Outdoor'),
          ),
        ],
      )),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _orderData.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
