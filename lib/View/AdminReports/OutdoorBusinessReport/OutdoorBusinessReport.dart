import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

import 'package:pfc/utility/utility.dart';

class OutdoorBusinessReport extends StatefulWidget {
  const OutdoorBusinessReport({Key? key}) : super(key: key);

  @override
  State<OutdoorBusinessReport> createState() => _OutdoorBusinessReportState();
}

List<String> selectVehicleList = ['All Vehicle' , 'Not Assign' , 'Assign'];
List<String> selectLedgerList = ['Ledger1' , 'Ledger2' , 'Ledger3'];
List<String> entriesDropdownList = ["10" ,"20" ,"30" ,"40"];
List<String> list4 = ["All" , "None"];

class _OutdoorBusinessReportState extends State<OutdoorBusinessReport> with Utility{

  String assignDropdownValue = selectVehicleList.first;
  String selectLedgerValue = selectLedgerList.first;
  String entriesDropdownValue = entriesDropdownList.first;
  TextEditingController fromDateUI = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController toDateUI = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedItem1 = '';
  String selectedItem2 = '';
  String selectedItem3 = '';
  String selectedItem4 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Outdoor Business Report"),
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
              child: TextDecorationClass().heading('Outdoor Business Report'),
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
                  Expanded(
                    child: SearchDropdownWidget(dropdownList: selectLedgerList, hintText: "Select Ledger/Customer", onChanged: (value) {
                      selectedItem2 = value!;
                    }, selectedItem: selectedItem2),
                  ),
                  const SizedBox(width: 30,),
                  // Vehicle type dropdown
                  Expanded(
                    child: SearchDropdownWidget(dropdownList: selectVehicleList, hintText: "Select Vehicle", onChanged: (value) {
                      selectedItem3 = value!;
                    }, selectedItem: selectedItem3),
                  ),
                  const SizedBox(width: 30,),
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

                  // SizedBox(
                  //   height: 35,
                  //   width: 150,
                  //   child: TextFormField(
                  //     readOnly: true,
                  //     controller: fromDateUI,
                  //     decoration: UiDecoration().dateFieldDecoration('From Date'),
                  //     onTap: (){
                  //       UiDecoration().showDatePickerDecoration(context).then((value){
                  //         setState(() {
                  //           String month = value.month.toString().padLeft(2, '0');
                  //           String day = value.day.toString().padLeft(2, '0');
                  //           fromDateUI.text = "$day-$month-${value.year}";
                  //           fromDateApi.text = "${value.year}-$month-$day";
                  //         });
                  //       });
                  //     },
                  //   ),
                  // ),
                  widthBox30(),
                  // SizedBox(
                  //   height: 35,
                  //   width: 150,
                  //   child: TextFormField(
                  //     readOnly: true,
                  //     controller: toDateUI,
                  //     decoration: UiDecoration().dateFieldDecoration('To Date'),
                  //     onTap: (){
                  //       UiDecoration().showDatePickerDecoration(context).then((value){
                  //         setState(() {
                  //           String month = value.month.toString().padLeft(2, '0');
                  //           String day = value.day.toString().padLeft(2, '0');
                  //           toDateUI.text = "$day-$month-${value.year}";
                  //           toDateApi.text = "${value.year}-$month-$day";
                  //         });
                  //       });
                  //     },
                  //   ),
                  // ),
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

            // All LRs | All Time Record
            Container(
              margin: const EdgeInsets.only(left: 10 , right: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration:  BoxDecoration(color: ThemeColors.primaryColor , borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("All LRs | All Time Records" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                ],),
            ),

            // DataTable
            Expanded(
                child: SingleChildScrollView(
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
                                    DataColumn(label: Text('LR No.')),
                                    DataColumn(label: Text('LR Date')),
                                    DataColumn(label: Text('Ledger')),
                                    DataColumn(label: Text('Vehicle No.')),
                                    DataColumn(label: Text('From Location')),
                                    DataColumn(label: Text('To Location')),
                                    DataColumn(label: Text('PFC Freight')),
                                    DataColumn(label: Text('TPT Freight')),
                                    DataColumn(label: Text('P/L')),
                                  ],
                                  rows: List.generate(50, (index) {
                                    return DataRow(
                                        color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
                                        cells: [
                                      DataCell(Text("$index")),
                                      const DataCell(Text("29-11-2022")),
                                      DataCell(Text("$index LedgerName")),
                                      DataCell(Text("MH$index 2031232")),
                                      const DataCell(Text("Mumbai")),
                                      const DataCell(Text("Chennai")),
                                      const DataCell(Text("7000")),
                                      const DataCell(Text("Indoor",style: TextStyle(color: Colors.green),)),
                                      const DataCell(Text("7000")),
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

