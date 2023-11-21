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

class Traffic extends StatefulWidget {
  const  Traffic({
    Key? key,
  }) : super(key: key);

  @override
  State<Traffic> createState() => _TrafficState();
}

class _TrafficState extends State<Traffic> {
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: ListTileTheme(
                  dense: true,
                  child: ExpansionTile(
                    initiallyExpanded: isExpanded,
                    backgroundColor:
                    getVehicleStatusColor('Diverted'.toLowerCase()),
                    collapsedBackgroundColor:
                    getVehicleStatusColor('Diverted'.toLowerCase()),
                    collapsedTextColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    childrenPadding: const EdgeInsets.all(0),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                              'MH20 CP 2058',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,

                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Reported'),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 0.5),
                        color: ThemeColors.whiteColor,
                        width: double.infinity,
                        alignment: Alignment.center,
                        height: 180,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text('Company Name :')),
                                  Expanded(
                                      flex: 2,
                                      child:
                                      Text('T & D Galiakot Containers')),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text('Driver Name :')),
                                  Expanded(
                                      flex: 2,
                                      child:
                                      Text('Babar Azam')),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text('From Location :')),
                                  Expanded(
                                      flex: 2, child: Text('Auranagabad')),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text('To Location :')),
                                  Expanded(flex: 2, child: Text('Mumbai')),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text('Major Issue Remarks :')),
                                  Expanded(

                                      flex: 2,
                                      child: Text('I dont know the Reason')),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Align(
                                alignment: Alignment.bottomRight ,
                                child: Padding(
                                  padding: const EdgeInsets.only(right:20),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ThemeColors.greenColor,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 18, horizontal: 10)),
                                    onPressed: () {
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
                                    child: Text('Resolve'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),

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
