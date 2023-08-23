import 'package:flutter/material.dart';
import 'package:pfc/View/TrafficReports/KmsReport/KMReport.dart';
import 'package:pfc/View/TrafficReports/LastActivity/LastActivityReport.dart';
import 'package:pfc/View/TrafficReports/NotesManage/NotesManage.dart';
import 'package:pfc/View/TrafficReports/OrderList/OrderList.dart';
import 'package:pfc/View/TrafficReports/TrafficReport.dart';
import 'package:pfc/View/TrafficReports/TrafficReportPrint/TrafficReportPrint.dart';
import 'package:pfc/View/TrafficReports/VehicleActivity/VehicleActivity.dart';
import 'package:pfc/utility/Widgets/CustomMenuButton.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class TrafficReportsDashboard extends StatefulWidget {
  const TrafficReportsDashboard({Key? key}) : super(key: key);

  @override
  State<TrafficReportsDashboard> createState() => _TrafficReportsDashboardState();
}

class _TrafficReportsDashboardState extends State<TrafficReportsDashboard> with Utility{

  List buttonNames = [
    {
      'btn_name': 'Order List',
      'class_name':const OrderList()
    },
    {
      'btn_name': 'Notes Manage',
      'class_name':const NotesManage()
    },
    {
      'btn_name': 'Traffic Report Print',
      'class_name':const TrafficReportPrint()
    },
    {
      'btn_name': 'Last Activity Report',
      'class_name':const LastActivityReport()
    },
    {
      'btn_name': 'KMs Report',
      'class_name':const KMReport()
    },
    {
      'btn_name': 'Vehicle Activity',
      'class_name':const VehicleActivity()
    },
    {
      'btn_name': 'Traffic Report',
      'class_name':const TrafficReport()
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
                Icon(Icons.traffic_rounded, color: Colors.grey, size: 22),  SizedBox(width: 5,),
                Text("Traffic Report" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
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

                            // Order List
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderList(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Order List" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // Notes Manage
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotesManage(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Notes Manage" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // Traffic Report Print
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TrafficReportPrint(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Traffic Report Print" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // Last Activity / Last Activity Report
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LastActivityReport(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Last Activity Report" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // KMs Report
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const KMReport(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("KMs Report" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // Vehicle Activity
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const VehicleActivity(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Vehicle Activity" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            widthBox10(),

                            //Traffic Report
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TrafficReport(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Traffic Report" ,style: TextDecorationClass().dashboardBtn(),)
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

///
///

