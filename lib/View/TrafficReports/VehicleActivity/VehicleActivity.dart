import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class VehicleActivity extends StatefulWidget {
  const VehicleActivity({Key? key}) : super(key: key);

  @override
  State<VehicleActivity> createState() => _VehicleActivityState();
}

class _VehicleActivityState extends State<VehicleActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Vehicle Activity"),
      body: const Center(child: Text("Vehicle Activity" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),),),
    );
  }
}
