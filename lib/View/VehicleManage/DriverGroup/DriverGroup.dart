import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class DriverGroup extends StatefulWidget {
  const DriverGroup({Key? key}) : super(key: key);

  @override
  State<DriverGroup> createState() => _DriverGroupState();
}

class _DriverGroupState extends State<DriverGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Driver Group"),
      body: const Center(child: Text("Driver Group" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}