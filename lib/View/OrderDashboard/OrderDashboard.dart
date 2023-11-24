import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/Provider/AnimationProvider.dart';
import 'package:pfc/Provider/ProviderOfFragment.dart';
import 'package:pfc/View/OrderDashboard/OrderVehicleInfo.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/service_wrapper/service_wrapper.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
class OrderDashboard extends StatefulWidget {
  const OrderDashboard({Key? key}) : super(key: key);

  @override
  State<OrderDashboard> createState() => _OrderDashboardState();
}

class _OrderDashboardState extends State<OrderDashboard> with TickerProviderStateMixin{
  late AnimationController _animationController;
  int iIndex = 0;
  late final TabController _tabController = TabController(length: 2, vsync: this, initialIndex: iIndex);
  List<String> companyNamesList = [
    "Aqua Plast",
    "Jamuna Transport",
    "T & D GALIAKOT CONTAINERS",
    "Aadi Foam",
    "CONTACT COMFORT",
    "Floatex solar Pvt.Ltd",
    "T & D GALIAKOT CONTAINERS",
    "UNITED BREWERIES LTD",
    "ASHOKA P.U. FOAM",
    "Acme Corporation",
    "Globex Corporation",
    "Soylent Corp",
    "Initech",
    "Bluth Company",
    "Umbrella Corporation",
    "Hooli",
    "Vehement Capital Partners",
    "Massive Dynamic",
    "Wonka Industries",
    "Stark Industries",
    "Gekko & Co",
    "Wayne Enterprises",
    "Bluth Company",
    "Bluth Company",
    "Bluth Company",
    "Bluth Company",
    "Bluth Company",
    "Bluth Company",
    "Bluth Company",
    "Bluth Company",
  ];
  List<String> cityNamesList = [
    'Ahmedabad ',
    'Amreli district',
    'Anand',
    'Banaskantha',
    'Bharuch',
    'Bhavnagar',
    'Dahod',
    'The Dangs',
    'Gandhinagar',
    'Jamnagar',
    'Junagadh',
    'Kutch',
    'Kheda',
    'Mehsana',
    'Narmada',
    'Navsari',
    'Patan',
    'Panchmahal',
    'Porbandar',
    'Rajkot',
    'Sabarkantha',
    'Surendranagar',
    'Surat',
    'Vyara',
    'Vadodara',
    'Valsad',
    'Porbandar',
    'Rajkot',
    'Sabarkantha',
    'Surendranagar',
    'Surat',
    'Vyara',
    'Vadodara',
    'Valsad',
    'Porbandar',
    'Rajkot',
    'Sabarkantha',
    'Surendranagar',
    'Surat',
    'Vyara',
    'Vadodara',
    'Valsad',
  ];
  late ButtonProvider _buttonProvider;
  FragmentsNotifier changeFragmentVariable = FragmentsNotifier();
  List ordersList = [];
  int freshLoad1 = 0;
  int limit = 30;
  int page = 1;
  String keyword = '';
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  ValueNotifier<String> partyName = ValueNotifier<String>("");
  ValueNotifier<String> fromCity = ValueNotifier<String>("");
  ValueNotifier<String> toCity = ValueNotifier<String>("");
  ValueNotifier<String> noOfMv = ValueNotifier<String>("");
  ValueNotifier<String> assignedMv = ValueNotifier<String>("");
  ValueNotifier<String> entryBy = ValueNotifier<String>("");
  String orderId = '';
  ValueNotifier<int> isSelected = ValueNotifier(-1);
  int currentIndex = 0;

  /// APIs
  getOrdersApiFunc(){
    setStateMounted(() => {freshLoad1 = 1, page = 1});
    ServiceWrapper().getOrdersApi(
        limit: '$limit',
        page: '$page',
        keyword: searchController.text,
        fromDate: '',
        toDate: '').then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        ordersList.clear();
        ordersList.addAll(info['data']);
        setStateMounted(() => freshLoad1 = 0);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() => freshLoad1 = 0);
      }
    });
  }

  // calling when user scrolls to the end of the list
  getMoreOrders(){
    if(!isLoading){
      setStateMounted(() => isLoading = true);
    }
    ServiceWrapper().getOrdersApi(
        limit: '$limit',
        page: '$page',
        keyword: searchController.text,
        fromDate: '',
        toDate: '').then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        ordersList.addAll(info['data']);
        setStateMounted(() => {freshLoad1 = 0, isLoading = false});
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
        setStateMounted(() => {freshLoad1 = 0, isLoading = false});
      }
    });
  }

  @override
  void initState() {
    getOrdersApiFunc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buttonProvider = Provider.of<ButtonProvider>(context, listen: false);
      _buttonProvider.startJumping();
    });

    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        page++;
        getMoreOrders();
      }
    });
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    _tabController.dispose();
    // _buttonProvider.stopJumping();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FragmentsNotifier changeFragmentVariable = Provider.of<FragmentsNotifier>(context, listen: false);
    return
      Consumer(builder: (context, fragmentsNotifier, child) {
        return  Scaffold(
          body: Responsive(

            /// Mobile
            mobile: Container(),

            /// Tablet
            tablet: Container(),

            /// Desktop
            desktop:Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 1,),

                  /// Dashboard
                  Expanded(
                    child: Container(
                      // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// left panel
                          Expanded(
                              flex: 2,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 0 , top: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),  boxShadow: [
                                  BoxShadow(color: ThemeColors.boxShadow , blurRadius: 5.0 , spreadRadius: 3),
                                ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: TabBar(
                                          onTap: (value) {
                                            setState(() {
                                              iIndex = value;
                                            });
                                          },
                                          indicator: BoxDecoration(color: iIndex == 0 ? ThemeColors.darkBlueColor : ThemeColors.darkBlueColor, borderRadius: BorderRadius.circular(10)),
                                          controller: _tabController,
                                          labelColor: Colors.white,
                                          unselectedLabelColor: Colors.grey,
                                          tabs: const [
                                            Tab(child: Text('Order List'),),
                                            Tab(child: Text('Assign Vehicle'),),
                                          ]),
                                    ),
                                    // Search
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2, bottom: 2 , left: 2),
                                      child: TextFormField(
                                        controller: searchController,
                                        onChanged: (value) {
                                          if(_tabController.index == 0){
                                            getOrdersApiFunc();
                                          }

                                        },
                                        style: const TextStyle(fontSize: 15),
                                        decoration: UiDecoration().outlineTextFieldDecoration("Search",Colors.grey,
                                            icon:  const Icon(CupertinoIcons.search,color: Colors.grey,)),
                                      ),
                                    ),

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: TabBarView(controller: _tabController, children: [
                                          // Order List Tab
                                          ListView.builder(
                                            controller: _scrollController,
                                            shrinkWrap: true,
                                            itemCount: ordersList.length + 1, // Add one for the loading indicator,
                                            itemBuilder: (context, index) {
                                              if(index < ordersList.length){
                                                return ValueListenableBuilder(
                                                  valueListenable: isSelected,
                                                  builder: (context, value, child) {
                                                    return Container(
                                                      margin: const EdgeInsets.only(top: 5, bottom: 5, right: 2),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: value == index  ? ThemeColors.primary : Colors.grey.shade300
                                                          ),
                                                          borderRadius: BorderRadius.circular(10)
                                                      ),
                                                      child: ListTile(
                                                        onTap: () {
                                                          partyName.value = ordersList[index]['ledger_title'].toString();
                                                          fromCity.value = ordersList[index]['from_location'].toString();
                                                          toCity.value = ordersList[index]['to_location'].toString();
                                                          noOfMv.value = ordersList[index]['no_of_vehicles'].toString();
                                                          assignedMv.value = ordersList[index]['assigned_vehicles'].toString();
                                                          entryBy.value = ordersList[index]['entry_by'].toString();
                                                          orderId = ordersList[index]['order_id'].toString();
                                                          currentIndex = index;
                                                          isSelected.value = index;
                                                          print(currentIndex);
                                                        },
                                                        mouseCursor: SystemMouseCursors.click,
                                                        style: ListTileStyle.drawer,
                                                        title: const Text(
                                                          'Party Name',
                                                          style:  TextStyle(color: Colors.black),
                                                        ),
                                                        subtitle: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    ordersList[index]['ledger_title'] ?? "Gahana Ram_null",
                                                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    ordersList[index]['to_location'] ?? "Pune _null",
                                                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),textAlign: TextAlign.end,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    "Order Date: ${ordersList[index]['order_date'] ?? "30-12-2022"}",
                                                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ),

                                                                Expanded(
                                                                  child: Text(
                                                                    "Entry By: ${ordersList[index]['entry_by'] ?? "Adil _null"}",
                                                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        trailing: const Icon(
                                                          Icons.arrow_right_sharp,
                                                          color: ThemeColors.darkBlack,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                );
                                              }else{
                                                if(isLoading){
                                                  return const SizedBox(
                                                    height: 40,
                                                    child: Center(
                                                      child: CircularProgressIndicator(strokeWidth: 2,),
                                                    ),
                                                  );
                                                } else{
                                                  return const SizedBox();
                                                }
                                              }
                                            },
                                          ),

                                          // Assign Vehicle Tab
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 20,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LRCreate(),)),
                                                onTap: () {
                                                  setState(() {
                                                    SidebarXController(selectedIndex: 1);
                                                    changeFragmentVariable.changeFragmentVariable(1);
                                                    debugPrint("aaa");
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(top: 5, bottom: 5, right: 2),
                                                  decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(10)),
                                                  child: ListTile(
                                                    mouseCursor: SystemMouseCursors.click,
                                                    // Vehicle Number
                                                    title: Text('MH20${Random().nextInt(90342)}',
                                                      style: const TextStyle(color: Colors.black),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Company Name
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            // Company Name
                                                            Expanded(
                                                              flex: 3,
                                                              child: Text(companyNamesList[index],
                                                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        // from city to city
                                                        Row(
                                                          children: [
                                                            Text(cityNamesList[index],
                                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold , overflow: TextOverflow.ellipsis),textAlign: TextAlign.end,
                                                            ),
                                                            const SizedBox(width: 2,),
                                                            const Icon(CupertinoIcons.arrow_right , size: 15,),
                                                            const SizedBox(width: 2,),
                                                            Expanded(
                                                              child: Text(cityNamesList[index],
                                                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold , overflow: TextOverflow.ellipsis),textAlign: TextAlign.start
                                                                ,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        // Assign Date and LR Number
                                                        const Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            // Assign Date
                                                            Expanded(
                                                              child: Text(
                                                                "Assign Date: 20-12-2022",
                                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                                              ),
                                                            ),
                                                            // LR Number
                                                            Expanded(
                                                              child: Text(
                                                                "LR No: 8587365",
                                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: const Icon(
                                                      Icons.arrow_right_sharp,
                                                      color: ThemeColors.darkBlack,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              )),

                          const SizedBox(width: 5,),

                          /// right panel
                          Expanded(flex: 7, child: OrderVehicleInfo(
                            partyName: partyName,
                            fromCity: fromCity,
                            toCity: toCity,
                            noOfMv: noOfMv,
                            assignedMv: assignedMv,
                            entryBy: entryBy,
                            orderId: orderId,
                          )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
  }

  setStateMounted(VoidCallback fn){
    if(mounted){
      setState(fn);
    }
  }
}
