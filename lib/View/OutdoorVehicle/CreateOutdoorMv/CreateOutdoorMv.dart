import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class CreateOutdoorMv extends StatefulWidget {
  const CreateOutdoorMv({Key? key}) : super(key: key);

  @override
  State<CreateOutdoorMv> createState() => _CreateOutdoorMvState();
}

class _CreateOutdoorMvState extends State<CreateOutdoorMv> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Create Outdoor MV"),
      body: const Center(child: Text("Create Outdoor MV" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}