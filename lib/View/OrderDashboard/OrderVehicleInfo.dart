import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pfc/Provider/AnimationProvider.dart';
import 'package:pfc/View/OrderDashboard/OrderVehicleDetails.dart';
import 'package:pfc/View/traffic.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:provider/provider.dart';

class OrderVehicleInfo extends StatefulWidget {
  const OrderVehicleInfo({Key? key,
    this.partyName,
    this.fromCity,
    this.toCity,
    this.noOfMv,
    this.assignedMv,
    this.entryBy,
    this.orderId = '0'
  }) : super(key: key);
  final ValueNotifier<String>? partyName;
  final ValueNotifier<String>? fromCity;
  final ValueNotifier<String>? toCity;
  final ValueNotifier<String>? noOfMv;
  final ValueNotifier<String>? assignedMv;
  final ValueNotifier<String>? entryBy;
  final String orderId;
  @override
  State<OrderVehicleInfo> createState() => _OrderVehicleInfoState();
}

class _OrderVehicleInfoState extends State<OrderVehicleInfo> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String dropDownValue = 'Reported';
  List<String> list = ['Reported', 'Unload', 'Send Empty', 'Crossing', 'Diverted'];
  TextEditingController fromDateController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  late AnimationController _animationController;
  late final TabController _tabController = TabController(length: 3, vsync: this);
  int index = 0;
  List<String> cityNames = [
    "Aberdeen",
    "Abilene",
    "Akron",
    "Albany",
    "Albuquerque",
    "Alexandria",
    "Allentown",
    "Amarillo",
    "Anaheim",
    "Anchorage",
    "Ann Arbor",
    "Antioch",
    "Apple Valley",
    "Appleton",
    "Arlington",
    "Arvada",
    "Asheville",
    "Athens",
    "Atlanta",
    "Atlantic City",
    "Augusta",
    "Aurora",
    "Austin",
    "Bakersfield",
    "Baltimore",
    "Barnstable",
    "Baton Rouge",
    "Beaumont",
    "Bel Air",
    "Bellevue",
    "Berkeley",
    "Bethlehem",
    "Billings",
    "Birmingham",
    "Bloomington",
    "Boise",
    "Boise City",
    "Bonita Springs",
    "Boston",
    "Boulder",
    "Bradenton",
    "Bremerton",
    "Bridgeport",
    "Brighton",
    "Brownsville",
    "Bryan",
    "Buffalo",
    "Burbank",
    "Burlington",
    "Cambridge",
    "Canton",
    "Cape Coral",
    "Carrollton",
    "Cary",
    "Cathedral City",
    "Cedar Rapids",
    "Champaign",
    "Chandler",
    "Charleston",
    "Charlotte",
    "Chattanooga",
    "Chesapeake",
    "Chicago",
    "Chula Vista",
    "Cincinnati",
    "Clarke County",
    "Clarksville",
    "Clearwater",
    "Cleveland",
    "College Station",
    "Colorado Springs",
    "Columbia",
    "Columbus",
    "Concord",
    "Coral Springs",
    "Corona",
    "Corpus Christi",
    "Costa Mesa",
    "Dallas",
    "Daly City",
    "Danbury",
    "Davenport",
    "Davidson County",
    "Dayton",
    "Daytona Beach",
    "Deltona",
    "Denton",
    "Denver",
    "Des Moines",
    "Detroit",
    "Downey",
    "Duluth",
    "Durham",
    "El Monte",
    "El Paso",
    "Elizabeth",
    "Elk Grove",
    "Elkhart",
    "Erie",
    "Escondido",
    "Eugene",
    "Evansville",
    "Fairfield",
    "Fargo",
    "Fayetteville",
    "Fitchburg",
    "Flint",
    "Fontana",
    "Fort Collins",
    "Fort Lauderdale",
    "Fort Smith",
    "Fort Walton Beach",
    "Fort Wayne",
    "Fort Worth",
    "Frederick",
    "Fremont",
    "Fresno",
    "Fullerton",
    "Gainesville",
    "Garden Grove",
    "Garland",
    "Gastonia",
    "Gilbert",
    "Glendale",
    "Grand Prairie",
    "Grand Rapids",
    "Grayslake",
    "Green Bay",
    "GreenBay",
    "Greensboro",
    "Greenville",
    "Gulfport-Biloxi",
    "Hagerstown",
    "Hampton",
    "Harlingen",
    "Harrisburg",
    "Hartford",
    "Havre de Grace",
    "Hayward",
    "Hemet",
    "Henderson",
    "Hesperia",
    "Hialeah",
    "Hickory",
    "High Point",
    "Hollywood",
    "Honolulu",
    "Houma",
    "Houston",
    "Howell",
    "Huntington",
    "Huntington Beach",
    "Huntsville",
    "Independence",
    "Indianapolis",
    "Inglewood",
    "Irvine",
    "Irving",
    "Jackson",
    "Jacksonville",
    "Jefferson",
    "Jersey City",
    "Johnson City",
    "Joliet",
    "Kailua",
    "Kalamazoo",
    "Kaneohe",
    "Kansas City",
    "Kennewick",
    "Kenosha",
    "Killeen",
    "Kissimmee",
    "Knoxville",
    "Lacey",
    "Lafayette",
    "Lake Charles",
    "Lakeland",
    "Lakewood",
    "Lancaster",
    "Lansing",
    "Laredo",
    "Las Cruces",
    "Las Vegas",
    "Layton",
    "Leominster",
    "Lewisville",
    "Lexington",
    "Lincoln",
    "Little Rock",
    "Long Beach",
    "Lorain",
    "Los Angeles",
    "Louisville",
    "Lowell",
    "Lubbock",
    "Macon",
    "Madison",
    "Manchester",
    "Marina",
    "Marysville",
    "McAllen",
    "McHenry",
    "Medford",
    "Melbourne",
    "Memphis",
    "Merced",
    "Mesa",
    "Mesquite",
    "Miami",
    "Milwaukee",
    "Minneapolis",
    "Miramar",
    "Mission Viejo",
    "Mobile",
    "Modesto",
    "Monroe",
    "Monterey",
    "Montgomery",
    "Moreno Valley",
    "Murfreesboro",
    "Murrieta",
    "Muskegon",
    "Myrtle Beach",
    "Naperville",
    "Naples",
    "Nashua",
    "Nashville",
    "New Bedford",
    "New Haven",
    "New London",
    "New Orleans",
    "New York",
    "New York City",
    "Newark",
    "Newburgh",
    "Newport News",
    "Norfolk",
    "Normal",
    "Norman",
    "North Charleston",
    "North Las Vegas",
    "North Port",
    "Norwalk",
    "Norwich",
    "Oakland",
    "Ocala",
    "Oceanside",
    "Odessa",
    "Ogden",
    "Oklahoma City",
    "Olathe",
    "Olympia",
    "Omaha",
    "Ontario",
    "Orange",
    "Orem",
    "Orlando",
    "Overland Park",
    "Oxnard",
    "Palm Bay",
    "Palm Springs",
    "Palmdale",
    "Panama City",
    "Pasadena",
    "Paterson",
    "Pembroke Pines",
    "Pensacola",
    "Peoria",
    "Philadelphia",
    "Phoenix",
    "Pittsburgh",
    "Plano",
    "Pomona",
    "Pompano Beach",
    "Port Arthur",
    "Port Orange",
    "Port Saint Lucie",
    "Port St. Lucie",
    "Portland",
    "Portsmouth",
    "Poughkeepsie",
    "Providence",
    "Provo",
    "Pueblo",
    "Punta Gorda",
    "Racine",
    "Raleigh",
    "Rancho Cucamonga",
    "Reading",
    "Redding",
    "Reno",
    "Richland",
    "Richmond",
    "Richmond County",
    "Riverside",
    "Roanoke",
    "Rochester",
    "Rockford",
    "Roseville",
    "Round Lake Beach",
    "Sacramento",
    "Saginaw",
    "Saint Louis",
    "Saint Paul",
    "Saint Petersburg",
    "Salem",
    "Salinas",
    "Salt Lake City",
    "San Antonio",
    "San Bernardino",
    "San Buenaventura",
    "San Diego",
    "San Francisco",
    "San Jose",
    "Santa Ana",
    "Santa Barbara",
    "Santa Clara",
    "Santa Clarita",
    "Santa Cruz",
    "Santa Maria",
    "Santa Rosa",
    "Sarasota",
    "Savannah",
    "Scottsdale",
    "Scranton",
    "Seaside",
    "Seattle",
    "Sebastian",
    "Shreveport",
    "Simi Valley",
    "Sioux City",
    "Sioux Falls",
    "South Bend",
    "South Lyon",
    "Spartanburg",
    "Spokane",
    "Springdale",
    "Springfield",
    "St. Louis",
    "St. Paul",
    "St. Petersburg",
    "Stamford",
    "Sterling Heights",
    "Stockton",
    "Sunnyvale",
    "Syracuse",
    "Tacoma",
    "Tallahassee",
    "Tampa",
    "Temecula",
    "Tempe",
    "Thornton",
    "Thousand Oaks",
    "Toledo",
    "Topeka",
    "Torrance",
    "Trenton",
    "Tucson",
    "Tulsa",
    "Tuscaloosa",
    "Tyler",
    "Utica",
    "Vallejo",
    "Vancouver",
    "Vero Beach",
    "Victorville",
    "Virginia Beach",
    "Visalia",
    "Waco",
    "Warren",
    "Washington",
    "Waterbury",
    "Waterloo",
    "West Covina",
    "West Valley City",
    "Westminster",
    "Wichita",
    "Wilmington",
    "Winston",
    "Winter Haven",
    "Worcester",
    "Yakima",
    "Yonkers",
    "York",
    "Youngstown"
  ];
  bool isExpanded = false;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animationController.repeat(reverse: true);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize =  MediaQuery.of(context).size;
    return Responsive(

        /// Mobile
        mobile: Container(),

        /// Tablet
        tablet: const Text("Tablet"),

        /// Desktop
        desktop: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),  boxShadow: [
                  BoxShadow(color: Colors.grey.shade300 , blurRadius: 5.0 , spreadRadius: 3),
                ]),
                padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                margin: const EdgeInsets.only(bottom: 1, top: 5),
                // color: Colors.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Top Indicators
                    Wrap(
                      children: [
                        // Late Delivery
                        Consumer<ButtonProvider>(
                          builder: (context, buttonProvider, child) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const   Traffic(),));
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                // transform: buttonProvider.isJumping ? Matrix4.translationValues(00, -5, 00) : Matrix4.translationValues(00, 00, 00),
                                child: FormWidgets().containerWidget('Late Delivery', '20', ThemeColors.primaryColor),
                              ),
                            );
                          },
                        ),

                        // Late Loading
                        Consumer<ButtonProvider>(
                          builder: (context, buttonProvider, child) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const   Traffic(),));
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                // transform: buttonProvider.isJumping ? Matrix4.translationValues(00, 0, 00) : Matrix4.translationValues(00, -5, 00),
                                child: FormWidgets().containerWidget('Late Loading', '20', ThemeColors.primaryColor),
                              ),
                            );
                          },
                        ),

                        // Pending LR
                        Consumer<ButtonProvider>(
                          builder: (context, buttonProvider, child) {
                            return GestureDetector(
                              // onTap:() => buttonProvider.startJumping(),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const   Traffic(),));
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  // transform: buttonProvider.isJumping ? Matrix4.translationValues(00, -5, 00) : Matrix4.translationValues(00, 00, 00),
                                  child: FormWidgets().containerWidget('Pending LR', '20', ThemeColors.primaryColor),
                                ),
                              ),
                            );
                          },
                        ),

                        // Vehicle Without Driver
                        InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const   Traffic(),));
                            },
                            child: FormWidgets().containerWidget('Vehicle Without Driver', '98', ThemeColors.primaryColor)),

                        // Vehicle in Maintenance
                        InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const   Traffic(),));
                            },
                            child: FormWidgets().containerWidget('Vehicle in Maintenance', '98', ThemeColors.primaryColor)),

                        // Major Issue
                        Consumer<ButtonProvider>(
                          builder: (context, buttonProvider, child) {
                            return GestureDetector(
                              // onTap:() => buttonProvider.startJumping(),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const   Traffic(),));
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  // transform: buttonProvider.isJumping ? Matrix4.translationValues(00, 0, 00) : Matrix4.translationValues(00, -5, 00),
                                  child: FormWidgets().containerWidget('Major Issue', '20', ThemeColors.darkRedColor),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    /// driver and vehicle info
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child: Column(
                        children: [
                          /// Driver Information
                          Row(
                            children: [
                              // driver image
                              const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 25,
                                backgroundImage: AssetImage(
                                  "assets/person.jpg",
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              // Driver Name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Shaikh Saeed',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Mob No: ',
                                        style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        '9683354091',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Guarantor Name: ',
                                        style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        'Md Kashif',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),

                              const Icon(Icons.more_vert),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // VehicleDetails
                          OrderVehicleDetails(
                              partyName: widget.partyName,
                              fromCity: widget.fromCity,
                              toCity: widget.toCity,
                              noOfMv: widget.noOfMv,
                              assignedMv: widget.assignedMv,
                              entryBy:  widget.entryBy,
                              orderId: widget.orderId,
                          ),

                          /// Routes | Driver Statistics
                          // Expanded(
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       const Expanded(child: Routes()),
                          //       Container(
                          //         height: double.infinity,
                          //         width: 1,
                          //         color: Colors.grey.shade400,
                          //       ),
                          //       const Expanded(child: AdvanceReport()),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 5,),

              Container(
                height:MediaQuery.of(context).size.height/2.24,
                width: double.maxFinite,
                decoration:  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child:  /// tabBar || tabBarView
                Column(
                  children: [
                    /// TabBar
                    SizedBox(
                      child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          onTap: (value) {
                            setState(() {
                              index = value;
                            });
                          },
                          indicatorWeight: 0.0,
                          indicator: BoxDecoration(
                              color: index == 0
                                  ? ThemeColors.darkRedColor
                                  : index == 1
                                  ? Colors.black
                                  : Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          tabs: const [
                            Tab(
                              child: Text("Empty Vehicles"),
                            ),
                            Tab(
                              child: Text("On Road Vehicles"),
                            ),
                            Tab(
                              child: Text("Reported Vehicles"),
                            ),
                          ]),
                    ),

                    ///TabBarView
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [
                        /// 1
                        MasonryGridView.builder(
                          itemCount: cityNames.length - 380,
                          gridDelegate:  SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount:  screenSize.width <= 1000 && screenSize.width >= 825 ? 3 : screenSize.width <= 825 ? 2 : 4),
                          itemBuilder: (context, index) =>
                              Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: UiDecoration().inTransit('${cityNames[index]}  ${index+Random().nextInt(9)}',"Empty Vehicle" , UiDecoration().inTransitReported())),
                        ),

                        /// 2
                        MasonryGridView.builder(
                          itemCount: cityNames.length - 380,
                          gridDelegate:  SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount:  screenSize.width <= 1000 && screenSize.width >= 825 ? 3 : screenSize.width <= 825 ? 2 : 4),
                          itemBuilder: (context, index) =>
                              Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: UiDecoration().inTransit('${cityNames[index]}  $index' ,"On Road Vehicle", UiDecoration().inTransitReported())),
                        ),

                        /// 3
                        MasonryGridView.builder(
                          itemCount: cityNames.length - 380,
                          gridDelegate:  SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount:  screenSize.width <= 1000 && screenSize.width >= 825 ? 3 : screenSize.width <= 825 ? 2 : 4),
                          itemBuilder: (context, index) =>
                              Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: ListTileTheme(
                                      dense: true,
                                      child: ExpansionTile(
                                        initiallyExpanded: isExpanded,
                                        backgroundColor: const Color(0xff337ab7),
                                        collapsedBackgroundColor: const Color(0xff337ab7),
                                        collapsedTextColor: Colors.white,
                                        collapsedIconColor: Colors.white,
                                        textColor: Colors.white,
                                        iconColor: Colors.white,
                                        childrenPadding: const EdgeInsets.all(0),
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: Text('${cityNames[index]}  $index',style: const TextStyle(fontWeight: FontWeight.w500,),
                                              overflow: TextOverflow.ellipsis,)),
                                            // Row(
                                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            //   children: [
                                            //     inTransitCircle(0xff4fafee),
                                            //     const SizedBox(width: 5,),
                                            //     inTransitCircle(0xff22a948),
                                            //     const SizedBox(width: 5,),
                                            //     inTransitCircle(0xffff0707),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                        children: [
                                          // OnRoad
                                          ListView.builder(
                                            itemCount: 5,
                                            controller: _scrollController,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    // margin: const EdgeInsets.only(top: 1),
                                                    color: Colors.blue.shade300,
                                                    width: double.infinity,
                                                    alignment: Alignment.center,
                                                    height: 40,
                                                    child: const Text('MH18BG2389 <-- Hosur' , style: TextStyle(color: Colors.white),),
                                                  ),
                                                ),
                                                const Divider( height: 0, color: Colors.white, )
                                              ],
                                            );

                                            },)
                                        ],
                                      ),
                                    ),
                                  ),
                                  // UiDecoration().inTransit('${cityNames[index]}  $index' ,"Reported Vehicle", UiDecoration().inTransitReported())
                              ),
                        ),
                      ]),
                    ),
                  ],
                ),
                ),


              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: const [
              //     Expanded(child: Routes()),
              //     ///asd
              //      SizedBox(width: 5,),
              //     // Container(
              //     //   height: double.infinity,
              //     //   width: 1,
              //     //   color: Colors.grey.shade400,
              //     // ),
              //     Expanded(child: AdvanceReport()),
              //   ],
              // )
            ],
          ),
        ));
  }

  Widget info(String title, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade300, fontWeight: FontWeight.w500),
        ),
        Text(
          info,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }
}
