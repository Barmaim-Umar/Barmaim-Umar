import 'package:flutter/material.dart';
import 'package:pfc/View/Settings/ChangeFYYears/ChangeFYYears.dart';
import 'package:pfc/View/Settings/CreateFYears/CreateFYears.dart';
import 'package:pfc/View/Settings/DeleteHistory/DeleteHistory.dart';
import 'package:pfc/View/Settings/ManageBranch/ManageBranch.dart';
import 'package:pfc/View/Settings/PendingDelete/PendingDelete.dart';
import 'package:pfc/View/Settings/User/User.dart';
import 'package:pfc/utility/Widgets/CustomMenuButton.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with Utility{

  List buttonNames = [
    {
      'btn_name': 'User',
      'class_name':const User()
    },
    {
      'btn_name': 'Manage Branch',
      'class_name':const ManageBranch()
    },
    {
      'btn_name': 'Pending Delete',
      'class_name':const PendingDelete()
    },
    {
      'btn_name': 'Delete History',
      'class_name':const DeleteHistory()
    },
    {
      'btn_name': 'Change FY Years',
      'class_name':const ChangeFYYears()
    },
    {
      'btn_name': 'Create F Years',
      'class_name':const CreateFYears()
    },
  ];

  int selectedIndex = 0;
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10,),

              Row(children: const [
                Icon(Icons.settings, color: Colors.grey, size: 22),  SizedBox(width: 5,),
                Text("Settings" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
              ],),

              const SizedBox(height: 10,),

              /// Buttons
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Home
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                style: ButtonStyles.dashboardButton2(isSelected: true),
                                child: const Text("Home" ,style: TextStyle(color: Colors.white),)
                            ),
                            const SizedBox(width: 10,),

                            // User
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const User(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("User" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // Manage Branch
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageBranch(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Manage Branch" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // Pending Delete
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PendingDelete(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Pending Delete" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // Delete History
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteHistory(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Delete History" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // Change FY Years
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeFYYears(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Change FY Years" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // Create F Years
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateFYears(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("Create F Years" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                          ],
                        ),
                      ),
                    ),

                    // menu button
                    CustomMenuButton(buttonNames: buttonNames),
                    const SizedBox(width: 10,),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 290,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                      heightBox10(),
                      Container(
                        height: 380,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 350,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                      heightBox10(),
                      Container(
                        height: 320,
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 500,
                        width: 680,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                      heightBox10(),
                      Container(
                        height: 170,
                        width: 680,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}