import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class UpdateBillDetailsAndLRList extends StatefulWidget {
  const UpdateBillDetailsAndLRList({Key? key}) : super(key: key);

  @override
  State<UpdateBillDetailsAndLRList> createState() =>
      _UpdateBillDetailsAndLRListState();
}

List<String> lr = ['Select LR Number', "1", "2", "3", "4", "5", "6"];

class _UpdateBillDetailsAndLRListState extends State<UpdateBillDetailsAndLRList>
    with Utility {
  String lrDropdown = lr.first;
  TextEditingController warehouse = TextEditingController();
  TextEditingController directBilling = TextEditingController();
  TextEditingController tollTax = TextEditingController();
  TextEditingController loadingUnloading = TextEditingController();
  TextEditingController multiLoadUnload = TextEditingController();
  TextEditingController incentive = TextEditingController();
  TextEditingController freightAdjustmentAddition = TextEditingController();
  TextEditingController latePenalty = TextEditingController();
  TextEditingController freightAdjustmentSubtraction = TextEditingController();
  TextEditingController damage = TextEditingController();
  TextEditingController haltDays = TextEditingController();
  TextEditingController haltAmount = TextEditingController();
  TextEditingController noOfPallets = TextEditingController();
  TextEditingController companyInvoiceNo = TextEditingController();
  TextEditingController loadingDate = TextEditingController();
  TextEditingController reportedDate = TextEditingController();
  TextEditingController unloadedDate = TextEditingController();
  TextEditingController freightAmount = TextEditingController();
  TextEditingController totalFreightAmount = TextEditingController();
  TextEditingController allRemark = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Update Bill Details and LR List"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Responsive(

              /// Mobile
              mobile: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  billDetails(),
                  const SizedBox(
                    height: 10,
                  ),
                  ledgerList(),
                ],
              ),

              /// Tablet
              tablet: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  billDetails(),
                  const SizedBox(
                    height: 10,
                  ),
                  ledgerList(),
                ],
              ),

              /// Desktop
              desktop: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  billDetails(),
                  const SizedBox(
                    height: 10,
                  ),
                  ledgerList(),
                ],
              )),
        ),
      ),
    );
  }

  billDetails() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: UiDecoration().formDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              TextDecorationClass().heading('Update Bill Details'),
              const SizedBox(
                width: 10,
              ),
              BStyles().button('Print', 'Print', "assets/print.png"),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    TextDecorationClass().subHeading2('Bill No :  '),
                    TextDecorationClass().heading2('83831'),
                    const SizedBox(
                      width: 20,
                    ),
                    UiDecoration().actionButton(
                        ThemeColors.editColor,
                        // Edit Icon
                        IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              showDialog(context: context, builder: (context) {
                                return  AlertDialog(
                                  title: const Text("Edit Bill no"),
                                  content: Container(
                                    width: 300,
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                    child: TextFormField(
                                      controller: TextEditingController(text: "83831"),
                                    ),
                                  ),
                                );
                              },);
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 15,
                              color: Colors.white,
                            ))),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    TextDecorationClass().subHeading2('Ledger :  '),
                    TextDecorationClass().heading2('UNITED BREWERIES LTD - KHURDA'),
                    const SizedBox(
                      width: 20,
                    ),
                    UiDecoration().actionButton(
                        ThemeColors.editColor,
                        IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              size: 15,
                              color: Colors.white,
                            ))),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    TextDecorationClass().subHeading2('Bill Date :  '),
                    TextDecorationClass().heading2('26-04-2023'),
                    const SizedBox(
                      width: 20,
                    ),
                    UiDecoration().actionButton(
                        ThemeColors.editColor,
                        IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              size: 15,
                              color: Colors.white,
                            ))),
                  ],
                ),
              ),
            ],
          ),
          heightBox20(),
          Row(
            children: [
              Row(
                children: [
                  UiDecoration().totalAmountLabel('Total Freight Amount',
                      backgroundColor: ThemeColors.primary,
                      foregroundColor: ThemeColors.whiteColor,
                      background: true),
                  UiDecoration().totalAmount('116000')
                ],
              ),
              widthBox20(),
              Row(
                children: [
                  UiDecoration().totalAmountLabel('Total Addition Amount',
                      backgroundColor: ThemeColors.orangeColor,
                      foregroundColor: ThemeColors.whiteColor,
                      background: true),
                  UiDecoration().totalAmount('2400')
                ],
              ),
              widthBox20(),
              Row(
                children: [
                  UiDecoration().totalAmountLabel('Total Subtraction Amount',
                      backgroundColor: ThemeColors.darkRedColor,
                      foregroundColor: ThemeColors.whiteColor,
                      background: true),
                  UiDecoration().totalAmount('2400')
                ],
              ),
              widthBox20(),
              Row(
                children: [
                  UiDecoration().totalAmountLabel('Grand Total Amount',
                      backgroundColor: ThemeColors.greenColor,
                      foregroundColor: ThemeColors.whiteColor,
                      background: true),
                  UiDecoration().totalAmount('118400')
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ledgerList() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: UiDecoration().formDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              TextDecorationClass().heading('LR List'),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              UiDecoration().dropDown(
                1,
                DropdownButton<String>(
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
                  value: lrDropdown,
                  elevation: 16,
                  style: TextDecorationClass().dropDownText(),
                  onChanged: (String? newValue) {
                    // This is called when the user selects an item.
                    setState(() {
                      lrDropdown = newValue!;
                    });
                  },
                  items: lr.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              widthBox20(),
              ElevatedButton(
                style: ButtonStyles.customiseButton(
                    Colors.grey.shade300, Colors.grey.shade900, 100.0, 43.0),
                onPressed: () {},
                child: Row(
                  children: const [ Icon(Icons.add),  Text('Add LR')],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey),
          ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    trailing: const Icon(CupertinoIcons.chevron_down,
                        color: ThemeColors.primaryColor),
                    title: Row(
                      children: [
                        TextDecorationClass().accountsHeading('1411667'),
                        TextDecorationClass()
                            .accountsHeading('UNITED BREWERIES LTD-KHURDA'),
                        TextDecorationClass().accountsHeading('MH20DE2345'),
                        TextDecorationClass().accountsHeading('Aurangabad'),
                        TextDecorationClass().accountsHeading('Khorda'),
                        widthBox5(),
                        ElevatedButton(
                          style: ButtonStyles.customiseButton(
                              ThemeColors.orangeColor,
                              ThemeColors.whiteColor,
                              50.0,
                              30.0),
                          onPressed: () {},
                          child: const Text('LR Edit'),
                        ),
                        widthBox5(),
                        UiDecoration().actionButton(
                            ThemeColors.deleteColor,
                            IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.delete,
                                  size: 19,
                                  color: Colors.white,
                                ))),
                      ],
                    ),
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "in Warehouse", "0", warehouse)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "in Direct Billing", "0", directBilling)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets()
                                  .formDetails8("Toll Tax", "0", tollTax)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Loading / Unloading",
                                  "0",
                                  loadingUnloading)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Multipoint Load / Unload",
                                  "0",
                                  multiLoadUnload)),
                        ],
                      ),
                      heightBox20(),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: FormWidgets()
                                  .formDetails8("Incentive", "0", incentive)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Freight Adjustment Addition",
                                  "0",
                                  freightAdjustmentAddition)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Late Penalty", "0", latePenalty)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Freight Adjustment Subtraction",
                                  "0",
                                  freightAdjustmentSubtraction)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets()
                                  .formDetails8("Damage", "0", damage)),
                        ],
                      ),
                      heightBox20(),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: FormWidgets()
                                  .formDetails8("Halt Days", "0", haltDays)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Halt Amount", "0", haltAmount)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Number Of Pallets", "0", noOfPallets)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Company Invoice Number",
                                  "0",
                                  companyInvoiceNo)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Loading Date", "0", loadingDate)),
                        ],
                      ),
                      heightBox20(),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Reported Date", "0", reportedDate)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Unloaded Date", "0", unloadedDate)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Freight Amount", "0", freightAmount)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Total Freight Amount",
                                  "0",
                                  totalFreightAmount)),
                          widthBox10(),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(''),
                                ElevatedButton(
                                  style: ButtonStyles.customiseButton(
                                      ThemeColors.greenColor,
                                      ThemeColors.whiteColor,
                                      10.0,
                                      40.0),
                                  onPressed: () {},
                                  child: const Text('Update'),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const Divider(
                    color: ThemeColors.primaryColor,
                  )
                ],
              );
            },
          ),
          heightBox20(),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  maxLines: 3,
                  controller: allRemark,
                  decoration: UiDecoration().longtextFieldDecoration2(
                      'Enter All Remark', ThemeColors.primary),
                ),
              ),
              widthBox20(),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ButtonStyles.customiseButton(
                      ThemeColors.greenColor, ThemeColors.whiteColor, 10.0, 55.0),
                  onPressed: () {},
                  child: const Text('Save Remark',style: TextStyle(fontSize: 18),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
