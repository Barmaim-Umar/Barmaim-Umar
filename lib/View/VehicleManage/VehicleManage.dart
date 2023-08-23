import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/View/VehicleManage/DriverAssignHistory/DriverHistory.dart';
import 'package:pfc/View/VehicleManage/DriverTimeline/TimelinePostAndList.dart';
import 'package:pfc/View/VehicleManage/AssignDriver/AssignDriver.dart';
import 'package:pfc/View/VehicleManage/DriverGroup/DriverGroup.dart';
import 'package:pfc/View/VehicleManage/DriverList/DriversList.dart';
import 'package:pfc/View/VehicleManage/NewDriver/DriverDetails.dart';
import 'package:pfc/View/VehicleManage/VehicleDocUpdateAndHistory/VehicleDocUpdateAndHIstory.dart';
import 'package:pfc/View/VehicleManage/VehicleDocuments/VehicleDocument.dart';
import 'package:pfc/View/VehicleManage/VehicleInfo/VehicleInfo.dart';
import 'package:pfc/View/VehicleManage/CreateVehicle/ManageVehicle.dart';
import 'package:pfc/View/VehicleManage/VehicleDashboard/VehicleDashboard.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/CustomMenuButton.dart';
import 'package:pfc/utility/Widgets/NavigationMenuButton.dart';
import 'package:pfc/utility/Widgets/NavigationMenuWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class VehicleManage extends StatefulWidget {
  const VehicleManage({Key? key}) : super(key: key);

  @override
  State<VehicleManage> createState() => _VehicleManageState();
}

class _VehicleManageState extends State<VehicleManage> with Utility{

  // List buttonNames = [
  //   {
  //     'btn_name': 'Vehicle Dashboard',
  //     'class_name':const VehicleDashboard()
  //   },
  //   {
  //     'btn_name': 'Create Vehicle',
  //     'class_name':const ManageVehicle()
  //   },
  //   {
  //     'btn_name': 'Vehicle Info',
  //     'class_name':const VehicleInfo()
  //   },
  //   {
  //     'btn_name': 'Vehicle Documents',
  //     'class_name':const VehicleDocument()
  //   },
  //   {
  //     'btn_name': 'Assign Driver',
  //     'class_name':const AssignDriver()
  //   },
  //   {
  //     'btn_name': 'New Driver',
  //     'class_name':const DriverDetails()
  //   },
  //   {
  //     'btn_name': 'Driver List',
  //     'class_name':const DriversList()
  //   },
  //   {
  //     'btn_name': 'Driver Group',
  //     'class_name':const DriverGroup()
  //   },
  //   {
  //     'btn_name': 'Driver Timeline',
  //     'class_name':const TimelinePostAndList()
  //   },
  //   {
  //     'btn_name': 'Driver Assign History',
  //     'class_name':const DriverHistory()
  //   },
  // ];
  ///
  List buttonNames = [
    {
      'name':'Vehicle Dashboard',
      'values':[
        {
          'btn_name': 'Vehicle Dashboard',
          'class_name':const VehicleDashboard()
        },
      ]
    },
    {
      'name':'Vehicle Create / Details',
      'values':[
        {
          'btn_name': 'Create Vehicle',
          'class_name':const ManageVehicle()
        },
        {
          'btn_name': 'Vehicle Info',
          'class_name':const VehicleInfo()
        },
        {
          'btn_name': 'Vehicle Documents',
          'class_name':const VehicleDocument()
        },
      ]
    },
    {
      'name':'Vehicle Driver',
      'values':[
        {
          'btn_name': 'Assign Driver',
          'class_name':const AssignDriver()
        },
        {
          'btn_name': 'New Driver',
          'class_name':const DriverDetails()
        },
        {
          'btn_name': 'Driver List',
          'class_name':const DriversList()
        },
        {
          'btn_name': 'Driver Group',
          'class_name':const DriverGroup()
        },
        {
          'btn_name': 'Driver Timeline',
          'class_name':const TimelinePostAndList()
        },
        {
          'btn_name': 'Driver Assign History',
          'class_name':const DriverHistory()
        },
      ]
    }
  ];
  List vehicleList = [];
  bool showNavigationMenu = false;

  vehicleFetchApiFunc(){
    vehicleFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        vehicleList.clear();

        vehicleList.addAll(info['data']);

        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  int selectedIndex = 0;
  int page = 40;
  int freshLoad = 1;
  ScrollController controller = ScrollController();
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    vehicleFetchApiFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(height: 10,),

                  // Row(children: const [
                  //   Icon(Icons.manage_accounts, color: Colors.grey, size: 22),  SizedBox(width: 5,),
                  //   Text("Vehicle Manage" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
                  // ],),

                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: const [
                            Icon(Icons.manage_accounts, color: Colors.grey, size: 22),  SizedBox(width: 5,),
                            Text("Vehicle Manage" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
                          ],
                        ),
                      ),
                      NavigationMenuButton(
                        showNavigationMenu: showNavigationMenu,
                        onTap: () {
                          setState(() {
                            showNavigationMenu = !showNavigationMenu;
                          });
                        },
                        onEnter: (event) {
                          setState(() {
                            showNavigationMenu = true;
                          });
                          // _widget.showNavigationMenu();
                        },
                        onExit: (event) {
                          showNavigationMenu = false;
                          Future.delayed(
                            const Duration(milliseconds: 200),
                                () {
                              setState(() {
                                if (showNavigationMenu != true) {
                                  showNavigationMenu = false;
                                }
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // More button
                      // CustomMenuButton(buttonNames: buttonNames),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  /// Buttons
                  // SizedBox(
                  //   height: 50,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: SingleChildScrollView(
                  //           scrollDirection: Axis.horizontal,
                  //           child: Row(
                  //             children: [
                  //               // Home
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {});
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(isSelected: true),
                  //                   child: const Text("Home" ,style: TextStyle(color: Colors.white),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Vehicle Dashboard
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const VehicleDashboard(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Vehicle Dashboard" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Create Vehicle
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageVehicle(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Create Vehicle" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Vehicle Info
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const VehicleInfo(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Vehicle Info" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Vehicle Documents
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const VehicleDocument(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Vehicle Documents" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Assign Driver
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const AssignDriver(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Assign Driver" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // New Driver
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverDetails(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("New Driver" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Driver List
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const DriversList(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Driver List" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Driver Group
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverGroup(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Driver Group" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Driver Timeline
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const TimelinePostAndList(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Driver Timeline" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //               // Driver Assign History
                  //               ElevatedButton(
                  //                   onPressed: () {
                  //                     setState(() {
                  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverHistory(),));
                  //                     });
                  //                   },
                  //                   style: ButtonStyles.dashboardButton2(),
                  //                   child: Text("Driver Assign History" ,style: TextDecorationClass().dashboardBtn(),)
                  //               ),
                  //               const SizedBox(width: 10,),
                  //
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //
                  //       // More Button
                  //       CustomMenuButton(buttonNames: buttonNames),
                  //       const SizedBox(width: 10,),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 10,),

                  Row(
                    children: [
                      TextDecorationClass().heading1('Search : '),
                      SizedBox(width: 5,),
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: search,
                          decoration: UiDecoration().outlineTextFieldDecoration('Search', ThemeColors.primary),
                          onChanged: (value) {
                            vehicleFetchApiFunc();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  freshLoad==1 ? const CircularProgressIndicator():GridView.builder(
                    controller: controller,
                    shrinkWrap: true,
                    itemCount: vehicleList.length>page?page:vehicleList.length,
                    gridDelegate:  const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350,
                      mainAxisExtent: 160,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(7),
                        width: 307,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: Colors.grey.shade400)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset('assets/container-truck.png',width: 120),
                                TextDecorationClass().heading1(vehicleList[index]['vehicle_number'] ),
                                IconButton(
                                    alignment: Alignment.topRight,
                                    onPressed: (){
                                      setState(() {
                                        GlobalVariable.vehicleId = vehicleList[index]['vehicle_id'];
                                      });
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const VehicleDocUpdateAndHistory(),));
                                    }, icon: const Icon(Icons.arrow_forward,color: Colors.green,))
                              ],
                            ),
                            const Divider(thickness: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextDecorationClass().fieldTitleColor('Current Month',color: Colors.yellow),
                                TextDecorationClass().fieldTitle(vehicleList[index]['currentmonth'].toString())
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextDecorationClass().fieldTitleColor('Next Month',color: ThemeColors.greenColor),
                                TextDecorationClass().fieldTitle(vehicleList[index]['nextmonth'].toString())
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextDecorationClass().fieldTitle('Expired',color: ThemeColors.redColor),
                                TextDecorationClass().fieldTitle(vehicleList[index]['expired'].toString()),
                              ],
                            ),
                          ],
                        ),
                      );
                    },),

                  heightBox20(),

                  search.text.isNotEmpty||freshLoad==1?const SizedBox():InkWell(
                    onTap: () {
                      setState(() {
                        page = page +30;
                      });
                    },
                    child: Text('Show More',style: TextStyle(color: ThemeColors.primary,fontWeight: FontWeight.bold,fontSize: 17),),
                  )
                ],
              ),
            ),
            showNavigationMenu ? _showNavigationMenu() : const SizedBox()
          ],
        ),
      ),
    );
  }
  _showNavigationMenu() {
    return
      NavigationMenuWidget(buttonNames: buttonNames,
        onEnter: (p0) {
          setState(() {
            showNavigationMenu = true;
          });
        },
        onExit: (p0) {
          setState(() {
            showNavigationMenu = false;
          });
        },
      );
    //   Positioned(
    //   right: 20,
    //   top: 60,
    //   child: MouseRegion(
    //     onEnter: (event) {
    //       setState(() {
    //         showNavigationMenu = true;
    //       });
    //     },
    //     onExit: (event) {
    //       Future.delayed(
    //         const Duration(milliseconds: 200),
    //         () {
    //           setState(() {
    //             showNavigationMenu = false;
    //           });
    //         },
    //       );
    //     },
    //     child: AnimatedContainer(
    //       duration: const Duration(milliseconds: 1000),
    //       child: Container(
    //         padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
    //         width: 180 * double.parse(buttonNames.length.toString()), // 180 --> is the width of a single section
    //         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: ThemeColors.primary)),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             SizedBox(
    //               height: 400,
    //
    //               /// Horizontal ListView
    //               child: ListView.builder(
    //                 shrinkWrap: true,
    //                 itemCount: buttonNames.length,
    //                 scrollDirection: Axis.horizontal,
    //                 itemBuilder: (context, index) {
    //                   return MouseRegion(
    //                     onEnter: (event) {
    //                       currentIndex = index;
    //                     },
    //                     child: Container(
    //                       height: 300,
    //                       width: 180,
    //                       padding: const EdgeInsets.only(left: 7, top: 7),
    //                       decoration: BoxDecoration(color: index == 0 || index % 2 == 0 ? Colors.grey.shade100 : Colors.white, borderRadius: BorderRadius.circular(3)),
    //                       margin: const EdgeInsets.only(right: 5),
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           /// Section Name
    //                           ShaderMask(
    //                             shaderCallback: (bounds) {
    //                               return LinearGradient(colors: currentIndex == index ? [ThemeColors.primaryColor, ThemeColors.primaryColor] : [ThemeColors.primaryColor, ThemeColors.primaryColor])
    //                                   .createShader(bounds);
    //                             },
    //                             child: Text(
    //                               buttonNames[index]['name'],
    //                               style: TextStyle(
    //                                 color: ThemeColors.menuTextColor,
    //                                 fontWeight: currentIndex == index ? FontWeight.w400 : FontWeight.w400,
    //                                 fontSize: 17,
    //                               ),
    //                             ),
    //                           ),
    //                           const SizedBox(height: 5),
    //                           Expanded(
    //                             /// Vertical ListView
    //                             child: ListView.builder(
    //                               itemCount: buttonNames[index]['values'].length,
    //                               shrinkWrap: true,
    //                               itemBuilder: (context, index2) {
    //                                 return MouseRegion(
    //                                   onEnter: (event) {
    //                                     setState(() {
    //                                       currentIndex2 = index2;
    //                                       animatedHover = true;
    //                                     });
    //                                   },
    //                                   onExit: (event) {
    //                                     setState(() {
    //                                       animatedHover = false;
    //                                     });
    //                                   },
    //                                   child: AnimatedContainer(
    //                                     duration: const Duration(milliseconds: 100),
    //                                     margin: const EdgeInsets.symmetric(vertical: 2),
    //                                     decoration: BoxDecoration(
    //                                       boxShadow: [
    //                                         BoxShadow(
    //                                           color: currentIndex2 == index2 ? Colors.transparent : Colors.transparent,
    //                                         )
    //                                       ],
    //                                     ),
    //                                     child: InkWell(
    //                                       onTap: () {
    //                                         Navigator.push(
    //                                             context,
    //                                             MaterialPageRoute(
    //                                               builder: (context) => buttonNames[index]['values'][index2]['class_name'],
    //                                             ));
    //                                       },
    //                                       child: AnimatedDefaultTextStyle(
    //                                         style: TextStyle(
    //                                             color: currentIndex2 == index2 && currentIndex == index ? ThemeColors.primary : Colors.grey.shade700,
    //                                             fontWeight: currentIndex2 == index2 && currentIndex == index ? FontWeight.bold : FontWeight.w400,
    //                                             fontSize: 16),
    //                                         duration: const Duration(milliseconds: 100),
    //
    //                                         /// page names
    //                                         child: Text(buttonNames[index]['values'][index2]['btn_name']),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                 );
    //                               },
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   );
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Future vehicleFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Vehicle/VehicleFetch?keyword=${search.text}");
    var response = await http.get(url , headers: headers);
    // print(response.body.toString());
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }

}

