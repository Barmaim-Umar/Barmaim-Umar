import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class BillReceipt extends StatefulWidget {
  const BillReceipt({Key? key}) : super(key: key);

  @override
  State<BillReceipt> createState() => _BillReceiptState();
}

List<String> billNo = ['Select Bill Number', '10', '20', '30'];
List<String> type = ['Dr', 'Cr'];
List<String> accountType = ['Select Ledger','Cash', 'Bank'];
List<String> tds = ['TDS'];
List<String> billDeduction = ['Freight Bill Deduction'];
List<String> ledgerNameList = ['reliable services' , 'ledger2' , 'ledger3' , 'ledger4'];

class _BillReceiptState extends State<BillReceipt> {
  final formKey = GlobalKey<FormState>();
  FocusNode focusNode1 = FocusNode();
  TextEditingController organizationNameController = TextEditingController();
  TextEditingController outstandingAmount = TextEditingController();
  TextEditingController deductionAmount = TextEditingController();
  TextEditingController tdsAmount = TextEditingController();
  TextEditingController receivedAmount = TextEditingController();

  List billReceiptList = [];
  ScrollController scrollController = ScrollController();
  String billNoDropdown = billNo.first;
  String typeDropdown = type.first;
  String accountDropdown = accountType.first;
  String tdsDropdown = tds.first;
  String billDeductionDropdown = billDeduction.first;
  String ledgerNameDropdown = ledgerNameList.first;
  TextEditingController date =TextEditingController();

  int totalReceivedAmount = 0;
  int totalTDSAmount = 0;
  int totalDeductionAmount = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController totalAmount = TextEditingController(text: totalReceivedAmount.toString());
    TextEditingController tdsTotalAmount = TextEditingController(text: totalTDSAmount.toString());
    TextEditingController deductionTotalAmount = TextEditingController(text: totalDeductionAmount.toString());
    return Scaffold(
      appBar: UiDecoration.appBar('Bill Receipt'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: UiDecoration().formDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                   Align(
                      alignment: Alignment.center,
                      child:DropdownDecoration().dropdownDecoration(DropdownButton<String>(
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: ThemeColors.whiteColor,
                        underline: Container(
                          decoration:
                          const BoxDecoration(border: Border()),
                        ),
                        isExpanded: true,
                        icon: const Icon(
                          CupertinoIcons.chevron_down,
                          color: ThemeColors.darkBlack,
                          size: 20,
                        ),
                        iconSize: 30,
                        value: ledgerNameDropdown,
                        elevation: 16,
                        style: TextDecorationClass().dropDownText(),
                        onChanged: (String? newValue) {
                          // This is called when the user selects an item.
                          setState(() {
                            ledgerNameDropdown = newValue!;
                          });
                        },
                        items: ledgerNameList.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value),
                              );
                            }).toList(),
                      )),
                      // Text(
                      //   'reliable services',
                      //   style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                      // )
                  ),
                  const Divider(),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Spacer(),
                            // Refresh Button
                            Container(
                              decoration: BoxDecoration(
                                // color: ThemeColors.primary,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: IconButton(onPressed: () {

                              }, icon: const Icon(Icons.refresh , color: Colors.black,)),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextDecorationClass().heading1('Select Bill Number'),
                                  UiDecoration().dropDown(0, DropdownButton<String>(
                                    borderRadius: BorderRadius.circular(5),
                                    dropdownColor: ThemeColors.whiteColor,
                                    underline: Container(
                                      decoration:
                                      const BoxDecoration(border: Border()),
                                    ),
                                    isExpanded: true,
                                    icon: const Icon(
                                      CupertinoIcons.chevron_down,
                                      color: ThemeColors.darkBlack,
                                      size: 20,
                                    ),
                                    iconSize: 30,
                                    value: billNoDropdown,
                                    elevation: 16,
                                    style: TextDecorationClass().dropDownText(),
                                    onChanged: (String? newValue) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        billNoDropdown = newValue!;
                                      });
                                    },
                                    items: billNo.map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value.toString(),
                                            child: Text(value),
                                          );
                                        }).toList(),
                                  ),),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            // Outstanding Amount
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextDecorationClass().heading1("Outstanding"),
                                  TextFormField(
                                    controller: outstandingAmount,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: UiDecoration().outlineTextFieldDecoration('Amount', ThemeColors.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            // Deduction Amount
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextDecorationClass().heading1("Deduction"),
                                  TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    controller: deductionAmount,
                                    decoration: UiDecoration()
                                        .outlineTextFieldDecoration(
                                        "Amount", ThemeColors.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            // TDS Amount
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextDecorationClass().heading1('TDS'),
                                  TextFormField(
                                    controller: tdsAmount,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: UiDecoration()
                                        .outlineTextFieldDecoration(
                                        "Amount", ThemeColors.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            // Received Amount
                            Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextDecorationClass().heading1('Received'),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: receivedAmount,
                                      decoration: UiDecoration()
                                          .outlineTextFieldDecoration(
                                          "Amount", ThemeColors.primaryColor),
                                    ),
                                  ],
                                )
                            ),
                            const SizedBox(
                              width: 50,
                            ),

                            // add button
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                  color: ThemeColors.primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextButton(
                                child: const Text("Add" , style: TextStyle(color: Colors.white , fontSize: 17),),
                                  onPressed: () {
                                    if (billNoDropdown.isEmpty) {
                                      AlertBoxes.flushBarErrorMessage(
                                          "Select Bill Number", context);
                                    } else if (outstandingAmount.text.isEmpty) {
                                      AlertBoxes.flushBarErrorMessage(
                                          "Enter Outstanding Amount", context);
                                    } else if (deductionAmount.text.isEmpty) {
                                      AlertBoxes.flushBarErrorMessage(
                                          "Enter Deduction Amount", context);
                                    } else if (tdsAmount.text.isEmpty) {
                                      AlertBoxes.flushBarErrorMessage(
                                          "Enter TDS Amount", context);
                                    } else if (receivedAmount
                                        .text.isEmpty) {
                                      AlertBoxes.flushBarErrorMessage(
                                          "Enter Received Amount", context);
                                    } else {
                                      setState(() {
                                        billReceiptList.add({
                                          "bill_no": billNoDropdown,
                                          "outstanding_amount":
                                          outstandingAmount.text,
                                          "deduction_amount": deductionAmount.text,
                                          "tds_amount": tdsAmount.text,
                                          "received_amount":
                                          receivedAmount.text
                                        });
                                        billNoDropdown=billNo.first;

                                        outstandingAmount.clear();
                                        deductionAmount.clear();
                                        tdsAmount.clear();
                                        receivedAmount.clear();

                                        totalReceivedAmount += int.parse(billReceiptList[billReceiptList.length-1]["received_amount"]);
                                        totalTDSAmount += int.parse(billReceiptList[billReceiptList.length-1]["tds_amount"]);
                                        totalDeductionAmount += int.parse(billReceiptList[billReceiptList.length-1]["deduction_amount"]);

                                        // Assigning values to Controllers
                                        totalAmount.text = totalReceivedAmount.toString();
                                        tdsTotalAmount.text = totalTDSAmount.toString();
                                        deductionTotalAmount.text = totalDeductionAmount.toString();
                                      });
                                    }
                                  },
                                  ),
                            ),

                            const Spacer(),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        /// Bill List Divider
                        billReceiptList.isEmpty
                            ? const SizedBox()
                            : Row(
                          children: const [
                            Expanded(
                              child: SizedBox(),
                            ),
                            Text(
                              "Bill List",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(flex: 12, child: Divider()),
                            Spacer()
                          ],
                        ),
                        ListView.builder(
                          controller: scrollController,
                          itemCount: billReceiptList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                const Spacer(),

                                // Organization Name
                                Expanded(
                                    flex: 2,
                                    child: UiDecoration().addMore(billReceiptList[index]["bill_no"].toString())),
                                const SizedBox(
                                  width: 50,
                                ),
                                // From Date
                                Expanded(
                                    flex: 2,
                                    child: UiDecoration().addMore(billReceiptList[index]["outstanding_amount"].toString())),
                                const SizedBox(
                                  width: 50,
                                ),
                                // To Date
                                Expanded(
                                    flex: 2,
                                    child: UiDecoration().addMore(billReceiptList[index]["deduction_amount"].toString())),
                                const SizedBox(
                                  width: 50,
                                ),
                                // No Of Months
                                Expanded(
                                    flex: 2,
                                    child: UiDecoration().addMore(billReceiptList[index]["tds_amount"].toString())),
                                const SizedBox(
                                  width: 50,
                                ),
                                // Reason For Leaving
                                Expanded(
                                    flex: 2,
                                    child: UiDecoration().addMore(billReceiptList[index]["received_amount"].toString())),
                                const SizedBox(
                                  width: 50,
                                ),

                                // delete button
                                Container(
                                  decoration: BoxDecoration(
                                      color: ThemeColors.darkRedColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {

                                          totalReceivedAmount -= int.parse(billReceiptList[index]["received_amount"]);
                                          totalTDSAmount -= int.parse(billReceiptList[index]["tds_amount"]);
                                          totalDeductionAmount -= int.parse(billReceiptList[index]["deduction_amount"]);

                                          billReceiptList.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.delete,
                                        size: 20,
                                      )),
                                ),
                                const Spacer()
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 100),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1(''),
                              UiDecoration().dropDown(0, DropdownButton<String>(
                                borderRadius: BorderRadius.circular(5),
                                dropdownColor: ThemeColors.whiteColor,
                                underline: Container(
                                  decoration:
                                  const BoxDecoration(border: Border()),
                                ),
                                isExpanded: true,
                                icon: const Icon(
                                  CupertinoIcons.chevron_down,
                                  color: ThemeColors.darkBlack,
                                  size: 20,
                                ),
                                iconSize: 30,
                                value: typeDropdown,
                                elevation: 16,
                                style: TextDecorationClass().dropDownText(),
                                onChanged: (String? newValue) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    typeDropdown = newValue!;
                                  });
                                },
                                items: type.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value.toString(),
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),width: 70),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1('Cash/Bank'),
                              UiDecoration().dropDown(0, DropdownButton<String>(
                                borderRadius: BorderRadius.circular(5),
                                dropdownColor: ThemeColors.whiteColor,
                                underline: Container(
                                  decoration:
                                  const BoxDecoration(border: Border()),
                                ),
                                isExpanded: true,
                                icon: const Icon(
                                  CupertinoIcons.chevron_down,
                                  color: ThemeColors.darkBlack,
                                  size: 20,
                                ),
                                iconSize: 30,
                                value: accountDropdown,
                                elevation: 16,
                                style: TextDecorationClass().dropDownText(),
                                onChanged: (String? newValue) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    accountDropdown = newValue!;
                                  });
                                },
                                items: accountType.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value.toString(),
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDecorationClass().heading1('Total Amount'),
                                TextFormField(
                                  controller: totalAmount,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: UiDecoration()
                                      .outlineTextFieldDecoration(
                                      "Total Received Amount", ThemeColors.primaryColor),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1(''),
                              UiDecoration().dropDown(0, DropdownButton<String>(
                                borderRadius: BorderRadius.circular(5),
                                dropdownColor: ThemeColors.whiteColor,
                                underline: Container(
                                  decoration:
                                  const BoxDecoration(border: Border()),
                                ),
                                isExpanded: true,
                                icon: const Icon(
                                  CupertinoIcons.chevron_down,
                                  color: ThemeColors.darkBlack,
                                  size: 20,
                                ),
                                iconSize: 30,
                                value: typeDropdown,
                                elevation: 16,
                                style: TextDecorationClass().dropDownText(),
                                onChanged: (String? newValue) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    typeDropdown = newValue!;
                                  });
                                },
                                items: type.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value.toString(),
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),width: 70),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1('TDS'),
                              UiDecoration().dropDown(0, DropdownButton<String>(
                                borderRadius: BorderRadius.circular(5),
                                dropdownColor: ThemeColors.whiteColor,
                                underline: Container(
                                  decoration:
                                  const BoxDecoration(border: Border()),
                                ),
                                isExpanded: true,
                                icon: const Icon(
                                  CupertinoIcons.chevron_down,
                                  color: ThemeColors.darkBlack,
                                  size: 20,
                                ),
                                iconSize: 30,
                                value: tdsDropdown,
                                elevation: 16,
                                style: TextDecorationClass().dropDownText(),
                                onChanged: (String? newValue) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    tdsDropdown = newValue!;
                                  });
                                },
                                items: tds.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value.toString(),
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDecorationClass().heading1('Total Amount'),
                                TextFormField(
                                  readOnly: true,
                                  controller: tdsTotalAmount,
                                  decoration: UiDecoration()
                                      .outlineTextFieldDecoration(
                                      "Total TDS Amount", ThemeColors.primaryColor),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1(''),
                              UiDecoration().dropDown(0, DropdownButton<String>(
                                borderRadius: BorderRadius.circular(5),
                                dropdownColor: ThemeColors.whiteColor,
                                underline: Container(
                                  decoration:
                                  const BoxDecoration(border: Border()),
                                ),
                                isExpanded: true,
                                icon: const Icon(
                                  CupertinoIcons.chevron_down,
                                  color: ThemeColors.darkBlack,
                                  size: 20,
                                ),
                                iconSize: 30,
                                value: typeDropdown,
                                elevation: 16,
                                style: TextDecorationClass().dropDownText(),
                                onChanged: (String? newValue) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    typeDropdown = newValue!;
                                  });
                                },
                                items: type.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value.toString(),
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),width: 70),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1('Bill Deduction'),
                              UiDecoration().dropDown(0, DropdownButton<String>(
                                borderRadius: BorderRadius.circular(5),
                                dropdownColor: ThemeColors.whiteColor,
                                underline: Container(
                                  decoration:
                                  const BoxDecoration(border: Border()),
                                ),
                                isExpanded: true,
                                icon: const Icon(
                                  CupertinoIcons.chevron_down,
                                  color: ThemeColors.darkBlack,
                                  size: 20,
                                ),
                                iconSize: 30,
                                value: billDeductionDropdown,
                                elevation: 16,
                                style: TextDecorationClass().dropDownText(),
                                onChanged: (String? newValue) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    billDeductionDropdown = newValue!;
                                  });
                                },
                                items: billDeduction.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value.toString(),
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDecorationClass().heading1('Total Amount'),
                                TextFormField(
                                  readOnly: true,
                                  controller: deductionTotalAmount,
                                  decoration: UiDecoration()
                                      .outlineTextFieldDecoration(
                                      "Total Deduction Amount", ThemeColors.primaryColor),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1('Narration'),
                              TextFormField(
                                maxLines: 3,
                                decoration: UiDecoration().longtextFieldDecoration2('Narration', ThemeColors.primaryColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextDecorationClass().heading1("Date"),
                              TextFormField(
                                maxLines: 1,
                                readOnly: true,
                                controller: date,
                                decoration: UiDecoration().outlineTextFieldDecoration("Date", Colors.grey),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Tenure To Field is Required';
                                  }
                                  return null;
                                },
                                onTap: (){
                                  UiDecoration().showDatePickerDecoration(context).then((value){
                                    setState(() {
                                      String month = value.month.toString().padLeft(2, '0');
                                      String day = value.day.toString().padLeft(2, '0');
                                      date.text = "${value.year}-$month-$day";
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48.0,left: 20,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ButtonStyles.smallButton(Colors.grey, Colors.white),
                      onPressed: (){},
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      style: ButtonStyles.smallButton(ThemeColors.primaryColor, Colors.white),
                      onPressed: (){},
                      child: const Text('Save'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
