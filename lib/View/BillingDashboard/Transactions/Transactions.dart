import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

List<String> account = ['Select Account', '1', '2', '3'];

class _TransactionsState extends State<Transactions> with Utility{

  @override
  void initState() {
    transactionListApiFunc();
    super.initState();
  }

  List transactionList = [];
  int freshLoad = 1;

  TextEditingController toDate = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  String dropdownValue = account.first;
  bool isExpanded = false ;
  bool next = false;
  bool previous = false;
  int page = 0;
  int pages = 0;
  ScrollController listController = ScrollController();

  transactionListApiFunc(){
    transactionListApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        transactionList.add(info['data']);
        setState(() {
          freshLoad = 0;
        });
      } else {
        debugPrint("Success False");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor,
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        shadowColor: Colors.transparent,
        backgroundColor: ThemeColors.whiteColor,
        toolbarHeight: 60,
        foregroundColor: Colors.black,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // const Text("Transactions", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: ThemeColors.primaryColor),),
            // const Spacer(),
            Container(
              width: 200,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: ThemeColors.grey200,
                borderRadius: BorderRadius.circular(6)
              ),
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(5),
                dropdownColor: ThemeColors.whiteColor,
                underline: Container(
                  decoration: const BoxDecoration(border: Border()),
                ),
                isExpanded: true,
                hint: const Text(
                  '',
                  style: TextStyle(color: ThemeColors.darkBlack),
                ),
                icon: const Icon(
                  CupertinoIcons.chevron_down,
                  color: ThemeColors.darkBlack,
                  size: 20,
                ),
                iconSize: 30,
                value: dropdownValue,
                elevation: 16,
                style: const TextStyle(
                    color: ThemeColors.darkGreyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.ellipsis),
                onChanged: (String? newValue) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: account.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 20,),
            SizedBox(
              width:145,
              height: 38,
              child:
              TextFormField(
                readOnly: true,
                controller: fromDate,
                decoration: UiDecoration().dateFieldDecoration('From Date'),
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
                      fromDate.text = "${value.year}-$month-$day";
                    });
                  });
                },
              ),
            ),
            const SizedBox(width: 10,),
            SizedBox(
              width:145,
              height: 38,
              child:
              TextFormField(
                readOnly: true,
                controller: toDate,
                decoration: UiDecoration().dateFieldDecoration('To Date'),
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
                      toDate.text = "${value.year}-$month-$day";
                    });
                  });
                },
              ),
            ),
            const SizedBox(width: 10,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.primaryColor
              ),
                onPressed: (){
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Filter'),
                )),

          ],
        ),
      ),
      body: Column(
        children: [
          heightBox20(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  flex: 5,
                  child: Text(
                    "Date",
                    style: TextStyle(
                        color: ThemeColors.redColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Text(
                      "Transaction ID",
                      style: TextStyle(
                          color: ThemeColors.redColor,
                          fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    flex: 10,
                    child: Text(
                      "Opposite A/c",
                      style: TextStyle(
                          color: ThemeColors.redColor,
                          fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    flex: 10,
                    child: Text(
                      "Description",
                      style: TextStyle(
                          color: ThemeColors.redColor,
                          fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    flex: 6,
                    child: Text(
                      "Debit",
                      style: TextStyle(
                          color: ThemeColors.redColor,
                          fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    flex: 6,
                    child: Text(
                      "Credit",
                      style: TextStyle(
                          color: ThemeColors.redColor,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                const EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                        controller: listController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: transactionList.isEmpty ? 1 : transactionList[0].length,
                        itemBuilder: (context, index) {
                          // print('this is data===============$rows');
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      children: [
                                        Text(freshLoad == 1 ? "FreshLoad = 1" : transactionList[0][index]['ledger_date'] ?? "null",
                                          style: TextStyle(
                                            color: ThemeColors.grey700,
                                          ),textAlign: TextAlign.start,
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Text(freshLoad == 1 ? "FreshLoad = 1" : transactionList[0][index]['transaction_id'].toString() ,
                                        style: TextStyle(
                                          color: ThemeColors.grey700,
                                        ),
                                        textAlign: TextAlign.start,
                                      )),
                                  Expanded(
                                      flex: 10,
                                      child: Text('-',
                                        style: TextStyle(
                                          color: ThemeColors.grey700,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 10,
                                      child: Text('-',
                                        style: TextStyle(
                                          color: ThemeColors.grey700,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 6,
                                      child: Text('-',
                                        style: TextStyle(
                                          color: ThemeColors.grey700,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 6,
                                      child: Text('-',
                                        style: TextStyle(
                                          color: ThemeColors.grey700,
                                        ),
                                      )),
                                ],
                              ),
                              const Divider()
                            ],
                          );
                        }
                    ),
                    Row(
                      children: const [
                        Expanded(flex:30,child: Text("Total",style: TextStyle(fontWeight: FontWeight.w700,color:ThemeColors.redColor),)),
                        Expanded(flex:6,child: Text("total-debit",style: TextStyle(fontWeight: FontWeight.w700,color:ThemeColors.redColor),),),
                        Expanded(flex:6,child: Text("total-credit",style: TextStyle(fontWeight: FontWeight.w700,color:ThemeColors.redColor),),),
                      ],
                    ),
                    const Divider()
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                previous==true?Container():InkWell(
                  onTap: () {
                    setState(() {
                      page--;
                      previous = false;
                    });
                    },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 15,
                        color: ThemeColors.primaryColor,
                      ),
                      Text(
                        " Previous",
                        style: TextStyle(
                            color: ThemeColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                next==true?Container(): InkWell(
                  onTap: () {
                    setState(() {
                      page++;
                      next = false;
                    });
                  },
                  child: Row(
                    children: const [
                      Text(
                        "Next ",
                        style: TextStyle(
                            color: ThemeColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: ThemeColors.primaryColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 27,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // API
  Future transactionListApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/TransactionFetch?limit=22&page=1");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

}
