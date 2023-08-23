import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class OrderVehicleDetails extends StatefulWidget {
  const OrderVehicleDetails({Key? key}) : super(key: key);

  @override
  State<OrderVehicleDetails> createState() => _OrderVehicleDetailsState();
}

class _OrderVehicleDetailsState extends State<OrderVehicleDetails> with Utility {
  /// New Order Button
  String selectLedgerDropdownValue = "Ledger 1";
  List<String> selectLedgerDropdownList = ["Ledger 1" , "Ledger 2" , "Ledger 3" , "Ledger 4" , "Ledger 5"];
  String selectRateTypeDropdownValue = "32FT HQ";
  List<String> selectRateTypeDropdownList = ["32FT HQ" , "33FT HQ" , "34FT HQ"];
  String fromLocationDropdownValue = "Aurangabad";
  List<String> fromLocationDropdownList = ["Aurangabad" , "Pune" , "Nagpur" , "Amravati"];
  String toLocationDropdownValue = "Pune";
  List<String> toLocationDropdownList = ["Aurangabad" , "Pune" , "Nagpur" , "Amravati"];
  TextEditingController newOrderDateController = TextEditingController();
  TextEditingController newOrderQtyController = TextEditingController();
  TextEditingController newOrderAmountController = TextEditingController();
  int toLocation = 0;
  String groupValue = 'RadioValue';
  final ScrollController _scrollController = ScrollController();

  /// Cancel Order Button
  TextEditingController cancelOrderController = TextEditingController();

  /// Assign Button
  String assignVehicleDropdownValue = "MH20312545";
  List<String> assignVehicleDropdownList = ["MH20312545" , "MH20312599" , "MH20312123" , "MH20399944" , "MH66091265"];

  /// Assign Outdoor Button
  String companyNameDropdownValue = "Central India Transport";
  List<String> companyNameDropdownList = ["Central India Transport" , "Akola Foam" , "Balaji Chips" , "Diamond Chips"];
  String assignOutdoorVehicleDropdownValue = "MH20312545";
  List<String> assignOutdoorVehicleDropdownList = ["MH20312545" , "MH20312599" , "MH20312123" , "MH20399944" , "MH66091265"];
  TextEditingController freightAmountController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Responsive(
        /// Mobile
        mobile: Container(),

        /// Tablet
        tablet: Container(),

        /// Desktop
        desktop: Container(
          padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10, left: 20),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [ThemeColors.primaryColor,Colors.white]),
              borderRadius: BorderRadius.circular(8)),
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
                          info("Party Name", "T & D GALLIANO CONTAINERS"),
                          info("From City", "Amravati District"),
                          info("To City", "Nagpur"),
                          info("No Of MV", "132"),
                          info("Assigned MV", "122"),
                          info("Entry By", "Santosh"),
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
                                newOrderButton();
                              },
                              child: const Text("New Order",style: TextStyle(fontSize: 15),
                              )),
                          widthBox20(),
                          // Cancel order button
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.darkRedColor, padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 10)),
                              onPressed: () {
                                orderCancelButton();
                              },
                              child: const Text("Cancel",style: TextStyle(fontSize: 15),
                              )),
                          widthBox20(),
                          // Assign button
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow.shade800, padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 10)),
                              onPressed: () {
                                assignButton();
                              },
                              child: const Text("Assign",style: TextStyle(fontSize: 15),
                              )),
                          widthBox20(),
                          // Assign Outdoor button
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800, padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 10)),
                              onPressed: () {
                                assignOutdoorButton();
                              },
                              child: const Text("Assign Outdoor",style: TextStyle(fontSize: 15),
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
  newOrderButton(){
    return  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextDecorationClass().heading("New Order"),
            const Divider(),
          ],
        ),
        content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [


              // Select Ledger Dropdown
              UiDecoration().orderDetails("Select Ledger",Container(
                height: 30,
                width: 358,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
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
                  icon: const Padding(
                    padding:  EdgeInsets.only(right: 8.0),
                    child:  Icon(
                      CupertinoIcons.chevron_down,
                      color: ThemeColors.darkBlack,
                      size: 20,
                    ),
                  ),
                  iconSize: 30,
                  value: selectLedgerDropdownValue,
                  elevation: 16,
                  style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                  onChanged: (String? newValue) {
                    // This is called when the user selects an item.
                    setState(() {
                      selectLedgerDropdownValue = newValue!;
                    });
                  },
                  items: selectLedgerDropdownList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              )),
              heightBox10(),
              // Select Rate Type Dropdown
              UiDecoration().orderDetails("Select Rate Type",Container(
                height: 30,
                width: 358,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
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
                  icon: const Padding(
                    padding:  EdgeInsets.only(right: 8.0),
                    child:  Icon(
                      CupertinoIcons.chevron_down,
                      color: ThemeColors.darkBlack,
                      size: 20,
                    ),
                  ),
                  iconSize: 30,
                  value: selectRateTypeDropdownValue,
                  elevation: 16,
                  style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                  onChanged: (String? newValue) {
                    // This is called when the user selects an item.
                    setState(() {
                      selectRateTypeDropdownValue = newValue!;
                    });
                  },
                  items: selectRateTypeDropdownList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              )),
              heightBox20(),
              /// Radio Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Expanded(child: Container()),
                  Radio(
                    value: "Single",
                    groupValue:groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                      });
                    },
                  ),
                  const Text("Single Delivery" , style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(
                    width: 55,
                  ),
                  Radio(
                    value: "Multiple",
                    groupValue: groupValue  ,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                      });
                    },
                  ),
                  const Text("Multiple Delivery", style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
              heightBox20(),
              // From Location Dropdown
              UiDecoration().orderDetails("Select From Location",Container(
                height: 30,
                width: 358,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
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
                  icon: const Padding(
                    padding:  EdgeInsets.only(right: 8.0),
                    child:  Icon(
                      CupertinoIcons.chevron_down,
                      color: ThemeColors.darkBlack,
                      size: 20,
                    ),
                  ),
                  iconSize: 30,
                  value: fromLocationDropdownValue,
                  elevation: 16,
                  style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                  onChanged: (String? newValue) {
                    // This is called when the user selects an item.
                    setState(() {
                      fromLocationDropdownValue = newValue!;
                    });
                  },
                  items: fromLocationDropdownList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              )),
              heightBox20(),
              // To Location Dropdown
              UiDecoration().orderDetails2("Select To Location",Expanded(
                child: SizedBox(
                  width: 357,
                  child: Row(
                    children: [
                      // To Location Dropdown
                      Container(
                        height: 30,
                        width: 150,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(5),
                          dropdownColor: ThemeColors.whiteColor,
                          underline: Container(
                            decoration: const BoxDecoration(border: Border()),
                          ),
                          isExpanded: true,
                          hint: const Text(
                            'Select Location',
                            style: TextStyle(color: ThemeColors.darkBlack),
                          ),
                          icon: const Padding(
                            padding:  EdgeInsets.only(right: 8.0),
                            child:  Icon(
                              CupertinoIcons.chevron_down,
                              color: ThemeColors.darkBlack,
                              size: 20,
                            ),
                          ),
                          iconSize: 30,
                          value: toLocationDropdownValue,
                          elevation: 16,
                          style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                          onChanged: (String? newValue) {
                            // This is called when the user selects an item.
                            setState(() {
                              toLocationDropdownValue = newValue!;
                            });
                          },
                          items: toLocationDropdownList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value.toString(),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
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
                      // Add Button
                      Container(
                        height: 27,
                        width: 27,
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
                          // decoration: FormWidgets().inputDecoration("Amount"),
                          decoration: UiDecoration().outlineTextFieldDecoration("Amount", Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),),
              toLocation <= 0 ? const SizedBox() : const Divider(thickness: 1.5),
              // LocationList
              toLocation <= 0 ? const SizedBox(height: 20,) : Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    // height: 300,
                    width: 730,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: toLocation,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: UiDecoration().orderDetails2(
                            "",
                            Expanded(
                              child: Row(
                                children: [
                                  // dropdown
                                  Container(
                                    height: 30,
                                    width: 150,
                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
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
                                      icon: const Padding(
                                        padding:  EdgeInsets.only(right: 8.0),
                                        child:  Icon(
                                          CupertinoIcons.chevron_down,
                                          color: ThemeColors.darkBlack,
                                          size: 20,
                                        ),
                                      ),
                                      iconSize: 30,
                                      value: toLocationDropdownValue,
                                      elevation: 16,
                                      style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                                      onChanged: (String? newValue) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          toLocationDropdownValue = newValue!;
                                        });
                                      },
                                      items: toLocationDropdownList.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value.toString(),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(value),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  widthBox10(),
                                  // Qty
                                  Expanded(
                                    child: TextFormField(
                                      controller: newOrderQtyController,
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
              toLocation <= 0 ? const SizedBox() : const Divider(thickness: 1.5,),
              UiDecoration().orderDetails("Order Date",Expanded(
                child: TextFormField(
                  readOnly: true,
                  controller: newOrderDateController,
                  // decoration: FormWidgets().inputDecoration("From Date"),
                  decoration: UiDecoration().outlineTextFieldDecoration("From Date", Colors.grey),
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
                        newOrderDateController.text = "${value.year}-$month-$day";
                      });
                    });
                  },
                ),
              )),
            ],
          );
        }),
        actions: <Widget>[
          // Cancel Button
          TextButton(
            onPressed: (){
              Navigator.pop(context, 'Cancel');
              newOrderQtyController.clear();
              newOrderAmountController.clear();
              newOrderDateController.clear();
              groupValue = "";
              toLocation = 0;
              selectLedgerDropdownValue = selectLedgerDropdownList.first;
              selectRateTypeDropdownValue = selectRateTypeDropdownList.first;
              fromLocationDropdownValue = fromLocationDropdownList.first;
              toLocationDropdownValue = toLocationDropdownList.first;
            },
            child: const Text('Cancel'),
          ),
          // OK Button
          TextButton(
            onPressed: () {

              if(newOrderQtyController.text.isEmpty){
                AlertBoxes.flushBarErrorMessage("Please Enter QTY", context);
              } else if(newOrderAmountController.text.isEmpty){
                AlertBoxes.flushBarErrorMessage("Please Enter AMOUNT", context);
              } else if(newOrderDateController.text.isEmpty){
                AlertBoxes.flushBarErrorMessage("Please Enter ORDER DATE", context);
              } else{
                Navigator.pop(context, 'OK');
                newOrderQtyController.clear();
                newOrderAmountController.clear();
                newOrderDateController.clear();
                groupValue = "";
                toLocation = 0;
                selectLedgerDropdownValue = selectLedgerDropdownList.first;
                selectRateTypeDropdownValue = selectRateTypeDropdownList.first;
                fromLocationDropdownValue = fromLocationDropdownList.first;
                toLocationDropdownValue = toLocationDropdownList.first;
              }

              },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  orderCancelButton(){
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextDecorationClass().heading("Cancel Order"),
          const Divider(),
        ],),
        content: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: TextFormField(
              controller: cancelOrderController,
              maxLines: 3,
              style: const TextStyle(fontSize: 15),
              decoration: UiDecoration().outlineTextFieldDecoration(
                "Remark...",
                Colors.grey,
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
          TextButton(
            onPressed: () {
              if(cancelOrderController.text.isEmpty){
                AlertBoxes.flushBarErrorMessage("Please Enter Remark", context);
              }else{
                Navigator.pop(context, 'OK');
                cancelOrderController.clear();
              }

            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  assignButton(){
    return  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          TextDecorationClass().heading("Assign"),
            const Divider()
        ],),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 30,
              width: 350,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(5),
                dropdownColor: ThemeColors.whiteColor,
                underline: Container(
                  decoration: const BoxDecoration(border: Border()),
                ),
                isExpanded: true,
                hint: const Text(
                  'Select Vehicle',
                  style: TextStyle(color: ThemeColors.darkBlack),
                ),
                icon: const Padding(
                  padding:  EdgeInsets.only(right: 8.0),
                  child:  Icon(
                    CupertinoIcons.chevron_down,
                    color: ThemeColors.darkBlack,
                    size: 20,
                  ),
                ),
                iconSize: 30,
                value: assignVehicleDropdownValue,
                elevation: 16,
                style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                onChanged: (String? newValue) {
                  // This is called when the user selects an item.
                  setState(() {
                    assignVehicleDropdownValue = newValue!;

                    // Vehicle Document Status
                    showDialog(context: context,
                        builder:  (BuildContext context) => AlertDialog(
                          title: const Text("Vehicle Status"),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                const Divider(),
                                const Text("Hyderabad To Aurangabad | (Unloaded)"),
                                const Text("Driver Name : Anis Hassan"),
                                heightBox20(),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 0 , horizontal: 15),
                                  decoration: const BoxDecoration(color: Color(0xfffcf7e3)),
                                  child: Row(
                                    children:  [
                                      TextDecorationClass().documentStatus("State Road Tax"),
                                      const SizedBox(height: 30,child: VerticalDivider(color: Colors.white, thickness: 1,)),
                                      TextDecorationClass().documentStatus("31-03-2023"),
                                      const SizedBox(height: 30,child: VerticalDivider(color: Colors.white, thickness: 1,)),
                                      TextDecorationClass().documentStatus("This Month Expiry"),

                                    ],
                                  ),
                                ),
                                const Divider(height: 1 , color: Colors.white, ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 0 , horizontal: 15),
                                  decoration: const BoxDecoration(color: Color(0xfff2dede)),
                                  child: Row(
                                    children: [
                                      TextDecorationClass().documentStatus("Speed Governance"),
                                      const SizedBox(height: 30,child: VerticalDivider(color: Colors.white, thickness: 2,)),
                                      TextDecorationClass().documentStatus("31-07-2018"),
                                      const SizedBox(height: 30,child: VerticalDivider(color: Colors.white, thickness: 2,)),
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
                                decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                                child: TextButton(onPressed: () {
                                  Navigator.pop(context, "Assign");
                                  Navigator.pop(context, "Assign");
                                }, child: const Text("Assign")))
                          ],
                        )
                    );
                  });
                },
                items: assignVehicleDropdownList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(value),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              showDialog(context: context,
                  builder:  (BuildContext context) => AlertDialog(
                    title: const Text("Vehicle Status"),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          const Divider(),
                          const Text("Hyderabad To Aurangabad | (Unloaded)"),
                          const Text("Driver Name : Anis Hassan"),
                          heightBox20(),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 0 , horizontal: 15),
                            decoration: const BoxDecoration(color: Color(0xfffcf7e3)),
                            child: Row(
                              children:  [
                                TextDecorationClass().documentStatus("State Road Tax"),
                                const SizedBox(height: 30,child: VerticalDivider(color: Colors.white, thickness: 1,)),
                                TextDecorationClass().documentStatus("31-03-2023"),
                                const SizedBox(height: 30,child: VerticalDivider(color: Colors.white, thickness: 1,)),
                                TextDecorationClass().documentStatus("This Month Expiry"),

                              ],
                            ),
                          ),
                          const Divider(height: 1 , color: Colors.white, ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 0 , horizontal: 15),
                            decoration: const BoxDecoration(color: Color(0xfff2dede)),
                            child: Row(
                              children: [
                                TextDecorationClass().documentStatus("Speed Governance"),
                                const SizedBox(height: 30,child: VerticalDivider(color: Colors.white, thickness: 2,)),
                                TextDecorationClass().documentStatus("31-07-2018"),
                                const SizedBox(height: 30,child: VerticalDivider(color: Colors.white, thickness: 2,)),
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
                          decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                          child: TextButton(onPressed: () => Navigator.pop(context, "Assign"), child: const Text("Assign")))
                    ],
                  )
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  assignOutdoorButton(){
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextDecorationClass().heading("Outdoor Vehicle Assign Order88474"),
            const Divider(),
          ],),
        content: SingleChildScrollView(
          child: Column(
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      Container(
                        height: 30,
                        width: 350,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(5),
                          dropdownColor: ThemeColors.whiteColor,
                          underline: Container(
                            decoration: const BoxDecoration(border: Border()),
                          ),
                          isExpanded: true,
                          hint: const Text(
                            'Select Company',
                            style: TextStyle(color: ThemeColors.darkBlack),
                          ),
                          icon: const Padding(
                            padding:  EdgeInsets.only(right: 8.0),
                            child:  Icon(
                              CupertinoIcons.chevron_down,
                              color: ThemeColors.darkBlack,
                              size: 20,
                            ),
                          ),
                          iconSize: 30,
                          value: companyNameDropdownValue,
                          elevation: 16,
                          style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                          onChanged: (String? newValue) {
                            // This is called when the user selects an item.
                            setState(() {
                              companyNameDropdownValue = newValue!;

                            });
                          },
                          items: companyNameDropdownList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value.toString(),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      heightBox20(),
                      Container(
                        height: 30,
                        width: 350,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: ThemeColors.grey700)),
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(5),
                          dropdownColor: ThemeColors.whiteColor,
                          underline: Container(
                            decoration: const BoxDecoration(border: Border()),
                          ),
                          isExpanded: true,
                          hint: const Text(
                            'Select Vehicle',
                            style: TextStyle(color: ThemeColors.darkBlack),
                          ),
                          icon: const Padding(
                            padding:  EdgeInsets.only(right: 8.0),
                            child:  Icon(
                              CupertinoIcons.chevron_down,
                              color: ThemeColors.darkBlack,
                              size: 20,
                            ),
                          ),
                          iconSize: 30,
                          value: assignOutdoorVehicleDropdownValue,
                          elevation: 16,
                          style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                          onChanged: (String? newValue) {
                            // This is called when the user selects an item.
                            setState(() {
                              assignOutdoorVehicleDropdownValue = newValue!;

                            });
                          },
                          items: assignOutdoorVehicleDropdownList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value.toString(),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      heightBox20(),
                      TextFormField(
                        controller: freightAmountController,
                        // decoration: FormWidgets().inputDecoration("Enter Freight Amount"),
                        decoration: UiDecoration().outlineTextFieldDecoration("Enter Freight Amount", Colors.grey),
                      )
                    ],
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
            decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
            child: TextButton(
              onPressed: () {
                if(freightAmountController.text.isEmpty){
                  AlertBoxes.flushBarErrorMessage("Please Enter FREIGHT AMOUNT", context);
                } else {
                  Navigator.pop(context, 'Assign');
                  freightAmountController.clear();
                }
              },
              child: const Text('Assign'),
            ),
          ),
        ],
      ),
    );
  }
}
