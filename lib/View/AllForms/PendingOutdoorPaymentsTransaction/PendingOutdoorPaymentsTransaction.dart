import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class PendingOutdoorPaymentsTransaction extends StatefulWidget {
  const PendingOutdoorPaymentsTransaction({Key? key}) : super(key: key);

  @override
  State<PendingOutdoorPaymentsTransaction> createState() => _PendingOutdoorPaymentsTransactionState();
}

List<String> entriesDropdownList = ["10", "20", "30", "40"];
List<String> ledgerDropdownList = ['select ledger',"10", "20", "30", "40"];
List<String> advanceMethodDropdownList = ['select advance method',"10", "20", "30", "40"];
List<String> ledgerList = ['select ledger',"10", "20", "30", "40"];

class _PendingOutdoorPaymentsTransactionState extends State<PendingOutdoorPaymentsTransaction> with Utility {

  final List<Map> pendingPaymentList = [
    {'date': '02-12-2001', 'particulars': 'cash-PFC office', 'vehicle_no': 'MH20DR9546', 'voucher_type': 'Outdoor', 'debit': '8500', 'credit': '', 'narration': 'CP To TALOJA ADV'},
    {'date': '02-12-2001', 'particulars': 'cash-PFC office', 'vehicle_no': 'MH20DR9546', 'voucher_type': 'Outdoor', 'debit': '', 'credit': '9500', 'narration': ''},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar('Transactions'),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // buttons
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Row(
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
                    ],
                  ),
                  widthBox10(),
                  Expanded(
                    flex: 2,
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
                              columnSpacing: 100,
                              columns: [
                                DataColumn(label: TextDecorationClass().dataColumnName("Date")),
                                DataColumn(label: TextDecorationClass().dataColumnName("")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Particulars")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Vehicle No.")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Voucher Type")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Debit")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Credit")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Narration")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Action")),
                              ],
                              rows:  List.generate(pendingPaymentList.length, (index) {
                                return DataRow(
                                  //Check Odd Even
                                    color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
                                    cells: [
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['date'].toString())),
                                      DataCell(
                                          UiDecoration().actionButton( ThemeColors.editColor,IconButton(padding: const EdgeInsets.all(0),
                                              onPressed: () {},
                                              icon: const Icon(Icons.edit, size: 15, color: Colors.white,)))
                                      ),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['particulars'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['vehicle_no'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['voucher_type'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['debit'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['credit'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(pendingPaymentList[index]['narration'].toString())),
                                      DataCell(Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                        child: pendingPaymentList[index]['narration']==''?UiDecoration().actionButton( ThemeColors.editColor,IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                                        }, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))):
                                        UiDecoration().actionButton( ThemeColors.deleteColor,IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                                        }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),
                                      ))
                                    ]);
                              })
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: UiDecoration().totalAmountLabel('Total Debit')),
                          Expanded(
                              child: UiDecoration().totalAmount('8500')),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: UiDecoration().totalAmountLabel('Total Credit')),
                          Expanded(
                              child: UiDecoration().totalAmount('9500')),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: UiDecoration().totalAmountLabel('Total Difference')),
                          Expanded(
                              child: UiDecoration().totalAmount('-1000')),
                        ],
                      ),
                      heightBox10(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
