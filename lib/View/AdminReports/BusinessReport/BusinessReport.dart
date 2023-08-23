import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class BusinessReport extends StatefulWidget {
  const BusinessReport({Key? key}) : super(key: key);

  @override
  State<BusinessReport> createState() => _BusinessReportState();
}

List<String> selectVehicleList = ['All Vehicle' , 'Not Assign' , 'Assign'];
List<String> selectLedgerList = ['Ledger1' , 'Ledger2' , 'Ledger3'];
List<String> entriesDropdownList = ["10" ,"20" ,"30" ,"40"];
List<String> list4 = ["All" , "None"];

class _BusinessReportState extends State<BusinessReport> with Utility{

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
      appBar: UiDecoration.appBar("Business Report"),
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
              child: TextDecorationClass().heading('Business Report'),
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

                  // Select Ledger / Customer
                  Expanded(
                    child: SearchDropdownWidget(dropdownList: selectLedgerList, hintText: "Select Ledger/Customer", onChanged: (value) {
                      selectedItem2 = value!;
                    }, selectedItem: selectedItem2),
                  ),
                  const SizedBox(width: 10,),
                  // Vehicle type dropdown
                  Expanded(
                    child: SearchDropdownWidget(dropdownList: selectVehicleList, hintText: "Select Vehicle", onChanged: (value) {
                      selectedItem3 = value!;
                    }, selectedItem: selectedItem3),
                  ),
                  const SizedBox(width: 10,),
                  // All dropdown
                  Expanded(
                    child: SearchDropdownWidget(dropdownList: list4, hintText: "All", onChanged: (value) {
                      selectedItem4 = value!;
                    }, selectedItem: selectedItem4),
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
                  widthBox10(),
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
                  Expanded(
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
                                          DataColumn(label: Text('Freight Amount')),
                                          DataColumn(label: Text('Type')),
                                          DataColumn(label: Text('Status')),
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
                                        DataCell(Container(padding: const EdgeInsets.only(left: 8 , right: 8 , bottom: 6 , top: 4),
                                          decoration: BoxDecoration(color: Colors.grey , borderRadius: BorderRadius.circular(10)),
                                          child: const Text("Pending",style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500 , fontSize: 13),),)),
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

