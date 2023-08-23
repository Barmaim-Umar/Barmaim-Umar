import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class PetrolPump extends StatefulWidget {
  const PetrolPump({Key? key}) : super(key: key);

  @override
  State<PetrolPump> createState() => _PetrolPumpState();
}

class _PetrolPumpState extends State<PetrolPump> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Petrol Pump"),
      body: const Center(child: Text("Petrol Pump" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}
