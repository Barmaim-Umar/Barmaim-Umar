import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class PendingDelete extends StatefulWidget {
  const PendingDelete({Key? key}) : super(key: key);

  @override
  State<PendingDelete> createState() => _PendingDeleteState();
}

class _PendingDeleteState extends State<PendingDelete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Pending Delete"),
      body: const Center(child: Text("Pending Delete" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}