import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/View/AccountsReports/AtmAdv/AdvanceAtmList.dart';
import 'package:pfc/View/AdminReports/BusinessReport/BusinessReport.dart';
import 'package:pfc/View/ReportDashboard/DriverSalaryReport/DriverSalaryReport.dart';
import 'package:pfc/View/LRReports/LRDocuments/LRDocs.dart';
import 'package:pfc/View/LRReports/AllLR/AllLR.dart';
import 'package:pfc/View/TrafficReports/KmsReport/KMReport.dart';
import 'package:pfc/View/AccountsReports/ReceiptVouchers/BillReceiptsVoucherReport.dart';
import 'package:pfc/View/LRReports/BilledLR/BilledLRReport.dart';
import 'package:pfc/View/TrafficReports/LastActivity/LastActivityReport.dart';
import 'package:pfc/View/TrafficReports/NotesManage/NotesManage.dart';
import 'package:pfc/View/AccountsReports/OnAccountVouchers/OnAccountVoucherReport.dart';
import 'package:pfc/View/AdminReports/OutdoorBusinessReport/OutdoorBusinessReport.dart';
import 'package:pfc/View/AccountsReports/PayableReport/PayableReport.dart';
import 'package:pfc/View/AccountsReports/PaymentVouchers/PaymentVoucherReport.dart';
import 'package:pfc/View/LRReports/PendingLR/PendingLRReport.dart';
import 'package:pfc/View/AccountsReports/ReceiptVouchers/ReceiptsVoucherReport.dart';
import 'package:pfc/View/LRReports/ReceivedLR/ReceivedLRReport.dart';
import 'package:pfc/View/AccountsReports/SalaryReport/SalaryReport.dart';
import 'package:pfc/View/AccountsReports/LedgerTransactionReports/TransactionReports.dart';
import 'package:pfc/View/AccountsReports/JournalVouchers/JournalVoucherReport.dart';
import 'package:pfc/View/ReportDashboard/TripBalanceReport/TripBalanceReport.dart';
import 'package:pfc/View/ReportDashboard/VoucherReport/VoucherReport.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class ReportDashboard extends StatefulWidget {
  const ReportDashboard({Key? key}) : super(key: key);

  @override
  State<ReportDashboard> createState() => _ReportDashboardState();
}

class _ReportDashboardState extends State<ReportDashboard> with Utility{

  int page = 0;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10,),

              Row(children: const [
                Icon(Icons.edit_note_rounded, color: Colors.grey, size: 30),  SizedBox(width: 10,),
                Text("Report Dashboard" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
              ],),

              const SizedBox(height: 10,),

              /// Buttons
              SizedBox(
                height: 50,
                child: Listener(
                  onPointerSignal: (event) {
                    if (event is PointerScrollEvent) {
                      final offset = event.scrollDelta.dy;
                      _scrollController.jumpTo(_scrollController.offset + offset);
                      // outerController.jumpTo(outerController.offset - offset);
                    }
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad
                        }
                      ),
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=0;
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 0),
                              child: const Text("Home" ,style: TextStyle(color: Colors.white),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=1;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionReports(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 1),
                              child: Text("Transaction Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=1;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const VoucherReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 1),
                              child: Text("Voucher Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=1;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LRDocs(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 1),
                              child: Text("LRDocs" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                             // AllLR=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AllLR(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("All LR" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const KMReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("KM Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SalaryReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Salary Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentVoucherReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Payment Voucher Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ReceiptsVoucherReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Receipts Voucher Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const JournalVoucherReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Journal Voucher Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OnAccountVoucherReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("OnAccount Voucher Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BillReceiptsVoucherReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Bill Receipt Voucher Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ReceivedLRReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Received LR Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BilledLRReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Billed LR Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotesManage(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Notes Manage" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PendingLRReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Pending LR Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LastActivityReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Last Activity Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AdvanceAtmList(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Advance ATM List" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BusinessReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Business Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OutdoorBusinessReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Outdoor Business Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverSalaryReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Driver Salary Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TripBalanceReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Trip Balance Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PayableReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Payable Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10,),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 500,
                        width: 500,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                      heightBox10(),
                      Container(
                        height: 170,
                        width: 500,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 290,
                        width: 400,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                      heightBox10(),
                      Container(
                        height: 380,
                        width: 400,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 350,
                        width: 350,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                      heightBox10(),
                      Container(
                        height: 320,
                        width: 350,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
