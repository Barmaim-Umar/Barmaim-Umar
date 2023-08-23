import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

List<String> userPostList = ["Admin" , "Operator" , "Manager"];
List<String> entriesList = ["10" , "20" , "30" , "40" ];

class _UserState extends State<User> with Utility {

  bool update = false;
  List userTableList = [];
  List groupEditList = [];
  List groupLinkList2 = [];
  int groupID = 0;
  int currentIndex = -1;
  int groupLinkID = 0;
  int freshLoad = 0;
  int? userType;
  String allianceDropdownValue = "";
  ValueNotifier<String> userPostValue = ValueNotifier("");
  String entriesDropdownValue = entriesList.first;
  bool passVisible = false;
  int? userID;

  TextDecorationClass textDecoration = TextDecorationClass();
  final _formKey = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController loginIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController pageNoController = TextEditingController();
  TextEditingController groupEditController = TextEditingController();
  FocusNode focusNode1 = FocusNode();

  int totalRecords = 0;
  bool isChecked = false;

  /// API ==================

  userCreateApiFunc(){
    userCreateApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  userFetchApiFunc(){
    userFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        userTableList.clear();
        userTableList.addAll(info['data']);
        GlobalVariable.totalRecords = info['total_records'] ?? 0;
        GlobalVariable.totalPages = info['total_pages'] ?? 1;
        GlobalVariable.currentPage = int.parse(info['page']) ;
        GlobalVariable.next = info['next'] ;
        GlobalVariable.prev = info['prev'];
        setStateMounted(() { });
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  userEditApiFunc(){
    userEditApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){

        userNameController.text = info['data'][0]['user_name'];
        loginIDController.text = info['data'][0]['login_email'];
        // passwordController.text = info['data'][0]['login_password']; // commented because password is in hash format


        for(int i = 0; i<userPostList.length; i++){
          if(userPostList[i] == userPostList[info['data'][0]['user_type']]){
            userType = i;
            userPostValue.value = userPostList[i]; // Dropdown value
          }
        }

        setState(() {
          update = true;
        });

      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  userUpdateApiFunc(){
    userUpdateApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
        setState(() => update = false);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  userDeleteApiFunc(){
    userDeleteApi().then((value) {
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
    GlobalVariable.currentPage = 1;
    userFetchApiFunc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Create USER"),
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
                const SizedBox(width: 10,),
                /// Group list
                Expanded(flex: 2,child: employeeList()),
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
                Expanded(
                    flex: 3,
                    child: employeeForm()),
                const SizedBox(width: 10,),
                /// Group list
                Expanded(
                    flex: 4,
                    child: employeeList()
                )
              ],
            ),
          )
      ),
    );
  }

  /// DATATABLE ===========================
  Widget buildDataTable() {
    return  userTableList.isEmpty ? const Center(child: CircularProgressIndicator(),) : DataTable(
      columns: [
        DataColumn(label: TextDecorationClass().dataColumnName("User Name")),
        DataColumn(label: TextDecorationClass().dataColumnName("Login ID")),
        DataColumn(label: TextDecorationClass().dataColumnName("Login Password")),
        DataColumn(label: TextDecorationClass().dataColumnName("Post")),
        DataColumn(label: TextDecorationClass().dataColumnName("Action")),
      ],
      rows:  List.generate(userTableList.length, (index) {
        return DataRow(
            color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
            cells: [
              DataCell(TextDecorationClass().dataRowCell(userTableList[index]['user_name'])),
              DataCell(TextDecorationClass().dataRowCell(userTableList[index]['login_email'])),
              DataCell(
                  InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                          passVisible = !passVisible;
                        });
                      },
                      child:  passVisible == true ? Text(userTableList[index]['login_password']) :  const Icon(Icons.visibility))
              ),
              DataCell(TextDecorationClass().dataRowCell(userPostList[userTableList[index]['user_type']])),
              DataCell(Row(
                children: [

                  // edit Icon
                  UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setStateMounted(() {
                          userID = userTableList[index]['user_id'];
                          userEditApiFunc();
                        });
                      }, icon: const Icon(Icons.edit, size: 15, color: Colors.white,),),),

                  // flag Icon
                  UiDecoration().actionButton( ThemeColors.primaryColor,IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setStateMounted(() {
                        });
                      }, icon: const Icon(Icons.flag, size: 15, color: Colors.white,))),

                  // delete Icon
                  UiDecoration().actionButton( ThemeColors.deleteColor,IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                    userID = userTableList[index]['user_id'];
                    showDialog(context: context, builder: (context) {
                      return
                        AlertDialog(
                          title: const Text("Are you sure you want to delete"),
                          actions: [
                            // Cancel Button
                            TextButton(onPressed: () {
                              Navigator.pop(context);
                            }, child: const Text("Cancel")),

                            // Delete Button
                            TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: ThemeColors.darkRedColor,
                                  foregroundColor: Colors.white
                                ),
                                onPressed: () {

                              setState(() {
                                userDeleteApiFunc();
                                userFetchApiFunc();
                              });

                              Navigator.pop(context);
                            }, child: const Text("Delete"))
                          ],
                        );
                    },);
                  }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),
                ],
              )),
            ]);
      }),

    );
  }

  employeeForm(){
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
                textDecoration.heading( update == true ? 'Update User' : 'New User'),
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
                        children: [
                          FormWidgets().onlyAlphabetField('User Name', 'Enter User Name' , userNameController , context, focusNode: focusNode1),

                          FormWidgets().alphanumericField('Login ID', 'Enter Login ID' , loginIDController , context),

                          FormWidgets().passwordField('Login Password', 'Enter Login Password' , passwordController , context , obscureText: true ),

                          FormWidgets().formDetails2('User Post',ValueListenableBuilder(
                            valueListenable: userPostValue,
                            builder: (context, value2, child) =>
                                SearchDropdownWidget(
                                  dropdownList: userPostList,
                                  hintText: "Select User Post",
                                  onChanged: (value) {

                                    userPostValue.value = value!;

                                    for(int i = 0; i<userPostList.length; i++){
                                      if(userPostList[i] == value){
                                        userType = i;
                                      }
                                    }
                                  },
                                  selectedItem: value2 ,
                                  maxHeight: 150,
                                  showSearchBox: false,
                                ),
                          )
                          ),

                          const Divider(),

                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Reset Button
                              ElevatedButton(
                                onPressed: () {
                                  _formKey.currentState!.reset();
                                  userNameController.text = "";
                                  loginIDController.text = "";
                                  passwordController.text = "";
                                  userPostValue.value = "";
                                  setState(() => update = false);
                                },
                                style: ButtonStyles.smallButton(
                                    ThemeColors.backgroundColor, ThemeColors.darkBlack),
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),

                              const SizedBox(width: 20,),

                              // create button / update button
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    // after validation completed
                                    update == true ? userUpdateApiFunc() : userCreateApiFunc();

                                    userFetchApiFunc();

                                    userNameController.text = "";
                                    loginIDController.text = "";
                                    passwordController.text = "";
                                    userPostValue.value = "";

                                  }
                                },
                                style: ButtonStyles.smallButton(
                                    ThemeColors.primaryColor, ThemeColors.whiteColor),
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

  employeeList(){
    return Container(
      decoration: UiDecoration().formDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10 , left: 10),
            alignment: Alignment.centerLeft,
            child:
            textDecoration.heading('User List'),
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
                              entriesDropdownValue = value!;
                              userFetchApiFunc();
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
                      const Text('Search: '), Expanded(child: FormWidgets().textFormField('Search' , searchController ,
                          onFieldSubmitted: (value){
                          userFetchApiFunc();
                          setState(() {
                            employeeList();
                          });
                      },
                          onChanged: (value){
                            setState(() {
                              userFetchApiFunc();
                            });
                          }

                      )),
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
                              child: /* freshLoad == 1 ? const Text("FreshLoad = 1 \nPlease Wait...") : */
                              SizedBox(
                                  width: double.maxFinite,
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      /// datatable
                                      child: buildDataTable(),
                                  ),
                              ),
                            ),
                            const Divider(),

                          ],
                        ))),

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
                        userFetchApiFunc();
                      });

                    }, icon: const Icon(Icons.first_page)),

                    // Prev Button
                    IconButton(
                        onPressed: GlobalVariable.prev == false ? null : () {
                          setState(() {
                            GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                            userFetchApiFunc();
                          });
                        }, icon: const Icon(Icons.chevron_left)),

                    const SizedBox(width: 30,),

                    // Next Button
                    IconButton  (
                        onPressed: GlobalVariable.next == false ? null : () {
                          setState(() {
                            GlobalVariable.currentPage++;
                            userFetchApiFunc();
                          });
                        }, icon: const Icon(Icons.chevron_right)),

                    // Last Page Button
                    IconButton(onPressed: !GlobalVariable.next ? null : () {
                      setState(() {
                        GlobalVariable.currentPage = GlobalVariable.totalPages;
                        userFetchApiFunc();
                      });

                    }, icon: const Icon(Icons.last_page)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// API User Create
  Future userCreateApi() async {
    var url = Uri.parse("${GlobalVariable.baseURL}User/UserStore");
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var body = {
      'user_name': userNameController.text,
      'login_email': loginIDController.text,
      'login_password': passwordController.text,
      'created_by': GlobalVariable.entryBy,
      'user_type': userType.toString()
    };
    var response = await http.post(url , body: body , headers: headers);
    return response.body.toString();
  }

  /// API User Fetch
  Future userFetchApi() async {
    var url = Uri.parse("${GlobalVariable.baseURL}User/?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&keyword=${searchController.text}");
    var response = await http.get(url);
    return response.body.toString();
  }

  /// Api User Edit
  Future userEditApi() async {
    var url = Uri.parse("${GlobalVariable.baseURL}User/UserEdit?user_id=$userID");
    var response = await http.get(url);
    return response.body.toString();
  }

  /// API User Update
  Future userUpdateApi() async {
    var url = Uri.parse("${GlobalVariable.baseURL}User/UserStore");
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var body = {
      'user_name': userNameController.text,
      'login_email': loginIDController.text,
      'login_password': passwordController.text,
      'created_by': GlobalVariable.entryBy,
      'user_type': userType.toString(),
      'user_id': userID.toString()
    };
    var response = await http.post(url , body: body , headers: headers);
    return response.body.toString();
  }

  /// User Delete API
  Future userDeleteApi() async {
    var url = Uri.parse("${GlobalVariable.baseURL}User/UserDelete?user_id=$userID");
    var response = await http.get(url);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }

}
