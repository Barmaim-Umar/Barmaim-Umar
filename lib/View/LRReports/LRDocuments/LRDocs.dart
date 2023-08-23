import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/DocumentUpload.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'dart:math';
import 'package:pfc/utility/utility.dart';

class LRDocs extends StatefulWidget {
  const LRDocs({Key? key}) : super(key: key);
  @override
  State<LRDocs> createState() => _LRDocsState();
}

List<String> assignDropdownList = ['All Vehicle' , 'Not Assign' , 'Assign'];
List<String> selectLedgerList = ['Select Ledger/Customer' , 'Ledger1' , 'Ledger2' , 'Ledger3'];
List<String> entriesDropdownList = ["10" ,"20" ,"30" ,"40"];

class _LRDocsState extends State<LRDocs> with Utility{
  final DataTableSource _data = MyData();

  String assignDropdownValue = assignDropdownList.first;
  String selectLedgerValue = selectLedgerList.first;
  String entriesDropdownValue = entriesDropdownList.first;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("LR Docs"),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              alignment: Alignment.centerLeft,
              child: TextDecorationClass().heading('LR Docs'),
            ),
            const Divider(),
            // dropdown | From date | To Date
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  const Text('Show '),
                  // entries dropdown
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
                  widthBox20(),

                  // Select Ledger / Customer
                  Expanded(
                    child: Container(
                      height: 35,
                      width: 400,
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
                          'Select Ledger / Customer',
                          style: TextStyle(color: ThemeColors.darkBlack),
                        ),
                        icon: const Icon(
                          CupertinoIcons.chevron_down,
                          color: ThemeColors.darkBlack,
                          size: 15,
                        ),
                        iconSize: 30,
                        value: selectLedgerValue,
                        elevation: 16,
                        style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                        onChanged: (String? newValue) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectLedgerValue = newValue!;
                          });
                        },
                        items: selectLedgerList.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Center(child: Text(value)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  // Vehicle type dropdown
                  Expanded(
                    child: Container(
                      height: 35,
                      width: 400,
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
                          'All Vehicles',
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
                        style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
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
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("From : "),
                            DateFieldWidget2(
                                dayController: dayControllerFrom,
                                monthController: monthControllerFrom,
                                yearController: yearControllerFrom,
                                dateControllerApi: fromDateApi
                            ),
                          ],
                        ),
                        widthBox20(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("To : "),
                            Column(
                              children: [

                                DateFieldWidget2(
                                    dayController: dayControllerTo,
                                    monthController: monthControllerTo,
                                    yearController: yearControllerTo,
                                    dateControllerApi: toDateApi
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: fromDate,
                  //       decoration: UiDecoration().dateFieldDecoration('From Date'),
                  //       onTap: (){
                  //         UiDecoration().showDatePickerDecoration(context).then((value){
                  //           setState(() {
                  //             String month = value.month.toString().padLeft(2, '0');
                  //             String day = value.day.toString().padLeft(2, '0');
                  //             fromDate.text = "${value.year}-$month-$day";
                  //           });
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                  widthBox10(),
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: toDate,
                  //       decoration: UiDecoration().dateFieldDecoration('To Date'),
                  //       onTap: (){
                  //         UiDecoration().showDatePickerDecoration(context).then((value){
                  //           setState(() {
                  //             String month = value.month.toString().padLeft(2, '0');
                  //             String day = value.day.toString().padLeft(2, '0');
                  //             toDate.text = "${value.year}-$month-$day";
                  //           });
                  //         });
                  //       },
                  //     ),
                  //   ),
                  // ),
                  widthBox10(),
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor,100.0,42.0),
                    onPressed: () {},
                    child: const Text("Filter"),
                  ),
                ],
              ),
            ),

            // buttons
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Wrap(
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
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search : '),
                  // Search
                  Expanded(
                    child: TextFormField(
                        decoration:
                        UiDecoration().outlineTextFieldDecoration('Search',ThemeColors.primaryColor)
                    ),
                  ),
                  const SizedBox(width: 10,)
                ],
              ),
            ),

            const SizedBox(height: 20,),

            // All LRs | All Time Record
            Container(
              margin: const EdgeInsets.only(left: 10 , right: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration:  BoxDecoration(color: ThemeColors.primaryColor , borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("All LRs | All Time Records" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                ],),
            ),
            // DataTable
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
                              DataColumn(label: Text('LR No.')),
                              DataColumn(label: Text('LR Date')),
                              DataColumn(label: Text('Ledger')),
                              DataColumn(label: Text('Vehicle No.')),
                              DataColumn(label: Text('From Location')),
                              DataColumn(label: Text('To Location')),
                              DataColumn(label: Text('Doc View')),
                              DataColumn(label: Text('Upload')),
                              DataColumn(label: Text('Bill Status')),
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
      ),
    );
  }

  uploadDocuments(){
    showDialog(context: context, builder: (context) {
      return  AlertDialog(
        title: Column(
          children: [
            // Upload Documents | LR Number
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextDecorationClass().heading("Upload Documents"),
                const SizedBox(width: 20,),
                TextDecorationClass().heading2("LR NUMBER: 1185654")
              ],
            ),
            const Divider(),
          ],
        ),
        // Document 1 and 2
        content: SizedBox(
          height: 270,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(7)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Document 1
                        Row(
                          children: [
                            const Icon(Icons.upload),
                            TextDecorationClass().heading2("Document 1")
                          ],
                        ),
                        const SizedBox(height: 10,),
                        // Browse | No file Selected
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 3),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(color: ThemeColors.grey)
                              ),
                              child: const Text("Browse..."),
                            ),
                            const SizedBox(width: 10,),
                            Text("No file selected." , style: TextStyle(color: Colors.grey.shade600 , fontSize: 13),),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        // Upload Button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () {  },
                          icon: const Icon(Icons.upload),
                          label: const Text("Upload"),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(width: 10,),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(7)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Document 2
                        Row(
                          children: [
                            const Icon(Icons.upload),
                            TextDecorationClass().heading2("Document 2")
                          ],
                        ),
                        const SizedBox(height: 10,),
                        // Browse | No File Selected
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 3),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(color: ThemeColors.grey)
                              ),
                              child: const Text("Browse..."),
                            ),
                            const SizedBox(width: 10,),
                            Text("No file selected." , style: TextStyle(color: Colors.grey.shade600 , fontSize: 13),),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        // Upload Button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () {  },
                          icon: const Icon(Icons.upload),
                          label: const Text("Upload"),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              const Text("Note:" , style: TextStyle(color: ThemeColors.darkRedColor , fontWeight: FontWeight.bold),),

              UiDecoration().noteText("Try to upload minimum size scanned LR"),
              UiDecoration().noteText("Upload one by one"),
              UiDecoration().noteText("Wait while upload in progress"),
              UiDecoration().noteText("Do not refresh while upload in progress"),
              UiDecoration().noteText("Check LR Number at header before upload"),

              const Divider(height: 30,),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () {

          }, child: const Text("Cancel"))
        ],
      );

    },);
  }
}


class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data = List.generate(
      200,
          (index) => {
        "lr_no": index,
        "lr_date": "Item $index",
        "ledger": Random().nextInt(10000),
        "vehicle_no": index,
        "from_location": "Item $index",
        "to_location": Random().nextInt(10000),
        "doc_view": index,
        "upload": "Item $index",
        "bill_status": Random().nextInt(10000),
      });

  @override
  DataRow? getRow(int index) {
    return DataRow(
      color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
      cells: [
        DataCell(Text(_data[index]['lr_no'].toString())),
        DataCell(Text(_data[index]['lr_date'])),
        DataCell(Text(_data[index]['ledger'].toString())),
        DataCell(Text(_data[index]['vehicle_no'].toString())),
        DataCell(Text(_data[index]['from_location'])),
        DataCell(Text(_data[index]['to_location'].toString())),
        DataCell(Text(_data[index]['doc_view'].toString())),
        DataCell(SizedBox(
          height: 30,
          width: 120,
          child: Builder(
            builder: (BuildContext context) {
              ValueNotifier<int> _a = ValueNotifier(0);
              return ElevatedButton(
                  onPressed: () {
                    // uploadDocuments();
                    showDialog(context: context, builder: (context) {
                      return  AlertDialog(
                        title: Column(
                          children: [
                            // Upload Documents | LR Number
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextDecorationClass().heading("Upload Documents"),
                                const SizedBox(width: 20,),
                                TextDecorationClass().heading2("LR NUMBER: 1185654"),
                                ValueListenableBuilder(valueListenable: _a, builder: (context, value, child) => Text("this is Value $value"),)
                              ],
                            ),
                            const Divider(),
                          ],
                        ),
                        // Document 1 and 2
                        content: SizedBox(
                          height: 270,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // upload Document 1
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      return Container(
                                        padding: const EdgeInsets.only(left: 10 , top: 10 , bottom: 10 , right: 70),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(7)
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Document 1
                                            Row(
                                              children: [
                                                const Icon(Icons.upload),
                                                TextDecorationClass().heading2("Document 1")
                                              ],
                                            ),
                                            const SizedBox(height: 10,),
                                            // Browse | No file Selected
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 3),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(7),
                                                      border: Border.all(color: ThemeColors.grey)
                                                  ),
                                                  child: const Text("Browse..."),
                                                ),
                                                const SizedBox(width: 10,),
                                                Text("No file selected." , style: TextStyle(color: Colors.grey.shade600 , fontSize: 13),),
                                              ],
                                            ),
                                            const SizedBox(height: 10,),
                                            // Upload Button
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                              onPressed: () {
                                                setState(() {
                                                  _a.value++;
                                                });
                                              },
                                              icon: const Icon(Icons.upload),
                                              label: const Text("Tap to Change value"),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 10,),
                                  // upload Document 2
                                  Container(
                                    padding: const EdgeInsets.only(left: 10 , top: 10 , bottom: 10 , right: 70),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(7)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Document 2
                                        Row(
                                          children: [
                                            const Icon(Icons.upload),
                                            TextDecorationClass().heading2("Document 2")
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        // Browse | No File Selected
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 3),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(7),
                                                  border: Border.all(color: ThemeColors.grey)
                                              ),
                                              child: const Text("Browse..."),
                                            ),
                                            const SizedBox(width: 10,),
                                            Text("No file selected." , style: TextStyle(color: Colors.grey.shade600 , fontSize: 13),),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        // Upload Button
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                          onPressed: () {  },
                                          icon: const Icon(Icons.upload),
                                          label: const Text("Upload"),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  // Widget
                                  const DocumentUpload(title: "Document3")

                                ],
                              ),
                              const SizedBox(height: 10,),
                              const Text("Note:" , style: TextStyle(color: ThemeColors.darkRedColor , fontWeight: FontWeight.bold),),

                              UiDecoration().noteText("Try to upload minimum size scanned LR"),
                              UiDecoration().noteText("Upload one by one"),
                              UiDecoration().noteText("Wait while upload in progress"),
                              UiDecoration().noteText("Do not refresh while upload in progress"),
                              UiDecoration().noteText("Check LR Number at header before upload"),

                              const Divider(height: 30,),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(onPressed: () {
                            Navigator.pop(context);
                          }, child: const Text("Cancel"))
                        ],
                      );
                    },
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                  child: const Text("Upload Docs" , style: TextStyle(color: Colors.white),));
            },
          ),
        )),
        DataCell(Container(padding: const EdgeInsets.only(left: 8 , right: 8 , bottom: 6 , top: 4),
          decoration: BoxDecoration(color: Colors.grey , borderRadius: BorderRadius.circular(10)),
          child: const Text("Pending",style: TextStyle(color: Colors.white , fontWeight: FontWeight.w500 , fontSize: 13),),)),

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
