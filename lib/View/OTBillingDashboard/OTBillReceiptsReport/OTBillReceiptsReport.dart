import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class OTBillReceiptsReport extends StatefulWidget {
  const OTBillReceiptsReport({Key? key}) : super(key: key);

  @override
  State<OTBillReceiptsReport> createState() => _OTBillReceiptsReportState();
}

class _OTBillReceiptsReportState extends State<OTBillReceiptsReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("OT Bill Receipts Report"),
      body: const Center(child: Text("OT Bill Receipts Report" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}