import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pfc/View/VehicleManage/VehicleDocuments/VehicleDocument.dart';
import 'package:pfc/View/VehicleManage/VehicleDashboard/VehicleDashboard.dart';
import 'package:pfc/View/VehicleManagement/NewOutdoorVehicle/NewOutdoorVehicle.dart';
import 'package:pfc/utility/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class VehicleManagement extends StatefulWidget {
  const VehicleManagement({Key? key}) : super(key: key);

  @override
  State<VehicleManagement> createState() => _VehicleManagementState();
}

class _VehicleManagementState extends State<VehicleManagement> {
  late List<VehicleStatus> _chartData;
  int page = 0;

  @override
  void initState() {
    _chartData = getChartDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20,),
            Row(children: const [
              Icon(Icons.car_repair, color: Colors.grey, size: 30),  SizedBox(width: 10,),
              Text("Vehicle Management" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
            ],),
            const SizedBox(height: 15,),

            /// Buttons
            SizedBox(
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyles.dashboardButton(page == 0),
                        child: const Text("Home" ,style:TextStyle(color: Colors.white))
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // page=1;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const NewOutdoorVehicleAndList(),));
                          });
                        },
                        style: ButtonStyles.dashboardButton(page == 1),
                        child: Text("New Outdoor Vehicle" ,style: TextDecorationClass().dashboardBtn(),)
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // page=2;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const VehicleDashboard(),));
                          });
                        },
                        style: ButtonStyles.dashboardButton(page == 2),
                        child: Text("Vehicle Details" ,style: TextDecorationClass().dashboardBtn(),)
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10,),

           /// Pages
           page == 0 ?
           Expanded(
             child: SingleChildScrollView(
               child: Column(
                 children: [
                   /// Top Indicators
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 10),
                     decoration: UiDecoration().dashboardBox(),
                     child: Row(
                       mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                       children: [
                         UiDecoration().topInfo(Colors.lightGreenAccent.shade700, "Total Vehicles", "553"),
                         const SizedBox( height: 60,child:  VerticalDivider()),
                         UiDecoration().topInfo(Colors.blue, "Available", "77"),
                         const SizedBox( height: 60,child:  VerticalDivider()),
                         UiDecoration().topInfo(Colors.yellow.shade700, "In Maintenance", "43"),
                         const SizedBox( height: 60,child:  VerticalDivider()),
                         UiDecoration().topInfo(Colors.green.shade700, "In Good Condition", "321"),
                         const SizedBox( height: 60,child:  VerticalDivider()),
                         UiDecoration().topInfo(Colors.red.shade700, "Need Repairs", "109"),
                         const SizedBox( height: 60,child:  VerticalDivider()),
                         UiDecoration().topInfo2(Colors.red.shade800, "Critical Alert", "3"),

                       ],
                     ),
                   ),

                   const SizedBox(height: 10,),

                   Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       /// Vehicle Status
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 8),
                         width: 350,
                         decoration: UiDecoration().dashboardBox(),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: const [
                                 Text("Vehicle Status" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),),
                                 Icon(Icons.more_horiz , color: Colors.grey,)
                               ],
                             ),
                             const Divider(),

                             /// Circular Graph
                             SfCircularChart(
                               annotations: [
                                 CircularChartAnnotation(
                                   widget: const Text("253 Vehicles Active" , style: TextStyle(fontWeight: FontWeight.w500),)
                                 )
                               ],
                               palette: const [
                                 Colors.blue,
                                 Colors.green,
                                 Colors.orange,
                                 Colors.greenAccent
                               ],
                               // legend: Legend(isVisible: true , overflowMode: LegendItemOverflowMode.wrap),
                               series: <CircularSeries>[
                                 DoughnutSeries<VehicleStatus , String>(
                                   innerRadius: "85",
                                   dataSource: _chartData,
                                   xValueMapper: (VehicleStatus data, _)=> data.status,
                                   yValueMapper: (VehicleStatus data, _)=> data.number,
                                 ),
                               ],),

                             const SizedBox(height: 5,),

                             UiDecoration().statusInfo(Colors.blue, "OnRoad", "63%", "217"),
                             const Divider(),
                             UiDecoration().statusInfo(Colors.green, "Empty", "25%", "36"),
                             const Divider(),
                             UiDecoration().statusInfo(Colors.orange, "Loading", "8%", "17"),
                             const Divider(),
                             UiDecoration().statusInfo(Colors.greenAccent, "Unloading", "4%", "9"),

                           ],
                         ),
                       ),
                       const SizedBox(width: 10,),

                       /// Warehouse
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 8),
                         width: 350,
                         height: 493,
                         decoration: UiDecoration().dashboardBox(),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: const [
                                 Text("Warehouse" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),),
                                 Icon(Icons.more_horiz , color: Colors.grey,)
                               ],
                             ),
                             const Divider(),
                             /// List
                             Expanded(
                               child: SingleChildScrollView(
                                 scrollDirection: Axis.vertical,
                                 child: Column(
                                   children: [
                                     UiDecoration().vehicleLeft("MH20112", "5 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH80516", "9 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH66023", "13 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleLeft("MH7756", "20 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH1835", "25 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleLeft("MH33426", "45 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH33342", "57 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH88113", "1 hrs ago"),
                                     const Divider(),
                                     UiDecoration().vehicleLeft("MH33426", "45 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH33342", "57 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH88113", "1 hrs ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH1835", "25 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH80516", "9 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH66023", "13 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleLeft("MH7756", "20 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH1835", "25 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleLeft("MH33426", "45 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH33342", "57 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH88113", "1 hrs ago"),
                                     const Divider(),
                                     UiDecoration().vehicleLeft("MH33426", "45 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH33342", "57 min ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH88113", "1 hrs ago"),
                                     const Divider(),
                                     UiDecoration().vehicleEntered("MH1835", "25 min ago"),
                                   ],
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                       const SizedBox(width: 10,),

                       /// Vehicle Timing
                       Expanded(
                           child: Container(
                             padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 8),
                             height: 493,
                             decoration: UiDecoration().dashboardBox(),
                             child:  Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 /// title
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: const [
                                     Text("Vehicle Timing" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),),
                                     Icon(Icons.more_horiz , color: Colors.grey,)
                                   ],
                                 ),
                                 const Divider(),
                                 const SizedBox(height: 35,),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                   children: [

                                     /// On time
                                     Column(
                                       children: [
                                         CircularPercentIndicator(
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
                                               Text("On Time" , style: TextStyle(color: Colors.grey , fontWeight: FontWeight.w400 , fontSize: 20),),
                                               Text(
                                                 "751 vehicles",
                                                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30.0),
                                               ),
                                             ],
                                           ),

                                           circularStrokeCap: CircularStrokeCap.round,
                                           // progressColor: Colors.tealAccent,
                                           linearGradient: const LinearGradient(colors: [
                                             Colors.lightGreenAccent,CupertinoColors.activeBlue
                                           ]),
                                         ),
                                         const SizedBox(height: 20,),
                                         Column(
                                           children:  [
                                             Text("82%",style: TextStyle(fontSize: 30 , color: Colors.grey.shade600),),
                                             const Text("Vehicles On Time",style: TextStyle(fontSize: 20 , color: Colors.grey),),

                                           ],
                                         )
                                       ],
                                     ),

                                     const SizedBox(
                                         height: 300,
                                         child: VerticalDivider()),

                                     /// Late
                                     Column(
                                       children: [
                                         CircularPercentIndicator(
                                           radius: 120.0,
                                           lineWidth: 18.0,
                                           animation: true,
                                           animationDuration: 3000,
                                           startAngle: 235,
                                           percent: 0.35,
                                           animateFromLastPercent: true,
                                           center: Column(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             children: const [
                                               Text("Late" , style: TextStyle(color: Colors.grey , fontWeight: FontWeight.w400 , fontSize: 20),),
                                               Text(
                                                 "152 vehicles",
                                                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30.0),
                                               ),
                                             ],
                                           ),

                                           circularStrokeCap: CircularStrokeCap.round,
                                           // progressColor: Colors.tealAccent,
                                           linearGradient: const LinearGradient(colors: [
                                             Colors.red,CupertinoColors.activeOrange
                                           ]),
                                         ),
                                         const SizedBox(height: 20,),
                                         Column(
                                           children:  [
                                             Text("33%",style: TextStyle(fontSize: 30 , color: Colors.grey.shade600),),
                                             const Text("Vehicles Running Late",style: TextStyle(fontSize: 20 , color: Colors.grey),),

                                           ],
                                         )
                                       ],
                                     ),

                                   ],
                                 ),
                               ],
                             ),
                           ))
                     ],
                   ),

                 ],
               ),
             ),
           ) :
           page == 1 ?
           const Expanded(child: VehicleDocument()) :
           page == 2 ?
           const Expanded(child: VehicleDashboard()) :
           const SizedBox()
          ],
        ),
      ),
    );
  }
  List<VehicleStatus> getChartDate(){
    final List<VehicleStatus> chartData = [
      VehicleStatus("OnRoad", 63),
      VehicleStatus("Empty", 25),
      VehicleStatus("Loading", 8),
      VehicleStatus("Unloading", 4)
    ];
    return chartData;
  }
}
class VehicleStatus{
  VehicleStatus(this.status , this.number);
  final String status;
  final int number;
}