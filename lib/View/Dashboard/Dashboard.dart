import 'dart:convert';

// import 'package:dashboard/responsive.dart';
// import 'package:dashboard/utilities/colors.dart';\
import 'package:hive/hive.dart';
import 'package:pfc/View/Login/LoginScreen.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/View/Dashboard/MyTasks.dart';
import 'package:pfc/View/Dashboard/pieChart.dart';
import 'package:pfc/View/Dashboard/reportsSection.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
// import 'package:pfc/utility/colors.dart';
// import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

import 'package:http/http.dart' as http;

enum SampleItem { itemOne, itemTwo, itemThree }

List<String> shipmentTracking = [
  'All Shipment',
  'In Transit',
  'Delivered',
  'Delayed'
];

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with Utility {
  SampleItem? selectedMenu;
  final _calendarControllerToday = AdvancedCalendarController.today();
  String shipmentTrackingValue = shipmentTracking.first;
  // CrCalendarController _controller = CrCalendarController();
  List<dynamic> user = [];
  Map VehicleStatus = {};
  double? screenWidth;
  int freshLoad = 0;
  int freshLoad2 = 0;
  var theme;
  final events = <DateTime>[
    DateTime.now(),
    DateTime(2022, 10, 10),
  ];
  void downloadPDFReport(String reportType) {
    // TODO: Implement PDF report download logic
    print('Downloading PDF report for $reportType');
  }

  @override
  void initState() {

    // getusers();
    getuserdata();
    getOverviewVehicleStatusData();

    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Hive.close();
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => const LoginScreen()),
    //         (route) => false,
    //   );
    // });

  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    theme = Theme.of(context);
    return Scaffold(
        body: Responsive(
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Container(
                    decoration:UiDecoration().formDecoration(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            padding: const EdgeInsets.all(18.0),
                            decoration: BoxDecoration(
                              color: ThemeColors.primary,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        profileImage(),
                                        const SizedBox(width: 16.0),
                                        profileDetails(),
                                      ],
                                    ),
                                    // Spacer(),
                                    Expanded(
                                      flex: 7,
                                      child: Wrap(
                                        // alignment: WrapAlignment.,

                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: analogClock(),
                                          ),
                                          screenWidth! < 1300? const SizedBox(): calendarWidget(theme)

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    elevatedButton(),
                                    const SizedBox(width: 8.0),
                                    elevatedButtonlogout(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: ThemeColors.primary,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  // #######Overview#####
                                  child: Column(
                                    children: [
                                      overviewText(),
                                      const SizedBox(height: 16.0),
                                      overviewCards(),

                                      const SizedBox(height: 16.0),
                                      // Shipment status summary
                                      _buildShipmentStatusSummary(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    // color: Colors.white,
                                    color: ThemeColors.primary,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      ExpansionTile(
                                        iconColor: Colors.white,
                                        collapsedIconColor: Colors.white,
                                        title: reportsText(),
                                        children: [
                                          Wrap(
                                            children: [
                                              const SizedBox(
                                                  width: 400,
                                                  height: 600,
                                                  child: PieChartSample2()),
                                              SizedBox(
                                                  width: 480,
                                                  height: 600,
                                                  child: ChartPage()),
                                            ],
                                          ),
                                        ],
                                        // const SizedBox(height: 16.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              widthBox10(),
              Expanded(
                  flex: 1,
                  child: Container(
                      decoration:UiDecoration().formDecoration(),

                      child: MyTaskScreen())),

            ],
          ),
          tablet: tablet(),

          mobile: tablet(),
        ));
  }

  Widget tablet() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: ThemeColors.primary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        screenWidth! < 656
                            ? Center(child: analogClock())
                            : const SizedBox(),
                        heightBox10(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                profileImage(),
                                const SizedBox(width: 16.0),
                                profileDetails(),
                              ],
                            ),
                            // Spacer(),
                            Expanded(
                              flex: 7,
                              child: Wrap(
                                // alignment: WrapAlignment.,

                                // crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  screenWidth! < 790
                                      ? const SizedBox()
                                      : analogClock(),
                                  screenWidth! < 790
                                      ? const SizedBox()
                                      : calendarWidget(theme)

                                  // Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            elevatedButton(),
                            const SizedBox(width: 8.0),
                            elevatedButtonlogout(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: ThemeColors.primary,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          // #######Overview#####
                          child: Column(
                            children: [
                              // overviewText(),
                              ExpansionTile(
                                iconColor: Colors.white,
                                collapsedIconColor: Colors.white,
                                // shape: Border.all(color: Colors.transparent),
                                title: overviewText(),
                                children: [
                                  const SizedBox(height: 16.0),
                                  overviewCards(),

                                  const SizedBox(height: 16.0),
                                  // Shipment status summary
                                  _buildShipmentStatusSummary(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: ThemeColors.primary,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ExpansionTile(
                                  iconColor: Colors.white,
                                  collapsedIconColor: Colors.white,
                                  title: shipmentText(),
                                  children: [
                                    Container(
                                        width: 900,
                                        height:500,


                                        child: MyTaskScreen()),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            color: ThemeColors.primary,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ExpansionTile(
                                iconColor: Colors.white,
                                collapsedIconColor: Colors.white,
                                title: reportsText(),
                                children: [
                                  Wrap(
                                    children: [
                                      const SizedBox(
                                          width: 400,
                                          height: 600,
                                          child: PieChartSample2()),
                                      SizedBox(
                                          width: 480,
                                          height: 600,
                                          child: ChartPage()),
                                    ],
                                  ),
                                ],
                                // const SizedBox(height: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      {required String title,
        required String value,
        required IconData icon,
        Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Wrap(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    size: 30.0,
                    color: color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Center(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentStatusSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatusIndicator(
          title: 'Reported',
          value: freshLoad2 == 1
              ? 'loading...'
              : VehicleStatus['Reported'].toString(),
          color: Colors.green,
        ),
        _buildStatusIndicator(
          title: 'On-Road',
          value: freshLoad2 == 1
              ? 'loading...'
              : VehicleStatus['On_road'].toString(),
          color: Colors.yellow,
        ),
        _buildStatusIndicator(
          title: 'Un-Loaded',
          value: freshLoad2 == 1
              ? 'loading...'
              : VehicleStatus['Un_Loaded'].toString(),
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(
      {required String title, required String value, required Color color}) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 50,
          child: Card(
            // width:70,
            color: color,
            // radius: 30.0,
            // backgroundColor: color,
            child: Center(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(title, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  profileImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('assets/driverImages/img1.jpeg', height: 200),
        // child:  AssetImage('assets/images/profile.jpeg'),
      ),
    );
  }

  profileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 50.0),
          child: Chip(
            backgroundColor: Colors.blue,
            label: Text(
              'Admin',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Text(
          freshLoad == 1 ? 'no name' : user[0]['user_name'],
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          '+91 8888 55 1111',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 16.0),
        Text(
          freshLoad == 1 ? 'no name' : user[0]['login_email'],
          style: const TextStyle(
            fontSize: 16.0,
            color: Color.fromARGB(255, 249, 249, 250),
          ),
        ),
      ],
    );
  }

  //### clock
  Widget analogClock() {
    return SizedBox(
      // width: 300,
      child: DigitalClock(
        is24HourTimeFormat: false,
        areaWidth: 200,
        areaHeight: 50,

        // secondDigitTextStyle : Theme.of(context).textTheme.caption!.copyWith(fontSize: 30),

        amPmDigitTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        hourMinuteDigitTextStyle: Theme.of(context)
            .textTheme
            .headlineLarge!
            .copyWith(color: Colors.white, fontSize: 30),
        secondDigitTextStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.white, fontSize: 20),
        colon: Text(
          ":",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  elevatedButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Implement edit profile functionality
      },
      icon: const Icon(
        Icons.edit,
        size: 16.0,
      ),
      label: const Text(
        'Edit Profile',
        style: TextStyle(fontSize: 14.0),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 255, 255, 255)),
        foregroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 101, 46, 249)),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      ),
    );
  }

  elevatedButtonlogout() {
    return ElevatedButton.icon(
      onPressed:
          () {
        Hive.close();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      },
      icon: const Icon(
        Icons.logout,
        size: 16.0,
      ),
      label: const Text(
        'Logout',
        style: TextStyle(fontSize: 14.0),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 255, 255, 255)),
        foregroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 101, 46, 249)),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      ),
    );
  }

// ################Overview#########
  Widget overviewText() {
    return const Text(
      'Overview',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  overviewCards() {
    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSummaryCard(
          icon: Icons.warning,
          title: 'Major Issues',
          value: freshLoad2 == 1
              ? 'loading...'
              : VehicleStatus['Major_issue'].toString(),
          color: Colors.red,
        ),
        _buildSummaryCard(
          icon: Icons.timer,
          title: 'Late delivery',
          value:freshLoad2 == 1
              ? 'loading...'
              : VehicleStatus['late_delivery'].toString(),
          color: Colors.orange,
        ),
        _buildSummaryCard(
          icon: Icons.shopping_cart,
          title: 'Late Loaded',
          value: freshLoad2 == 1
              ? 'loading...'
              : VehicleStatus['late_loaded'].toString(),
          color: const Color.fromARGB(255, 235, 62, 14),
        ),
      ],
    );
  }
// Reports######

  reportsText() {
    return const Text(
      'Reports and Analytics',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  allDeliveries() {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(
                Icons.file_copy,
                size: 48.0,
                color: Color.fromARGB(255, 4, 90, 176),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'All Deliveries',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              InkWell(
                onTap: () => downloadPDFReport('all_deliveries'),
                child: const Text(
                  'Download PDF Report',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(255, 7, 27, 184),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  completedDeliveries() {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(
                Icons.done_all,
                size: 48.0,
                color: Colors.green,
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Completed Deliveries',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4.0),
              InkWell(
                onTap: () => downloadPDFReport('completed_deliveries'),
                child: const Text(
                  'Download PDF Report',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(255, 7, 27, 184),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// #######Shipment#####
  shipmentText() {
    return const Text(
      'My Tasks',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  shipmentDropdown() {
    return SearchDropdownWidget(
      maxHeight: 200,
      showSearchBox: false,
      dropdownList: shipmentTracking,
      hintText: "",
      onChanged: (value) {
        shipmentTrackingValue = value!;
      },
      selectedItem: shipmentTrackingValue,
    );

    // DropdownButton<String>(
    //   style:  TextStyle(color: Colors.white),
    //   value: shipmentTrackingValue,
    //   isDense: true,
    //   dropdownColor: Color.fromARGB(255, 14, 11, 141),
    //   iconEnabledColor: Colors.white,
    //   onChanged: (value) {
    //     // Handle dropdown selection
    //     setState((){
    //     shipmentTrackingValue = value!;
    //     });
    //   },
    //   items: shipmentTracking.map<DropdownMenuItem<String>>((String value) {
    //     return DropdownMenuItem<String>(
    //       value: value,
    //       child: Text(value),
    //     );
    //   }).toList(),
    // );
  }

  listtileTittle() {
    return const Text('Assigned By: Sibghat Ahmed');
  }

  // listtileSubtittle() {
  //   return Container(
  //     child: ExpansionTile(
  //         title: Text('Remarks'),

  //         children: [
  //           Text('Delivery: Aurangabad To Mumbai'),
  //           Text('Delivery: Aurangabad To Mumbai'),
  //         ]),
  //   );
  // }

  // listtileTraling() {
  //   return Container(
  //       width: 120,
  //       height: 50,
  //       decoration: BoxDecoration(
  //           color: const Color.fromARGB(255, 252, 252, 252),
  //           borderRadius: BorderRadius.circular(5),
  //           border: Border.all(color: const Color.fromARGB(255, 29, 71, 198))),
  //       child: Padding(
  //         padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             const Text(
  //               'Status',
  //               style: TextStyle(color: Color.fromARGB(255, 11, 11, 11)),
  //             ),
  //             const Spacer(),
  //             Center(
  //               child: PopupMenuButton<SampleItem>(
  //                 position: PopupMenuPosition.over,
  //                 initialValue: selectedMenu,
  //                 // Callback that sets the selected popup menu item.
  //                 onSelected: (SampleItem item) {
  //                   setState(() {
  //                     selectedMenu = item;
  //                   });
  //                 },
  //                 itemBuilder: (BuildContext context) =>
  //                     <PopupMenuEntry<SampleItem>>[
  //                   const PopupMenuItem<SampleItem>(
  //                     value: SampleItem.itemOne,
  //                     child: Text('Completed'),
  //                   ),
  //                   const PopupMenuItem<SampleItem>(
  //                     value: SampleItem.itemTwo,
  //                     child: Text('Pending'),
  //                   ),
  //                   const PopupMenuItem<SampleItem>(
  //                     value: SampleItem.itemThree,
  //                     child: Text('In Progress'),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  // }

  calendarWidget(ThemeData theme) {
    return SizedBox(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 30),
        child: Theme(
          data: theme.copyWith(
            textTheme: theme.textTheme.copyWith(
              titleMedium: theme.textTheme.titleMedium!.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
              bodyLarge: theme.textTheme.bodyLarge!.copyWith(
                fontSize: 14,
                color: const Color.fromARGB(241, 63, 110, 241),
              ),
              bodyMedium: theme.textTheme.bodyMedium!.copyWith(
                fontSize: 12,
                color: const Color.fromARGB(221, 244, 241, 241),
              ),
            ),
            primaryColor: const Color.fromARGB(255, 45, 14, 147),
            highlightColor: const Color.fromARGB(255, 22, 119, 198),
            disabledColor: const Color.fromARGB(255, 38, 137, 236),
          ),
          child: AdvancedCalendar(
            // onHorizontalDrag: ,
            controller: _calendarControllerToday,
            events: events,
            weekLineHeight: 48.0,
            startWeekDay: 1,
            innerDot: true,
            keepLineSize: true,
            calendarTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              height: 1.3125,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }

  Future getusers() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.baseURL}User/UserEdit?user_id=${GlobalVariable.userId}');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  getuserdata() {
    setState(() {
      freshLoad = 1;
    });
    getusers().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        user = info['data'];
        setState(() {
          freshLoad = 0;
        });
      } else {
        setState(() {
          freshLoad = 0;
        });
      }
      // print(user);
    });
  }

  // ###### Overview Api ########
  Future getOverviewVehicleStatus() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.baseURL}Dashboard/UserDashboard?user_id=${GlobalVariable.userId}');
    var response = await http.get(url, headers: headers);
    // print("5t55t: ${response.body.toString()}");
    return response.body.toString();
  }

  getOverviewVehicleStatusData() {
    setState(() {
      freshLoad2 = 1;
    });
    getOverviewVehicleStatus().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        VehicleStatus = info['data'];
        setState(() {
          freshLoad2 = 0;
        });
      } else {
        setState(() {
          freshLoad2 = 0;
        });
      }
      // print(user);
    });
  }


// #########Employee Tassks Api##########







}
