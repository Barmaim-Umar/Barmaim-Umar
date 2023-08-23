import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class FasTagAutomation extends StatefulWidget {
  const FasTagAutomation({Key? key}) : super(key: key);

  @override
  State<FasTagAutomation> createState() => _FasTagAutomationState();
}

class _FasTagAutomationState extends State<FasTagAutomation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("FasTag Automation"),
      body: const Center(child: Text("FasTag Automation" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}