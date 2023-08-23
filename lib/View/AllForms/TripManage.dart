import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class TripManage extends StatefulWidget {
  const TripManage({Key? key}) : super(key: key);

  @override
  State<TripManage> createState() => _TripManageState();
}

List<String> vehiclesDropdownList = ["Select Vehicle", "Mh20232323" , "Mh20232312" , "Mh20232376" , "Mh20232311" , "Mh20232309"];
List<String> driversDropdownList = ["Select Driver","Driver1" , "Driver2" , "Driver3" , "Driver4" , "Driver5"];
List<String> entriesDropdownList = ["10" ,"20" , "30" , "40"];

class _TripManageState extends State<TripManage> {
  final DataTableSource _data = MyData();

  String dropdownValue = "Select Option";
  List<String> dropdownList = ["1" , "2" , "3" , "4" , "5"];
  bool isOpen = false;


  TextDecorationClass textDecoration = TextDecorationClass();

  String vehiclesDropdownValue = vehiclesDropdownList.first;
  String driversDropdownValue = driversDropdownList.first;
  String entriesDropdownValue = entriesDropdownList.first;

  final formKey = GlobalKey<FormState>();

  String groupValue = 'RadioValue';

  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode1 = FocusNode();

  TextEditingController toDateApi = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();

  @override
  void initState() {
    
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   FocusScope.of(context).requestFocus(focusNode1);
    // });
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // backgroundColor: ThemeColors.backgroundColor,
      body: Responsive(
        /// Mobile
          mobile: const Text("Mobile"),

          /// Tablet
          tablet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // New Ledger
                ledgerForm(),
                const SizedBox(
                  height: 10,
                ),

                // ledger list
                ledgerList(),
              ],
            ),
          ),

          /// Desktop
          desktop: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// New Ledger
                ledgerForm(),
                const SizedBox(width: 10,),
                /// ledger list
                ledgerList(),
              ],
            ),
          )
      ),
    );
  }

  ledgerForm(){
    return  Expanded(
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Form(
            key: formKey,
            child: FocusScope(
              child: FocusTraversalGroup(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                        child:
                        // TextDecoration().formTitle('New Ledger'),
                        textDecoration.heading('Trip Manage'),
                      ),
                    ),
                    const Divider(),
                    // form
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.only(top: 8 , left: 8, bottom: 8 ,right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FormWidgets().formDetails2('Vehicles',Container(
                                height: 33,
                                width: 350,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
                                child: DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(5),
                                  dropdownColor: ThemeColors.whiteColor,
                                  underline: Container(
                                    decoration: const BoxDecoration(border: Border()),
                                  ),
                                  isExpanded: true,
                                  hint: const Text(
                                    'Select a class',
                                    style: TextStyle(color: ThemeColors.darkBlack),
                                  ),
                                  icon: const Icon(
                                    CupertinoIcons.chevron_down,
                                    color: ThemeColors.darkBlack,
                                    size: 20,
                                  ),
                                  iconSize: 30,
                                  value: vehiclesDropdownValue,
                                  elevation: 16,
                                  style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                                  onChanged: (String? newValue) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      vehiclesDropdownValue = newValue!;
                                    });
                                  },
                                  items: vehiclesDropdownList.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value.toString(),
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              )),
                              FormWidgets().formDetails2('State',Container(
                                height: 33,
                                width: 350,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
                                child: DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(5),
                                  dropdownColor: ThemeColors.whiteColor,
                                  underline: Container(
                                    decoration: const BoxDecoration(border: Border()),
                                  ),
                                  isExpanded: true,
                                  hint: const Text(
                                    'Select a class',
                                    style: TextStyle(color: ThemeColors.darkBlack),
                                  ),
                                  icon: const Icon(
                                    CupertinoIcons.chevron_down,
                                    color: ThemeColors.darkBlack,
                                    size: 20,
                                  ),
                                  iconSize: 30,
                                  value: driversDropdownValue,
                                  elevation: 16,
                                  style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                                  onChanged: (String? newValue) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      driversDropdownValue = newValue!;
                                    });
                                  },
                                  items: driversDropdownList.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value.toString(),
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              )),
                              FormWidgets().formDetails2('Trip From Date',
                                DateFieldWidget2(
                                    dayController: dayControllerFrom,
                                    monthController: monthControllerFrom,
                                    yearController: yearControllerFrom,
                                    dateControllerApi: fromDateApi
                                ),
                              //   SizedBox(
                              //   height: 33,
                              //   width: 350,
                              //   child: TextFormField(
                              //     readOnly: true,
                              //     controller: fromDate,
                              //     decoration:
                              //     UiDecoration().dateFieldDecoration('From Date'),
                              //     onTap: () {
                              //       UiDecoration()
                              //           .showDatePickerDecoration(context)
                              //           .then((value) {
                              //         setState(() {
                              //           String month =
                              //           value.month.toString().padLeft(2, '0');
                              //           String day = value.day.toString().padLeft(2, '0');
                              //           fromDate.text = "${value.year}-$month-$day";
                              //         });
                              //       });
                              //     },
                              //   ),
                              // ),
                              ),
                              FormWidgets().formDetails2('Trip To Date',
                                DateFieldWidget2(
                                    dayController: dayControllerTo,
                                    monthController: monthControllerTo,
                                    yearController: yearControllerTo,
                                    dateControllerApi: toDateApi
                                ),
                              //   SizedBox(
                              //   height: 33,
                              //   width: 350,
                              //   child: TextFormField(
                              //     readOnly: true,
                              //     controller: toDate,
                              //     decoration:
                              //     UiDecoration().dateFieldDecoration('To Date'),
                              //     onTap: () {
                              //       UiDecoration()
                              //           .showDatePickerDecoration(context)
                              //           .then((value) {
                              //         setState(() {
                              //           String month =
                              //           value.month.toString().padLeft(2, '0');
                              //           String day = value.day.toString().padLeft(2, '0');
                              //           toDate.text = "${value.year}-$month-$day";
                              //         });
                              //       });
                              //     },
                              //   ),
                              // ),
                              ),

                              // Buttons
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
                                        if(fromDate.text.isEmpty){
                                          AlertBoxes.flushBarErrorMessage("Enter From Date", context);
                                        } else if(toDate.text.isEmpty){
                                          AlertBoxes.flushBarErrorMessage('Enter To Date', context);
                                        } else {
                                          "";
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
            ),
          ),
        ));
  }

  ledgerList(){
    return Expanded(
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10 , left: 10),
                alignment: Alignment.centerLeft,
                child:
                // TextDecoration().formTitle('Ledger List'),
                textDecoration.heading('Last Created Trip'),
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
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
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
                        style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                        onChanged: (String? newValue) {
                          // This is called when the user selects an item.
                          setState(() {
                            entriesDropdownValue = newValue!;
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
                    const Spacer(),
                    // Search
                    const Text('Search: '), Expanded(child: FormWidgets().textFormField('Search' , searchController)),
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
                                DataColumn(label: Text('Vehicle Number')),
                                DataColumn(label: Text('From Date')),
                                DataColumn(label: Text('To Date'),),
                                DataColumn(label: Text('Action'),),
                              ],
                              source: _data,

                              // header: const Center(
                              //   child: Text('My Products'),
                              // ),
                              showCheckboxColumn: false,
                              columnSpacing: 70,
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
        ));
  }

}

class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data = List.generate(200, (index) => {"vehicle_number": index, "from_date": "Item $index", "to_date": Random().nextInt(10000) , "action" : "asd"});

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
      cells: [
        DataCell(Text(_data[index]['vehicle_number'].toString())),
        DataCell(Text(_data[index]['from_date'].toString())),
        DataCell(Text(_data[index]['to_date'].toString())),
        DataCell(Row(
          children: [
            // Activities
            ElevatedButton(onPressed: () {},
                style: ButtonStyles.customiseButton(Colors.blue, Colors.white, 80.0, 28.0),
                child: const Text("Activities" ,style: TextStyle(fontSize: 13), )),
            const SizedBox(width: 2,),
            // Transactions
            ElevatedButton(onPressed: () {},
                style: ButtonStyles.customiseButton(Colors.blue.shade800, Colors.white, 80.0, 28.0),
                child: const Text("Transactions" ,style: TextStyle(fontSize: 13), )),
            const SizedBox(width: 1,),
            // edit Icon
            Container(
                height: 20,
                width:20,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
            // delete Icon
            Container(
                height: 20,
                width: 20,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(color: ThemeColors.darkRedColor, borderRadius: BorderRadius.circular(5)),
                child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),

          ],
        )),
      ],
      onSelectChanged: (value) {},
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
