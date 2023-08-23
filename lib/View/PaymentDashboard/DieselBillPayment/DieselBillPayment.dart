import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';

class DieselBillPayment extends StatefulWidget {
  const DieselBillPayment({Key? key}) : super(key: key);

  @override
  State<DieselBillPayment> createState() => _DieselBillPaymentState();
}

class _DieselBillPaymentState extends State<DieselBillPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Diesel Bill Payment"),
      body: const Center(child: Text("Diesel Bill Payment" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
    );
  }
}