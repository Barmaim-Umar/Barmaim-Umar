import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class OrderVehicleDetails extends StatefulWidget {
  const OrderVehicleDetails({Key? key,
    this.partyName,
    this.fromCity,
    this.toCity,
    this.noOfMv,
    this.assignedMv,
    this.entryBy,
    this.orderId = '0'
  }) : super(key: key);
  final ValueNotifier<String>? partyName;
  final ValueNotifier<String>? fromCity;
  final ValueNotifier<String>? toCity;
  final ValueNotifier<String>? noOfMv;
  final ValueNotifier<String>? assignedMv;
  final ValueNotifier<String>? entryBy;
  final String orderId;
  @override
  State<OrderVehicleDetails> createState() => _OrderVehicleDetailsState();
}

class _OrderVehicleDetailsState extends State<OrderVehicleDetails> with Utility {
  /// New Order Button
  ValueNotifier<String> selectLedgerDropdownValue = ValueNotifier("");
  List<String> ledgersList = [];
  List ledgersListWithId = [];
  String selectRateTypeDropdownValue = "";
  List<String> selectRateTypeDropdownList = ["32FT HQ", "33FT HQ", "34FT HQ"];
  ValueNotifier<String> fromLocationDropdownValue = ValueNotifier("");
  List<String> fromLocationDropdownList = ["Aurangabad", "Pune", "Nagpur", "Amravati"];
  ValueNotifier<String> toLocationDropdownValue = ValueNotifier("");
  List<String> toLocationDropdownList = ["Aurangabad", "Pune", "Nagpur", "Amravati"];
  TextEditingController newOrderDateController = TextEditingController();
  TextEditingController newOrderQtyController = TextEditingController();
  TextEditingController newOrderAmountController = TextEditingController();
  int toLocation = 0;
  String groupValue = 'Single';
  final ScrollController _scrollController = ScrollController();

  /// Cancel Order Button
  TextEditingController cancelOrderController = TextEditingController();

  /// Assign Button
  String assignVehicleDropdownValue = "";
  List<String> assignVehicleDropdownList = ["MH20312545", "MH20312599", "MH20312123", "MH20399944", "MH66091265"];

  /// Assign Outdoor Button
  String companyNameDropdownValue = "";
  List<String> companyNameDropdownList = ["Central India Transport", "Akola Foam", "Balaji Chips", "Diamond Chips"];
  String assignOutdoorVehicleDropdownValue = "";
  List<String> assignOutdoorVehicleDropdownList = ["MH20312545", "MH20312599", "MH20312123", "MH20399944", "MH66091265"];
  TextEditingController freightAmountController = TextEditingController();
  TextEditingController dayControllerFreightRateDate = TextEditingController();
  TextEditingController monthControllerFreightRateDate = TextEditingController();
  TextEditingController yearControllerFreightRateDate = TextEditingController();
  TextEditingController freightRateDateApi = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  int freshLoad = 0;
  int freshLoad1 = 0;
  int freshLoad2 = 0;
  int freshLoad3 = 0;
  List editOrderInfo = [];
  bool update = false;
  String ledgerId = '';

  /// APIs
  ledgerFetchApiFunc(){
    setStateMounted(() => freshLoad = 1);
    ServiceWrapper().ledgerFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        ledgersListWithId.clear();
        ledgersList.clear();
        ledgersListWithId.addAll(info['data']);
        // storing only ledger_title in ledgersList
        for(int i=0; i<info['data'].length; i++){
          ledgersList.add(info['data'][i]['ledger_title'].toString());
        }
        setStateMounted(() => freshLoad = 0);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() => freshLoad = 0);
      }
    });
  }

  createOrderApiFunc(){
    setStateMounted(() => freshLoad1 = 1);
    ServiceWrapper().createOrderApi(
        ledgerId: ledgerId,
        fromLocation: fromLocationDropdownValue.value,
        toLocation: toLocationDropdownValue.value,
        noOfVehicles: '1',
        rateId: '1',
        totalFreightAmount: '1000',
        totalKMs: '120',
        typeOfVehicle: 'typeOfVehicle',
        orderDate: freightRateDateApi.text,
        userId: GlobalVariable.entryBy).then((value) {
          var info = jsonDecode(value);
          if(info['success'] == true){
            AlertBoxes.flushBarSuccessMessage(info['message'], context);
            setStateMounted(() => freshLoad1 = 0);
          }else{
            AlertBoxes.flushBarErrorMessage(info['message'], context);
            setStateMounted(() => freshLoad1 = 0);
          }
    });
  }

  getOrderInfoApiFunc(){
    setStateMounted(() => freshLoad2 = 1);
    ServiceWrapper().getOrderInfoApi(orderId: widget.orderId).then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        editOrderInfo.addAll(info['data']);
        selectLedgerDropdownValue.value = info['data'][0]['ledger_title'];
        fromLocationDropdownValue.value = info['data'][0]['from_location'];
        toLocationDropdownValue.value = info['data'][0]['to_location'];
        newOrderAmountController.text = info['data'][0]['total_freight_amount'].toString();
        setStateMounted(() => {freshLoad2 = 0, update = true});
        _showNewOrderPopup();
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() => freshLoad2 = 0);
      }
    });
  }

  updateOrderApiFunc(){
    setStateMounted(() => freshLoad3 = 1);
    ServiceWrapper().updateOrderApi(
        ledgerId: ledgerId,
        fromLocation: fromLocationDropdownValue.value,
        toLocation: toLocationDropdownValue.value,
        noOfVehicles: '0',
        rateId: selectRateTypeDropdownValue,
        totalFreightAmount: newOrderAmountController.text,
        totalKMs: '0',
        typeOfVehicle: '0',
        orderDate: freightRateDateApi.text,
        userId: GlobalVariable.entryBy,
        orderId: widget.orderId).then((value) {
          var info = jsonDecode(value);
          if(info['success'] == true){
            AlertBoxes.flushBarSuccessMessage(info['message'], context);
            setStateMounted(() => freshLoad3 = 0);
          }else{
            AlertBoxes.flushBarErrorMessage(info['message'], context);
            setStateMounted(() => freshLoad3 = 0);
          }
          setStateMounted(() => update = false);
    });

  }

  cancelOrderApiFunc(){
    ServiceWrapper().cancelOrderApi(widget.orderId).then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  void initState() {
    ledgerFetchApiFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(

        /// Mobile
        mobile: Container(),

        /// Tablet
        tablet: Container(),

        /// Desktop
        desktop: Container  (
          padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 20),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [ThemeColors.primaryColor, Colors.white]), borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        spacing: 50,
                        runSpacing: 30,
                        children: [
                          ValueListenableBuilder(
                              valueListenable: widget.partyName!,
                              builder: (context, value, child) =>
                              info("Party Name", value)),

                          ValueListenableBuilder(
                              valueListenable: widget.fromCity!,
                              builder: (context, value, child) =>
                              info("From City", value)),

                          ValueListenableBuilder(
                              valueListenable: widget.toCity!,
                              builder: (context, value, child) =>
                              info("To City", value)),

                          ValueListenableBuilder(
                              valueListenable: widget.noOfMv!,
                              builder: (context, value, child) =>
                               info("No Of MV", value)),

                          ValueListenableBuilder(
                              valueListenable: widget.assignedMv!,
                              builder: (context, value, child) =>
                              info("Assigned MV", value)),

                          ValueListenableBuilder(
                              valueListenable: widget.entryBy!,
                              builder: (context, value, child) =>
                               info("Entry By", value)),
                        ],
                      ),
                      heightBox10(),
                      const Divider(
                        color: Colors.white,
                      ),
                      heightBox10(),
                      // Vehicle Number | Major Issue
                      Wrap(
                        runSpacing: 20,
                        children: [
                          // New Order Button
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 10)),
                              onPressed: () {
                                _showNewOrderPopup();
                              },
                              child: const Text(
                                "New Order",
                                style: TextStyle(fontSize: 15),
                              )),
                          widthBox20(),
                          // Edit Order Button
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 10)),
                              onPressed: () {
                                getOrderInfoApiFunc();
                              },
                              child: const Text(
                                "Edit Order",
                                style: TextStyle(fontSize: 15),
                              )),
                          widthBox20(),
                          // Cancel order button
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.darkRedColor, padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 10)),
                              onPressed: () {
                                orderCancelButton();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontSize: 15),
                              )),
                          widthBox20(),
                          // Assign button
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow.shade800, padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 10)),
                              onPressed: () {
                                assignButton();
                              },
                              child: const Text(
                                "Assign",
                                style: TextStyle(fontSize: 15),
                              )),
                          widthBox20(),
                          // Assign Outdoor button
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800, padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 10)),
                              onPressed: () {
                                assignOutdoorButton();
                              },
                              child: const Text(
                                "Assign Outdoor",
                                style: TextStyle(fontSize: 15),
                              )),
                          widthBox20(),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                  flex: 5,
                  child: Image.asset(
                    "assets/truck_loading.png",
                    height: 300,
                  )),
            ],
          ),
        ));
  }

  Widget info(String title, String info) {
    return Responsive(
      mobile: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade300, fontWeight: FontWeight.w500),
          ),
          Text(
            info,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
      tablet: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade300, fontWeight: FontWeight.w500, fontSize: 10),
          ),
          Text(
            info,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
      desktop: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade300, fontWeight: FontWeight.w500),
          ),
          Text(
            info,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }

  _showNewOrderPopup() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextDecorationClass().heading(update ? "Update Order" : "New Order"),
            const Divider(),
          ],
        ),
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            width: 700,
            child: Form(
              key: _formKey2,
              child: Column(
                children: [
                  FormWidgets().formDetails2(
                    "Select Ledger",
                    ValueListenableBuilder(
                      valueListenable: selectLedgerDropdownValue,
                      builder: (context, value, child) =>
                       SearchDropdownWidget(
                        dropdownList: ledgersList,
                        hintText: "Please Select Ledger",
                        onChanged: (String? newValue) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectLedgerDropdownValue.value = newValue!;

                            // getting ledger id
                            for(int i=0; i<ledgersListWithId.length; i++){
                              if(selectLedgerDropdownValue.value == ledgersListWithId[i]['ledger_title']){
                                ledgerId = ledgersListWithId[i]['ledger_id'].toString();
                              }
                            }
                          });
                        },
                        selectedItem: value,
                      ),
                    ),
                  ),
                  heightBox10(),
                  // Select Rate Type Dropdown
                  FormWidgets().formDetails2(
                    "Select Rate Type",
                    SearchDropdownWidget(
                      dropdownList: selectRateTypeDropdownList,
                      hintText: "Please Select Rate",
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          selectRateTypeDropdownValue = newValue!;
                        });
                      },
                      selectedItem: selectRateTypeDropdownValue,
                    ),
                  ),
                  heightBox20(),

                  /// Radio Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(child:  SizedBox()),
                       Expanded(flex: 3,child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                        Radio(
                          value: "Single",
                          groupValue: groupValue,
                          onChanged: (value) {
                            setState(() {
                              groupValue = value!;
                            });
                          },
                        ),
                        const Text(
                          "Single Delivery",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 55,
                        ),
                        Radio(
                          value: "Multiple",
                          groupValue: groupValue,
                          onChanged: (value) {
                            setState(() {
                              groupValue = value!;
                            });
                          },
                        ),
                        const Text(
                          "Multiple Delivery",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],))
                    ],
                  ),
                  heightBox20(),
                  // From Location Dropdown
                  FormWidgets().formDetails2(
                    "Select From Location",
                    ValueListenableBuilder(
                      valueListenable: fromLocationDropdownValue,
                      builder: (context, value, child) =>
                       SearchDropdownWidget(
                        dropdownList: fromLocationDropdownList,
                        hintText: 'Select From Location',
                        onChanged: (String? newValue) {
                          // This is called when the user selects an item.
                          setState(() {
                            fromLocationDropdownValue.value = newValue!;
                          });
                        },
                        selectedItem: value,
                      ),
                    ),
                  ),
                  heightBox20(),
                  FormWidgets().formDetails2(
                    "Select To Location",
                    SizedBox(
                      width: 387,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // To Location Dropdown
                          SizedBox(
                            width: 300,
                            child: ValueListenableBuilder(
                              valueListenable: toLocationDropdownValue,
                              builder: (context, value, child) =>
                              SearchDropdownWidget(
                                dropdownList: toLocationDropdownList,
                                hintText: 'Select Location',
                                onChanged: (String? newValue) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    toLocationDropdownValue.value = newValue!;
                                  });
                                },
                                selectedItem: value,
                              ),
                            ),
                          ),
                          widthBox10(),
                          // Qty
                          Expanded(
                            child: TextFormField(
                              controller: newOrderQtyController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: UiDecoration().outlineTextFieldDecoration("QTY", Colors.grey),
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  AlertBoxes.flushBarErrorMessage("Please Enter Qty", context);
                                  return "Please Enter Qty";
                                }
                                return null;
                              },
                            ),
                          ),
                          widthBox10(),
                          // Add Button
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(color: ThemeColors.primaryColor, borderRadius: BorderRadius.circular(5)),
                            child: IconButton(
                                padding: const EdgeInsets.only(right: 0),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    toLocation++;
                                  });
                                },
                                icon: const Icon(
                                  CupertinoIcons.add,
                                  size: 20,
                                )),
                          ),
                          widthBox10(),
                          // Amount
                          Expanded(
                            child: TextFormField(
                              controller: newOrderAmountController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: UiDecoration().outlineTextFieldDecoration("Amount", Colors.grey),
                              validator: (value) {
                                if(value == null || value.isEmpty){
                                  AlertBoxes.flushBarErrorMessage("Please Enter Amount", context);
                                  return "Please Enter Amount";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  toLocation <= 0 ? const SizedBox() : const Divider(thickness: 1.5),
                  // LocationList
                  toLocation <= 0
                      ? const SizedBox(height: 20)
                      : SizedBox(
                    height: 200,
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: 775,
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: toLocation,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: FormWidgets().formDetails2(
                                    optional: true, // to remove "*"
                                    "",
                                    SizedBox(
                                      width: 357,
                                      child: Row(
                                        children: [
                                          // To Location Dropdown
                                          Container(
                                            height: 30,
                                            width: 300,
                                            padding: const EdgeInsets.symmetric(horizontal: 0),
                                            child: ValueListenableBuilder(
                                              valueListenable: toLocationDropdownValue,
                                              builder: (context, value, child) =>
                                              SearchDropdownWidget(
                                                dropdownList: toLocationDropdownList,
                                                hintText: 'Select Location',
                                                onChanged: (String? newValue) {
                                                  // This is called when the user selects an item.
                                                  setState(() {
                                                    toLocationDropdownValue.value = newValue!;
                                                  });
                                                },
                                                selectedItem: value,
                                              ),
                                            ),
                                          ),
                                          widthBox10(),
                                          // Qty
                                          Expanded(
                                            child: TextFormField(
                                              controller: newOrderQtyController,
                                              // decoration: FormWidgets().inputDecoration("QTY"),
                                              decoration: UiDecoration().outlineTextFieldDecoration("QTY", Colors.grey),
                                            ),
                                          ),
                                          widthBox10(),
                                          // Delete Button
                                          Container(
                                            height: 27,
                                            width: 27,
                                            decoration: BoxDecoration(color: ThemeColors.darkRedColor, borderRadius: BorderRadius.circular(5)),
                                            child: IconButton(
                                                padding: const EdgeInsets.only(right: 0),
                                                color: Colors.white,
                                                onPressed: () {
                                                  setState(() {
                                                    toLocation > 0 ? toLocation-- : toLocation = 0;
                                                  });
                                                },
                                                icon: const Icon(
                                                  CupertinoIcons.delete,
                                                  size: 20,
                                                )),
                                          ),
                                          widthBox10(),
                                          // Amount
                                          Expanded(
                                            child: TextFormField(
                                              controller: newOrderAmountController,
                                              // decoration: FormWidgets().inputDecoration("Amount"),
                                              decoration: UiDecoration().outlineTextFieldDecoration("Amount", Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                  toLocation <= 0
                      ? const SizedBox()
                      : const Divider(
                          thickness: 1.5,
                        ),

                  FormWidgets().formDetails2(
                    'Freight Rate Date',
                    DateFieldWidget2(
                        dayController: dayControllerFreightRateDate,
                        monthController: monthControllerFreightRateDate,
                        yearController: yearControllerFreightRateDate,
                        dateControllerApi: freightRateDateApi
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        actions: <Widget>[
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              newOrderQtyController.clear();
              newOrderAmountController.clear();
              newOrderDateController.clear();
              groupValue = "Single";
              toLocation = 0;
              selectLedgerDropdownValue.value = '';
              selectRateTypeDropdownValue = '';
              fromLocationDropdownValue.value = '';
              toLocationDropdownValue.value = '';
              setState(() {
                update = false;
              });
            },
            child: const Text('Cancel'),
          ),
          // OK Button || Update Button
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.primary,
              borderRadius: BorderRadius.circular(3)
            ),
            child: TextButton(
              onPressed: () {
                if(_formKey2.currentState!.validate()){
                  // checking whether to update order or create order
                  update ? updateOrderApiFunc() : createOrderApiFunc();
                  Navigator.pop(context);
                }
              },
              child: Text(update ? 'Update' : 'OK', style: const TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  orderCancelButton() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextDecorationClass().heading("Cancel Order"),
            const Divider(),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Form(
              key: _formKey3,
              child: TextFormField(
                controller: cancelOrderController,
                maxLines: 3,
                style: const TextStyle(fontSize: 15),
                decoration: UiDecoration().outlineTextFieldDecoration(
                  "Remark...",
                  Colors.grey,
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    AlertBoxes.flushBarErrorMessage("Please Enter Remark", context);
                    return "Please Enter Remark";
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
              cancelOrderController.clear();
            },
            child: const Text('Cancel'),
          ),
          Container(
            decoration: BoxDecoration(
                color: ThemeColors.primary,
                borderRadius: BorderRadius.circular(3)
            ),
            child: TextButton(
              onPressed: () {
                if(_formKey3.currentState!.validate()){
                  cancelOrderApiFunc();
                  Navigator.pop(context, 'OK');
                  cancelOrderController.clear();
                }
              },
              child: const Text('OK', style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  assignButton() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [TextDecorationClass().heading("Assign"), const Divider()],
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: 350,
              child: Form(
                key: _formKey4,
                child: SearchDropdownWidget(
                    dropdownList: assignVehicleDropdownList,
                    hintText: 'Select Vehicle',
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        assignVehicleDropdownValue = newValue!;

                        // Vehicle Document Status
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Vehicle Status"),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    const Text("Hyderabad To Aurangabad | (Unloaded)"),
                                    const Text("Driver Name : Anis Hassan"),
                                    heightBox20(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                      decoration: const BoxDecoration(color: Color(0xfffcf7e3)),
                                      child: Row(
                                        children: [
                                          TextDecorationClass().documentStatus("State Road Tax"),
                                          const SizedBox(
                                              height: 30,
                                              child: VerticalDivider(
                                                color: Colors.white,
                                                thickness: 1,
                                              )),
                                          TextDecorationClass().documentStatus("31-03-2023"),
                                          const SizedBox(
                                              height: 30,
                                              child: VerticalDivider(
                                                color: Colors.white,
                                                thickness: 1,
                                              )),
                                          TextDecorationClass().documentStatus("This Month Expiry"),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                      decoration: const BoxDecoration(color: Color(0xfff2dede)),
                                      child: Row(
                                        children: [
                                          TextDecorationClass().documentStatus("Speed Governance"),
                                          const SizedBox(
                                              height: 30,
                                              child: VerticalDivider(
                                                color: Colors.white,
                                                thickness: 2,
                                              )),
                                          TextDecorationClass().documentStatus("31-07-2018"),
                                          const SizedBox(
                                              height: 30,
                                              child: VerticalDivider(
                                                color: Colors.white,
                                                thickness: 2,
                                              )),
                                          TextDecorationClass().documentStatus("Expired"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(onPressed: () => Navigator.pop(context, "Cancel"), child: const Text("Cancel")),
                                Container(
                                    decoration: BoxDecoration(
                                        color: ThemeColors.primary,
                                        borderRadius: BorderRadius.circular(3)
                                    ),
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, "Assign");
                                          Navigator.pop(context, "Assign");
                                        },
                        child: const Text('Assign', style: TextStyle(color: Colors.white),),))
                              ],
                            ));
                      });
                    },
                    selectedItem: assignVehicleDropdownValue
                ),
              ),
            );

          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          Container(
            decoration: BoxDecoration(
                color: ThemeColors.primary,
                borderRadius: BorderRadius.circular(3)
            ),
            child: TextButton(
              onPressed: () {
                if(_formKey4.currentState!.validate()){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Vehicle Status"),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const Text("Hyderabad To Aurangabad | (Unloaded)"),
                              const Text("Driver Name : Anis Hassan"),
                              heightBox20(),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                decoration: const BoxDecoration(color: Color(0xfffcf7e3)),
                                child: Row(
                                  children: [
                                    TextDecorationClass().documentStatus("State Road Tax"),
                                    const SizedBox(
                                        height: 30,
                                        child: VerticalDivider(
                                          color: Colors.white,
                                          thickness: 1,
                                        )),
                                    TextDecorationClass().documentStatus("31-03-2023"),
                                    const SizedBox(
                                        height: 30,
                                        child: VerticalDivider(
                                          color: Colors.white,
                                          thickness: 1,
                                        )),
                                    TextDecorationClass().documentStatus("This Month Expiry"),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: Colors.white,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                decoration: const BoxDecoration(color: Color(0xfff2dede)),
                                child: Row(
                                  children: [
                                    TextDecorationClass().documentStatus("Speed Governance"),
                                    const SizedBox(
                                        height: 30,
                                        child: VerticalDivider(
                                          color: Colors.white,
                                          thickness: 2,
                                        )),
                                    TextDecorationClass().documentStatus("31-07-2018"),
                                    const SizedBox(
                                        height: 30,
                                        child: VerticalDivider(
                                          color: Colors.white,
                                          thickness: 2,
                                        )),
                                    TextDecorationClass().documentStatus("Expired"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(onPressed: () => Navigator.pop(context, "Cancel"), child: const Text("Cancel")),
                          Container(
                            decoration: BoxDecoration(
                                color: ThemeColors.primary,
                                borderRadius: BorderRadius.circular(3)
                            ),
                            child: TextButton(
                              onPressed: () => Navigator.pop(context, "Assign"),
                              child: const Text('Assign', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ],
                      ));
                }
              },
              child: const Text('OK', style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  assignOutdoorButton() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextDecorationClass().heading("Outdoor Vehicle Assign Order88474"),
            const Divider(),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SearchDropdownWidget(
                            dropdownList: companyNameDropdownList,
                            hintText: 'Select Company',
                            onChanged: (String? newValue) {
                              // This is called when the user selects an item.
                              setState(() {
                                companyNameDropdownValue = newValue!;
                              });
                            },
                            selectedItem: companyNameDropdownValue
                        ),
                        heightBox20(),
                        SearchDropdownWidget(
                            dropdownList: assignOutdoorVehicleDropdownList,
                            hintText:  'Select Vehicle',
                            onChanged: (String? newValue) {
                              // This is called when the user selects an item.
                              setState(() {
                                assignOutdoorVehicleDropdownValue = newValue!;
                              });
                            },
                            selectedItem: assignOutdoorVehicleDropdownValue
                        ),
                        heightBox20(),
                        TextFormField(
                          controller: freightAmountController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: UiDecoration().outlineTextFieldDecoration('Enter Freight Amount', ThemeColors.primaryColor),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              AlertBoxes.flushBarErrorMessage("Please Enter Freight Amount", context);
                              return 'Please Enter Freight Amount';
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
              freightAmountController.clear();
            },
            child: const Text('Cancel'),
          ),
          Container(
            decoration: BoxDecoration(
                color: ThemeColors.primary,
                borderRadius: BorderRadius.circular(3)
            ),
            child: TextButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  Navigator.pop(context);
                }
              },
              child: const Text('Assign', style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
  
  setStateMounted(VoidCallback fn){
    if(mounted){
      setState(fn);
    }
  }
}
