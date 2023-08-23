import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class DeleteHistory extends StatefulWidget {
  const DeleteHistory({Key? key}) : super(key: key);

  @override
  State<DeleteHistory> createState() => _DeleteHistoryState();
}

class _DeleteHistoryState extends State<DeleteHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Delete History"),
      body: const Center(child: Text("Delete History" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}