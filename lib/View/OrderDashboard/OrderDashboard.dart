import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfc/Provider/AnimationProvider.dart';
import 'package:pfc/Provider/ProviderOfFragment.dart';
import 'package:pfc/View/OrderDashboard/OrderVehicleInfo.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
class OrderDashboard extends StatefulWidget {
  const OrderDashboard({Key? key}) : super(key: key);

  @override
  State<OrderDashboard> createState() => _OrderDashboardState();
}

class _OrderDashboardState extends State<OrderDashboard> with TickerProviderStateMixin{
  late AnimationController _animationController;
  int iIndex = 0;
  late final TabController _tabController = TabController(length: 2, vsync: this, initialIndex: iIndex);

  List<String> companyNamesList = [
    "Aqua Plast",
    "Jamuna Transport",
    "T & D GALIAKOT CONTAINERS",
    "Aadi Foam",
    "CONTACT COMFORT",
    "Floatex solar Pvt.Ltd",
    "T & D GALIAKOT CONTAINERS",
    "UNITED BREWERIES LTD",
    "ASHOKA P.U. FOAM",
    "Acme Corporation",
    "Globex Corporation",
    "Soylent Corp",
    "Initech",
    "Bluth Company",
    "Umbrella Corporation",
    "Hooli",
    "Vehement Capital Partners",
    "Massive Dynamic",
    "Wonka Industries",
    "Stark Industries",
    "Gekko & Co",
    "Wayne Enterprises",
    "Bluth Company",
    "Bluth Company",
    "Bluth Company",
    "Bluth Company",
    "Bluth Company",
    "Bluth Company",
    "Bluth Company",
    "Bluth Company",
  ];
  List<String> cityNamesList = [
    'Ahmedabad ',
    'Amreli district',
    'Anand',
    'Banaskantha',
    'Bharuch',
    'Bhavnagar',
    'Dahod',
    'The Dangs',
    'Gandhinagar',
    'Jamnagar',
    'Junagadh',
    'Kutch',
    'Kheda',
    'Mehsana',
    'Narmada',
    'Navsari',
    'Patan',
    'Panchmahal',
    'Porbandar',
    'Rajkot',
    'Sabarkantha',
    'Surendranagar',
    'Surat',
    'Vyara',
    'Vadodara',
    'Valsad',
    'Porbandar',
    'Rajkot',
    'Sabarkantha',
    'Surendranagar',
    'Surat',
    'Vyara',
    'Vadodara',
    'Valsad',
    'Porbandar',
    'Rajkot',
    'Sabarkantha',
    'Surendranagar',
    'Surat',
    'Vyara',
    'Vadodara',
    'Valsad',
  ];

  late ButtonProvider _buttonProvider;
  FragmentsNotifier changeFragmentVariable = FragmentsNotifier();

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buttonProvider = Provider.of<ButtonProvider>(context, listen: false);
      _buttonProvider.startJumping();
    });

    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    _tabController.dispose();
    // _buttonProvider.stopJumping();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FragmentsNotifier changeFragmentVariable = Provider.of<FragmentsNotifier>(context, listen: false);
    return
      Consumer(builder: (context, fragmentsNotifier, child) {
        return  Scaffold(
          body: Responsive(

            /// Mobile
            mobile: Container(),

            /// Tablet
            tablet: Container(),

            /// Desktop
            desktop:Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Top Indicators
                  // Row(
                  //   children: [
                  //
                  //     // Late Delivery
                  //     Expanded(
                  //       child: Consumer<ButtonProvider>(
                  //         builder: (context, buttonProvider, child) {
                  //           return AnimatedContainer(
                  //             duration: const Duration(milliseconds: 500),
                  //             curve: Curves.easeInOut,
                  //             transform: buttonProvider.isJumping ? Matrix4.translationValues(00, -5, 00) : Matrix4.translationValues(00, 00, 00),
                  //             child:   FormWidgets().containerWidget('Late Delivery', '20', ThemeColors.orangeColor),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //
                  //     // Late Loading
                  //     Expanded(
                  //       child: Consumer<ButtonProvider>(
                  //         builder: (context, buttonProvider, child) {
                  //           return AnimatedContainer(
                  //             duration: const Duration(milliseconds: 500),
                  //             curve: Curves.easeInOut,
                  //             transform: buttonProvider.isJumping ? Matrix4.translationValues(00, 0, 00) : Matrix4.translationValues(00, -5, 00),
                  //             child:   FormWidgets().containerWidget('Late Loading', '20', ThemeColors.greenColor),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //
                  //     // Pending LR
                  //     Expanded(
                  //       child: Consumer<ButtonProvider>(
                  //         builder: (context, buttonProvider, child) {
                  //           return GestureDetector(
                  //             // onTap:() => buttonProvider.startJumping(),
                  //             child: AnimatedContainer(
                  //               duration: const Duration(milliseconds: 500),
                  //               curve: Curves.easeInOut,
                  //               transform: buttonProvider.isJumping ? Matrix4.translationValues(00, -5, 00) : Matrix4.translationValues(00, 00, 00),
                  //               child:   FormWidgets().containerWidget('Pending LR', '20', ThemeColors.redColor),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //
                  //     // Vehicle Without Driver
                  //     Expanded(
                  //       child: FormWidgets().containerWidget('Vehicle Without Driver', '98', ThemeColors.primaryColor),
                  //     ),
                  //
                  //     // Vehicle in Maintenance
                  //     Expanded(
                  //       child: FormWidgets().containerWidget('Vehicle in Maintenance', '98', ThemeColors.primaryColor),
                  //     ),
                  //
                  //     // Major Issue
                  //     Expanded(
                  //       child: Consumer<ButtonProvider>(
                  //         builder: (context, buttonProvider, child) {
                  //           return GestureDetector(
                  //             // onTap:() => buttonProvider.startJumping(),
                  //             child: AnimatedContainer(
                  //               duration: const Duration(milliseconds: 500),
                  //               curve: Curves.easeInOut,
                  //               transform: buttonProvider.isJumping ? Matrix4.translationValues(00, 0, 00) : Matrix4.translationValues(00, -5, 00),
                  //               child:   FormWidgets().containerWidget('Major Issue', '20', ThemeColors.darkRedColor),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //
                  //   ],
                  // ),

                  /// Top Indicators
                  // Wrap(
                  //   children: [
                  //     // Late Delivery
                  //     Consumer<ButtonProvider>(
                  //       builder: (context, buttonProvider, child) {
                  //         return AnimatedContainer(
                  //           duration: const Duration(milliseconds: 500),
                  //           curve: Curves.easeInOut,
                  //           // transform: buttonProvider.isJumping ? Matrix4.translationValues(00, -5, 00) : Matrix4.translationValues(00, 00, 00),
                  //           child:   FormWidgets().containerWidget('Late Delivery', '20', ThemeColors.primaryColor),
                  //         );
                  //       },
                  //     ),
                  //
                  //     // Late Loading
                  //     Consumer<ButtonProvider>(
                  //       builder: (context, buttonProvider, child) {
                  //         return AnimatedContainer(
                  //           duration: const Duration(milliseconds: 500),
                  //           curve: Curves.easeInOut,
                  //           // transform: buttonProvider.isJumping ? Matrix4.translationValues(00, 0, 00) : Matrix4.translationValues(00, -5, 00),
                  //           child:   FormWidgets().containerWidget('Late Loading', '20', ThemeColors.primaryColor),
                  //         );
                  //       },
                  //     ),
                  //
                  //     // Pending LR
                  //     Consumer<ButtonProvider>(
                  //       builder: (context, buttonProvider, child) {
                  //         return GestureDetector(
                  //           // onTap:() => buttonProvider.startJumping(),
                  //           child: AnimatedContainer(
                  //             duration: const Duration(milliseconds: 500),
                  //             curve: Curves.easeInOut,
                  //             // transform: buttonProvider.isJumping ? Matrix4.translationValues(00, -5, 00) : Matrix4.translationValues(00, 00, 00),
                  //             child:   FormWidgets().containerWidget('Pending LR', '20', ThemeColors.primaryColor),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //
                  //     // Vehicle Without Driver
                  //     FormWidgets().containerWidget('Vehicle Without Driver', '98', ThemeColors.primaryColor),
                  //
                  //     // Vehicle in Maintenance
                  //     FormWidgets().containerWidget('Vehicle in Maintenance', '98', ThemeColors.primaryColor),
                  //
                  //     // Major Issue
                  //     Consumer<ButtonProvider>(
                  //       builder: (context, buttonProvider, child) {
                  //         return GestureDetector(
                  //           // onTap:() => buttonProvider.startJumping(),
                  //           child: AnimatedContainer(
                  //             duration: const Duration(milliseconds: 500),
                  //             curve: Curves.easeInOut,
                  //             // transform: buttonProvider.isJumping ? Matrix4.translationValues(00, 0, 00) : Matrix4.translationValues(00, -5, 00),
                  //             child:   FormWidgets().containerWidget('Major Issue', '20', ThemeColors.darkRedColor),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //
                  //   ],
                  // ),

                  const SizedBox(height: 1,),

                  /// Dashboard
                  Expanded(
                    child: Container(
                      // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// left panel
                          Expanded(
                              flex: 2,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 0 , top: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),  boxShadow: [
                                  BoxShadow(color: ThemeColors.boxShadow , blurRadius: 5.0 , spreadRadius: 3),
                                ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: TabBar(
                                          onTap: (value) {
                                            setState(() {
                                              iIndex = value;
                                            });
                                          },
                                          indicator: BoxDecoration(color: iIndex == 0 ? ThemeColors.darkBlueColor : ThemeColors.darkBlueColor, borderRadius: BorderRadius.circular(10)),
                                          controller: _tabController,
                                          labelColor: Colors.white,
                                          unselectedLabelColor: Colors.grey,
                                          tabs: const [
                                            Tab(child: Text('Order List'),),
                                            Tab(child: Text('Assign Vehicle'),),
                                          ]),
                                    ),
                                    // Search
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2, bottom: 2 , left: 2),
                                      child: TextFormField(
                                        style: const TextStyle(fontSize: 15),
                                        decoration: UiDecoration().outlineTextFieldDecoration("Search",Colors.grey,
                                            icon:  const Icon(CupertinoIcons.search,color: Colors.grey,)),
                                      ),
                                    ),

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: TabBarView(controller: _tabController, children: [
                                          // Order List Tab
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 20,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: const EdgeInsets.only(top: 5, bottom: 5, right: 2),
                                                decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
                                                child: ListTile(
                                                  mouseCursor: SystemMouseCursors.click,
                                                  title: const Text(
                                                    'Party Name',
                                                    style:  TextStyle(color: Colors.black),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              companyNamesList[index],
                                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              cityNamesList[index],
                                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),textAlign: TextAlign.end,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: const [
                                                          Expanded(
                                                            child: Text(
                                                              "Order Date: 20-12-2022",
                                                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                                            ),
                                                          ),

                                                          Expanded(
                                                            child: Text(
                                                              "Entry By: Parvez",
                                                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: const Icon(
                                                    Icons.arrow_right_sharp,
                                                    color: ThemeColors.darkBlack,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),

                                          // Assign Vehicle Tab
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 20,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LRCreate(),)),
                                                onTap: () {
                                                  setState(() {
                                                    SidebarXController(selectedIndex: 1);
                                                    changeFragmentVariable.changeFragmentVariable(1);
                                                    debugPrint("aaa");
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(top: 5, bottom: 5, right: 2),
                                                  decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
                                                  child: ListTile(
                                                    mouseCursor: SystemMouseCursors.click,
                                                    // Vehicle Number
                                                    title: Text('MH20${Random().nextInt(90342)}',
                                                      style: const TextStyle(color: Colors.black),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Company Name
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            // Company Name
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(companyNamesList[index],
                                                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        // from city to city
                                                        Row(
                                                          children: [
                                                            Text(cityNamesList[index],
                                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold , overflow: TextOverflow.ellipsis),textAlign: TextAlign.end,
                                                            ),
                                                            const SizedBox(width: 2,),
                                                            const Icon(CupertinoIcons.arrow_right , size: 15,),
                                                            const SizedBox(width: 2,),
                                                            Expanded(
                                                              child: Text(cityNamesList[index],
                                                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold , overflow: TextOverflow.ellipsis),textAlign: TextAlign.start
                                                                ,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        // Assign Date and LR Number
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: const [
                                                            // Assign Date
                                                            Expanded(
                                                              child: Text(
                                                                "Assign Date: 20-12-2022",
                                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                                              ),
                                                            ),
                                                            // LR Number
                                                            Expanded(
                                                              child: Text(
                                                                "LR No: 8587365",
                                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: const Icon(
                                                      Icons.arrow_right_sharp,
                                                      color: ThemeColors.darkBlack,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              )),

                          const SizedBox(width: 5,),

                          /// right panel
                          const Expanded(flex: 7, child: OrderVehicleInfo()),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
  }
}
