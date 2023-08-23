import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:http/http.dart' as http;

class ChangeFYYears extends StatefulWidget {
  const ChangeFYYears({Key? key}) : super(key: key);

  @override
  State<ChangeFYYears> createState() => _ChangeFYYearsState();
}

  List<String> entriesList = ["10" , "20" , "30" , "40" ];
class _ChangeFYYearsState extends State<ChangeFYYears> {

  int freshLoad = 0;
  List yearTableList = []; // for data table
  List<String> yearDropdownList = []; // for dropdown
  List yearDropdownListWithID = []; // for dropdown
  bool update = false;
  int? yearID;
  ValueNotifier<String> selectedYear = ValueNotifier("");
  String entriesDropdownValue = entriesList.first;
  TextEditingController searchController = TextEditingController();
  TextEditingController pageNoController = TextEditingController();

  // API
  yearFetchApiFunc(){
    yearFetchApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        yearTableList.clear();

        yearTableList.addAll(info['data']);

        GlobalVariable.totalRecords = info['total_records'];
        GlobalVariable.totalPages = info['total_pages'];
        GlobalVariable.currentPage = info['page'];
        GlobalVariable.next = info['next'];
        GlobalVariable.prev = info['prev'];

        setState(() {
          freshLoad = 0;
        });

      }
      else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  yearDeleteApiFunc(){
    yearDeleteApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  changeFYApiFunc(){
    changeFYApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  // Dropdown API
  yearFetchDropdownApiFunc() {
    yearFetchDropdownApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){

        yearDropdownList.clear();
        yearDropdownListWithID.clear();

        // changing date format to dd-mm-yy and adding in "yearDropdownList"
        for(int i = 0; i<info['data'].length; i++){
          yearDropdownList.add('${UiDecoration().getFormattedDate(info['data'][i]['year_from'])} - ${UiDecoration().getFormattedDate(info['data'][i]['year_to'])}');

          //adding in "yearDropdownListWithID" to compare with "yearDropdownList" and get yearID
          yearDropdownListWithID.add({
            'year_from_to': '${UiDecoration().getFormattedDate(info['data'][i]['year_from'])} - ${UiDecoration().getFormattedDate(info['data'][i]['year_to'])}',
            'year_gen_id': info['data'][i]['year_gen_id']
          });

          // checking active f year in dropdown
            if(info['data'][i]['active'] == 1){

              // storing active f year in global variable
              setStateMounted(() {
                GlobalVariable.fYearFrom = DateTime.parse(info['data'][i]['year_from']) ;
                GlobalVariable.fYearTo = DateTime.parse(info['data'][i]['year_to']);
              });


              // showing active f year in dropdown value
              selectedYear.value = '${UiDecoration().getFormattedDate(info['data'][i]['year_from'])} - ${UiDecoration().getFormattedDate(info['data'][i]['year_to'])}';

              // storing active f yearID
              yearID = info['data'][i]['year_gen_id'];
            }

        }
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    yearFetchDropdownApiFunc();
    yearFetchApiFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Change FY Years"),
      body: Responsive(
        /// Mobile
          mobile: Container(),

          /// Tablet
          tablet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // /// Create Year
                // Expanded(child: createYearForm()),
                // const SizedBox(width: 10,),
                /// Year List
                Expanded(flex: 1,child: yearList()),
              ],
            ),
          ),

          /// Desktop
          desktop: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Create Year
                Expanded(
                    flex: 1,
                    child: changeYearForm()),
                const SizedBox(width: 10,),
                /// Year List
                Expanded(
                    flex: 3,
                    child: yearList()
                )
              ],
            ),
          )
      ),
    );
  }

  /// DATATABLE ===========================
  Widget buildDataTable() {
    return yearTableList.isEmpty ? const Center(child: Text("yearTableList.isEmpty \nUpdating List..."),) : DataTable(
      columns: [
        DataColumn(label: TextDecorationClass().dataColumnName("Year ID")),
        DataColumn(label: TextDecorationClass().dataColumnName("From Year")),
        DataColumn(label: TextDecorationClass().dataColumnName("To Year")),
        DataColumn(label: TextDecorationClass().dataColumnName("Created By")),
        DataColumn(label: TextDecorationClass().dataColumnName("Action")),
      ],
      rows:  List.generate(yearTableList.length, (index) {
        return DataRow(
            color: MaterialStatePropertyAll(index == 0 || index % 2 == 0 ? Colors.grey.shade100 : Colors.white),
            cells: [
              DataCell(TextDecorationClass().dataRowCell(yearTableList[index]['year_gen_id'].toString())),
              DataCell(TextDecorationClass().dataRowCell(UiDecoration().getFormattedDate(yearTableList[index]['year_from']))),
              DataCell(TextDecorationClass().dataRowCell(UiDecoration().getFormattedDate(yearTableList[index]['year_to']))),
              DataCell(TextDecorationClass().dataRowCell(yearTableList[index]['user_name'] ?? '_')),
              DataCell( Row(
                children: [

                  // delete Icon
                  UiDecoration().actionButton( ThemeColors.deleteColor,IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return
                        AlertDialog(
                          title: const Text("Are you sure you want to delete"),
                          actions: [
                            TextButton(onPressed: () {
                              Navigator.pop(context);
                            }, child: const Text("Cancel")),

                            TextButton(onPressed: () {
                              setState(() {
                                yearID = yearTableList[index]['year_gen_id'];
                                yearDeleteApiFunc();
                                yearFetchApiFunc();
                              });
                              Navigator.pop(context);
                            }, child: const Text("Delete"))
                          ],
                        );
                    },);
                  }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),

                  // block Icon
                  UiDecoration().actionButton( ThemeColors.primary,IconButton(padding: const EdgeInsets.all(0),onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return
                        AlertDialog(
                          title: const Text("Are you sure you want to Block This Year"),
                          actions: [
                            TextButton(onPressed: () {
                              Navigator.pop(context);
                            }, child: const Text("Cancel")),

                            TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: ThemeColors.primary,
                                  foregroundColor: Colors.white
                                ),
                                onPressed: () {},
                                child: const Text("Block"))
                          ],
                        );
                    },);
                  }, icon: const Icon(Icons.block, size: 15, color: Colors.white,))),

                  const SizedBox(width: 5,),

                  // f year Activated
                  yearTableList[index]['active'] == 1 ?
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(3)
                    ),
                    child: const Text("Active", style: TextStyle(color: Colors.white),),
                  ) :
                      const SizedBox(),
                ],
              )),
            ]);
      }),

    );
  }

  changeYearForm(){
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: UiDecoration().formDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(" Activated Financial Year"),
              // Dropdown
              ValueListenableBuilder(
                valueListenable: selectedYear,
                builder: (context, value2, child) =>
                 SearchDropdownWidget(
                    dropdownList: yearDropdownList,
                    hintText: "Select Year",
                    onChanged: (value) {
                      selectedYear.value = value!;

                      // saving f year id
                      for(int i=0; i<yearDropdownListWithID.length; i++){
                        if(value == yearDropdownListWithID[i]['year_from_to']){
                          yearID = yearDropdownListWithID[i]['year_gen_id'];
                        }
                        }

                    },
                    selectedItem: value2
                ),
              ),
              const SizedBox(height: 10,),

              // change button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.primary
                ),
                  onPressed: () {
                    changeFYApiFunc();
                    yearFetchApiFunc();
                    Future.delayed(const Duration(milliseconds: 1000), () => yearFetchDropdownApiFunc(),);

                  },
                  child: const Text("Change"),
              )
            ],
          ),
        ),

      ],
    );
  }

  yearList(){
    return Container(
      decoration: UiDecoration().formDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10 , left: 10),
            alignment: Alignment.centerLeft,
            child:
            TextDecorationClass().heading('Year List'),
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
                              yearFetchApiFunc();
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
                      const Text('Search: '), Expanded(
                          child: FormWidgets().textFormField('Search' , searchController ,
                              onFieldSubmitted: (value){
                                setState(() {
                                  yearFetchApiFunc();
                                });
                              },
                              onChanged: (value){
                                setState(() {
                                  yearFetchApiFunc();
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
                              child: freshLoad == 1 ? const Center(child: CircularProgressIndicator(),) :
                              SizedBox(
                                  width: double.maxFinite,

                                  /// Datatable
                                  child: buildDataTable(),
                              ),
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
                        yearFetchApiFunc();
                      });
                    }, icon: const Icon(Icons.first_page)),

                    // Prev Button
                    IconButton(
                        onPressed: GlobalVariable.prev == false ? null : () {
                          setState(() {
                            GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                            yearFetchApiFunc();
                          });
                        }, icon: const Icon(Icons.chevron_left)),

                    const SizedBox(width: 30,),

                    // Next Button
                    IconButton  (
                        onPressed: GlobalVariable.next == false ? null : () {
                          setState(() {
                            GlobalVariable.currentPage++;
                            yearFetchApiFunc();
                          });
                        }, icon: const Icon(Icons.chevron_right)),

                    // Last Page Button
                    IconButton(onPressed: !GlobalVariable.next ? null : () {
                      setState(() {
                        GlobalVariable.currentPage = GlobalVariable.totalPages;
                        yearFetchApiFunc();
                      },
                      );
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

  // API ===========================
  Future yearFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}FY/FYlist?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&keyword=${searchController.text}");
    var response = await http.get(url , headers: headers);
    print("vv66: ${response.body.toString()}");
    return response.body.toString();
  }

  Future yearDeleteApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}FY/FYDelete?year_gen_id=${yearID.toString()}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future changeFYApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}FY/changeFY");
    var body = {
      'year_gen_id' : yearID.toString(),
      'user_id':GlobalVariable.entryBy
    };
    var response = await http.post(url, headers: headers, body: body);
    return response.body.toString();

  }

  // for year dropdown to show all years - no pagination
  Future yearFetchDropdownApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}FY/FYFetch");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }

}