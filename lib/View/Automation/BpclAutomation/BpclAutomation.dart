import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class BpclAutomation extends StatefulWidget {
  const BpclAutomation({Key? key}) : super(key: key);

  @override
  State<BpclAutomation> createState() => _BpclAutomationState();
}

class _BpclAutomationState extends State<BpclAutomation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("BPCL Automation"),
      body: const Center(child: Text("BPCL Automation" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}