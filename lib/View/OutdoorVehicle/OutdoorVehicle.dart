import 'package:flutter/material.dart';
import 'package:pfc/View/OutdoorVehicle/CreateOutdoorMv/CreateOutdoorMv.dart';
import 'package:pfc/View/OutdoorVehicle/CreateTransporter/CreateTransporter.dart';
import 'package:pfc/View/OutdoorVehicle/PaidOutdoor/PaidOutdoor.dart';
import 'package:pfc/View/OutdoorVehicle/PendingOutdoor/PendingOutdoor.dart';
import 'package:pfc/utility/Widgets/CustomMenuButton.dart';
import 'package:pfc/utility/Widgets/NavigationMenuButton.dart';
import 'package:pfc/utility/Widgets/NavigationMenuWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class OutdoorVehicle extends StatefulWidget {
  const OutdoorVehicle({Key? key}) : super(key: key);

  @override
  State<OutdoorVehicle> createState() => _OutdoorVehicleState();
}

class _OutdoorVehicleState extends State<OutdoorVehicle> with Utility{

  // List buttonNames = [
  //   {
  //     'btn_name': 'Pending Outdoor',
  //     'class_name':const PendingOutdoor()
  //   },
  //   {
  //     'btn_name': 'Paid Outdoor',
  //     'class_name':const PaidOutdoor()
  //   },
  //   {
  //     'btn_name': 'Create Transporter',
  //     'class_name':const CreateTransporter()
  //   },
  //   {
  //     'btn_name': 'Create Outdoor MV',
  //     'class_name':const CreateOutdoorMv()
  //   },
  // ];
  ///
  List buttonNames = [
    {
     'name':'Outdoor Vehicle',
     'values':[
       {
         'btn_name': 'Pending Outdoor',
         'class_name':const PendingOutdoor()
       },
       {
         'btn_name': 'Paid Outdoor',
         'class_name':const PaidOutdoor()
       },
       {
         'btn_name': 'Create Transporter',
         'class_name':const CreateTransporter()
       },
       {
         'btn_name': 'Create Outdoor MV',
         'class_name':const CreateOutdoorMv()
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
                  //   Icon(Icons.car_repair, color: Colors.grey, size: 22),  SizedBox(width: 5,),
                  //   Text("Outdoor Vehicle" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
                  // ],),

                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: const [
                            Icon(Icons.car_repair, color: Colors.grey, size: 22),  SizedBox(width: 5,),
                            Text("Outdoor Vehicle" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
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
                  //               // Pending Outdoor
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const PendingOutdoor(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Pending Outdoor" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Paid Outdoor
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const PaidOutdoor(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Paid Outdoor" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Create Transporter
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateTransporter(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Create Transporter" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Create Outdoor MV
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateOutdoorMv(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Create Outdoor MV" ,style: TextDecorationClass().dashboardBtn(),)
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
  }
}


