import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class TimelinePostAndList extends StatefulWidget {
  const TimelinePostAndList({Key? key}) : super(key: key);

  @override
  State<TimelinePostAndList> createState() => _TimelinePostAndListState();
}

List<String> selectDriverList = ["Driver1" , "Driver2" , "Driver3" , "Driver4" , "Driver5" , "Driver6"];
List<String> entriesList = ["10" ,"20" , "30" , "40"];

class _TimelinePostAndListState extends State<TimelinePostAndList> {

  int freshLoad = 1;
  String selectedItem = '';
  String selectedItem2 = '';
  TextEditingController timelinePostController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  String selectDriverValue = selectDriverList.first;
  String entriesDropdownValue = entriesList.first;
  final formKey = GlobalKey<FormState>();

  
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
      appBar: UiDecoration.appBar("Timeline POST"),
      body: Responsive(
        /// Mobile
          mobile: const Text("Mobile"),

          /// Tablet
          tablet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Timeline Form
                Expanded(child: timelineForm()),

                const SizedBox(height: 10,),

                /// Timeline list
                Expanded(child: timelineList()),
              ],
            ),
          ),

          /// Desktop
          desktop: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Timeline form
                Expanded(flex: 2,child: timelineForm()),
                const SizedBox(width: 10,),
                /// Timeline list
                Expanded(flex: 3,child: timelineList()),
              ],
            ),
          )
      ),
    );
  }

  timelineForm(){
    return  Container(
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
                    TextDecorationClass().heading('Timeline Post'),
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

                          FormWidgets().formDetails2('Select Driver', SearchDropdownWidget(
                              dropdownList: selectDriverList,
                              hintText: "Select Alias Name",
                              onChanged: (p0) {

                              },
                              selectedItem: selectedItem
                          ),),
                          FormWidgets().formDetails2('Timeline Write POST', SearchDropdownWidget(
                              dropdownList: selectDriverList,
                              hintText: "Select Alias Name",
                              onChanged: (p0) {

                              },
                              selectedItem: selectedItem
                          ),),

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
                                    if(timelinePostController.text.isEmpty){
                                      AlertBoxes.flushBarErrorMessage("Enter Timeline", context);
                                    } else {

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
    );
  }

  timelineList(){
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
            TextDecorationClass().heading('Timeline List'),
          ),
          const Divider(),
          // dropdown & search
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text('Show '),
                // dropdown
                SizedBox(
                  width: 80,
                  child: SearchDropdownWidget(dropdownList: entriesList, hintText: "10", onChanged: (value) {
                    selectedItem2 = value!;
                  }, selectedItem: selectedItem2),
                ),
                const Text(' entries'),
                const Spacer(),
                // Search
                const Text('Search: '), Expanded(child: FormWidgets().textFormField('Search' , searchController , onFieldSubmitted: (value){
                  setState(() {});
                })),
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
                        child: /*freshLoad == 1 ? const Text("FreshLoad = 1 \nPlease Wait...") : */
                        SizedBox(
                            width: double.maxFinite,
                            child: buildDataTable()),
                      ),
                      const Divider(),
                    ],
                  ))),
        ],
      ),
    );
  }

  /// DATATABLE ===========================
  Widget buildDataTable() {
    return /*ledgerTableList.isEmpty ? const Center(child: Text("ledgerTableList.isEmpty \nUpdating List..."),) : */
      DataTable(
        columns: [
          DataColumn(label: TextDecorationClass().dataColumnName("Timeline POST")),
          DataColumn(label: TextDecorationClass().dataColumnName("Date")),
          DataColumn(label: TextDecorationClass().dataColumnName("Action")),
        ],
        rows:  List.generate(200, (index) {
          return DataRow(
              color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
              cells: [
                DataCell(TextDecorationClass().dataRowCell("timelinePOST")),
                DataCell(TextDecorationClass().dataRowCell("30-12-2023")),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // edit Icon
                    UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.edit, size: 15, color: Colors.white,), onPressed: () {
                      setState(() {});
                    },)),

                    // delete Icon
                    UiDecoration().actionButton( ThemeColors.deleteColor,IconButton(padding: const EdgeInsets.all(0),onPressed: () {

                      showDialog(context: context, builder: (context) {
                        return
                          AlertDialog(
                            title: const Text("Are you sure you want to delete"),
                            actions: [
                              TextButton(onPressed: () {
                                Navigator.pop(context);
                              }, child: const Text("Cancel")),

                              TextButton(onPressed: () {
                                setState(() {});
                                Navigator.pop(context);
                              }, child: const Text("Delete"))
                            ],
                          );
                      },);

                    }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),

                    // Info Icon
                    UiDecoration().actionButton( ThemeColors.infoColor,IconButton(
                        padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.info_outlined, size: 15, color: Colors.white,))),
                  ],
                )),
              ]);
        })

    );
  }

}