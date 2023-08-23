import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class OTOutstandingList extends StatefulWidget {
  const OTOutstandingList({Key? key}) : super(key: key);

  @override
  State<OTOutstandingList> createState() => _OTOutstandingListState();
}

class _OTOutstandingListState extends State<OTOutstandingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("OT Outstanding List"),
      body: const Center(child: Text("OT Outstanding List" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}