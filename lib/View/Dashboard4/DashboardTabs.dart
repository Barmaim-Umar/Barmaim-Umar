import 'package:flutter/material.dart';
import 'package:pfc/View/Dashboard4/Dashboard4.dart';

class DashboardTabs extends StatefulWidget {
  const DashboardTabs({Key? key}) : super(key: key);

  @override
  State<DashboardTabs> createState() => _DashboardTabsState();
}

class _DashboardTabsState extends State<DashboardTabs> with TickerProviderStateMixin{

  /// Navigation bar
  int currentPageIndex = 0;

  /// BottomNavBar
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
   Dashboard4(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final TabController _tabController = TabController(length: 3, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      //   // backgroundColor: ThemeColors.primaryColor,
      //   backgroundColor: Colors.transparent,
      //   shadowColor: Colors.transparent,
      //   title: Container(
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.circular(7)
      //     ),
      //     child: NavigationBar(
      //       backgroundColor: Colors.transparent,
      //       onDestinationSelected: (int index) {
      //         setState(() {
      //           currentPageIndex = index;
      //         });
      //       },
      //       selectedIndex: currentPageIndex,
      //       destinations: const <Widget>[
      //         NavigationDestination(
      //           icon: Icon(Icons.explore),
      //           label: 'Explore',
      //         ),
      //         NavigationDestination(
      //           icon: Icon(Icons.commute),
      //           label: 'Commute',
      //         ),
      //         NavigationDestination(
      //           selectedIcon: Icon(Icons.bookmark),
      //           icon: Icon(Icons.bookmark_border),
      //           label: 'Saved',
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body:
      Column(
        children: [
          /// NavBar
          // Container(
          //   height: 60,
          //   margin: const EdgeInsets.only(top: 5 , right: 5),
          //   decoration: BoxDecoration(
          //       // color: ThemeColors.primary,
          //       color: Colors.blue.shade800,
          //     borderRadius: BorderRadius.circular(7),
          //
          //   ),
          //   child: NavigationBar(
          //     backgroundColor: Colors.transparent,
          //
          //     onDestinationSelected: (int index) {
          //       setState(() {
          //         currentPageIndex = index;
          //       });
          //     },
          //     selectedIndex: currentPageIndex,
          //     destinations: const <Widget>[
          //       NavigationDestination(
          //         icon: Icon(Icons.explore , color: Colors.white,),
          //         label: 'Explore',
          //       ),
          //       NavigationDestination(
          //         icon: Icon(Icons.commute),
          //         label: 'Commute',
          //       ),
          //       NavigationDestination(
          //         selectedIcon: Icon(Icons.bookmark),
          //         icon: Icon(Icons.bookmark_border),
          //         label: 'Saved',
          //       ),
          //     ],
          //   ),
          // ),
          /// NavBar Pages
          // Expanded(
          //   child: <Widget>[
          //     const Dashboard4(),
          //     const Center(child: Text("Page2"),),
          //     const Center(child: Text("Page3"),),
          //   ][currentPageIndex],
          // ),

          ///========================

          /// BottomNavBar
          // Container(
          //   margin: const EdgeInsets.only(top: 10 , right: 10),
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(10),
          //     child: BottomNavigationBar(
          //       items: const <BottomNavigationBarItem>[
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.space_dashboard_outlined),
          //           label: 'Dashboard',
          //           tooltip: "",
          //         ),
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.business),
          //           label: 'Page2',
          //           tooltip: "",
          //         ),
          //         BottomNavigationBarItem(
          //           icon: Icon(Icons.school),
          //           label: 'Page3',
          //           tooltip: ""
          //         ),
          //       ],
          //       currentIndex: _selectedIndex,
          //       selectedItemColor: Colors.white,
          //       unselectedLabelStyle: const TextStyle(color: Colors.white , fontSize: 12 , ),
          //       unselectedItemColor: Colors.grey.shade400,
          //       selectedLabelStyle: const TextStyle(fontSize: 15),
          //       type: BottomNavigationBarType.fixed,
          //       onTap: _onItemTapped,
          //     ),
          //   ),
          // ),

          /// BottomNavBar Pages
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      )


    );
  }
}
