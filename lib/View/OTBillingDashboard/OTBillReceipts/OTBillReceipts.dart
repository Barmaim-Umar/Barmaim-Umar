import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class OTBillReceipts extends StatefulWidget {
  const OTBillReceipts({Key? key}) : super(key: key);

  @override
  State<OTBillReceipts> createState() => _OTBillReceiptsState();
}

class _OTBillReceiptsState extends State<OTBillReceipts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("OT Bill Receipts"),
      body: const Center(child: Text("OT Bill Receipts" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}