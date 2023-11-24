import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:http/http.dart' as http;

class MajorIssuesVehicles extends StatefulWidget {
  const MajorIssuesVehicles({
    Key? key,
  }) : super(key: key);

  @override
  State<MajorIssuesVehicles> createState() => _MajorIssuesVehiclesState();
}

class _MajorIssuesVehiclesState extends State<MajorIssuesVehicles> {
  static bool isExpanded = false;
  List<String> cityName = [
    "Aberdeen",
    "Abilene",
    "Akron",
    "Albany",
    "kuch",
  ];
  TextEditingController resolvedIssueRemark = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController dayControllerResolvedIssue = TextEditingController(
      text: GlobalVariable.displayDate.day.toString().padLeft(2, '0'));
  TextEditingController monthControllerResolvedIssue = TextEditingController(
      text: GlobalVariable.displayDate.month.toString().padLeft(2, '0'));
  TextEditingController yearControllerResolvedIssue =
      TextEditingController(text: GlobalVariable.displayDate.year.toString());

  resolvedIssueApiFunc() {
    reolveIssue().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // print(screenSize.width);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.primaryColor,
          title: Text('Major Issue '),
        ),
        body: MasonryGridView.builder(
          itemCount: 5,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  screenSize.width <= 1000 && screenSize.width >= 825
                      ? 3
                      : screenSize.width <= 825
                          ? 2
                          : 4),
          itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: UiDecoration().vehicleInfoCardFunc(context,
                  onPressedButton:  () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          AlertDialog(
                            titlePadding: const EdgeInsets.all(8),
                            title: const Text("Resolve Issue"),
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
                                        controller:
                                        resolvedIssueRemark,
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
                                            dayControllerResolvedIssue,
                                            monthController:
                                            monthControllerResolvedIssue,
                                            yearController:
                                            yearControllerResolvedIssue,
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
                                onPressed: () => Navigator.pop(
                                    context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // resolvedIssueApiFunc();
                                  setState(() {
                                    resolvedIssueRemark.clear();
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                    );
                  },
                  vehicleNumber: 'MH20 CP 2058',
                  companyName: 'T & D Galiakot Containers',
                  LrNO: '56795',
                  vehicleStatus: 'Reported',
                  driverName: 'Babar Azam',
                  fromLocation: 'Auranagabad',
                  toLocation: 'Mumbai',
                  remarksName: 'Major Issue Remarks :',
                  majorIssueRemark: 'I dont know the Reason',
                  buttonName: 'Resolve',
                  backgroundColor:  getVehicleStatusColor('Diverted'.toLowerCase()),
                  collapsedBackgroundColor: getVehicleStatusColor('Diverted'.toLowerCase()),
                  collapsedTextColor: Colors.white,
                  collapsedIconColor: Colors.white)),
        ));
  }

  Color getVehicleStatusColor(String trafficVehicleStatus) {
    if (trafficVehicleStatus == 'unloaded') {
      return ThemeColors.unloadedVehicleGrey;
    } else if (trafficVehicleStatus == 'reported') {
      return ThemeColors.reportedVehicleGreen;
    } else if (trafficVehicleStatus == 'sendempty') {
      return ThemeColors.sendEmptyVehiclepink;
    } else if (trafficVehicleStatus == 'diverted') {
      return ThemeColors.divertedVehicleGreyorange;
    } else {
      return ThemeColors.crossingVehicleyellow;
    }
  }

  Future reolveIssue() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url =
        Uri.parse('${GlobalVariable.trafficBaseURL}apis/MejorIssueVehicle');
    var body = {
      'remark': resolvedIssueRemark.text,
      'entry_by': GlobalVariable.entryBy.toString(),
      // 'vehicle_id': widget.vehicleId.toString(),
      'vehicle_id': '',
      'date': fromDateApi.text.toString()
    };
    var response = await http.post(url, headers: headers, body: body);

    return response.body.toString();
  }
}