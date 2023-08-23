import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class GenerateOTBill extends StatefulWidget {
  const GenerateOTBill({Key? key}) : super(key: key);

  @override
  State<GenerateOTBill> createState() => _GenerateOTBillState();
}

class _GenerateOTBillState extends State<GenerateOTBill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Generate OT Bill"),
      body: const Center(child: Text("Generate OT Bill" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}