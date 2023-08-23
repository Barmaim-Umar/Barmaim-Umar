import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class PendingOutdoor extends StatefulWidget {
  const PendingOutdoor({Key? key}) : super(key: key);

  @override
  State<PendingOutdoor> createState() => _PendingOutdoorState();
}

class _PendingOutdoorState extends State<PendingOutdoor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Pending Outdoor"),
      body: const Center(child: Text("Pending Outdoor" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}
