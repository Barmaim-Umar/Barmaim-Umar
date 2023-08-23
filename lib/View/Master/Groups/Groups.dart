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
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

List<String> allianceList = ["alliance" , "alliance" , "alliance" , "alliance"];
List<String> groupLinkList = [];
List<String> entriesList = ["10" , "20" , "30" , "40" ];

class _GroupsState extends State<Groups> with Utility {

  bool update = false;
  List groupTableList = [];
  List groupEditList = [];
  List groupLinkList2 = [];
  int groupID = 0;
  int groupLinkID = 0;
  int allianceID = -1;
  int freshLoad = 1;
  String selectedItem = '';

  String allianceDropdownValue = "";
  String groupLinkDropdownValue = "";
  String entriesDropdownValue = entriesList.first;

  TextDecorationClass textDecoration = TextDecorationClass();
  final _formKey = GlobalKey<FormState>();

  TextEditingController groupNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController pageNoController = TextEditingController();
  TextEditingController groupEditController = TextEditingController();

  FocusNode focusNode1 = FocusNode();

  int totalRecords = 0;
  bool isChecked = false;

  /// API ==================

  groupCreateApiFunc(){
    groupCreateApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  groupFetchApiFunc(){
    setStateMounted(() {
      freshLoad = 1;
    });
    groupFetchApi().then((value) {
      var info = jsonDecode(value);
      print("this is group fetch info: $info");
      if(info['success'] == true){
        groupTableList.clear();
        setStateMounted(() {
          groupTableList.addAll(info['data']);
          GlobalVariable.totalRecords = info['total_records'];
          GlobalVariable.totalPages = info['total_pages'];
          GlobalVariable.currentPage = info['page'];
          GlobalVariable.next = info['next'];
          GlobalVariable.prev = info['prev'];
          freshLoad = 0;
        });
      } else{
        setState(() {
          freshLoad = 0;
        });
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  groupDeleteApiFunc(){
    groupDeleteApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info["message"], context);
      } else{
        AlertBoxes.flushBarErrorMessage(info["message"], context);
      }
    });
  }

  groupEditApiFunc(){
    groupEditList.clear();
    setStateMounted(() {
      freshLoad = 1;
    });
    groupEditApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        groupEditList.addAll(info['data']);
          groupNameController.text = groupEditList[0]['group_title'];
          allianceDropdownValue = groupEditList[0]['group_alliance'];
          for(int i=0; i<groupLinkList.length; i++){
            if(info['data'][0]['link_group_id'].toString() == groupLinkList2[i]['group_id'].toString()){
             groupLinkDropdownValue = groupLinkList2[i]['group_title'];
            }
          }
        setStateMounted(() {
          freshLoad = 0;
        });
      }else{
        setStateMounted(() {
          freshLoad = 1;
        });
        debugPrint("Success FALSE :  GROUP EDIT");
      }
    });
  }

  groupUpdateApiFunc(){
    groupUpdateApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
        groupNameController.clear();
        allianceDropdownValue = "";
        groupLinkDropdownValue = "";
        setStateMounted(() {
          update = false;
        });
      }else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  groupDropdownApiFunc(){
    groupDropdownApi().then((value) {
      var info = jsonDecode(value);
      if(info['success']==true){
        groupLinkList.clear();
        groupLinkList2.clear();
        for(int i = 0; i<info['data'].length; i++){
          groupLinkList.add(info['data'][i]['group_title']);
        }
        groupLinkList2.addAll(info['data']);

        print("hgg77: ${groupLinkList.length}");
        print("hgg77: ${info['data'].length}");
        print("hgg77: ${groupLinkList2.length}");
      }
    });
  }

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    groupFetchApiFunc();
    groupDropdownApiFunc();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Groups"),
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
                Expanded(child: groupForm()),
                const SizedBox(width: 10,),
                /// Group list
                Expanded(flex: 2,child: groupList()),
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
                Expanded(child: groupForm()),
                const SizedBox(width: 10,),
                /// Group list
                // Expanded(child: groupList()),
                Expanded(
                    child: groupList()
                )
              ],
            ),
          )
      ),
    );
  }

  /// DATATABLE ===========================
  Widget buildDataTable() {
    return groupTableList.isEmpty ? const Center(child: Text("groupTableList.isEmpty \nUpdating List..."),) : DataTable(
      columns: [
        DataColumn(label: TextDecorationClass().dataColumnName("Group")),
        DataColumn(label: TextDecorationClass().dataColumnName("Linked Group")),
        DataColumn(label: TextDecorationClass().dataColumnName("Alliance")),
        DataColumn(label: TextDecorationClass().dataColumnName("Action")),
      ],
      rows:  List.generate(groupTableList.length, (index) {
        return DataRow(
            color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
            cells: [
              DataCell(TextDecorationClass().dataRowCell(groupTableList[index]['group_title'])),
              DataCell(TextDecorationClass().dataRowCell(groupTableList[index]['Link_group'].toString())),
              DataCell(TextDecorationClass().dataRowCell(groupTableList[index]['group_alliance'])),
              DataCell( groupTableList[index]['fixed'] == 0 ? const Text("Fixed") : Row(
                children: [

                  // edit Icon
                  UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setStateMounted(() {
                          update = true;
                          groupID = groupTableList[index]['group_id'];
                          groupEditApiFunc();
                        });
                      }, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),

                  // delete Icon
                  UiDecoration().actionButton( ThemeColors.deleteColor,IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return
                        AlertDialog(
                          title: const Text("Are you sure you want to delete"),
                          actions: [

                            UiDecoration().cancelButton(context: context, onPressed:  () {
                              Navigator.pop(context);
                            }),

                            UiDecoration().deleteButton(context: context, onPressed:  () {
                              setState(() {
                                groupID = groupTableList[index]['group_id'];
                                groupDeleteApiFunc();
                                groupFetchApiFunc();
                              });
                              Navigator.pop(context);
                            }),

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

  groupForm(){
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
                textDecoration.heading( update == true ? 'Update Group' : 'New Group'),
              ),
            ),
            const Divider(),
            // form
            Expanded(
              child: SingleChildScrollView(
                child: FocusScope(
                  child: FocusTraversalGroup(
                    child: Container(
                      padding: const EdgeInsets.only(top: 8 , left: 8, bottom: 8 ,right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FormWidgets().onlyAlphabetField('Group Name', 'Group Name' , groupNameController , context , focusNode: focusNode1),

                          FormWidgets().formDetails2('Alliance', SearchDropdownWidget(
                            showSearchBox: false,
                              maxHeight: 200,
                              dropdownList: GlobalVariable.allianceList, hintText: "Select Alliance",
                              onChanged: (value) {
                                allianceDropdownValue = value!;
                                // allianceID
                                for(int i=0; i<GlobalVariable.allianceList.length; i++){
                                  if(allianceDropdownValue == GlobalVariable.allianceList[i]){
                                    allianceID = i;
                                  }
                                }
                              }, selectedItem: allianceDropdownValue)),

                          FormWidgets().formDetails2('Group Link',SearchDropdownWidget(
                              dropdownList: groupLinkList,
                              hintText: "Select Group Link",
                              onChanged: (value) {
                                groupLinkDropdownValue = value!;

                                for (int i = 0; i < groupLinkList2.length; i++) {
                                  if (groupLinkDropdownValue == groupLinkList2[i]['group_title']) {
                                    groupLinkID = groupLinkList2[i]['group_id'];
                                  }
                                }

                              },
                              selectedItem: groupLinkDropdownValue,
                            optional: true,
                          ),optional: true),

                          /// CheckBox
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: TextDecorationClass().fieldTitle("Fixed")),
                                  const SizedBox(
                                    width: 20,
                                  ),
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
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),

                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Reset Button
                              ElevatedButton(
                                onPressed: () {
                                  _formKey.currentState!.reset();
                                  groupNameController.text = '';
                                  groupLinkDropdownValue = '';
                                  allianceDropdownValue = '';
                                  update = false;
                                  setState(() {

                                  });
                                },
                                style: ButtonStyles.smallButton(
                                    ThemeColors.backgroundColor, ThemeColors.darkBlack),
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),

                              const SizedBox(width: 20,),

                              // create button
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    // after validation completed
                                    update == true ? groupUpdateApiFunc() : groupCreateApiFunc();
                                    groupFetchApiFunc();
                                    // groupNameController.clear();
                                    // allianceDropdownValue = "";
                                    // groupLinkDropdownValue = "";
                                    // isChecked = false;

                                  }
                                  // else {
                                  //   groupCreateApiFunc();
                                  //   groupFetchApiFunc();
                                  //   groupNameController.clear();
                                  //   allianceDropdownValue = allianceList.first;
                                  //   groupLinkDropdownValue = groupLinkList.first;
                                  //   isChecked = false;
                                  // }
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

  groupList(){
    return Container(
      decoration: UiDecoration().formDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10 , left: 10),
            alignment: Alignment.centerLeft,
            child:
            textDecoration.heading('Group List'),
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
                              groupFetchApiFunc();
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
                      const Text('Search: '), Expanded(child: FormWidgets().textFormField('Search' , searchController , onFieldSubmitted: (value){
                        setState(() {
                          groupFetchApiFunc();
                        });
                      },
                          onChanged: (value){
                            setState(() {
                              groupFetchApiFunc();
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
                              child: freshLoad == 1 ? const CircularProgressIndicator() :
                              SizedBox(
                                  width: double.maxFinite,
                                  child: buildDataTable()),
                            ),
                            const Divider(),

                          ],
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
                        groupFetchApiFunc();
                      });

                    }, icon: const Icon(Icons.first_page)),

                    // Prev Button
                    IconButton(
                        onPressed: GlobalVariable.prev == false ? null : () {
                          setState(() {
                            GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                            groupFetchApiFunc();
                          });
                        }, icon: const Icon(Icons.chevron_left)),

                    const SizedBox(width: 30,),

                    // Next Button
                    IconButton  (
                        onPressed: GlobalVariable.next == false ? null : () {
                          setState(() {
                            GlobalVariable.currentPage++;
                            groupFetchApiFunc();
                          });
                        }, icon: const Icon(Icons.chevron_right)),

                    // Last Page Button
                    IconButton(onPressed: !GlobalVariable.next ? null : () {
                      setState(() {
                        GlobalVariable.currentPage = GlobalVariable.totalPages;
                        groupFetchApiFunc();
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

  /// API GroupCreate
  Future groupCreateApi() async {
    var url = Uri.parse("${GlobalVariable.baseURL}Account/GroupStore");
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'token': Auth.token,
    };
    var body = {
      'group_title': groupNameController.text,
      // 'group_alliance': allianceDropdownValue,
      'group_alliance': allianceID.toString(),
      'link_group_id': groupLinkID.toString(),
      'fixed': isChecked ? '0' : '1', // 0 --> Fixed | 1 --> Editable
    };
    var response = await http.post(url , body: body , headers: headers);
    return response.body.toString();
  }

  /// API DataTableFetch
  Future groupFetchApi() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'token': Auth.token,
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/GroupList?limit=${int.parse(entriesDropdownValue)}&page=${GlobalVariable.currentPage}&keyword=${searchController.text}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  /// API Group Delete
  Future groupDeleteApi() async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'token': Auth.token,
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/GroupDelete?group_id=$groupID");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  /// API Group Edit
  Future groupEditApi() async {
    var headers = {
      'token': Auth.token,
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/GroupEdit?group_id=$groupID");
    var response = await http.get(url , headers: headers);
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
      'group_title': groupNameController.text,
      'group_alliance': allianceDropdownValue,
      'link_group_id': groupLinkID.toString(),
      'fixed': '1',  // 1 --> Editable
      'group_id': groupID.toString()
    };
    var response = await http.post(url , headers: headers , body: body);
    return response.body.toString();
  }

  /// Group Dropdown Api
  Future groupDropdownApi() async   {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Account/GroupFetch');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }

}
