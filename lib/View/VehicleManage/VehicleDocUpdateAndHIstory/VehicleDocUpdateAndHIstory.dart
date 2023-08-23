import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class VehicleDocUpdateAndHistory extends StatefulWidget {
  const VehicleDocUpdateAndHistory({Key? key}) : super(key: key);

  @override
  State<VehicleDocUpdateAndHistory> createState() => _VehicleDocUpdateAndHistoryState();
}

  List<String> entries = ['10','20','30','40','50'];
class _VehicleDocUpdateAndHistoryState extends State<VehicleDocUpdateAndHistory> with Utility{
  String entriesValue = entries.first;
  List vehicleInfo = [];
  List docInfo = [];
  List docHistoryList = [];
  List docList = [];
  int currentSortColumn = 0;
  bool isAscending = true;

  TextEditingController vehicleNo = TextEditingController();
  TextEditingController documentNo = TextEditingController();
  TextEditingController renewalDateApi = TextEditingController();
  TextEditingController renewalDateUi = TextEditingController();
  TextEditingController expiryDateApi = TextEditingController();
  TextEditingController expiryDateUi = TextEditingController();
  TextEditingController documentName = TextEditingController();
  TextEditingController search = TextEditingController();
  int freshLoad = 0;
  int freshLoad2 = 0;
  final formKey = GlobalKey<FormState>();
  int currentPage = 1;
  var next;
  var prev;
  var totalPages;
  var docinfoId;

  TextEditingController companyName = TextEditingController();

  docRenewalApiFunc(){
    docRenewApi().then((value) {
      var info = jsonDecode(value);
      if(info['success']==true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }
      else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  vehicleEditApiFunc(){
    vehicleInfo.clear();
    setState(() {
      freshLoad = 1;
    });
    vehicleEditApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        vehicleInfo.addAll(info['data']);
        setState(() {
          freshLoad = 0;
        });
      }
    });
  }

  docEditApiFunc(){
    docEditApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        vehicleNo.text = vehicleInfo[0]['vehicle_number'];
        documentName.text=info['data'][0]['doc_name'];
        companyName.text=info['data'][0]['company_name'];
        documentNo.text = info['data'][0]['doc_number'];
        renewalDateUi.text = info['data'][0]['renewal_date'];
        renewalDateApi.text = info['data'][0]['renewal_date'];
        expiryDateUi.text = info['data'][0]['expiry_date'];
        expiryDateApi.text = info['data'][0]['expiry_date'];
      }
    });
  }

  docListApiFunc(){
    docList.clear();
    setState(() {
      freshLoad = 1;
    });
    docListApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        docList.addAll(info['data']);
        setState(() {
          freshLoad = 0;
        });
      }
    });
  }

  docHistoryApiFunc(){
    setState(() {
      freshLoad2 = 1;
    });
    docHistoryList.clear();
    docHistory().then((value) {
      var info = jsonDecode(value);
      if(info['success']==true){
        docHistoryList.addAll(info['data']);
        totalPages = info['total_pages'];
        currentPage = info['page'];
        next = info['next'];
        prev = info['prev'];
        setState(() {
          freshLoad2 = 0;
        });
      }
      else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    vehicleEditApiFunc();
    docHistoryApiFunc();
    docListApiFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar('Vehicle Document Update & History'),
      body: freshLoad==1?const Center(child:  CircularProgressIndicator()):Responsive(
          mobile: Column(),
          tablet: Column(
            children: [
              vehicleDetails(),
              vehicleDocUpdate(),
              Expanded(flex: 1, child: vehicleDocUpdateHistory()),
            ],
          ),
          desktop: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vehicleDetails(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 2,
                        child: vehicleDocUpdate(),
                    ),
                    Expanded(
                        flex: 2,
                        child: vehicleDocUpdateHistory(),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  //Widgets--------------------------------

  Widget vehicleDocUpdate(){
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: UiDecoration().formDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Vehicle Documents',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20),),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: docList.length,
            itemBuilder: (context, index) {
            return Container(
              color: index==0||index%2==0?ThemeColors.tableRowColor:Colors.white,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextDecorationClass().heading1(docList[index]['doc_name']),
                  ElevatedButton(
                    style: ButtonStyles.customiseButton(ThemeColors.greenColor, ThemeColors.whiteColor, 100.0, 40.0),
                      onPressed: (){
                      setState(() {
                        docinfoId = docList[index]['docinfo_id'];
                      });
                      docEditApiFunc();
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextDecorationClass().subHeading2('Renew Vehicle Document'),
                              ],
                            ),
                            titlePadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                            content: Form(
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    FormWidgets().infoField('Vehicle Number', 'Vehicle Number', vehicleNo, context),
                                    FormWidgets().infoField('Document Name', 'Document Name', documentName, context),
                                    FormWidgets().onlyAlphabetField('Company Name', 'Company Name', companyName, context,optional: true),
                                    FormWidgets().alphanumericField('Document No', 'Document No', documentNo, context),
                                    FormWidgets().formDetails2('Renewal Date',TextFormField(
                                      readOnly: true,
                                      controller: renewalDateUi,
                                      decoration: UiDecoration()
                                          .dateFieldDecoration('Renewal Date'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Date Field Is Required';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        UiDecoration()
                                            .showDatePickerDecoration(context)
                                            .then((value) {
                                          setState(() {
                                            String month = value.month
                                                .toString()
                                                .padLeft(2, '0');
                                            String day =
                                            value.day.toString().padLeft(2, '0');
                                            renewalDateApi.text ="${value.year}-$month-$day";
                                            renewalDateUi.text = '$day-$month-${value.year}';
                                          });
                                        });
                                      },
                                    ),),
                                    FormWidgets().formDetails2('Expiry Date',TextFormField(
                                      readOnly: true,
                                      controller: expiryDateUi,
                                      decoration: UiDecoration()
                                          .dateFieldDecoration('Expiry Date'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Date Field Is Required';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        UiDecoration()
                                            .showDatePickerDecoration(context)
                                            .then((value) {
                                          setState(() {
                                            String month = value.month
                                                .toString()
                                                .padLeft(2, '0');
                                            String day =
                                            value.day.toString().padLeft(2, '0');
                                            expiryDateApi.text = "${value.year}-$month-$day";
                                            expiryDateUi.text = '$day-$month-${value.year}';
                                          });
                                        });
                                      },
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                            actions: [
                              ElevatedButton(
                                style: ButtonStyles.customiseButton(ThemeColors.grey, ThemeColors.whiteColor, 100.0, 40.0),
                                onPressed: (){
                                  setState(() {

                                  formKey.currentState!.reset();
                                  documentNo.clear();
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ButtonStyles.customiseButton(ThemeColors.primary, ThemeColors.whiteColor, 100.0, 40.0),
                                onPressed: (){
                                  docRenewalApiFunc();
                                  docHistoryApiFunc();
                                  Navigator.pop(context);
                                },
                                child: const Text('Renew'),
                              ),
                            ],
                          );
                        },);
                      },
                      child: const Text('Renew')),
                ],
              ),
            );
          },),
        ],
      ),
    );
  }

  Widget vehicleDocUpdateHistory(){
    return freshLoad2==1?const Center(child: CircularProgressIndicator()):SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: UiDecoration().formDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightBox10(),
            Row(
              children: [
                widthBox5(),
                const Text('Show '),
                SizedBox(
                  width: 100,
                  child: SearchDropdownWidget(
                    showSearchBox: false,
                      dropdownList: entries, hintText: 'select entries', onChanged: (p0) {
                    setState(() {
                    entriesValue = p0!;
                    });
                    docHistoryApiFunc();
                  }, selectedItem: entriesValue),
                ),
                const Text(' entries'),
                const Spacer(),
                TextDecorationClass().heading1('Search :  '),
                widthBox5(),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: search,
                    decoration: UiDecoration().outlineTextFieldDecoration('Search', ThemeColors.primary),
                    onFieldSubmitted: (value) {
                      docHistoryApiFunc();
                    },
                  ),
                ),
              ],
            ),
            const Divider(),
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: currentSortColumn,
                  sortAscending: isAscending,
                  columns: [
                    DataColumn(
                        label: const Text('Date'),
                  // Sorting function
                  onSort: (columnIndex, _) {
                    setState(() {
                      currentSortColumn = columnIndex;
                      if (isAscending == true) {
                        isAscending = false;
                        // sort the product list in Ascending, order by Price
                        docHistoryList.sort((productA, productB) =>
                            productB['entry_date'].compareTo(productA['entry_date']));
                      } else {
                        isAscending = true;
                        // sort the product list in Descending, order by Price
                        docHistoryList.sort((productA, productB) =>
                            productA['entry_date'].compareTo(productB['entry_date']));
                      }
                    });
                  }
                    ),
                    const DataColumn(label: Text('Document Name'),),
                    const DataColumn(label: Text('Document Number'),),
                    const DataColumn(label: Text('Renewal Date'),),
                    const DataColumn(label: Text('Expiry Date'),),
                  ],
                  showCheckboxColumn: false,
                  columnSpacing: 60,
                  horizontalMargin: 20,
                  rows: List.generate(docHistoryList.length, (index) {
                    return DataRow(
                      color: index==0||index%2==0?MaterialStatePropertyAll(ThemeColors.tableRowColor):const MaterialStatePropertyAll(Colors.white),
                        cells: [
                      DataCell(TextDecorationClass().dataRowCell(docHistoryList[index]['entry_date'].toString())),
                      DataCell(TextDecorationClass().dataRowCell(docHistoryList[index]['doc_name'].toString())),
                      DataCell(TextDecorationClass().dataRowCell(docHistoryList[index]['doc_number'].toString())),
                      DataCell(TextDecorationClass().dataRowCell(docHistoryList[index]['renewal_date'].toString())),
                      DataCell(TextDecorationClass().dataRowCell(docHistoryList[index]['expiry_date'].toString())),
                    ]);
                  }),
                ),
              ),
            ),
            const Divider(),
            freshLoad2==1?const SizedBox():Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// Prev Button
                Row(
                  children: [
                    const SizedBox(
                      width: 3,
                    ),
                    prev == true
                        ? InkWell(
                        onTap: () {
                          setState(() {
                            currentPage = 1;
                            docHistoryApiFunc();
                          });
                        },
                        child: const Text(
                          'First Page',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ))
                        : const SizedBox(),
                    const SizedBox(width: 10),
                    prev == true
                        ? Text(
                      'Prev',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade700),
                    )
                        : const SizedBox(),
                    IconButton(
                        onPressed: prev == false
                            ? null
                            : () {
                          setState(() {
                            currentPage > 1
                                ? currentPage--
                                : currentPage = 1;
                            docHistoryApiFunc();
                          });
                        },
                        icon: const Icon(Icons.chevron_left)),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),

                /// Next Button
                Row(
                  children: [
                    IconButton(
                      onPressed: next == false
                          ? null
                          : () {
                        setState(() {
                          currentPage++;
                          docHistoryApiFunc();
                        });
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                    next == true
                        ? Text(
                      'Next',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade700),
                    )
                        : const SizedBox(),
                    const SizedBox(
                      width: 10,
                    ),
                    next == true
                        ? InkWell(
                        onTap: () {
                          setState(() {
                            currentPage = totalPages;
                            docHistoryApiFunc();
                          });
                        },
                        child: const Text(
                          'Last Page',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ))
                        : const SizedBox(),
                  ],
                ),
                widthBox20()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget vehicleDetails(){
    return Container(
      color: ThemeColors.tableRowColor,
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(vehicleInfo[0]['company'].toString(),style:  TextStyle(color: ThemeColors.primary,fontSize: 25,fontWeight: FontWeight.bold),),
              Container(
                // width: 250,
                margin: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextDecorationClass().tableSubHeading2('Engine No : '),
                    TextDecorationClass().vehicleDocInfo(vehicleInfo[0]['engine_number'].toString()),
                  ],
                ),
              ),
              Container(
                // width: 250,
                margin: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextDecorationClass().tableSubHeading2('Chassis No : '),
                    TextDecorationClass().vehicleDocInfo(vehicleInfo[0]['chassis_number']),
                  ],
                ),
              ),
              Container(
                // width: 250,
                margin: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextDecorationClass().tableSubHeading2('On Load Avg : '),
                    TextDecorationClass().vehicleDocInfo(vehicleInfo[0]['on_load_avg'].toString()),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                // width: 250,
                margin: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // TextDecoration().tableSubHeading2('Vehicle No : '),
                    Text(vehicleInfo[0]['vehicle_number'].toString(),style:  TextStyle(color: ThemeColors.primary,fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.right),
                    widthBox5(),
                    Container(
                      height: 15,
                      width: 15,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                          color: vehicleInfo[0]['vehicle_status']==0?ThemeColors.yellowColor:ThemeColors.greenColor,
                          borderRadius: BorderRadius.circular(10)

                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // width: 250,
                margin: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextDecorationClass().tableSubHeading2('MFG Date : '),
                    TextDecorationClass().vehicleDocInfo(vehicleInfo[0]['manu_date'].toString()),
                  ],
                ),
              ),
              Container(
                // width: 250,
                margin: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextDecorationClass().tableSubHeading2('Registration Date : '),
                    TextDecorationClass().vehicleDocInfo(vehicleInfo[0]['reg_date'].toString()),
                  ],
                ),
              ),
              Container(
                // width: 250,
                margin: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextDecorationClass().tableSubHeading2('Empty Avg : '),
                    TextDecorationClass().vehicleDocInfo(vehicleInfo[0]['empty_avg'].toString()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Api---------------------------------------

  Future vehicleEditApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Vehicle/VehicleEdit?vehicle_id=${GlobalVariable.vehicleId.toString()}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future docEditApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDocument/DocumentInfoEdit?docinfo_id=${docinfoId.toString()}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future docRenewApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}VehicleDocument/VehicleDocumentRenewal');
    var body = {
      'vehicle_id': GlobalVariable.vehicleId.toString(),
      'company_name': companyName.text,
      'docinfo_id': docinfoId.toString(),
      'renewal_date': renewalDateApi.text,
      'expiry_date': expiryDateApi.text,
      'doc_number': documentNo.text
    };
    var response = await http.post(url,headers: headers,body: body);
    return response.body.toString();
  }

  Future docHistory() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}VehicleDocument/DocumentInfoRenewalFetch?filter=${GlobalVariable.vehicleId}&keyword=${search.text}&page=$currentPage&limit=$entriesValue');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  Future docListApi() async {
    var headers = {
      'token': Auth.token,
    };
    var url = Uri.parse('${GlobalVariable.baseURL}VehicleDocument/DocumentInfoFetch?filter=${GlobalVariable.vehicleId}');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

}