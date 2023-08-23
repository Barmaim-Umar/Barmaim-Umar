import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class GenerateExtraBill extends StatefulWidget {
  const GenerateExtraBill({Key? key}) : super(key: key);

  @override
  State<GenerateExtraBill> createState() => _GenerateExtraBillState();
}

class _GenerateExtraBillState extends State<GenerateExtraBill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Generate Extra Bill"),
      body: const Center(child: Text("Generate Extra Bill"),),
    );
  }
}
