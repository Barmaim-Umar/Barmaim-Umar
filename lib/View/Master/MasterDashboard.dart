import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pfc/View/Master/CreateCustomer/CreateCustomer.dart';
import 'package:pfc/View/Master/CreateEmployee/CreateEmployee.dart';
import 'package:pfc/View/Master/CreateGroupOfCompany/CreateGroupOfCompany.dart';
import 'package:pfc/View/Master/CreateRate/CreateRate.dart';
import 'package:pfc/View/Master/CustomerList/CustomerList.dart';
import 'package:pfc/View/Master/RateList/RateList.dart';
import 'package:pfc/View/Master/Groups/Groups.dart';
import 'package:pfc/View/Master/NewLedger/NewLedger.dart';
import 'package:pfc/View/Master/RateType/RateType.dart';
import 'package:pfc/utility/Widgets/CustomMenuButton.dart';
import 'package:pfc/utility/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'RateHistory/RateHistory.dart';

class MasterDashboard extends StatefulWidget {
  const MasterDashboard({Key? key}) : super(key: key);

  @override
  State<MasterDashboard> createState() => _MasterDashboardState();
}

class _MasterDashboardState extends State<MasterDashboard> {

  List buttonNames = [
    {
      'btn_name': 'New Ledger',
      'class_name':const NewLedger()
    },
    {
      'btn_name': 'Groups',
      'class_name':const Groups()
    },
    {
      'btn_name': 'Create Customer',
      'class_name': CreateCustomer()
    },
    {
      'btn_name': 'Customer List',
      'class_name':const CustomerList()
    },
    {
      'btn_name': 'Create Group Of Company',
      'class_name':const CreateGroupOfCompany()
    },
    {
      'btn_name': 'Create Rate',
      'class_name':const CreateRate()
    },
    {
      'btn_name': 'Rate List',
      'class_name':const RateList()
    },
    {
      'btn_name': 'Rate History',
      'class_name':const RateHistory()
    },
    {
      'btn_name': 'Rate Type',
      'class_name':const RateType()
    },
    {
      'btn_name': 'Create Employee',
      'class_name':const CreateEmployee()
    },
  ];

  int page = 0;
  String state = 'Animation start';
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(1, 35),
      ChartData(2, 23),
      ChartData(3, 34),
      ChartData(4, 25),
      ChartData(5, 40),
      ChartData(6, 23),
      ChartData(7, 35),
      ChartData(8, 5),
      ChartData(9, 50),
      ChartData(10, 35),
      ChartData(11, 85),
      ChartData(12, 15),
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10,),

            // dashboard name and icon
            page == 0 ? Row(
              children: const [
              Icon(Icons.space_dashboard_outlined , color: Colors.grey, size: 30),  SizedBox(width: 10,),
              Text("Master Dashboard" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
            ],
            ) : const SizedBox(),

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

                          // New Ledger
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NewLedger(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child: Text("New Ledger" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Groups
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Groups(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child:  Text("Groups" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Create Customer
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const CreateCustomer(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child: Text("Create Customer" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Customer List
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerList(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child:  Text("Customer List" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Create Group Of Company
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateGroupOfCompany(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child:  Text("Create Group Of Company" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Create Rate
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateRate(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child:  Text("Create Rate" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Rate List
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RateList(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child:  Text("Rate List" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Rate History
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RateHistory(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child:  Text("Rate History" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Rate Type
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RateType(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child:  Text("Rate Type" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Create Employee
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateEmployee(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child:  Text("Create Employee" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                        ],
                      ),
                    ),
                  ),

                  // More button
                  CustomMenuButton(buttonNames: buttonNames),
                  const SizedBox(width: 10,),

                  // ElevatedButton(
                  //     onPressed: () {
                  //       setState(() {});
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //         backgroundColor:  Colors.blue ,
                  //         shadowColor: Colors.transparent,
                  //         side:  const BorderSide(color: Colors.grey),
                  //         foregroundColor:  Colors.black,
                  //         shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                  //         minimumSize: const Size(100, 50)
                  //     ),
                  //     child: const Text("Home" ,style: TextStyle(color: Colors.white),)
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 10,),

            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                  children: [
                    /// Cards
                    Row(
                      children: [
                        UiDecoration().cardWidget("NEW EMPLOYEES", "34 ", "hires", Icons.add , Colors.green , 0.81 , "81%"),
                        const SizedBox(width: 20,),
                        UiDecoration().cardWidget("TOTAL EXPENSES", "71 ", "%", Icons.keyboard_arrow_down_rounded , const Color(0xffaa1441) ,  0.62 , "62%"),
                        const SizedBox(width: 20,),
                        UiDecoration().cardWidget("COMPANY VALUE", "100,45M", "", Icons.currency_rupee , const Color(0xffddb439) , 0.82 , "82%"),
                        const SizedBox(width: 20,),
                        UiDecoration().cardWidget("NEW ACCOUNTS", "234 ", "%", Icons.keyboard_arrow_up, const Color(0xff3359ac) , 0.41 , "41%"),
                      ],
                    ),

                    const SizedBox(height: 10,),

                    Row(
                      children: [
                        /// Traffic Source
                        Expanded(
                          flex: 2,
                          child: Container(
                              padding: const EdgeInsets.only(right: 5),
                              alignment: Alignment.center,
                              height: 430,
                              width: 890,
                              decoration: UiDecoration().dashboardBox(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding:  const EdgeInsets.all(8.0),
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextDecorationClass().heading('Traffic Source'),

                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xfff5c343),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text("Actions" , style: TextStyle(color: Colors.black , fontWeight: FontWeight.w500),),
                                          ),

                                        ],
                                      )
                                  ),
                                  const Divider(),
                                  SfCartesianChart(
                                      series: <ChartSeries<ChartData, int>>[
                                        // Renders column chart
                                        ColumnSeries<ChartData, int>(
                                            dataSource: chartData,
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y
                                        )
                                      ]
                                  ),
                                ],
                              )
                          ),
                        ),

                        const SizedBox(width: 20,),

                        /// Income
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.only(right: 5),
                              alignment: Alignment.center,
                              height: 430,
                              width: 290,
                              decoration:UiDecoration().dashboardBox(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding:  const EdgeInsets.all(8.0),
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextDecorationClass().heading('Income'),

                                          const Icon(Icons.settings),

                                        ],
                                      )
                                  ),
                                  const Divider(),

                                  /// Circular Graph
                                  Center(
                                    heightFactor: 1.0,
                                    child: CircularPercentIndicator(
                                      radius: 120.0,
                                      lineWidth: 18.0,
                                      animation: true,
                                      animationDuration: 3000,
                                      startAngle: 235,
                                      percent: 0.7,
                                      animateFromLastPercent: true,
                                      center: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text("Percent" , style: TextStyle(color: Colors.grey , fontWeight: FontWeight.w400 , fontSize: 20),),
                                          Text(
                                            "75",
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 35.0),
                                          ),
                                        ],
                                      ),

                                      circularStrokeCap: CircularStrokeCap.round,
                                      // progressColor: Colors.tealAccent,
                                      linearGradient: const LinearGradient(colors: [
                                        Colors.lightGreenAccent,CupertinoColors.activeBlue
                                      ]),
                                    ),
                                  ),

                                  const SizedBox(height: 30,),

                                  /// Line graph
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15 , left: 15 , right: 15 , bottom: 0),
                                    child: LinearPercentIndicator(
                                      lineHeight: 4,
                                      leading: const Text("32%" , style: TextStyle(color: Color(0xffeeb732) , fontWeight: FontWeight.w500 , fontSize: 30),),
                                      progressColor: const Color(0xffeeb732),
                                      barRadius: const Radius.circular(5),
                                      percent: .32,
                                      animation: true,
                                      animationDuration: 1200,
                                    ),
                                  ),

                                  const Text("   Spending Target" , style: TextStyle(fontSize: 17 , color: Colors.grey , fontWeight: FontWeight.w500),)
                                ],
                              )
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15,),

                    // Row(
                    //   children: [
                    //     Container(
                    //       width: 300,
                    //       height: 100,
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(5),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.grey.shade300,
                    //             blurRadius: 3,
                    //             spreadRadius: 1
                    //           ),
                    //         ]
                    //       ),
                    //
                    //     )
                    //   ],
                    // ),

                    /// Target Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Target Section" , style: TextStyle(color: Color(0xff737587) , fontSize: 20 , fontWeight: FontWeight.w500),),

                        Text("View Details" , style:  TextStyle(color: Colors.blue , fontSize: 15 , fontWeight: FontWeight.w500),)
                      ],
                    ),

                    const SizedBox(height: 15,),

                    Row(
                      children: [
                        UiDecoration().targetCard("71%", const Color(0xffbc1140), 0.71, "Income Target"),
                        const SizedBox(width: 20,),
                        UiDecoration().targetCard("88%", Colors.green, 0.88, "Expenses Target"),
                        const SizedBox(width: 20,),
                        UiDecoration().targetCard("32%", const Color(0xffe6b024), 0.32, "Spending Target"),
                        const SizedBox(width: 20,),
                        UiDecoration().targetCard("89%", const Color(0xff2ea3e7), 0.89, "Totals Target"),
                      ],
                    )
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
class ChartData {
  ChartData(this.x, this.y,);
  final int x;
  final double y;
}
