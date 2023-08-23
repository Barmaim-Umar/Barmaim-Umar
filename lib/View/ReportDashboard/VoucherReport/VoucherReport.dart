import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/Widgets/searchDataTable.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class VoucherReport extends StatefulWidget {
  const VoucherReport({Key? key}) : super(key: key);

  @override
  State<VoucherReport> createState() => _VoucherReportState();
}

List<String> vouchersList = ['BPCL' , 'Cash' , 'ATM','Journal','Payment','Receipt','OnAccount','FastTag'];
List<String> entriesList = ["10" ,"20" ,"30" ,"40"];

class _VoucherReportState extends State<VoucherReport> with Utility{
  List voucherList = [];
  int freshLoad = 1;
  String vouchersDropdownValue = "";
  String entriesDropdownValue = entriesList.first;
  TextEditingController fromDateUiController = TextEditingController();
  TextEditingController fromDateApiController = TextEditingController();
  TextEditingController toDateUiController = TextEditingController();
  TextEditingController toDateApiController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List voucherReportColumns = [
    {
      'column_name' : 'Date',
      'column_value' : 'accounts__vouchers.entry_date'
    },
    {
      'column_name' : 'Particulars',
      'column_value' : 'acc_one.ledger_title'
    },
    {
      'column_name' : 'Voucher No.',
      'column_value' : 'accounts__vouchers.voucher_id ',
    },
    {
      'column_name' : 'Voucher Type',
      'column_value' : 'accounts__vouchers.voucher_type',
    },
    {
      'column_name' : 'Amount',
      'column_value' : 'accounts__vouchers.amount',
    },
    {
      'column_name' : 'Entry By',
      'column_value' : 'accounts__vouchers.entry_by',
    },
    {
      'column_name' : 'Actions',
      'column_value' : '',
    },
  ];
  var keyword;
  int currentIndex = 0;

  // API
  voucherListApiFunc(){
    voucherList.clear();
    setState(() {
      freshLoad = 1;
    });
    voucherListApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        voucherList.addAll(info['data']);
        setState(() {
          GlobalVariable.totalRecords = info['total_records'];
          GlobalVariable.totalPages = info['total_pages'];
          GlobalVariable.currentPage = info['page'];
          GlobalVariable.next = info['next'];
          GlobalVariable.prev = info['prev'];
          freshLoad = 0;
        });
      } else {
        debugPrint("SUCCESS FALSE");
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  void initState() {
    voucherListApiFunc();
    keyword = voucherReportColumns[0]['column_value'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Voucher Report"),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              alignment: Alignment.centerLeft,
              child: TextDecorationClass().heading('Voucher Report'),
            ),
            const Divider(),
            // dropdown , fromDate , toDate , filter Button
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // entries dropdown
                  SizedBox(
                    width: 80,
                    child: SearchDropdownWidget(dropdownList: entriesList, hintText: entriesList.first, onChanged: (value) {
                      // This is called when the user selects an item.
                      setState(() {
                        entriesDropdownValue = value!;
                        voucherListApiFunc();
                      });
                    }, selectedItem: entriesDropdownValue),
                  ),
                  const Text(' entries'),

                  widthBox30(),
                  widthBox10(),

                  // Vouchers dropdown
                  Expanded(
                    child: SearchDropdownWidget(dropdownList: vouchersList, hintText: "Please Select Voucher", onChanged: (value) {
                      // This is called when the user selects an item.
                      setState(() {
                        vouchersDropdownValue = value!;
                        keyword = voucherReportColumns[3]['column_value'];
                        voucherListApiFunc();
                      });
                    }, selectedItem: vouchersDropdownValue),
                  ),

                  const SizedBox(width: 10,),

                  // fromDate
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: TextFormField(
                        readOnly: true,
                        controller: fromDateUiController,
                        decoration: UiDecoration().dateFieldDecoration('From Date'),
                        onTap: (){
                          UiDecoration().showDatePickerDecoration(context).then((value){
                            setState(() {
                              String month = value.month.toString().padLeft(2, '0');
                              String day = value.day.toString().padLeft(2, '0');
                              fromDateUiController.text = "$day-$month-${value.year}";
                              fromDateApiController.text = "${value.year}-$month-$day";
                            });
                          });
                        },
                      ),
                    ),
                  ),

                  widthBox10(),

                  // toDate
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: TextFormField(
                        readOnly: true,
                        controller: toDateUiController,
                        decoration: UiDecoration().dateFieldDecoration('To Date'),
                        onTap: (){
                          UiDecoration().showDatePickerDecoration(context).then((value){
                            setState(() {
                              String month = value.month.toString().padLeft(2, '0');
                              String day = value.day.toString().padLeft(2, '0');
                              toDateUiController.text = "$day-$month-${value.year}";
                              toDateApiController.text = "${value.year}-$month-$day";
                            });
                          });
                        },
                      ),
                    ),
                  ),

                  widthBox10(),

                  // Filter Button
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor,100.0,42.0),
                    onPressed: () {
                      voucherListApiFunc();
                    },
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
                ],
              ),
            ),

            const SizedBox(height: 20,),

            // Voucher Report
            Container(
              margin: const EdgeInsets.only(left: 10 , right: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration:  BoxDecoration(color: ThemeColors.primaryColor , borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Voucher Report" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                ],),
            ),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Dr Opening Amount
                        Row(
                          children: [
                            Expanded(child: UiDecoration().totalAmountLabel("Opening Amount")),
                            Expanded(child: UiDecoration().totalAmount("0.00")),
                          ],
                        ),

                        /// DataTable
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5 , vertical: 5),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: ThemeColors.whiteColor,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                            child: freshLoad == 1 ? const Center(child: Text("FreshLoad = 1 \nPlease Wait..."),) :
                            /// Data table
                            buildDataTable(),
                          ),
                        ),

                        Row(
                          children: [
                            /// Prev Button
                            Row(
                              children: [
                                const SizedBox(
                                  width: 3,
                                ),
                                GlobalVariable.prev == true
                                    ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        GlobalVariable.currentPage = 1;
                                        voucherListApiFunc();
                                      });
                                    },
                                    child: const Text(
                                      'First Page',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    ))
                                    : const SizedBox(),
                                const SizedBox(width: 10),
                                GlobalVariable.prev == true
                                    ? Text(
                                  'Prev',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade700),
                                )
                                    : const SizedBox(),
                                IconButton(
                                    onPressed: GlobalVariable.prev == false
                                        ? null
                                        : () {
                                      setState(() {
                                        GlobalVariable.currentPage > 1
                                            ? GlobalVariable.currentPage--
                                            : GlobalVariable.currentPage = 1;
                                        voucherListApiFunc();
                                      });
                                    },
                                    icon: const Icon(Icons.chevron_left)),
                              ],
                            ),
                            const SizedBox(
                              width: 30,
                            ),

                            /// Next Button
                            Row(
                              children: [
                                IconButton(
                                  onPressed: GlobalVariable.next == false
                                      ? null
                                      : () {
                                    setState(() {
                                      GlobalVariable.currentPage++;
                                      voucherListApiFunc();
                                    });
                                  },
                                  icon: const Icon(Icons.chevron_right),
                                ),
                                GlobalVariable.next == true
                                    ? Text(
                                  'Next',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade700),
                                )
                                    : const SizedBox(),
                                const SizedBox(
                                  width: 10,
                                ),
                                GlobalVariable.next == true
                                    ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        GlobalVariable.currentPage = GlobalVariable.totalPages;
                                        voucherListApiFunc();
                                      });
                                    },
                                    child: const Text(
                                      'Last Page',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    ))
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),

                        /// Dr Closing Amount
                        Row(
                          children: [
                            Expanded(
                              child: UiDecoration().totalAmountLabel("Dr Closing Amount"),
                            ),
                            Expanded(
                                child: UiDecoration().totalAmount("386214.40")
                            ),
                          ],
                        ),

                      ],
                    ))),
          ],
        ),
      ),
    );
  }

  Widget buildDataTable() {
    return voucherList.isEmpty ? const Center(child: Text("voucherList.isEmpty \nUpdating List..."),) : DataTable(
      columnSpacing: 20,
      columns: List.generate(voucherReportColumns.length, (index) =>
          DataColumn(label: InkWell(
            onTap: () {
              setState(() {
                currentIndex = index;
                keyword = voucherReportColumns[index]['column_value'];
              });
            },
            child: SearchDataTable(
                onFieldSubmitted: (value) {
                  voucherListApiFunc();
                },
                isSelected: index == 6 ? false : index == currentIndex,
                search: searchController,
                columnName: voucherReportColumns[index]['column_name']
            ),
          )
          )
      ),


      rows:  List.generate(voucherList.length, (index) {
        return DataRow(
            cells: [
              DataCell(TextDecorationClass().dataRowCell(voucherList[index]['entry_date'])),
              DataCell(TextDecorationClass().dataRowCell(voucherList[index]['ledger_title'].toString())),
              DataCell(TextDecorationClass().dataRowCell(voucherList[index]['voucher_id'].toString())),
              DataCell(TextDecorationClass().dataRowCell(voucherList[index]['voucher_type'])),
              DataCell(TextDecorationClass().dataRowCell(voucherList[index]['amount'].toString())),
              DataCell(TextDecorationClass().dataRowCell(voucherList[index]['entry_by'].toString())),
              DataCell(Row(
                children: [
                  UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                      padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
                  const SizedBox(width: 5),
                  UiDecoration().actionButton( ThemeColors.deleteColor, IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setState((){

                        });
                      },
                      icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),

                ],
              )),
            ]);
      }),

    );
  }

  // API
  Future voucherListApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/PaymentVoucherTransactionList?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&from_date=${fromDateApiController.text}&to_date=${toDateApiController.text}&keyword=${searchController.text}&column=$keyword&filter=$vouchersDropdownValue");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }
}

