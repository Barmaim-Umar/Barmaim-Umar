import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/View/Vouchers/AtmAdv/ATMAdv.dart';
import 'package:pfc/View/Vouchers/FasTagAdv/FasTagAdv.dart';
import 'package:pfc/View/Vouchers/Journal/Journal.dart';
import 'package:pfc/View/Vouchers/OnAccount/OnAccount.dart';
import 'package:pfc/View/VoucherDashboard/PayableTransaction/PayableTransaction.dart';
import 'package:pfc/View/Vouchers/ExpensesVoucher/ExpensesVoucher.dart';
import 'package:pfc/View/Vouchers/Payment/Payment.dart';
import 'package:pfc/View/Vouchers/Receipt/Receipt.dart';
import 'package:pfc/View/Vouchers/BpclAdv/BPCLAdv.dart';
import 'package:pfc/View/Vouchers/CashAdv/CashAdv.dart';
import 'package:pfc/View/Vouchers/DieselAdv/DieselAdv.dart';
import 'package:pfc/View/Vouchers/SalaryGenerate/GenerateSalary.dart';
import 'package:pfc/utility/Widgets/CustomButton.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import '../Vouchers/DriverSalary/DriverSalaryGenerate.dart';

class VoucherDashboard extends StatefulWidget {
  const VoucherDashboard({Key? key}) : super(key: key);

  @override
  State<VoucherDashboard> createState() => _VoucherDashboardState();
}

class _VoucherDashboardState extends State<VoucherDashboard> with Utility{

  int selectedIndex = 0;
  int page = 0;
  final ScrollController _scrollController = ScrollController();

  bool isTapped = false;
  bool isHover = false;

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
                Icon(Icons.airplane_ticket, color: Colors.grey, size: 30),  SizedBox(width: 10,),
                Text("Vouchers Dashboard" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
              ],),

              const SizedBox(height: 10,),

              /// Buttons
              SizedBox(
                height: 50,
                child: Listener(
                  onPointerSignal: (event) {
                    if (event is PointerScrollEvent) {
                      final offset = event.scrollDelta.dy;
                      _scrollController.jumpTo(_scrollController.offset + offset);
                      // outerController.jumpTo(outerController.offset - offset);
                    }
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                            PointerDeviceKind.trackpad
                          }
                      ),
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=0;
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 0),
                              child: const Text("Home" ,style: TextStyle(color: Colors.white),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=1;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Payment(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 1),
                              child: Text("Payment" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=1;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Receipt(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 1),
                              child: Text("Receipt" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=1;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Journal(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 1),
                              child: Text("Journal" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OnAccount(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("OnAccount" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpensesVoucher(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Payable" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BPCLAdv(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("BPCL Adv" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ATMAdv(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("ATM Adv" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CashAdv(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Cash Adv" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DieselAdv(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Diesel Adv" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FasTagAdv(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("FastTag Adv" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GenerateSalary(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Generate Salary" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverSalaryGenerate(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Driver Salary Generate" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // page=2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PayableTransaction(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton(page == 2),
                              child: Text("Payable Transaction" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10,),

              /// GlobalButtonWidget
              Center(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: const [

                     CustomButton(name: "Payment",page: Payment(),),
                     CustomButton(name: "Receipt",page: Receipt(),),
                     CustomButton(name: "Journal",page: Journal(),),
                     CustomButton(name: "OnAccount",page: OnAccount(),),
                     CustomButton(name: "Payable",page: ExpensesVoucher(),),
                     CustomButton(name: "BPCL Adv",page: BPCLAdv(),),
                     CustomButton(name: "ATM Adv",page: ATMAdv(),),
                     CustomButton(name: "Cash Adv",page: CashAdv(),),
                     CustomButton(name: "Diesel Adv",page: DieselAdv(),),
                     CustomButton(name: "FastTag Adv",page: FasTagAdv(),),
                     CustomButton(name: "Generate Salary",page: GenerateSalary(),),
                     CustomButton(name: "Driver Salary Generate",page: DriverSalaryGenerate(),),

                  ],
                ),
              ),
              const SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }
}
