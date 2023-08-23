import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class VehicleWiseProfit extends StatefulWidget {
  const VehicleWiseProfit({Key? key}) : super(key: key);

  @override
  State<VehicleWiseProfit> createState() => _VehicleWiseProfitState();
}

class _VehicleWiseProfitState extends State<VehicleWiseProfit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Vehicle Wise Profit"),
      body: const Center(child: Text("Vehicle Wise Profit" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}