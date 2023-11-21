import 'dart:convert';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AdvanceReport extends StatefulWidget {
  int? vehicleId;

  AdvanceReport({Key? key, required this.vehicleId}) : super(key: key);

  @override
  State<AdvanceReport> createState() => _AdvanceReportState();
}

class _AdvanceReportState extends State<AdvanceReport>
    with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  // final DataTableSource _data = MyData();
  final ScrollController _scrollController1 = ScrollController();
  int index = 0;
  int currentPageAtm = 1;
  int currentPageDiesel = 1;
  int currentPageCash = 1;
  int totalPagesAtm = 0;
  int totalPagesDiesel = 0;
  int totalPagesCash = 0;
  int? vehicleId;
  int freshLoad = 0;
  int freshLoad2 = 0;
  List advAtmTransactionList = [];
  List advDieselTransactionList = [];
  List advCashTransactionList = [];
  TextEditingController searchAtm = TextEditingController();
  TextEditingController searchDiesel = TextEditingController();
  TextEditingController searchCash = TextEditingController();
  DateTimeRange? _dateRange;
  TextEditingController dateRangeController = TextEditingController();
  TextEditingController search = TextEditingController();
  var formattedStartDateApi = '';
  var formattedEndDateApi = '';

  advAtmTransactionListApiFunc() {
    setStateMounted(() {
      advAtmTransactionList.isEmpty ? freshLoad = 1 : freshLoad = 0;
      freshLoad2 = 1;
    });
    advAtmTransactionListApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        // advAtmTransactionList.clear();
        advAtmTransactionList.addAll(info['data']);
        totalPagesAtm = info['total_pages'];
        // print(currentPageAtm);
        setStateMounted(() {
          freshLoad = 0;
          freshLoad2 = 0;
        });
      } else {
        // AlertBoxes.flushBarErrorMessage(info['message']+' In ATM Advance', context);
        setState(() {
          freshLoad = 0;
          freshLoad2 = 0;
        });
      }
      print('gfdasdoshfj:$advCashTransactionList');
    });
  }

  advDieselTransactionListApiFunc() {
    setStateMounted(() {
      advDieselTransactionList.isEmpty ? freshLoad = 1 : freshLoad = 0;
      freshLoad2 = 1;
    });
    advDieselTransactionListApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        // advAtmTransactionList.clear();
        advDieselTransactionList.addAll(info['data']);
        totalPagesDiesel = info['total_pages'];
        setStateMounted(() {
          freshLoad = 0;
          freshLoad2 = 0;
        });
      } else {
        // AlertBoxes.flushBarErrorMessage(info['message']+' In DIESEL Advance', context);
        setState(() {
          freshLoad = 0;
          freshLoad2 = 0;
        });
      }
    });
  }

  advCashTransactionListApiFunc() {
    setStateMounted(() {
      advCashTransactionList.isEmpty ? freshLoad = 1 : freshLoad = 0;
      freshLoad2 = 1;
    });
    advCashTransactionListApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        // advAtmTransactionList.clear();
        advCashTransactionList.addAll(info['data']);
        totalPagesCash = info['total_pages'];
        setStateMounted(() {
          freshLoad = 0;
          freshLoad2 = 0;
        });
      } else {
        // AlertBoxes.flushBarErrorMessage(info['message']+' In CASH Advance', context);
        setState(() {
          freshLoad = 0;
          freshLoad2 = 0;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    advAtmTransactionListApiFunc();
    advDieselTransactionListApiFunc();
    advCashTransactionListApiFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.25,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: ThemeColors.boxShadow, blurRadius: 5.0, spreadRadius: 3),
          ]),
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.only(top: 0, bottom: 0, right: 10, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Driver Statistics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Advance Report',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: dateRangeController,
                    readOnly: true,
                    onTap: () {
                      _showDateRangePicker();
                    },
                    decoration: UiDecoration()
                        .dateFieldDecoration('Select From Date and To Date'),
                  )),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.all(0),
                height: 40,
                child: AnimSearchBar(
                  width: 230,
                  boxShadow: false,
                  textController: search,
                  onSuffixTap: () {},
                  onSubmitted: (p0) {
                    setStateMounted(() {
                      search.text = p0;
                      advDieselTransactionList.clear();
                      advAtmTransactionList.clear();
                      advCashTransactionList.clear();
                    });
                    advDieselTransactionListApiFunc();
                    advAtmTransactionListApiFunc();
                    advCashTransactionListApiFunc();
                  },
                  suffixIcon: const Icon(CupertinoIcons.xmark_circle, size: 20),
                ),
              ),
              // Text('History', style: TextStyle(fontSize: 13 , fontWeight: FontWeight.w500 , color: Colors.grey.shade700),),
            ],
          ),
          const Divider(),

          /// tabBar || tabBarView
          Expanded(
            child: Column(
              children: [
                /// TabBar
                SizedBox(
                  child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      onTap: (value) {
                        setState(() {
                          index = value;
                        });
                      },
                      indicatorWeight: 0.0,
                      indicator: BoxDecoration(
                          color: index == 0
                              ? ThemeColors.darkRedColor
                              : index == 1
                                  ? Colors.black
                                  : Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      tabs: const [
                        Tab(
                          child: Text("ATM Advance"),
                        ),
                        Tab(
                          child: Text("Diesel Advance"),
                        ),
                        Tab(
                          child: Text("Cash Advance"),
                        ),
                      ]),
                ),

                ///TabBarView
                Expanded(
                  child: TabBarView(controller: _tabController, children: [
                    /// 1
                    freshLoad == 1
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : advAtmTransactionList.isEmpty
                            ? Center(
                                child: TextDecorationClass()
                                    .heading1('Data Not Available'))
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: advAtmTransactionList.length,
                                      itemBuilder: (context, index) {
                                        return SingleChildScrollView(
                                          controller: _scrollController1,
                                          child: ScrollConfiguration(
                                            behavior:
                                                ScrollConfiguration.of(context)
                                                    .copyWith(dragDevices: {
                                              PointerDeviceKind.touch,
                                              PointerDeviceKind.mouse,
                                              PointerDeviceKind.trackpad
                                            }),
                                            child: Column(
                                              children: [
                                                UiDecoration().reportTable(
                                                    UiDecoration().getFormattedDate(
                                                        advAtmTransactionList[index]
                                                            ['entry_date']),
                                                    advAtmTransactionList[index]
                                                            ['ledger_title'] ??
                                                        '-',
                                                    advAtmTransactionList[index]
                                                            ['amount']
                                                        .toString(),
                                                    advAtmTransactionList[index]
                                                                ['remark'] ==
                                                            null
                                                        ? '-'
                                                        : advAtmTransactionList[index]
                                                                ['remark']
                                                            .toString(),
                                                    advAtmTransactionList[index]
                                                                ['user_name'] ==
                                                            null
                                                        ? '-'
                                                        : advAtmTransactionList[index]
                                                                ['user_name']
                                                            .toString()),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    // Pagination
                                    currentPageAtm == totalPagesAtm
                                        ? const SizedBox()
                                        : freshLoad2 == 1
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  setStateMounted(() {
                                                    currentPageAtm =
                                                        currentPageAtm + 1;
                                                  });
                                                  // widget.routesListApiFunc;
                                                  advAtmTransactionListApiFunc();
                                                },
                                                child: Text(
                                                  'Show More',
                                                  style: TextStyle(
                                                      color: ThemeColors
                                                          .darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                ),
                                              ),
                                    const SizedBox(height: 10)
                                  ],
                                ),
                              ),

                    /// 2
                    freshLoad == 1
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : advDieselTransactionList.isEmpty
                            ? Center(
                                child: TextDecorationClass()
                                    .heading1('Data Not Available'))
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          advDieselTransactionList.length,
                                      itemBuilder: (context, index) {
                                        return SingleChildScrollView(
                                          controller: _scrollController1,
                                          child: ScrollConfiguration(
                                            behavior:
                                                ScrollConfiguration.of(context)
                                                    .copyWith(dragDevices: {
                                              PointerDeviceKind.touch,
                                              PointerDeviceKind.mouse,
                                              PointerDeviceKind.trackpad
                                            }),
                                            child: Column(
                                              children: [
                                                UiDecoration().reportTable(
                                                    UiDecoration().getFormattedDate(
                                                        advDieselTransactionList[index]
                                                            ['entry_date']),
                                                    advDieselTransactionList[index]
                                                            ['ledger_title'] ??
                                                        '-',
                                                    advDieselTransactionList[index]
                                                            ['amount']
                                                        .toString(),
                                                    advDieselTransactionList[index]
                                                                ['remark'] ==
                                                            null
                                                        ? '-'
                                                        : advDieselTransactionList[index]
                                                                ['remark']
                                                            .toString(),
                                                    advDieselTransactionList[index]
                                                                ['user_name'] ==
                                                            null
                                                        ? '-'
                                                        : advDieselTransactionList[index]
                                                                ['user_name']
                                                            .toString()),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    // Pagination
                                    currentPageDiesel == totalPagesDiesel
                                        ? const SizedBox()
                                        : freshLoad2 == 1
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  setStateMounted(() {
                                                    currentPageDiesel =
                                                        currentPageDiesel + 1;
                                                  });
                                                  // widget.routesListApiFunc;
                                                  advDieselTransactionListApiFunc();
                                                },
                                                child: Text(
                                                  'Show More',
                                                  style: TextStyle(
                                                      color: ThemeColors
                                                          .darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                ),
                                              ),
                                    const SizedBox(height: 10)
                                  ],
                                ),
                              ),

                    /// 3
                    freshLoad == 1
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : advCashTransactionList.isEmpty
                            ? Center(
                                child: TextDecorationClass()
                                    .heading1('Data Not Available'))
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: advCashTransactionList.length,
                                      itemBuilder: (context, index) {
                                        return SingleChildScrollView(
                                          controller: _scrollController1,
                                          child: ScrollConfiguration(
                                            behavior:
                                                ScrollConfiguration.of(context)
                                                    .copyWith(dragDevices: {
                                              PointerDeviceKind.touch,
                                              PointerDeviceKind.mouse,
                                              PointerDeviceKind.trackpad
                                            }),
                                            child: Column(
                                              children: [
                                                UiDecoration().reportTable(
                                                    UiDecoration().getFormattedDate(advCashTransactionList[index]['entry_date']),
                                                    advCashTransactionList[index]['ledger_title'] ?? '-',
                                                    advCashTransactionList[index]['amount'].toString(),
                                                    advCashTransactionList[index]['remark'] ==null? '-': advCashTransactionList[index]['remark'].toString(),
                                                    advCashTransactionList[index]['user_name'] ==null? '-': advCashTransactionList[index]['user_name'].toString()),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    // Pagination
                                    currentPageCash == totalPagesCash
                                        ? const SizedBox()
                                        : freshLoad2 == 1
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  setStateMounted(() {
                                                    currentPageCash =currentPageCash + 1;
                                                  });
                                                  // widget.routesListApiFunc;
                                                  advCashTransactionListApiFunc();
                                                },
                                                child: Text(
                                                  'Show More',
                                                  style: TextStyle(
                                                      color: ThemeColors
                                                          .darkBlueColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15),
                                                ),
                                              ),
                                    const SizedBox(height: 10)
                                  ],
                                ),
                              ),
                  ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showDateRangePicker() async {
    final initialDate = _dateRange?.start ?? DateTime.now();
    final dateRange = await showDateRangePicker(
        useRootNavigator: true,
        context: context,
        cancelText: 'CANCEL',
        confirmText: 'Conform',
        firstDate: DateTime(1995),
        lastDate: DateTime(DateTime.now().year + 50),
        saveText: 'SUBMIT',
        initialDateRange:
            _dateRange ?? DateTimeRange(start: initialDate, end: initialDate),
        builder: (context, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: child,
                ),
              )
            ],
          );
        });

    if (dateRange != null) {
      setState(() {
        _dateRange = dateRange;
        final formattedStartDate = DateFormat('dd-MM-yyyy').format(dateRange.start);
        final formattedEndDate = DateFormat('dd-MM-yyyy').format(dateRange.end);

        // final formattedStartDate = DateFormat.yMd().format(dateRange.start);
        formattedStartDateApi =
            DateFormat('yyyy-MM-dd').format(dateRange.start);
        formattedEndDateApi = DateFormat('yyyy-MM-dd').format(dateRange.end);
        // final formattedEndDate = DateFormat.yMd().format(dateRange.end);
        dateRangeController.text = '$formattedStartDate to $formattedEndDate';

        advAtmTransactionList.clear();
        advAtmTransactionListApiFunc();
        advDieselTransactionList.clear();
        advDieselTransactionListApiFunc();
        advCashTransactionList.clear();
        advCashTransactionListApiFunc();
      });
    }
  }

  Future advAtmTransactionListApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.trafficBaseURL}apis/GetATM?vehicle_id=${widget.vehicleId}&limit=10&page=$currentPageAtm&from_date=$formattedStartDateApi&to_date=$formattedEndDateApi&keyword=${search.text}');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  Future advDieselTransactionListApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.trafficBaseURL}apis/GetBPCL?vehicle_id=${widget.vehicleId}&limit=10&page=$currentPageDiesel&from_date=$formattedStartDateApi&to_date=$formattedEndDateApi&keyword=${search.text}');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  Future advCashTransactionListApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.trafficBaseURL}apis/GetCash?vehicle_id=${widget.vehicleId}&limit=10&page=$currentPageCash&from_date=$formattedStartDateApi&to_date=$formattedEndDateApi&keyword=${search.text}');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
