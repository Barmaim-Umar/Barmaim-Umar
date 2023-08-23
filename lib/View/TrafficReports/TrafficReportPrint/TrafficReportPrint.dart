import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

import 'TrafficReportPrintFunc.dart';
class TrafficReportPrint extends StatefulWidget {
  const TrafficReportPrint({Key? key}) : super(key: key);

  @override
  State<TrafficReportPrint> createState() => _TrafficReportPrintState();
}
class _TrafficReportPrintState extends State<TrafficReportPrint> with Utility {
  List<String> list = ['Reported', 'Unload', 'Send Empty', 'Crossing', 'Diverted'];
  List trafficReport2 = [];
  String entriesDropdownValue = '';
  Map trafficReport = {};
  bool isLoading = false;
  trafficReportsApiFunc(){
    setState(() {
      isLoading = true;
    });
    trafficReportsApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        trafficReport.addAll(info['data']);

        for(int i=0; i< info['data']['vehicle_Maintanance'].length; i++){
          trafficReport2.add(info['data']['vehicle_Maintanance'][i]['vehicle_number']);
        }
        // trafficReport2.addAll(info['data']['vehicle_Maintanance']);


      print('trafficReportData: ${trafficReport2}');
        setState(() {
          isLoading = false;
        });
      }
      else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setState(() {
          isLoading = false;
        });
      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    trafficReportsApiFunc();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar("Traffic Report Print"),
      body: SingleChildScrollView(
        child: Column(
          children: [
          Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Traffic ',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.grey.shade600),),
                    // entries dropdown
                    SizedBox(
                      width: 180,
                      child: SearchDropdownWidget(
                          dropdownList: list,
                          hintText: "Select Type",
                          showSearchBox: false,
                          maxHeight: 250,
                          onChanged: (value) {
                        entriesDropdownValue = value!;
                      }, selectedItem: entriesDropdownValue),
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                      style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor,100.0,40.0),
                      onPressed: () {},
                      child: const Text("Filter"),
                    ),
                    const Spacer(),
                    BStyles().button('Print', 'Print', "assets/print.png",onPressed: () {
                      // print('ggtg: ${ isLoading ? trafficReport : trafficReport['vehicle_Maintanance']}');
                      // trafficReport['vehicle_Maintanance'][i]['vehicle_number'],

                      TrafficReportPrintFunction().generatePrintDocument([[trafficReport2]]);
                      },),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
              ),


            Container(
              decoration: const BoxDecoration(
                border: BorderDirectional(bottom: BorderSide())
              ),
                child: const Text('PUSHPAK FREIGHT CARRIER TRAFFIC REPORT',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
            ),
            heightBox10(),

            isLoading == true?CircularProgressIndicator():Table(
              border: TableBorder.all(color: Colors.grey),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0:const FlexColumnWidth(1),
                1:const FlexColumnWidth(5),
              },
              children: [
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('PFC',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                              color: Colors.green,
                                borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                            const Text('OnRoad',style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                              color: Colors.purpleAccent,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                            const Text('Empty',style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                            const Text('Reported',style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                              color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                            const Text('Reported Halt',style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                              color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                            const Text('Unloaded',style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ],
                    )
                  ]
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Vehicle In Maintanance (${trafficReport['maintanance_count']})',style: TextStyle(color: Colors.deepOrangeAccent,fontSize: 16,fontWeight: FontWeight.w700),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5, // Adjust the vertical spacing between items as needed
                        children: [
                          for (int i = 0; i < trafficReport['vehicle_Maintanance'].length; i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                trafficReport['vehicle_Maintanance'][i]['vehicle_number'],
                                style: TextStyle(color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ]
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Vehicle Without Driver (${trafficReport['without_driver_count']})',
                        style: TextStyle(color: Colors.brown, fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5, // Adjust the vertical spacing between items as needed
                        children: [
                          for (int i = 0; i < trafficReport['vehicle_without_driver'].length; i++)
                            Text(
                              trafficReport['vehicle_without_driver'][i]['vehicle_number']+',',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Pending LR (${trafficReport['lr_count']})',style: TextStyle(color: Colors.blue.shade900,fontSize: 16,fontWeight: FontWeight.w700),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5, // Adjust the vertical spacing between items as needed
                        children: [
                          for (int i = 0; i < 100; i++)
                            Text(
                              trafficReport['pending_lr'][i]['lr_number'] == ''?'- ,':trafficReport['pending_lr'][i]['lr_number']+',',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ]
                ),

                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('To Location',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Details',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),textAlign: TextAlign.center),
                    ),
                  ]
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ahmedabad',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                          Row(
                            children: [
                              const Text('(1)',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16),),
                              const Text('(1)',style: TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.bold,fontSize: 16)),
                              Text('(1)',style: TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.bold,fontSize: 16)),
                              const Text('(1)',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16)),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0,left: 8),
                      child: Wrap(
                        spacing: 5,
                        children: [
                          RichText(
                              text: const TextSpan(
                                text: 'MH18BG2368',
                                style: TextStyle(fontWeight: FontWeight.w600,color: Colors.green,fontSize: 17),
                                children: [
                                  TextSpan(text: ' Ranjangaon(PEP|02-08)',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w400))
                                ]
                              )
                          ),
                          RichText(
                              text: TextSpan(
                                text: 'MH18BG2368',
                                style: TextStyle(fontWeight: FontWeight.w600,color: Colors.blue.shade900,fontSize: 17),
                                children: [
                                  const TextSpan(text: ' Ranjangaon(PEP|02-08)',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w400))
                                ]
                              )
                          ),
                          RichText(
                              text: const TextSpan(
                                text: 'MH18BG2368',
                                style: TextStyle(fontWeight: FontWeight.w600,color: Colors.purpleAccent,fontSize: 17),
                                children: [
                                  TextSpan(text: ' Ranjangaon(PEP|02-08)',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w400))
                                ]
                              )
                          ),
                          RichText(
                              text: const TextSpan(
                                text: 'MH18BG2368',
                                style: TextStyle(fontWeight: FontWeight.w600,color: Colors.red,fontSize: 17),
                                children: [
                                  TextSpan(text: ' Ranjangaon(PEP|02-08)',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w400))
                                ]
                              )
                          ),
                          RichText(
                              text: const TextSpan(
                                text: 'MH18BG2368',
                                style: TextStyle(fontWeight: FontWeight.w600,color: Colors.red,fontSize: 17),
                                children: [
                                  TextSpan(text: ' Ranjangaon(PEP|02-08)',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.w400))
                                ]
                              )
                          ),
                        ],
                      ),
                    ),
                  ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Amravati',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                            Row(
                              children: [
                                const Text('(1)',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16),),
                                const Text('(1)',style: TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.bold,fontSize: 16)),
                                Text('(1)',style: TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.bold,fontSize: 16)),
                                const Text('(1)',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16)),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Text('')
                    ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Akola',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                            Row(
                              children: [
                                const Text('(1)',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16),),
                                const Text('(1)',style: TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.bold,fontSize: 16)),
                                Text('(1)',style: TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.bold,fontSize: 16)),
                                const Text('(1)',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16)),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Text('')
                    ]
                ),
                TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Aurangabad',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                            Row(
                              children: [
                                const Text('(1)',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16),),
                                const Text('(1)',style: TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.bold,fontSize: 16)),
                                Text('(1)',style: TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.bold,fontSize: 16)),
                                const Text('(1)',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16)),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Text('')
                    ]
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future trafficReportsApi() async {
    var headers = {
      'token': Auth.token
    };
    var url =Uri.parse('${GlobalVariable.trafficBaseURL}apis/trafficreport/vehicleinmaintanance');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

}
