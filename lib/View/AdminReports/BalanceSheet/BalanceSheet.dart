import 'dart:convert';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

List<String> entriesList = ["10" ,"20" ,"30" ,"40"];

class BalanceSheet extends StatefulWidget {
  const BalanceSheet({Key? key}) : super(key: key);
  @override
  State<BalanceSheet> createState() => _BalanceSheetState();
}

class _BalanceSheetState extends State<BalanceSheet> with Utility{

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
  final ScrollController _scrollController2 = ScrollController();
  final ScrollController _scrollController3 = ScrollController();
  final _formKey = GlobalKey<FormState>();
  String entriesDropdownValue = entriesList.first;
  int freshLoad = 0;
  List liabilitiesTableList = [];
  int liabilitiesTotal = 0;
  List assetsTableList = [];
  int assetsTotal = 0;

  /// height
  ValueNotifier<double?> leftHeight = ValueNotifier(0.0);
  ValueNotifier<double?> rightHeight = ValueNotifier(0.0);
  ValueNotifier<double?> dividerHeight = ValueNotifier(0.0);
  ValueNotifier<int> currentIndex = ValueNotifier(-1);
  ValueNotifier<int> currentIndex2 = ValueNotifier(-1);

  // API
  balanceSheetFetchFunc(){
    setStateMounted(() { freshLoad = 1; });
    balanceSheetFetch().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        liabilitiesTableList.clear();
        assetsTableList.clear();
        liabilitiesTableList.addAll(info['liabilities']);
        liabilitiesTotal = info['liabilities_total']; // liabilities Total Amount
        assetsTableList.addAll(info['assets']);
        assetsTotal = info['assets_total']; // assets Total Amount
        setStateMounted(() { freshLoad = 0; });
      }else{
        setStateMounted(() { freshLoad = 0; });
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    balanceSheetFetchFunc();
    super.initState();
  }

  @override
  void dispose() {
    GlobalVariable.totalRecords = 0;
    GlobalVariable.totalPages = 0;
    GlobalVariable.currentPage = 0;
    GlobalVariable.next = false;
    GlobalVariable.prev = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Balance Sheet"),
      body: Container(
        margin: const EdgeInsets.all(2),
        decoration: UiDecoration().formDecoration(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10),
                alignment: Alignment.centerLeft,
                child: TextDecorationClass().heading('Balance Sheet'),
              ),
              const Divider(),

              // dropdown & dateField & filter button
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
                        });
                      }, selectedItem: entriesDropdownValue,
                        showSearchBox: false,
                        maxHeight: 200.0,
                      ),
                    ),
                    const Text(' entries'),

                    widthBox30(),
                    const Spacer(),

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

                    // filter button
                    ElevatedButton(
                      style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor,100.0,42.0),
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text("Filter"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20,),

              // From Date || To Date
              Container(
                margin: const EdgeInsets.only(left: 10 , right: 10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration:  BoxDecoration(color: ThemeColors.primaryColor , borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(" From: ${fromDateApi.text} | To: ${toDateApi.text} Records" , style: const TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                  ],),
              ),


              ///------------------START---------------------------------
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    /// Top Field
                    Row(
                      children: [
                        /// left
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.black, width: 1.0),
                                    bottom: BorderSide(color: Colors.black, width: 1.0),
                                    right: BorderSide(color: Colors.black, width: 1.0),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Liabilities",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Amount",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )),

                        /// right
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.black, width: 1.0),
                                    bottom: BorderSide(color: Colors.black, width: 1.0),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Assets",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  // Text("as at 1-May-22"),
                                  Text("Amount",
                                    style: TextStyle(fontWeight: FontWeight.w500),),

                                ],
                              ),
                            )),
                      ],
                    ),

                    /// body
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// left Container
                        Builder(builder: (context) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            leftHeight.value = context.size?.height;
                          });
                          return Expanded(
                            child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child:
                                ListView.builder(
                                  controller: _scrollController2,
                                  shrinkWrap: true,
                                  itemCount: liabilitiesTableList.length,
                                  itemBuilder: (context, index) {
                                    return
                                      Column(
                                        children: [
                                          MouseRegion(
                                            onEnter: (event) {
                                              currentIndex.value = index;
                                            },
                                            onExit: (event) {
                                              currentIndex.value = -1;
                                            },
                                            child: InkWell(
                                              onTap:(){},

                                              child: ValueListenableBuilder(
                                                valueListenable: currentIndex,
                                                builder: (context, value, child) =>
                                                    Container(
                                                      margin: const EdgeInsets.symmetric(vertical: 3),
                                                      color:  value == index ? ThemeColors.primaryColorWithOpacity1 : Colors.white ,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(liabilitiesTableList[index]['group_title']),
                                                          Text(
                                                              liabilitiesTableList[index]['account_balance'] == null ||
                                                                  liabilitiesTableList[index]['account_balance'].toString().isEmpty ? '0' :
                                                              liabilitiesTableList[index]['account_balance'].toString()),
                                                        ],
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                  },)
                            ),
                          );
                        }),

                        /// Divider
                        ValueListenableBuilder(
                          valueListenable: dividerHeight,
                          builder: (context, value, child) => Container(
                            color: Colors.black,
                            width: 1,
                            height: value,
                          ),
                        ),

                        /// right Container
                        Builder(builder: (context) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            rightHeight.value = context.size?.height;
                            if (leftHeight.value! > rightHeight.value!) {
                              dividerHeight.value = leftHeight.value;
                            } else if(rightHeight.value! > leftHeight.value!){
                              dividerHeight.value = rightHeight.value;
                            } else if (leftHeight.value! == rightHeight.value!){
                              dividerHeight.value = rightHeight.value;
                            }
                          });
                          return Expanded(
                              child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  decoration: const BoxDecoration(),
                                  child: ListView.builder(
                                    controller: _scrollController3,
                                    shrinkWrap: true,
                                    itemCount: assetsTableList.length,
                                    itemBuilder: (context, index) {
                                      return
                                        Column(
                                          children: [
                                            MouseRegion(
                                              onEnter: (event) {
                                                currentIndex2.value = index;
                                              },
                                              onExit: (event) {
                                                currentIndex2.value = -1;
                                              },
                                              child: InkWell(
                                                onTap:(){},

                                                child: ValueListenableBuilder(
                                                  valueListenable: currentIndex2,
                                                  builder: (context, value, child) =>
                                                      Container(
                                                        margin: const EdgeInsets.symmetric(vertical: 3),
                                                        color:  value == index ? ThemeColors.primaryColorWithOpacity1 : Colors.white ,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(assetsTableList[index]['group_title']),
                                                            Text(
                                                                assetsTableList[index]['account_balance'] == null ||
                                                                    assetsTableList[index]['account_balance'].toString().isEmpty ? '0' :
                                                                assetsTableList[index]['account_balance'].toString()),
                                                          ],
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                    },)
                              ));
                        }),
                      ],
                    ),

                    /// Total Amount
                    Row(
                      children: [
                        /// left
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.black, width: 1.0),
                                    bottom: BorderSide(color: Colors.black, width: 1.0),
                                    right: BorderSide(color: Colors.black, width: 1.0),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(liabilitiesTotal.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            )),

                        /// right
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.black, width: 1.0),
                                    bottom: BorderSide(color: Colors.black, width: 1.0),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(assetsTotal.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.w500)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              ///-----------------END----------------------------------


              // datatables
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Liabilities Data Table
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      height: MediaQuery.of(context).size.height/1.4,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

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
                                child: freshLoad == 1 ? const Center(child: CircularProgressIndicator(),) : expensesDataTable(),
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Assets Data Table
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      height: MediaQuery.of(context).size.height/1.4,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [

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
                                child: freshLoad == 1 ? const Center(child: CircularProgressIndicator(),) : incomeDataTable(),
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Liabilities DataTable
  Widget expensesDataTable() {
    List<DataRow> tableRowList =  List.generate(liabilitiesTableList.length, (index) {
      return DataRow(
          color: MaterialStatePropertyAll(index == 0 || index % 2 == 0 ? Colors.white : ThemeColors.tableRowColor),
          cells: [
        DataCell(Text(liabilitiesTableList[index]['group_title'])),
        DataCell(Text(liabilitiesTableList[index]['account_balance'].toString())),
      ]);
    });
    return DataTable(
        columnSpacing: 0,
        headingRowColor: MaterialStatePropertyAll(ThemeColors.primaryColorWithOpacity1),
        dividerThickness: 0,
        sortColumnIndex: 0,
        sortAscending: false,
        columns: const [
          DataColumn(label: Text("Liabilities")),
          DataColumn(numeric: true,label: Text("Amount")),
        ],
        rows: tableRowList +  [
          DataRow(
              color: MaterialStatePropertyAll(ThemeColors.primaryColorWithOpacity1),
              cells: [
                const DataCell(Text("Total", style: TextStyle(fontWeight: FontWeight.bold),)),
                DataCell(Text("$liabilitiesTotal", style: const TextStyle(fontWeight: FontWeight.bold),)),
              ])
        ]
    );
  }

  /// Assets DataTable
  Widget incomeDataTable() {
    List<DataRow> tableRowList = List.generate(assetsTableList.length, (index) {
      return DataRow(
        color: MaterialStatePropertyAll( index == 0 || index % 2 == 0 ? Colors.white : ThemeColors.tableRowColor),
          cells: [
        DataCell(Text(assetsTableList[index]['group_title'].toString())),
        DataCell(Text(assetsTableList[index]['account_balance'].toString())),
      ]);
    });
    return DataTable(
        columnSpacing: 0,
        headingRowColor: MaterialStatePropertyAll(ThemeColors.primaryColorWithOpacity1),
        dividerThickness: 0,
        sortColumnIndex: 0,
        sortAscending: false,
        columns: const [
          DataColumn(label: Text("Assets")),
          DataColumn(numeric: true,label: Text("Amount")),
        ],
        rows: tableRowList +  [
          DataRow(
              color: MaterialStatePropertyAll(ThemeColors.primaryColorWithOpacity1),
              cells: [
                const DataCell(Text("Total", style: TextStyle(fontWeight: FontWeight.bold),)),
                DataCell(Text("$assetsTotal", style: const TextStyle(fontWeight: FontWeight.bold),)),
              ])
        ]
    );
  }

  // Api
  Future balanceSheetFetch() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/BalanceSheetLiabilities");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  setStateMounted(VoidCallback fn){
    if(mounted){
    setState(fn);
    }
  }
}

