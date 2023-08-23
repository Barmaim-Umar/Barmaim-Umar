import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class AdvanceTransactionReports extends StatefulWidget {
  const AdvanceTransactionReports({Key? key}) : super(key: key);

  @override
  State<AdvanceTransactionReports> createState() => _AdvanceTransactionReportsState();
}

class _AdvanceTransactionReportsState extends State<AdvanceTransactionReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Advance Transaction Reports"),
      body: const Center(child: Text("Advance Transaction Reports" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}
