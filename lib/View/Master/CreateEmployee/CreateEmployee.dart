import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class CreateEmployee extends StatefulWidget {
  const CreateEmployee({Key? key}) : super(key: key);

  @override
  State<CreateEmployee> createState() => _CreateEmployeeState();
}

List<String> userPostList = ["Admin", "Operator", "Manager"];
List<String> entriesList = ["10", "20", "30", "40"];

class _CreateEmployeeState extends State<CreateEmployee> with Utility {
  List employeeEditList = [];
  bool update = false;
  List<String> maritalStatusList = ['Married', 'Unmarried'];
  String maritalStatusValue = "";
  List employeeTableList = [];
  List groupEditList = [];
  List groupLinkList2 = [];
  int groupID = 0;
  int currentIndex = -1;
  int groupLinkID = 0;
  int freshLoad = 0;
  var userType;
  var employeeId;
  String allianceDropdownValue = "";
  ValueNotifier<String> userPostValue = ValueNotifier("");
  String entriesDropdownValue = entriesList.first;
  bool passVisible = false;
  int? groupValue;
  TextDecorationClass textDecoration = TextDecorationClass();
  final _formKey = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController loginIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController pageNoController = TextEditingController();
  TextEditingController groupEditController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController adhaarController = TextEditingController();
  TextEditingController panCardController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController bankAccountNoController = TextEditingController();
  TextEditingController bankIFSCController = TextEditingController();
  TextEditingController nomineeNameController = TextEditingController();
  TextEditingController maritalStatusController = TextEditingController();
  TextEditingController basicSalaryController = TextEditingController();
  TextEditingController pfController = TextEditingController();
  TextEditingController esicController = TextEditingController();
  TextEditingController ptController = TextEditingController();
  TextEditingController joiningDateController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController dateControllerApi = TextEditingController();
  FocusNode focusNode1 = FocusNode();

  int totalRecords = 0;
  bool isChecked = false;


  /// API ==================

  userCreateApiFunc() {
    userCreateApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  employeeCreateApiFunc() {
    createEmployee().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }
  employeeUpdateApiFunc() {
    updateEmployee().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  employeeFetchApiFunc() {
    setState(() {
      freshLoad =1;
    });
    employeeFetchApi().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        employeeTableList.clear();
        employeeTableList.addAll(info['data']);
        GlobalVariable.totalRecords = info['total_records'] ?? 0;
        GlobalVariable.totalPages = info['total_pages'] ?? 1;
        GlobalVariable.currentPage = info['page'];
        GlobalVariable.next = info['next'];
        GlobalVariable.prev = info['prev'];
        setStateMounted(() {
          freshLoad =0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setState(() {
          freshLoad = 0;
        });
      }
    });
  }

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    groupValue = 1;
    employeeFetchApiFunc();
    employeeInfoFun();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });
    super.initState();
  }

  Future employeeInfo() async {
    var headers = {'token': Auth.token};
    // Fetching weapons data from API
    var url = Uri.parse(
        '${GlobalVariable.baseURL}Employee/EmployeeList?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  employeeInfoFun() {
    setState(() {
      freshLoad = 1;
    });
    employeeInfo().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.totalPages = info['total_pages'];
        GlobalVariable.currentPage = info['page'];
        GlobalVariable.next = info['next'];
        GlobalVariable.prev = info['prev'];
        employeeTableList.clear();
        employeeTableList.addAll(info['data']);
        setState(() {
          freshLoad = 0;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setState(() {
          freshLoad = 0;
        });
      }
    });
  }

  Future employeeDelete() async {
    var headers = {
      'token':
      Auth.token
    };
    var url = Uri.parse(
        '${GlobalVariable.baseURL}Employee/EmployeeDelete?employee_id=$employeeId');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  employeeDeleteFunc() {
    employeeDelete().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  editEmployeeFunc(){
    editEmployee().then((value) {
      var info = jsonDecode(value);
      if (info['success']== true){
        employeeEditList.clear();
        employeeEditList.addAll(info['data']);
        userNameController.text = employeeEditList[0]['employee_name'];
        designationController.text = employeeEditList[0]['employee_designation'];
        departmentController.text = employeeEditList[0]['employee_department'];
        contactNoController.text = employeeEditList[0]['employee_contact'].toString();
        addressController.text = employeeEditList[0]['employee_address'];
        cityController.text = employeeEditList[0]['employee_town'];
        panCardController.text = employeeEditList[0]['employee_pan'];
        bankController.text = employeeEditList[0]['employee_bank'];
        bankAccountNoController.text = employeeEditList[0]['employee_bank_account_number'];
        bankIFSCController.text = employeeEditList[0]['employee_bank_ifsc'];
        nomineeNameController.text = employeeEditList[0]['employee_nominee'];
        maritalStatusValue = employeeEditList[0]['employee_marital_status'];
        basicSalaryController.text = employeeEditList[0]['basic_salary'].toString();
        pfController.text = employeeEditList[0]['pf'].toString();
        esicController.text = employeeEditList[0]['esic'].toString();
        ptController.text = employeeEditList[0]['pt'].toString();
        dateControllerApi.text = employeeEditList[0]['joining_date'];
        dayController.text = DateTime.parse(employeeEditList[0]['joining_date']).day.toString();
        monthController.text = DateTime.parse(employeeEditList[0]['joining_date']).month.toString();
        yearController.text = DateTime.parse(employeeEditList[0]['joining_date']).year.toString();
        setStateMounted(() {
          groupValue = employeeEditList[0]['employee_status'];
        });

      }
      else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Create Employee"),
      body: Responsive(

        /// Mobile
          mobile: Container(),

          /// Tablet
          tablet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// New Group
                Expanded(child: employeeForm()),
                const SizedBox(
                  width: 10,
                ),

                /// Group list
                Expanded(flex: 2, child: employeeList()),
              ],
            ),
          ),

          /// Desktop
          desktop: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// New Group
                Expanded(flex: 2, child: employeeForm()),
                const SizedBox(
                  width: 10,
                ),

                /// Group list
                Expanded(flex: 5, child: employeeList())
              ],
            ),
          )),
    );
  }

  /// DATATABLE ===========================

  Widget buildDataTable() {
    return freshLoad == 1
        ? const Center(
      child: CircularProgressIndicator(),
    )
        :employeeTableList.isEmpty?Text('Data Not Available'): DataTable(
      columns: [
        DataColumn(label: TextDecorationClass().dataColumnName("Name")),
        DataColumn(label: TextDecorationClass().dataColumnName("Contact")),
        DataColumn(label: TextDecorationClass().dataColumnName("Address")),
        DataColumn(label: TextDecorationClass().dataColumnName("Type")),
        DataColumn(label: TextDecorationClass().dataColumnName("UID")),
        DataColumn(label: TextDecorationClass().dataColumnName("Method")),
        DataColumn(label: TextDecorationClass().dataColumnName("Action")),
      ],
      rows: List.generate(employeeTableList.length, (index) {
        return DataRow.byIndex(
          index: index,
          selected: true,
          // Automatically adjusts the row height based on content
          color: MaterialStatePropertyAll(
            index == 0 || index % 2 == 0
                ? ThemeColors.tableRowColor
                : Colors.white,
          ),
          cells: [
            DataCell(TextDecorationClass().dataRowCell(
                employeeTableList[index]['employee_name'].toString())),
            DataCell(TextDecorationClass().dataRowCell(
                employeeTableList[index]['employee_contact'].toString())),
            DataCell(TextDecorationClass().dataRowCell(
                employeeTableList[index]['employee_address'].toString())),
            DataCell(TextDecorationClass().dataRowCell(
                employeeTableList[index]['employee_address'].toString())),
            DataCell(TextDecorationClass().dataRowCell(
                employeeTableList[index]['employee_uid'].toString())),
            DataCell(TextDecorationClass().dataRowCell(
                employeeTableList[index]['employee_address'].toString())),
            DataCell(
              Row(
                children: [
                  // edit Icon
                  UiDecoration().actionButton(
                    ThemeColors.editColor,
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setStateMounted(() {
                          update = true;
                          employeeId = employeeTableList[index]['employee_id'];
                          print(employeeId);
                          editEmployeeFunc();
                        });
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // delete Icon
                  UiDecoration().actionButton(
                    ThemeColors.deleteColor,
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  "Are you sure you want to delete"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      // print("34ef: $employeeTableList");
                                      // groupID = employeeTableList[index]['group_id'];
                                      employeeId =
                                      employeeTableList[index]
                                      ['employee_id'];
                                      employeeDeleteFunc();
                                      employeeFetchApiFunc();
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Delete"),
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // Widget buildDataTable() {
  //   return  /*userTableList.isEmpty ? const Center(child: CircularProgressIndicator(),) :*/ DataTable(
  //     // dataRowHeight: ,
  //     columns: [
  //       DataColumn(label: TextDecoration().dataColumnName("Name")),
  //       DataColumn(label: TextDecoration().dataColumnName("Contact")),
  //       DataColumn(label: TextDecoration().dataColumnName("Address")),
  //       DataColumn(label: TextDecoration().dataColumnName("Type")),
  //       DataColumn(label: TextDecoration().dataColumnName("UID")),
  //       DataColumn(label: TextDecoration().dataColumnName("Method")),
  //       DataColumn(label: TextDecoration().dataColumnName("Action")),
  //     ],
  //     rows:  List.generate(employeeTableList.length, (index) {
  //       return DataRow(
  //           color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
  //           cells: [
  //             DataCell(TextDecoration().dataRowCell(employeeTableList[index]['employee_name'].toString())),
  //             DataCell(TextDecoration().dataRowCell(employeeTableList[index]['employee_contact'].toString())),
  //             DataCell(TextDecoration().dataRowCell(employeeTableList[index]['employee_address'].toString())),
  //             DataCell(TextDecoration().dataRowCell(employeeTableList[index]['employee_address'].toString())),
  //             DataCell(TextDecoration().dataRowCell(employeeTableList[index]['employee_uid'].toString())),
  //             DataCell(TextDecoration().dataRowCell(employeeTableList[index]['employee_address'].toString())),
  //
  //             DataCell(Row(
  //               children: [
  //
  //                 // edit Icon
  //                 UiDecoration().actionButton( ThemeColors.editColor,IconButton(
  //                     padding: const EdgeInsets.all(0),
  //                     onPressed: () {
  //                       setStateMounted(() {
  //                         update = true;
  //                         groupID = employeeTableList[index]['group_id'];
  //                         groupEditApiFunc();
  //                       });
  //                     }, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
  //
  //                 // flag Icon
  //                 UiDecoration().actionButton( ThemeColors.primaryColor,IconButton(
  //                     padding: const EdgeInsets.all(0),
  //                     onPressed: () {
  //                       setStateMounted(() {
  //                         update = true;
  //                         groupID = employeeTableList[index]['group_id'];
  //                         groupEditApiFunc();
  //                       });
  //                     }, icon: const Icon(Icons.flag, size: 15, color: Colors.white,))),
  //
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
  //                               groupID = employeeTableList[index]['group_id'];
  //                               groupDeleteApiFunc();
  //                               groupFetchApiFunc();
  //                             });
  //                             Navigator.pop(context);
  //                           }, child: const Text("Delete"))
  //                         ],
  //                       );
  //                   },);
  //                 }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),
  //               ],
  //             )),
  //           ]);
  //     }),
  //
  //   );
  // }

  employeeForm() {
    return Container(
      decoration: UiDecoration().formDecoration(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: textDecoration.heading(
                    update == true ? 'Update Employee' : 'New Employee'),
              ),
            ),
            const Divider(),
            // form
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 8, left: 8, bottom: 8, right: 20),
                  child: FocusScope(
                    child: FocusTraversalGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FormWidgets().onlyAlphabetField(
                              'Name', 'Enter Name', userNameController, context,
                              focusNode: focusNode1),

                          FormWidgets().onlyAlphabetField(
                              'Designation',
                              'Enter Designation',
                              designationController,
                              context),

                          FormWidgets().onlyAlphabetField(
                              'Department',
                              'Enter Department',
                              departmentController,
                              context),

                          FormWidgets().contactField(
                              'Contact Number',
                              'Enter Contact Number',
                              contactNoController,
                              context),

                          FormWidgets().alphanumericField('Address',
                              'Enter Address', addressController, context),

                          FormWidgets().alphanumericField('Town/City/Village',
                              'Enter Town', cityController, context),

                          FormWidgets().alphanumericField('PAN Card',
                              'Enter PAN Card', panCardController, context),

                          FormWidgets().onlyAlphabetField(
                              'Bank', 'Enter Bank', bankController, context),

                          FormWidgets().numberField(
                              'Bank Account Number',
                              'Enter Bank Account Number',
                              bankAccountNoController,
                              context),

                          FormWidgets().alphanumericField('Bank IFSC',
                              'Enter Bank IFSC', bankIFSCController, context),

                          FormWidgets().onlyAlphabetField(
                              'Nominee Name',
                              'Enter Nominee Name',
                              nomineeNameController,
                              context),

                          FormWidgets().formDetails2(
                            "Marital Status",
                            SearchDropdownWidget(
                              dropdownList: maritalStatusList,
                              hintText: "Marital Status",
                              onChanged: (value) {
                                maritalStatusValue = value!;
                              },
                              selectedItem: maritalStatusValue,
                              showSearchBox: false,
                              maxHeight: 100,
                            ),
                          ),

                          FormWidgets().numberField(
                              'Basic Salary',
                              'Enter Basic Salary',
                              basicSalaryController,
                              context),

                          FormWidgets().numberField(
                              'PF', 'Enter PF', pfController, context),

                          FormWidgets().numberField(
                              'ESIC', 'Enter ESIC', esicController, context),

                          FormWidgets().numberField(
                              'PT', 'Enter PT', ptController, context),

                          FormWidgets().formDetails2(
                              'Joining Date',
                              DateFieldWidget(
                                  dayController: dayController,
                                  monthController: monthController,
                                  yearController: yearController,
                                  dateControllerApi: dateControllerApi)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Active
                              Radio(
                                value: 1,
                                groupValue: groupValue,
                                onChanged: (value) {
                                  setState(() {
                                    groupValue = value!;
                                  });
                                },
                              ),
                              const Text("Active"),

                              const SizedBox(
                                width: 20,
                              ),

                              // DeActive
                              Radio(
                                value: 0,
                                groupValue: groupValue,
                                onChanged: (value) {
                                  setState(() {
                                    groupValue = value!;
                                  });
                                },
                              ),
                              const Text("DeActive")
                            ],
                          ),

                          // FormWidgets().textField('Login ID', 'Enter Login ID' , loginIDController , context),

                          // FormWidgets().passwordField('Login Password', 'Enter Login Password' , passwordController , context , obscureText: true ),

                          const Divider(),

                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Reset Button
                              ElevatedButton(
                                onPressed: () {
                                  _formKey.currentState!.reset();
                                  nomineeNameController.clear();
                                  userNameController.clear();
                                  designationController.clear();
                                  departmentController.clear();
                                  contactNoController.clear();
                                  addressController.clear();
                                  cityController.clear();
                                  panCardController.clear();
                                  bankController.clear();
                                  bankAccountNoController.clear();
                                  bankIFSCController.clear();

                                  basicSalaryController.clear();
                                  pfController.clear();
                                  esicController.clear();
                                  dayController.clear();
                                  monthController.clear();
                                  yearController.clear();
                                  setStateMounted(() { });
                                  maritalStatusValue = '';
                                },
                                style: ButtonStyles.smallButton(
                                    ThemeColors.backgroundColor,
                                    ThemeColors.darkBlack),
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),

                              const SizedBox(
                                width: 20,
                              ),

                              // create button
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    // after validation completed
                                    // update == true ? groupUpdateApiFunc() : userCreateApiFunc();
                                    // employeeCreateApiFunc();
                                    update == true ? employeeUpdateApiFunc() : employeeCreateApiFunc();
                                    // employeeCreateApiFunc();
                                    // employeeUpdateApiFunc();
                                    employeeInfoFun();

                                    userNameController.text = "";
                                    loginIDController.text = "";
                                    passwordController.text = "";
                                    userPostValue.value = "";
                                  }
                                },
                                style: ButtonStyles.smallButton(
                                    ThemeColors.primaryColor,
                                    ThemeColors.whiteColor),
                                child: Text(
                                  update == true ? 'Update' : 'Create',
                                ),
                              ),
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

  employeeList() {
    return Container(
      decoration: UiDecoration().formDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, left: 10),
            alignment: Alignment.centerLeft,
            child: textDecoration.heading('Employee List'),
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
                        child: SearchDropdownWidget(
                          dropdownList: entriesList,
                          hintText: entriesList.first,
                          onChanged: (value) {
                            setState(() {
                              entriesDropdownValue = value!;
                              employeeInfoFun();
                            });
                          },
                          selectedItem: entriesDropdownValue,
                          showSearchBox: false,
                          maxHeight: 200.0,
                        ),
                      ),

                      const Text(' entries'),
                      const Spacer(),
                      // Search
                      const Text('Search: '),
                      Expanded(
                          child: FormWidgets().textFormField(
                              'Search',
                              searchController,
                              onFieldSubmitted: (value) {
                                setState(() {
                                  employeeFetchApiFunc();
                                });
                              }, onChanged: (value) {
                            setState(() {
                              employeeFetchApiFunc();
                            });
                          })),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                /// DataTable
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: double.maxFinite, child: buildDataTable()),
                            const Divider(),
                          ],
                        ))),

                // Pagination
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
                            employeeInfoFun();
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
                            employeeInfoFun();
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
                            employeeInfoFun();
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
                            employeeInfoFun();
                          });
                        },
                        icon: const Icon(Icons.last_page)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// API EmployeeCreate
  Future userCreateApi() async {
    var url = Uri.parse("${GlobalVariable.baseURL}User/UserStore");
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var body = {
      'user_name': userNameController.text,
      'login_email': loginIDController.text,

      /// TODO: no field for email  || has Login ID field
      'login_password': passwordController.text,
      'created_by': GlobalVariable.entryBy,
      'user_type': '1'
    };
    var response = await http.post(url, body: body, headers: headers);
    return response.body.toString();
  }

  Future createEmployee() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Employee/EmployeeStore');
    var body = {
      'employee_name': userNameController.text,
      'employee_contact': contactNoController.text,
      'employee_address': addressController.text,
      'employee_town': cityController.text,
      'employee_designation': designationController.text,
      'employee_bank_account_number': bankAccountNoController.text,
      'employee_department': departmentController.text,
      'employee_pan': panCardController.text,
      'employee_bank': bankController.text,
      'employee_bank_ifsc': bankIFSCController.text,
      'employee_nominee': nomineeNameController.text,
      'employee_marital_status': maritalStatusValue,
      'basic_salary': basicSalaryController.text,
      'pf': pfController.text,
      'esic': esicController.text,
      'pt': ptController.text,
      'joining_date': dateControllerApi.text,
      'employee_status': groupValue.toString(),
    };
    var response = await http.post(url, headers: headers, body: body);
    return response.body.toString();
  }

  Future updateEmployee() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Employee/EmployeeStore?employee_id=$employeeId');
    var body = {
      'employee_name': userNameController.text,
      'employee_contact': contactNoController.text,
      'employee_address': addressController.text,
      'employee_town': cityController.text,
      'employee_designation': designationController.text,
      'employee_bank_account_number': bankAccountNoController.text,
      'employee_department': departmentController.text,
      'employee_pan': panCardController.text,
      'employee_bank': bankController.text,
      'employee_bank_ifsc': bankIFSCController.text,
      'employee_nominee': nomineeNameController.text,
      'employee_marital_status': maritalStatusValue,
      'basic_salary': basicSalaryController.text,
      'pf': pfController.text,
      'esic': esicController.text,
      'pt': ptController.text,
      'joining_date': dateControllerApi.text,
      'employee_status': groupValue.toString(),
      'employee_id': employeeId.toString(),
    };
    var response = await http.post(url, headers: headers, body: body);
    return response.body.toString();
  }

  /// edit Api
  Future editEmployee() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Employee/EmployeeEdit?employee_id=$employeeId');
    var response = await http.get( url, headers: headers);
    return response.body.toString();
  }

  /// AIP Employee Fetch
  Future employeeFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse(
        "${GlobalVariable.baseURL}Employee/EmployeeList?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&keyword=${searchController.text}");
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }


  /// API DataTableFetch
  Future groupFetchApi() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'token': Auth.token,
    };
    var url = Uri.parse(
        "${GlobalVariable.baseURL}Account/GroupList?limit=${int.parse(entriesDropdownValue)}&page=${GlobalVariable.currentPage}&keyword=${searchController.text}");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  /// API Group Delete
  Future groupDeleteApi() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'token': Auth.token,
    };
    var url = Uri.parse(
        "${GlobalVariable.baseURL}Account/GroupDelete?group_id=$groupID");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  /// API Group Edit
  Future groupEditApi() async {
    var headers = {
      'token': Auth.token,
    };
    var url = Uri.parse(
        "${GlobalVariable.baseURL}Account/GroupEdit?group_id=$groupID");
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  /// API Group Update
  Future groupUpdateApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/GroupStore");
    var body = {
      'group_title': userNameController.text,
      'group_alliance': allianceDropdownValue,
      'link_group_id': userPostValue,
      'fixed': '1', // 1 --> Editable
      'group_id': groupID.toString()
    };
    var response = await http.post(url, headers: headers, body: body);
    return response.body.toString();
  }

  Future groupDropdownApi() async {
    var headers = {'token': Auth.token};
    var url = Uri.parse('${GlobalVariable.baseURL}Company/CompanyGroupFetch');
    var response = await http.get(url, headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
