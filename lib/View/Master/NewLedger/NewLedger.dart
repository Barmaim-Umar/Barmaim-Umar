import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:http/http.dart' as http;

class NewLedger extends StatefulWidget {
  const NewLedger({Key? key}) : super(key: key);

  @override
  State<NewLedger> createState() => _NewLedgerState();
}

List<String> stateList = [];
List<String> openingBalanceList = ["Dr" , "Cr"];
List<String> entriesList = ["10" ,"20" , "30" , "40"];

class _NewLedgerState extends State<NewLedger> {

  int listLength = 4;
  List<FocusNode> focusNodesList = List<FocusNode>.generate(17, (int index) => FocusNode());

  // for group dropdown
  List groupList = [];
  List<String> groupTitleList = [];
  var groupID;

  // using to export data --> pdf , excel , etc
  List data = [];
  List<List<dynamic>> exportData = [];

  int freshLoad = 1;
  List ledgerTableList = [];
  List ledgerEditList = [];
  List ledgerInfoList = [];
  int ledgerID = 0;
  bool isChecked = false; // using for checkbox
  String selectedItem = '';
  bool readOnly = true;
  TextEditingController pageNoController = TextEditingController();

  TextDecorationClass textDecoration = TextDecorationClass();

  String groupDropdownValue = "";
  String stateDropdownValue = '';
  String openingBalanceDropdownValue = openingBalanceList.first;
  String entriesDropdownValue = entriesList.first;

  final _formKey = GlobalKey<FormState>();

  int? groupValue;
  bool update = false;

  // info
  int infoIsChecked = 1;


  // Ledger Form Controllers
  TextEditingController ledgerNameController = TextEditingController(text: "LedgerName");
  TextEditingController aliasNameController = TextEditingController(text: "Alias Name");
  TextEditingController contactNumberController = TextEditingController(text: "9988776655");
  TextEditingController emailController = TextEditingController(text: "email@gmail.com");
  TextEditingController addressController = TextEditingController(text: "Aurangabad");
  TextEditingController countryController = TextEditingController(text: "India");
  TextEditingController gstNumberController = TextEditingController(text: "665878");
  TextEditingController creditDaysController = TextEditingController(text: "123");
  TextEditingController panNumberController = TextEditingController(text: "523413");
  TextEditingController bankNameController = TextEditingController(text: "Bank Of Maharashtra");
  TextEditingController bankAccNumberController = TextEditingController(text: "1523412131");
  TextEditingController bankIFSCController = TextEditingController(text: "4f45322");
  TextEditingController bankBranchController = TextEditingController(text: "Roshan Gate");
  TextEditingController ledgerOpeningBalanceController = TextEditingController(text: "123");
  TextEditingController searchController = TextEditingController();

  // controllers for info
  TextEditingController infoLedgerNameController = TextEditingController();
  TextEditingController infoAliasNameController = TextEditingController();
  TextEditingController infoContactNumberController = TextEditingController();
  TextEditingController infoEmailController = TextEditingController();
  TextEditingController infoAddressController = TextEditingController();
  TextEditingController infoCountryController = TextEditingController();
  TextEditingController infoGSTNumberController = TextEditingController();
  TextEditingController infoCreditDaysController = TextEditingController();
  TextEditingController infoPANNumberController = TextEditingController();
  TextEditingController infoBankNameController = TextEditingController();
  TextEditingController infoBankAccNumberController = TextEditingController();
  TextEditingController infoBankIFSCController = TextEditingController();
  TextEditingController infoBankBranchController = TextEditingController();
  TextEditingController infoLedgerOpeningBalanceController = TextEditingController();
  TextEditingController infoSearchController = TextEditingController();

  @override
  void initState() {
    groupValue = 0;
    getStateApiFunc();
    GlobalVariable.currentPage = 1;
    ledgerFetchApiFunc();
    groupFetchApiFunc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNodesList[0]);
    });

    super.initState();
  }
  // API ==================
  newLedgerAPIFunc(){
    setState(() {
      freshLoad = 1;
    });
    newLedgerAPI().then((value) {
      var info = jsonDecode(value);
      if(info["success"] == true){
        setState(() {
          freshLoad = 0;
        });
        AlertBoxes.flushBarSuccessMessage(info["message"], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info["message"], context);
      }
    });
  }

  ledgerFetchApiFunc(){
    ledgerTableList.clear();
    setState(() {
      freshLoad = 1;
    });
    ledgerFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        setState(() {
          ledgerTableList.addAll(info['data']);
          GlobalVariable.totalRecords = info['total_records'];
          GlobalVariable.totalPages = info['total_pages'];
          GlobalVariable.currentPage = info['page'];
          GlobalVariable.next = info['next'];
          GlobalVariable.prev = info['prev'];
          freshLoad = 0;
        });
      } else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });

    // Export Data
    exportDataApi().then((value){
      var info = jsonDecode(value);
      if(info['success'] == true){
        data.clear();
        exportData.clear();
        data.addAll(info['data']);
        setStateMounted(() { freshLoad = 0;});
      }else{
        setState(() {freshLoad = 1;});
      }
    });
  }

  getStateApiFunc(){
    getStateApi().then((value) {
      var info = jsonDecode(value);
      for(int i=0; i<info.length;i++){
        stateList.add(info[i]);
      }
    });
  }

  ledgerDeleteApiFunc(){
    ledgerDeleteApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['massage'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  ledgerEditApiFunc(){
    ledgerEditList.clear();
    setState(() {
      freshLoad = 1;
    });
    ledgerEditApi().then((value) {
      var info = jsonDecode(value);

      if(info['success'] == true){
        ledgerEditList.addAll(info['data']);
        setStateMounted(() {

          ledgerNameController.text = ledgerEditList[0]['ledger_title'].toString();
          aliasNameController.text = ledgerEditList[0]['ledger_alias_title'].toString();
          groupID = ledgerEditList[0]['group_id'].toString();
          getGroupName();
          stateDropdownValue = ledgerEditList[0]['ledger_state'].toString();
          contactNumberController.text = ledgerEditList[0]['ledger_contact_number'].toString();
          emailController.text = ledgerEditList[0]['ledger_email'].toString();
          addressController.text = ledgerEditList[0]['ledger_address'].toString();
          countryController.text = ledgerEditList[0]['ledger_country'].toString();
          gstNumberController.text = ledgerEditList[0]['ledger_gst_number'].toString();
          creditDaysController.text = ledgerEditList[0]['ledger_credit_days'].toString();
          panNumberController.text = ledgerEditList[0]['ledger_pan_number'].toString();
          bankNameController.text = ledgerEditList[0]['ledger_bank_name'].toString();
          bankAccNumberController.text = ledgerEditList[0]['ledger_bank_account_number'].toString();
          bankIFSCController.text = ledgerEditList[0]['ledger_bank_ifsc'].toString();
          bankBranchController.text = ledgerEditList[0]['ledger_bank_branch'].toString();
          openingBalanceDropdownValue = ledgerEditList[0]['opening_type'].toString();
          ledgerOpeningBalanceController.text = ledgerEditList[0]['opening_balance'].toString();
          infoIsChecked = ledgerEditList[0]['fixed'];
          groupValue = ledgerEditList[0]['ledger_registered'];

          ledgerInfoList.addAll(info['data']);

          freshLoad = 0;
        });
      }else{
        setState(() {
          freshLoad = 1;
        });
        debugPrint("Success FALSE :  LEDGER EDIT");
      }
    });
  }

  getGroupName(){
    for(int i =0; i<groupList.length ; i++){
      if(groupID == groupList[i]['group_id'].toString()){
        setState((){
          groupDropdownValue = groupList[i]['group_title'];
        });
      }
    }
  }

  ledgerUpdateApiFunc(){
    ledgerUpdateApi().then((value) {
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

  // Dropdown api
  groupFetchApiFunc(){
    ServiceWrapper().groupFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        groupList.clear();
        groupTitleList.clear();

        groupList.addAll(info['data']);

        // adding "group_title" in "$groupTitleList" for dropdown
        for(int i = 0; i<info['data'].length; i++){
          groupTitleList.add(info['data'][i]['group_title']);
        }

        setState(() {
          freshLoad = 0;
        });
      }else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("New Ledger"),
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
                Expanded(child: ledgerForm()),

                const SizedBox(height: 10,),

                /// ledger list
                Expanded(child: ledgerList()),
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
                Expanded(child: ledgerForm()),
                const SizedBox(width: 10,),
                /// ledger list
                Expanded(child: ledgerList()),
              ],
            ),
          )
      ),
    );
  }

  ledgerForm(){
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
                textDecoration.heading( update == true ? 'Update Ledger' : 'New Ledger'),
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FormWidgets().onlyAlphabetField('Ledger Name', 'Ledger Name' , ledgerNameController,context , focusNode: focusNodesList[0],nextFocus: focusNodesList[1]),
                          FormWidgets().onlyAlphabetField('Alias Name', 'Alias Name' , aliasNameController,context , focusNode: focusNodesList[1] ,nextFocus: focusNodesList[2]),
                          FormWidgets().formDetails2('Groups', SearchDropdownWidget(
                            // focusNode: focusNodesList[2],
                              dropdownList: groupTitleList,
                              hintText: "Select Groups",
                              onChanged: (value) {
                                groupDropdownValue = value!;
                                // storing groupID
                                for(int i = 0; i<groupList.length; i++){
                                  if(groupList[i]['group_title'] == groupDropdownValue){
                                    groupID = groupList[i]['group_id'];
                                  }
                                }
                              },
                              selectedItem: groupDropdownValue
                          ), ),
                          FormWidgets().contactField('Contact Number', 'Contact Number' , contactNumberController,context /*[FilteringTextInputFormatter.digitsOnly]*/),
                          FormWidgets().emailField('E-Mail Address', 'E-Mail Address' , emailController , context),
                          FormWidgets().textField('Address', 'Address' , addressController , context),
                          FormWidgets().formDetails2('State', SearchDropdownWidget(
                              dropdownList: stateList,
                              hintText: "State List",
                              onChanged: (p0) {
                                stateDropdownValue = p0!;
                              },
                              selectedItem: stateDropdownValue
                          )),
                          FormWidgets().onlyAlphabetField('Country', 'Country' , countryController , context ,    onFieldSubmitted: (value) {
                            // FocusScope.of(context).requestFocus(focusNodesList[3]);
                            // FocusScope.of(context).canRequestFocus;
                          },),
                          FormWidgets().alphanumericField('GST Number', 'Enter Ledger GST Number (Optional)' , gstNumberController , context , optional: true),
                          FormWidgets().numberField('Credit Days', 'Enter Ledger Credit Days (Optional)' , creditDaysController ,context, optional: true),
                          FormWidgets().alphanumericField('PAN Number', 'Enter Ledger PAN Number (Optional)' , panNumberController, context , optional: true),
                          FormWidgets().onlyAlphabetField('Bank Name', 'Enter Bank Name (Optional)' , bankNameController, context , optional: true , focusNode: focusNodesList[3] ,  onFieldSubmitted: (value) {
                            // FocusScope.of(context).requestFocus(focusNodesList[0]);
                            // FocusScope.of(context).canRequestFocus;
                          },),
                          FormWidgets().alphanumericField('Bank Account Number', 'Enter Bank Account Number (Optional)' , bankAccNumberController , optional: true, context),
                          FormWidgets().alphanumericField('Bank IFSC', 'Enter Bank IFSC (Optional)' , bankIFSCController, context , optional: true),
                          FormWidgets().alphanumericField('Bank Branch', 'Enter Bank Branch (Optional)' , bankBranchController, context , optional: true),
                          FormWidgets().formDetails3('Opening Balance', SearchDropdownWidget(dropdownList: openingBalanceList, hintText: "Select Val..",
                            onChanged: (value) {openingBalanceDropdownValue = value!;},selectedItem: openingBalanceDropdownValue ,
                            showSearchBox: false , maxHeight: 100 , optional: true, ) ,'Enter Ledger Opening Balance (Optional)' , ledgerOpeningBalanceController , inputFormatters: [FilteringTextInputFormatter.digitsOnly]),

                          /// CheckBox
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: TextDecorationClass().fieldTitle("Fixed")),
                                  const SizedBox(width: 20,),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Transform.scale(
                                        scale: 1.2,
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child: Checkbox(value: isChecked, onChanged: (value) {
                                            setState(() {
                                              isChecked = value!;
                                            });
                                          },),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15,),
                            ],
                          ),

                          // registered under gst?
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(),
                                  ),
                                  const SizedBox(width: 20,),
                                  Expanded(
                                    flex: 4,
                                    child: TextDecorationClass().fieldTitle2('Registered under GST ?'),
                                  ),
                                ],
                              ),
                              // radioButton
                              Row(
                                children: [
                                  Expanded(child: Container()),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    flex: 4,
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: groupValue,
                                          onChanged: (value) {
                                            setState(() {
                                              groupValue = value!;
                                            });
                                          },
                                        ),
                                        const Text('Yes'),
                                        const SizedBox(width: 10,),
                                        Radio(
                                          value: 0,
                                          groupValue: groupValue,
                                          onChanged: (value) {
                                            setState(() {
                                              groupValue = value!;
                                            });
                                          },
                                        ),
                                        const Text('No'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15,),
                            ],
                          ),

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
                                    ledgerNameController.clear();
                                    aliasNameController.clear();
                                    contactNumberController.clear();
                                    emailController.clear();
                                    addressController.clear();
                                    countryController.clear();
                                    gstNumberController.clear();
                                    creditDaysController.clear();
                                    panNumberController.clear();
                                    bankNameController.clear();
                                    bankAccNumberController.clear();
                                    bankIFSCController.clear();
                                    bankBranchController.clear();
                                    ledgerOpeningBalanceController.clear();
                                    searchController.clear();
                                    setState(() {
                                      update = false;
                                    });
                                    resetDropdown();
                                  }, child: const Text("Reset")),

                              const SizedBox(width: 20,),

                              // Create Button
                              ElevatedButton(
                                  style: ButtonStyles.smallButton(
                                      ThemeColors.primaryColor, ThemeColors.whiteColor),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      // Calling APIs - after validation completed
                                      update == true ? ledgerUpdateApiFunc() : newLedgerAPIFunc();
                                      ledgerFetchApiFunc();
                                    }
                                  },
                                  child: Text( update == true ? "Update" : "Create")),
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

  ledgerList(){
    return Container(
      decoration: UiDecoration().formDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10 , left: 10),
            alignment: Alignment.centerLeft,
            child:
            textDecoration.heading('Ledger List'),
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
                  child: SearchDropdownWidget(dropdownList: entriesList, hintText: "10", onChanged: (value) {
                    entriesDropdownValue = value!;
                    ledgerFetchApiFunc();
                  }, selectedItem: entriesDropdownValue , showSearchBox: false , maxHeight: 200),
                ),
                const Text(' entries'),
                const Spacer(),
                // Search
                const Text('Search: '), Expanded(child: FormWidgets().textFormField('Search' , searchController , onFieldSubmitted: (value){
                  setState(() {
                    ledgerFetchApiFunc();
                  });
                },
                    onChanged: (value){
                      setState(() {
                        ledgerFetchApiFunc();
                      });
                    }
                )
                ),
              ],
            ),
          ),

          // buttons
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Wrap(
              runSpacing: 5,
              children: [
                // BStyles().button('CSV', 'Export to CSV', "assets/csv2.png" , onPressed: () {
                //   // UiDecoration().exportToExcel(groupList);
                // },),
                const SizedBox(width: 10,),
                BStyles().button('Excel', 'Export to Excel', "assets/excel.png", onPressed: () {
                  setState(() {
                    addDataToExport();
                  });
                  UiDecoration().excelFunc(exportData);
                },),
                const SizedBox(width: 10,),
                BStyles().button('PDF', 'Export to PDF', "assets/pdf.png" , onPressed: () {
                  setState(() {
                    addDataToExport();
                  });
                  UiDecoration().pdfFunc(exportData);
                },),
                const SizedBox(width: 10,),
                BStyles().button('Print', 'Print', "assets/print.png" , onPressed: () {
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                        child: freshLoad == 1 ? const Text("FreshLoad = 1 \nPlease Wait...") :
                        SizedBox(
                            width: double.maxFinite,
                            /// DATATABLE
                            child: buildDataTable()),
                      ),
                      const Divider(),

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
                              ledgerFetchApiFunc();
                            });

                          }, icon: const Icon(Icons.first_page)),

                          // Prev Button
                          IconButton(
                              onPressed: GlobalVariable.prev == false ? null : () {
                                setState(() {
                                  GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                                  ledgerFetchApiFunc();
                                });
                              }, icon: const Icon(Icons.chevron_left)),

                          const SizedBox(width: 30,),

                          // Next Button
                          IconButton  (
                              onPressed: GlobalVariable.next == false ? null : () {
                                setState(() {
                                  GlobalVariable.currentPage++;
                                  ledgerFetchApiFunc();
                                });
                              }, icon: const Icon(Icons.chevron_right)),

                          // Last Page Button
                          IconButton(onPressed: !GlobalVariable.next ? null : () {
                            setState(() {
                              GlobalVariable.currentPage = GlobalVariable.totalPages;
                              ledgerFetchApiFunc();
                            });

                          }, icon: const Icon(Icons.last_page)),
                        ],
                      ),

                    ],
                  ),),),
        ],
      ),
    );
  }

  resetDropdown(){
    setStateMounted(() {
      // dropdown
      groupDropdownValue = "";
      stateDropdownValue = "";
    });
  }

  /// DATATABLE ===========================
  Widget buildDataTable() {
    print("nn87kjk: $ledgerTableList");
    return ledgerTableList.isEmpty ? const Center(child: Text("ledgerTableList.isEmpty \nUpdating List..."),) :
    DataTable(
        columns: [
          DataColumn(label: InkWell(child: TextDecorationClass().dataColumnName("Ledger"))),
          DataColumn(label: TextDecorationClass().dataColumnName("Group")),
          DataColumn(label: TextDecorationClass().dataColumnName("Action")),
        ],
        rows:  List.generate(ledgerTableList.length, (index) {
          return DataRow(
              color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
              cells: [
                DataCell(TextDecorationClass().dataRowCell(ledgerTableList[index]['ledger_title'])),
                DataCell(TextDecorationClass().dataRowCell(ledgerTableList[index]['group_title'].toString())),
                DataCell( Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // edit Icon
                    ledgerTableList[index]['fixed'] == 0 ? const Text("") :
                    UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.edit, size: 15, color: Colors.white,), onPressed: () {
                      setState(() {
                        update = true;
                        ledgerID = ledgerTableList[index]['ledger_id'];
                        ledgerEditApiFunc();
                        // editLedgerPopUp();
                      });
                    },)),

                    // delete Icon
                    ledgerTableList[index]['fixed'] == 0 ? const Text("") :
                    UiDecoration().actionButton( ThemeColors.deleteColor,IconButton(padding: const EdgeInsets.all(0),onPressed: () {

                      showDialog(context: context, builder: (context) {
                        return
                          AlertDialog(
                            title: const Text("Are you sure you want to delete"),
                            actions: [

                              UiDecoration().cancelButton(context: context, onPressed:  () {
                                Navigator.pop(context);
                              }),

                              UiDecoration().deleteButton(context: context, onPressed: () {
                                setState(() {
                                  ledgerID = ledgerTableList[index]['ledger_id'];
                                  ledgerDeleteApiFunc();
                                  ledgerFetchApiFunc();
                                });
                                Navigator.pop(context);
                              }),
                            ],
                          );
                      },);

                    }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),

                    // Info Icon
                    UiDecoration().actionButton( ThemeColors.infoColor,IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          ledgerID = ledgerTableList[index]['ledger_id'];
                          ledgerEditApiFunc();
                          showInfoPopUp(index);
                        }, icon: const Icon(Icons.info_outlined, size: 15, color: Colors.white,))),
                  ],
                )),
              ]);
        })
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FormWidgets().infoField('Ledger Name', 'Ledger Name' , ledgerNameController,context ,),
                                  FormWidgets().infoField('Alias Name', 'Alias Name' , aliasNameController,context, ),
                                  FormWidgets().infoField('Groups', 'select Groups' , TextEditingController(text: groupDropdownValue),context, ),
                                  FormWidgets().infoField('Contact Number', 'Contact Number' , contactNumberController,context /*[FilteringTextInputFormatter.digitsOnly]*/, ),
                                  FormWidgets().infoField('E-Mail Address', 'E-Mail Address' , emailController , context, ),
                                  FormWidgets().infoField('Address', 'Address' , addressController , context, ),
                                  FormWidgets().infoField('Address', 'Address' , TextEditingController(text: stateDropdownValue) , context, ),
                                  FormWidgets().infoField('Country', 'INDIA' , countryController , context, ),
                                  FormWidgets().infoField('GST Number', 'Enter Ledger GST Number (Optional)' , gstNumberController , context , optional: true, ),
                                  FormWidgets().infoField('Credit Days', 'Enter Ledger Credit Days (Optional)' , creditDaysController ,context, optional: true, ),
                                  FormWidgets().infoField('PAN Number', 'Enter Ledger PAN Number (Optional)' , panNumberController, context , optional: true, ),
                                  FormWidgets().infoField('Bank Name', 'Enter Bank Name (Optional)' , bankNameController, context , optional: true, ),
                                  FormWidgets().infoField('Bank Account Number', 'Enter Bank Account Number (Optional)' , bankAccNumberController , optional: true, context, ),
                                  FormWidgets().infoField('Bank IFSC', 'Enter Bank IFSC (Optional)' , bankIFSCController, context , optional: true, ),
                                  FormWidgets().infoField('Bank Branch', 'Enter Bank Branch (Optional)' , bankBranchController, context , optional: true, ),
                                  FormWidgets().formDetails3('Opening Balance', TextFormField(
                                    controller: TextEditingController(text: openingBalanceDropdownValue),
                                    readOnly: true,
                                    decoration: UiDecoration().outlineTextFieldDecoration("", ThemeColors.primaryColor,),) ,
                                      'Enter Ledger Opening Balance (Optional)' , ledgerOpeningBalanceController , readOnly: true),

                                  /// CheckBox
                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: TextDecorationClass().fieldTitle("Fixed")),
                                          const SizedBox(width: 20,),
                                          Expanded(
                                            flex: 4,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Transform.scale(
                                                scale: 1.2,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 10.0),
                                                  child: Checkbox(value: infoIsChecked == 1 ? false : true, onChanged: null, ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15,),
                                    ],
                                  ),

                                  // registered under gst?
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(),
                                          ),
                                          const SizedBox(width: 20,),
                                          Expanded(
                                            flex: 4,
                                            child: TextDecorationClass().fieldTitle2('Registered under GST ?'),
                                          ),
                                        ],
                                      ),
                                      // radioButton
                                      Row(
                                        children: [
                                          Expanded(child: Container()),
                                          const SizedBox(width: 10,),
                                          Expanded(
                                            flex: 4,
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 1,
                                                  groupValue: groupValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      groupValue = value!;
                                                    });
                                                  },
                                                ),
                                                const Text('Yes'),
                                                const SizedBox(width: 10,),
                                                Radio(
                                                  value: 0,
                                                  groupValue: groupValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      groupValue = value!;
                                                    });
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 15,),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
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
      ['Ledger','Group'],
    ];
    for (int index = 0; index < data.length; index++) {
      List<String> rowData = [
        data[index]['ledger_title'].toString(),
        data[index]['group_id'].toString(),
      ];
      exportData.add(rowData);
    }
  }

  /// API
  Future newLedgerAPI() async {
    var headers = {'token' : Auth.token};
    var url = Uri.parse("${GlobalVariable.baseURL}Account/LedgersStore");
    var body = {
      // TODO : State Code | ledger_date
      'group_id': groupID.toString(),
      'ledger_title': ledgerNameController.text,
      'ledger_alias_title': aliasNameController.text,
      'ledger_contact_number': contactNumberController.text,
      'ledger_email': emailController.text,
      'ledger_address': addressController.text,
      'ledger_state_code': '431001',
      'ledger_state': stateDropdownValue,
      'ledger_country': countryController.text,
      'ledger_credit_days': creditDaysController.text,
      'ledger_gst_number': gstNumberController.text,
      'ledger_pan_number': panNumberController.text,
      'ledger_registered': groupValue.toString(),
      'ledger_bank_name': bankNameController.text,
      'ledger_bank_account_number': bankAccNumberController.text,
      'ledger_bank_ifsc': bankIFSCController.text,
      'ledger_bank_branch': bankBranchController.text,
      'opening_balance': ledgerOpeningBalanceController.text,
      'opening_type': openingBalanceDropdownValue,
      'ledger_date': '10-20-2022',
      'fixed': isChecked ? '0' : '1', // 0 --> Fixed | 1 --> Editable
    };
    var response = await http.post(headers:headers , url , body: body);
    return response.body.toString();
  }

  Future ledgerFetchApi() async {
    var headers = {'token' : Auth.token};
    var url = Uri.parse("${GlobalVariable.baseURL}Account/LedgersList?limit=${int.parse(entriesDropdownValue)}&page=${GlobalVariable.currentPage}&keyword=${searchController.text}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future getStateApi() async {
    var headers = {'token' : Auth.token};
    var url = Uri.parse("${GlobalVariable.baseURL}Company/GetStates");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future exportDataApi() async {
    var headers = {'token' : Auth.token};
    var url = Uri.parse("${GlobalVariable.baseURL}Account/LedgersList?keyword=${searchController.text}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future ledgerDeleteApi() async {
    var headers = {'token' : Auth.token};
    var url = Uri.parse("${GlobalVariable.baseURL}Account/LedgersDelete?ledger_id=$ledgerID");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future ledgerEditApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/LedgerEdit?ledger_id=$ledgerID");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future ledgerUpdateApi() async {
    var headers = {'token' : Auth.token};
    var url = Uri.parse("${GlobalVariable.baseURL}Account/LedgersStore");
    var body = {
      // TODO : State Code | ledger_date
      'ledger_id' : ledgerID.toString(),
      'group_id': groupID.toString(),
      'ledger_title': ledgerNameController.text,
      'ledger_alias_title': aliasNameController.text,
      'ledger_contact_number': contactNumberController.text,
      'ledger_email': emailController.text,
      'ledger_address': addressController.text,
      'ledger_state_code': '431001',
      'ledger_state': stateDropdownValue,
      'ledger_country': countryController.text,
      'ledger_credit_days': creditDaysController.text,
      'ledger_gst_number': gstNumberController.text,
      'ledger_pan_number': panNumberController.text,
      'ledger_registered': groupValue.toString(),
      'ledger_bank_name': bankNameController.text,
      'ledger_bank_account_number': bankAccNumberController.text,
      'ledger_bank_ifsc': bankIFSCController.text,
      'ledger_bank_branch': bankBranchController.text,
      'opening_balance': ledgerOpeningBalanceController.text,
      'opening_type': openingBalanceDropdownValue,
      'ledger_date': '10-20-502',
      'fixed': isChecked ? '0' : '1', // 0 --> Fixed | 1 --> Editable
    };
    var response = await http.post(headers:headers , url , body: body);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }

}
