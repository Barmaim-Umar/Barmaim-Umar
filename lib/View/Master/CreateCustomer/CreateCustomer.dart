import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/View/Master/CustomerList/CustomerList.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:http/http.dart' as http;

class CreateCustomer extends StatefulWidget {
  const CreateCustomer({Key? key }) : super(key: key);

  @override
  State<CreateCustomer> createState() => _CreateCustomerState();
}

List<String> selectGroupOfCompanyList = [];
List<String> ledgerGroupList = [];
List ledgerGroupListWithID = [];
List<String> entriesList = ['10' , '20' , '30' , '40' , '50'];
List<String> stateList = [];
class _CreateCustomerState extends State<CreateCustomer> {
  List additionalInfo = [];
  String groupOfCompanyValue = "";
  String ledgerGroup = "";
  String entriesValue = entriesList.first;
  String stateDropdownValue = "";
  TextDecorationClass textDecoration = TextDecorationClass();
  List companyGroupListWithID = [];

  FocusNode focusNode1 = FocusNode();
  var additionalDetailsID;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  TextEditingController companyNameController = TextEditingController(text: "test Name 1");
  TextEditingController addressController = TextEditingController(text: "test Address 1");
  TextEditingController stateController = TextEditingController(text: "test State 1"); // not in use. Replaced with Dropdown
  TextEditingController mobileNoController = TextEditingController(text: "9898989898");
  TextEditingController emailController = TextEditingController(text: "test@gmail.com");
  TextEditingController websiteController = TextEditingController(text: "testWebsite.com");
  TextEditingController panNoController = TextEditingController(text: "23424");
  TextEditingController gstNoController = TextEditingController(text: "243323");
  TextEditingController openingBalanceController = TextEditingController(text: "2500");
  // Additional Info
  TextEditingController nameController = TextEditingController(text: "test Name 1");
  TextEditingController designationController = TextEditingController(text: "test design 1");
  TextEditingController mobileNo2Controller = TextEditingController(text: "9999999999");
  TextEditingController email2Controller = TextEditingController(text: "mail@gmail.com");

  TextEditingController searchController = TextEditingController();
  int freshLoad = 0;
  var companyGroupId;
  var groupId;
  var clientId;


  @override
  void dispose() {
    super.dispose();
    GlobalVariable.update = false;
  }

  @override
  void initState() {
    super.initState();
    groupFetchApiFunc();
    stateDropdownApiFunc();
    companyGroupDropdownApiFunc();
    updateCustomer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });
  }



  // API
  createCustomerApiFunc(){
    createCustomerApi().then((value) {
      try{
        var info = jsonDecode(value);
        if(info['success'] == true){
          AlertBoxes.flushBarSuccessMessage(info['message'], context);
        } else{
          AlertBoxes.flushBarErrorMessage(info['message'], context);
        }
      }
      catch(e){
        AlertBoxes.flushBarErrorMessage("$e", context);
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

  additionalDetailsDeleteApiFunc(){
    additionalDetailsDeleteApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  companyGroupDropdownApiFunc(){
    companyGroupDropdownApi().then((value) {
      setStateMounted(() {
        freshLoad = 1;
      });
      var info = jsonDecode(value);
      if (info['success'].toString() == 'true') {
        companyGroupListWithID.clear();
        selectGroupOfCompanyList.clear();
        for (int i = 0; i < info['data'].length; i++) {
          companyGroupListWithID.add(info['data'][i]);
          selectGroupOfCompanyList.add(info['data'][i]['group_title']);
        }
        setStateMounted(() {
          freshLoad = 0;
        });
      } else {
        setStateMounted(() {
          freshLoad = 1;
        });
      }
    });
  }

  stateDropdownApiFunc(){
    stateList.clear();
    stateDropdownApi().then((value) {
      var info = jsonDecode(value);
      for(int i=0; i<info.length; i++){

        stateList.add(info[i]);
      }
    });
  }

  // Using for "Select type of company" dropdown
  groupFetchApiFunc(){
    ServiceWrapper().groupFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        ledgerGroupList.clear();
        ledgerGroupListWithID.clear();

        for(int i=0; i<info['data'].length; i++){
          ledgerGroupList.add(info['data'][i]['group_title']);
        }

        ledgerGroupListWithID.addAll(info['data']);

        setStateMounted(() { });
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  updateCustomer(){
    if(GlobalVariable.update == true){
      clientId = GlobalVariable.customerEditList[0]['client_id'];
      companyGroupId = GlobalVariable.customerEditList[0]['company_group_id'];
      groupOfCompanyValue =  GlobalVariable.customerEditList[0]['company_group_title'];
      ledgerGroup = GlobalVariable.customerEditList[0]['group_title'];
      groupId = GlobalVariable.customerEditList[0]['group_id'];
      companyNameController.text = GlobalVariable.customerEditList[0]['company_name'];
      addressController.text =  GlobalVariable.customerEditList[0]['client_address'];
      stateDropdownValue =  GlobalVariable.customerEditList[0]['client_state'];
      mobileNoController.text =  GlobalVariable.customerEditList[0]['client_contact_number'];
      emailController.text =  GlobalVariable.customerEditList[0]['client_email'];
      websiteController.text =  GlobalVariable.customerEditList[0]['client_website'];
      panNoController.text =  GlobalVariable.customerEditList[0]['client_pan_number'];
      gstNoController.text =  GlobalVariable.customerEditList[0]['client_gst_number'];
      openingBalanceController.text = GlobalVariable.customerEditList[0]['opening_balance'] ?? '_';

      additionalInfo.addAll(GlobalVariable.customerEditList[0]['additional']);
      print("poiuytrfgb: ${additionalInfo}");

    }else{
      print("no update");
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: UiDecoration.appBar("Create Customer"),
      body: Responsive(
        /// Mobile
          mobile: const Text("Mobile"),

          /// Tablet
          tablet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// New Ledger
                Expanded(child: customerForm()),
                const SizedBox(height: 10,),
                /// ledger list
                // Expanded(child: ledgerList()),
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
                Expanded(
                    flex: 10,
                    child: customerForm()),
                const SizedBox(width: 10,),
                /// Additional Information
                Expanded(
                    flex: 11,
                    child: additionalInformation()),
              ],
            ),
          )
      ),
    );
  }

  customerForm(){
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
                textDecoration.heading('Create Customer Form'),
              ),
            ),
            const Divider(),
            // form
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 8 , left: 8, bottom: 8 ,right: 20),
                  child: FocusScope(
                    child: FocusTraversalGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FormWidgets().onlyAlphabetField('Company Name', 'Company Name' , companyNameController , context , focusNode: focusNode1),
                          FormWidgets().formDetails2('Select Group Of Company',SearchDropdownWidget(
                              dropdownList: selectGroupOfCompanyList, hintText: "Select Group Of Company", onChanged: (value) {
                            groupOfCompanyValue = value!;
                            getCompanyGroupId();
                          }, selectedItem: groupOfCompanyValue)),
                          FormWidgets().formDetails2('Select Ledger Group ',SearchDropdownWidget(
                              dropdownList: ledgerGroupList,
                              hintText: "Select Type Of Company",
                              onChanged: (value) {
                                ledgerGroup = value!;

                                // getting group id
                                for (int i = 0; i < ledgerGroupListWithID.length; i++) {
                                  if (ledgerGroup == ledgerGroupListWithID[i]['group_title']) {
                                    groupId = ledgerGroupListWithID[i]['group_id'];
                                  }
                                }
                              },
                              selectedItem: ledgerGroup),),
                          FormWidgets().textField('Address', 'Address' , addressController , context),
                          FormWidgets().formDetails2('State', SearchDropdownWidget(
                              dropdownList: stateList,
                              hintText: "Please Select State ",
                              onChanged: (value) {
                                stateDropdownValue = value!;
                              },
                              selectedItem: stateDropdownValue
                          )),
                          FormWidgets().contactField('Mobile No', 'Mobile No' , mobileNoController , context),
                          FormWidgets().emailField('Email ID', 'Email ID' , emailController , context),
                          FormWidgets().textField('Website', 'Website' , websiteController , context),
                          FormWidgets().alphanumericField('PAN No', 'PAN No' , panNoController , context),
                          FormWidgets().alphanumericField('GST No', 'GST No' , gstNoController , context),
                          FormWidgets().numberField('Opening Balance', 'Enter Opening Balance' , openingBalanceController , context),
                          // const Divider(),
                          // const Text("Additional Details",  style:TextStyle(color: ThemeColors.formTextColor, fontWeight: FontWeight.bold , fontSize: 18),),
                          // FormWidgets().formDetails('Name', 'Name' , nameController),
                          // FormWidgets().formDetails('Designation', 'Designation' , designationController),
                          // FormWidgets().formDetails('Mobile No', 'Mobile No' , mobileNo2Controller),
                          // FormWidgets().formDetails('Email ID', 'Email ID' , email2Controller),

                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Reset Button
                              ElevatedButton(
                                  style: ButtonStyles.smallButton(
                                      ThemeColors.backgroundColor, ThemeColors.darkBlack),
                                  onPressed: () {
                                    _formKey.currentState!.reset();
                                    setState(() {
                                      GlobalVariable.update = false;
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
                                      GlobalVariable.update == true  ? customerUpdateApiFunc() : createCustomerApiFunc();
                                      setState(() {
                                        // additionalInfo.clear();
                                      });
                                    }
                                  },
                                  child: Text(GlobalVariable.update == true ? "Update" : "Create"),),

                              // Navigating to customer list
                              ElevatedButton(
                                  style: ButtonStyles.smallButton(
                                      ThemeColors.primaryColor, ThemeColors.whiteColor),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerList(),));
                                  },
                                  // onPressed: () {
                                  //   if(companyNameController.text.isEmpty){
                                  //     AlertBoxes.flushBarErrorMessage("Enter Company Name", context);
                                  //   } else if(addressController.text.isEmpty){
                                  //     AlertBoxes.flushBarErrorMessage('Enter Address', context);
                                  //   } else if(stateController.text.isEmpty){
                                  //     AlertBoxes.flushBarErrorMessage('Enter State', context);
                                  //   } else if(mobileNoController.text.isEmpty){
                                  //     AlertBoxes.flushBarErrorMessage('Enter Mobile Number', context);
                                  //   } else if(emailController.text.isEmpty){
                                  //     AlertBoxes.flushBarErrorMessage('Enter Email ID', context);
                                  //   } else if(websiteController.text.isEmpty){
                                  //     AlertBoxes.flushBarErrorMessage('Enter Website', context);
                                  //   } else if(panNoController.text.isEmpty){
                                  //     AlertBoxes.flushBarErrorMessage('Enter PAN Number', context);
                                  //   } else if(gstNoController.text.isEmpty){
                                  //     AlertBoxes.flushBarErrorMessage('Enter GST Number', context);
                                  //   } else if(nameController.text.isEmpty){
                                  //     AlertBoxes.flushBarErrorMessage('Enter Name', context);
                                  //   } else if(designationController.text.isEmpty){
                                  //     AlertBoxes.flushBarErrorMessage('Enter Designation', context);
                                  //   } else if(mobileNo2Controller.text.isEmpty){
                                  //     AlertBoxes.flushBarErrorMessage('Enter Mobile Number', context);
                                  //   } else if(email2Controller.text.isEmpty){
                                  //     AlertBoxes.flushBarErrorMessage('Enter Email ID', context);
                                  //   }  else {
                                  //     createCustomerApiFunc();
                                  //   }
                                  // },
                                  child: const Text("Customer List -->"),),


                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  additionalInformation(){
    return  Container(
      decoration: UiDecoration().formDecoration(),
      child: Form(
        key: _formKey2,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textDecoration.heading('Additional Details'),
                  ],
                ),
              ),
            ),
            const Divider(),
            // form
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 8 , left: 8, bottom: 8 ,right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // const Divider(),
                    // const Text("Additional Details",  style:TextStyle(color: ThemeColors.formTextColor, fontWeight: FontWeight.bold , fontSize: 18),),
                    FocusScope(
                      child: FocusTraversalGroup(
                        child: Column(
                          children: [
                            FormWidgets().textField('Name', 'Name' , nameController , context),
                            FormWidgets().textField('Designation', 'Designation' , designationController , context),
                            FormWidgets().contactField('Mobile No', 'Mobile No' , mobileNo2Controller , context),
                            FormWidgets().emailField('Email ID', 'Email ID' , email2Controller , context),
                            // Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  /// Reset Button
                                  // ElevatedButton(
                                  //     style: ButtonStyles.smallButton(
                                  //         ThemeColors.backgroundColor, ThemeColors.darkBlack),
                                  //     onPressed: () {
                                  //       _formKey2.currentState!.reset();
                                  //     }, child: const Text("Reset")),
                                const SizedBox(width: 20,),
                                // Add Button
                                ElevatedButton(
                                    style: ButtonStyles.smallButton(
                                        ThemeColors.primaryColor, ThemeColors.whiteColor),
                                    onPressed: () {
                                      if(_formKey2.currentState!.validate()){
                                        _formKey2.currentState!.save();
                                        // after validation complete
                                        setState(() {
                                          additionalInfo.add({
                                            'add_name' : nameController.text ,
                                            'add_designation': designationController.text,
                                            'add_mobile':mobileNo2Controller.text,
                                            'add_email':email2Controller.text
                                          });
                                        });
                                      }
                                    },
                                    // onPressed: () {
                                    //   if(nameController.text.isEmpty){
                                    //     AlertBoxes.flushBarErrorMessage("Enter Name", context);
                                    //   } else if(designationController.text.isEmpty){
                                    //     AlertBoxes.flushBarErrorMessage('Enter Designation', context);
                                    //   }  else if(mobileNo2Controller.text.isEmpty){
                                    //     AlertBoxes.flushBarErrorMessage('Enter Mobile Number', context);
                                    //   } else if(email2Controller.text.isEmpty){
                                    //     AlertBoxes.flushBarErrorMessage('Enter Email', context);
                                    //   } else {
                                    //     setState(() {
                                    //       additionalInfo.add({
                                    //         'name' : nameController.text ,
                                    //         'designation': designationController.text,
                                    //         'mobile_no':mobileNo2Controller.text,
                                    //         'email':email2Controller.text
                                    //       });
                                    //     });
                                    //
                                    //   }
                                    // },
                                    child: const Icon(Icons.add)),
                              ],
                            ),
                            const Divider(),

                          ],
                        ),
                      ),
                    ),


                    // additional info list
                    additionalInfo.isEmpty ? const SizedBox() :
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: additionalInfo.isEmpty ? 1 : additionalInfo.length,
                         itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(left: 4),
                            margin: const EdgeInsets.only(bottom: 3),
                            decoration: BoxDecoration(
                            color: index==0||index%2==0?Colors.grey.shade200:Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(3)
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3)
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 5 , horizontal: 5),
                                    child: Text(additionalInfo.isEmpty ?"empty" :additionalInfo[index]['add_name']),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5 , horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3)
                                    ),
                                    child: Text(additionalInfo.isEmpty ?"empty" :additionalInfo[index]['add_designation']),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5 , horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3)
                                    ),
                                    child: Text(additionalInfo.isEmpty ?"empty" :additionalInfo[index]['add_mobile']),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5 , horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3)
                                    ),
                                    child: Text(additionalInfo.isEmpty ?"empty" :additionalInfo[index]['add_email']),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                // delete icon
                                IconButton(onPressed: () {
                                   setState(() {
                                    additionalDetailsID = additionalInfo[0]['client_ad_id'];
                                    GlobalVariable.update == true ? additionalDetailsDeleteApiFunc() : null ;
                                    print("bgb: ${additionalInfo[0]['client_ad_id']}");
                                    additionalInfo.removeAt(index);
                                  });
                                }, icon: const Icon(Icons.delete) , color: ThemeColors.darkRedColor,)
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

  }

  // API
  Future  createCustomerApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Company/CompanyClientStore");
    var body = {
      'company_name': companyNameController.text,
      'company_group_id': companyGroupId.toString(),
      'company_type': ledgerGroup == 'Pushpak'?'0':'1', // dropdown list changed to groupList
      'group_id': groupId.toString(),
      'client_address': addressController.text,
      'client_state': stateDropdownValue,
      'client_contact_number': mobileNoController.text,
      'client_email': emailController.text,
      'client_website': websiteController.text,
      'client_pan_number': panNoController.text,
      'client_gst_number': gstNoController.text,
      'additional' : jsonEncode(additionalInfo),
      'created_by': GlobalVariable.entryBy,
      'opening_balance': openingBalanceController.text
    };
    print("b5t: ${openingBalanceController.text}");
    var response = await http.post(url , headers: headers , body: body);
    return response.body.toString();
  }

  Future  customerUpdateApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Company/CompanyClientStore");
    print("876thn: $additionalInfo");
    var body = {
      'company_name': companyNameController.text,
      'company_group_id': companyGroupId.toString(),
      'company_type': ledgerGroup == 'Pushpak'?'0':'1', // dropdown list changed to groupList
      'group_id': groupId.toString(),
      'client_address': addressController.text,
      'client_state': stateDropdownValue,
      'client_contact_number': mobileNoController.text,
      'client_email': emailController.text,
      'client_website': websiteController.text,
      'client_pan_number': panNoController.text,
      'client_gst_number': gstNoController.text,
      'additional' : jsonEncode(additionalInfo),
      'created_by': GlobalVariable.entryBy,
      'opening_balance': openingBalanceController.text,
      'client_id': GlobalVariable.customerEditList[0]['client_id'].toString()
    };

    var response = await http.post(url , headers: headers , body: body);
    return response.body.toString();
  }

  Future companyGroupDropdownApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Company/CompanyGroupFetch');
    var response = await http.get(url,headers: headers);

    return response.body.toString();
  }

  Future additionalDetailsDeleteApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Company/CompanyAddDelete?client_ad_id=$additionalDetailsID");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  Future stateDropdownApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Company/GetStates');
    var response = await http.get(url,headers: headers);

    return response.body.toString();
  }

  getCompanyGroupId() {
    /// TODO: check group "group_title" parameter && "company_group_title" parameter
    for (int i = 0; i < companyGroupListWithID.length; i++) {
      if (groupOfCompanyValue == companyGroupListWithID[i]['group_title']) {
        companyGroupId = companyGroupListWithID[i]['company_group_id'];
      }
    }
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }


}

