import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class LRTracking extends StatefulWidget {
  const LRTracking({Key? key}) : super(key: key);

  @override
  State<LRTracking> createState() => _LRTrackingState();
}

class _LRTrackingState extends State<LRTracking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("LR Tracking"),
      body: const Center(child: Text("LR Tracking" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}
