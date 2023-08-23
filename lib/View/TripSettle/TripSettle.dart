import 'package:flutter/material.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class TripSettle extends StatefulWidget {
  const TripSettle({Key? key}) : super(key: key);

  @override
  State<TripSettle> createState() => _TripSettleState();
}

class _TripSettleState extends State<TripSettle> with Utility{

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
                Icon(Icons.trip_origin, color: Colors.grey, size: 22),  SizedBox(width: 5,),
                Text("Trip Settle" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
              ],),

              const SizedBox(height: 10,),

              /// Buttons
              SizedBox(
                height: 50,
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

                      /// Pending Outdoor
                      // ElevatedButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         Navigator.push(context, MaterialPageRoute(builder: (context) => const PendingOutdoor(),));
                      //       });
                      //     },
                      //     style: ButtonStyles.dashboardButton2(),
                      //     child: Text("Pending Outdoor" ,style: TextDecoration().dashboardBtn(),)
                      // ),
                      // const SizedBox(width: 10,),


                    ],
                  ),
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