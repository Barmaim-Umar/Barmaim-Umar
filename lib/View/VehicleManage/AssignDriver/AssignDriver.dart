import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class AssignDriver extends StatefulWidget {
  const AssignDriver({Key? key}) : super(key: key);

  @override
  State<AssignDriver> createState() => _AssignDriverState();
}

class _AssignDriverState extends State<AssignDriver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Assign Driver"),
      body: const Center(child: Text("Assign Driver" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}