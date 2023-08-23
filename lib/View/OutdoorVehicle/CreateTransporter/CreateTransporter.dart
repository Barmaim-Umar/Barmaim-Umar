import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class CreateTransporter extends StatefulWidget {
  const CreateTransporter({Key? key}) : super(key: key);

  @override
  State<CreateTransporter> createState() => _CreateTransporterState();
}

class _CreateTransporterState extends State<CreateTransporter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Create Transporter"),
      body: const Center(child: Text("Create Transporter" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}