import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class BillReceiptReport extends StatefulWidget {
  const BillReceiptReport({Key? key}) : super(key: key);

  @override
  State<BillReceiptReport> createState() => _BillReceiptReportState();
}

class _BillReceiptReportState extends State<BillReceiptReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Bill Receipt Report"),
      body: const Center(child: Text("Bill Receipt Report"),),
    );
  }
}
