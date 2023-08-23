import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfc/View/AdminReports/BalanceSheet/BalanceSheet.dart';
import 'package:pfc/View/AdminReports/GroupWiseProfit/GroupWiseProfit.dart';
import 'package:pfc/View/AdminReports/ProfitAndLossAccount/ProfitAndLossAccount.dart';
import 'package:pfc/View/AdminReports/VehicleWiseProfit/VehicleWiseProfit.dart';
import 'package:pfc/View/AdminReports/BusinessReport/BusinessReport.dart';
import 'package:pfc/View/AdminReports/OutdoorBusinessReport/OutdoorBusinessReport.dart';
import 'package:pfc/utility/Widgets/CustomMenuButton.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({Key? key}) : super(key: key);

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> with Utility{

    List buttonNames = [
      {
        'btn_name': 'Business Report',
        'class_name':const BusinessReport()
      },
      {
        'btn_name': 'Outdoor Business Report',
        'class_name':const OutdoorBusinessReport()
      },
      {
        'btn_name': 'Vehicle Wise Profit',
        'class_name':const VehicleWiseProfit()
      },
      {
        'btn_name': 'Group Wise Profit',
        'class_name':const GroupWiseProfit()
      },
      {
        'btn_name': 'Profit and Loss Account',
        'class_name':const ProfitAndLossAccount()
      },
      {
        'btn_name': 'Balance Sheet',
        'class_name':const BalanceSheet()
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10,),

            // dashboard name and icon
            Row(children: const [
              Icon(Icons.person, color: Colors.grey, size: 22),  SizedBox(width: 5,),
              Text("Admin Reports" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
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

                          // Business Report
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BusinessReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child: Text("Business Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Outdoor Business Report
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OutdoorBusinessReport(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child: Text("Outdoor Business Report" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Vehicle Wise Profit
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const VehicleWiseProfit(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child: Text("Vehicle Wise Profit" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Group Wise Profit
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GroupWiseProfit(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child: Text("Group Wise Profit" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Profit and Loss Account
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfitAndLossAccount(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child: Text("Profit and Loss Account" ,style: TextDecorationClass().dashboardBtn(),)
                          ),
                          const SizedBox(width: 10,),

                          // Balance Sheet
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BalanceSheet(),));
                                });
                              },
                              style: ButtonStyles.dashboardButton2(),
                              child: Text("Balance Sheet" ,style: TextDecorationClass().dashboardBtn(),)
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

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Column(
            //       children: [
            //         Container(
            //           height: 290,
            //           width: 300,
            //           decoration: BoxDecoration(
            //               border: Border.all(color: Colors.grey),
            //               color: Colors.white
            //           ),
            //         ),
            //         heightBox10(),
            //         Container(
            //           height: 380,
            //           width: 300,
            //           decoration: BoxDecoration(
            //               border: Border.all(color: Colors.grey),
            //               color: Colors.white
            //           ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         Container(
            //           height: 350,
            //           width: 300,
            //           decoration: BoxDecoration(
            //               border: Border.all(color: Colors.grey),
            //               color: Colors.white
            //           ),
            //         ),
            //         heightBox10(),
            //         Container(
            //           height: 320,
            //           width: 300,
            //           decoration: BoxDecoration(
            //               border: Border.all(color: Colors.grey),
            //               color: Colors.white
            //           ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         Container(
            //           height: 500,
            //           width: 680,
            //           decoration: BoxDecoration(
            //               border: Border.all(color: Colors.grey),
            //               color: Colors.white
            //           ),
            //         ),
            //         heightBox10(),
            //         Container(
            //           height: 170,
            //           width: 680,
            //           decoration: BoxDecoration(
            //               border: Border.all(color: Colors.grey),
            //               color: Colors.white
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
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