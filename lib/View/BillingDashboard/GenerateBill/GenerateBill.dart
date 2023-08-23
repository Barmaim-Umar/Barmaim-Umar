import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class GenerateBill extends StatefulWidget {
  const GenerateBill({Key? key}) : super(key: key);

  @override
  State<GenerateBill> createState() => _GenerateBillState();
}

class _GenerateBillState extends State<GenerateBill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Generate Bill"),
      body: const Center(child: Text("Generate Bill"),),
    );
  }
}
