import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/View/AllForms/UpdateBillDetails%20&%20LRList/BillsPrint.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class UpdateBillDetailsAndLRList extends StatefulWidget {
  const UpdateBillDetailsAndLRList({Key? key, this.billNumber = "", this.ledger = "", this.date = ""})
      : super(key: key);
  final String billNumber;
  final String ledger;
  final String date;

  @override
  State<UpdateBillDetailsAndLRList> createState() =>
      _UpdateBillDetailsAndLRListState();
}

List<String> lr = ['Select LR Number', "1", "2", "3", "4", "5", "6"];
List BillsLRsData = [];
class _UpdateBillDetailsAndLRListState extends State<UpdateBillDetailsAndLRList>
    with Utility {
  String lrDropdown = lr.first;

  List<TextEditingController> warehouseController = [];

  List<TextEditingController> directBillingController = [];
  List<TextEditingController> tollTaxController = [];
  List<TextEditingController> loadingUnloadingController = [];
  List<TextEditingController> multipointLoadUnloadController = [];
  List<TextEditingController> incentiveController = [];
  List<TextEditingController> freightAdjustmentAdditionController = [];
  List<TextEditingController> latePenaltyController = [];
  List<TextEditingController> freightAdjustmentSubtractionController = [];
  List<TextEditingController> damageController = [];
  List<TextEditingController> haltDaysController = [];
  List<TextEditingController> haltAmountController = [];
  List<TextEditingController> noOfPalletsController = [];
  List<TextEditingController> companyInvoiceNoController = [];
  List<TextEditingController> loadingDateController = [];
  List<TextEditingController> reportedDateController = [];
  List<TextEditingController> unloadedDateController = [];
  List<TextEditingController> freightAmountController = [];
  List<TextEditingController> totalFreightAmountController = [];
  List<TextEditingController> allRemarkController = [];


  // #####################################
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
  List receivedLrTable = [];
  List selectedRows = [];
  List selectedReceivedLRIdsList = [];
  int selectedReceivedLRId = -1;
  TextEditingController searchController = TextEditingController();
  String lrId = '0';
  int freshload = 0;
  bool update = false;
  String totalFreightAmountSum = '';
  double sum = 0.0;

  getBillsLRsApiFunc() {
    setState(() {
      freshload = 1;
    });
    getBillsLRsApi().then((value) {
      var info = jsonDecode(value);
      print(info);
      if (info['success'] = true) {
        BillsLRsData.clear();
        BillsLRsData.addAll(info['data']);

        warehouseController = List.generate(info['data'].length, (index) => TextEditingController());
        directBillingController = List.generate(info['data'].length, (index) => TextEditingController());
        tollTaxController = List.generate(info['data'].length, (index) => TextEditingController());
        loadingUnloadingController = List.generate(info['data'].length, (index) => TextEditingController());
        multipointLoadUnloadController = List.generate(info['data'].length, (index) => TextEditingController());
        incentiveController = List.generate(info['data'].length, (index) => TextEditingController());
        freightAdjustmentAdditionController = List.generate(info['data'].length, (index) => TextEditingController());
        latePenaltyController = List.generate(info['data'].length, (index) => TextEditingController());
        freightAdjustmentSubtractionController = List.generate(info['data'].length, (index) => TextEditingController());
        damageController = List.generate(info['data'].length, (index) => TextEditingController());
        haltDaysController = List.generate(info['data'].length, (index) => TextEditingController());
        haltAmountController = List.generate(info['data'].length, (index) => TextEditingController());
        noOfPalletsController = List.generate(info['data'].length, (index) => TextEditingController());
        companyInvoiceNoController = List.generate(info['data'].length, (index) => TextEditingController());
        loadingDateController = List.generate(info['data'].length, (index) => TextEditingController());
        reportedDateController = List.generate(info['data'].length, (index) => TextEditingController());
        unloadedDateController = List.generate(info['data'].length, (index) => TextEditingController());
        freightAmountController = List.generate(info['data'].length, (index) => TextEditingController());
        totalFreightAmountController = List.generate(info['data'].length, (index) => TextEditingController());
        allRemarkController = List.generate(info['data'].length, (index) => TextEditingController());

        for(int i=0; i<warehouseController.length; i++){
          warehouseController[i].text = info['data'][i]['detention_in_warehouse'].toString();
          directBillingController[i].text = info['data'][i]['detention_for_direct_billing'].toString();
          tollTaxController[i].text = info['data'][i]['toll_tax'].toString();
          loadingUnloadingController[i].text = info['data'][i]['loading_unloading_amount'].toString();
          multipointLoadUnloadController[i].text = info['data'][i]['multipoint_load_unloading'].toString();
          incentiveController[i].text = info['data'][i]['incentive'].toString();
          freightAdjustmentAdditionController[i].text = info['data'][i]['freight_adjustment_addition'].toString();
          latePenaltyController[i].text = info['data'][i]['late_penalty'].toString();
          freightAdjustmentSubtractionController[i].text = info['data'][i]['freight_adjustment_subtraction'].toString();
          damageController[i].text = info['data'][i]['damage'].toString();
          haltDaysController[i].text = info['data'][i]['halt_days'].toString();
          haltAmountController[i].text = info['data'][i]['halt_amount'].toString();
          noOfPalletsController[i].text = info['data'][i]['no_of_pallets'].toString();
          companyInvoiceNoController[i].text = info['data'][i]['lr_invoice_number'].toString();
          // loadingDateController[i].text = info['data'][i]['detention_in_warehouse'].toString();
          reportedDateController[i].text = info['data'][i]['reported_date'].toString();
          unloadedDateController[i].text = info['data'][i]['unloaded_date'].toString();
          freightAmountController[i].text = info['data'][i]['freight_amount'].toString();
          totalFreightAmountController[i].text = info['data'][i]['total_freight_amount'].toString();
          // allRemarkController[i].text = info['data'][i]['detention_in_warehouse'].toString();
        }

        // for (int i = 0; i < BillsLRsData.length; i++) {
        //   warehouse.text = info['data'][i]['detention_in_warehouse'].toString();
        //   directBilling.text =
        //       info['data'][i]['detention_for_direct_billing'].toString();
        //
        //   tollTax.text = info['data'][i]['toll_tax'].toString();
        //   loadingUnloading.text =
        //       info['data'][i]['loading_unloading_amount'].toString();
        //   multiLoadUnload.text =
        //       info['data'][i]['multipoint_load_unloading'].toString();
        //   incentive.text = info['data'][i]['incentive'].toString();
        //   freightAdjustmentAddition.text =
        //       info['data'][i]['freight_adjustment_addition'].toString();
        //   latePenalty.text = info['data'][i]['late_penalty'].toString();
        //   freightAdjustmentSubtraction.text =
        //       info['data'][i]['freight_adjustment_subtraction'].toString();
        //   damage.text = info['data'][i]['damage'].toString();
        //   haltDays.text = info['data'][i]['halt_days'].toString();
        //   haltAmount.text = info['data'][i]['halt_amount'].toString();
        //   noOfPallets.text = info['data'][i]['no_of_pallets'].toString();
        //   companyInvoiceNo.text =
        //       info['data'][i]['lr_invoice_number'].toString();
        //   // loadingDate.text = info['data'][i]['lr_invoice_number'].toString();
        //   reportedDate.text = info['data'][i]['reported_date'].toString();
        //   unloadedDate.text = info['data'][i]['unloaded_date'].toString();
        //   freightAmount.text = info['data'][i]['freight_amount'].toString();
        //   totalFreightAmount.text =
        //       info['data'][i]['total_freight_amount'].toString();
        // }

            setState(() {
            freshload = 0;
            });


      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setState(() {
          freshload = 0;
        });
      }
    });
  }

  addLrApiFunc(){
    addLrApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }
  billUpdateApiFunc(int index){
    billUpdateApi(index).then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        setState(() {
          update = false;
        });
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  void initState() {
    getBillsLRsApiFunc();
    // TODO: implement initState
    super.initState();
  }

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
              BStyles().button(
                'Print',
                'Print',
                "assets/print.png",
                onPressed: () {
                  //
                  generateBillAndPrint(
                      BillsLRsData: BillsLRsData,
                      billNo: widget.billNumber,
                    date: widget.date,
                    ledger: widget.ledger
                  );
                },
              ),
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
                    TextDecorationClass().heading2(widget.billNumber.toString()),
                    const SizedBox(
                      width: 20,
                    ),
                    UiDecoration().actionButton(
                        ThemeColors.editColor,
                        // Edit Icon
                        IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Edit Bill no"),
                                    content: Container(
                                      width: 300,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: "83831"),
                                      ),
                                    ),
                                  );
                                },
                              );
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
                    TextDecorationClass()
                        .heading2(widget.ledger.toString()),
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
                    TextDecorationClass().heading2(widget.date.toString()),
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
                  UiDecoration().totalAmountLabel(totalFreightAmountSum,
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

              Expanded(
                child: SearchDropdownWidget(
                  dropdownList: lr,
                  hintText: 'Entries',
                  onChanged: (String? newValue) {
                    // This is called when the user selects an item.
                    setState(() {
                      lrDropdown = newValue!;
                    });
                  },
                  selectedItem: lrDropdown,
                  maxHeight: 200,
                  showSearchBox: false,
                ),
              ),
              // UiDecoration().dropDown(
              //   1,
              //   DropdownButton<String>(
              //     borderRadius: BorderRadius.circular(5),
              //     dropdownColor: ThemeColors.whiteColor,
              //     underline: Container(
              //       decoration: const BoxDecoration(border: Border()),
              //     ),
              //     isExpanded: true,
              //     hint: const Text(
              //       'Entries',
              //       style: TextStyle(color: ThemeColors.darkBlack),
              //     ),
              //     icon: const Icon(
              //       CupertinoIcons.chevron_down,
              //       color: ThemeColors.darkBlack,
              //       size: 20,
              //     ),
              //     iconSize: 30,
              //     value: lrDropdown,
              //     elevation: 16,
              //     style: TextDecorationClass().dropDownText(),
              //     onChanged: (String? newValue) {
              //       // This is called when the user selects an item.
              //       setState(() {
              //         lrDropdown = newValue!;
              //       });
              //     },
              //     items: lr.map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value.toString(),
              //         child: Text(value),
              //       );
              //     }).toList(),
              //   ),
              // ),
              widthBox20(),
              ElevatedButton(
                style: ButtonStyles.customiseButton(
                    Colors.grey.shade300, Colors.grey.shade900, 100.0, 43.0),
                onPressed: () {
                  getReceivedLRsApiFunc();
                },
                child: Row(
                  children: const [Icon(Icons.add), Text('Add LR')],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey),
          freshload == 1 ? const Center(child: CircularProgressIndicator()) : ListView.builder(
            itemCount: BillsLRsData.length,
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
                        TextDecorationClass().accountsHeading(BillsLRsData[index]['lr_number'].toString()),
                        TextDecorationClass()
                            .accountsHeading(BillsLRsData[index]['ledger_title'].toString()),
                        TextDecorationClass().accountsHeading(BillsLRsData[index]['vehicle_number'].toString()),
                        TextDecorationClass().accountsHeading(BillsLRsData[index]['lr_from_location'].toString()),
                        TextDecorationClass().accountsHeading(BillsLRsData[index]['lr_to_location'].toString()),
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
                                  "in Warehouse", "0", warehouseController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "in Direct Billing", "0", directBillingController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets()
                                  .formDetails8("Toll Tax", "0", tollTaxController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Loading / Unloading",
                                  "0",
                                  loadingUnloadingController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Multipoint Load / Unload",
                                  "0",
                                  multipointLoadUnloadController[index])),
                        ],
                      ),
                      heightBox20(),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: FormWidgets()
                                  .formDetails8("Incentive", "0", incentiveController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Freight Adjustment Addition",
                                  "0",
                                  freightAdjustmentAdditionController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Late Penalty", "0", latePenaltyController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Freight Adjustment Subtraction",
                                  "0",
                                  freightAdjustmentSubtractionController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets()
                                  .formDetails8("Damage", "0", damageController[index])),
                        ],
                      ),
                      heightBox20(),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: FormWidgets()
                                  .formDetails8("Halt Days", "0", haltDaysController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Halt Amount", "0", haltAmountController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Number Of Pallets", "0", noOfPalletsController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Company Invoice Number",
                                  "0",
                                  companyInvoiceNoController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Loading Date", "0", loadingDateController[index])),
                        ],
                      ),
                      heightBox20(),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Reported Date", "0", reportedDateController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().formDetails8(
                                  "Unloaded Date", "0", unloadedDateController[index])),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().numberField2(
                                  "Freight Amount", "0", freightAmountController[index], context)),
                          widthBox10(),
                          Expanded(
                              flex: 1,
                              child: FormWidgets().numberField2(
                                  "Total Freight Amount",
                                  "0",
                                  totalFreightAmountController[index],
                                  context,
                                onChanged: (value) {
                                  totalFreightAmountAddition(index);
                                },
                              )),
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
                                  onPressed: () {
                                    billUpdateApiFunc(index);
                                  },
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
                  style: ButtonStyles.customiseButton(ThemeColors.greenColor,
                      ThemeColors.whiteColor, 10.0, 55.0),
                  onPressed: () {},
                  child: const Text(
                    'Save Remark',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ============== START ==================

  _showLrList(){
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState)
            {
              // for checkbox
              onSelectedRow(bool selected, int index) {
                setState(() {
                  if (selected) {
                    selectedRows.add(index);
                    selectedReceivedLRIdsList.add(receivedLrTable[index]['lr_id']);
                    selectedReceivedLRId = receivedLrTable[index]['lr_id'];
                  } else {
                    selectedRows.remove(index);
                    selectedReceivedLRIdsList.remove(receivedLrTable[index]['lr_id']);
                    // selectedPayableId = -1;
                  }
                });
              }

              return
                  AlertDialog(
                    title: Row(
                      children: [
                        const Text("Add New Lr"),
                        const Spacer(),
                        Expanded(
                          child: TextFormField(
                              onFieldSubmitted: (value) {
                                Navigator.pop(context);
                                getReceivedLRsApiFunc();
                              },
                              controller: searchController,
                              decoration: UiDecoration().outlineTextFieldDecoration(
                                  'Search', ThemeColors.primaryColor)),
                        ),
                      ],
                    ),
                    content: Column(
                      children: [
                        buildDataTable(onSelectedRow, context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Total Records: ${GlobalVariable.totalRecords}"),

                            const SizedBox(
                              width: 100,
                            ),

                            // First Page Button
                            IconButton(
                                onPressed: !GlobalVariable.prev
                                    ? null
                                    : () {
                                  setState(() {
                                    GlobalVariable.currentPage = 1;
                                    Navigator.pop(context);
                                    getReceivedLRsApiFunc();
                                  });
                                },
                                icon: const Icon(Icons.first_page)),

                            // Prev Button
                            IconButton(
                                onPressed: GlobalVariable.prev == false
                                    ? null
                                    : () {
                                  setState(() {
                                    GlobalVariable.currentPage > 1
                                        ? GlobalVariable.currentPage--
                                        : GlobalVariable.currentPage = 1;
                                    Navigator.pop(context);
                                    getReceivedLRsApiFunc();
                                  });
                                },
                                icon: const Icon(Icons.chevron_left)),

                            const SizedBox(
                              width: 30,
                            ),

                            // Next Button
                            IconButton(
                                onPressed: GlobalVariable.next == false
                                    ? null
                                    : () {
                                  setState(() {
                                    GlobalVariable.currentPage++;
                                    Navigator.pop(context);
                                    getReceivedLRsApiFunc();
                                  });
                                },
                                icon: const Icon(Icons.chevron_right)),

                            // Last Page Button
                            IconButton(
                                onPressed: !GlobalVariable.next
                                    ? null
                                    : () {
                                  setState(() {
                                    GlobalVariable.currentPage =
                                        GlobalVariable.totalPages;
                                    Navigator.pop(context);
                                    getReceivedLRsApiFunc();
                                  });
                                },
                                icon: const Icon(Icons.last_page)),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeColors.primary,
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        onPressed: () {

                          Navigator.pop(context);

                        },
                        child: const Text("Close"),
                      )
                    ],
                  );

                });
        },
    );
  }



  Widget buildDataTable(onSelectedRow, BuildContext context) {
    double totalDebit = 0;
    double totalCredit = 0;
    return
      /* transactionList.isEmpty ? const Center(child: Text("Select Leger"),) : */
      freshload == 1
          ? const Center(child: CircularProgressIndicator())
          : DataTable(
          columnSpacing: 55,
          showCheckboxColumn: false,
          columns: const [
            // DataColumn(label: Text('Mark',overflow: TextOverflow.ellipsis,)),
            DataColumn(
                label: Text(
                  'LR No ',
                  overflow: TextOverflow.ellipsis,
                )),
            DataColumn(
                label: Text(
                  'Ledger',
                  overflow: TextOverflow.ellipsis,
                )),
            DataColumn(
                label: Text(
                  'vehicle No',
                  overflow: TextOverflow.ellipsis,
                )),
            DataColumn(
                label: Text(
                  'From Location',
                  overflow: TextOverflow.ellipsis,
                )),
            DataColumn(
                label: Text(
                  'TO Location',
                  overflow: TextOverflow.ellipsis,
                )),
            DataColumn(
                label: Text(
                  'LR Date',
                  overflow: TextOverflow.ellipsis,
                )),
            DataColumn(
                label: Text(
                  'Received Date',
                  overflow: TextOverflow.ellipsis,
                )),
            DataColumn(
                label: Text(
                  'Add LR',
                  overflow: TextOverflow.ellipsis,
                )),
          ],
          rows: List.generate(receivedLrTable.length, (index) {
            // Calculate totals
            // if (transactionList[0][index]['debit'] != null) {
            //   totalDebit += double.parse( transactionList[0][index]['debit'] == '' ? '0' : transactionList[0][index]['debit'] );
            // }
            // if (transactionList[0][index]['credit'] != null) {
            //   totalCredit += double.parse(transactionList[0][index]['credit'] == '' ? '0' : transactionList[0][index]['credit']);
            // }
            return DataRow(
                selected: selectedRows.contains(index),
                onSelectChanged: (value) {
                  lrId = value! ?  receivedLrTable[index]['lr_id'].toString(): '0';
                  onSelectedRow(value!, index);
                },
                color: index == 0 || index % 2 == 0
                    ? MaterialStatePropertyAll(ThemeColors.tableRowColor)
                    : const MaterialStatePropertyAll(Colors.white),
                cells: [
                  // DataCell(Text("data")),
                  DataCell(Text(
                      receivedLrTable[index]['lr_number'].toString())),
                  DataCell(Text(
                      receivedLrTable[index]['ledger_title'].toString())),
                  DataCell(Text(receivedLrTable[index]['vehicle_number']
                      .toString())),
                  DataCell(Text(receivedLrTable[index]['from_location']
                      .toString())),
                  DataCell(Text(
                      receivedLrTable[index]['to_location'].toString())),
                  DataCell(
                      Text(receivedLrTable[index]['lr_date'].toString())),
                  DataCell(Text(receivedLrTable[index]['received_date']
                      .toString())),

                  DataCell(ElevatedButton(
                    style: ButtonStyles.customiseButton(
                        ThemeColors.primary,
                        ThemeColors.whiteColor,
                        70.0,
                        35.0),
                    onPressed: () {
                      lrId =  receivedLrTable[index]['lr_id'].toString();
                      addLrApiFunc();
                      Navigator.pop(context);
                      getBillsLRsApiFunc();
                    },
                    child: const Text('+ Add'),
                  )),
                ]);
          })
      );
  }

  // Calculating Total Freight Amount
  totalFreightAmountAddition(int i){

      sum += double.parse(totalFreightAmountController[i].text.isEmpty ? '0.0' : totalFreightAmountController[i].text);

    setState(() {
      totalFreightAmountSum = sum.toString();
    });
  }

  /// lr table api
  getReceivedLRsApiFunc() {
    setState(() {
      freshload = 1;
    });
    getReceivedLRsApi().then((value) {
      var info = jsonDecode(value);
      print(info);
      if (info['success'] == true) {
        receivedLrTable.clear();
        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.prev = info['prev'];
        GlobalVariable.next = info['next'];
        GlobalVariable.totalPages = info['total_pages'];
        receivedLrTable.addAll(info['data']);
        setState(() {
          freshload = 0;
          _showLrList();
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  /// Received Lr Api
  Future getReceivedLRsApi() async {
    var url =
    Uri.parse('${GlobalVariable.billingBaseURL}Reports/GetReceivedLRs?'
        'limit=10&'
        'page=${GlobalVariable.currentPage}&'
        // 'from_date=${fromDateApi.text}&'
        // 'to_date=${toDateApi.text}&'
        // 'ledger_id=$ledgerIDDropdown&'
        // 'vehcicle_type=$vehicleId&'
        'keyword=${searchController.text}');
    var headers = {'token': Auth.token};
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  /// ============== END ==================

  /// billed lr API
  Future getBillsLRsApi() async {
    var url = Uri.parse(
        '${GlobalVariable.billingBaseURL}Billing/GetBillsLR?bill_id=${widget.billNumber}');
    var headers = {'token': Auth.token};
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  /// add lr api
  Future addLrApi()async{
    var url = Uri.parse("${GlobalVariable.billingBaseURL}Billing/AddLR?"
        "bill_number=${widget.billNumber}&"
        "lr_id=$lrId");
    var headers = {
      'token': Auth.token
    };
    var response = await http.post(url, headers: headers);
    return response.body.toString();
  }

  /// update
  Future billUpdateApi(int index) async {
    var headers = {'token' : Auth.token};
    var url = Uri.parse("${GlobalVariable.billingBaseURL}Billing/UpdateBillLR?"
        // "lr_id=${}&"
        "detention_in_warehouse=${warehouseController[index].text}&"
        "halt_amount=${haltAmountController[index].text}&"
        "detention_for_direct_billing=${ directBillingController[index].text}&"
        "toll_tax=${tollTaxController[index].text}&"
        "loading_unloading_amount=${loadingUnloadingController[index].text}&"
        "multipoint_load_unloading=${multipointLoadUnloadController[index].text}&"
        "incentive=${ incentiveController[index].text}&"
        "freight_adjustment_addition=${freightAdjustmentAdditionController[index].text}&"
        "late_penalty=${latePenaltyController[index].text}&"
        "freight_adjustment_subtraction=${freightAdjustmentSubtractionController[index].text}&"
        "damage=${damageController[index].text}&"
        "halt_days=${haltDaysController[index].text}&"
        "freight_amount=${freightAmountController[index].text}&"
        "total_freight_amount=${totalFreightAmountController[index].text}&"
        // "lr_date=${}&"
        "no_of_pallets=${noOfPalletsController[index].text}&"
        "lr_invoice_number=${companyInvoiceNoController[index].text}&"
        "reported_date=${ reportedDateController[index].text}&"
        "unloaded_date=${ unloadedDateController[index].text}");
    var body = {
      // TODO : State Code | ledger_date

      'detention_in_warehouse': warehouseController[index].text,
      'detention_for_direct_billing': directBillingController[index].text,
      'toll_tax': tollTaxController[index].text,
      'loading_unloading_amount': loadingUnloadingController[index].text,
      'multipoint_load_unloading': multipointLoadUnloadController[index].text,
      'incentive': incentiveController[index].text,
      'freight_adjustment_addition': freightAdjustmentAdditionController[index].text,
      'late_penalty': latePenaltyController[index].text,
      'freight_adjustment_subtraction': freightAdjustmentSubtractionController[index].text,
      'damage': damageController[index].text,
      'halt_days': haltDaysController[index].text,
      'halt_amount': haltAmountController[index].text,
      'no_of_pallets': noOfPalletsController[index].text,
      'lr_invoice_number': companyInvoiceNoController[index].text,
      // 'detention_in_warehouse': loadingDateController[index].text,
      'reported_date': reportedDateController[index].text,
      'unloaded_date': unloadedDateController[index].text,
      'freight_amount': freightAmountController[index].text,
      'total_freight_amount': totalFreightAmountController[index].text,
      // 'detention_in_warehouse': allRemarkController[index].text,



    };
    var response = await http.post(headers:headers , url , body: body);
    return response.body.toString();
  }
}
