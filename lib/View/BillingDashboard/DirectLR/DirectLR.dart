import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class DirectLR extends StatefulWidget {
  const DirectLR({Key? key}) : super(key: key);

  @override
  State<DirectLR> createState() => _DirectLRState();
}

class _DirectLRState extends State<DirectLR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Direct LR"),
      body: const Center(child: Text("Direct LR"),),
    );
  }
}
