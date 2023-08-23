import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class AtmAutomation extends StatefulWidget {
  const AtmAutomation({Key? key}) : super(key: key);

  @override
  State<AtmAutomation> createState() => _AtmAutomationState();
}

class _AtmAutomationState extends State<AtmAutomation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("ATM Automation"),
      body: const Center(child: Text("ATM Automation" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}