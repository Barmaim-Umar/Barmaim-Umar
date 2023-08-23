import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:http/http.dart' as http;

class CreateGroupOfCompany extends StatefulWidget {
  const CreateGroupOfCompany({Key? key}) : super(key: key);

  @override
  State<CreateGroupOfCompany> createState() => _CreateGroupOfCompanyState();
}

List<String> entriesList = ["10" , "20" , "30" , "40"];

class _CreateGroupOfCompanyState extends State<CreateGroupOfCompany> {
  var groupId;
  int freshLoad = 0;
  int currentPage = 1;
  List companyGroupList = [];
  List companyGroupEdit = [];
  TextDecorationClass textDecoration = TextDecorationClass();
  final _formKey = GlobalKey<FormState>();
  String entriesValue = entriesList.first;
  TextEditingController createGroupOfCompanyController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  var info ;
  bool update = false;

  companyGroupListApiFunc(){
    companyGroupList.clear();
    setState(() {
      freshLoad = 1;
    });
    companyGroupListApi().then((source){
      info = jsonDecode(source);
      if(info['success']==true){
        companyGroupList.addAll(info['data']);
        setState(() {
          freshLoad = 0;
        });
      }
      else{
        setState(() {
          freshLoad = 1;
          AlertBoxes.flushBarErrorMessage(info['message'], context);
        });
      }

    });
  }

  createCompanyGroupApiFunc(){
    createCompanyGroupApi().then((value){
      var info = jsonDecode(value);
      if(info['success']==true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }
      else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }
  companyGroupUpdateApiFunc(){
    update=false;
    companyGroupUpdateApi().then((value){
      var info = jsonDecode(value);
      if(info['success']==true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }
      else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }
  companyGroupDeleteApiFunc(){
    companyGroupDeleteApi().then((value){
      var info = jsonDecode(value);
      if(info['success']==true){
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
      else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  companyGroupEditApiFunc(){
    companyGroupEditApi().then((value){
      var info = jsonDecode(value);
      if(info['success']==true){
        companyGroupEdit.addAll(info['data']);
        setState(() {
          update = true;
          createGroupOfCompanyController.text=info['data'][0]['group_title'];
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
    companyGroupListApiFunc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: UiDecoration.appBar( update ? "Update Group Of Company" : "Create Group Of Company"),
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
                /// Create Company Form
                Expanded(child: createCompanyForm()),
                const SizedBox(height: 10,),
                /// Company List
                Expanded(child: companyList()),
              ],
            ),
          ),

          /// Desktop
          desktop: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Create New Company
                Expanded(flex: 2, child: createCompanyForm()),
                const SizedBox(width: 10,),
                /// Company List
                Expanded(flex: 3, child: companyList()),
              ],
            ),
          )
      ),
    );
  }

  createCompanyForm(){
    return  Container(
      decoration: UiDecoration().formDecoration(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child:
                // TextDecoration().formTitle('New Ledger'),
                textDecoration.heading( update ? 'Update Group Of Company' : 'Create Group Of Company'),
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
                      FormWidgets().alphanumericField('Company Name', 'Company Name' , createGroupOfCompanyController , context , focusNode: focusNode1),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Reset Button
                          ElevatedButton(
                              style: ButtonStyles.smallButton(
                                  ThemeColors.backgroundColor, ThemeColors.darkBlack),
                              onPressed: () {
                                setState(() {
                                _formKey.currentState!.reset();
                                createGroupOfCompanyController.clear();
                                });
                              }, child: const Text("Reset")),

                          const SizedBox(width: 20,),

                          // Create Button
                          ElevatedButton(
                              style: ButtonStyles.smallButton(
                                  ThemeColors.primaryColor, ThemeColors.whiteColor),
                              onPressed: () {
                                if(_formKey.currentState!.validate()){
                                  _formKey.currentState!.save();

                                  // after validation
                                  createCompanyGroupApiFunc();
                                      companyGroupListApiFunc();
                                }
                              },
                              // onPressed: () {
                              //   if(createGroupOfCompanyController.text.isEmpty){
                              //     AlertBoxes.flushBarErrorMessage("Enter Company Name", context);
                              //   }
                              //   if(update==true){
                              //     companyGroupUpdateApiFunc();
                              //     companyGroupListApiFunc();
                              //   }
                              //   else {
                              //     createCompanyGroupApiFunc();
                              //     companyGroupListApiFunc();
                              //   }
                              // },
                              child: Text(update == true?'Update':"Create")),
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
    );
  }

  companyList(){
    return Container(
      decoration: UiDecoration().formDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10 , left: 10),
            alignment: Alignment.centerLeft,
            child:
            textDecoration.heading('Company List'),
          ),
          const Divider(),
          Expanded(
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
                      SizedBox(
                        width: 80,
                        child: SearchDropdownWidget(dropdownList: entriesList, hintText: entriesList.first,
                            onChanged: (value) {
                              setState(() {
                                entriesValue = value!;
                                companyGroupListApiFunc();
                              });
                            }, selectedItem: entriesValue,
                          maxHeight: 200,
                          showSearchBox: false,
                        ),
                      ),

                      const Text(' entries'),
                      const Spacer(),
                      // Search
                      const Text('Search: '),
                      Expanded(
                        child: TextFormField(
                          decoration: UiDecoration().outlineTextFieldDecoration('Search', ThemeColors.primary),
                          controller: searchController,
                          onFieldSubmitted: (value) {
                            companyGroupListApiFunc();
                          },
                          onChanged: (value) {
                            companyGroupListApiFunc();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10,),

                /// DataTable
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                              child: SizedBox(
                                  width: double.maxFinite,
                                  child: freshLoad == 1? const Center(child: CircularProgressIndicator()) :buildDataTable()),
                            ),
                            const Divider(),
                          ],
                        ))),
                freshLoad == 1?const SizedBox():Row(
                  children: [
                    /// Prev Button
                    Row(
                      children: [
                        SizedBox(width: 3,),
                        info['prev'] == true ?InkWell(onTap: () {
                          setState(() {
                            currentPage=1;
                            companyGroupListApiFunc();
                          });
                        },
                            child: Text('First Page',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),)):SizedBox(),
                        SizedBox(width: 10),
                        info['prev'] == true ?Text('Prev',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade700),):const SizedBox(),
                        IconButton(
                            onPressed: info['prev'] == false ? null : () {
                              setState(() {
                                currentPage > 1 ? currentPage-- : currentPage = 1;
                                companyGroupListApiFunc();
                              });
                            }, icon: const Icon(Icons.chevron_left)),
                      ],
                    ),
                    const SizedBox(width: 30,),
                    /// Next Button
                    Row(
                      children: [
                        IconButton(
                          onPressed: info['next'] == false ? null : () {
                            setState(() {
                              currentPage++;
                              companyGroupListApiFunc();
                            });
                          },
                          icon: const Icon(Icons.chevron_right),
                        ),
                        info['next'] == true ?Text('Next',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade700),):const SizedBox(),
                        SizedBox(width: 10,),
                        info['next'] == true ?InkWell(onTap: () {
                          setState(() {
                            currentPage=info['total_pages'];
                            companyGroupListApiFunc();
                          });
                        },
                            child: Text('Last Page',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),)):SizedBox(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDataTable() {
    return DataTable(
      columns: [
        DataColumn(label: TextDecorationClass().dataColumnName("Company")),
        DataColumn(label: TextDecorationClass().dataColumnName("Action")),
      ],
      rows:  List.generate(companyGroupList.length, (index) {
        return DataRow(
            color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
            cells: [
              DataCell(TextDecorationClass().dataRowCell(companyGroupList[index]['group_title'].toString())),
              DataCell(
                Row(
                  children: [
                    // edit Icon
                    UiDecoration().actionButton( ThemeColors.editColor,IconButton(padding: const EdgeInsets.all(0),
                        onPressed: () {
                          setState(() {
                            groupId = companyGroupList[index]['group_id'];
                            companyGroupEditApiFunc();
                          });
                        },
                        icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),

                // delete Icon
                    UiDecoration().actionButton( ThemeColors.deleteColor,IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return
                          AlertDialog(
                            title: const Text("Are you sure you want to delete"),
                            actions: [
                              UiDecoration().cancelButton(context: context, onPressed: () {
                                Navigator.pop(context);
                              }),

                             UiDecoration().deleteButton(context: context, onPressed: () {
                               setState(() {
                                 groupId = companyGroupList[index]['group_id'];
                                 companyGroupDeleteApiFunc();
                                 companyGroupListApiFunc();
                               });
                               Navigator.pop(context);
                             })
                            ],
                          );
                      },);
                    }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),
                  ],
                ),),
            ]);
      }),

    );
  }

  createCompanyGroupApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Company/CompanyGroupStore');
    var body = {
      'group_title': createGroupOfCompanyController.text
    };
    var response = await http.post(url,headers: headers,body: body);
    return response.body.toString();
  }
  companyGroupUpdateApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Company/CompanyGroupStore');
    var body = {
      'group_title': createGroupOfCompanyController.text,
      'group_id': groupId.toString()
    };
    var response = await http.post(url,headers: headers,body: body);
    return response.body.toString();
  }

  companyGroupListApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Company/CompanyGroupList?limit=${int.parse(entriesValue)}&page=$currentPage&keyword=${searchController.text}');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  companyGroupEditApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Company/CompanyGroupEdit?group_id=$groupId');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }
  companyGroupDeleteApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Company/CompanyGroupdelete?group_id=$groupId');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

}





// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:pfc/AlertBoxes.dart';
// import 'package:pfc/responsive.dart';
// import 'package:pfc/utility/colors.dart';
// import 'package:pfc/utility/styles.dart';
//
// class CreateGroupOfCompany extends StatefulWidget {
//   const CreateGroupOfCompany({Key? key}) : super(key: key);
//
//   @override
//   State<CreateGroupOfCompany> createState() => _CreateGroupOfCompanyState();
// }
//
//   List<String> entriesList = ["10" , "20" , "30" , "40" , "50" , "100"];
//
// class _CreateGroupOfCompanyState extends State<CreateGroupOfCompany> {
//
//   TextDecoration textDecoration = TextDecoration();
//
//   final formKey = GlobalKey<FormState>();
//   String entriesValue = entriesList.first;
//   TextEditingController createGroupOfCompanyController = TextEditingController();
//   TextEditingController searchController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: UiDecoration.appBar("Create Group Of List"),
//       // backgroundColor: ThemeColors.backgroundColor,
//       body: Responsive(
//         /// Mobile
//           mobile: const Text("Mobile"),
//
//           /// Tablet
//           tablet: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// Create Company Form
//                 Expanded(child: createCompanyForm()),
//                 const SizedBox(height: 10,),
//                 /// Company List
//                 Expanded(child: companyList()),
//               ],
//             ),
//           ),
//
//           /// Desktop
//           desktop: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// Create New Company
//                 Expanded(child: createCompanyForm()),
//                 const SizedBox(width: 10,),
//                 /// Company List
//                 Expanded(child: companyList()),
//               ],
//             ),
//           )
//       ),
//     );
//   }
//
//   createCompanyForm(){
//     return  Container(
//       decoration: UiDecoration().formDecoration(),
//       child: Form(
//         key: formKey,
//         child: Column(
//           children: [
//             Container(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 10.0, left: 10.0),
//                 child:
//                 // TextDecoration().formTitle('New Ledger'),
//                 textDecoration.heading('Create Group Of Company'),
//               ),
//             ),
//             const Divider(),
//             // form
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Container(
//                   padding: const EdgeInsets.only(top: 8 , left: 8, bottom: 8 ,right: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       FormWidgets().formDetails('Company Name', 'Company Name' , createGroupOfCompanyController),
//
//                       // Buttons
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // Reset Button
//                           ElevatedButton(
//                               style: ButtonStyles.smallButton(
//                                   ThemeColors.backgroundColor, ThemeColors.darkBlack),
//                               onPressed: () {
//                                 formKey.currentState!.reset();
//                               }, child: const Text("Reset")),
//                           const SizedBox(width: 20,),
//                           // Create Button
//                           ElevatedButton(
//                               style: ButtonStyles.smallButton(
//                                   ThemeColors.primaryColor, ThemeColors.whiteColor),
//                               onPressed: () {
//                                 if(createGroupOfCompanyController.text.isEmpty){
//                                   AlertBoxes.flushBarErrorMessage("Enter Company Name", context);
//                                 } else {
//                                   "";
//                                 }
//                               }, child: const Text("Create")),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   companyList(){
//     return Container(
//       decoration: UiDecoration().formDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.only(top: 10 , left: 10),
//             alignment: Alignment.centerLeft,
//             child:
//             textDecoration.heading('Company List'),
//           ),
//           const Divider(),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // dropdown & search
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Row(
//                     children: [
//                       const Text('Show '),
//                       // dropdown
//                       DropdownDecoration().dropdownDecoration2(DropdownButton<String>(
//                         borderRadius: BorderRadius.circular(5),
//                         dropdownColor: ThemeColors.dropdownColor,
//                         underline: Container(
//                           decoration: const BoxDecoration(border: Border()),
//                         ),
//                         isExpanded: true,
//                         hint: Text(
//                           'Select Entries',
//                           style: TextStyle(color: ThemeColors.dropdownTextColor),
//                         ),
//                         icon: DropdownDecoration().dropdownIcon(),
//                         value: entriesValue,
//                         elevation: 16,
//                         style: DropdownDecoration().dropdownTextStyle(),
//                         onChanged: (String? newValue) {
//                           // This is called when the user selects an item.
//                           setState(() {
//                             entriesValue = newValue!;
//                           });
//                         },
//                         items: entriesList.map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value.toString(),
//                             child: Text(value),
//                           );
//                         }).toList(),
//                       )),
//                       const Text(' entries'),
//                       const Spacer(),
//                       // Search
//                       const Text('Search: '), Expanded(child: FormWidgets().textFormField('Search' , searchController )),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 10,),
//
//                 /// DataTable
//                 Expanded(
//                     child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ScrollConfiguration(
//                               behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
//                               child: SizedBox(
//                                   width: double.maxFinite,
//                                   child: buildDataTable()),
//                             ),
//                             const Divider(),
//                           ],
//                         ))),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildDataTable() {
//     return DataTable(
//       columns: [
//         DataColumn(label: TextDecoration().dataColumnName("Company")),
//         DataColumn(label: TextDecoration().dataColumnName("Action")),
//       ],
//       rows:  List.generate(100, (index) {
//         return DataRow(
//             cells: [
//               DataCell(TextDecoration().dataRowCell("company name")),
//               DataCell(
//                 // delete Icon
//                 UiDecoration().actionButton( ThemeColors.deleteColor,IconButton(padding: const EdgeInsets.all(0),onPressed: () {
//                   showDialog(context: context, builder: (context) {
//                     return
//                       AlertDialog(
//                         title: const Text("Are you sure you want to delete"),
//                         actions: [
//                           TextButton(onPressed: () {
//                             Navigator.pop(context);
//                           }, child: const Text("Cancel")),
//
//                           TextButton(onPressed: () {
//                             setState(() {
//
//                             });
//                             Navigator.pop(context);
//                           }, child: const Text("Delete"))
//                         ],
//                       );
//                   },);
//                 }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),),
//             ]);
//       }),
//
//     );
//   }
// }
//
//
