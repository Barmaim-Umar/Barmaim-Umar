import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class TripSettlement extends StatefulWidget {
  const TripSettlement({Key? key}) : super(key: key);

  @override
  State<TripSettlement> createState() => _TripSettlementState();
}

class _TripSettlementState extends State<TripSettlement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Trip Settlement"),
      body: const Center(child: Text("Trip Settlement" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}