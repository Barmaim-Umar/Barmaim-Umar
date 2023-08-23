import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:http/http.dart' as http;

class VehicleInfo extends StatefulWidget {
  const VehicleInfo({Key? key}) : super(key: key);

  @override
  State<VehicleInfo> createState() => _VehicleInfoState();
}

List<String> selectVehicleDropdownList = ["MH202121" , "MH202897" , "MH2027679" , "MH202999" , "MH20211221" , "MH20242311"];
List<String> infoTypeDropdownList = ["1" , "2" , "3" , "4" , "5"];
List<String> entriesDropdownList = ["10" ,"20" , "30" , "40"];

class _VehicleInfoState extends State<VehicleInfo> {

  final DataTableSource _data = MyData();

  TextDecorationClass textDecoration = TextDecorationClass();

  String selectVehicleDropdownValue = selectVehicleDropdownList.first;
  String infoTypeDropdownValue = infoTypeDropdownList.first;
  String entriesDropdownValue = entriesDropdownList.first;

  final formKey = GlobalKey<FormState>();

  TextEditingController companyNameController = TextEditingController();
  TextEditingController docNumberController = TextEditingController();
  TextEditingController renewalDateController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  TextEditingController dayControllerRenewal = TextEditingController();
  TextEditingController monthControllerRenewal = TextEditingController();
  TextEditingController yearControllerRenewal = TextEditingController();
  TextEditingController dayControllerExpiry = TextEditingController();
  TextEditingController monthControllerExpiry = TextEditingController();
  TextEditingController yearControllerExpiry = TextEditingController();
  TextEditingController expiryDateApi =TextEditingController();
  TextEditingController renewalDateApi =TextEditingController();

  FocusNode focusNode1 = FocusNode();
  List vehicleList = [];
  List<String> vehicleNumberList = [];
  String vehicleNumber = "";
  var vehicleID;

  // api
  vehicleDocumentRenewalApiFunc(){
    vehicleDocumentRenewalApi().then((value) {

      print("44e4: $value");

      var info = jsonDecode(value);

      print("ee98: $info");

      // try {
        if (info['success'] == true) {
          AlertBoxes.flushBarSuccessMessage(info['message'], context);
        } else {
          AlertBoxes.flushBarErrorMessage(info['message'], context);
        }
      // }
      // catch(e){
      //   print(e);
      //   AlertBoxes.flushBarErrorMessage("catch: Something went wrong", context);
      // }
    });
  }

  // dropdown api
  vehicleFetchApiFunc(){
    ServiceWrapper().vehicleFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        vehicleList.addAll(info['data']);

        for(int i=0; i<info['data'].length; i++){
          vehicleNumberList.add(info['data'][i]['vehicle_number']);
        }

      } else {
        print("Success FALSE");
      }
    });
  }

  @override
  void initState() {
    vehicleFetchApiFunc();
    
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   FocusScope.of(context).requestFocus(focusNode1);
    // });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: UiDecoration.appBar("Vehicle Info"),
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
          decoration: UiDecoration().formDecoration(),
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
                        textDecoration.heading('Vehicle Info'),
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
                            children: [
                              FormWidgets().formDetails2('Select Vehicle',SearchDropdownWidget(
                                  dropdownList: vehicleNumberList,
                                  hintText: "Select Vehicle",
                                  onChanged: (value) {
                                    vehicleNumber = value!;

                                    // vehicle ID
                                    for(int i=0; i<vehicleList.length; i++){
                                      if(vehicleNumber ==  vehicleList[i]['vehicle_number']){
                                        vehicleID = vehicleList[i]['vehicle_id'];
                                      }
                                    }

                                    print("ff102: $vehicleID");

                                  }, selectedItem: vehicleNumber)),
                              FormWidgets().formDetails2('Select Info Type',SearchDropdownWidget(
                                  dropdownList: infoTypeDropdownList,
                                  hintText: "Select Info Type",
                                  onChanged:(value) {
                                    infoTypeDropdownValue = value!;
                                  }, selectedItem: infoTypeDropdownValue)),
                              FormWidgets().onlyAlphabetField('Company Name (Optional)', 'Company Name' , companyNameController , context),
                              FormWidgets().alphanumericField('Doc Number', 'Doc Number' , docNumberController , context),
                              FormWidgets().formDetails2('Renewal Date'  ,
                                DateFieldWidget2(
                                    dayController: dayControllerRenewal,
                                    monthController: monthControllerRenewal,
                                    yearController: yearControllerRenewal,
                                    dateControllerApi: renewalDateApi,
                                ),
                              //   TextFormField(
                              //   readOnly: true,
                              //   controller: renewalDateController,
                              //   decoration: UiDecoration().dateFieldDecoration('Renewal Date'),
                              //   onTap: (){
                              //     UiDecoration().showDatePickerDecoration(context).then((value){
                              //       setState(() {
                              //         String month = value.month.toString().padLeft(2, '0');
                              //         String day = value.day.toString().padLeft(2, '0');
                              //         renewalDateController.text = "${value.year}-$month-$day";
                              //       });
                              //     });
                              //   },
                              //
                              //   validator: (value) {
                              //     if(value == null || value == ''){
                              //       return "Please Select Date";
                              //     }
                              //     return null;
                              //   },
                              // ),
                              ),
                              FormWidgets().formDetails2('Expiry Date'  ,
                                DateFieldWidget2(
                                    dayController: dayControllerExpiry,
                                    monthController: monthControllerExpiry,
                                    yearController: yearControllerExpiry,
                                    dateControllerApi: expiryDateApi,
                                ),
                              //   TextFormField(
                              //   readOnly: true,
                              //   controller: expiryDateController,
                              //   decoration: UiDecoration().dateFieldDecoration('Expiry Date'),
                              //   onTap: (){
                              //     UiDecoration().showDatePickerDecoration(context).then((value){
                              //       setState(() {
                              //         String month = value.month.toString().padLeft(2, '0');
                              //         String day = value.day.toString().padLeft(2, '0');
                              //         expiryDateController.text = "${value.year}-$month-$day";
                              //       });
                              //     });
                              //   },
                              //
                              //   validator: (value) {
                              //     if(value == null || value == ''){
                              //       return "Please Select Date";
                              //     }
                              //     return null;
                              //   },
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
                                        if(companyNameController.text.isEmpty){
                                          AlertBoxes.flushBarErrorMessage("Enter Company Name", context);
                                        } else if(docNumberController.text.isEmpty){
                                          AlertBoxes.flushBarErrorMessage('Enter Doc Number', context);
                                        } else if(renewalDateController.text.isEmpty){
                                          AlertBoxes.flushBarErrorMessage('Enter From Date', context);
                                        } else if(expiryDateController.text.isEmpty){
                                          AlertBoxes.flushBarErrorMessage('Enter Expiry Date', context);
                                        } else {
                                          vehicleDocumentRenewalApiFunc();
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
      flex: 2,
        child: Container(
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
                                DataColumn(label: Text('Info Title')),
                                DataColumn(label: Text('Number'),),
                                DataColumn(label: Text('From Date'),),
                                DataColumn(label: Text('Expiry Date'),),
                                DataColumn(label: Text('Action'),),
                              ],
                              source: _data,

                              // header: const Center(
                              //   child: Text('My Products'),
                              // ),
                              showCheckboxColumn: false,
                              columnSpacing: 90,
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

  Future vehicleDocumentRenewalApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDocument/VehicleDocumentRenewal");

    var body = {
      'vehicle_id': vehicleID.toString(),
      'docinfo_id':infoTypeDropdownValue,
      'company_name':companyNameController.text,
      'doc_number':docNumberController.text,
      'renewal_date':renewalDateController.text,
      'expiry_date':expiryDateController.text,

    };

    var response = await http.post(headers: headers , url , body: body);
    return response.body.toString();
  }

}

class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data = List.generate(200, (index) => {
    "vehicle_number": index,
    "info_title": "Item $index",
    "number": Random().nextInt(10000),
    "from_date": Random().nextInt(10000),
    "expiry_date": Random().nextInt(10000),
  });

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
      cells: [
        DataCell(Text(_data[index]['vehicle_number'].toString())),
        DataCell(Text(_data[index]['info_title'].toString())),
        DataCell(Text(_data[index]['number'].toString())),
        DataCell(Text(_data[index]['from_date'].toString())),
        DataCell(Text(_data[index]['expiry_date'].toString())),
        DataCell(Row(
          children: [
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
