import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class PaidOutdoor extends StatefulWidget {
  const PaidOutdoor({Key? key}) : super(key: key);

  @override
  State<PaidOutdoor> createState() => _PaidOutdoorState();
}

class _PaidOutdoorState extends State<PaidOutdoor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Paid Outdoor"),
      body: const Center(child: Text("Paid Outdoor" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}