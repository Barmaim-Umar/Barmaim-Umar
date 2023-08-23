import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
// import 'package:pdf/widgets.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:http/http.dart' as http;

class MyTaskScreen extends StatefulWidget {
  MyTaskScreen({super.key});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

List<String> statusDropdownList = [
  "In Progress",
  "Completed",
  "Issue",
  "Pending",
];

class _MyTaskScreenState extends State<MyTaskScreen> {
  // Replace this with actual data of the user's tasks from your transportation software
  List<Task> userTasks = [
    Task(
      title: "Pick up shipment at Warehouse A",
      description:
      "Pick up the shipment from Warehouse A and deliver it to Warehouse B.",
      assignedBy: "Sibghat Ahmed",
    ),
    Task(
      title: "Deliver the goods to Customer X.",
      description:
      "Deliver the goods to Customer X's address before the end of the day.",
      assignedBy: "Sibghat Ahmed",
    ),
    Task(
      title: "Transfer products to Warehouse C",
      description: "Transfer products from Warehouse B to Warehouse C.",
      assignedBy: "Alex Johnson",
    ),
    Task(
      title: "Deliver emergency supplies to Hospital Y",
      description: "Urgently deliver medical supplies to Hospital Y.",
      assignedBy: "Michael Brown",
    ),
    Task(
      title: "Deliver emergency supplies to Hospital Y",
      description: "Urgently deliver medical supplies to Hospital Y.",
      assignedBy: "Dinesh Sir",
    ),
    Task(
      title: "Deliver ordered items to Supermarket T",
      description: "Urgently deliver medical supplies to Hospital Y.",
      assignedBy: "Michael Brown",
    ),
    Task(
      title: "Pickup goods supplies from Warehouse N",
      description: "Urgently deliver medical supplies to Hospital Y.",
      assignedBy: "Sultan Sheikh",
    ),
    Task(
      title: "Deliver emergency supplies to Hospital Y",
      description: "Urgently deliver medical supplies to Hospital Y.",
      assignedBy: "Rouf Khan ",
    ),
    // Add more tasks as needed...
  ];

  List<Task> _searchResults = [];

  String statusDropdownValue = statusDropdownList.first;
  String selectedItem1 = '';

  // Define a TextEditingController to manage the search input
  TextEditingController _searchController = TextEditingController();

  TextEditingController fromDate = TextEditingController();
  TextEditingController vehicleStatusRemark = TextEditingController();
  TextEditingController dayControllerVehicleActivity = TextEditingController(
      text: GlobalVariable.displayDate.day.toString().padLeft(2, '0'));
  TextEditingController monthControllerVehicleActivity = TextEditingController(
      text: GlobalVariable.displayDate.month.toString().padLeft(2, '0'));
  TextEditingController yearControllerVehicleActivity =
  TextEditingController(text: GlobalVariable.displayDate.year.toString());
  List TaskData = [];

  int freshLoad3 = 0;
  // Function to clear the search input
  void clearSearch() {
    setState(() {
      _searchResults.clear();
      _searchController.clear();
    });
  }

  getEmployeeTaskData() {
    setState(() {
      freshLoad3 = 1;
    });
    getEmployeeTasks().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        TaskData.addAll(info['data']) ;
        print(TaskData);
        setState(() {
          freshLoad3 = 0;
        });
      } else {
        setState(() {
          freshLoad3 = 0;
        });
      }
      // print(user);
    });
  }
  @override
  void initState() {
    getEmployeeTaskData();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          // width: 450.0,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  controller:
                  _searchController, // Use the TextEditingController
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black),
                    hintText: "Search tasks...",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  onChanged: (query) {
                    _performSearch(query);
                  },
                ),
              ),
              freshLoad3 == 1 ? const CircularProgressIndicator() : Expanded(
                child: _buildTaskList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future getEmployeeTasks () async{
    var headers = {'token': Auth.token};
    var url = Uri.parse(
        '${GlobalVariable.baseURL}Employee/EmployeeTaskList?user_id=${GlobalVariable.userId}');
    var response = await http.get(url, headers: headers);
    print('response: ${response.body}');
    return response.body.toString();
  }
  Widget _buildTaskList() {
    return ListView.builder(
      itemCount:TaskData.length,
      // _searchResults.isNotEmpty ? _searchResults.length : userTasks.length,
      itemBuilder: (context, index) {
        final task = _searchResults.isNotEmpty
            ? _searchResults[index]
            : userTasks[index];
        return _buildTaskCard(context, task,index);
      },
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    setState(() {
      _searchResults = userTasks.where((task) {
        final titleLower = task.title.toLowerCase();
        final descriptionLower = task.description.toLowerCase();
        final queryLower = query.toLowerCase();
        final name = task.assignedBy.toLowerCase();
        return titleLower.contains(queryLower) ||
            descriptionLower.contains(queryLower) ||
            name.contains(queryLower);
      }).toList();
    });
  }

  Widget _buildTaskCard(BuildContext context, Task task,index) {
    TaskStatus _selectedStatus = TaskStatus.pending;

    final Color primaryColor = const Color.fromARGB(255, 35, 28, 118);
    final Color backgroundColor = const Color.fromARGB(255, 102, 177, 252);
    final Color textColor = Colors.black;

    final Gradient cardGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 58, 101, 180),
        Color.fromARGB(255, 34, 57, 126)
      ], // Use vibrant colors for the gradient
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
// ######################################################################
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4, // Add a subtle shadow to the card
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primaryColor),
          gradient: cardGradient, // Set the gradient as the card background
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(
                      TaskData[0]['employee_name'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(255, 37, 131,
                        246), // Use a color for the assignedBy chip
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    TaskData[0]['employee_task_title'].toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                      color: Colors
                          .white, // Use white text color on the gradient background
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Chip(
                  label: Text(
                    TaskData[0]['created_date'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor:
                  Colors.green, // Use a color for the date chip
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: 140,
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(6), // Apply rounded corner effect
                  ),
                  child: SearchDropdownWidget(
                    showSearchBox: false,
                    maxHeight: 150,
                    dropdownList: statusDropdownList,
                    hintText: 'Actions',
                    onChanged: (value) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Action:" + statusDropdownValue),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: SizedBox(
                                        height: 100,
                                        width: 300,
                                        child: TextFormField(
                                          controller: vehicleStatusRemark,
                                          maxLines: 3,
                                          style: const TextStyle(fontSize: 15),
                                          decoration: UiDecoration()
                                              .outlineTextFieldDecoration(
                                            "Enter Remark",
                                            Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Expanded(
                                    //   child: Column(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.start,
                                    //     children: [
                                    //       Row(
                                    //         children: [
                                    //           TextDecoration().heading1('Date'),
                                    //           const Text(
                                    //             "  dd-mm-yyyy",
                                    //             style: TextStyle(
                                    //                 fontSize: 12,
                                    //                 color: Colors.grey),
                                    //           )
                                    //         ],
                                    //       ),
                                    //       DateFieldWidget2(
                                    //           dayController:
                                    //               dayControllerVehicleActivity,
                                    //           monthController:
                                    //               monthControllerVehicleActivity,
                                    //           yearController:
                                    //               yearControllerVehicleActivity,
                                    //           dateControllerApi: fromDate),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  vehicleStatusRemark.clear();

                                });
                                Navigator.pop(context, 'Cancel');
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  vehicleStatusRemark.clear();

                                });
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      statusDropdownValue = value!;
                    },
                    selectedItem: selectedItem1,
                  ),
                  // child: DropdownButton<TaskStatus>(
                  //   underline: Container(),
                  //   dropdownColor: Colors.white,
                  //   borderRadius: BorderRadius.circular(6), // Apply rounded corner effect
                  //   value: _selectedStatus,
                  //   items: TaskStatus.values.map((status) {
                  //     return DropdownMenuItem<TaskStatus>(
                  //       value: status,
                  //       child: Text(
                  //         _getStatusText(status),
                  //         style: TextStyle(fontSize: 16, color: textColor),
                  //       ),
                  //     );
                  //   }).toList(),
                  //   onChanged: (status) {
                  //     setState(() {
                  //       _selectedStatus = status!;
                  //     });
                  //   },
                  // ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return "In Progress";
      case TaskStatus.completed:
        return "Completed";
      case TaskStatus.issue:
        return "Issue";
      case TaskStatus.pending:
      default:
        return "Pending";
    }
  }

}

class Task {
  final String title;
  final String description;
  final String assignedBy;

  Task({
    required this.title,
    required this.description,
    required this.assignedBy,
  });
}

enum TaskStatus {
  inProgress,
  completed,
  pending,
  issue,
}
