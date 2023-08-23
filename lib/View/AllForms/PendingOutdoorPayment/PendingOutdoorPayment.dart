import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/View/AllForms/PendingOutdoorPaymentsTransaction/PendingOutdoorPaymentsTransaction.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

import 'package:pfc/utility/utility.dart';

class PendingOutdoorPayment extends StatefulWidget {
  const PendingOutdoorPayment({Key? key}) : super(key: key);

  @override
  State<PendingOutdoorPayment> createState() => _PendingOutdoorPaymentState();
}

List<String> entriesDropdownList = ["10", "20", "30", "40"];
List<String> ledgerDropdownList = ['select ledger',"10", "20", "30", "40"];
List<String> advanceMethodDropdownList = ['select advance method',"10", "20", "30", "40"];
List<String> ledgerList = ['select ledger',"10", "20", "30", "40"];

class _PendingOutdoorPaymentState extends State<PendingOutdoorPayment> with Utility {

  final List<Map> pendingPaymentList = [
    {'date': '02-12-2001', 'lr_number': 1, 'route': 'Route 1', 'transporter': 'Jivan TPT', 'party': 'United Breveris', 'vehicle_number': 'MH20DR9546', 'total_freight': '10000', 'extra_freight': '0', 'paid_amount': '8500', 'balance_amount':'1500'},
    {'date': '02-12-2001', 'lr_number': 1, 'route': 'Route 1', 'transporter': 'Jivan TPT', 'party': 'United Breveris', 'vehicle_number': 'MH20DR9546', 'total_freight': '10000', 'extra_freight': '0', 'paid_amount': '8500', 'balance_amount':'1500'},
    {'date': '02-12-2001', 'lr_number': 1, 'route': 'Route 1', 'transporter': 'Jivan TPT', 'party': 'United Breveris', 'vehicle_number': 'MH20DR9546', 'total_freight': '10000', 'extra_freight': '0', 'paid_amount': '8500', 'balance_amount':'1500'},
    {'date': '02-12-2001', 'lr_number': 1, 'route': 'Route 1', 'transporter': 'Jivan TPT', 'party': 'United Breveris', 'vehicle_number': 'MH20DR9546', 'total_freight': '10000', 'extra_freight': '0', 'paid_amount': '8500', 'balance_amount':'1500'},
    {'date': '02-12-2001', 'lr_number': 1, 'route': 'Route 1', 'transporter': 'Jivan TPT', 'party': 'United Breveris', 'vehicle_number': 'MH20DR9546', 'total_freight': '10000', 'extra_freight': '0', 'paid_amount': '8500', 'balance_amount':'1500'},
    {'date': '02-12-2001', 'lr_number': 1, 'route': 'Route 1', 'transporter': 'Jivan TPT', 'party': 'United Breveris', 'vehicle_number': 'MH20DR9546', 'total_freight': '10000', 'extra_freight': '0', 'paid_amount': '8500', 'balance_amount':'1500'},
    {'date': '02-12-2001', 'lr_number': 1, 'route': 'Route 1', 'transporter': 'Jivan TPT', 'party': 'United Breveris', 'vehicle_number': 'MH20DR9546', 'total_freight': '10000', 'extra_freight': '0', 'paid_amount': '8500', 'balance_amount':'1500'},
    {'date': '02-12-2001', 'lr_number': 1, 'route': 'Route 1', 'transporter': 'Jivan TPT', 'party': 'United Breveris', 'vehicle_number': 'MH20DR9546', 'total_freight': '10000', 'extra_freight': '0', 'paid_amount': '8500', 'balance_amount':'1500'},
    {'date': '02-12-2001', 'lr_number': 1, 'route': 'Route 1', 'transporter': 'Jivan TPT', 'party': 'United Breveris', 'vehicle_number': 'MH20DR9546', 'total_freight': '10000', 'extra_freight': '0', 'paid_amount': '8500', 'balance_amount':'1500'},
    {'date': '02-12-2001', 'lr_number': 1, 'route': 'Route 1', 'transporter': 'Jivan TPT', 'party': 'United Breveris', 'vehicle_number': 'MH20DR9546', 'total_freight': '10000', 'extra_freight': '0', 'paid_amount': '8500', 'balance_amount':'1500'},
    {'date': '02-12-2001', 'lr_number': 1, 'route': 'Route 1', 'transporter': 'Jivan TPT', 'party': 'United Breveris', 'vehicle_number': 'MH20DR9546', 'total_freight': '10000', 'extra_freight': '0', 'paid_amount': '8500', 'balance_amount':'1500'},
    {'date': '02-12-2001', 'lr_number': 1, 'route': 'Route 1', 'transporter': 'Jivan TPT', 'party': 'United Breveris', 'vehicle_number': 'MH20DR9546', 'total_freight': '10000', 'extra_freight': '0', 'paid_amount': '8500', 'balance_amount':'1500'},
  ];


  String entriesDropdownValue = entriesDropdownList.first;
  String advanceMethodDropdownValue = advanceMethodDropdownList.first;
  String ledgerDropdownValue = ledgerDropdownList.first;
  String ledgerDropdownValue2 = ledgerList.first;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController search = TextEditingController();
  TextEditingController payingDate = TextEditingController();
  TextEditingController remark = TextEditingController();
  TextEditingController remark2 = TextEditingController();
  TextEditingController toDateApi = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
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
      appBar: UiDecoration.appBar('Pending Outdoor Payment'),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    padding: const EdgeInsets.symmetric(horizontal: 5),
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
                      value: entriesDropdownValue,
                      elevation: 16,
                      style: TextDecorationClass().dropDownText(),
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          entriesDropdownValue = newValue!;
                        });
                      },
                      items: entriesDropdownList
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
                  UiDecoration().dropDown(1, DropdownButton<String>(
                    borderRadius: BorderRadius.circular(5),
                    dropdownColor: ThemeColors.whiteColor,
                    underline: Container(
                      decoration: const BoxDecoration(border: Border()),
                    ),
                    isExpanded: true,
                    hint: const Text(
                      'Select Ledger',
                      style: TextStyle(color: ThemeColors.darkBlack),
                    ),
                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      color: ThemeColors.darkBlack,
                      size: 20,
                    ),
                    iconSize: 30,
                    value: ledgerDropdownValue,
                    elevation: 16,
                    style: TextDecorationClass().dropDownText(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        ledgerDropdownValue = newValue!;
                      });
                    },
                    items: ledgerDropdownList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value),
                      );
                    }).toList(),
                  ),),
                  widthBox10(),
                  UiDecoration().dropDown(1, DropdownButton<String>(
                    borderRadius: BorderRadius.circular(5),
                    dropdownColor: ThemeColors.whiteColor,
                    underline: Container(
                      decoration: const BoxDecoration(border: Border()),
                    ),
                    isExpanded: true,
                    hint: const Text(
                      'Select Advance Method',
                      style: TextStyle(color: ThemeColors.darkBlack),
                    ),
                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      color: ThemeColors.darkBlack,
                      size: 20,
                    ),
                    iconSize: 30,
                    value: advanceMethodDropdownValue,
                    elevation: 16,
                    style: TextDecorationClass().dropDownText(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        advanceMethodDropdownValue = newValue!;
                      });
                    },
                    items: advanceMethodDropdownList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value),
                      );
                    }).toList(),
                  ),),
                  widthBox10(),
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
                  //   flex: 1,
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: fromDate,
                  //       decoration:
                  //       UiDecoration().dateFieldDecoration('From Date'),
                  //       onTap: () {
                  //         UiDecoration()
                  //             .showDatePickerDecoration(context)
                  //             .then((value) {
                  //           setState(() {
                  //             String month =
                  //             value.month.toString().padLeft(2, '0');
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
                  //   flex: 1,
                  //   child: SizedBox(
                  //     height: 35,
                  //     child: TextFormField(
                  //       readOnly: true,
                  //       controller: toDate,
                  //       decoration:
                  //       UiDecoration().dateFieldDecoration('To Date'),
                  //       onTap: () {
                  //         UiDecoration()
                  //             .showDatePickerDecoration(context)
                  //             .then((value) {
                  //           setState(() {
                  //             String month =
                  //             value.month.toString().padLeft(2, '0');
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
                    style: ButtonStyles.customiseButton(
                        ThemeColors.primaryColor,
                        ThemeColors.whiteColor,
                        100.0,
                        42.0),
                    onPressed: () {
                      fromDate.text = '';
                      toDate.text = '';
                    },
                    child: const Text("Filter"),
                  ),
                ],
              ),
            ),

            // buttons
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Wrap(
                      runSpacing: 5,
                      // spacing: 0,
                      children: [
                        BStyles()
                            .button('CSV', 'Export to CSV', "assets/csv2.png"),
                        const SizedBox(
                          width: 10,
                        ),
                        BStyles().button(
                            'Excel', 'Export to Excel', "assets/excel.png"),
                        const SizedBox(
                          width: 10,
                        ),
                        BStyles()
                            .button('PDF', 'Export to PDF', "assets/pdf.png"),
                        const SizedBox(
                          width: 10,
                        ),
                        BStyles().button('Print', 'Print', "assets/print.png"),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextDecorationClass().subHeading2('Search : '),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                        controller: search,
                        onFieldSubmitted: (value) {},
                        decoration: UiDecoration().outlineTextFieldDecoration(
                            'Search', ThemeColors.primaryColor)),
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: SingleChildScrollView(
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
                              columnSpacing: 50,
                              dataRowHeight: 67,
                              columns: [
                                DataColumn(label: TextDecorationClass().dataColumnName("Date")),
                                DataColumn(label: TextDecorationClass().dataColumnName("LR Number")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Route")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Transporter")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Party")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Vehicle Number")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Total Freight")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Extra Freight")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Paid Amount")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Balance Amount")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Action")),
                              ],
                              rows:  List.generate(pendingPaymentList.length, (index) {
                                return DataRow(
                                  //Check Odd Even
                                    color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
                                    cells: [
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['date'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['lr_number'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['route'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['transporter'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['party'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['vehicle_number'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['total_freight'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['extra_freight'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['paid_amount'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['balance_amount'].toString())),
                                      DataCell(Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                ElevatedButton(
                                                  style: ButtonStyles.customiseButton(ThemeColors.greenColor, ThemeColors.whiteColor, 55.0, 30.0),
                                                  onPressed: (){
                                                    payDialogue();
                                                  },
                                                  child: const Text('Pay'),
                                                ),
                                                widthBox5(),
                                                ElevatedButton(
                                                  style: ButtonStyles.customiseButton(ThemeColors.primaryDark, ThemeColors.whiteColor, 55.0, 30.0),
                                                  onPressed: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PendingOutdoorPaymentsTransaction(),));
                                                  },
                                                  child: const Text('Transaction'),
                                                ),
                                              ],
                                            ),
                                            heightBox5(),
                                            ElevatedButton(
                                              style: ButtonStyles.customiseButton(ThemeColors.orangeColor, ThemeColors.whiteColor, 153.0, 30.0),
                                              onPressed: (){
                                                extraChargesDialogue();
                                              },
                                              child: const Text('Add Extra Charges'),
                                            ),
                                          ],
                                        ),
                                      ))
                                    ]);
                              })
                          ),
                        ),
                      ),
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
                )),
          ],
        ),
      ),
    );
  }

  payDialogue(){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.all(5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextDecorationClass().heading('Pay To Transfer'),
            InkWell(onTap: () {
              Navigator.pop(context);
            }, child: const Icon(CupertinoIcons.xmark,color: Colors.grey,size: 15,)),
          ],
        ),
        contentPadding: const EdgeInsets.all(10),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextDecorationClass().subHeading('Transporter'),
                  widthBox10(),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      decoration: UiDecoration().outlineTextFieldDecoration('Transporter', ThemeColors.primary),
                    ),
                  )
                ],
              ),
              heightBox20(),
              Row(
                children: [
                  TextDecorationClass().subHeading('Balance Amount'),
                  widthBox10(),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: UiDecoration().outlineTextFieldDecoration('Enter Balance Amount', ThemeColors.primary),
                    ),
                  )
                ],
              ),
              heightBox20(),
              Row(
                children: [
                  TextDecorationClass().subHeading('Paying Amount'),
                  widthBox10(),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: UiDecoration().outlineTextFieldDecoration('Enter Amount', ThemeColors.primary),
                    ),
                  )
                ],
              ),
              heightBox20(),
              Row(
                children: [
                  TextDecorationClass().subHeading('From'),
                  widthBox10(),
                  Container(
                    height: 33,
                    width: 250,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
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
                        'Select Ledger',
                        style: TextStyle(color: ThemeColors.darkBlack),
                      ),
                      icon: const Icon(
                        CupertinoIcons.chevron_down,
                        color: ThemeColors.darkBlack,
                        size: 20,
                      ),
                      iconSize: 30,
                      value: ledgerDropdownValue2,
                      elevation: 16,
                      style: TextDecorationClass().dropDownText(),
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          ledgerDropdownValue2 = newValue!;
                        });
                      },
                      items: ledgerList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              heightBox20(),
              Row(
                children: [
                  TextDecorationClass().subHeading('Entry Date'),
                  widthBox10(),
                  SizedBox(
                    width: 250,
                    height: 33,
                    child: TextFormField(
                      controller: payingDate,
                      decoration: UiDecoration().dateFieldDecoration('Enter Paying Date'),
                      onTap: () {
                        UiDecoration()
                            .showDatePickerDecoration(context)
                            .then((value) {
                          setState(() {
                            String month =
                            value.month.toString().padLeft(2, '0');
                            String day = value.day.toString().padLeft(2, '0');
                            payingDate.text = "${value.year}-$month-$day";
                          });
                        });
                      },
                    ),
                  )
                ],
              ),
              heightBox20(),
              Row(
                children: [
                  TextDecorationClass().subHeading('Remark'),
                  widthBox10(),
                  SizedBox(
                    width: 250,
                    height: 33,
                    child: TextFormField(
                      controller: remark,
                      decoration: UiDecoration().outlineTextFieldDecoration('Remark', ThemeColors.primary),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyles.customiseButton(ThemeColors.primary, ThemeColors.whiteColor, 100.0, 40.0),
            onPressed: (){},
            child: const Text('Pay'),
          ),
          ElevatedButton(
            style: ButtonStyles.customiseButton(ThemeColors.primary, ThemeColors.whiteColor, 100.0, 40.0),
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      );
    },);
  }
  extraChargesDialogue(){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.all(5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextDecorationClass().heading('Add Extra Charges'),
            InkWell(onTap: () {
              Navigator.pop(context);
            }, child: const Icon(CupertinoIcons.xmark,color: Colors.grey,size: 15,)),
          ],
        ),
        contentPadding: const EdgeInsets.all(10),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextDecorationClass().subHeading('Transporter'),
                  widthBox10(),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      decoration: UiDecoration().outlineTextFieldDecoration('Transporter', ThemeColors.primary),
                    ),
                  )
                ],
              ),
              heightBox20(),
              Row(
                children: [
                  TextDecorationClass().subHeading('Extra Amount'),
                  widthBox10(),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: UiDecoration().outlineTextFieldDecoration('Enter Extra Amount', ThemeColors.primary),
                    ),
                  )
                ],
              ),
              heightBox20(),
              Row(
                children: [
                  TextDecorationClass().subHeading('Extra Charges Ledger'),
                  widthBox10(),
                  Container(
                    height: 33,
                    width: 250,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
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
                        'Select Ledger',
                        style: TextStyle(color: ThemeColors.darkBlack),
                      ),
                      icon: const Icon(
                        CupertinoIcons.chevron_down,
                        color: ThemeColors.darkBlack,
                        size: 20,
                      ),
                      iconSize: 30,
                      value: ledgerDropdownValue2,
                      elevation: 16,
                      style: TextDecorationClass().dropDownText(),
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          ledgerDropdownValue2 = newValue!;
                        });
                      },
                      items: ledgerList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              heightBox20(),
              Row(
                children: [
                  TextDecorationClass().subHeading('Entry Date'),
                  widthBox10(),
                  SizedBox(
                    width: 250,
                    height: 33,
                    child: TextFormField(
                      controller: payingDate,
                      decoration: UiDecoration().dateFieldDecoration('Enter Paying Date'),
                      onTap: () {
                        UiDecoration()
                            .showDatePickerDecoration(context)
                            .then((value) {
                          setState(() {
                            String month =
                            value.month.toString().padLeft(2, '0');
                            String day = value.day.toString().padLeft(2, '0');
                            payingDate.text = "${value.year}-$month-$day";
                          });
                        });
                      },
                    ),
                  )
                ],
              ),
              heightBox20(),
              Row(
                children: [
                  TextDecorationClass().subHeading('Remark'),
                  widthBox10(),
                  SizedBox(
                    width: 250,
                    height: 33,
                    child: TextFormField(
                      controller: remark2,
                      decoration: UiDecoration().outlineTextFieldDecoration('Remark', ThemeColors.primary),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyles.customiseButton(ThemeColors.primary, ThemeColors.whiteColor, 100.0, 40.0),
            onPressed: (){},
            child: const Text('Add'),
          ),
          ElevatedButton(
            style: ButtonStyles.customiseButton(ThemeColors.primary, ThemeColors.whiteColor, 100.0, 40.0),
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      );
    },);
  }

}
