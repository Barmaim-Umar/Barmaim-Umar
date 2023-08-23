import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class CreateFYears extends StatefulWidget {
  const CreateFYears({Key? key}) : super(key: key);

  @override
  State<CreateFYears> createState() => _CreateFYearsState();
}

List<String> allianceList = ["alliance" , "alliance" , "alliance" , "alliance"];
List<String> userPostList = ["Admin" , "Operator" , "Manager"];
List<String> entriesList = ["10" , "20" , "30" , "40" ];

class _CreateFYearsState extends State<CreateFYears> with Utility {

  bool update = false;

  int freshLoad = 0;
  String entriesDropdownValue = entriesList.first;

  final _formKey = GlobalKey<FormState>();

  TextEditingController fromDateUi = TextEditingController();
  TextEditingController fromDateApi = TextEditingController();
  TextEditingController toDateUi = TextEditingController();
  TextEditingController toDateApi = TextEditingController();

  TextEditingController searchController = TextEditingController();
  TextEditingController pageNoController = TextEditingController();
  TextEditingController dayControllerFrom = TextEditingController();
  TextEditingController monthControllerFrom = TextEditingController();
  TextEditingController yearControllerFrom = TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  FocusNode focusNode1 = FocusNode();

  int totalRecords = 0;

  List yearTableList = [];
  List yearEditList = [];
  var yearID;

  /// API ==================

  createYearApiFunc(){
    setState(() {
      freshLoad = 1;
    });
    createYearApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);

        yearFetchApi();
        setState(() {
          freshLoad = 0;
        });

      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);

        setState(() {
          freshLoad = 0;
        });
      }
    });
  }

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
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  yearEditApiFunc(){
    yearEditApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        setStateMounted(() {
          fromDateUi.text = info['data'][0]['year_from'];
          fromDateApi.text = info['data'][0]['year_from'];
          toDateUi.text = info['data'][0]['year_to'];
          toDateApi.text = info['data'][0]['year_to'];
        });

      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  yearUpdateApiFunc(){
    setState(() {
      freshLoad = 1;
    });
    yearUpdateApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);

        yearFetchApiFunc();
        setState(() {
          freshLoad = 0;
          update = false;
        });
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setState(() {
          freshLoad = 0;
          update = false;
        });
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

  @override
  void initState() {
    GlobalVariable.currentPage = 1;
    yearFetchApiFunc();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode1);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Create F Years"),
      body: Responsive(
        /// Mobile
          mobile: Container(),

          /// Tablet
          tablet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Create Year
                Expanded(child: createYearForm()),
                const SizedBox(width: 10,),
                /// Year List
                Expanded(flex: 2,child: yearList()),
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
                    flex: 2,
                    child: createYearForm()),
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
        DataColumn(label: TextDecorationClass().dataColumnName("Action")),
      ],
      rows:  List.generate(yearTableList.length, (index) {
        return DataRow(
            color: MaterialStatePropertyAll(index == 0 || index % 2 == 0 ? Colors.grey.shade100 : Colors.white),
            cells: [
              DataCell(TextDecorationClass().dataRowCell(yearTableList[index]['year_gen_id'].toString())),
              DataCell(TextDecorationClass().dataRowCell(UiDecoration().getFormattedDate(yearTableList[index]['year_from']))),
              DataCell(TextDecorationClass().dataRowCell(UiDecoration().getFormattedDate(yearTableList[index]['year_to']))),
              DataCell( Row(
                children: [

                  // edit Icon
                  UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setStateMounted(() {
                          update = true;
                          yearID = yearTableList[index]['year_gen_id'];
                          yearEditApiFunc();
                        });
                      }, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),

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
                ],
              )),
            ]);
      }),

    );
  }

  createYearForm(){
    return  Container(
      decoration: UiDecoration().formDecoration(),
      child: Form(
        key: _formKey,
        child: FocusScope(
          child: FocusTraversalGroup(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                    child:
                    TextDecorationClass().heading( update == true ? 'Update Year' : 'Generate Year'),
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
                        children: [

                          FormWidgets().formDetails2('From Date'  ,
                            DateFieldWidget2(
                                dayController: dayControllerFrom,
                                monthController: monthControllerFrom,
                                yearController: yearControllerFrom,
                                dateControllerApi: fromDateApi
                            ),
                            //   TextFormField(
                            //   focusNode: focusNode1,
                            //   readOnly: true,
                            //   controller: fromDateUi,
                            //   decoration: UiDecoration().dateFieldDecoration('Enter From Date'),
                            //   onTap: (){
                            //     UiDecoration().showDatePickerDecoration(context).then((value){
                            //       setState(() {
                            //         String month = value.month.toString().padLeft(2, '0');
                            //         String day = value.day.toString().padLeft(2, '0');
                            //         fromDateUi.text = "$day-$month-${value.year}";
                            //         fromDateApi.text = "${value.year}-$month-$day";
                            //       });
                            //     });
                            //   },
                            //
                            //   validator: (value) {
                            //     if(value == null || value == ''){
                            //       return "Please Select Date";
                            //     }
                            //     return null;
                            //   },
                            // ),
                          ),

                          FormWidgets().formDetails2('To Date'  ,
                            DateFieldWidget2(
                                dayController: dayControllerTo,
                                monthController: monthControllerTo,
                                yearController: yearControllerTo,
                                dateControllerApi: toDateApi
                            ),
                            //   TextFormField(
                            //   readOnly: true,
                            //   controller: toDateUi,
                            //
                            //   decoration: UiDecoration().dateFieldDecoration('Enter To Date'),
                            //   onTap: (){
                            //     UiDecoration().showDatePickerDecoration(context).then((value){
                            //       setState(() {
                            //         String month = value.month.toString().padLeft(2, '0');
                            //         String day = value.day.toString().padLeft(2, '0');
                            //         toDateUi.text = "$day-$month-${value.year}";
                            //         toDateApi.text = "${value.year}-$month-$day";
                            //       });
                            //     });
                            //   },
                            //
                            //   validator: (value) {
                            //     if(value == null || value == ''){
                            //       return "Please Select Date";
                            //     }
                            //     return null;
                            //   },
                            // ),
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
                                  fromDateUi.text = "";
                                  fromDateApi.text = "";
                                  toDateUi.text = "";
                                  toDateApi.text = "";
                                  setStateMounted(() { update = false; });
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

                                    print("fromDate: ${fromDateApi.text} \n toDate: ${toDateApi.text}");

                                    // checking if "fromDate" is greater or smaller or equal to "toDate"
                                    if(DateTime.parse(fromDateApi.text).isBefore(DateTime.parse(toDateApi.text))){

                                      // after validation completed
                                      update == true ? yearUpdateApiFunc() : createYearApiFunc();
                                      yearFetchApiFunc();

                                      setState(() {
                                        fromDateUi.text = "";
                                        fromDateApi.text = "";
                                        toDateUi.text = "";
                                        toDateApi.text = "";
                                      });

                                    } else{
                                      AlertBoxes.flushBarErrorMessage('"From Date" is after "To Date"', context);
                                    }

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
                )
              ],
            ),
          ),
        ),
      ),
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
                                  child: buildDataTable()),
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

  // Api
  Future createYearApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}FY/FYStore");
    var body = {
      'year_from': fromDateApi.text,
      'year_to': toDateApi.text
    };
    var response = await http.post(url , headers: headers , body: body);
    return response.body.toString();
  }

  Future yearFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}FY/FYlist?limit=$entriesDropdownValue&page=${GlobalVariable.currentPage}&keyword=${searchController.text}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future yearEditApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}FY/FYEdit?year_gen_id=${yearID.toString()}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future yearUpdateApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}FY/FYStore");
    var body = {
      'year_from': fromDateApi.text,
      'year_to': toDateApi.text,
      'year_gen_id': yearID.toString()
    };
    var response = await http.post(url , headers: headers, body: body);
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

  void setStateMounted(VoidCallback fn) {
    if(mounted) {
      setState(fn);
    }
  }

}
