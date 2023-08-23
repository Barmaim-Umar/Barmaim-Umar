import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/View/filePickerWeb/model/dropped_file.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class VehicleDocument extends StatefulWidget {
  const VehicleDocument({Key? key}) : super(key: key);

  @override
  State<VehicleDocument> createState() => _VehicleDocumentState();
}

List <String>vehicleNumber = ['MH20AD2143','MH21DM9250','MH20HM7598'];
List <String>entries = ['10','20','30' , '40'];

class _VehicleDocumentState extends State<VehicleDocument> with Utility{

  List vehicleDocList = [];
  int docID = 0;
  var vehicleID;
  int freshLoad = 1;
  bool update = false;
  List<String> selectVehicleList = [];
  List selectVehicleList2 = [];
  ValueNotifier<String> vehicleDropdownValue = ValueNotifier(""); // vehicle Dropdown

  String dropdownValue = vehicleNumber.first;
  String entriesValue = entries.first;
  final formKey = GlobalKey<FormState>();
  FocusNode focusNode1 = FocusNode();
  TextEditingController documentNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  DroppedFile? file;

  // for document
  List<int> imageBytes =[];
  var img;
  String fileExtension = '';
  int totalSize = 0;
  int sentSize = 0;
  double progressIndicator = 0.0;

  String imgPath = "";

  // API
  vehicleDocFetchApiFunc(){
    vehicleDocList.clear();
    vehicleDocFetchApi().then((value) {
      var info = jsonDecode(value);

        if(info['success'] == true){
          vehicleDocList.addAll(info['data']);
          GlobalVariable.totalRecords = info['total_records']  ?? 0 ;
          GlobalVariable.totalPages = info['total_pages'] ?? 0;
          GlobalVariable.currentPage = info['page'] ?? 0;
          GlobalVariable.next = info['next'] ?? false;
          GlobalVariable.prev = info['prev'] ?? false;

          setStateMounted(() {
            freshLoad = 0;
          });
        }else {
          AlertBoxes.flushBarErrorMessage(info['message'], context);
        }

    });
  }

  vehicleDocDeleteApiFunc(){
    vehicleDocDeleteApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  vehicleDocEditApiFunc(){
    setState(() {
      freshLoad = 1;
    });
    vehicleDocEditApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        setStateMounted(() {
        documentNameController.text = info['data'][0]['document_name'];
        imgPath = info['data'][0]['document_path'];

        setState(() {
          freshLoad = 0;
        });

        });
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  vehicleDocUpdateApiFunc() {
    vehicleDocUpdateApi().then((value) {
      var info = jsonDecode(value);
      try{
        if(info['success'] == true){
          setStateMounted(() {
            update = false;
            AlertBoxes.flushBarSuccessMessage(info['message'], context);
          });
        }else{
          AlertBoxes.flushBarErrorMessage(info['message'], context);
        }
      }
      catch(e){
        AlertBoxes.flushBarErrorMessage("catchError: $e", context);
      }
    });
  }

  // Dropdown api
  groupListFetchApiFunc() {
    groupListFetchApi().then((value) {
        var info = jsonDecode(value);
        if (info['success'].toString() == 'true') {
        selectVehicleList.clear();
        selectVehicleList2.clear();

        // selectGroupList.addAll(info['data']['driver_group_name']);
        selectVehicleList2.addAll(info['data']);
          for(int i = 0; i <info['data'].length; i++){
            selectVehicleList.add(info['data'][i]['vehicle_number']);
          }



          // selectDriverCityDropdownValue = selectDriverCityList.first;
          // getDriverGroupId();
          setStateMounted(() {
            freshLoad = 0;
          });
        } else {
          setStateMounted(() {
            freshLoad = 1;
          });
        }
      },
    );
  }
  ///
  // getDriverGroupId() {
  //   for (int i = 0; i < selectGroupList.length; i++) {
  //     if (selectDriverCityDropdownValue == selectGroupList[i]['driver_group_name']) {
  //       driverGroupId = selectGroupList[i]['drivers_group_id'];
  //     }
  //   }
  // }

  @override
  void initState() {
    vehicleDocFetchApiFunc();
    groupListFetchApiFunc();
    
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      FocusScope.of(context).requestFocus(focusNode1);
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Vehicle Document"),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:  Responsive(
            /// Mobile
            mobile: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child:
                  addVehicleDoc(),
                ),
                heightBox10(),
                Expanded(
                  flex: 1,
                  child:
                  vehicleList(),
                ),
              ],
            ),

            /// Tablet
            tablet: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child:
                  addVehicleDoc(),
                ),
                widthBox10(),
                Expanded(
                  flex: 1,
                  child:
                  vehicleList(),
                ),
              ],
            ),

            /// Desktop
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: addVehicleDoc(),
                ),
                widthBox20(),
                Expanded(
                    flex: 3,
                    child: vehicleList()
                )
              ],
            ),

          )

      ),
    );
  }

  addVehicleDoc(){
    return Container(
      decoration: UiDecoration().formDecoration(),
      child: Form(
        key: formKey,
        child: FocusScope(
          child: FocusTraversalGroup(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                    child:
                    // TextDecoration().formTitle('New Ledger'),
                    TextDecorationClass().heading(update?'Edit Vehicle Document':'Add Vehicle Document'),
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
                            heightBox10(),
                            /// Dropdown - Select Vehicle
                            FormWidgets().formDetails2("Select Vehicle", ValueListenableBuilder(
                              valueListenable: vehicleDropdownValue,
                              builder: (context, value2, child) =>
                               SearchDropdownWidget(
                                dropdownList: selectVehicleList ,
                                hintText: "Select Vehicle",
                                onChanged: (value) {

                                  vehicleDropdownValue.value = value!;

                                  // getting vehicle ID
                                  for(int i = 0; i<selectVehicleList2.length; i++){
                                    if(selectVehicleList2[i]['vehicle_number'] == value ){
                                      vehicleID = selectVehicleList2[i]['vehicle_id'];
                                    }
                                  }

                                },
                                selectedItem: value2,
                              ),
                            )),
                            heightBox10(),

                            FormWidgets().onlyAlphabetField("Document Name", "Enter Document Name", documentNameController , context , focusNode: focusNode1),
                            heightBox10(),

                            FormWidgets().formDetails2("Attach scanned image copy", Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// Upload Button
                                ElevatedButton.icon(

                                  onPressed: () => kIsWeb ? pickFileWeb() : pickFile(),
                                  icon: const Icon(Icons.file_copy , size: 20,),
                                label: const Text("Upload Document"),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: img == null || img == "" ? ThemeColors.primaryColor : Colors.green,
                                    minimumSize: const Size(200, 50)
                                ),
                                ),

                                 const SizedBox(height: 8,),

                                img == null || img == "" ?
                                const Text("No File Chosen" , style: TextStyle(color: Colors.grey , fontSize: 12),)
                                    :
                                    const Icon(Icons.check_circle_outline , color: Colors.green,)
                              ],
                            )),
                            heightBox10(),

                            /// Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    formKey.currentState!.reset();
                                    vehicleDropdownValue.value = "";
                                    documentNameController.clear();
                                    img = null;
                                    setState(() {
                                      update = false;
                                    });

                                  },
                                  style: ButtonStyles.smallButton(
                                      ThemeColors.backgroundColor, ThemeColors.darkBlack),
                                  child: const Text(
                                    'Reset',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if(formKey.currentState!.validate()){
                                      formKey.currentState!.save();

                                      if(img == null && update == false){
                                        AlertBoxes.flushBarErrorMessage("Pick Image", context);
                                      } else if(update == true){
                                        uploadFile();
                                      } else {
                                        uploadFile();
                                      }
                                      vehicleDocFetchApiFunc();
                                    }

                                  },
                                  style: ButtonStyles.smallButton(
                                      ThemeColors.primaryColor, ThemeColors.whiteColor),
                                  child:  Text(
                                    update ? 'Update':'Create',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                          ]
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

  vehicleList(){
    return Container(
      decoration: UiDecoration().formDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10 , left: 10),
            alignment: Alignment.centerLeft,
            child:
            TextDecorationClass().heading('Vehicle List'),
          ),
          const Divider(),
          // dropdown & search
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                TextDecorationClass().subHeading2('Show '),
                SizedBox(
                  width: 80,
                  height: 35,
                  child: SearchDropdownWidget(dropdownList: entries, hintText: "10", onChanged: (value) {
                    entriesValue = value!;
                    vehicleDocFetchApiFunc();
                  }, selectedItem: entriesValue,
                  showSearchBox: false,
                    maxHeight: 200,
                  ),
                ),
                TextDecorationClass().subHeading2(' entries'),
                const Spacer(),
                TextDecorationClass().subHeading2('Search: '),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: searchController,
                    onFieldSubmitted: (value) {
                      vehicleDocFetchApiFunc();
                    },
                    decoration: UiDecoration().outlineTextFieldDecoration('Search', ThemeColors.primaryColor),
                  ),
                )
              ],
            ),
          ),
          heightBox10(),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.mouse,PointerDeviceKind.trackpad,PointerDeviceKind.touch}),
                          child:
                          SizedBox(
                              width: double.maxFinite,
                              child: buildDataTable())
                      ),

                    ],
                  ))),

          Row(
            children: [
              // First Page Button
              IconButton(onPressed: !GlobalVariable.prev ? null : () {

                setState(() {
                 GlobalVariable.currentPage = 1;
                  vehicleDocFetchApiFunc();
                });

              }, icon: const Icon(Icons.first_page)),

              // Previous Button
              IconButton(onPressed: !GlobalVariable.prev ? null : () {
                setState(() {
                  GlobalVariable.currentPage > 1 ? GlobalVariable.currentPage-- : GlobalVariable.currentPage = 1;
                  vehicleDocFetchApiFunc();
                });

              }, icon: const Icon(CupertinoIcons.left_chevron)),

              const SizedBox(width: 30,),

              // Next Button
              IconButton(onPressed: !GlobalVariable.next ? null : () {

                setState(() {
                  GlobalVariable.currentPage < GlobalVariable.totalPages ? GlobalVariable.currentPage++  :
                  GlobalVariable.currentPage = GlobalVariable.totalPages;
                  vehicleDocFetchApiFunc();
                });

              }, icon: const Icon(CupertinoIcons.right_chevron)),

              // Last Page Button
              IconButton(onPressed: !GlobalVariable.next ? null : () {

                setState(() {
                  GlobalVariable.currentPage = GlobalVariable.totalPages;
                  vehicleDocFetchApiFunc();
                });

              }, icon: const Icon(Icons.last_page)),

            ],
          ),

        ],
      ),
    );
  }

  // DATATABLE ===========================
  Widget buildDataTable() {
    return vehicleDocList.isEmpty ? const Center(child: Text("vehicleDocList.isEmpty \nUpdating List..."),) : DataTable(
        columns: [
          DataColumn(label: TextDecorationClass().dataColumnName("Vehicle Number")),
          DataColumn(label: TextDecorationClass().dataColumnName("Document Title/Name")),
          DataColumn(label: TextDecorationClass().dataColumnName("Action")),
        ],
        rows:  List.generate(vehicleDocList.length, (index) {
          return DataRow(
              color:  MaterialStatePropertyAll(index == 0 || index % 2 == 0? ThemeColors.tableRowColor : Colors.white ),
              cells: [
                DataCell(TextDecorationClass().dataRowCell(vehicleDocList[index]['vehicle_id'].toString())),
                DataCell(TextDecorationClass().dataRowCell(vehicleDocList[index]['document_name'].toString())),
                DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // edit Icon
                    UiDecoration().actionButton( ThemeColors.editColor,IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.edit, size: 15, color: Colors.white,), onPressed: () {
                      setState(() {
                        update = true;
                        img = null;

                        docID = vehicleDocList[index]['document_id'];
                        vehicleID = vehicleDocList[index]['vehicle_id'].toString();
                        vehicleDropdownValue.value = vehicleDocList[index]['vehicle_id'].toString();

                        // using loop to show vehicle dropdown value
                        for(int i=0 ; i<selectVehicleList2.length; i++){
                          if(selectVehicleList2[i]['vehicle_id'].toString() == vehicleDropdownValue){
                            vehicleDropdownValue = selectVehicleList2[i]['vehicle_number'];
                          }
                        }

                        vehicleDocEditApiFunc();
                        // showPopUp();
                      });
                    },)),

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
                                  // ledgerID = vehicleDocList[index]['ledger_id'];
                                  docID = vehicleDocList[index]['document_id'];
                                  vehicleDocDeleteApiFunc();
                                  vehicleDocFetchApiFunc();
                                  // ledgerFetchApiFunc();
                                });
                                Navigator.pop(context);
                              }, child: const Text("Delete"))
                            ],
                          );
                      },);

                    }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),

                    // Info Icon
                    UiDecoration().actionButton( ThemeColors.infoColor,IconButton(
                        padding: const EdgeInsets.all(0),onPressed: () {
                      docID = vehicleDocList[index]['document_id'];
                      vehicleDropdownValue.value = vehicleDocList[index]['vehicle_id'].toString();
                      img = null;

                      // using loop to show vehicle dropdown value
                      for(int i=0 ; i<selectVehicleList2.length; i++){
                        if(selectVehicleList2[i]['vehicle_id'].toString() == vehicleDropdownValue){
                          vehicleDropdownValue = selectVehicleList2[i]['vehicle_number'];
                        }
                      }

                      vehicleDocEditApiFunc();
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
                  child:Form(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                            child:
                            // TextDecoration().formTitle('New Ledger'),
                            TextDecorationClass().heading(update?'Edit Vehicle Document':'Add Vehicle Document'),
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

                                    heightBox10(),
                                    FormWidgets().infoField("Select Vehicle", "Select Vehicle", TextEditingController(text: vehicleDropdownValue.value), context),

                                    heightBox10(),
                                    FormWidgets().infoField("Document Name", "Enter Document Name", documentNameController , context),

                                    heightBox10(),
                                    FormWidgets().formDetails2("Attached scanned image copy",
                                      CachedNetworkImage(
                                        imageUrl: "${GlobalVariable.baseURL}public/Vehicle_Documents/$imgPath",
                                        placeholder: (context, url) => const Center(child:  CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),

                                  ]
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
    },);
  }


  // API

  // dropdown api
  Future groupListFetchApi() async {
    var headers = {'token' : Auth.token};
    var url = Uri.parse("${GlobalVariable.baseURL}Vehicle/VehicleFetch");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }



  // Function to pick file (for windows)
  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    // Get the file extension.
    if (result != null) {
      fileExtension = result.files.first.extension!;
    }

    if (result != null) {

      File file = File(result.files.single.path ?? " ");
      // String fileName = file.path.split('/').last;  /* getting file name */
      File imageFile = File(file.path);


      int sizeInBytes = imageFile.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);

      if(sizeInMb > 2){
        setState(() => img = "");
        AlertBoxes.flushBarErrorMessage("Upload file less then 2mb", context);
      } else {
        imageBytes = imageFile.readAsBytesSync();
        img = base64Encode(imageBytes);
        setState(() {});
      }
    }
  }

  // Function to pick file (for web)
  Future pickFileWeb() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    // Get the file extension.
    if (result != null) {
      fileExtension = result.files.first.extension!;
    }

    if (result != null) {

      Uint8List? fileBytes = result.files.first.bytes;

      int sizeInBytes = fileBytes!.length;
      double sizeInMb = sizeInBytes / (1024 * 1024);

      if(sizeInMb > 2){
        setState( () => img = "" );
        AlertBoxes.flushBarErrorMessage("Upload file less then 2mb", context);
      }
      else{
        img = base64Encode(fileBytes);
        setState(() {});
      }
    }
  }

  // Function to upload file
  Future uploadFile() async {

    var dio = Dio();

    try {
      // dio
      dio.options.headers["token"] = Auth.token;

      FormData data = update ?
      // Update form
      FormData.fromMap({
        'vehicle_id': vehicleID.toString(),
        'document_name': documentNameController.text,
        'document': img.toString(),
        'document_id': docID.toString(),
        'file_extension' : fileExtension
      }) :
      // Create form
      FormData.fromMap({
        'vehicle_id': vehicleID.toString(),
        'document_name': documentNameController.text,
        'document': img.toString(),
        'file_extension' : fileExtension
      });

      var response = await dio.post("${GlobalVariable.baseURL}VehicleDocument/DocumentStore", data: data,
          onSendProgress: (int sent, int total) {}
      );

      if (response.data['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(response.data['message'], context);
        setState(() {
          update = false;
          vehicleDocFetchApiFunc();
        });
        print("if true: ${response.statusCode}");
      } else {
        AlertBoxes.flushBarErrorMessage(response.data['message'], context);
        print("if false: ${response.statusCode}");
      }
    }
    catch(e){
      return AlertBoxes.flushBarErrorMessage("catch ERROR: $e", context);
    }

  }

  /// not using vehicleDocCreateApi() and vehicleDocUpdateApi()
  /// : using uploadFile() for both create and update APIs
  Future vehicleDocCreateApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDocument/DocumentStore?limit=10&page=1&keyword=a");
    var body = {
      'vehicle_id': '22',
      'document_name': 'document_name tested',
      'document_path': 'document_path',
      // 'document_id': '11395'
    };
    var response = await http.post(url , headers: headers , body: body);

    return response.body.toString();
  }

  Future vehicleDocFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDocument/DocumentList?limit=$entriesValue&page=${GlobalVariable.currentPage}&keyword=${searchController.text}");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future vehicleDocDeleteApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDocument/DocumentDelete?document_id=$docID");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  Future vehicleDocEditApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDocument/DocumentEdit?document_id=$docID");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  /// not using vehicleDocCreateApi() and vehicleDocUpdateApi()
  /// : using uploadFile() for both create and update APIs
  Future vehicleDocUpdateApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDocument/DocumentStore");

    var body = {
      'vehicle_id': vehicleID.toString(),
      'document_name': documentNameController.text,
      // 'document_path': 'document_path',
      'document_id': docID.toString()
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

