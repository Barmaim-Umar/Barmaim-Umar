import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class NotesManage extends StatefulWidget {
  const NotesManage({Key? key}) : super(key: key);

  @override
  State<NotesManage> createState() => _NotesManageState();
}

List<String> vehicleList = ['Select Vehicle' , 'type1' , 'type2' , 'type3'];
List<String> entriesList = ['10' , '20' , '30' , '40' , '50'];

class _NotesManageState extends State<NotesManage> with Utility{

  final List<Map> paidLRReportList = [
    {
      'date': '02-12-2001',
      'vehicle': 'Vehicle',
      'note': 'Note',
    },
    {
      'date': '02-12-2001',
      'vehicle': 'Vehicle',
      'note': 'Note',
    },
    {
      'date': '02-12-2001',
      'vehicle': 'Vehicle',
      'note': 'Note',
    },
    {
      'date': '02-12-2001',
      'vehicle': 'Vehicle',
      'note': 'Note',
    },
    {
      'date': '02-12-2001',
      'vehicle': 'Vehicle',
      'note': 'Note',
    },
    {
      'date': '02-12-2001',
      'vehicle': 'Vehicle',
      'note': 'Note',
    },
    {
      'date': '02-12-2001',
      'vehicle': 'Vehicle',
      'note': 'Note',
    },
    {
      'date': '02-12-2001',
      'vehicle': 'Vehicle',
      'note': 'Note',
    },
    {
      'date': '02-12-2001',
      'vehicle': 'Vehicle',
      'note': 'Note',
    },
    {
      'date': '02-12-2001',
      'vehicle': 'Vehicle',
      'note': 'Note',
    },
    {
      'date': '02-12-2001',
      'vehicle': 'Vehicle',
      'note': 'Note',
    },
  ];

  String vehicleValue = vehicleList.first;
  String entriesValue = entriesList.first;
  TextDecorationClass textDecoration = TextDecorationClass();
  final formKey = GlobalKey<FormState>();
  TextEditingController addNoteController = TextEditingController();
  TextEditingController noteDate = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController dayControllerNote = TextEditingController();
  TextEditingController monthControllerNote = TextEditingController();
  TextEditingController yearControllerNote = TextEditingController();
  TextEditingController NodeDateApi =TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: UiDecoration.appBar("Notes Management"),
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
                /// New Ledger
                Expanded(child: customerForm()),
                const SizedBox(height: 10,),
                /// ledger list
                // Expanded(child: ledgerList()),
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
                Expanded(flex: 2, child: customerForm()),
                const SizedBox(width: 10,),
                /// ledger list
                Expanded(flex: 3, child: ledgerList()),
              ],
            ),
          )
      ),
    );
  }

  customerForm(){
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
                    textDecoration.heading('Notes Manage'),
                  ),
                ),
                const Divider(),
                // form
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(top: 8 , left: 8, bottom: 8 ,right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          FormWidgets().formDetails2('Select Vehicle', SearchDropdownWidget(dropdownList: vehicleList, hintText: 'Select Vehicle', onChanged: (p0) {

                          }, selectedItem: vehicleValue)),
                          heightBox10(),
                          FormWidgets().alphanumericField('Write Note', 'Write Note Here', addNoteController, context, maxLines: 4),
                          heightBox10(),
                          FormWidgets().formDetails2('Note Date', DateFieldWidget2(
                            dayController: dayControllerNote,
                            monthController: monthControllerNote,
                            yearController: yearControllerNote,
                            dateControllerApi: NodeDateApi,
                          ),),
                          // Row(
                          //   children: [
                          //     textDecoration.subHeading('Note Date'),
                          //     widthBox20(),
                          //
                          //
                          //     // Expanded(
                          //     //   flex: 3,
                          //     //   child: SizedBox(
                          //     //     height: 35,
                          //     //     child: TextFormField(
                          //     //       readOnly: true,
                          //     //       controller: noteDate,
                          //     //       decoration:
                          //     //       UiDecoration().dateFieldDecoration('Note Date'),
                          //     //       onTap: () {
                          //     //         UiDecoration()
                          //     //             .showDatePickerDecoration(context)
                          //     //             .then((value) {
                          //     //           setState(() {
                          //     //             String month =
                          //     //             value.month.toString().padLeft(2, '0');
                          //     //             String day = value.day.toString().padLeft(2, '0');
                          //     //             noteDate.text = "${value.year}-$month-$day";
                          //     //           });
                          //     //         });
                          //     //       },
                          //     //     ),
                          //     //   ),
                          //     // )
                          //   ],
                          // ),
                          const SizedBox(height: 20,),
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
                                    if(formKey.currentState!.validate()){
                                      formKey.currentState!.save();
                                    }
                                    if(vehicleValue.isEmpty){
                                      AlertBoxes.flushBarErrorMessage("Select Vehicle", context);
                                    } else if(addNoteController.text.isEmpty){
                                      AlertBoxes.flushBarErrorMessage('Add Note', context);
                                    } else if(noteDate.text.isEmpty){
                                      AlertBoxes.flushBarErrorMessage('Enter Date', context);
                                    }  else {
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
    );
  }

  ledgerList(){
    return  Container(
      decoration: UiDecoration().formDecoration(),
      child: Form(
        // key: formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child:
                textDecoration.heading('Notes'),
              ),
            ),
            const Divider(),
            Row(
              children: [
                const Text('Show '),
                // entries dropdown
                Container(
                  height: 35,
                  width: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey.shade400)),
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
                    value: entriesValue,
                    elevation: 16,
                    style: TextDecorationClass().dropDownText(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        entriesValue = newValue!;
                      });
                    },
                    items: entriesList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const Text(' entries'),
                const Spacer(),
                Expanded(
                  child: TextFormField(
                      decoration: UiDecoration().outlineTextFieldDecoration(
                          'Search', ThemeColors.primaryColor)),
                ),
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {
                                PointerDeviceKind.touch,
                                PointerDeviceKind.mouse,
                                PointerDeviceKind.trackpad
                              }),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('Date')),
                                  DataColumn(label: Text('Vehicle')),
                                  DataColumn(label: Text('Note')),
                                  DataColumn(label: Text('Actions')),
                                ],
                                showCheckboxColumn: false,
                                columnSpacing: 227,
                                horizontalMargin: 10,
                                sortAscending: true,
                                sortColumnIndex: 0,
                                rows: List.generate(paidLRReportList.length,
                                        (index) {
                                      return DataRow(
                                        color: MaterialStatePropertyAll(index == 0 || index % 2 == 0 ? ThemeColors.tableRowColor : Colors.white),
                                        cells: [
                                          DataCell(Text(paidLRReportList[index]
                                          ['date']
                                              .toString())),
                                          DataCell(Text(paidLRReportList[index]
                                          ['vehicle'])),
                                          DataCell(Text(paidLRReportList[index]
                                          ['note']
                                              .toString())),
                                          DataCell(Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              UiDecoration().actionButton(ThemeColors.editColor, IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                                              }, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
                                              UiDecoration().actionButton( ThemeColors.deleteColor, IconButton(
                                                  padding: const EdgeInsets.all(0),onPressed: () {
                                                setState((){
                                                });
                                              }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),
                                            ],
                                          )),
                                        ],
                                      );
                                    })),
                          ),
                        )
                      ],
                    ))),
            Row(
              children: [
                /// Prev Button
                Row(
                  children: [
                    GlobalVariable.next == false ?Text('Prev',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade700),):const SizedBox(),
                    IconButton(
                        onPressed: GlobalVariable.prev == false ? null : () {
                          setState(() {
                            GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                          });
                        }, icon: const Icon(Icons.chevron_left)),
                  ],
                ),
                const SizedBox(width: 30,),
                /// Next Button
                Row(
                  children: [
                    IconButton(
                      onPressed: GlobalVariable.next == false ? null : () {
                        setState(() {
                          GlobalVariable.currentPage++;
                        });
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                    GlobalVariable.next == false ?Text('Next',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade700),):const SizedBox()
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

