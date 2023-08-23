import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class GenerateExtraOTBill extends StatefulWidget {
  const GenerateExtraOTBill({Key? key}) : super(key: key);

  @override
  State<GenerateExtraOTBill> createState() => _GenerateExtraOTBillState();
}

class _GenerateExtraOTBillState extends State<GenerateExtraOTBill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Generate Extra OT Bill"),
      body: const Center(child: Text("Generate Extra OT Bill" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}