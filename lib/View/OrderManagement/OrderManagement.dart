import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pfc/View/VehicleManage/VehicleDocuments/VehicleDocument.dart';
import 'package:pfc/View/VehicleManage/NewDriver/DriverDetails.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({Key? key}) : super(key: key);

  @override
  State<OrderManagement> createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  final DataTableSource _data = MyData();
  int page = 0;

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(2010, 5 , 9),
      ChartData(2011, 18 , 22),
      ChartData(2012, 94 , 15),
      ChartData(2013, 12 , 31),
      ChartData(2014, 60 , 53),
      ChartData(2015, 12 , 23),
      ChartData(2016, 70 , 53),
      ChartData(2017, 87 , 13),
      ChartData(2018, 40 , 13),
      ChartData(2019, 90 , 53),

    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10,),

             Row(children: const [
              Icon(Icons.list, color: Colors.grey, size: 30),  SizedBox(width: 10,),
              Text("Orders Management" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),)
            ],) ,

            const SizedBox(height: 10,),

            /// Buttons
            SizedBox(
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // page=0;
                          });
                        },
                        style: ButtonStyles.dashboardButton(page == 0),
                        child: const Text("Home" ,style: TextStyle(color: Colors.white),)
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // page=1;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverDetails(),));
                          });
                        },
                        style: ButtonStyles.dashboardButton(page == 1),
                        child: Text("New Order" ,style: TextDecorationClass().dashboardBtn(),)
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // page=2;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const VehicleDocument(),));
                          });
                        },
                        style: ButtonStyles.dashboardButton(page == 2),
                        child: Text("Order Details" ,style: TextDecorationClass().dashboardBtn(),)
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10,),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height:5,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        /// Clients
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
                            decoration: UiDecoration().dashboardBox(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Heading
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  [
                                    const Text("Clients" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Image.asset("assets/external.png" , height: 32, color: Colors.grey,)),
                                    )
                                  ],
                                ),
                                const Divider(height: 10,),
                                const SizedBox(height: 10,),
                                /// Company Name & profit
                                UiDecoration().linerGraph("Aqua Plast", "60.34", 0.6),
                                const SizedBox(height: 20,),
                                UiDecoration().linerGraph("Jamuna Transport", "30.34", 0.3),
                                const SizedBox(height: 20,),
                                UiDecoration().linerGraph("T & D Galiakot Containers", "90.34", 0.9),
                                const SizedBox(height: 20,),
                                UiDecoration().linerGraph("Contact Comfort", "15.34", 0.15),
                                const SizedBox(height: 20,),
                                UiDecoration().linerGraph("Balaji Chips", "68.34", 0.68),
                                const SizedBox(height: 20,),
                                UiDecoration().linerGraph("Floatex solar Pvt.Ltd", "50.34", 0.5),
                                const SizedBox(height: 20,),
                                UiDecoration().linerGraph("United Breweries Ltd", "71.34", 0.71),
                                const SizedBox(height: 20,),
                                UiDecoration().linerGraph("Ashoka P.U. Foam", "40.34", 0.4),
                                const SizedBox(height: 20,),
                                UiDecoration().linerGraph("Aqua Plast", "60.34", 0.6),
                                const SizedBox(height: 20,),
                                UiDecoration().linerGraph("Jamuna Transport", "30.34", 0.3),
                                const SizedBox(height: 20,),
                                UiDecoration().linerGraph("T & D Galiakot Containers", "90.34", 0.9),
                                const SizedBox(height: 20,),
                                UiDecoration().linerGraph("Contact Comfort", "15.34", 0.15),
                                const SizedBox(height: 20,),
                                UiDecoration().linerGraph("Balaji Chips", "68.34", 0.68),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 10,),

                        Expanded(
                          flex: 11,
                          child: Column(
                            children: [

                              Row(
                                children: [
                                  /// Cards & Sales Update
                                  Expanded(
                                    flex: 8,
                                    child: Column(
                                      children: [
                                        /// Cards
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            UiDecoration().orderCards(
                                              Colors.green.shade100,
                                              Colors.green,
                                              "649",
                                              const Icon(Icons.arrow_upward , color: Colors.green , size: 15,),
                                              const Icon(Icons.delivery_dining, color: Colors.green, size: 30,),
                                              "Orders \nCompleted",
                                              "+24.4%",
                                            ),

                                            UiDecoration().orderCards(
                                              Colors.orange.shade100,
                                              Colors.orange,
                                              "12",
                                              Icon(Icons.arrow_downward , color: Colors.red.shade600 , size: 15,),
                                              const Icon(Icons.refresh, color: Colors.orange, size: 30,),
                                              "Refund \nRequest",
                                              "+2.7%",
                                            ),

                                            UiDecoration().orderCards(
                                              Colors.red.shade100,
                                              Colors.red,
                                              "45",
                                              Icon(Icons.arrow_upward , color: Colors.green.shade600 , size: 15,),
                                              const Icon(Icons.cancel_outlined, color: Colors.red, size: 30,),
                                              "Orders \nCancelled",
                                              "-1.9%",
                                            ),

                                          ],
                                        ),

                                        const SizedBox(height: 10,),

                                        /// Sales Update
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 20),
                                          decoration: UiDecoration().dashboardBox(),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              /// Sales Update
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children:  [
                                                    const Text("Sales Update" , style:  TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),),
                                                    const Divider(),
                                                    const SizedBox(height: 30,),

                                                    /// Revenue
                                                    UiDecoration().salesUpdate(const Color(0xff3e79db), "Revenue", "23.4%", "\$43,540.45"),
                                                    const SizedBox(width: 200,child: Divider(height: 30,)),
                                                    UiDecoration().salesUpdate(const Color(0xff19e2e2), "Orders", "15.7%", "539"),

                                                  ],
                                                ),
                                              ),

                                              /// Graph
                                              Expanded(
                                                flex: 3,
                                                child: SizedBox(
                                                  height: 280,
                                                  child:
                                                  SfCartesianChart(
                                                      series: <ChartSeries>[
                                                        // Renders line chart
                                                        StackedLineSeries<ChartData, int>(
                                                          color: Colors.green,
                                                            dataSource: chartData,
                                                            xValueMapper: (ChartData data, _) => data.x,
                                                            yValueMapper: (ChartData data, _) => data.y
                                                        ),
                                                        StackedLineSeries<ChartData, int>(
                                                          color: Colors.blue,
                                                            dataSource: chartData,
                                                            xValueMapper: (ChartData data, _) => data.x,
                                                            yValueMapper: (ChartData data, _) => data.y2
                                                        ),
                                                      ]
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 10,),

                                  /// Visitors
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
                                        decoration: UiDecoration().dashboardBox(),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: const [
                                                Text("Visitors" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),),
                                                Icon(Icons.more_horiz , color: Colors.grey,)
                                              ],
                                            ),
                                            const Divider(),
                                            const SizedBox(height: 10,),
                                            Row(
                                              children: const [
                                                Text("51,246", style: TextStyle(fontSize: 30 , fontWeight: FontWeight.bold),),
                                                SizedBox(width: 15,),
                                                Text("4.4%", style: TextStyle(color: Colors.green),),
                                                Icon(Icons.arrow_upward, color: Colors.green, size: 15,)

                                              ],
                                            ),
                                            SizedBox(
                                              height: 315,
                                              child:
                                              SfCartesianChart(
                                                  series: <ChartSeries>[
                                                    // Renders line chart
                                                    StackedLineSeries<ChartData, int>(
                                                      color:  Colors.orange,
                                                        dataSource: chartData,
                                                        xValueMapper: (ChartData data, _) => data.x,
                                                        yValueMapper: (ChartData data, _) => data.y
                                                    ),
                                                    StackedLineSeries<ChartData, int>(
                                                      color: Colors.blue,
                                                        dataSource: chartData,
                                                        xValueMapper: (ChartData data, _) => data.x,
                                                        yValueMapper: (ChartData data, _) => data.y2
                                                    ),
                                                  ]
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              ),

                              const SizedBox(height: 10,),

                              /// Table
                              // Container(
                              //   padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
                              //   width: double.infinity,
                              //   height: 290,
                              //   decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     borderRadius: BorderRadius.circular(5),
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: Colors.grey.shade300,
                              //         spreadRadius: .5,
                              //         blurRadius: 3
                              //       )
                              //     ]
                              //   ),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children:  [
                              //     const Text("Order Details" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),),
                              //       const Divider(),
                              //       SingleChildScrollView(
                              //           child: Column(
                              //             children: [
                              //               /// Table Header
                              //               Container(
                              //                 padding: const EdgeInsets.symmetric(vertical: 5),
                              //                 decoration: const BoxDecoration(
                              //                   color: Color(0xffe1e0e0),
                              //                 ),
                              //                 child: Row(
                              //                   children: [
                              //                     Expanded(child: Text("Order ID" , style:tableHeader(),)),
                              //                     Expanded(child: Text("Customer" , style:tableHeader(),)),
                              //                     Expanded(child: Text("Date" , style:tableHeader(),)),
                              //                     Expanded(child: Text("Status" , style:tableHeader(),)),
                              //                     Expanded(child: Text("Order Total" , style:tableHeader(),)),
                              //                   ],
                              //                 ),
                              //               ),
                              //               ListView(
                              //                 shrinkWrap: true,
                              //                 children: [
                              //                   Container(
                              //                     decoration: BoxDecoration(
                              //
                              //                     ),
                              //                     child: Row(
                              //                       children: [
                              //                         Expanded(child: Text("Order ID" , style:tableValues(),)),
                              //                         Expanded(child: Text("Customer" , style:tableValues(),)),
                              //                         Expanded(child: Text("Date" , style:tableValues(),)),
                              //                         Expanded(child: Text("Status" , style:tableValues(),)),
                              //                         Expanded(child: Text("Order Total" , style:tableValues(),)),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 ],
                              //               )
                              //             ],
                              //           )
                              //       )
                              //     ],
                              //   ),
                              // )

                              Container(
                                height: 300,
                                decoration: UiDecoration().dashboardBox(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 10 , left: 10),
                                      alignment: Alignment.centerLeft,
                                      child:
                                      // TextDecoration().formTitle('Ledger List'),
                                      TextDecorationClass().heading('Order Details'),
                                    ),
                                    const Divider(height: 5,),

                                    Expanded(
                                        child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ScrollConfiguration(
                                                  behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                                                  child: SizedBox(
                                                    width: double.maxFinite,
                                                    child: PaginatedDataTable(
                                                      columns: const [
                                                        DataColumn(label: Text('Order ID')),
                                                        DataColumn(label: Text('Customer')),
                                                        DataColumn(label: Text('Date'),),
                                                        DataColumn(label: Text('Status'),),
                                                        DataColumn(label: Text('Order Total'),),
                                                        DataColumn(label: Text('Action'),),
                                                      ],
                                                      source: _data,

                                                      // header: const Center(
                                                      //   child: Text('My Products'),
                                                      // ),
                                                      showCheckboxColumn: false,
                                                      columnSpacing: 90,
                                                      horizontalMargin: 10,
                                                      rowsPerPage: 5,
                                                      showFirstLastButtons: true,
                                                      sortAscending: true,
                                                      sortColumnIndex: 0,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ))),
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ) 
          ],
        ),
      )
    );
  }

  TextStyle tableHeader(){
    return  const TextStyle(fontWeight: FontWeight.w500);
  }

  TextStyle tableValues(){
    return  const TextStyle(color: Colors.grey);
  }

  /// DataTable

  ledgerList(){
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10 , left: 10),
            alignment: Alignment.centerLeft,
            child:
            // TextDecoration().formTitle('Ledger List'),
            TextDecorationClass().heading('Vehicle List'),
          ),
          const Divider(),

          const SizedBox(height: 10,),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
                        child: PaginatedDataTable(
                          columns: const [
                            DataColumn(label: Text('Vehicle Number')),
                            DataColumn(label: Text('Info Title')),
                            DataColumn(label: Text('Number'),),
                            DataColumn(label: Text('From Date'),),
                            DataColumn(label: Text('Expiry Date'),),
                            DataColumn(label: Text('Action'),),
                          ],
                          source: _data,

                          // header: const Center(
                          //   child: Text('My Products'),
                          // ),
                          showCheckboxColumn: false,
                          columnSpacing: 90,
                          horizontalMargin: 10,
                          rowsPerPage: 5,
                          showFirstLastButtons: true,
                          sortAscending: true,
                          sortColumnIndex: 0,
                        ),
                      )
                    ],
                  ))),
        ],
      ),
    );
  }

}

class ChartData {
  ChartData(this.x, this.y, this.y2);
  final int x;
  final double y;
  final double y2;
}

/// DataTable
class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data = List.generate(200, (index) => {
    "vehicle_number": index,
    "info_title": "Item $index",
    "number": Random().nextInt(10000),
    "from_date": Random().nextInt(10000),
    "expiry_date": Random().nextInt(10000),
  });

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text(_data[index]['vehicle_number'].toString())),
        DataCell(Text(_data[index]['info_title'].toString())),
        DataCell(Text(_data[index]['number'].toString())),
        DataCell(Text(_data[index]['from_date'].toString())),
        DataCell(Text(_data[index]['expiry_date'].toString())),
        DataCell(Row(
          children: [
            // edit Icon
            Container(
                height: 20,
                width:20,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.edit, size: 15, color: Colors.white,))),
            // delete Icon
            Container(
                height: 20,
                width: 20,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(color: ThemeColors.darkRedColor, borderRadius: BorderRadius.circular(5)),
                child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {}, icon: const Icon(Icons.delete, size: 15, color: Colors.white,))),

          ],
        )),
      ],
      onSelectChanged: (value) {},
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _data.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}