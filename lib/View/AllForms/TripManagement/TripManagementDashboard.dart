import 'package:flutter/material.dart';
import 'package:pfc/utility/Widgets/CustomMenuButton.dart';
import 'package:pfc/utility/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

class TripManagementDashboard extends StatefulWidget {
  const TripManagementDashboard({Key? key}) : super(key: key);

  @override
  State<TripManagementDashboard> createState() => _TripManagementDashboardState();
}

class _TripManagementDashboardState extends State<TripManagementDashboard> {

  DateTime today = DateTime.now();
  int page = 0;

  @override
  Widget build(BuildContext context) {

    List buttonNames = [
      {
        'btn_name': '',
        'class_name': '',
      }
    ];

    final List<ChartData> chartData = <ChartData>[
      ChartData('Monday', 18, 129),
      ChartData('Tuesday', 123, 92),
      ChartData('Wednesday', 107, 106),
      ChartData('Thursday', 77, 95,),
      ChartData('Friday', 187, 95,),
      ChartData('Saturday', 87, 95,),
      ChartData('Sunday', 74, 95,),
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10,),

            page == 0 ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Row(
                children: const [
                  Icon(Icons.timeline , color: Colors.grey, size: 30),
                  SizedBox(width: 10,),
                  Text("Trip Management" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),),
                ],
              ),
                /// Submenu
                CustomMenuButton(buttonNames: buttonNames)
            ],
            ) : const SizedBox(),

            const SizedBox(height: 10,),

            /// Buttons
            SizedBox(
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                        onPressed: () {},
                        style: ButtonStyles.dashboardButton(page == 1),
                        child: Text("Create Trip" ,style: TextDecorationClass().dashboardBtn(),)
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyles.dashboardButton(page == 2),
                        child:  Text("All Trips" ,style: TextDecorationClass().dashboardBtn(),)
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyles.dashboardButton(page == 3),
                        child: Text("Closed Trips" ,style: TextDecorationClass().dashboardBtn(),)
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10,),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        /// Top Card
                        UiDecoration().topCardWidget(Icons.add_road, "352", "Running Trips" , Colors.amberAccent),

                        UiDecoration().topCardWidget(Icons.add, "312", "Issue Trips" , Colors.blueGrey),

                        UiDecoration().topCardWidget(Icons.check, "52", "This Month Closed Trips" , Colors.blue),

                        UiDecoration().topCardWidget(Icons.done_all, "752", "All Closed Trips" , Colors.green),

                      ],
                    ),

                    const SizedBox(height: 20,),
                    /// Calendar && Chart
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Calendar
                        Expanded(flex: 7,
                            child: Container(
                              decoration: UiDecoration().dashboardBox(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TableCalendar(
                                      focusedDay: today,
                                      firstDay: DateTime.utc(2010, 10 , 16),
                                      lastDay: DateTime.utc(2030 , 10 , 16)),
                                  const SizedBox(height: 10,),

                                  const Divider(),

                                  /// Driver Updates
                                  const Padding(
                                    padding:  EdgeInsets.only(top: 8.0 , left: 8 , bottom: 4),
                                    child:  Text("Driver Updates" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),),
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 0,),
                                  UiDecoration().driverUpdates("Mumbai --> Pune - MH20211212", "assets/driverImages/img12.png", "Imran Khan", "15 min ago", "Reported", Colors.green),
                                  const Divider(),
                                  const SizedBox(height: 0,),
                                  UiDecoration().driverUpdates("Hyderabad --> Aurangabad - MH202113312", "assets/driverImages/img12.png", "Adbulrafee", "45 min ago", "OnRoad", Colors.yellow.shade700),
                                  const Divider(),
                                  const SizedBox(height: 0,),
                                  UiDecoration().driverUpdates("Karnataka --> Aurangabad - MH2021199890", "assets/driverImages/img12.png", "Yusuf Patel", "55 min ago", "UnLoading", Colors.blue),
                                  const Divider(),
                                  const SizedBox(height: 0,),
                                  UiDecoration().driverUpdates("Ahmedabad --> Kutch - MH202119077767", "assets/driverImages/img12.png", "Sanjay Rao", "56 min ago", "OnRoad", Colors.yellow.shade700),
                                  const Divider(),
                                  const SizedBox(height: 20,),

                                  /// Show More
                                  const Align(
                                      alignment: Alignment.center,
                                      child:  Text("Show more" , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15),)),

                                  const SizedBox(height: 20,)
                                ],
                              ),
                            )),

                        const SizedBox(width: 20,),

                        /// Chart
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [

                              /// chart
                              Container(
                                decoration: UiDecoration().dashboardBox(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:  EdgeInsets.only(top: 8.0 , left: 8 , bottom: 4),
                                      child:  Text("Reservation Stats" , style: TextStyle(fontSize: 17 , fontWeight: FontWeight.w500),),
                                    ),
                                    const Divider(),
                                    SfCartesianChart(
                                        primaryXAxis: CategoryAxis(),
                                        series: <CartesianSeries>[
                                          ColumnSeries<ChartData, String>(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(0),
                                              width: 0.2,
                                              dataSource: chartData,
                                              xValueMapper: (ChartData data, _) => data.x,
                                              yValueMapper: (ChartData data, _) => data.y
                                          ),
                                          ColumnSeries<ChartData, String>(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(0),
                                              width: 0.2,
                                              dataSource: chartData,
                                              xValueMapper: (ChartData data, _) => data.x,
                                              yValueMapper: (ChartData data, _) => data.y1
                                          ),

                                        ]
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20,),

                              /// Green Cards
                              Row(
                                children: [
                                  UiDecoration().greenCard("Available Vehicles Today", "687", 80),
                                  const SizedBox(width: 5,),
                                  UiDecoration().greenCard("Out For Delivery Today", "387", 150) ,
                                ],
                              ) ,

                              const SizedBox(height: 20,),

                              /// more details
                              Container(
                                height: 290,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                decoration: UiDecoration().dashboardBox(),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        UiDecoration().moreDetails("456", "Total Consignor"),
                                        UiDecoration().moreDetails("4916", "Total Customer"),

                                      ],
                                    ),

                                    const SizedBox(height: 100,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        UiDecoration().moreDetails("978", "Total Vehicles"),
                                        UiDecoration().moreDetails("836k", "Total Transaction"),


                                      ],
                                    ),
                                  ],
                                ),
                              )

                            ],
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 40,)
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
  ChartData(this.x, this.y, this.y1);
  final String x;
  final double? y;
  final double? y1;
}