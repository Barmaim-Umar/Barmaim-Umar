import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class GroupWiseProfit extends StatefulWidget {
  const GroupWiseProfit({Key? key}) : super(key: key);

  @override
  State<GroupWiseProfit> createState() => _GroupWiseProfitState();
}

class _GroupWiseProfitState extends State<GroupWiseProfit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Group Wise Profit"),
      body: const Center(child: Text("Group Wise Profit" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}