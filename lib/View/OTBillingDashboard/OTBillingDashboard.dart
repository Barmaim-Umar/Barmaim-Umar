import 'package:flutter/material.dart';
import 'package:pfc/View/OTBillingDashboard/DirectLR/DirectLR.dart';
import 'package:pfc/View/OTBillingDashboard/GenerateExtraOTBill/GenerateExtraOTBill.dart';
import 'package:pfc/View/OTBillingDashboard/GenerateOTBill/GenerateOTBill.dart';
import 'package:pfc/View/OTBillingDashboard/OTBillList/OTBillList.dart';
import 'package:pfc/View/OTBillingDashboard/OTBillReceipts/OTBillReceipts.dart';
import 'package:pfc/View/OTBillingDashboard/OTBillReceiptsReport/OTBillReceiptsReport.dart';
import 'package:pfc/View/OTBillingDashboard/OTOutstandingList/OTOutstandingList.dart';
import 'package:pfc/utility/Widgets/CustomMenuButton.dart';
import 'package:pfc/utility/Widgets/NavigationMenuButton.dart';
import 'package:pfc/utility/Widgets/NavigationMenuWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class OTBillingDashboard extends StatefulWidget {
  const OTBillingDashboard({Key? key}) : super(key: key);

  @override
  State<OTBillingDashboard> createState() => _OTBillingDashboardState();
}

class _OTBillingDashboardState extends State<OTBillingDashboard> with Utility{

  // List buttonNames = [
  //   {
  //     'btn_name': 'Generate OT Bill',
  //     'class_name':const GenerateOTBill()
  //   },
  //   {
  //     'btn_name': 'Generate Extra OT Bill',
  //     'class_name':const GenerateExtraOTBill()
  //   },
  //   {
  //     'btn_name': 'OT Bill List',
  //     'class_name':const OTBillList()
  //   },
  //   {
  //     'btn_name': 'OT Outstanding List',
  //     'class_name':const OTOutstandingList()
  //   },
  //   {
  //     'btn_name': 'OT Bill Receipt',
  //     'class_name':const OTBillReceipts()
  //   },
  //   {
  //     'btn_name': 'OT Bill Receipt Report',
  //     'class_name':const OTBillReceiptsReport()
  //   },
  //   {
  //     'btn_name': 'Direct LR',
  //     'class_name':const DirectLR()
  //   },
  // ];
  ///
  List buttonNames = [
    {
      'name': 'Generate Bill',
      'values': [
        {
          'btn_name': 'Generate OT Bill',
          'class_name':const GenerateOTBill()
        },
        {
          'btn_name': 'Generate Extra OT Bill',
          'class_name':const GenerateExtraOTBill()
        },
        {
          'btn_name': 'OT Bill Receipt',
          'class_name':const OTBillReceipts()
        },
      ]
    },
    {
      'name':'Bill List',
      'values': [
        {
          'btn_name': 'OT Bill List',
          'class_name':const OTBillList()
        },
        {
          'btn_name': 'OT Outstanding List',
          'class_name':const OTOutstandingList()
        },
        {
          'btn_name': 'OT Bill Receipt Report',
          'class_name':const OTBillReceiptsReport()
        },
        {
          'btn_name': 'Direct LR',
          'class_name':const DirectLR()
        },
      ]
    }
  ];
  bool showNavigationMenu = false;
  int selectedIndex = 0;
  int page = 0;

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

                  const SizedBox(height: 10,),

                  // Row(children: const [
                  //   Icon(Icons.currency_rupee, color: Colors.grey, size: 22),  SizedBox(width: 5,),
                  //   Text("OT Billing Dashboard" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
                  // ],),

                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: const [
                            Icon(Icons.currency_rupee, color: Colors.grey, size: 22),  SizedBox(width: 5,),
                            Text("OT Billing Dashboard" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
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

                  const SizedBox(height: 10,),

                  /// Buttons
                  // SizedBox(
                  //   height: 50,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: SingleChildScrollView(
                  //           scrollDirection: Axis.horizontal,
                  //           child: Row(
                  //             children: [
                  //               // Home
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {});
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(isSelected: true),
                  //                   child: const Text("Home" ,style: TextStyle(color: Colors.white),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Generate OT Bill
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const GenerateOTBill(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Generate OT Bill" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Generate Extra OT Bill
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const GenerateExtraOTBill(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Generate Extra OT Bill" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // OT Bill List
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const OTBillList(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("OT Bill List" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // OT Outstanding List
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const OTOutstandingList(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("OT Outstanding List" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // OT Bill Receipt
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const OTBillReceipts(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("OT Bill Receipt" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // OT Bill Receipt Report
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const OTBillReceiptsReport(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("OT Bill Receipt Report" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Direct LR
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const DirectLR(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Direct LR" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //
                  //       // menu button
                  //       CustomMenuButton(buttonNames: buttonNames),
                  //       const SizedBox(width: 10,),
                  //     ],
                  //   ),
                  // ),

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