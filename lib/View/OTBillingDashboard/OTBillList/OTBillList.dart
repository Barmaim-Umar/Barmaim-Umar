import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class OTBillList extends StatefulWidget {
  const OTBillList({Key? key}) : super(key: key);

  @override
  State<OTBillList> createState() => _OTBillListState();
}

class _OTBillListState extends State<OTBillList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("OT Bill List"),
      body: const Center(child: Text("OT Bill List" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}