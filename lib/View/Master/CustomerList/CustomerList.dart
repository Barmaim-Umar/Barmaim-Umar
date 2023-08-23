import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/View/Master/CreateCustomer/CreateCustomer.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:http/http.dart' as http;

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

List<String> selectGroupOfCompanyList = ['Select Group Of Company' , 'Company1' , 'Company2' , 'Company3' , '4' , '5' , '6'];
List<String> typeOfCompanyList = ['Select Type Of Company' , 'type1' , 'type2' , 'type3' , '4' , '5' , '6'];
List<String> entriesList = ['10' , '20' , '30' , '40' ];
List customerList = [];
int clientID = 0;
class _CustomerListState extends State<CustomerList> {
  var customerID;
  int freshLoad = 0;
  String selectGroupOfCompanyValue = selectGroupOfCompanyList.first;
  String typeOfCompanyValue = typeOfCompanyList.first;
  String entriesValue = entriesList.first;

  // Exporting data
  List data = [];
  List<List<dynamic>> exportData = [];

  TextDecorationClass textDecoration = TextDecorationClass();

  final formKey = GlobalKey<FormState>();

  TextEditingController companyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();
  TextEditingController openingBalanceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController mobileNo2Controller = TextEditingController();
  TextEditingController email2Controller = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    customerFetchApiFunc();
    super.initState();
  }

  // API
  customerFetchApiFunc(){
    setState(() {
      freshLoad = 1;
    });
    customerFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        customerList.clear();
        customerList.addAll(info['data']);
        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.totalPages = info['total_pages'];
        GlobalVariable.currentPage = info['page'];
        GlobalVariable.next = info['next'];
        GlobalVariable.prev = info['prev'];
        setStateMounted(() {
          freshLoad = 0;
        });
      }else {
        setState(() {
          freshLoad = 1;
        });
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        debugPrint("SUCCESS FALSE");
      }
    });
    // Export Data
    exportDataApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        data.clear();
        exportData.clear();
        data.addAll(info['data']);
        setStateMounted(() { freshLoad = 0;});
      }else{
        setState(() {
          freshLoad = 1;
        });
      }
    });
  }

  customerDeleteApiFunc(){
    customerDeleteApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        setState((){
          AlertBoxes.flushBarSuccessMessage(info['message'], context);
        });
      }else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  customerEditApiFunc() {
    customerEditApi().then((value) {
      var info = jsonDecode(value);
      print("editAPIResponse: $info");
      if(info['success'] == true){
        setState(() {

          /// storing in globalVariable
          GlobalVariable.customerEditList.clear();
          GlobalVariable.customerEditList.addAll(info['data']);

          companyNameController.text = info['data'][0]['company_name'];
          addressController.text = info['data'][0]['client_address'];
          stateController.text = info['data'][0]['client_state'];
          mobileNoController.text = info['data'][0]['client_contact_number'];
          emailController.text = info['data'][0]['client_email'];
          websiteController.text = info['data'][0]['client_website'];
          panNoController.text = info['data'][0]['client_pan_number'];
          gstNoController.text = info['data'][0]['client_gst_number'];
          openingBalanceController.text = info['data'][0]['opening_balance'] ?? '_';

          freshLoad = 0;
          GlobalVariable.update = true;
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  const CreateCustomer(),),);

        });
      }else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  customerUpdateApiFunc(){
    customerUpdateApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: UiDecoration.appBar("Customer List"),
      body: Responsive(
        /// Mobile
          mobile: const Text("Mobile"),

          /// Tablet
          tablet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ledger list
                Expanded(child: customerTableList()),
              ],
            ),
          ),

          /// Desktop
          desktop: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// New Ledger
                // Expanded(child: customerForm()),
                // const SizedBox(width: 10,),
                /// ledger list
                Expanded(child: customerTableList()),
              ],
            ),
          )
      ),
    );
  }

  customerTableList(){
    return Container(
      decoration: UiDecoration().formDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10 , left: 10),
            alignment: Alignment.centerLeft,
            child:
            textDecoration.heading('Customer List'),
          ),
          const Divider(),
          // dropdown & search
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text('Show '),
                // dropdown
                SizedBox(
                  width: 80,
                  child: SearchDropdownWidget(
                      dropdownList: entriesList,
                      hintText: entriesList.first,
                      onChanged: (value) {
                        // This is called when the user selects an item.
                        setState(() {
                          entriesValue = value!;
                          customerFetchApiFunc();
                        });
                      },
                      selectedItem: entriesValue,
                    showSearchBox: false,
                    maxHeight: 200,
                  ),
                ),
                const Text(' entries'),
                const Spacer(),
                // Search
                const Text('Search: '), Expanded(child: FormWidgets().textFormField('Search' , searchController , onFieldSubmitted: (value){
                  customerFetchApiFunc();
                })),
              ],
            ),
          ),
          // buttons
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Wrap(
              runSpacing: 5,
              children: [
                // BStyles().button('CSV', 'Export to CSV', "assets/csv2.png"),
                // const SizedBox(width: 10,),
                BStyles().button('Excel', 'Export to Excel', "assets/excel.png", onPressed: () {
                  setState(() {
                    addDataToExport();
                  });
                  UiDecoration().excelFunc(exportData);
                },),
                const SizedBox(width: 10,),

                BStyles().button('PDF', 'Export to PDF', "assets/pdf.png", onPressed: () {
                  setState(() {
                    addDataToExport();
                  });
                  UiDecoration().pdfFunc(exportData);
                },),
                const SizedBox(width: 10,),

                BStyles().button('Print', 'Print', "assets/print.png", onPressed: () {
                  setState(() {
                    addDataToExport();
                  });
                  UiDecoration().generatePrintDocument(exportData);
                },),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                              PointerDeviceKind.trackpad
                            }),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DataTable(
                              columnSpacing: 30,
                              dataRowHeight: 65,
                              columns: [
                                DataColumn(label: TextDecorationClass().dataColumnName("Company Name")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Group Of Company")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Email")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Mobile")),
                                DataColumn(label: TextDecorationClass().dataColumnName("Actions")),
                              ],
                              rows:  List.generate(customerList.length, (index) {
                                return DataRow(
                                  //Check Odd Even
                                    color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
                                    cells: [
                                      DataCell(TextDecorationClass().dataRowCell(customerList[index]['company_name'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(customerList[index]['company_group_id'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(customerList[index]['client_email'].toString())),
                                      DataCell(TextDecorationClass().dataRowCell(customerList[index]['client_contact_number'].toString())),
                                      DataCell(Row(
                                        children: [
                                          // edit Icon
                                          UiDecoration().actionButton(ThemeColors.editColor, LayoutBuilder(
                                              builder: (BuildContext context, BoxConstraints constraints) {
                                                return IconButton(padding: const EdgeInsets.all(0), onPressed: () {
                                                  /// Navigation to Form page
                                                  // Navigator.pop(context);
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateCustomer(),));

                                                  clientID = customerList[index]['client_id'];
                                                  customerEditApiFunc();

                                                  /// edit popup
                                                  // showDialog(context: context, builder: (context) {
                                                  //   return  StatefulBuilder(builder: (context, setState) {
                                                  //     return AlertDialog(
                                                  //       content: Container(
                                                  //         width: 600,
                                                  //         decoration: UiDecoration().formDecoration(),
                                                  //         child: Column(
                                                  //           children: [
                                                  //             Container(
                                                  //               alignment: Alignment.centerLeft,
                                                  //               child: Padding(
                                                  //                 padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                                                  //                 child:
                                                  //                 // TextDecoration().formTitle('New Ledger'),
                                                  //                 textDecoration.heading('Create Customer Form'),
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
                                                  //                       FormWidgets().formDetails('Company Name', 'Company Name' , companyNameController),
                                                  //                       FormWidgets().formDetails2('Select Group Of Company',DropdownDecoration().dropdownDecoration(DropdownButton<String>(
                                                  //                         borderRadius: BorderRadius.circular(5),
                                                  //                         dropdownColor: ThemeColors.dropdownColor,
                                                  //                         underline: Container(
                                                  //                           decoration: const BoxDecoration(border: Border()),
                                                  //                         ),
                                                  //                         isExpanded: true,
                                                  //                         hint: Text(
                                                  //                           'Select Group Of Company',
                                                  //                           style: TextStyle(color: ThemeColors.dropdownTextColor),
                                                  //                         ),
                                                  //                         icon: DropdownDecoration().dropdownIcon(),
                                                  //                         value: selectGroupOfCompanyValue,
                                                  //                         elevation: 16,
                                                  //                         style: DropdownDecoration().dropdownTextStyle(),
                                                  //                         onChanged: (String? newValue) {
                                                  //                           // This is called when the user selects an item.
                                                  //                           setState(() {
                                                  //                             selectGroupOfCompanyValue = newValue!;
                                                  //                           });
                                                  //                         },
                                                  //                         items: selectGroupOfCompanyList.map<DropdownMenuItem<String>>((String value) {
                                                  //                           return DropdownMenuItem<String>(
                                                  //                             value: value.toString(),
                                                  //                             child: Text(value),
                                                  //                           );
                                                  //                         }).toList(),
                                                  //                       ))),
                                                  //                       FormWidgets().formDetails2('Select Type Of Company',DropdownDecoration().dropdownDecoration(DropdownButton<String>(
                                                  //                         borderRadius: BorderRadius.circular(5),
                                                  //                         dropdownColor: ThemeColors.dropdownColor,
                                                  //                         underline: Container(
                                                  //                           decoration: const BoxDecoration(border: Border()),
                                                  //                         ),
                                                  //                         isExpanded: true,
                                                  //                         hint: Text(
                                                  //                           'Select Type Of Company',
                                                  //                           style: TextStyle(color: ThemeColors.dropdownTextColor),
                                                  //                         ),
                                                  //                         icon: DropdownDecoration().dropdownIcon(),
                                                  //                         value: typeOfCompanyValue,
                                                  //                         elevation: 16,
                                                  //                         style: DropdownDecoration().dropdownTextStyle(),
                                                  //                         onChanged: (String? newValue) {
                                                  //                           // This is called when the user selects an item.
                                                  //                           setState(() {
                                                  //                             typeOfCompanyValue = newValue!;
                                                  //                           });
                                                  //                         },
                                                  //                         items: typeOfCompanyList.map<DropdownMenuItem<String>>((String value) {
                                                  //                           return DropdownMenuItem<String>(
                                                  //                             value: value.toString(),
                                                  //                             child: Text(value),
                                                  //                           );
                                                  //                         }).toList(),
                                                  //                       ))),
                                                  //                       FormWidgets().formDetails('Address', 'Address' , addressController),
                                                  //                       FormWidgets().formDetails('State', 'State' , stateController),
                                                  //                       FormWidgets().formDetails('Mobile No', 'Mobile No' , mobileNoController),
                                                  //                       FormWidgets().formDetails('Email ID', 'Email ID' , emailController),
                                                  //                       FormWidgets().formDetails('Website', 'Website' , websiteController),
                                                  //                       FormWidgets().formDetails('PAN No', 'PAN No' , panNoController),
                                                  //                       FormWidgets().formDetails('GST No', 'GST No' , gstNoController),
                                                  //
                                                  //                     ],
                                                  //                   ),
                                                  //                 ),
                                                  //               ),
                                                  //             )
                                                  //           ],
                                                  //         ),
                                                  //       ),
                                                  //       actions: [
                                                  //         TextButton(onPressed: () {
                                                  //           Navigator.pop(context);
                                                  //         }, child: const Text("Cancel")),
                                                  //         TextButton(onPressed: () {
                                                  //           customerUpdateApiFunc();
                                                  //           customerFetchApiFunc();
                                                  //           Navigator.pop(context);
                                                  //         }, child: const Text("Update"))
                                                  //       ],
                                                  //     );
                                                  //   },);
                                                  // },);
                                                }, icon: const Icon(Icons.edit, size: 15, color: Colors.white,));
                                              }
                                          )),

                                          // delete Icon
                                          UiDecoration().actionButton(ThemeColors.deleteColor, IconButton(
                                              padding: const EdgeInsets.all(0), onPressed: () {
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
                                                        clientID = customerList[index]['client_id'];
                                                        customerDeleteApiFunc();
                                                        customerFetchApiFunc();
                                                      });
                                                      Navigator.pop(context);
                                                    }),
                                                  ],
                                                );
                                            },
                                            );
                                          },
                                              icon: const Icon(Icons.delete, size: 15, color: Colors.white,),),),

                                          // Info Icon
                                          UiDecoration().actionButton(ThemeColors.infoColor, IconButton(
                                              padding: const EdgeInsets.all(0),
                                              onPressed: () {
                                                clientID = customerList[index]['client_id'];
                                                customerEditApiFunc();
                                                showInfoPopUp(index);
                                              },
                                              icon: const Icon(Icons.info_outlined, size: 15,
                                                color: Colors.white,
                                              ),
                                          ),
                                          ),
                                        ],
                                      ))
                                    ]);
                              })
                          ),
                        ),
                      ),
                    ),
                    // Pagination
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        Text("Total Records: ${GlobalVariable.totalRecords}"),

                        const SizedBox(width: 100,),

                        // First Page Button
                        IconButton(onPressed: !GlobalVariable.prev ? null : () {
                          setState(() {
                            GlobalVariable.currentPage = 1;
                            customerFetchApiFunc();
                          });

                        }, icon: const Icon(Icons.first_page)),

                        // Prev Button
                        IconButton(
                            onPressed: GlobalVariable.prev == false ? null : () {
                              setState(() {
                                GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                                customerFetchApiFunc();
                              });
                            }, icon: const Icon(Icons.chevron_left)),

                        const SizedBox(width: 30,),

                        // Next Button
                        IconButton  (
                            onPressed: GlobalVariable.next == false ? null : () {
                              setState(() {
                                GlobalVariable.currentPage++;
                                customerFetchApiFunc();
                              });
                            }, icon: const Icon(Icons.chevron_right)),

                        // Last Page Button
                        IconButton(onPressed: !GlobalVariable.next ? null : () {
                          setState(() {
                            GlobalVariable.currentPage = GlobalVariable.totalPages;
                            customerFetchApiFunc();
                          });

                        }, icon: const Icon(Icons.last_page)),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // INFO POPUP
  showInfoPopUp(index){
    showDialog(context: context, builder: (context) {
      return
        StatefulBuilder(
          builder: (context, setState) {
            return
              AlertDialog(

                content:Container(
                  width: 750,
                  decoration: UiDecoration().formDecoration(),
                  child: Form(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                            child:
                            textDecoration.heading('Ledger Info'),
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
                                  FormWidgets().infoField('Company Name', '-' , companyNameController , context),
                                  FormWidgets().infoField('Select Group Of Company','-',TextEditingController(text: selectGroupOfCompanyValue) , context),
                                  FormWidgets().infoField('Select Type Of Company', '-' , TextEditingController(text: typeOfCompanyValue) , context),
                                  FormWidgets().infoField('Address', '-' , addressController , context),
                                  FormWidgets().infoField('State', '-' , stateController , context),
                                  FormWidgets().infoField('Mobile No', '-' , mobileNoController , context),
                                  FormWidgets().infoField('Email ID', '-' , emailController , context),
                                  FormWidgets().infoField('Website', '-' , websiteController , context),
                                  FormWidgets().infoField('PAN No', '-' , panNoController , context),
                                  FormWidgets().infoField('GST No', '-' , gstNoController , context),
                                  FormWidgets().infoField('Opening Balance', '-' , openingBalanceController , context),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                actions: [
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: const Text("OK")),

                ],
              );
          },
        );
    },
    );
  }

  addDataToExport(){
    exportData.clear();
    exportData=[
      ['Company Name','Group Of Company','Email','Mobile'],
    ];
    for (int index = 0; index < data.length; index++) {
      List<String> rowData = [
        data[index]['company_name'].toString(),
        data[index]['company_group_id'].toString(),
        data[index]['client_email'].toString(),
        data[index]['client_contact_number'].toString(),
      ];
      exportData.add(rowData);
    }
  }

  // API
  Future customerFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Company/CompanyClientFetch?limit=$entriesValue&page=${GlobalVariable.currentPage}&keyword=${searchController.text}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future exportDataApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Company/CompanyClientFetch?keyword=${searchController.text}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future customerDeleteApi() async {
    var headers = {
      'token': Auth.token
    };

    var url = Uri.parse("${GlobalVariable.baseURL}Company/CompanyClientDelete?client_id=$clientID");

    var response = await http.get(url , headers: headers);

    return response.body.toString();
  }

  Future customerEditApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Company/CompanyClientEdit?client_id=$clientID");
    var response = await http.get(url , headers: headers);
    print("88ky8y: ${response.body.toString()}");
    return response.body.toString();
  }

  Future customerUpdateApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var url = Uri.parse("${GlobalVariable.baseURL}Company/CompanyClientStore");

    var body = {
      'company_name': companyNameController.text,
      'company_group_id': selectGroupOfCompanyValue,
      'company_type': typeOfCompanyValue,
      'client_address': addressController.text,
      'client_state': stateController.text,
      'client_contact_number': mobileNoController.text,
      'client_email': emailController.text,
      'client_website': websiteController.text,
      'client_pan_number': panNoController.text,
      'client_gst_number': gstNoController.text,
      'created_by': '2',
      'client_id': clientID.toString()
    };

    var response = await http.post(url , headers: headers , body: body);

    return response.body.toString();

  }


  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }
}