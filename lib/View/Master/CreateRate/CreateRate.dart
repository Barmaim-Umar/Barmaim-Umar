import 'dart:convert';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class CreateRate extends StatefulWidget {
  const CreateRate({Key? key}) : super(key: key);

  @override
  State<CreateRate> createState() => _CreateRateState();
}

/// RateManagement
List<String> ledgerList = ["Ledger1" , "Ledger2" , "Ledger3" , "Ledger4"];
List<String> matrixList = ["32sq" , "12sq" , "33sq"];
List<String> typeList = ["Type1" , "Type2" , "Type3" , "Type4"];
List<String> vehicleStatusList = ["Vehicle Status" , "Unloaded" , "OnRoad" , "Empty"];
List<String> entriesList = ["10" ,"20" , "30" , "40"];

class _CreateRateState extends State<CreateRate> {

  final DataTableSource _data = MyData();

  TextDecorationClass textDecoration = TextDecorationClass();

  String ledgerValue = "";
  String matrixValue = "";
  String typeValue = "";
  String vehicleStatusValue = vehicleStatusList.first;
  String entriesDropdownValue = entriesList.first;

  final _formKey = GlobalKey<FormState>();

  TextEditingController fromLocationController = TextEditingController();
  TextEditingController toLocationController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController freightRateController = TextEditingController();
  TextEditingController totalFreightAmountController = TextEditingController();
  TextEditingController freightRateDateController = TextEditingController();
  TextEditingController totalKMsController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  TextEditingController dayControllerFreightRateDate = TextEditingController();
  TextEditingController monthControllerFreightRateDate = TextEditingController();
  TextEditingController yearControllerFreightRateDate = TextEditingController();
  TextEditingController freightRateDateApi =TextEditingController();
  FocusNode focusNode1 = FocusNode();


  // Api
  ledgerFetchApiFunc(){
    ServiceWrapper().ledgerFetchApi().then((value) {
      var info = jsonDecode(value);
      // TODO : ledger dropdown api
    });
  }

  @override
  void initState() {
    ledgerFetchApiFunc();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   FocusScope.of(context).requestFocus(focusNode1);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: UiDecoration.appBar("Create Rate"),
      body: Responsive(
        /// Mobile
          mobile: const Text("Mobile"),

          /// Tablet
          tablet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// New Ledger
                Expanded(child: rateManagementForm()),

                const SizedBox(height: 10,),

                /// ledger list
                Expanded(child: rateManagementList()),
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
                Expanded(child: rateManagementForm()),
                const SizedBox(width: 10,),
                /// ledger list
                Expanded(child: rateManagementList()),
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
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child:
                // TextDecoration().formTitle('New Ledger'),
                textDecoration.heading('Rate Management'),
              ),
            ),
            const Divider(),
            // form
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 8 , left: 8, bottom: 8 ,right: 20),
                  child: FocusScope(
                    child: FocusTraversalGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FormWidgets().formDetails2('Select Ledger/Customer',SearchDropdownWidget(
                              dropdownList: ledgerList, hintText: "Please Select Ledger",
                              onChanged: (value) {
                                ledgerValue = value!;
                              }, selectedItem: ledgerValue),
                          ),
                          FormWidgets().formDetails2('Select Matrix',
                            SearchDropdownWidget(dropdownList: matrixList, hintText: "Please Select Matrix", onChanged: (value) {
                              matrixValue = value!;
                            }, selectedItem: matrixValue),
                          ),
                          FormWidgets().formDetails2('Type',
                            SearchDropdownWidget(
                                dropdownList: typeList, hintText: "Please Select Type",
                                onChanged: (value) {
                                  typeValue = value!;
                                },
                                selectedItem: typeValue
                            ),
                          ),
                          FormWidgets().alphanumericField('From Location', 'From Location' , fromLocationController , context ,),
                          FormWidgets().alphanumericField('To Location', 'To Location' , toLocationController , context),
                          FormWidgets().numberField('Quantity', 'Quantity' , quantityController , context),
                          FormWidgets().numberField('Freight Rate', 'Freight Rate' , freightRateController , context),
                          FormWidgets().numberField('Total Freight Amount', 'Total Amount' , totalFreightAmountController , context),
                          FormWidgets().formDetails2('Freight Rate Date'  ,
                            DateFieldWidget2(
                                dayController: dayControllerFreightRateDate,
                                monthController: monthControllerFreightRateDate,
                                yearController: yearControllerFreightRateDate,
                                dateControllerApi: freightRateDateApi
                            ),
                            //   TextFormField(
                            //   readOnly: true,
                            //   controller: freightRateDateController,
                            //
                            //   decoration: UiDecoration().dateFieldDecoration('Freight Rate Date'),
                            //   onTap: (){
                            //     UiDecoration().showDatePickerDecoration(context).then((value){
                            //       setState(() {
                            //         String month = value.month.toString().padLeft(2, '0');
                            //         String day = value.day.toString().padLeft(2, '0');
                            //         freightRateDateController.text = "${value.year}-$month-$day";
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
                          FormWidgets().alphanumericField('Total KMs', 'Total KMs' , totalKMsController , context),
                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Reset Button
                              ElevatedButton(
                                  style: ButtonStyles.smallButton(
                                      ThemeColors.backgroundColor, ThemeColors.darkBlack),
                                  onPressed: () {
                                    _formKey.currentState!.reset();
                                    freightRateDateController.clear();
                                  }, child: const Text("Reset")),
                              const SizedBox(width: 20,),
                              // Create Button
                              ElevatedButton(
                                  style: ButtonStyles.smallButton(
                                      ThemeColors.primaryColor, ThemeColors.whiteColor),
                                  onPressed: () {
                                    if(_formKey.currentState!.validate()){
                                      _formKey.currentState!.save();
                                    }
                                  },

                                  child: const Text("Create")),
                            ],
                          )
                        ],
                      ),
                    ),
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
            textDecoration.heading('Rate Management List'),
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
                const Text('Search: '), Expanded(child: FormWidgets().textFormField('Search' , searchController)),
              ],
            ),
          ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                        child: PaginatedDataTable(
                          columns: const [
                            DataColumn(label: Text('Ledger')),
                            DataColumn(label: Text('Group')),
                            DataColumn(label: Text('Action'),),
                          ],
                          source: _data,

                          // header: const Center(
                          //   child: Text('My Products'),
                          // ),
                          showCheckboxColumn: false,
                          columnSpacing: 250,
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
  final List<Map<String, dynamic>> _data = List.generate(200, (index) => {"Ledger": index, "Group": "Item $index", "Action": Random().nextInt(10000)});

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
      cells: [
        DataCell(Text(_data[index]['Ledger'].toString())),
        DataCell(Text(_data[index]['Group'])),
        DataCell(Row(
          children: [
            // edit Icon
            UiDecoration().actionButton(ThemeColors.editColor , LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints){
                  return IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return const AlertDialog(
                        title: Text("Test"),
                      );
                    },);
                  }, icon: const Icon(Icons.edit, size: 15, color: Colors.white,));
                }
            )),

            // delete Icon
            UiDecoration().actionButton( ThemeColors.deleteColor, IconButton(
                padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),

            // Info Icon
            UiDecoration().actionButton( ThemeColors.infoColor, IconButton(
                padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.info_outlined, size: 15, color: Colors.white,))),
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

