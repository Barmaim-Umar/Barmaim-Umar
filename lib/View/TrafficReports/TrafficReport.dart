import 'package:flutter/material.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';

class TrafficReport extends StatefulWidget {
  const TrafficReport({Key? key}) : super(key: key);

  @override
  State<TrafficReport> createState() => _TrafficReportState();
}

class _TrafficReportState extends State<TrafficReport> with Utility{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar('Traffic Report'),
      body: SingleChildScrollView(
        child: ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          itemBuilder: (context, index) {
          return Column(
            children: [
              ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextDecorationClass().heading1('Ahmedabad'),
                    Row(
                      children: [
                        RichText(
                          softWrap: true,
                          text: const TextSpan(
                            text: 'Total Reported : ',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(text: '(',style: TextStyle(color: Colors.black)),
                              TextSpan(text: '00', style: TextStyle(color: Colors.blue)),
                              TextSpan(text: ') |',style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: 'Total Unloaded : ',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(text: '(',style: TextStyle(color: Colors.black)),
                              TextSpan(text: '00', style: TextStyle(color: Colors.blue)),
                              TextSpan(text: ') |',style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: 'Total Onroad : ',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(text: '(',style: TextStyle(color: Colors.black)),
                              TextSpan(text: '00', style: TextStyle(color: Colors.blue)),
                              TextSpan(text: ')',style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 17,vertical: 5),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextDecorationClass().blueHeading('MH20CR0007'),
                      Text('Ranjangaon',style: TextStyle(color: ThemeColors.grey700,fontWeight: FontWeight.w500,fontSize: 16),),
                      Text('PEPSICO INDIA HOLDINGS',style: TextStyle(color: ThemeColors.grey700,fontWeight: FontWeight.w500,fontSize: 14),),
                      Text('30-12-2001',style: TextStyle(color: ThemeColors.grey700,fontWeight: FontWeight.w500,fontSize: 14),),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.red
                        ),
                        child: const Text('Onroad',style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w500),),
                      )
                    ],
                  ),
                ],
              ),
              ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextDecorationClass().heading1('Akola'),
                    Row(
                      children: [
                        RichText(
                          softWrap: true,
                          text: const TextSpan(
                            text: 'Total Reported : ',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(text: '(',style: TextStyle(color: Colors.black)),
                              TextSpan(text: '05', style: TextStyle(color: Colors.blue)),
                              TextSpan(text: ') |',style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: 'Total Unloaded : ',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(text: '(',style: TextStyle(color: Colors.black)),
                              TextSpan(text: '00', style: TextStyle(color: Colors.blue)),
                              TextSpan(text: ') |',style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            text: 'Total Onroad : ',
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(text: '(',style: TextStyle(color: Colors.black)),
                              TextSpan(text: '01', style: TextStyle(color: Colors.blue)),
                              TextSpan(text: ')',style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 17,vertical: 5),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: TextDecorationClass().blueHeading('MH20CR0007')),
                      Expanded(flex: 1, child: Text('Nagpur',style: TextStyle(color: ThemeColors.grey700,fontWeight: FontWeight.w500,fontSize: 16),)),
                      Expanded(flex: 1, child: Text('JAMUNA TRANSPORT',style: TextStyle(color: ThemeColors.grey700,fontWeight: FontWeight.w500,fontSize: 14),)),
                      Expanded(flex: 1, child: Text('30-12-2001',style: TextStyle(color: ThemeColors.grey700,fontWeight: FontWeight.w500,fontSize: 14),)),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.green
                        ),
                        child: const Text('Reported',style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w500),),
                      )
                    ],
                  ),
                  heightBox10(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: TextDecorationClass().blueHeading('MH20CR0007')),
                      Expanded(flex: 1, child: Text('Ranjangaon',style: TextStyle(color: ThemeColors.grey700,fontWeight: FontWeight.w500,fontSize: 16),)),
                      Expanded(flex: 1, child: Text('PEPSICO INDIA HOLDINGS',style: TextStyle(color: ThemeColors.grey700,fontWeight: FontWeight.w500,fontSize: 14),)),
                      Expanded(flex: 1, child: Text('30-12-2001',style: TextStyle(color: ThemeColors.grey700,fontWeight: FontWeight.w500,fontSize: 14),)),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.green
                        ),
                        child: const Text('Reported',style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w500),),
                      )
                    ],
                  ),
                ],
              ),
            ],
          );
        },),
      ),
    );
  }
}
