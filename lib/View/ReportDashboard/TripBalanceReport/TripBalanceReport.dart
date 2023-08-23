import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

import 'package:pfc/utility/utility.dart';

class TripBalanceReport extends StatefulWidget {
  const TripBalanceReport({Key? key}) : super(key: key);

  @override
  State<TripBalanceReport> createState() => _TripBalanceReportState();
}

List<String> selectVehicleList = ['Vehicle1' , 'Vehicle2' , 'Vehicle3'];
List<String> entriesDropdownList = ["10" ,"20" ,"30" ,"40"];

class _TripBalanceReportState extends State<TripBalanceReport> with Utility{

  String driverValue = selectVehicleList.first;
  String entriesDropdownValue = entriesDropdownList.first;
  TextEditingController fromDateUI = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController toDateUI = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String selectedItem1 = '';
  String selectedItem2 = '';
  String selectedItem3 = '';
  String selectedItem4 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Trip Balance Report"),
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
              child: TextDecorationClass().heading('Trip Balance Report'),
            ),

            const Divider(),

            // dropdown | From date | To Date
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // entries dropdown
                  SizedBox(
                    width: 80,
                    child: SearchDropdownWidget(dropdownList: entriesDropdownList, hintText: "10", onChanged: (value) {
                      entriesDropdownValue = value!;
                    }, selectedItem: selectedItem1),
                  ),

                  const Text(' entries'),
                  widthBox20(),
                  const Spacer(),
                  // Select Ledger / Customer
                  SizedBox(
                    width: 300,
                    child: SearchDropdownWidget(dropdownList: selectVehicleList, hintText: "Select Vehicle", onChanged: (value) {
                      selectedItem2 = value!;
                    }, selectedItem: selectedItem2),
                  ),
                  const SizedBox(width: 30,),

                  SizedBox(
                    height: 35,
                    width: 150,
                    child: TextFormField(
                      readOnly: true,
                      controller: fromDateUI,
                      decoration: UiDecoration().dateFieldDecoration('From Date'),
                      onTap: (){
                        UiDecoration().showDatePickerDecoration(context).then((value){
                          setState(() {
                            String month = value.month.toString().padLeft(2, '0');
                            String day = value.day.toString().padLeft(2, '0');
                            fromDateUI.text = "$day-$month-${value.year}";
                            fromDateApi.text = "${value.year}-$month-$day";
                          });
                        });
                      },
                    ),
                  ),
                  widthBox30(),
                  SizedBox(
                    height: 35,
                    width: 150,
                    child: TextFormField(
                      readOnly: true,
                      controller: toDateUI,
                      decoration: UiDecoration().dateFieldDecoration('To Date'),
                      onTap: (){
                        UiDecoration().showDatePickerDecoration(context).then((value){
                          setState(() {
                            String month = value.month.toString().padLeft(2, '0');
                            String day = value.day.toString().padLeft(2, '0');
                            toDateUI.text = "$day-$month-${value.year}";
                            toDateApi.text = "${value.year}-$month-$day";
                          });
                        });
                      },
                    ),
                  ),
                  widthBox30(),
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor,100.0,42.0),
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
                  TextDecorationClass().subHeading2('Search '),
                  // Search
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                        controller: searchController,
                        decoration:
                        UiDecoration().outlineTextFieldDecoration('Search',ThemeColors.primaryColor)
                    ),
                  ),
                  const SizedBox(width: 10,)
                ],
              ),
            ),

            const SizedBox(height: 20,),

            // Trip Balance Report
            Container(
              margin: const EdgeInsets.only(left: 10 , right: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration:  BoxDecoration(color: ThemeColors.primaryColor , borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Trip Balance Report" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                ],),
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
                            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                            child:
                            SizedBox(
                              width: double.maxFinite,
                              child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Trip No.')),
                                    DataColumn(label: Text('Vehicle Number')),
                                    DataColumn(label: Text('Driver Name')),
                                    DataColumn(label: Text('Trip Start Date')),
                                    DataColumn(label: Text('Trip End Date')),
                                    DataColumn(label: Text('Settled Date')),
                                    DataColumn(label: Text('Payable')),
                                    DataColumn(label: Text('Receivable')),
                                    DataColumn(label: Text('Action')),
                                  ],
                                  rows: List.generate(500, (index) {
                                    return DataRow(
                                        color:index == 0 || index % 2 == 0
                                            ? MaterialStatePropertyAll(
                                            Colors.grey.shade400)
                                            :const MaterialStatePropertyAll(
                                            ThemeColors.whiteColor),
                                        cells: [
                                          DataCell(Text("${index}92312")),
                                          DataCell(Text("MH$index 2031232")),
                                          const DataCell(Text("Tayyar Essa Shaikh")),
                                          const DataCell(Text("01-08-2022")),
                                          const DataCell(Text("08-08-2022")),
                                          const DataCell(Text("09-04-2023")),
                                          const DataCell(Text("0")),
                                          const DataCell(Text("2400")),
                                          DataCell(
                                             index == 0 || index == 3 || index == 4 ? ElevatedButton(
                                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                                 onPressed: () {

                                                 }, child: const Text("Pay" , style: TextStyle(color: Colors.white),)) : ElevatedButton(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                              onPressed: () {

                                              }, child: const Text("Receive" , style: TextStyle(color: Colors.white),))),
                                        ]);
                                  })
                              ),
                            )
                        )
                      ],
                    ))),

            /// Pagination
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //
            //     Text("${GlobalVariable.totalRecords} Total Records"),
            //     const SizedBox(width: 30,),
            //
            //     // First Page Button
            //     IconButton(onPressed: !GlobalVariable.prev ? null : () {
            //
            //       setState(() {
            //         GlobalVariable.currentPage = 1;
            //         paymentTransactionListApiFunc();
            //       });
            //
            //     }, icon: const Icon(Icons.first_page)),
            //
            //     // Previous Button
            //     IconButton(onPressed: !GlobalVariable.prev ? null : () {
            //
            //       setState(() {
            //         GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
            //         paymentTransactionListApiFunc();
            //       });
            //
            //     }, icon: const Icon(CupertinoIcons.left_chevron)),
            //
            //     const SizedBox(width: 30,),
            //
            //     // Next Button
            //     IconButton(onPressed: !GlobalVariable.next ? null : () {
            //
            //       setState(() {
            //         GlobalVariable.currentPage < GlobalVariable.totalPages ? GlobalVariable.currentPage++  :
            //         GlobalVariable.currentPage = GlobalVariable.totalPages;
            //         paymentTransactionListApiFunc();
            //       });
            //
            //     }, icon: const Icon(CupertinoIcons.right_chevron)),
            //
            //     // Last Page Button
            //     IconButton(onPressed: !GlobalVariable.next ? null : () {
            //
            //       setState(() {
            //         GlobalVariable.currentPage = GlobalVariable.totalPages;
            //         paymentTransactionListApiFunc();
            //       });
            //
            //     }, icon: const Icon(Icons.last_page)),
            //
            //   ],
            // ),

          ],
        ),
      ),
    );
  }

}

