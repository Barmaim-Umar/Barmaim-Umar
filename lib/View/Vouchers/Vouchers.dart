import 'package:flutter/material.dart';
import 'package:pfc/View/VoucherDashboard/PayableTransaction/PayableTransaction.dart';
import 'package:pfc/View/Vouchers/AtmAdv/ATMAdv.dart';
import 'package:pfc/View/Vouchers/BpclAdv/BPCLAdv.dart';
import 'package:pfc/View/Vouchers/CashAdv/CashAdv.dart';
import 'package:pfc/View/Vouchers/DieselAdv/DieselAdv.dart';
import 'package:pfc/View/Vouchers/DriverSalary/DriverSalaryGenerate.dart';
import 'package:pfc/View/Vouchers/FasTagAdv/FasTagAdv.dart';
import 'package:pfc/View/Vouchers/Journal/Journal.dart';
import 'package:pfc/View/Vouchers/OnAccount/OnAccount.dart';
import 'package:pfc/View/Vouchers/ExpensesVoucher/ExpensesVoucher.dart';
import 'package:pfc/View/Vouchers/Payment/Payment.dart';
import 'package:pfc/View/Vouchers/Receipt/Receipt.dart';
import 'package:pfc/View/Vouchers/SalaryGenerate/GenerateSalary.dart';
import 'package:pfc/utility/Widgets/CustomButton.dart';
import 'package:pfc/utility/Widgets/CustomMenuButton.dart';
import 'package:pfc/utility/Widgets/NavigationMenuButton.dart';
import 'package:pfc/utility/Widgets/NavigationMenuWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class Vouchers extends StatefulWidget {
  const Vouchers({Key? key}) : super(key: key);

  @override
  State<Vouchers> createState() => _VouchersState();
}

class _VouchersState extends State<Vouchers> with Utility {
  // List buttonNames = [
  //   {
  //     'btn_name': 'Payment',
  //     'class_name':const Payment()
  //   },
  //   {
  //     'btn_name': 'Receipt',
  //     'class_name':const Receipt()
  //   },
  //   {
  //     'btn_name': 'Journal',
  //     'class_name':const Journal()
  //   },
  //   {
  //     'btn_name': 'OnAccount',
  //     'class_name':const OnAccount()
  //   },
  //   {
  //     'btn_name': 'Expenses Voucher',
  //     'class_name':const ExpensesVoucher()
  //   },
  //   {
  //     'btn_name': 'BPCL Adv',
  //     'class_name':const BPCLAdv()
  //   },
  //   {
  //     'btn_name': 'ATM Adv',
  //     'class_name':const ATMAdv()
  //   },
  //   {
  //     'btn_name': 'Cash Adv',
  //     'class_name':const CashAdv()
  //   },
  //   {
  //     'btn_name': 'Diesel Adv',
  //     'class_name':const DieselAdv()
  //   },
  //   {
  //     'btn_name': 'FastTag Adv',
  //     'class_name':const FasTagAdv()
  //   },
  //   {
  //     'btn_name': 'Generate Salary',
  //     'class_name':const GenerateSalary()
  //   },
  //   {
  //     'btn_name': 'Driver Salary Generate',
  //     'class_name':const DriverSalaryGenerate()
  //   },
  //   {
  //     'btn_name': 'Payable Transaction',
  //     'class_name':const PayableTransaction()
  //   },
  // ];
  ///
  List buttonNames = [
    {
      'name': 'Vouchers',
      'values': [
        {'btn_name': 'Payment', 'class_name': const Payment()},
        {'btn_name': 'Receipt', 'class_name': const Receipt()},
        {'btn_name': 'Journal', 'class_name': const Journal()},
        {'btn_name': 'OnAccount', 'class_name': const OnAccount()},
        {'btn_name': 'Expenses Voucher', 'class_name': const ExpensesVoucher()},
      ]
    },
    {
      'name': 'Advance Vouchers',
      'values': [
        {'btn_name': 'BPCL Adv', 'class_name': const BPCLAdv()},
        {'btn_name': 'ATM Adv', 'class_name': const ATMAdv()},
        {'btn_name': 'Cash Adv', 'class_name': const CashAdv()},
        {'btn_name': 'Diesel Adv', 'class_name': const DieselAdv()},
        {'btn_name': 'FastTag Adv', 'class_name': const FasTagAdv()},
      ]
    },
    {
      'name': 'Salary',
      'values': [
        {'btn_name': 'Generate Salary', 'class_name': const GenerateSalary()},
        {'btn_name': 'Driver Salary Generate', 'class_name': const DriverSalaryGenerate()},
      ]
    },
    {
      'name': 'Others',
      'values': [
        {'btn_name': 'Payable Transaction', 'class_name': const PayableTransaction()},
      ]
    },
  ];

  int selectedIndex = 0;
  int page = 0;
  final ScrollController _scrollController = ScrollController();

  bool isTapped = false;
  bool isHover = false;
  bool showNavigationMenu = false;
  bool animatedHover = false;
  int currentIndex = -1;
  int currentIndex2 = -1;
  double? navigationMenuWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: const [
                            Icon(Icons.currency_rupee, color: Colors.grey, size: 30),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Vouchers Dashboard",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      NavigationMenuButton(
                        showNavigationMenu: showNavigationMenu,
                        onTap: () {
                          setState(() {
                            showNavigationMenu = !showNavigationMenu;
                          });
                        },
                        onEnter: (event) {
                          setState(() {
                            showNavigationMenu = true;
                          });
                          // _widget.showNavigationMenu();
                        },
                        onExit: (event) {
                          showNavigationMenu = false;
                          Future.delayed(
                            const Duration(milliseconds: 200),
                                () {
                              setState(() {
                                if (showNavigationMenu != true) {
                                  showNavigationMenu = false;
                                }
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // More button
                      // CustomMenuButton(buttonNames: buttonNames),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// Buttons
                  // SizedBox(
                  //   height: 50,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: SingleChildScrollView(
                  //           controller: _scrollController,
                  //           scrollDirection: Axis.horizontal,
                  //           child: Row(
                  //             children: [
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=0;
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 0),
                  //                   child: const Text("Home" ,style: TextStyle(color: Colors.white),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=1;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const Payment(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 1),
                  //                   child: Text("Payment" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=1;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const Receipt(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 1),
                  //                   child: Text("Receipt" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=1;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const Journal(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 1),
                  //                   child: Text("Journal" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=2;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const OnAccount(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 2),
                  //                   child: Text("OnAccount" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=2;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpensesVoucher(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 2),
                  //                   child: Text("Expenses Voucher" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=2;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const BPCLAdv(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 2),
                  //                   child: Text("BPCL Adv" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=2;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const ATMAdv(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 2),
                  //                   child: Text("ATM Adv" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=2;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const CashAdv(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 2),
                  //                   child: Text("Cash Adv" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=2;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const DieselAdv(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 2),
                  //                   child: Text("Diesel Adv" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=2;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const FasTagAdv(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 2),
                  //                   child: Text("FastTag Adv" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=2;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const GenerateSalary(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 2),
                  //                   child: Text("Generate Salary" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=2;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverSalaryGenerate(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 2),
                  //                   child: Text("Driver Salary Generate" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       // page=2;
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const PayableTransaction(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton(page == 2),
                  //                   child: Text("Payable Transaction" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //
                  //       // More button
                  //       CustomMenuButton(buttonNames: buttonNames),
                  //
                  //       const SizedBox(width: 10,),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(
                    height: 10,
                  ),

                  /// GlobalButtonWidget
                  Center(
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: const [
                        CustomButton(
                          name: "Payment",
                          page: Payment(),
                        ),
                        CustomButton(
                          name: "Receipt",
                          page: Receipt(),
                        ),
                        CustomButton(
                          name: "Journal",
                          page: Journal(),
                        ),
                        CustomButton(
                          name: "OnAccount",
                          page: OnAccount(),
                        ),
                        CustomButton(
                          name: "Expenses Voucher",
                          page: ExpensesVoucher(),
                        ),
                        CustomButton(
                          name: "BPCL Adv",
                          page: BPCLAdv(),
                        ),
                        CustomButton(
                          name: "ATM Adv",
                          page: ATMAdv(),
                        ),
                        CustomButton(
                          name: "Cash Adv",
                          page: CashAdv(),
                        ),
                        CustomButton(
                          name: "Diesel Adv",
                          page: DieselAdv(),
                        ),
                        CustomButton(
                          name: "FastTag Adv",
                          page: FasTagAdv(),
                        ),
                        CustomButton(
                          name: "Generate Salary",
                          page: GenerateSalary(),
                        ),
                        CustomButton(
                          name: "Driver Salary Generate",
                          page: DriverSalaryGenerate(),
                        ),
                        CustomButton(
                          name: "Payable Transaction",
                          page: PayableTransaction(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            showNavigationMenu ? _showNavigationMenu() : const SizedBox()
          ],
        ),
      ),
    );
  }

  _showNavigationMenu() {
    return
      NavigationMenuWidget(buttonNames: buttonNames,
        onEnter: (p0) {
        setState(() {
          showNavigationMenu = true;
        });
      },
      onExit: (p0) {
        setState(() {
          showNavigationMenu = false;
        });
      },
      );
    //   Positioned(
    //   right: 20,
    //   top: 60,
    //   child: MouseRegion(
    //     onEnter: (event) {
    //       setState(() {
    //         showNavigationMenu = true;
    //       });
    //     },
    //     onExit: (event) {
    //       Future.delayed(
    //         const Duration(milliseconds: 200),
    //         () {
    //           setState(() {
    //             showNavigationMenu = false;
    //           });
    //         },
    //       );
    //     },
    //     child: AnimatedContainer(
    //       duration: const Duration(milliseconds: 1000),
    //       child: Container(
    //         padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
    //         width: 180 * double.parse(buttonNames.length.toString()), // 180 --> is the width of a single section
    //         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: ThemeColors.primary)),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             SizedBox(
    //               height: 400,
    //
    //               /// Horizontal ListView
    //               child: ListView.builder(
    //                 shrinkWrap: true,
    //                 itemCount: buttonNames.length,
    //                 scrollDirection: Axis.horizontal,
    //                 itemBuilder: (context, index) {
    //                   return MouseRegion(
    //                     onEnter: (event) {
    //                       currentIndex = index;
    //                     },
    //                     child: Container(
    //                       height: 300,
    //                       width: 180,
    //                       padding: const EdgeInsets.only(left: 7, top: 7),
    //                       decoration: BoxDecoration(color: index == 0 || index % 2 == 0 ? Colors.grey.shade100 : Colors.white, borderRadius: BorderRadius.circular(3)),
    //                       margin: const EdgeInsets.only(right: 5),
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           /// Section Name
    //                           ShaderMask(
    //                             shaderCallback: (bounds) {
    //                               return LinearGradient(colors: currentIndex == index ? [ThemeColors.primaryColor, ThemeColors.primaryColor] : [ThemeColors.primaryColor, ThemeColors.primaryColor])
    //                                   .createShader(bounds);
    //                             },
    //                             child: Text(
    //                               buttonNames[index]['name'],
    //                               style: TextStyle(
    //                                 color: ThemeColors.menuTextColor,
    //                                 fontWeight: currentIndex == index ? FontWeight.w400 : FontWeight.w400,
    //                                 fontSize: 17,
    //                               ),
    //                             ),
    //                           ),
    //                           const SizedBox(height: 5),
    //                           Expanded(
    //                             /// Vertical ListView
    //                             child: ListView.builder(
    //                               itemCount: buttonNames[index]['values'].length,
    //                               shrinkWrap: true,
    //                               itemBuilder: (context, index2) {
    //                                 return MouseRegion(
    //                                   onEnter: (event) {
    //                                     setState(() {
    //                                       currentIndex2 = index2;
    //                                       animatedHover = true;
    //                                     });
    //                                   },
    //                                   onExit: (event) {
    //                                     setState(() {
    //                                       animatedHover = false;
    //                                     });
    //                                   },
    //                                   child: AnimatedContainer(
    //                                     duration: const Duration(milliseconds: 100),
    //                                     margin: const EdgeInsets.symmetric(vertical: 2),
    //                                     decoration: BoxDecoration(
    //                                       boxShadow: [
    //                                         BoxShadow(
    //                                           color: currentIndex2 == index2 ? Colors.transparent : Colors.transparent,
    //                                         )
    //                                       ],
    //                                     ),
    //                                     child: InkWell(
    //                                       onTap: () {
    //                                         Navigator.push(
    //                                             context,
    //                                             MaterialPageRoute(
    //                                               builder: (context) => buttonNames[index]['values'][index2]['class_name'],
    //                                             ));
    //                                       },
    //                                       child: AnimatedDefaultTextStyle(
    //                                         style: TextStyle(
    //                                             color: currentIndex2 == index2 && currentIndex == index ? ThemeColors.primary : Colors.grey.shade700,
    //                                             fontWeight: currentIndex2 == index2 && currentIndex == index ? FontWeight.bold : FontWeight.w400,
    //                                             fontSize: 16),
    //                                         duration: const Duration(milliseconds: 100),
    //
    //                                         /// page names
    //                                         child: Text(buttonNames[index]['values'][index2]['btn_name']),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 );
    //                               },
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   );
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
