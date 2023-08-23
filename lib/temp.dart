import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/View/VehicleManage/NewDriver/DriverDetails.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/searchDataTable.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:http/http.dart' as http;
import 'package:pfc/utility/utility.dart';

class DriversList extends StatefulWidget {
  const DriversList({Key? key}) : super(key: key);

  @override
  State<DriversList> createState() => _DriversListState();
}

List<String> assignDropdownList = ['Assign' , 'Not Assign' , 'Assign/Not Assign'];
List<String> entriesDropdownList = ["10" ,"20" ,"30" ,"40"];

class _DriversListState extends State<DriversList> with Utility{

  List driverColumnName = [
    {
      'column_name': 'ID No',
      'column_value':'vehicles__drivers_profile.driver_id',
    },
    {
      'column_name': 'Photo',
      'column_value': 'vehicles__drivers_profile.driver_id'
    },
    {
      'column_name':'Driver Name',
      'column_value':'vehicles__drivers_profile.driver_name'

    },
    {
      'column_name': 'Contact Number',
      'column_value':'vehicles__drivers_profile.driver_mobile_number'
    },
    {
      'column_name': 'Guarantor',
      'column_value': 'vehicles__drivers_guarantee.guarantor_name'
    },
    {
      'column_name': 'Licence Number',
      'column_value':'vehicles__drivers_profile.driver_license_number'
    },
    {
      'column_name': 'Licence Expiry',
      'column_value': 'vehicles__drivers_profile.driver_license_validity_to'
    },
    {
      'column_name': 'Vehicle Number',
      'column_value': 'vehicles.vehicle_number'
    },
    {
      'column_name': 'Group',
      'column_value': 'vehicles__drivers_group.drivers_group_id'
    },
    {
      'column_name': 'Action',
      'column_value': 'vehicles__drivers_group.drivers_group_id'
    }
  ];

  String assignDropdownValue = assignDropdownList.first;
  String entriesDropdownValue = entriesDropdownList.first;

  TextEditingController searchController = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  bool search = false;
  bool search2 = false;
  bool search3 = false;
  bool search4 = false;
  bool search5 = false;
  bool search6 = false;
  bool search7 = false;
  bool search8 = false;
  int currentIndex = -1;
  var keyword;
  int currentPage = 1;
  int freshLoad = 0;
  var vehicleId;
  var next;
  var prev;
  var totalPages;
  var driverId;
  List driverList = [];

  driverListApiFunc() {
    driverList.clear();
    setStateMounted(() {
      freshLoad = 1;
    });
    driverListApi().then((source) {
      var info = jsonDecode(source);
      if (info['success'] == true) {
        driverList.addAll(info['data']);
        setStateMounted(() {
          freshLoad = 0;
          currentPage = info['page'];
          prev = info['prev'];
          next = info['next'];
          totalPages = info['total_pages'];
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setState(() {
          freshLoad = 1;
        });
      }
    });
  }

  driverDeleteApiFunc() {
    driverDeleteApi().then((source) {
      var info = jsonDecode(source);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  driverEditApiFunc() {
    driverEditApi().then((value) {
      var info = jsonDecode(value);
      if(info['success']==true){

      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    driverListApiFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar('Driver List'),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10,right: 10),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  // Dropdown
                  UiDecoration().dropDown(1, DropdownButton<String>(
                    borderRadius: BorderRadius.circular(5),
                    dropdownColor: ThemeColors.whiteColor,
                    underline: Container(
                      decoration: const BoxDecoration(border: Border()),
                    ),
                    isExpanded: true,
                    hint: const Text(
                      'Assign',
                      style: TextStyle(color: ThemeColors.darkBlack),
                    ),
                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      color: ThemeColors.darkBlack,
                      size: 15,
                    ),
                    iconSize: 30,
                    value: assignDropdownValue,
                    elevation: 16,
                    style: TextDecorationClass().dropDownText(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        assignDropdownValue = newValue!;
                      });
                    },
                    items: assignDropdownList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Center(child: Text(value)),
                      );
                    }).toList(),
                  ),),
                  widthBox20(),

                  // from Date
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: TextFormField(
                        readOnly: true,
                        controller: fromDate,
                        decoration: UiDecoration().dateFieldDecoration('From Date'),
                        onTap: () {
                          UiDecoration()
                              .showDatePickerDecoration(context)
                              .then((value) {
                            setState(() {
                              String month = value.month.toString().padLeft(2, '0');
                              String day = value.day.toString().padLeft(2, '0');
                              fromDate.text = "${value.year}-$month-$day";
                            });
                          });
                        },
                      ),
                    ),
                  ),
                  widthBox10(),

                  // to Date
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: TextFormField(
                        readOnly: true,
                        controller: toDate,
                        decoration: UiDecoration().dateFieldDecoration('To Date'),
                        onTap: () {
                          UiDecoration()
                              .showDatePickerDecoration(context)
                              .then((value) {
                            setState(() {
                              String month = value.month.toString().padLeft(2, '0');
                              String day = value.day.toString().padLeft(2, '0');
                              toDate.text = "${value.year}-$month-$day";
                            });
                          });
                        },
                      ),
                    ),
                  ),
                  widthBox10(),

                  // filter button
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(ThemeColors.primaryColor,
                        ThemeColors.whiteColor, 100.0, 42.0),
                    onPressed: () {
                      driverListApiFunc();
                      setState(() {
                        fromDate.text = '';
                        toDate.text = '';
                      });
                    },
                    child: const Text("Filter"),
                  ),
                ],
              ),
            ),
            const Divider(),

            // dropdown & search
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text('Show '),

                  // dropdown
                  Container(
                    height: 30,
                    width: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade400)),
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(5),
                      dropdownColor: ThemeColors.whiteColor,
                      underline: Container(
                        decoration: const BoxDecoration(border: Border()),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Entries',
                        style: TextStyle(color: ThemeColors.darkBlack),
                      ),
                      icon: const Icon(
                        CupertinoIcons.chevron_down,
                        color: ThemeColors.darkBlack,
                        size: 20,
                      ),
                      iconSize: 30,
                      value: entriesDropdownValue,
                      elevation: 16,
                      style: TextDecorationClass().dropDownText(),
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          entriesDropdownValue = newValue!;
                          driverListApiFunc();
                        });
                      },
                      items: entriesDropdownList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const Text(' entries'),

                  const Spacer(flex: 3),

                  // Search
                  const Text('Search: '),
                  Expanded(child: TextFormField(
                    controller: searchController,
                    onFieldSubmitted: (value) {
                      driverListApiFunc();
                    },
                    decoration: UiDecoration().outlineTextFieldDecoration('Search', ThemeColors.primary),
                  )),
                ],
              ),
            ),

            const Divider(),

            // buttons
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Wrap(
                runSpacing: 5,
                // spacing: 0,
                children: [
                  BStyles().button('CSV', 'Export to CSV', "assets/csv2.png"),
                  const SizedBox(
                    width: 10,
                  ),
                  BStyles().button('Excel', 'Export to Excel', "assets/excel.png"),
                  const SizedBox(
                    width: 10,
                  ),
                  BStyles().button('PDF', 'Export to PDF', "assets/pdf.png"),
                  const SizedBox(
                    width: 10,
                  ),
                  BStyles().button('Print', 'Print', "assets/print.png"),
                ],
              ),
            ),

            const SizedBox(height: 10,),

            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        freshLoad==1?const Center(child: CircularProgressIndicator()):ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child:
                            // FutureBuilder(
                            //   future: driverListApi(),
                            //   builder: (context, snapshot) {
                            //   if(snapshot.hasError){
                            //     return Center(
                            //       child: TextDecoration().subHeading('Try Again'),
                            //     );
                            //   }
                            //   else if(snapshot.hasData){
                            //     var info = jsonDecode(snapshot.data);
                            //     if(info['success']==false){
                            //       return Text(info['message'].toString());
                            //     }
                            //     return DataTable(
                            //       columns: const [
                            //         DataColumn(label: Text('ID No.')),
                            //         DataColumn(label: Text('Photo')),
                            //         DataColumn(label: Text('Driver Name')),
                            //         DataColumn(label: Text('Contact Number')),
                            //         DataColumn(label: Text('Guarantor')),
                            //         DataColumn(label: Text('License No.')),
                            //         DataColumn(label: Text('License Expiry')),
                            //         DataColumn(label: Text('Vehicle')),
                            //         DataColumn(label: Text('Group')),
                            //         DataColumn(label: Text('Action')),
                            //       ],
                            //       rows: List.generate(driverList.length, (index) => DataRow(
                            //         color: index==0||index%2==0?MaterialStatePropertyAll(Colors.grey.shade400):MaterialStatePropertyAll(Colors.white),
                            //         cells: [
                            //           DataCell(Text(driverList[index]['driver_id'].toString())),
                            //           DataCell(driverList[index]['driver_photo']==''?Text('No Image Found'):CachedNetworkImage(
                            //               imageUrl: 'http://192.168.5.103:3000/public/Driver_Profile/'+ driverList[index]['driver_photo'],
                            //             errorWidget: (context, url, error) =>  Icon(Icons.error,color: Colors.grey,),
                            //             placeholder: (context, url) =>  Text('Image Not Found'),
                            //           ),
                            //           ),
                            //           DataCell(Text(driverList[index]['driver_name'].toString())),
                            //           DataCell(Text(driverList[index]['driver_mobile_number'].toString())),
                            //           DataCell(Text(driverList[index]['guarantor_name'].toString())),
                            //           DataCell(Text(driverList[index]['driver_license_number'])),
                            //           DataCell(Text(driverList[index]['driver_license_validity_to'])),
                            //           DataCell(Text(driverList[index]['vehicle_number'].toString())),
                            //           DataCell(Text(driverList[index]['drivers_group_id'].toString())),
                            //           DataCell(Column(
                            //             mainAxisAlignment: MainAxisAlignment.center,
                            //             children: [
                            //
                            //               Row(
                            //                 crossAxisAlignment: CrossAxisAlignment.center,
                            //                 children: [
                            //                   UiDecoration().actionButton(
                            //                       ThemeColors.editColor,
                            //                       IconButton(
                            //                           padding: const EdgeInsets.all(0),
                            //                           onPressed: () {
                            //                             setState(() {
                            //                               driverId = driverList[index]['driver_id'];
                            //                               GlobalVariable.driverId = driverList[index]['driver_id'];
                            //                               print(GlobalVariable.driverId);
                            //                               GlobalVariable.driverGroupId = driverList[index]['drivers_group_id'];
                            //                               print(GlobalVariable.driverGroupId);
                            //                               GlobalVariable.edit = true;
                            //                               Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverDetails(),));
                            //                             });
                            //                           },
                            //                           icon: const Icon(
                            //                             Icons.edit,
                            //                             size: 15,
                            //                             color: Colors.white,
                            //                           ))),
                            //                   UiDecoration().actionButton(
                            //                       ThemeColors.deleteColor,
                            //                       IconButton(
                            //                           padding: const EdgeInsets.all(0),
                            //                           onPressed: () {
                            //                             showDialog(
                            //                               context: context,
                            //                               builder: (context) {
                            //                                 return AlertDialog(
                            //                                   title: const Text(
                            //                                       "Are you sure you want to delete"),
                            //                                   actions: [
                            //                                     TextButton(
                            //                                         onPressed: () {
                            //                                           Navigator.pop(
                            //                                               context);
                            //                                         },
                            //                                         child: const Text(
                            //                                             "Cancel")),
                            //                                     TextButton(
                            //                                         onPressed: () {
                            //                                           setState(() {
                            //                                             driverId = driverList[index]['driver_id'];
                            //                                             print(driverId);
                            //                                             driverDeleteApiFunc();
                            //                                             driverListApiFunc();
                            //                                           });
                            //                                           Navigator.pop(
                            //                                               context);
                            //                                         },
                            //                                         child: const Text(
                            //                                             "Delete"))
                            //                                   ],
                            //                                 );
                            //                               },
                            //                             );
                            //                           },
                            //                           icon: const Icon(
                            //                             Icons.delete,
                            //                             size: 15,
                            //                             color: Colors.white,
                            //                           ))),
                            //                   // Print Icon
                            //                   Container(
                            //                       height: 20,
                            //                       width: 20,
                            //                       margin: const EdgeInsets.all(1),
                            //                       decoration: BoxDecoration(color: ThemeColors.darkBlueColor, borderRadius: BorderRadius.circular(5)),
                            //                       child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.print, size: 15, color: Colors.white,))),
                            //                 ],
                            //               ),
                            //               Row(
                            //                 children: [
                            //                   // ViewDocuments Icon
                            //                   Container(
                            //                       height: 20,
                            //                       width:20,
                            //                       margin: const EdgeInsets.all(1),
                            //                       decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                            //                       child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.contact_page_outlined, size: 15, color: Colors.white,))),
                            //                   // Driver Time Line Icon
                            //                   Container(
                            //                       height: 20,
                            //                       width: 20,
                            //                       margin: const EdgeInsets.all(1),
                            //                       decoration: BoxDecoration(color: ThemeColors.yellowColor, borderRadius: BorderRadius.circular(5)),
                            //                       child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.timeline, size: 15, color: Colors.white,))),
                            //                   // Driver History Icon
                            //                   Container(
                            //                       height: 20,
                            //                       width: 20,
                            //                       margin: const EdgeInsets.all(1),
                            //                       decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                            //                       child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.history_rounded, size: 15, color: Colors.white,))),
                            //                 ],
                            //               ),
                            //
                            //             ],
                            //           )),
                            //
                            //         ],
                            //       )),
                            //       showCheckboxColumn: false,
                            //       sortAscending: true,
                            //       sortColumnIndex: 0,
                            //     );
                            //   }
                            //   else{
                            //     return Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: const[
                            //         CircularProgressIndicator(),
                            //       ],
                            //     );
                            //   }
                            // },)

                            DataTable(
                              columns:List.generate(driverColumnName.length, (index) =>
                                  DataColumn(label: InkWell(
                                    focusColor: Colors.white,
                                    hoverColor: Colors.white,
                                    onTap: () {
                                      setState(() {
                                        currentIndex = index;
                                        keyword = driverColumnName[index]['column_value'];
                                      });
                                    }, child: SearchDataTable(
                                      onFieldSubmitted: (p0) {
                                        driverListApiFunc();
                                      },
                                      isSelected: index==9||index==1?false:index == currentIndex ,
                                      search: searchController,
                                      columnName: driverColumnName[index]['column_name']),
                                  ),
                                  ),
                              ),
                              // [
                              //   DataColumn(label: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       search==false?const SizedBox():UiDecoration().search(searchController,onFieldSubmitted: (p0) {
                              //         driverListApiFunc();
                              //       },),
                              //       InkWell(onTap: () {
                              //         setState(() {
                              //         search = !search;
                              //         keyword = 'vehicles__drivers_profile.driver_id';
                              //         });
                              //       }, child: Text('ID No.')),
                              //     ],
                              //   )),
                              //   DataColumn(label: Text('Photo')),
                              //   DataColumn(label: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       search2==false?const SizedBox():UiDecoration().search(searchController,onFieldSubmitted: (p0) {
                              //         driverListApiFunc();
                              //       },),
                              //       InkWell(onTap: () {
                              //         setState(() {
                              //         search = false;
                              //         search2 = !search2;
                              //         keyword = 'vehicles__drivers_profile.driver_name';
                              //         });
                              //       }, child: Text('Driver Name')),
                              //     ],
                              //   )),
                              //   DataColumn(label: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       search3==false?const SizedBox():UiDecoration().search(searchController,onFieldSubmitted: (p0) {
                              //         driverListApiFunc();
                              //       },),
                              //       InkWell(onTap: () {
                              //         setState(() {
                              //         search = false;
                              //         search2 = false;
                              //         search3 = !search3;
                              //         keyword = 'vehicles__drivers_profile.driver_mobile_number';
                              //         });
                              //       }, child: Text('Contact Number')),
                              //     ],
                              //   )),
                              //   DataColumn(label: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       search4==false?const SizedBox():UiDecoration().search(searchController,onFieldSubmitted: (p0) {
                              //         driverListApiFunc();
                              //       },),
                              //       InkWell(onTap: () {
                              //         setState(() {
                              //         search = false;
                              //         search2 = false;
                              //         search3 = false;
                              //         search4 = !search4;
                              //         keyword = 'vehicles__drivers_guarantee.guarantor_name';
                              //         });
                              //       }, child: Text('Guarantor')),
                              //     ],
                              //   )),
                              //   DataColumn(label: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       search5==false?const SizedBox():UiDecoration().search(searchController,onFieldSubmitted: (p0) {
                              //         driverListApiFunc();
                              //       },),
                              //       InkWell(onTap: () {
                              //         setState(() {
                              //         search = false;
                              //         search2 = false;
                              //         search3 = false;
                              //         search4 = false;
                              //         search5 = !search5;
                              //         keyword = 'vehicles__drivers_profile.driver_license_number';
                              //         });
                              //       }, child: Text('License No')),
                              //     ],
                              //   )),
                              //   DataColumn(label: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       search6==false?const SizedBox():UiDecoration().search(searchController,onFieldSubmitted: (p0) {
                              //         driverListApiFunc();
                              //       },),
                              //       InkWell(onTap: () {
                              //         setState(() {
                              //         search = false;
                              //         search2 = false;
                              //         search3 = false;
                              //         search4 = false;
                              //         search5 = false;
                              //         search6 = !search6;
                              //         keyword = 'vehicles__drivers_profile.driver_license_validity_to';
                              //         });
                              //       }, child: Text('License Expiry')),
                              //     ],
                              //   )),
                              //   DataColumn(label: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       search7==false?const SizedBox():UiDecoration().search(searchController,onFieldSubmitted: (p0) {
                              //         driverListApiFunc();
                              //       },),
                              //       InkWell(onTap: () {
                              //         setState(() {
                              //         search = false;
                              //         search2 = false;
                              //         search3 = false;
                              //         search4 = false;
                              //         search5 = false;
                              //         search6 = false;
                              //         search7 = !search7;
                              //         keyword = 'vehicles.vehicle_number';
                              //         });
                              //       }, child: Text('Vehicle')),
                              //     ],
                              //   )),
                              //   DataColumn(label: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       search8==false?const SizedBox():UiDecoration().search(searchController,onFieldSubmitted: (p0) {
                              //         driverListApiFunc();
                              //       },),
                              //       InkWell(onTap: () {
                              //         setState(() {
                              //         search = false;
                              //         search2 = false;
                              //         search3 = false;
                              //         search4 = false;
                              //         search5 = false;
                              //         search6 = false;
                              //         search7 = false;
                              //         search8 = !search8;
                              //         keyword = 'vehicles__drivers_group.drivers_group_id';
                              //         });
                              //       }, child: Text('Group')),
                              //     ],
                              //   )),
                              //   DataColumn(label: Text('Action')),
                              // ],
                              rows: List.generate(driverList.length, (index) => DataRow(
                                color: index==0||index%2==0?MaterialStatePropertyAll(Colors.grey.shade400):const MaterialStatePropertyAll(Colors.white),
                                cells: [
                                  DataCell(Text(driverList[index]['driver_id'].toString())),
                                  DataCell(driverList[index]['driver_photo']==''?const Text('No Image Found'):
                                  CachedNetworkImage(
                                    width: 50,
                                    imageUrl: 'http://192.168.5.103:3000/public/Driver_Profile/${driverList[index]['driver_photo']}',
                                    errorWidget: (context, url, error) =>  const Icon(Icons.error,color: Colors.grey,),
                                    placeholder: (context, url) =>  const Text('Image Not Found'),
                                  ),
                                  ),
                                  DataCell(Text(driverList[index]['driver_name'].toString())),
                                  DataCell(Text(driverList[index]['driver_mobile_number'].toString())),
                                  DataCell(Text(driverList[index]['guarantor_name'].toString())),
                                  DataCell(Text(driverList[index]['driver_license_number'])),
                                  DataCell(Text(driverList[index]['driver_license_validity_to'])),
                                  DataCell(Text(driverList[index]['vehicle_number'].toString())),
                                  DataCell(Text(driverList[index]['drivers_group_id'].toString())),
                                  DataCell(Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          UiDecoration().actionButton(
                                              ThemeColors.editColor,
                                              IconButton(
                                                  padding: const EdgeInsets.all(0),
                                                  onPressed: () {
                                                    setState(() {
                                                      driverId = driverList[index]['driver_id'];
                                                      GlobalVariable.driverId = driverList[index]['driver_id'];
                                                      GlobalVariable.driverGroupId = driverList[index]['drivers_group_id'];
                                                      GlobalVariable.edit = true;
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverDetails(),));
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ))),
                                          UiDecoration().actionButton(
                                              ThemeColors.deleteColor,
                                              IconButton(
                                                  padding: const EdgeInsets.all(0),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Are you sure you want to delete"),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    "Cancel")),
                                                            TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    driverId = driverList[index]['driver_id'];
                                                                    driverDeleteApiFunc();
                                                                    driverListApiFunc();
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    "Delete"))
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ))),
                                          // Print Icon
                                          Container(
                                              height: 20,
                                              width: 20,
                                              margin: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(color: ThemeColors.darkBlueColor, borderRadius: BorderRadius.circular(5)),
                                              child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.print, size: 15, color: Colors.white,))),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // ViewDocuments Icon
                                          Container(
                                              height: 20,
                                              width:20,
                                              margin: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                                              child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.contact_page_outlined, size: 15, color: Colors.white,))),
                                          // Driver Time Line Icon
                                          Container(
                                              height: 20,
                                              width: 20,
                                              margin: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(color: ThemeColors.yellowColor, borderRadius: BorderRadius.circular(5)),
                                              child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.timeline, size: 15, color: Colors.white,))),
                                          // Driver History Icon
                                          Container(
                                              height: 20,
                                              width: 20,
                                              margin: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                                              child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.history_rounded, size: 15, color: Colors.white,))),
                                        ],
                                      ),

                                    ],
                                  )),

                                ],
                              )),
                              showCheckboxColumn: false,
                              sortAscending: true,
                              sortColumnIndex: 0,
                            ),
                          ),
                        ),
                      ],
                    ))),
            Row(
              children: [
                /// Prev Button
                Row(
                  children: [
                    const SizedBox(
                      width: 3,
                    ),
                    prev == true
                        ? InkWell(
                        onTap: () {
                          setState(() {
                            currentPage = 1;
                            driverListApiFunc();
                          });
                        },
                        child: const Text(
                          'First Page',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ))
                        : const SizedBox(),
                    const SizedBox(width: 10),
                    prev == true
                        ? Text(
                      'Prev',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade700),
                    )
                        : const SizedBox(),
                    IconButton(
                        onPressed: prev == false
                            ? null
                            : () {
                          setState(() {
                            currentPage > 1
                                ? currentPage--
                                : currentPage = 1;
                            driverListApiFunc();
                          });
                        },
                        icon: const Icon(Icons.chevron_left)),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),

                /// Next Button
                Row(
                  children: [
                    IconButton(
                      onPressed: next == false
                          ? null
                          : () {
                        setState(() {
                          currentPage++;
                          driverListApiFunc();
                        });
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                    next == true
                        ? Text(
                      'Next',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade700),
                    )
                        : const SizedBox(),
                    const SizedBox(
                      width: 10,
                    ),
                    next == true
                        ? InkWell(
                        onTap: () {
                          setState(() {
                            currentPage = totalPages;
                            driverListApiFunc();
                          });
                        },
                        child: const Text(
                          'Last Page',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ))
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future driverListApi() async{
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}VehicleDriver/ProfileList?limit=${int.parse(entriesDropdownValue)}&page=$currentPage&from_date=${fromDate.text}&to_date=${toDate.text}&keyword=${searchController.text}&column=$keyword');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  Future driverDeleteApi() async{
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}VehicleDriver/ProfileDelete?driver_id=$driverId');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  Future driverEditApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}VehicleDriver/ProfileEdit?driver_id=$driverId');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }

}
