import 'package:flutter/material.dart';
import 'package:pfc/View/Automation/AtmAutomation/AtmAutomation.dart';
import 'package:pfc/View/Automation/BpclAutomation/BpclAutomation.dart';
import 'package:pfc/View/Automation/FasTagAutomation/FasTagAutomation.dart';
import 'package:pfc/utility/Widgets/CustomMenuButton.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class Automation extends StatefulWidget {
  const Automation({Key? key}) : super(key: key);

  @override
  State<Automation> createState() => _AutomationState();
}

class _AutomationState extends State<Automation> with Utility{

  List buttonNames = [
    {
      'btn_name': 'BPCL Automation',
      'class_name':const BpclAutomation()
    },
    {
      'btn_name': 'ATM Automation',
      'class_name':const AtmAutomation()
    },
    {
      'btn_name': 'FasTag Automation',
      'class_name':const FasTagAutomation()
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
                Icon(Icons.connect_without_contact_rounded, color: Colors.grey, size: 22),  SizedBox(width: 5,),
                Text("Automation" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
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

                            // BPCL Automation
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BpclAutomation(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("BPCL Automation" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // ATM Automation
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AtmAutomation(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("ATM Automation" ,style: TextDecorationClass().dashboardBtn(),)
                            ),
                            const SizedBox(width: 10,),

                            // FasTag Automation
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FasTagAutomation(),));
                                  });
                                },
                                style: ButtonStyles.dashboardButton2(),
                                child: Text("FasTag Automation" ,style: TextDecorationClass().dashboardBtn(),)
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