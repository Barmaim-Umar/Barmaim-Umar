import 'package:pfc/View/TrafficDashboard/HeaderScreens/MajorIssueVehicles.dart';
import 'package:pfc/utility/Widgets/AutoCompleteLocationModel/autocompleteprediction.dart';
import 'package:pfc/utility/Widgets/AutoCompleteLocationModel/autocompleteresponse.dart';
import 'package:pfc/utility/Widgets/AutoCompleteLocationModel/locationListTile.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/Provider/AnimationProvider.dart';
import 'package:pfc/View/TrafficDashboard/AdvanceReport.dart';
import 'package:pfc/View/traffic.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class TrafficVehicleInfo extends StatefulWidget {
  Map vehicleDetails = {};
  List? vehicleDocument;
  int? vehicleId;
  int? activityId;
  int? activityStatus;
  TrafficVehicleInfo(
      {Key? key,
      required this.vehicleDetails,
      required this.vehicleId,
      required this.activityId,
      required this.activityStatus,
      required this.vehicleDocument})
      : super(key: key);

  @override
  State<TrafficVehicleInfo> createState() => _TrafficVehicleInfoState();
}

class _TrafficVehicleInfoState extends State<TrafficVehicleInfo>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ScrollController scrollController2 = ScrollController();
  TextEditingController searchRoutes = TextEditingController();
  DateTimeRange? _dateRange;
  TextEditingController dateRangeController = TextEditingController();
  var formattedStartDateApi = '';
  var formattedEndDateApi = '';
  List vehicleRoutesList = [];
  int freshLoad = 0;
  int freshLoad2 = 0;
  String dropDownValue = '';
  String selectedDropDownValue = '';
  List<String> list = [
    'Reported',
    'Unload',
    'Send Empty',
    'Crossing',
    'Diverted'
  ];
  TextEditingController fromDate = TextEditingController();
  TextEditingController majorIssueRemark = TextEditingController();
  TextEditingController vehicleStatusRemark = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController dayControllerMajorIssue = TextEditingController(
      text: GlobalVariable.displayDate.day.toString().padLeft(2, '0'));
  TextEditingController monthControllerMajorIssue = TextEditingController(
      text: GlobalVariable.displayDate.month.toString().padLeft(2, '0'));
  TextEditingController yearControllerMajorIssue =
      TextEditingController(text: GlobalVariable.displayDate.year.toString());
  TextEditingController dayControllerVehicleActivity = TextEditingController(
      text: GlobalVariable.displayDate.day.toString().padLeft(2, '0'));
  TextEditingController monthControllerVehicleActivity = TextEditingController(
      text: GlobalVariable.displayDate.month.toString().padLeft(2, '0'));
  TextEditingController yearControllerVehicleActivity =
      TextEditingController(text: GlobalVariable.displayDate.year.toString());
  int? activityStatus;
  late AnimationController _animationController;
  TextEditingController fromLocation = TextEditingController();
  TextEditingController toLocation = TextEditingController();

  Color? vehicleDetailsBGColor;

  majorIssueApiFunc() {
    majorIssue().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  vehicleStatusApiFunc() {
    vehicleStatus().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  vehicleActivityApiFunc() {
    vehicleRoutesList.isEmpty ? freshLoad = 1 : freshLoad = 0;
    setStateMounted(() {
      freshLoad2 = 1;
    });
    vehicleRoutesApi().then((value) {
      var info2 = jsonDecode(value);
      if (info2['success'] == true) {
        // vehicleRoutesList.clear();
        vehicleRoutesList.addAll(info2['data']);
        setStateMounted(() {
          GlobalVariable.totalPages = info2['total_pages'];
          freshLoad = 0;
          freshLoad2 = 0;
        });
      } else {
        setStateMounted(() {
          freshLoad = 0;
          freshLoad2 = 0;
        });
        // AlertBoxes.flushBarErrorMessage(info2['message']+' For This Vehicles Routes', context);
      }
    });
  }

  dashboardHeaderApiFunc() {
    setStateMounted(() {
      freshLoad = 1;
    });
    dashboardHeaderApi().then((value) {
      var info2 = jsonDecode(value);
      if (info2['success'] == true) {
        GlobalVariable.dashboardHeaders.clear();
        GlobalVariable.dashboardHeaders.addAll(info2['data']);
        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        // AlertBoxes.flushBarErrorMessage(info2['message'], context);
        setStateMounted(() {
          freshLoad = 1;
        });
      }
      print('dashboard headrs ${GlobalVariable.dashboardHeaders}');
    });
  }

  List<AutoCompletePrediction> placePrediction = [];

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https('maps.googleapis.com',
        'maps/api/place/autocomplete/json', {'input': query, 'key': ''});
    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      print(response);
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePrediction = result.predictions!;
        });
      }
    }
  }

  @override
  void initState() {
    // print('bhgiggt78gitdgf:  $vehicleDetails');0kjhg
    setState(() {
      activityStatus = widget.activityStatus;
    });
    activityStatus == 3
        ? dropDownValue = list.first
        : activityStatus == 4
            ? dropDownValue = list.elementAt(1)
            : activityStatus == 0
                ? dropDownValue = list.elementAt(2)
                : activityStatus == 5
                    ? dropDownValue = list.elementAt(3)
                    : activityStatus == 6
                        ? dropDownValue = list.elementAt(4)
                        : '';
    vehicleDetailsBGColor = activityStatus == 3
        ? ThemeColors.greenColor
        : activityStatus == 4
            ? Colors.grey.shade700
            : activityStatus == 0
                ? ThemeColors.redColor
                : activityStatus == 5
                    ? ThemeColors.yellowColor
                    : activityStatus == 6
                        ? ThemeColors.orangeColor
                        : Colors.lightBlueAccent;
    // dropDownValue == list.first? activityStatus = 3:dropDownValue == list.elementAt(1)? activityStatus =4:dropDownValue == list.elementAt(2)? activityStatus = 0:dropDownValue == list.elementAt(3)? activityStatus = 5: activityStatus =6;
    UiDecoration().initialDateApi(setState, fromDateApi);
    selectedDropDownValue = dropDownValue;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animationController.repeat(reverse: true);
    vehicleActivityApiFunc();
    dashboardHeaderApiFunc();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    dateRangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(

        /// Mobile
        mobile: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          margin: const EdgeInsets.only(bottom: 5),
          // color: Colors.green,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TopBar
              Row(
                children: [
                  // driver image
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 25,
                    backgroundImage:

                    widget.vehicleDetails['driver_data'] != null && widget.vehicleDetails['driver_data'] != [] && widget.vehicleDetails['driver_data']==null
                            ? NetworkImage(
                                GlobalVariable.trafficBaseURL +
                                    widget.vehicleDetails['driver_data'][0]
                                            ['driver_photo']
                                        .toString(),
                              ) as ImageProvider<Object>?
                            : const AssetImage(
                                "assets/driverImages/img11.jpeg",
                              ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),
                  // Driver Name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vehicleDetails.containsKey('driver_data') && widget.vehicleDetails['driver_data']==null
                            ? widget.vehicleDetails['driver_data'][0]
                                    ['driver_name']
                                .toString()
                            : '-',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        'Mob No: ${widget.vehicleDetails.containsKey('driver_data') && widget.vehicleDetails['driver_data']==null ? widget.vehicleDetails['driver_data'][0]['driver_mobile_number'].toString() : '-'}',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Guarantor Name: ${ widget.vehicleDetails['driver_data']==null && widget.vehicleDetails.containsKey('driver_data') && widget.vehicleDetails['driver_data'][0]['guarantor_name'] != null ? widget.vehicleDetails['driver_data'][0]['guarantor_name'].toString() : '-'}',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const Spacer(),

                  const Icon(Icons.more_vert),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // VehicleDetails
              // TrafficVehicleDetails(vehicleDetails: widget.vehicleDetails,vehicleId: widget.vehicleId,activityId: widget.activityId,activityStatus: widget.activityStatus),

              vehicleDetails(),

              // Routes | Driver Statistics
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: routes()),
                    Container(
                      height: double.infinity,
                      width: 1,
                      color: Colors.grey.shade400,
                    ),
                    Expanded(
                        child: AdvanceReport(
                      vehicleId: widget.vehicleId,
                    )),
                  ],
                ),
              )
            ],
          ),
        ),

        /// Tablet
        tablet: Container(),
        // Column(
        //   children: [
        //     Expanded(
        //       child: SingleChildScrollView(
        //         child: Column(
        //           children: [
        //             Container(
        //               decoration: BoxDecoration(
        //                   color: Colors.white,
        //                   borderRadius: BorderRadius.circular(10),
        //                   boxShadow: [
        //                     BoxShadow(
        //                         color: Colors.grey.shade300,
        //                         blurRadius: 5.0,
        //                         spreadRadius: 3),
        //                   ]),
        //               padding:
        //                   const EdgeInsets.only(left: 10, right: 10, top: 10),
        //               margin: const EdgeInsets.only(bottom: 0, top: 0),
        //               // color: Colors.green,
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   /// driver and vehicle info
        //                   Padding(
        //                     padding: const EdgeInsets.only(
        //                         top: 3, left: 5, right: 5),
        //                     child: Column(
        //                       children: [
        //                         // Driver Information
        //                         Row(
        //                           children: [
        //                             // driver image
        //                             Container(
        //                               decoration: BoxDecoration(
        //                                 // color: Colors.red,
        //                                 borderRadius: BorderRadius.circular(50),
        //                                 // boxShadow: [
        //                                 //   BoxShadow(color: Colors.grey.shade400 ,
        //                                 //   spreadRadius: .1,
        //                                 //     blurRadius: 3
        //                                 //   )
        //                                 // ]
        //                               ),
        //                               child: widget.vehicleDetails
        //                                       .containsKey('driver_data')
        //                                   ? widget.vehicleDetails['driver_data']
        //                                               [0]['driver_photo'] ==
        //                                           ""
        //                                       ? const CircleAvatar(
        //                                           backgroundColor:
        //                                               Colors.transparent,
        //                                           radius: 25,
        //                                           backgroundImage: AssetImage(
        //                                             "assets/driverImages/img11.jpeg",
        //                                           ),
        //                                         )
        //                                       : CircleAvatar(
        //                                           backgroundColor:
        //                                               Colors.transparent,
        //                                           radius: 25,
        //                                           backgroundImage: NetworkImage(
        //                                               GlobalVariable
        //                                                       .trafficBaseURL +
        //                                                   widget.vehicleDetails[
        //                                                           'driver_data']
        //                                                           [
        //                                                           'driver_photo']
        //                                                       .toString()))
        //                                   : const CircleAvatar(
        //                                       backgroundColor:
        //                                           Colors.transparent,
        //                                       radius: 25,
        //                                       backgroundImage: AssetImage(
        //                                         "assets/driverImages/img11.jpeg",
        //                                       ),
        //                                     ),
        //                             ),
        //                             const SizedBox(
        //                               width: 8,
        //                             ),
        //                             // Driver Name
        //                             Column(
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               children: [
        //                                 Text(
        //                                   widget.vehicleDetails
        //                                           .containsKey('driver_data')
        //                                       ? widget
        //                                           .vehicleDetails['driver_data']
        //                                               [0]['driver_name']
        //                                           .toString()
        //                                       : '-',
        //                                   style: const TextStyle(
        //                                       fontWeight: FontWeight.bold,
        //                                       fontSize: 15),
        //                                 ),
        //                                 Text(
        //                                   'Mob No: ${widget.vehicleDetails.containsKey('driver_data') ? widget.vehicleDetails['driver_data'][0]['driver_mobile_number'].toString() : '-'}',
        //                                   style: TextStyle(
        //                                       fontSize: 11,
        //                                       color: Colors.grey.shade600,
        //                                       fontWeight: FontWeight.w400),
        //                                 ),
        //                                 Text(
        //                                   'Guarantor Name: ${widget.vehicleDetails.containsKey('driver_data') && widget.vehicleDetails['driver_data'][0]['guarantor_name'] != null ? widget.vehicleDetails['driver_data']['guarantor_name'].toString() : '-'}',
        //                                   style: TextStyle(
        //                                       fontSize: 11,
        //                                       color: Colors.grey.shade600,
        //                                       fontWeight: FontWeight.w400),
        //                                 ),
        //                               ],
        //                             ),
        //                             const Spacer(),
        //
        //                             const Icon(Icons.more_vert),
        //                           ],
        //                         ),
        //                         const SizedBox(
        //                           height: 5,
        //                         ),
        //                         // VehicleDetails
        //                         // TrafficVehicleDetails(
        //                         //     vehicleDetails: widget.vehicleDetails,vehicleId: widget.vehicleId,activityId: widget.activityId,activityStatus: widget.activityStatus),
        //
        //                         vehicleDetails(),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 routes(),
        //                 AdvanceReport(vehicleId: widget.vehicleId),
        //               ],
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),

        /// Desktop
        desktop: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5.0,
                          spreadRadius: 3),
                    ]),
                padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                margin: const EdgeInsets.only(bottom: 1, top: 5),
                // color: Colors.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Top Indicators
                    Wrap(
                      children: [
                        // Late Delivery
                        Consumer<ButtonProvider>(
                          builder: (context, buttonProvider, child) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>  Traffic(),
                                    ));
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                // transform: buttonProvider.isJumping ? Matrix4.translationValues(00, -5, 00) : Matrix4.translationValues(00, 00, 00),
                                child: FormWidgets().containerWidget(
                                    'Late Delivery',
                                    GlobalVariable.dashboardHeaders.isEmpty
                                        ? '-'
                                        : GlobalVariable.dashboardHeaders[0]
                                                ['late_delivery']
                                            .toString(),
                                    ThemeColors.primaryColor),
                              ),
                            );
                          },
                        ),

                        // Late Loading
                        Consumer<ButtonProvider>(
                          builder: (context, buttonProvider, child) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>  Traffic(),
                                    ));
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                // transform: buttonProvider.isJumping ? Matrix4.translationValues(00, 0, 00) : Matrix4.translationValues(00, -5, 00),
                                child: FormWidgets().containerWidget(
                                    'Late Loading',
                                    GlobalVariable.dashboardHeaders.isEmpty
                                        ? '-'
                                        : GlobalVariable.dashboardHeaders[0]
                                                ['late_loaded']
                                            .toString(),
                                    ThemeColors.primaryColor),
                              ),
                            );
                          },
                        ),

                        // Pending LR
                        Consumer<ButtonProvider>(
                          builder: (context, buttonProvider, child) {
                            return GestureDetector(
                              // onTap:() => buttonProvider.startJumping(),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  Traffic(),
                                      ));
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  // transform: buttonProvider.isJumping ? Matrix4.translationValues(00, -5, 00) : Matrix4.translationValues(00, 00, 00),
                                  child: FormWidgets().containerWidget(
                                      'Pending LR',
                                      GlobalVariable.dashboardHeaders.isEmpty
                                          ? '-'
                                          : GlobalVariable.dashboardHeaders[0]
                                                  ['pending_lr']
                                              .toString(),
                                      ThemeColors.primaryColor),
                                ),
                              ),
                            );
                          },
                        ),

                        // Vehicle Without Driver
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  Traffic(),
                                  ));
                            },
                            child: FormWidgets().containerWidget(
                                'Vehicle Without Driver',
                                GlobalVariable.dashboardHeaders.isEmpty
                                    ? '-'
                                    : GlobalVariable.dashboardHeaders[0]
                                            ['without_driver']
                                        .toString(),
                                ThemeColors.primaryColor)),

                        // Vehicle in Maintenance
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  Traffic(),
                                  ));
                            },
                            child: FormWidgets().containerWidget(
                                'Vehicle in Maintenance',
                                GlobalVariable.dashboardHeaders.isEmpty
                                    ? '-'
                                    : GlobalVariable.dashboardHeaders[0]
                                            ['maintanance']
                                        .toString(),
                                ThemeColors.primaryColor)),

                        // Major Issue
                        Consumer<ButtonProvider>(
                          builder: (context, buttonProvider, child) {
                            return GestureDetector(
                              // onTap:() => buttonProvider.startJumping(),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MajorIssuesVehicles(),
                                      ));
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  // transform: buttonProvider.isJumping ? Matrix4.translationValues(00, 0, 00) : Matrix4.translationValues(00, -5, 00),
                                  child: FormWidgets().containerWidget(
                                      'Major Issue',
                                      GlobalVariable.dashboardHeaders.isEmpty
                                          ? '-'
                                          : GlobalVariable.dashboardHeaders[0]
                                                  ['major_issue']
                                              .toString(),
                                      ThemeColors.darkRedColor),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    /// driver and vehicle info
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child: Column(
                        children: [
                          /// Driver Information
                          Row(
                            children: [
                              // driver image
                           widget.vehicleDetails['driver_data']==null && widget.vehicleDetails.containsKey('driver_data')
                                  ? widget.vehicleDetails['driver_data'][0]
                                              ['driver_photo'] ==
                                          ""
                                      ? const CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 25,
                                          backgroundImage: AssetImage(
                                            "assets/driverImages/img11.jpeg",
                                          ),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 25,
                                          backgroundImage: NetworkImage(
                                              GlobalVariable.trafficBaseURL +
                                                  widget.vehicleDetails[
                                                          'driver_data'][0]
                                                          ['driver_photo']
                                                      .toString()))
                                  : const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 25,
                                      backgroundImage: AssetImage(
                                        "assets/driverImages/img11.jpeg",
                                      ),
                                    ),
                              const SizedBox(
                                width: 8,
                              ),
                              // Driver Name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.vehicleDetails['driver_data'].isNotEmpty ?
                                    widget.vehicleDetails['driver_data'][0]['driver_name'] != null &&
                                        widget.vehicleDetails['driver_data'][0]['driver_name'].toString() != "" ?
                                    widget.vehicleDetails['driver_data'][0]['driver_name'].toString()
                                        : '-'
                                        : 'Not Assigned',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Mob No: ',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        widget.vehicleDetails['driver_data'].isNotEmpty ?
                                        widget.vehicleDetails['driver_data'][0]['driver_mobile_number'] != null &&
                                            widget.vehicleDetails['driver_data'][0]['driver_mobile_number'].toString() != "" ?
                                        widget.vehicleDetails['driver_data'][0]['driver_mobile_number'].toString()
                                        : '-'
                                            : '-',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade800,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Guarantor Name: ',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        widget.vehicleDetails['driver_data'].isNotEmpty ?
                                        widget.vehicleDetails['driver_data'][0]['guarantor_name'] != null &&
                                            widget.vehicleDetails['driver_data'][0]['guarantor_name'].toString() != "" ?
                                        widget.vehicleDetails['driver_data'][0]['guarantor_name'].toString()
                                            : '-'
                                            : '-',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade800,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),

                              const Icon(Icons.more_vert),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // VehicleDetails
                          // TrafficVehicleDetails(
                          //     vehicleDetails: widget.vehicleDetails,vehicleId: widget.vehicleId,activityId: widget.activityId,activityStatus: widget.activityStatus),

                          vehicleDetails(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: routes()),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: AdvanceReport(
                    vehicleId: widget.vehicleId,
                  )),
                ],
              )
            ],
          ),
        ));
  }

  Widget info(String title, String info) {
    return Responsive(
      mobile: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.grey.shade300, fontWeight: FontWeight.w500),
          ),
          Text(
            info,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
      tablet: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.grey.shade300,
                fontWeight: FontWeight.w500,
                fontSize: 10),
          ),
          Text(
            info,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
      desktop: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.grey.shade300, fontWeight: FontWeight.w500),
          ),
          Text(
            info,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget routes() {
    return Container(
      height: MediaQuery.of(context).size.height / 2.25,
      padding: const EdgeInsets.only(top: 0, bottom: 0, right: 5, left: 10),
      margin: const EdgeInsets.only(
        top: 5,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: ThemeColors.boxShadow, blurRadius: 5.0, spreadRadius: 3),
          ]),
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Routes | History
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Padding(
              padding: EdgeInsets.only(left: 0, top: 5, bottom: 0),
              child: Text(
                'Routes',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Expanded(
                flex: 1,
                child: TextFormField(
                  controller: dateRangeController,
                  readOnly: true,
                  onTap: () {
                    _showDateRangePicker();
                  },
                  decoration: UiDecoration()
                      .dateFieldDecoration('Select From Date and To Date'),
                )),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 40,
              child: AnimSearchBar(
                width: 230,
                boxShadow: false,
                textController: searchRoutes,
                onSuffixTap: () {},
                onSubmitted: (p0) {
                  setState(() {
                    searchRoutes.text = p0;
                    vehicleRoutesList.clear();
                  });
                  vehicleActivityApiFunc();
                },
                suffixIcon: const Icon(CupertinoIcons.xmark_circle, size: 20),
              ),
            ),
          ]),
          const Divider(),

          freshLoad == 1
              ? const Center(child: CircularProgressIndicator())
              : vehicleRoutesList.isEmpty
                  ? Center(
                      child:
                          TextDecorationClass().heading1('Data Not Available'))
                  : Expanded(
                      child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: freshLoad == 1
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: vehicleRoutesList.length,
                                  itemBuilder: (context, index) {
                                    return SingleChildScrollView(
                                      controller: scrollController2,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          freshLoad == 1
                                              ? const CircularProgressIndicator()
                                              : UiDecoration()
                                                  .vehicleExpansionTile(
                                                      vehicleRoutesList[index]
                                                          ['lr_number'],
                                                      vehicleRoutesList[index]
                                                          ['expected_date'],
                                                      UiDecoration().getFormattedDate(
                                                          vehicleRoutesList[index]
                                                              [
                                                              'activity_date']),
                                                      vehicleRoutesList[index]
                                                          ['from_location'],
                                                      vehicleRoutesList[index]
                                                          ['to_location'],
                                                      vehicleRoutesList[index]
                                                              ['user_name'] ??
                                                          '-',
                                                      'Pepsico India Holdings ',
                                                      vehicleRoutesList[index][
                                                                  'activity_status'] ==
                                                              0
                                                          ? 'Empty'
                                                          : vehicleRoutesList[index]
                                                                      [
                                                                      'activity_status'] ==
                                                                  1
                                                              ? 'Pending'
                                                              : vehicleRoutesList[index]
                                                                          ['activity_status'] ==
                                                                      2
                                                                  ? 'OnRoad'
                                                                  : vehicleRoutesList[index]['activity_status'] == 3
                                                                      ? 'Reported'
                                                                      : 'Unloaded',
                                                      vehicleRoutesList[index]['activity_status'] == 0
                                                          ? ThemeColors.redColor
                                                          : vehicleRoutesList[index]['activity_status'] == 1
                                                              ? ThemeColors.orangeColor
                                                              : vehicleRoutesList[index]['activity_status'] == 2
                                                                  ? ThemeColors.darkBlueColor
                                                                  : vehicleRoutesList[index]['activity_status'] == 3
                                                                      ? ThemeColors.greenColor
                                                                      : ThemeColors.grey700),
                                          const Divider(),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                GlobalVariable.currentPage ==
                                        GlobalVariable.totalPages
                                    ? const SizedBox()
                                    : freshLoad2 == 1
                                        ? const CircularProgressIndicator()
                                        : InkWell(
                                            onTap: () {
                                              setStateMounted(() {
                                                GlobalVariable.currentPage =
                                                    GlobalVariable.currentPage +
                                                        1;
                                                // print(GlobalVariable.currentPage);
                                              });
                                              // widget.routesListApiFunc;
                                              vehicleActivityApiFunc();
                                            },
                                            child: Text(
                                              'Show More',
                                              style: TextStyle(
                                                  color:
                                                      ThemeColors.darkBlueColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                          ),
                                const SizedBox(height: 10)
                              ],
                            ),
                    )),
        ],
      ),
    );
  }

  Widget vehicleDetails() {
    return Responsive(

        /// Mobile
        mobile: Container(),

        /// Tablet
        tablet: Container(
          padding:
              const EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 20),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            // color: ThemeColors.primaryColor.withOpacity(1),
            color: vehicleDetailsBGColor,
            borderRadius: BorderRadius.circular(8),
            // boxShadow: [BoxShadow(color: Colors.black38 , blurRadius: 1 , spreadRadius: 1 ,)]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        spacing: 30,
                        runSpacing: 30,
                        children: [
                          info(
                              "LR No.",
                              widget.vehicleDetails.containsKey('current')
                                  ? widget.vehicleDetails['current']
                                          ['lr_number']
                                      .toString()
                                  : '-'),
                          info("Company Name", "T & D GALIAKOT CONTAINERS"),
                          info(
                            "From City",
                            widget.vehicleDetails.containsKey('current')
                                ? widget.vehicleDetails['current']
                                        ['from_location']
                                    .toString()
                                : '-',
                          ),
                          info(
                              "To City",
                              widget.vehicleDetails.containsKey('current')
                                  ? widget.vehicleDetails['current']
                                          ['to_location']
                                      .toString()
                                  : '-'),
                          // Action Dropdown

                          SizedBox(
                            width: 155,
                            child: SearchDropdownWidget(
                              borderColor: Colors.white,
                              textColor: true,
                              fillColor: Colors.transparent,
                              showSearchBox: false,
                              maxHeight: 250,
                              dropdownList: list,
                              hintText: 'Action',
                              onChanged: (String? newValue) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropDownValue = newValue!;
                                  dropDownValue == list.first
                                      ? activityStatus = 3
                                      : dropDownValue == list.elementAt(1)
                                          ? activityStatus = 4
                                          : dropDownValue == list.elementAt(2)
                                              ? activityStatus = 0
                                              : dropDownValue ==
                                                      list.elementAt(3)
                                                  ? activityStatus = 5
                                                  : activityStatus = 6;
                                });

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text(dropDownValue),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          dropDownValue == 'Reported' ||
                                                  dropDownValue == 'Unload'
                                              ? const SizedBox()
                                              : Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            dropDownValue ==
                                                                    'Send Empty'
                                                                ? 'Send Empty To'
                                                                : dropDownValue ==
                                                                        'Diverted'
                                                                    ? 'Diverted From'
                                                                    : 'Crossing From',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            // height: 35,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  fromLocation,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                              decoration:
                                                                  UiDecoration()
                                                                      .outlineTextFieldDecoration(
                                                                "Enter From Location",
                                                                Colors.grey,
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                placeAutocomplete(
                                                                    value);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            dropDownValue ==
                                                                    'Send Empty'
                                                                ? 'Send Empty To'
                                                                : dropDownValue ==
                                                                        'Diverted'
                                                                    ? 'Diverted To'
                                                                    : 'Crossing To',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            // height: 35,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  toLocation,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                              decoration:
                                                                  UiDecoration()
                                                                      .outlineTextFieldDecoration(
                                                                "Enter To Location",
                                                                Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          const SizedBox(height: 10),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: SizedBox(
                                                  // height: 35,
                                                  child: TextFormField(
                                                    controller:
                                                        vehicleStatusRemark,
                                                    maxLines: 3,
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                    decoration: UiDecoration()
                                                        .outlineTextFieldDecoration(
                                                      "Enter Remark",
                                                      Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        TextDecorationClass()
                                                            .heading1('Date'),
                                                        const Text(
                                                          "  dd-mm-yyyy",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      ],
                                                    ),
                                                    DateFieldWidget2(
                                                        dayController:
                                                            dayControllerVehicleActivity,
                                                        monthController:
                                                            monthControllerVehicleActivity,
                                                        yearController:
                                                            yearControllerVehicleActivity,
                                                        dateControllerApi:
                                                            fromDate),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          // setState(() {
                                          //   dropDownValue =
                                          //       selectedDropDownValue;
                                          //   vehicleDetailsBGColor = activityStatus ==
                                          //           3
                                          //       ? ThemeColors.greenColor
                                          //       : activityStatus == 4
                                          //           ? Colors.grey.shade700
                                          //           : activityStatus == 0
                                          //               ? ThemeColors.redColor
                                          //               : activityStatus == 5
                                          //                   ? ThemeColors
                                          //                       .yellowColor
                                          //                   : activityStatus ==
                                          //                           6
                                          //                       ? ThemeColors
                                          //                           .orangeColor
                                          //                       : Colors
                                          //                           .lightBlueAccent;
                                          // });
                                          Navigator.pop(context, 'Cancel');
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          vehicleStatusApiFunc();
                                          setState(() {
                                            selectedDropDownValue =
                                                dropDownValue;
                                            vehicleDetailsBGColor = activityStatus ==
                                                    3
                                                ? ThemeColors.greenColor
                                                : activityStatus == 4
                                                    ? Colors.grey.shade700
                                                    : activityStatus == 0
                                                        ? ThemeColors.redColor
                                                        : activityStatus == 5
                                                            ? ThemeColors
                                                                .yellowColor
                                                            : activityStatus ==
                                                                    6
                                                                ? ThemeColors
                                                                    .orangeColor
                                                                : Colors
                                                                    .lightBlueAccent;
                                            vehicleStatusRemark.clear();
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              selectedItem: dropDownValue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Vehicle Number | Major Issue
                      Wrap(
                        runSpacing: 20,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              widget.vehicleDetails['vehicle_number']
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          // Major Issue Button
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeColors.darkRedColor,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18, horizontal: 10)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    titlePadding: const EdgeInsets.all(8),
                                    title: const Text("Major Issue"),
                                    contentPadding: const EdgeInsets.all(8),
                                    content: SingleChildScrollView(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: SizedBox(
                                              // height: 35,
                                              child: TextFormField(
                                                controller: majorIssueRemark,
                                                maxLines: 3,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                                decoration: UiDecoration()
                                                    .outlineTextFieldDecoration(
                                                  "Enter Remark",
                                                  Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    TextDecorationClass()
                                                        .heading1('Date'),
                                                    const Text(
                                                      "  dd-mm-yyyy",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                                DateFieldWidget2(
                                                    dayController:
                                                        dayControllerMajorIssue,
                                                    monthController:
                                                        monthControllerMajorIssue,
                                                    yearController:
                                                        yearControllerMajorIssue,
                                                    dateControllerApi:
                                                        fromDateApi),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          majorIssueApiFunc();
                                          setState(() {
                                            majorIssueRemark.clear();
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text(
                                "Major Issues",
                                style: TextStyle(fontSize: 15),
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          // Documents Button
                          Stack(
                            children: [
                              // View Documents
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 10),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text("Documents"),
                                        content: SizedBox(
                                          width: 500,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2, bottom: 2),
                                            child: GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3),
                                              padding: const EdgeInsets.all(10),
                                              shrinkWrap: true,
                                              itemCount: widget
                                                  .vehicleDocument!.length,
                                              itemBuilder: (context, index) {
                                                String documentName = widget
                                                    .vehicleDocument![index]
                                                        ['document_name']
                                                    .toString();
                                                String documentPath = widget
                                                    .vehicleDocument![index]
                                                        ['document_path']
                                                    .toString();

                                                // Get the file extension from the document path
                                                String fileExtension =
                                                    getFileExtension(
                                                        documentPath);

                                                // Determine which icon to display based on the file extension
                                                Widget iconWidget;
                                                if (fileExtension == 'png' ||
                                                    fileExtension == 'jpg' ||
                                                    fileExtension == 'jpeg' ||
                                                    fileExtension == 'img' ||
                                                    fileExtension == 'png...') {
                                                  iconWidget = Image.asset(
                                                      'assets/download-image-icon.png',
                                                      height: 80);
                                                } else {
                                                  iconWidget = Image.asset(
                                                      'assets/download-pdf-icon.png',
                                                      height: 80);
                                                }

                                                return Card(
                                                  color: Colors.grey.shade300,
                                                  child: InkWell(
                                                    onTap: () {
                                                      var url =
                                                          '${GlobalVariable.trafficBaseURL}public/vehicle_Documents/$documentPath';
                                                      var docName =
                                                          '$documentName${widget.vehicleDetails['vehicle_number']}.$fileExtension';
                                                      downloadFileOrPhoto(
                                                          url, docName);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            documentName,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          iconWidget,
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "View Documents",
                                    style: TextStyle(fontSize: 12),
                                  )),
                              Align(
                                alignment: const Alignment(012.0, -2),
                                heightFactor: 2,
                                widthFactor: 1.75,
                                child: FadeTransition(
                                  opacity: _animationController,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 6, left: 7, bottom: 7, right: 6),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ThemeColors.darkRedColor),
                                    child: const Text(
                                      "3",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),

        /// Desktop
        desktop: Container(
          padding:
              const EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 20),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              // color: ThemeColors.primaryColor.withOpacity(1),
              gradient: LinearGradient(
                  colors: [vehicleDetailsBGColor!, Colors.white]),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        spacing: 50,
                        runSpacing: 30,
                        children: [
                          // Action Dropdown
                          SizedBox(
                            width: 155,
                            child: SearchDropdownWidget(
                              borderColor: Colors.white,
                              textColor: true,
                              fillColor: Colors.transparent,
                              showSearchBox: false,
                              maxHeight: 250,
                              dropdownList: list,
                              hintText: 'Action',
                              onChanged: (String? newValue) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropDownValue = newValue!;
                                  dropDownValue == list.first
                                      ? activityStatus = 3
                                      : dropDownValue == list.elementAt(1)
                                          ? activityStatus = 4
                                          : dropDownValue == list.elementAt(2)
                                              ? activityStatus = 0
                                              : dropDownValue ==
                                                      list.elementAt(3)
                                                  ? activityStatus = 5
                                                  : activityStatus = 6;
                                });

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text(dropDownValue),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          dropDownValue == 'Reported' ||
                                                  dropDownValue == 'Unload'
                                              ? const SizedBox()
                                              : Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          dropDownValue ==
                                                                  'Send Empty'
                                                              ? 'Send Empty To'
                                                              : dropDownValue ==
                                                                      'Diverted'
                                                                  ? 'Diverted From'
                                                                  : 'Crossing From',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height: 35,
                                                          width: 300,
                                                          child: TextFormField(
                                                            controller:
                                                                fromLocation,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                            decoration:
                                                                UiDecoration()
                                                                    .outlineTextFieldDecoration(
                                                              "Enter From Location",
                                                              Colors.grey,
                                                            ),
                                                            onChanged: (value) {
                                                              placeAutocomplete(
                                                                  value);
                                                            },
                                                          ),
                                                        ),
                                                        placePrediction.isEmpty
                                                            ? const SizedBox()
                                                            : Expanded(
                                                                child: SizedBox(
                                                                  width: 300,
                                                                  child: ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount:
                                                                        placePrediction
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return LocationListTile(
                                                                        location:
                                                                            placePrediction[index].description!,
                                                                        press:
                                                                            () {},
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            dropDownValue ==
                                                                    'Send Empty'
                                                                ? 'Send Empty To'
                                                                : dropDownValue ==
                                                                        'Diverted'
                                                                    ? 'Diverted To'
                                                                    : 'Crossing To',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            // height: 35,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  toLocation,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                              decoration:
                                                                  UiDecoration()
                                                                      .outlineTextFieldDecoration(
                                                                "Enter To Location",
                                                                Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          const SizedBox(height: 10),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: SizedBox(
                                                  // height: 35,
                                                  child: TextFormField(
                                                    controller:
                                                        vehicleStatusRemark,
                                                    maxLines: 3,
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                    decoration: UiDecoration()
                                                        .outlineTextFieldDecoration(
                                                      "Enter Remark",
                                                      Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        TextDecorationClass()
                                                            .heading1('Date'),
                                                        const Text(
                                                          "  dd-mm-yyyy",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      ],
                                                    ),
                                                    DateFieldWidget2(
                                                        dayController:
                                                            dayControllerVehicleActivity,
                                                        monthController:
                                                            monthControllerVehicleActivity,
                                                        yearController:
                                                            yearControllerVehicleActivity,
                                                        dateControllerApi:
                                                            fromDate),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          // setState(() {
                                          //   dropDownValue =
                                          //       selectedDropDownValue;
                                          //   vehicleDetailsBGColor = activityStatus ==
                                          //           3
                                          //       ? ThemeColors.greenColor
                                          //       : activityStatus == 4
                                          //           ? Colors.grey.shade700
                                          //           : activityStatus == 0
                                          //               ? ThemeColors.redColor
                                          //               : activityStatus == 5
                                          //                   ? ThemeColors
                                          //                       .yellowColor
                                          //                   : activityStatus ==
                                          //                           6
                                          //                       ? ThemeColors
                                          //                           .orangeColor
                                          //                       : Colors
                                          //                           .lightBlueAccent;
                                          // });
                                          Navigator.pop(context, 'Cancel');
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          vehicleStatusApiFunc();
                                          setState(() {
                                            selectedDropDownValue =
                                                dropDownValue;
                                            vehicleDetailsBGColor = activityStatus ==
                                                    3
                                                ? ThemeColors.greenColor
                                                : activityStatus == 4
                                                    ? Colors.grey.shade700
                                                    : activityStatus == 0
                                                        ? ThemeColors.redColor
                                                        : activityStatus == 5
                                                            ? ThemeColors
                                                                .yellowColor
                                                            : activityStatus ==
                                                                    6
                                                                ? ThemeColors
                                                                    .orangeColor
                                                                : Colors
                                                                    .lightBlueAccent;
                                            vehicleStatusRemark.clear();
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              selectedItem: dropDownValue,
                            ),
                          ),
                          info("Company Name", "T & D GALIAKOT CONTAINERS"),
                          info(
                            "From City",
                            widget.vehicleDetails.containsKey('current')
                                ? widget.vehicleDetails['current']
                                        ['from_location']
                                    .toString()
                                : '-',
                          ),
                          info(
                              "To City",
                              widget.vehicleDetails.containsKey('current')
                                  ? widget.vehicleDetails['current']
                                          ['to_location']
                                      .toString()
                                  : '-'),
                          info(
                              "LR No.",
                              widget.vehicleDetails.containsKey('current')
                                  ? widget.vehicleDetails['current']
                                          ['lr_number']
                                      .toString()
                                  : '-'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Vehicle Number | Major Issue
                      Wrap(
                        runSpacing: 20,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              widget.vehicleDetails['vehicle_number']
                                  .toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          // Major Issue Button
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeColors.darkRedColor,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 21, horizontal: 10)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    titlePadding: const EdgeInsets.all(8),
                                    title: const Text("Major Issue"),
                                    contentPadding: const EdgeInsets.all(8),
                                    content: SingleChildScrollView(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: SizedBox(
                                              // height: 35,
                                              child: TextFormField(
                                                controller: majorIssueRemark,
                                                maxLines: 3,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                                decoration: UiDecoration()
                                                    .outlineTextFieldDecoration(
                                                  "Enter Remark",
                                                  Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    TextDecorationClass()
                                                        .heading1('Date'),
                                                    const Text(
                                                      "  dd-mm-yyyy",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                                DateFieldWidget2(
                                                    dayController:
                                                        dayControllerMajorIssue,
                                                    monthController:
                                                        monthControllerMajorIssue,
                                                    yearController:
                                                        yearControllerMajorIssue,
                                                    dateControllerApi:
                                                        fromDateApi),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          majorIssueApiFunc();
                                          dashboardHeaderApiFunc();
                                          setState(() {
                                            majorIssueRemark.clear();
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text(
                                "Major Issues",
                                style: TextStyle(fontSize: 15),
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          // Documents Button
                          Stack(
                            children: [
                              // View Documents
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 21, horizontal: 10)),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text("Documents"),
                                        content: SizedBox(
                                          width: 500,
                                          child: GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3),
                                            padding: const EdgeInsets.all(10),
                                            shrinkWrap: true,
                                            itemCount:
                                                widget.vehicleDocument!.length,
                                            itemBuilder: (context, index) {
                                              String documentName = widget
                                                  .vehicleDocument![index]
                                                      ['document_name']
                                                  .toString();
                                              String documentPath = widget
                                                  .vehicleDocument![index]
                                                      ['document_path']
                                                  .toString();

                                              // Get the file extension from the document path
                                              String fileExtension =
                                                  getFileExtension(
                                                      documentPath);

                                              // Determine which icon to display based on the file extension
                                              Widget iconWidget;
                                              if (fileExtension == 'png' ||
                                                  fileExtension == 'jpg' ||
                                                  fileExtension == 'jpeg' ||
                                                  fileExtension == 'img' ||
                                                  fileExtension == 'png...') {
                                                iconWidget = Image.asset(
                                                    'assets/download-image-icon.png',
                                                    height: 80);
                                              } else {
                                                iconWidget = Image.asset(
                                                    'assets/download-pdf-icon.png',
                                                    height: 80);
                                              }

                                              return Card(
                                                color: Colors.grey.shade300,
                                                child: InkWell(
                                                  onTap: () {
                                                    var url =
                                                        '${GlobalVariable.trafficBaseURL}public/vehicle_Documents/$documentPath';
                                                    var docName =
                                                        '$documentName${widget.vehicleDetails['vehicle_number']}.$fileExtension';
                                                    downloadFileOrPhoto(
                                                        url, docName);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          documentName,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        iconWidget,
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "View Documents",
                                    style: TextStyle(fontSize: 15),
                                  )),
                              Align(
                                alignment: const Alignment(012.0, -2),
                                heightFactor: 2,
                                widthFactor: 1.8,
                                child: FadeTransition(
                                  opacity: _animationController,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ThemeColors.darkRedColor),
                                    child: const Text(
                                      "3",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                  flex: 5,
                  child: Image.asset(
                    "assets/truck/1 (3).png",
                    scale: 0.8,
                  )),
            ],
          ),
        ));
  }

  void _showDateRangePicker() async {
    final initialDate = _dateRange?.start ?? DateTime.now();
    final dateRange = await showDateRangePicker(
        useRootNavigator: true,
        context: context,
        cancelText: 'CANCEL',
        confirmText: 'Confirm',
        firstDate: DateTime(1995),
        lastDate: DateTime(DateTime.now().year + 50),
        saveText: 'SUBMIT',
        initialDateRange:
            _dateRange ?? DateTimeRange(start: initialDate, end: initialDate),
        builder: (context, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: child,
                ),
              )
            ],
          );
        });

    if (dateRange != null) {
      setState(() {
        _dateRange = dateRange;
        final formattedStartDate =
            DateFormat('dd-MM-yyyy').format(dateRange.start);
        final formattedEndDate = DateFormat('dd-MM-yyyy').format(dateRange.end);

        // final formattedStartDate = DateFormat.yMd().format(dateRange.start);
        formattedStartDateApi =
            DateFormat('yyyy-MM-dd').format(dateRange.start);
        formattedEndDateApi = DateFormat('yyyy-MM-dd').format(dateRange.end);
        // final formattedEndDate = DateFormat.yMd().format(dateRange.end);
        dateRangeController.text = '$formattedStartDate to $formattedEndDate';
        vehicleRoutesList.clear();
        vehicleActivityApiFunc();
      });
    }
  }

  Future vehicleRoutesApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.trafficBaseURL}apis/getactivity?vehicle_id=${widget.vehicleId}&limit=10&page=${GlobalVariable.currentPage}&from_date=$formattedStartDateApi&to_date=$formattedEndDateApi&keyword=${searchRoutes.text}');
    var response = await http.get(url, headers: headers);
    // print(response.body.toString());
    return response.body.toString();
  }

  Future dashboardHeaderApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse('${GlobalVariable.trafficBaseURL}apis/DashboardHeader');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  Future majorIssue() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url =
        Uri.parse('${GlobalVariable.trafficBaseURL}apis/MejorIssueVehicle');
    var body = {
      'remark': majorIssueRemark.text,
      'entry_by': GlobalVariable.entryBy.toString(),
      'vehicle_id': widget.vehicleId.toString(),
      'date': fromDateApi.text.toString()
    };
    var response = await http.post(url, headers: headers, body: body);
    return response.body.toString();
  }

  Future vehicleStatus() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url =
        Uri.parse('${GlobalVariable.trafficBaseURL}Traffic/VehicleStatus');
    var body = {
      'remark': vehicleStatusRemark.text,
      'activities_status': activityStatus.toString(),
      'activities_id': widget.activityId.toString()
    };
    var response = await http.post(url, headers: headers, body: body);
    return response.body.toString();
  }

  downloadFileOrPhoto(String url, String fileName) {
    if (kIsWeb) {
      downloadFileOrPhotoWeb(url, fileName);
      print(kIsWeb);
    } else {
      downloadFileOrPhotoWindows(url, fileName, context);
    }
  }

  Future<void> downloadFileOrPhotoWindows(
      String url, String fileName, BuildContext context) async {
    Dio dio = Dio();
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String filePath = '${documentsDir.path}/$fileName';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        double downloadPercentage = 0.0;

        dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              downloadPercentage = (received / total) * 100;
            }
          },
        ).then((Response response) async {
          // After the download is completed, open the downloaded file.
          await OpenFile.open(filePath);
          Navigator.of(context).pop(); // Close the progress indicator dialog.
          print(fileName);
          print(response.statusCode);
        }).catchError((e) {
          Navigator.of(context).pop(); // Close the progress indicator dialog.
          print('Error occurred while downloading: $e');
        });

        return Dialog(
          child: Container(
            width: 500,
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                LinearProgressIndicator(
                  value: downloadPercentage / 100,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                SizedBox(height: 16.0),
                Text(
                  "Downloading $fileName...",
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  "${downloadPercentage.toStringAsFixed(2)}%",
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> downloadFileOrPhotoWeb(String url, String fileName) async {
    try {
      // Declare anchor as final
      final html.AnchorElement anchor = html.AnchorElement(href: url);
      anchor.download = fileName;
      // Trigger the download using JavaScript.
      anchor.click();
      // Show some feedback for the user
      print('Downloading $fileName...');
    } catch (e) {
      print('Error occurred while downloading: $e');
    } finally {
      // Revoke the object URL to avoid memory leaks
      html.Url.revokeObjectUrl(url);
      // Show some feedback for the user
      print('Download completed.');
    }
  }

  String getFileExtension(String filePath) {
    List<String> parts = filePath.split('.');
    return parts.isNotEmpty ? parts.last.toLowerCase() : '';
  }

  void setStateMounted(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}

class NetworkUtility {
  static Future<String?> fetchUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
