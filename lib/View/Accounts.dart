import 'package:flutter/material.dart';
import 'package:pfc/View/Vouchers/Journal/Journal.dart';
import 'package:pfc/View/Vouchers/Payment/Payment.dart';
import 'package:pfc/View/Vouchers/Receipt/Receipt.dart';
import 'package:pfc/View/BillingDashboard/Transactions/Transactions.dart';
import 'package:pfc/utility/colors.dart';

class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> with TickerProviderStateMixin{
  late final TabController _tabController = TabController(length: 4, vsync: this);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        backgroundColor: Colors.white,
        title: TabBar(
          unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            unselectedLabelStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
            labelStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            labelPadding: const EdgeInsets.all(5),
            indicatorColor: Colors.red,
            indicator: BoxDecoration(
              color: ThemeColors.primaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
            controller: _tabController,
            tabs: const [
          Text("Journal"),
          Text("Payment"),
          Text("Receipt"),
          Text("Transactions"),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: TabBarView(
          controller: _tabController,
            children: const [
          Journal(),
              Payment(),
              Receipt(),
              Transactions(),
        ]),
      ),
    );
  }
}
