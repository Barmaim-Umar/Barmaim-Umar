import 'package:flutter/material.dart';
import 'package:pfc/View/AccountsReports/CashAdv/AdvanceCashList.dart';
import 'package:pfc/View/AllForms/FreightRateList.dart';
import 'package:pfc/View/AllForms/LRCreate.dart';
import 'package:pfc/View/AllForms/PaidOutdoorPayments/PaidOutdoorPayments.dart';
import 'package:pfc/View/AllForms/PendingOrdersLR.dart';
import 'package:pfc/View/AllForms/PendingOutdoorPayment/PendingOutdoorPayment.dart';
import 'package:pfc/View/AllForms/PendingOutdoorPaymentsTransaction/PendingOutdoorPaymentsTransaction.dart';
import 'package:pfc/View/AllForms/TripManage.dart';
import 'package:pfc/View/AllForms/TripManagement/TripManagementDashboard.dart';
import 'package:pfc/View/AllForms/UpdateBillDetails%20&%20LRList/UpdateBillDetailsAndLRList.dart';
import 'package:pfc/View/AllForms/VehicleDocumentExpiry.dart';
import 'package:pfc/View/AllForms/VehicleUpdate/VehicleUpdate.dart';
import 'package:pfc/View/AllForms/pdfTest.dart';
import 'package:pfc/View/VehicleManage/DriverList/DriversList.dart';
import 'package:pfc/utility/colors.dart';

class AllForms extends StatefulWidget {
  const AllForms({Key? key}) : super(key: key);

  @override
  State<AllForms> createState() => _AllFormsState();
}

class _AllFormsState extends State<AllForms> with TickerProviderStateMixin{

  late final TabController _tabController = TabController(length: 14, vsync: this);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        backgroundColor: Colors.white,
        title: TabBar(
          isScrollable: true,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            unselectedLabelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            labelPadding: const EdgeInsets.symmetric(horizontal: 30 , vertical: 10),
            indicatorColor: Colors.red,
            indicator: BoxDecoration(
                color: ThemeColors.primaryColor,
                borderRadius: BorderRadius.circular(10)
            ),
            controller: _tabController,
            tabs: const [
              Text("-2. Trip Management Dashboard"),
              Text("-1. PdfTest"),
              Text("0. Vehicle Update"),
              Text("1. LR Create & List"),
              Text("2. Driver List"),
              Text("3. Vehicle Document Expiry"),
              Text("4. Pending Orders"),
              Text("5. FreightRateList"),
              Text("6. TripManage"),
              Text("7. AdvanceCashList"),
              // Billing Dashboard
              Text("8. Update Bill Details and LR List"),
              Text("9. Paid Outdoor Payments"),
              Text("10. Pending Outdoor Payments"),
              Text("11. Pending Outdoor Payments Transaction"),
            ]),
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: TabBarView(
            controller: _tabController,
            children: const [
              TripManagementDashboard(),
              PdfTest(),
              DateTimePickerCustom(),
              // VehicleUpdate(),
              LRCreate(),
              DriversList(),
              VehicleDocumentExpiry(),
              PendingOrderLR(),
              FreightRateList(),
              TripManage(),
              AdvanceCashList(),
              // Billing Dashboard Screens
              UpdateBillDetailsAndLRList(),
              PaidOutdoorPayment(),
              PendingOutdoorPayment(),
              PendingOutdoorPaymentsTransaction()
            ]),
      ),
    );
  }
}
