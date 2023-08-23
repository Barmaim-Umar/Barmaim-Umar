import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class ManageBranch extends StatefulWidget {
  const ManageBranch({Key? key}) : super(key: key);

  @override
  State<ManageBranch> createState() => _ManageBranchState();
}

class _ManageBranchState extends State<ManageBranch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Manage Branch"),
      body: const Center(child: Text("Manage Branch" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}