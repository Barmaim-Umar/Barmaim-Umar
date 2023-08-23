import 'package:flutter/material.dart';
import 'package:pfc/View/Master/CustomerList/CustomerList.dart';
import 'package:pfc/View/OrderDashboard/OrderDashboard.dart';
import 'package:pfc/View/VehicleManage/VehicleDashboard/VehicleDashboard.dart';
import 'package:pfc/utility/Widgets/NavigationButton.dart';

class Dashboard4 extends StatefulWidget {
  const Dashboard4({Key? key}) : super(key: key);

  @override
  State<Dashboard4> createState() => _Dashboard4State();
}

class _Dashboard4State extends State<Dashboard4> {

  List buttons = [
    {'buttonNames':['Dashboard' , 'Wallet' , 'Balance']},
    {'buttonColor1' : [Colors.green , Colors.blue , Colors.orange]},
    {'buttonColor2' : [const Color(0xffe2fbed) , const Color(0xffe0f6ff) , const Color(0xfffef9ea)]},
    {'buttonIcons' : [Icons.space_dashboard_outlined , Icons.account_balance_wallet_outlined , Icons.account_balance_outlined]}
  ];
  List<_DashboardButtons> dashboardButtons= [
  _DashboardButtons("Dashboard", Icons.space_dashboard_outlined, Colors.green, const Color(0xffe2fbed), Colors.white),
  ];
  List<_PieData> pieData = [
    _PieData('Amravati', 14 , 'Amravati'),
    _PieData('Pune', 45 , 'Pune'),
    _PieData('Patna', 64 , 'Patna'),
    _PieData('Narmada', 14 , 'Narmada'),
    _PieData('Rajkot', 34 , 'Rajkot'),
  ];
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];

  /// =========
  int currentIndex = 0;
  /// ==========

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("this is length: ${buttons[3]["buttonIcons"][0]}");
  }
  int pageNo = 1;
  @override
  Widget build(BuildContext context) {
    return
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),

        /// Tab
        SizedBox(
          height: 62,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: buttons[0]['buttonNames'].length,
            itemBuilder: (context, index) {
              return
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: NavigationButton(
                    isSelected: currentIndex == index,
                    onPress: () {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    icon: buttons[3]["buttonIcons"][index],
                    title: buttons[0]["buttonNames"][index],
                    primaryColor: buttons[1]["buttonColor1"][index],
                    secondaryColor: buttons[2]["buttonColor2"][index],
                  ),
                );
            },
          ),
        ),

        /// View
        currentIndex == 0 ?
            const Expanded(child:  CustomerList()) :
            currentIndex == 1 ?
        const Expanded(child:  VehicleDashboard()) :
               const Expanded(child:  OrderDashboard()),

      ],
    );


    //   Scaffold(
    //   // appBar: AppBar(title: const Text("Dashboard4"),),
    //   body: Padding(
    //     padding: const EdgeInsets.only(right: 10.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const SizedBox(height: 10,),
    //         SingleChildScrollView(
    //           scrollDirection: Axis.horizontal,
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //
    //               /// Navigation Button
    //               for(int i=0 ; i<buttons[0]['buttonNames'].length ; i++)
    //                 Padding(
    //                   padding: const EdgeInsets.only(right: 8.0),
    //                   child: NavigationButton(
    //                     isSelected: currentIndex == i,
    //                     onPress: () {
    //                       setState(() {
    //                         currentIndex = i;
    //                       });
    //                     },
    //                     icon: buttons[3]["buttonIcons"][i],
    //                     title: buttons[0]["buttonNames"][i],
    //                     primaryColor: buttons[1]["buttonColor1"][i],
    //                     secondaryColor: buttons[2]["buttonColor2"][i],
    //                   ),
    //                 ),
    //
    //               // NavigationButton(
    //               //   isSelected: currentIndex == 0,
    //               //   onPress: () {
    //               //
    //               //   },
    //               //   icon: Icons.account_balance_outlined,
    //               //   title: "title",
    //               //   primaryColor: Colors.green,
    //               //   secondaryColor: Colors.green.shade300.withOpacity(0.2),
    //               // ),
    //               // InkWell(
    //               //     onTap: () {
    //               //       setState(() {
    //               //         pageNo = 1;
    //               //       });
    //               //     },
    //               //     child: UiDecoration().navigationButton("Dashboard", const Color(0xffe2feed), Icons.space_dashboard_outlined, Colors.green , Colors.white)),
    //               // const SizedBox(width: 10,),
    //               // InkWell(
    //               //     onTap: () {
    //               //       setState(() {
    //               //         pageNo = 2;
    //               //       });
    //               //     },
    //               //     child: UiDecoration().navigationButton("Page2", const Color(0xffe0f6ff), Icons.account_balance_wallet_outlined, Colors.blue , Colors.white)),
    //               // const SizedBox(width: 10,),
    //               // UiDecoration().navigationButton("Page3", const Color(0xfffef9ea), Icons.car_crash_outlined, const Color(0xffff9b21) , Colors.white),
    //               // const SizedBox(width: 10,),
    //               // UiDecoration().navigationButton2("Page4", const Color(0xfffdeef7), Icons.account_balance_outlined, const Color(0xfff3388b)),
    //
    //             ],
    //           ),
    //         ),
    //        /// ===================
    //        // const SizedBox(height: 10,),
    //        //  Row(
    //        //    mainAxisAlignment: MainAxisAlignment.center,
    //        //    children: [
    //        //      for (var i = 0; i < 10; i++)
    //        //        InkWell(
    //        //          onTap:  () {
    //        //            setState(() {
    //        //              currentIndex = i;
    //        //            });
    //        //          },
    //        //            child: buildIndicator(currentIndex == i))
    //        //    ],
    //        //  ),
    //        /// ==============================
    //        const SizedBox(height: 10,),
    //        /// ListView Builder
    //        // SizedBox(
    //        //   height: 72,
    //        //   child: ListView.builder(
    //        //     scrollDirection: Axis.horizontal,
    //        //     shrinkWrap: true,
    //        //     itemCount: buttons[0]['buttonNames'].length,
    //        //     itemBuilder: (context, index) {
    //        //     return Container(
    //        //       margin: const EdgeInsets.only(right: 10),
    //        //       padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
    //        //       height: 72,
    //        //       width: 200,
    //        //       decoration:  BoxDecoration(
    //        //         color: Colors.white,
    //        //         borderRadius: BorderRadius.circular(7),
    //        //         border: Border.all(color: buttons[1]['buttonColor1'][index] ),
    //        //       ),
    //        //       child: Column(
    //        //         mainAxisAlignment: MainAxisAlignment.center,
    //        //         crossAxisAlignment: CrossAxisAlignment.start,
    //        //         children: [
    //        //           Row(
    //        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //        //             children: [
    //        //               Text(buttons[0]['buttonNames'][index] , style:  TextStyle(color: buttons[1]['buttonColor1'][index] , fontWeight: FontWeight.w500 , fontSize: 18),),
    //        //               Container(
    //        //                 height: 50,
    //        //                 width: 50,
    //        //                 decoration:  BoxDecoration(
    //        //                     shape: BoxShape.circle,
    //        //                     // color: Colors.lightGreen.shade100
    //        //                     color: buttons[2]['buttonColor2'][index]
    //        //                 ),
    //        //                 child:  Icon(buttons[3]['buttonIcons'][index], color: buttons[1]['buttonColor1'][index],),
    //        //               )
    //        //             ],
    //        //           ),
    //        //         ],
    //        //       ),
    //        //     );
    //        //   },),
    //        // ),
    //
    //         currentIndex == 0 ?
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //               //Initialize the chart widget
    //               Container(
    //                 height: 300,
    //                 width: 600,
    //                 margin: const EdgeInsets.symmetric(vertical: 8),
    //                 decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.circular(7),
    //                   boxShadow:  [
    //                     BoxShadow(color: Colors.grey.shade400,
    //                     blurRadius: 3,
    //                       spreadRadius: 0.1
    //                     )
    //                   ],
    //
    //                 ),
    //                 child: SfCartesianChart(
    //                     primaryXAxis: CategoryAxis(),
    //                     // Chart title
    //                     title: ChartTitle(text: 'Half yearly sales analysis'),
    //                     // Enable legend
    //                     legend: Legend(isVisible: true),
    //                     // Enable tooltip
    //                     tooltipBehavior: TooltipBehavior(enable: true),
    //                     series: <ChartSeries<_SalesData, String>>[
    //                       LineSeries<_SalesData, String>(
    //                           dataSource: data,
    //                           xValueMapper: (_SalesData sales, _) => sales.year,
    //                           yValueMapper: (_SalesData sales, _) => sales.sales,
    //                           name: 'Sales',
    //                           // Enable data label
    //                           dataLabelSettings: const DataLabelSettings(isVisible: true))
    //                     ]),
    //               ),
    //               const SizedBox(height: 10,),
    //               Container(
    //                 height: 300,
    //                 width: 600,
    //                 decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.circular(7),
    //                   boxShadow:  [
    //                     BoxShadow(color: Colors.grey.shade400,
    //                         blurRadius: 3,
    //                         spreadRadius: 0.1
    //                     )
    //                   ],
    //
    //                 ),
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   //Initialize the spark charts widget
    //                   child: SfSparkLineChart.custom(
    //                     //Enable the trackball
    //                     trackball: const SparkChartTrackball(
    //                         activationMode: SparkChartActivationMode.tap),
    //                     //Enable marker
    //                     marker: const SparkChartMarker(
    //                         displayMode: SparkChartMarkerDisplayMode.all),
    //                     //Enable data label
    //                     labelDisplayMode: SparkChartLabelDisplayMode.all,
    //                     xValueMapper: (int index) => data[index].year,
    //                     yValueMapper: (int index) => data[index].sales,
    //                     dataCount: 5,
    //                   ),
    //                 ),
    //               ),
    //                   const SizedBox(height: 10,),
    //                   Container(
    //                     height: 300,
    //                     width: 600,
    //                     margin: const EdgeInsets.symmetric(vertical: 8),
    //                     decoration: BoxDecoration(
    //                       color: Colors.white,
    //                       borderRadius: BorderRadius.circular(7),
    //                       boxShadow:  [
    //                         BoxShadow(color: Colors.grey.shade400,
    //                             blurRadius: 3,
    //                             spreadRadius: 0.1
    //                         )
    //                       ],
    //
    //                     ),
    //                     child: SfCartesianChart(
    //                         primaryXAxis: CategoryAxis(),
    //                         // Chart title
    //                         title: ChartTitle(text: 'Half yearly sales analysis'),
    //                         // Enable legend
    //                         legend: Legend(isVisible: true),
    //                         // Enable tooltip
    //                         tooltipBehavior: TooltipBehavior(enable: true),
    //                         series: <ChartSeries<_SalesData, String>>[
    //                           LineSeries<_SalesData, String>(
    //                               dataSource: data,
    //                               xValueMapper: (_SalesData sales, _) => sales.year,
    //                               yValueMapper: (_SalesData sales, _) => sales.sales,
    //                               name: 'Sales',
    //                               // Enable data label
    //                               dataLabelSettings: const DataLabelSettings(isVisible: true))
    //                         ]),
    //                   ),
    //             ]),
    //             Container(
    //               height: 620,
    //               width: 820,
    //               margin: const EdgeInsets.only(right: 0 , top: 10),
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(7),
    //                 boxShadow:  [
    //                   BoxShadow(color: Colors.grey.shade400,
    //                       blurRadius: 3,
    //                       spreadRadius: 0.1
    //                   )
    //                 ],
    //               ),
    //               child: SfCircularChart(
    //                   title: ChartTitle(text: 'Sales by sales City'),
    //                   legend: Legend(isVisible: true),
    //                   series: <PieSeries<_PieData, String>>[
    //                     PieSeries<_PieData, String>(
    //                         explode: true,
    //                         explodeIndex: 0,
    //                         dataSource: pieData,
    //                         xValueMapper: (_PieData data, _) => data.xData,
    //                         yValueMapper: (_PieData data, _) => data.yData,
    //                         dataLabelMapper: (_PieData data, _) => data.text,
    //                         dataLabelSettings: const DataLabelSettings(isVisible: true)),
    //                   ]
    //               ),
    //             )
    //           ],
    //         ) :
    //         currentIndex == 1 ?
    //        Row(
    //          mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //          crossAxisAlignment: CrossAxisAlignment.start,
    //          children: [
    //            Container(
    //              height: 620,
    //              width: 820,
    //              margin: const EdgeInsets.only(right: 0 , top: 10),
    //              decoration: BoxDecoration(
    //                color: Colors.white,
    //                borderRadius: BorderRadius.circular(7),
    //                boxShadow:  [
    //                  BoxShadow(color: Colors.grey.shade400,
    //                      blurRadius: 3,
    //                      spreadRadius: 0.1
    //                  )
    //                ],
    //              ),
    //              child: SfCircularChart(
    //                  title: ChartTitle(text: 'Sales by sales City'),
    //                  legend: Legend(isVisible: true),
    //                  series: <PieSeries<_PieData, String>>[
    //                    PieSeries<_PieData, String>(
    //                        explode: true,
    //                        explodeIndex: 0,
    //                        dataSource: pieData,
    //                        xValueMapper: (_PieData data, _) => data.xData,
    //                        yValueMapper: (_PieData data, _) => data.yData,
    //                        dataLabelMapper: (_PieData data, _) => data.text,
    //                        dataLabelSettings: const DataLabelSettings(isVisible: true)),
    //                  ]
    //              ),
    //            ),
    //            Column(
    //                crossAxisAlignment: CrossAxisAlignment.start,
    //                children: [
    //                  //Initialize the chart widget
    //                  Container(
    //                    height: 300,
    //                    width: 600,
    //                    margin: const EdgeInsets.symmetric(vertical: 8),
    //                    decoration: BoxDecoration(
    //                      color: Colors.white,
    //                      borderRadius: BorderRadius.circular(7),
    //                      boxShadow:  [
    //                        BoxShadow(color: Colors.grey.shade400,
    //                            blurRadius: 3,
    //                            spreadRadius: 0.1
    //                        )
    //                      ],
    //
    //                    ),
    //                    child: SfCartesianChart(
    //                        primaryXAxis: CategoryAxis(),
    //                        // Chart title
    //                        title: ChartTitle(text: 'Half yearly sales analysis'),
    //                        // Enable legend
    //                        legend: Legend(isVisible: true),
    //                        // Enable tooltip
    //                        tooltipBehavior: TooltipBehavior(enable: true),
    //                        series: <ChartSeries<_SalesData, String>>[
    //                          LineSeries<_SalesData, String>(
    //                              dataSource: data,
    //                              xValueMapper: (_SalesData sales, _) => sales.year,
    //                              yValueMapper: (_SalesData sales, _) => sales.sales,
    //                              name: 'Sales',
    //                              // Enable data label
    //                              dataLabelSettings: const DataLabelSettings(isVisible: true))
    //                        ]),
    //                  ),
    //                  const SizedBox(height: 10,),
    //                  Container(
    //                    height: 300,
    //                    width: 600,
    //                    decoration: BoxDecoration(
    //                      color: Colors.white,
    //                      borderRadius: BorderRadius.circular(7),
    //                      boxShadow:  [
    //                        BoxShadow(color: Colors.grey.shade400,
    //                            blurRadius: 3,
    //                            spreadRadius: 0.1
    //                        )
    //                      ],
    //
    //                    ),
    //                    child: Padding(
    //                      padding: const EdgeInsets.all(8.0),
    //                      //Initialize the spark charts widget
    //                      child: SfSparkLineChart.custom(
    //                        //Enable the trackball
    //                        trackball: const SparkChartTrackball(
    //                            activationMode: SparkChartActivationMode.tap),
    //                        //Enable marker
    //                        marker: const SparkChartMarker(
    //                            displayMode: SparkChartMarkerDisplayMode.all),
    //                        //Enable data label
    //                        labelDisplayMode: SparkChartLabelDisplayMode.all,
    //                        xValueMapper: (int index) => data[index].year,
    //                        yValueMapper: (int index) => data[index].sales,
    //                        dataCount: 5,
    //                      ),
    //                    ),
    //                  ),
    //                  const SizedBox(height: 10,),
    //                  Container(
    //                    height: 300,
    //                    width: 600,
    //                    margin: const EdgeInsets.symmetric(vertical: 8),
    //                    decoration: BoxDecoration(
    //                      color: Colors.white,
    //                      borderRadius: BorderRadius.circular(7),
    //                      boxShadow:  [
    //                        BoxShadow(color: Colors.grey.shade400,
    //                            blurRadius: 3,
    //                            spreadRadius: 0.1
    //                        )
    //                      ],
    //
    //                    ),
    //                    child: SfCartesianChart(
    //                        primaryXAxis: CategoryAxis(),
    //                        // Chart title
    //                        title: ChartTitle(text: 'Half yearly sales analysis'),
    //                        // Enable legend
    //                        legend: Legend(isVisible: true),
    //                        // Enable tooltip
    //                        tooltipBehavior: TooltipBehavior(enable: true),
    //                        series: <ChartSeries<_SalesData, String>>[
    //                          LineSeries<_SalesData, String>(
    //                              dataSource: data,
    //                              xValueMapper: (_SalesData sales, _) => sales.year,
    //                              yValueMapper: (_SalesData sales, _) => sales.sales,
    //                              name: 'Sales',
    //                              // Enable data label
    //                              dataLabelSettings: const DataLabelSettings(isVisible: true))
    //                        ]),
    //                  ),
    //                  ///====================
    //                  SfCircularChart(
    //                      title: ChartTitle(text: 'Sales by sales person'),
    //                      legend: Legend(isVisible: true),
    //                      series: <PieSeries<_PieData, String>>[
    //                        PieSeries<_PieData, String>(
    //                            explode: true,
    //                            explodeIndex: 0,
    //                            dataSource: pieData,
    //                            xValueMapper: (_PieData data, _) => data.xData,
    //                            yValueMapper: (_PieData data, _) => data.yData,
    //                            dataLabelMapper: (_PieData data, _) => data.text,
    //                            dataLabelSettings: const DataLabelSettings(isVisible: true)),
    //                      ]
    //                  ),
    //                  const CircularChart(),
    //                  const SizedBox(height: 50,)
    //
    //                ]),
    //          ],
    //        ) :
    //             const AccountsMasterTabs()
    //
    //       ],
    //     ),
    //   ),
    // );
  }

  ///==========================
  Widget buildIndicator(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        height: isSelected ? 12 : 10,
        width: isSelected ? 12 : 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
///==========================

}

class _DashboardButtons {
  _DashboardButtons(this.title , this.icon , this.color1 , this.color2 , this.backgroundColor);
  final String title;
  final IconData icon;
  final Color color1;
  final Color color2;
  final Color backgroundColor;
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
class _PieData {
  _PieData(this.xData, this.yData, this.text);
  final String xData;
  final num yData;
  final String text;
}

