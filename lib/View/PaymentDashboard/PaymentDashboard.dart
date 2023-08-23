import 'package:flutter/material.dart';
import 'package:pfc/View/PaymentDashboard/DieselBillPayment/DieselBillPayment.dart';
import 'package:pfc/View/PaymentDashboard/TripSettlement/TripSettlement.dart';
import 'package:pfc/View/Vouchers/DriverSalary/DriverSalaryGenerate.dart';
import 'package:pfc/View/Vouchers/ExpensesVoucher/ExpensesVoucher.dart';
import 'package:pfc/utility/Widgets/CustomMenuButton.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class PaymentDashboard extends StatefulWidget {
  const PaymentDashboard({Key? key}) : super(key: key);

  @override
  State<PaymentDashboard> createState() => _PaymentDashboardState();
}

class _PaymentDashboardState extends State<PaymentDashboard> with Utility{

  List buttonNames = [
    {
      'btn_name': 'Payable',
      'class_name':const ExpensesVoucher()
    },
    {
      'btn_name': 'Driver Salary',
      'class_name':const DriverSalaryGenerate()
    },
    {
      'btn_name': 'Trip Settlement',
      'class_name':const TripSettlement()
    },
    {
      'btn_name': 'Diesel Bill Payment',
      'class_name':const DieselBillPayment()
    },
  ];

  int selectedIndex = 0;
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10,),

              Row(children: const [
                Icon(Icons.payment, color: Colors.grey, size: 22),  SizedBox(width: 5,),
                Text("Payment Dashboard" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
              ],),

              const SizedBox(height: 10,),

              /// Buttons
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Home
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                style: ButtonStyles.dashboardButton2(isSelected: true),
                                child: const Text("Home" ,style: TextStyle(color: Colors.white),)
                            ),
                            const SizedBox(width: 10,),

                            // Payable
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpensesVoucher(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Payable" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // Driver Salary
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverSalaryGenerate(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Driver Salary" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // Trip Settlement
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TripSettlement(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Trip Settlement" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // Diesel Bill Payment
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DieselBillPayment(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Diesel Bill Payment" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                          ],
                        ),
                      ),
                    ),

                    // menu button
                    CustomMenuButton(buttonNames: buttonNames),
                    const SizedBox(width: 10,),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 290,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                      heightBox10(),
                      Container(
                        height: 380,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 350,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                      heightBox10(),
                      Container(
                        height: 320,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 500,
                        width: 680,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                      heightBox10(),
                      Container(
                        height: 170,
                        width: 680,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}