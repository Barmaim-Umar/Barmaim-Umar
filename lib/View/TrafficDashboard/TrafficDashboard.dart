import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/Provider/AnimationProvider.dart';
import 'package:pfc/View/TrafficDashboard/TrafficVehicleInfo.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:provider/provider.dart';

class TrafficDashboard extends StatefulWidget {
  const TrafficDashboard({Key? key}) : super(key: key);

  @override
  State<TrafficDashboard> createState() => _TrafficDashboardState();
}

class _TrafficDashboardState extends State<TrafficDashboard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  int iIndex = 0;
  late final TabController _tabController =
      TabController(length: 2, vsync: this, initialIndex: iIndex);
  TextEditingController search = TextEditingController();

  late ButtonProvider _buttonProvider;

  List normalVehicleList = [];
  List issueVehicleList = [];
  List vehicleRoutesList = [];
  Map vehicleDetailList = {};
  int freshLoad = 0;
  int freshLoad2 = 0;
  int? vehicleId;
  int? activityId;
  int? activityStatus;
  int currentPage = 1;
  int? totalPages;
  List vehicleDocument = [];
  bool loaderForVehicleInfo = false;

  normalVehicleListApiFunc() {
    // print('normalVehicle');
    setStateMounted(() {
      normalVehicleList.isEmpty ? freshLoad = 1 : freshLoad = 0;
      freshLoad2 = 1;
      // freshLoad =1;
    });
    normalVehicleApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        // normalVehicleList.clear();
        normalVehicleList.addAll(info['data']);
        totalPages = info['total_pages'];
        // print('CurrentPage:    $normalVehicleList');
        // print('object yyyyyyyNormal :    $normalVehicleList');
        setStateMounted(() {
          freshLoad = 0;
          freshLoad2 = 0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() {
          freshLoad = 0;
          freshLoad2 = 0;
        });
      }
    });
  }

  issueVehicleListApiFunc() {
    // print('issueVehicle');
    setStateMounted(() {
      freshLoad = 1;
    });
    normalVehicleApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        issueVehicleList.clear();
        issueVehicleList.addAll(info['data']);
        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() {
          freshLoad = 1;
        });
      }
      // print('object yyyyyyy888 :    $issueVehicleList');
    });
  }

  vehicleDetailsApiFunc() {

    setStateMounted(() {
      loaderForVehicleInfo = true;
      activityId = null;
      activityStatus = null;
      freshLoad = 1;
    });
    vehicleDetailsApi().then((value) {
      var info2 = jsonDecode(value);
      if (info2['success'] == true) {
        setStateMounted(() {
          loaderForVehicleInfo = false;
          GlobalVariable.currentPage = 1;
          vehicleDetailList.clear();
          vehicleRoutesList.clear();
          vehicleDetailList.addAll(info2['data']);
          // print('978546132546 vehicle:     $vehicleDetailList');
          // print('978546132546:     $info2');
          activityId = vehicleDetailList.containsKey('current')
              ? vehicleDetailList['current']['activity_id']
              : activityId;
          activityStatus = vehicleDetailList.containsKey('current')
              ? vehicleDetailList['current']['activity_status']
              : activityStatus;
          print("activity status :   $activityStatus");
          // print('978546132546 vehicle:     $vehicleDetailList');
          freshLoad = 0;
        });
      } else {
        // AlertBoxes.flushBarErrorMessage(info2['message'], context);
        setStateMounted(() {
          loaderForVehicleInfo = false;
          freshLoad = 1;
        });
      }
      print('978546132546 vehicle djf:     $vehicleDetailList');
    });
  }

  vehicleDocumentListApiFunc() {
    setStateMounted(() {
      freshLoad = 1;
    });
    documentListApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        vehicleDocument.clear();
        vehicleDocument.addAll(info['data']);
        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        // AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() {
          freshLoad = 0;
        });
      }
    });
  }

  @override
  void initState() {

    // print(" rfewrtfwre :  $activityId");
    setStateMounted(() {
      GlobalVariable.currentPage = 1;
    });
    normalVehicleListApiFunc();
    issueVehicleListApiFunc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buttonProvider = Provider.of<ButtonProvider>(context, listen: false);
      _buttonProvider.startJumping();
      // print('object yyyyyyy :    $normalVehicleList');
      // print('object yyyyyyy :    $issueVehicleList');
      // print('978546132546:     $vehicleDetailList');
    });

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
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
    return Scaffold(
      body: Responsive(
        /// Mobile
        mobile: mobileViewVehicle(),

        /// Tablet
        tablet: mobileViewVehicle(),

        /// Desktop
        desktop: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 1,
              ),

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
                            margin: const EdgeInsets.only(bottom: 0, top: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: ThemeColors.boxShadow,
                                      blurRadius: 5.0,
                                      spreadRadius: 3),
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child: TabBar(
                                      onTap: (value) {
                                        setStateMounted(() {
                                          iIndex = value;
                                        });
                                      },
                                      indicator: BoxDecoration(
                                          color: iIndex == 0
                                              ? ThemeColors.darkRedColor
                                              : ThemeColors.darkBlueColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      controller: _tabController,
                                      labelColor: Colors.white,
                                      unselectedLabelColor: Colors.grey,
                                      tabs: const [
                                        Tab(
                                          child: Text('Issue'),
                                        ),
                                        Tab(
                                          child: Text('Normal'),
                                        ),
                                      ]),
                                ),
                                // Search
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2, bottom: 2, left: 2),
                                  child: TextFormField(
                                    controller: search,
                                    onChanged: (value) {
                                      normalVehicleList.clear();
                                      currentPage = 1;
                                      iIndex == 0
                                          ? issueVehicleListApiFunc()
                                          : normalVehicleListApiFunc();
                                    },
                                    onFieldSubmitted: (value) {
                                      normalVehicleList.clear();
                                      currentPage = 1;
                                      iIndex == 0
                                          ? issueVehicleListApiFunc()
                                          : normalVehicleListApiFunc();
                                    },
                                    style: const TextStyle(fontSize: 15),
                                    decoration: UiDecoration()
                                        .outlineTextFieldDecoration(
                                            "Search", Colors.grey,
                                            icon: const Icon(
                                              CupertinoIcons.search,
                                              color: Colors.grey,
                                            )),
                                  ),
                                ),

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          // Issue Tab
                                          freshLoad == 1
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      issueVehicleList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 1,
                                                              bottom: 10,
                                                              right: 2),
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.red),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: ListTile(
                                                        onTap: () {
                                                          setStateMounted(() {
                                                            // vehicleId = null;
                                                            vehicleId =
                                                                issueVehicleList[
                                                                        index][
                                                                    'vehicle_id'];
                                                          });
                                                          vehicleDetailsApiFunc();
                                                          // vehicleActivityApiFunc();
                                                          vehicleDocumentListApiFunc();
                                                          print(
                                                              "  issue vehicle id $vehicleId");
                                                          // print('issueVehicleList:  $issueVehicleList');
                                                        },
                                                        mouseCursor:
                                                            SystemMouseCursors
                                                                .click,
                                                        title: Text(
                                                          issueVehicleList[
                                                                  index][
                                                              'vehicle_number'],
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip),
                                                        ),
                                                        subtitle: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    issueVehicleList[
                                                                            index]
                                                                        [
                                                                        'vehicle_number'],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    issueVehicleList[
                                                                            index]
                                                                        [
                                                                        'company'],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        trailing:
                                                            FadeTransition(
                                                                opacity:
                                                                    _animationController,
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .error_outline,
                                                                  color: Colors
                                                                      .red,
                                                                )),
                                                      ),
                                                    );
                                                  },
                                                ),

                                          // Normal Tab
                                          freshLoad == 1
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            normalVehicleList
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5,
                                                                    bottom: 5,
                                                                    right: 2),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black12),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: ListTile(
                                                              mouseCursor:
                                                                  SystemMouseCursors
                                                                      .click,
                                                              onTap: () {
                                                                setStateMounted(
                                                                    () {
                                                                  vehicleId = normalVehicleList[
                                                                          index]
                                                                      [
                                                                      'vehicle_id'];
                                                                });
                                                                vehicleDetailsApiFunc();
                                                                vehicleDocumentListApiFunc();
                                                                print(
                                                                    'activity id  $activityId');
                                                                // vehicleActivityApiFunc();
                                                                print(
                                                                    ' normal vehicle id  $vehicleId');
                                                              },
                                                              title: Text(
                                                                normalVehicleList[
                                                                        index][
                                                                    'vehicle_number'],
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              subtitle: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 3,
                                                                        child:
                                                                            Text(
                                                                          normalVehicleList[index]
                                                                              [
                                                                              'company'],
                                                                          style: const TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w500,
                                                                              overflow: TextOverflow.clip),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          normalVehicleList[index]
                                                                              [
                                                                              'company'],
                                                                          style: const TextStyle(
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.bold),
                                                                          textAlign:
                                                                              TextAlign.end,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing:
                                                                  const Icon(
                                                                Icons
                                                                    .arrow_right_sharp,
                                                                color: ThemeColors
                                                                    .darkBlack,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      currentPage == totalPages
                                                          ? const SizedBox()
                                                          : freshLoad2 == 1
                                                              ? const Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    setStateMounted(
                                                                        () {
                                                                      currentPage =
                                                                          currentPage +
                                                                              1;
                                                                    });
                                                                    // widget.routesListApiFunc;
                                                                    normalVehicleListApiFunc();
                                                                  },
                                                                  child: Text(
                                                                    'Show More',
                                                                    style: TextStyle(
                                                                        color: ThemeColors
                                                                            .darkBlueColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                ),
                                                      const SizedBox(height: 10)
                                                    ],
                                                  ),
                                                )
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          )),

                      const SizedBox(
                        width: 5,
                      ),

                      /// right panel
                      vehicleId == null
                          ? const Expanded(
                              flex: 7,
                              child: Center(
                                child: Text('Select Vehicle First'),
                              ))
                          : Expanded(
                              flex: 7,
                              child: loaderForVehicleInfo == true
                                  ? const Center(
                                      child: Text('Select Vehicle First'))
                                  : vehicleDetailList.isEmpty
                                      ? const Center(
                                          child: Text('Data Not Available'))
                                      : TrafficVehicleInfo(
                                          vehicleDetails: vehicleDetailList,
                                          vehicleId: vehicleId,
                                          activityId: activityId,
                                          activityStatus: activityStatus,
                                          vehicleDocument: vehicleDocument,
                                        )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  mobileViewVehicle() {
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Indicators
          Row(
            children: [
              // Late Delivery
              Expanded(
                child: Consumer<ButtonProvider>(
                  builder: (context, buttonProvider, child) {
                    return AnimatedContainer(
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
                    );
                  },
                ),
              ),

              // Late Loading
              Expanded(
                child: Consumer<ButtonProvider>(
                  builder: (context, buttonProvider, child) {
                    return AnimatedContainer(
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
                    );
                  },
                ),
              ),

              // Pending LR
              Expanded(
                child: Consumer<ButtonProvider>(
                  builder: (context, buttonProvider, child) {
                    return GestureDetector(
                      // onTap:() => buttonProvider.startJumping(),
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
                    );
                  },
                ),
              ),

              // Vehicle Without Driver
              Expanded(
                child: FormWidgets().containerWidget(
                    'Without Driver',
                    GlobalVariable.dashboardHeaders.isEmpty
                        ? '-'
                        : GlobalVariable.dashboardHeaders[0]['without_driver']
                            .toString(),
                    ThemeColors.primaryColor),
              ),

              // Vehicle in Maintenance
              Expanded(
                child: FormWidgets().containerWidget(
                    'In Maintenance',
                    GlobalVariable.dashboardHeaders.isEmpty
                        ? '-'
                        : GlobalVariable.dashboardHeaders[0]['maintanance']
                            .toString(),
                    ThemeColors.primaryColor),
              ),

              // Major Issue
              Expanded(
                child: Consumer<ButtonProvider>(
                  builder: (context, buttonProvider, child) {
                    return GestureDetector(
                      // onTap:() => buttonProvider.startJumping(),
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
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

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
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 0, top: 0),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: ThemeColors.boxShadow,
                                  blurRadius: 5.0,
                                  spreadRadius: 3),
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              child: TabBar(
                                  onTap: (value) {
                                    setStateMounted(() {
                                      iIndex = value;
                                    });
                                  },
                                  indicator: BoxDecoration(
                                      color: iIndex == 0
                                          ? ThemeColors.darkRedColor
                                          : ThemeColors.darkBlueColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  controller: _tabController,
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.grey,
                                  tabs: const [
                                    Tab(
                                      child: Text('Issue'),
                                    ),
                                    Tab(
                                      child: Text('Normal'),
                                    ),
                                  ]),
                            ),
                            // Search
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 2, bottom: 2, left: 2),
                              child: TextFormField(
                                controller: search,
                                onChanged: (value) {
                                  setStateMounted(() {
                                    normalVehicleList.clear();
                                    currentPage = 1;
                                    iIndex == 0
                                        ? issueVehicleListApiFunc()
                                        : normalVehicleListApiFunc();
                                  });
                                },
                                onFieldSubmitted: (value) {
                                  setStateMounted(() {
                                    normalVehicleList.clear();
                                    currentPage = 1;
                                    iIndex == 0
                                        ? issueVehicleListApiFunc()
                                        : normalVehicleListApiFunc();
                                  });
                                },
                                style: const TextStyle(fontSize: 15),
                                decoration: UiDecoration()
                                    .outlineTextFieldDecoration(
                                        "Search", Colors.grey,
                                        icon: const Icon(
                                          CupertinoIcons.search,
                                          color: Colors.grey,
                                        )),
                              ),
                            ),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      // Issue Tab
                                      freshLoad == 1
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  issueVehicleList.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 1,
                                                      bottom: 10,
                                                      right: 2),
                                                  decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                          color: Colors.red),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: ListTile(
                                                    mouseCursor:
                                                        SystemMouseCursors
                                                            .click,
                                                    onTap: () {
                                                      setStateMounted(() {
                                                        vehicleId =
                                                            issueVehicleList[
                                                                    index]
                                                                ['vehicle_id'];
                                                      });
                                                      // vehicleDetailsApiFunc();
                                                      // vehicleActivityApiFunc();
                                                    },
                                                    title: Text(
                                                      issueVehicleList[index]
                                                          ['vehicle_number'],
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          overflow: TextOverflow
                                                              .clip),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(
                                                                issueVehicleList[
                                                                        index]
                                                                    ['company'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                issueVehicleList[
                                                                        index]
                                                                    ['company'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),

                                      // Normal Tab
                                      freshLoad == 1
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: normalVehicleList
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            top: 5,
                                                            bottom: 5,
                                                            right: 2),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black12),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        child: ListTile(
                                                          mouseCursor:
                                                              SystemMouseCursors
                                                                  .click,
                                                          onTap: () {
                                                            setStateMounted(() {
                                                              vehicleId =
                                                                  normalVehicleList[
                                                                          index]
                                                                      [
                                                                      'vehicle_id'];
                                                            });
                                                            vehicleDetailsApiFunc();
                                                            vehicleDocumentListApiFunc();
                                                            activityId =
                                                                vehicleDetailList[
                                                                            'current']
                                                                        [index][
                                                                    'activity_id'];
                                                            print(' normal tab  $activityId');
                                                            // vehicleActivityApiFunc();
                                                          },
                                                          title: Text(
                                                            normalVehicleList[
                                                                    index][
                                                                'vehicle_number'],
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Text(
                                                                      normalVehicleList[
                                                                              index]
                                                                          [
                                                                          'company'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          overflow:
                                                                              TextOverflow.clip),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      normalVehicleList[
                                                                              index]
                                                                          [
                                                                          'company'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .end,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          trailing: const Icon(
                                                            Icons
                                                                .arrow_right_sharp,
                                                            color: ThemeColors
                                                                .darkBlack,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  currentPage == totalPages
                                                      ? const SizedBox()
                                                      : freshLoad2 == 1
                                                          ? const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                setStateMounted(
                                                                    () {
                                                                  currentPage =
                                                                      currentPage +
                                                                          1;
                                                                });
                                                                // widget.routesListApiFunc;
                                                                normalVehicleListApiFunc();
                                                              },
                                                              child: Text(
                                                                'Show More',
                                                                style: TextStyle(
                                                                    color: ThemeColors
                                                                        .darkBlueColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ),
                                                  const SizedBox(height: 10)
                                                ],
                                              ),
                                            )
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(
                    width: 5,
                  ),

                  /// right panel
                  vehicleId == null
                      ? const Expanded(
                          flex: 7,
                          child: Center(
                            child: Text('Select Vehicle First'),
                          ))
                      : Expanded(
                          flex: 7,
                          child: loaderForVehicleInfo == true
                              ? const Center(
                                  child: Text('Select Vehicle First'))
                              : vehicleDetailList.isEmpty
                                  ? const Center(
                                      child: Text('Data Not Available'))
                                  : TrafficVehicleInfo(
                                      vehicleDetails: vehicleDetailList,
                                      vehicleId: vehicleId,
                                      activityId: activityId,
                                      activityStatus: activityStatus,
                                      vehicleDocument: vehicleDocument,
                                    )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future normalVehicleApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.trafficBaseURL}apis/vehicleList?keyword=${search.text}&page=$currentPage&limit=15');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  Future issueVehicleApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.trafficBaseURL}apis/vehicleList?keyword=${search.text}');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  Future vehicleDetailsApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.trafficBaseURL}apis/VehicleDetails?vehicle_id=$vehicleId');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  Future documentListApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.baseURL}VehicleDocument/DocumentFetch?filter=$vehicleId');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
