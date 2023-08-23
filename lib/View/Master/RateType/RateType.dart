import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class RateType extends StatefulWidget {
  const RateType({Key? key}) : super(key: key);

  @override
  State<RateType> createState() => _RateTypeState();
}

class _RateTypeState extends State<RateType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Rate Type"),
      body: const Center(child: Text("Rate Type" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}