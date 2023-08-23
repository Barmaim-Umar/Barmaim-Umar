import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class NewOutdoorVehicleAndList extends StatefulWidget {
  const NewOutdoorVehicleAndList({Key? key}) : super(key: key);

  @override
  State<NewOutdoorVehicleAndList> createState() => _NewOutdoorVehicleAndListState();
}

/// RateManagement
List<String> transportList = ["Vehicle Transport" , "Ledger2" , "Ledger3" , "Ledger4"];
List<String> typeList = ["Type" , "Type2" , "Type3" , "Type4"];
List<String> vehicleStatusList = ["Vehicle Status" , "Unloaded" , "OnRoad" , "Empty"];
List<String> entriesList = ["10" ,"20" , "30" , "40"];

class _NewOutdoorVehicleAndListState extends State<NewOutdoorVehicleAndList> {

  TextDecorationClass textDecoration = TextDecorationClass();

  String transportValue = transportList.first;
  String typeValue = typeList.first;
  String vehicleStatusValue = vehicleStatusList.first;
  String entriesDropdownValue = entriesList.first;

  final formKey = GlobalKey<FormState>();

  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: UiDecoration.appBar("New Outdoor Vehicle And List"),
      body: Responsive(
        /// Mobile
          mobile: const Text("Mobile"),

          /// Tablet
          tablet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// New Ledger
                Expanded(flex: 2, child: rateManagementForm()),

                const SizedBox(width: 10,),

                /// ledger list
                Expanded(flex: 2, child: rateManagementList()),
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
                Expanded(flex: 2, child: rateManagementForm()),
                const SizedBox(width: 10,),
                /// ledger list
                Expanded(flex: 3, child: rateManagementList()),
              ],
            ),
          )
      ),
    );
  }

  rateManagementForm(){
    return  Container(
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
                // TextDecoration().formTitle('New Ledger'),
                textDecoration.heading('New Outdoor Vehicle'),
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
                      FormWidgets().formDetails9('Vehicle Number', 'Enter Vehicle Number' , vehicleNumberController),
                      FormWidgets().formDetails2('Type',DropdownDecoration().dropdownDecoration(DropdownButton<String>(
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: ThemeColors.dropdownColor,
                        underline: Container(
                          decoration: const BoxDecoration(border: Border()),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Select Type',
                          style: TextStyle(color: ThemeColors.dropdownTextColor),
                        ),
                        icon: DropdownDecoration().dropdownIcon(),
                        value: typeValue,
                        elevation: 16,
                        style: DropdownDecoration().dropdownTextStyle(),
                        onChanged: (String? newValue) {
                          // This is called when the user selects an item.
                          setState(() {
                            typeValue = newValue!;
                          });
                        },
                        items: typeList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(value),
                          );
                        }).toList(),
                      ))),
                      FormWidgets().formDetails2('Select Transport',DropdownDecoration().dropdownDecoration(DropdownButton<String>(
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: ThemeColors.dropdownColor,
                        underline: Container(
                          decoration: const BoxDecoration(border: Border()),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Select Transport',
                          style: TextStyle(color: ThemeColors.dropdownTextColor),
                        ),
                        icon: DropdownDecoration().dropdownIcon(),
                        value: transportValue,
                        elevation: 16,
                        style: DropdownDecoration().dropdownTextStyle(),
                        onChanged: (String? newValue) {
                          // This is called when the user selects an item.
                          setState(() {
                            transportValue = newValue!;
                          });
                        },
                        items: transportList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(value),
                          );
                        }).toList(),
                      ))),
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
                                if(vehicleNumberController.text.isEmpty){
                                  AlertBoxes.flushBarErrorMessage('Enter Vehicle Number', context);
                                } else if(typeValue.isEmpty){
                                  AlertBoxes.flushBarErrorMessage('Select Type', context);
                                } else if(transportValue.isEmpty){
                                  AlertBoxes.flushBarErrorMessage('Select Transport', context);
                                }else {
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
    );
  }

  rateManagementList(){
    final DataTableSource data = MyData(setState);
    return Container(
      decoration: UiDecoration().formDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10 , left: 10),
            alignment: Alignment.centerLeft,
            child:
            // TextDecoration().formTitle('Ledger List'),
            textDecoration.heading('Vehicle List'),
          ),
          const Divider(),
          // dropdown & search
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text('Show '),
                // dropdown
                DropdownDecoration().dropdownDecoration2(
                    DropdownButton<String>(
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
                const SizedBox(width: 20,),
                UiDecoration().dropDown(1, DropdownButton<String>(
                  borderRadius: BorderRadius.circular(5),
                  dropdownColor: ThemeColors.dropdownColor,
                  underline: Container(
                    decoration: const BoxDecoration(border: Border()),
                  ),
                  isExpanded: true,
                  hint: Text(
                    'Select Vehicle Status',
                    style: TextStyle(color: ThemeColors.dropdownTextColor),
                  ),
                  icon: DropdownDecoration().dropdownIcon(),
                  value: vehicleStatusValue,
                  elevation: 16,
                  style: DropdownDecoration().dropdownTextStyle(),
                  onChanged: (String? newValue) {
                    // This is called when the user selects an item.
                    setState(() {
                      vehicleStatusValue = newValue!;
                    });
                  },
                  items: vehicleStatusList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value),
                    );
                  }).toList(),
                )),
                const SizedBox(width: 20,),
                // Search
                const Text('Search: '), Expanded(flex: 1, child: FormWidgets().textFormField('Search' , searchController)),
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
                            DataColumn(label: Text('In/Outdoor')),
                            DataColumn(label: Text('Vehicle Company')),
                            DataColumn(label: Text('Vehicle Number')),
                            DataColumn(label: Text('Vehicle Type')),
                            DataColumn(label: Text('Vehicle Status')),
                            DataColumn(label: Text('Action'),),
                          ],
                          source: data,
                          showCheckboxColumn: false,
                          columnSpacing: 40,
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
  Function setState;
  MyData(this.setState);
  final List<Map<String, dynamic>> _data = List.generate(200, (index) => {
    "driver": 'Driver $index',
    "indoor": "Indoor $index",
    "vehicle_company": "Vehicle Company $index",
    "vehicle_number": "Vehicle Number $index",
    "vehicle_type": "Vehicle Type $index",
    "vehicle_status": "Vehicle Status $index",
  }
  );

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color: index==0||index%2==0?MaterialStatePropertyAll(Colors.grey.shade400):const MaterialStatePropertyAll(ThemeColors.whiteColor),
      cells: [
        DataCell(Text(_data[index]['driver'].toString())),
        DataCell(Text(_data[index]['indoor'])),
        DataCell(Text(_data[index]['vehicle_company'])),
        DataCell(Text(_data[index]['vehicle_number'])),
        DataCell(Text(_data[index]['vehicle_type'])),
        DataCell(Text(_data[index]['vehicle_status'])),
        DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                // edit Icon
                UiDecoration().actionButton(ThemeColors.editColor, IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                }, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),

                // delete Icon
                UiDecoration().actionButton( ThemeColors.deleteColor, IconButton(
                    padding: const EdgeInsets.all(0),onPressed: () {
                      setState((){
                      _data.removeAt(index);
                      });
                }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),

                // Info Icon
                UiDecoration().actionButton( ThemeColors.infoColor, IconButton(
                    padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.person, size: 15, color: Colors.white,))),
              ],
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
              color: Colors.green,
                borderRadius: BorderRadius.circular(3)
                
              ),
              child: const Text('Activated',style: TextStyle(color: ThemeColors.whiteColor),),
            )
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

