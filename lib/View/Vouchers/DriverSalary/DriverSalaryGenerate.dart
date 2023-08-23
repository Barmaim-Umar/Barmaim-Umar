import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class DriverSalaryGenerate extends StatefulWidget {
  const DriverSalaryGenerate({Key? key}) : super(key: key);

  @override
  State<DriverSalaryGenerate> createState() => _DriverSalaryGenerateState();
}

List<String> vehicle = ["Select Vehicle" , "Vehicle1" , "Vehicle2" , "Vehicle3"];
List<String> driver = ["Select Driver" , "Unloaded" , "OnRoad" , "Empty"];
List<String> entriesList = ["10" ,"20" , "30" , "40"];


class _DriverSalaryGenerateState extends State<DriverSalaryGenerate> with Utility{



  final DataTableSource _data = MyData();

  TextDecorationClass textDecoration = TextDecorationClass();
  String vehicleValue = vehicle.first;
  String driverValue = driver.first;
  String entriesDropdownValue = entriesList.first;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController entryDate = TextEditingController();
  TextEditingController driverSalary = TextEditingController();
  TextEditingController deduction = TextEditingController();
  TextEditingController total = TextEditingController();
  TextEditingController search = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  TextEditingController dayControllerEntry = TextEditingController();
  TextEditingController monthControllerEntry = TextEditingController();
  TextEditingController yearControllerEntry = TextEditingController();
  TextEditingController entryDateApi = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar('Driver Salary Generate/List'),
      body: Responsive(
        mobile: Column(
          children: [
            salaryGenerateForm(),
            heightBox20(),
            salaryList()
          ],
        ),
        tablet: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: salaryGenerateForm(),),
            widthBox20(),
            Expanded(flex: 1, child: salaryList(),),
          ],
        ),
        desktop: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: salaryGenerateForm(),),
            widthBox20(),
            Expanded(flex: 3, child: salaryList(),),
          ],
        ),
      ),
    );
  }


  salaryGenerateForm(){
    return  Container(
      margin: const EdgeInsets.only(top: 10,left: 10),
      height: 550,
      decoration: UiDecoration().formDecoration(),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child:
                textDecoration.heading('Driver Salary Generate'),
              ),
            ),
            const Divider(),
            /// form
            Expanded(
              flex: 0,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 8 , left: 8, bottom: 8 ,right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FormWidgets().formDetails2('Vehicle',DropdownDecoration().dropdownDecoration(DropdownButton<String>(
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: ThemeColors.dropdownColor,
                        underline: Container(
                          decoration: const BoxDecoration(border: Border()),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Select Vehicle',
                          style: TextStyle(color: ThemeColors.dropdownTextColor),
                        ),
                        icon: DropdownDecoration().dropdownIcon(),
                        value: vehicleValue,
                        elevation: 16,
                        style: DropdownDecoration().dropdownTextStyle(),
                        onChanged: (String? newValue) {
                          // This is called when the user selects an item.
                          setState(() {
                            vehicleValue = newValue!;
                          });
                        },
                        items: vehicle.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(value),
                          );
                        }).toList(),
                      ))),
                      FormWidgets().formDetails2('Driver',DropdownDecoration().dropdownDecoration(DropdownButton<String>(
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: ThemeColors.dropdownColor,
                        underline: Container(
                          decoration: const BoxDecoration(border: Border()),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Select Driver',
                          style: TextStyle(color: ThemeColors.dropdownTextColor),
                        ),
                        icon: DropdownDecoration().dropdownIcon(),
                        value: driverValue,
                        elevation: 16,
                        style: DropdownDecoration().dropdownTextStyle(),
                        onChanged: (String? newValue) {
                          // This is called when the user selects an item.
                          setState(() {
                            driverValue = newValue!;
                          });
                        },
                        items: driver.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(value),
                          );
                        }).toList(),
                      ))),
                      FormWidgets().formDetails2('From Date'  ,
                        DateFieldWidget2(
                          dayController: dayControllerFrom,
                          monthController: monthControllerFrom,
                          yearController: yearControllerFrom,
                          dateControllerApi: fromDateApi,
                        ),
                        //   SizedBox(
                        //   height: 35,
                        //   child: TextFormField(
                        //     readOnly: true,
                        //     controller: fromDate,
                        //     decoration: UiDecoration().dateFieldDecoration('Freight Rate Date'),
                        //     onTap: (){
                        //       UiDecoration().showDatePickerDecoration(context).then((value){
                        //         setState(() {
                        //           String month = value.month.toString().padLeft(2, '0');
                        //           String day = value.day.toString().padLeft(2, '0');
                        //           fromDate.text = "${value.year}-$month-$day";
                        //         });
                        //       });
                        //     },
                        //   ),
                        // ),
                      ),
                      FormWidgets().formDetails2('To Date'  ,
                        DateFieldWidget2(
                            dayController: dayControllerTo,
                            monthController: monthControllerTo,
                            yearController: yearControllerTo,
                            dateControllerApi: toDateApi
                        ),
                        //   SizedBox(
                        //   height: 35,
                        //   child: TextFormField(
                        //     readOnly: true,
                        //     controller: toDate,
                        //     decoration: UiDecoration().dateFieldDecoration('Freight Rate Date'),
                        //     onTap: (){
                        //       UiDecoration().showDatePickerDecoration(context).then((value){
                        //         setState(() {
                        //           String month = value.month.toString().padLeft(2, '0');
                        //           String day = value.day.toString().padLeft(2, '0');
                        //           toDate.text = "${value.year}-$month-$day";
                        //         });
                        //       });
                        //     },
                        //   ),
                        // ),
                      ),
                      FormWidgets().formDetails('Driver Salary', 'Driver Salary' , driverSalary),
                      FormWidgets().formDetails('Deduction', 'Deduction Amount' , deduction),
                      FormWidgets().formDetails9('Quantity', 'Quantity' , total),
                      FormWidgets().formDetails2('Entry Date'  ,
                        DateFieldWidget2(
                            dayController: dayControllerEntry,
                            monthController: monthControllerEntry,
                            yearController: yearControllerEntry,
                            dateControllerApi: entryDateApi
                        ),
                        //   SizedBox(
                        //   height: 35,
                        //   child: TextFormField(
                        //     readOnly: true,
                        //     controller: entryDate,
                        //     decoration: UiDecoration().dateFieldDecoration('Freight Rate Date'),
                        //     onTap: (){
                        //       UiDecoration().showDatePickerDecoration(context).then((value){
                        //         setState(() {
                        //           String month = value.month.toString().padLeft(2, '0');
                        //           String day = value.day.toString().padLeft(2, '0');
                        //           entryDate.text = "${value.year}-$month-$day";
                        //         });
                        //       });
                        //     },
                        //   ),
                        // ),
                      ),
                      /// Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Reset Button
                          ElevatedButton(
                              style: ButtonStyles.smallButton(
                                  ThemeColors.backgroundColor, ThemeColors.darkBlack),
                              onPressed: () {
                                formKey.currentState!.reset();
                              }, child: const Text("Reset")),
                          const SizedBox(width: 20,),
                          // Create Button
                          ElevatedButton(
                              style: ButtonStyles.smallButton(
                                  ThemeColors.primaryColor, ThemeColors.whiteColor),
                              onPressed: () {
                                if(vehicleValue.isEmpty){
                                  AlertBoxes.flushBarErrorMessage("Select Vehicle", context);
                                } else if(driverValue.isEmpty){
                                  AlertBoxes.flushBarErrorMessage('Select Driver', context);
                                } else if(fromDate.text.isEmpty){
                                  AlertBoxes.flushBarErrorMessage('Enter From Date', context);
                                } else if(toDate.text.isEmpty){
                                  AlertBoxes.flushBarErrorMessage('Enter To Date', context);
                                } else if(driverSalary.text.isEmpty){
                                  AlertBoxes.flushBarErrorMessage('Enter Driver Salary', context);
                                } else if(entryDate.text.isEmpty){
                                  AlertBoxes.flushBarErrorMessage('Enter Entry Date', context);
                                }
                              }, child: const Text("Create")),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  salaryList(){
    return Container(
      margin: const EdgeInsets.only(top: 10,right: 10),
      decoration: UiDecoration().formDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10 , left: 10),
            alignment: Alignment.centerLeft,
            child:
            textDecoration.heading('Salary List'),
          ),
          const Divider(),
          // dropdown & search
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text('Show '),
                // dropdown
                DropdownDecoration().dropdownDecoration2(DropdownButton<String>(
                  borderRadius: BorderRadius.circular(5),
                  dropdownColor: ThemeColors.dropdownColor,
                  underline: Container(
                    decoration: const BoxDecoration(border: Border()),
                  ),
                  isExpanded: true,
                  hint: Text(
                    'Select Entries',
                    style: TextStyle(color: ThemeColors.dropdownTextColor),
                  ),
                  icon: DropdownDecoration().dropdownIcon(),
                  value: entriesDropdownValue,
                  elevation: 16,
                  style: DropdownDecoration().dropdownTextStyle(),
                  onChanged: (String? newValue) {
                    // This is called when the user selects an item.
                    setState(() {
                      entriesDropdownValue = newValue!;
                    });
                  },
                  items: entriesList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value),
                    );
                  }).toList(),
                )),
                const Text(' entries'),
                const Spacer(),
                // Search
                const Text('Search: '), Expanded(child: FormWidgets().textFormField('Search' , search )),
              ],
            ),
          ),

          const SizedBox(height: 10,),

          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                        child: PaginatedDataTable(
                          columns: const [
                            DataColumn(label: Text('Driver')),
                            DataColumn(label: Text('Vehicle')),
                            DataColumn(label: Text('From Date'),),
                            DataColumn(label: Text('To Date'),),
                            DataColumn(label: Text('Salary'),),
                            DataColumn(label: Text('Deduction'),),
                            DataColumn(label: Text('Total'),),
                            DataColumn(label: Text('Date'),),
                          ],
                          source: _data,
                          showCheckboxColumn: false,
                          columnSpacing: 60,
                          horizontalMargin: 10,
                          rowsPerPage: int.parse(entriesDropdownValue),
                          showFirstLastButtons: true,
                          sortAscending: true,
                          sortColumnIndex: 0,
                        ),
                      )
                    ],
                  ))),
        ],
      ),
    );
  }

}

class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data = List.generate(200, (index) => {
    "driver": 'Person $index',
    "vehicle": "Vehicle $index",
    "from_date": '${index-Random().nextInt(12)}-20${Random().nextInt(23)}',
    "to_date": '${index-Random().nextInt(12)}-20${Random().nextInt(23)}',
    'salary': '${Random().nextInt(3000)*4}',
    'deduction': '$index',
    'total': '${Random().nextInt(3000)*4}',
    "date": '${index-Random().nextInt(12)}-20${Random().nextInt(23)}',
  });

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
      cells: [
        DataCell(Text(_data[index]['driver'].toString())),
        DataCell(Text(_data[index]['vehicle'].toString())),
        DataCell(Text(_data[index]['from_date'].toString())),
        DataCell(Text(_data[index]['to_date'].toString())),
        DataCell(Text(_data[index]['salary'].toString())),
        DataCell(Text(_data[index]['deduction'].toString())),
        DataCell(Text(_data[index]['total'].toString())),
        DataCell(Text(_data[index]['date'].toString())),
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _data.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
