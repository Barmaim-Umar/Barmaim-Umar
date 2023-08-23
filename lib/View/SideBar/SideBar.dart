import 'package:flutter/material.dart';
import 'package:pfc/View/AccountsReports/AccountsReport.dart';
import 'package:pfc/View/AdminReports/AdminReports.dart';
import 'package:pfc/View/AllForms/TripManagement/TripManagementDashboard.dart';
import 'package:pfc/View/Automation/Automation.dart';
import 'package:pfc/View/Dashboard/Dashboard.dart';
import 'package:pfc/View/LRReports/LRReport.dart';
import 'package:pfc/View/Logout/Logout.dart';
import 'package:pfc/View/Master/MasterDashboard.dart';
import 'package:pfc/View/AllForms/AllForms.dart';
import 'package:pfc/View/BillingDashboard/BillingDashboard.dart';
import 'package:pfc/View/Dashboard4/DashboardTabs.dart';
import 'package:pfc/View/FilePicker.dart';
import 'package:pfc/View/Accounts.dart';
import 'package:pfc/View/OTBillingDashboard/OTBillingDashboard.dart';
import 'package:pfc/View/PaymentDashboard/PaymentDashboard.dart';
import 'package:pfc/View/Settings/Settings.dart';
import 'package:pfc/View/TrafficReports/TrafficReportsDashboard.dart';
import 'package:pfc/View/TripSettle/TripSettle.dart';
import 'package:pfc/View/VehicleManage/NewDriver/DriverDetails.dart';
import 'package:pfc/View/OrderDashboard/OrderDashboard.dart';
import 'package:pfc/View/OrderManagement/OrderManagement.dart';
import 'package:pfc/View/OutdoorVehicle/OutdoorVehicle.dart';
import 'package:pfc/View/ReportDashboard/ReportDashboard.dart';
import 'package:pfc/View/TrafficDashboard/TrafficDashboard.dart';
import 'package:pfc/View/VehicleManage/VehicleDashboard/VehicleDashboard.dart';
import 'package:pfc/View/VehicleManage/VehicleManage.dart';
import 'package:pfc/View/VehicleManagement/VehicleManagement.dart';
import 'package:pfc/View/VoucherDashboard/VoucherDashboard.dart';
import 'package:pfc/View/Vouchers/Vouchers.dart';
import 'package:pfc/View/camera/cam.dart';
import 'package:pfc/View/traffic.dart';
import 'package:pfc/temp.dart';
import 'package:sidebarx/sidebarx.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final _controller = SidebarXController(selectedIndex: 0, extended: false);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pushpak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: canvasColor,
                    title: Text(_getTitleByIndex(_controller.selectedIndex)),
                    leading: IconButton(
                      onPressed: () {
                        // if (!Platform.isAndroid && !Platform.isIOS) {
                        //   _controller.setExtended(true);
                        // }
                        _key.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  )
                : null,
            drawer: ExampleSidebarX(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) ExampleSidebarX(controller: _controller),
                Expanded(
                  child: Center(
                    child: _ScreensExample(
                      controller: _controller,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        // hoverColor: scaffoldBackgroundColor,
        hoverColor: accentCanvasColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 220,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          // height: 200,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/pushpaklogo.png',
            ),
          ),
        );
      },
      items: [
        // 1
        const SidebarXItem(
            label:'Dashboard',
          iconWidget: Tooltip(
              message: "Dashboard",
              child: Icon(Icons.dashboard , color: Colors.white,))
        ),

        // 2
        const SidebarXItem(
            label:'Traffic Dashboard',
          iconWidget: Tooltip(
              message: "Traffic Dashboard",
              child: Icon(Icons.traffic_outlined , color: Colors.white,))
        ),

        // 3
        const SidebarXItem(
            label:'Order Dashboard',
          iconWidget: Tooltip(
              message: "Order Dashboard",
              child: Icon(Icons.bookmark , color: Colors.white,))
        ),

        // 4
        const SidebarXItem(
            label:'Traffic Reports',
          iconWidget: Tooltip(
              message: "Traffic Report",
              child: Icon(Icons.traffic , color: Colors.white,))
        ),

        // 5
        const SidebarXItem(
            label:'LR Reports',
            iconWidget: Tooltip(
                message: "LR Reports",
                child: Icon(Icons.edit_note_rounded , color: Colors.white,))
        ),

        // 6
        const SidebarXItem(
            label:'Vouchers',
          iconWidget: Tooltip(
              message: "Vouchers",
              child: Icon(Icons.currency_rupee , color: Colors.white,))
        ),

        // 7
        const SidebarXItem(
            label:'Outdoor Vehicle',
            iconWidget: Tooltip(
                message: "Outdoor Vehicle",
                child: Icon(Icons.car_repair , color: Colors.white,))
        ),

        // 8
        const SidebarXItem(
            label:'Vehicle Manage',
            iconWidget: Tooltip(
                message: "Vehicle Manage",
                child: Icon(Icons.manage_accounts , color: Colors.white,))
        ),

        // 9
        const SidebarXItem(
            label:'Trip Settle',
            iconWidget: Tooltip(
                message: "Trip Settle",
                child: Icon(Icons.trip_origin , color: Colors.white,))
        ),

        // 10
        const SidebarXItem(
            label:'Billing Dashboard',
            iconWidget: Tooltip(
                message: "Billing Dashboard",
                child: Icon(Icons.library_books_sharp , color: Colors.white,))
        ),

        // 11
        const SidebarXItem(
            label:'OT Billing Dashboard',
            iconWidget: Tooltip(
                message: "OT Billing Dashboard",
                child: Icon(Icons.library_books_sharp , color: Colors.white,))
        ),

        // 12
        const SidebarXItem(
            label:'Accounts Report',
            iconWidget: Tooltip(
                message: "Accounts Report",
                child: Icon(Icons.account_balance_outlined , color: Colors.white,))
        ),

        // 13
        const SidebarXItem(
            label:'Admin Report',
            iconWidget: Tooltip(
                message: "Admin Report",
                child: Icon(Icons.person , color: Colors.white,))
        ),

        // 14
        const SidebarXItem(
            label:'Payment Dashboard',
            iconWidget: Tooltip(
                message: "Payment Dashboard",
                child: Icon(Icons.payment , color: Colors.white,))
        ),

        // 15
        const SidebarXItem(
            label:'Master',
            iconWidget: Tooltip(
                message: "Master",
                child: Icon(Icons.supervisor_account_rounded , color: Colors.white,))
        ),

        // 16
        const SidebarXItem(
            label:'Settings',
            iconWidget: Tooltip(
                message: "Settings",
                child: Icon(Icons.settings , color: Colors.white,))
        ),

        // 17
        const SidebarXItem(
            label:'Automation',
            iconWidget: Tooltip(
                message: "Automation",
                child: Icon(Icons.connect_without_contact_rounded , color: Colors.white,))
        ),

        // 18
        const SidebarXItem(
            label:'Logout',
            iconWidget: Tooltip(
                message: "Logout",
                child: Icon(Icons.logout , color: Colors.white,))
        ),

        // 19
        const SidebarXItem(
            label:'==================',
           iconWidget: Tooltip(
          message: "Others",
          child: Icon(Icons.abc , color: Colors.white,))
        ),

        //===========================================

        // 21
        const SidebarXItem(
          icon: Icons.manage_search,
          label: "Trip Management"
        ),

        // 22
        const SidebarXItem(
          icon: Icons.reorder,
          label: "Order Management"
        ),

        // 23
        const SidebarXItem(
          icon: Icons.car_repair_sharp,
          label: "Vehicle Management"
        ),

        // 24
        const SidebarXItem(
          icon: Icons.library_books_sharp,
          label: "Billing Dashboard"
        ),

        // 25
        const SidebarXItem(
          icon: Icons.edit_note_rounded,
          label: "Reports"
        ),

        // 26
        const SidebarXItem(
          icon: Icons.airplane_ticket,
          label: "Voucher Report"
        ),

        // 27
        const SidebarXItem(
          icon: Icons.bookmark_border_outlined,
          label: "Order Dashboard"
        ),

        // 28
        SidebarXItem(
          icon: Icons.home,
          label: 'LR Management',
          onTap: () {
            debugPrint('Home');
          },
        ),

        // 29
        const SidebarXItem(
          icon: Icons.sell,
          label: 'Accounts2',
        ),

        // 30
        const SidebarXItem(
          icon: Icons.traffic,
          label: 'Traffic',
        ),

        // 31
        const SidebarXItem(
          icon: Icons.person,
          label: 'Master',
        ),

        // 32
        const SidebarXItem(
          icon: Icons.fire_truck_sharp,
          label: 'Vehicle Management',
        ),

        // 33
        const SidebarXItem(
          icon: Icons.trip_origin,
          label: 'Trip Management',
        ),

        // 34
        const SidebarXItem(
          icon: Icons.monetization_on,
          label: 'Billing',
        ),

        // 35
        const SidebarXItem(
          icon: Icons.list_alt,
          label: 'Reports',
        ),

        // 36
        const SidebarXItem(
          icon: Icons.settings,
          label: 'Settings',
        ),

        // 37
        const SidebarXItem(
            icon: Icons.dashboard,
            label: 'Dashboard4'
        ),
      ],
    );
  }
}

class _ScreensExample extends StatelessWidget {
  const _ScreensExample({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(controller.selectedIndex);
        switch (controller.selectedIndex) {
          case 0:
            return Dashboard();
          case 1 :
            return const TrafficDashboard();
          case 2:
            return const OrderDashboard();
          case 3:
            return const TrafficReportsDashboard();
          case 4:
            return const LRReport();
          case 5:
            return const Vouchers();
          case 6:
            return const OutdoorVehicle();
          case 7:
            return const VehicleManage();
          case 8:
            return const TripSettle();
          case 9:
            return const BillingDashboard();
          case 10:
            return const OTBillingDashboard();
          case 11:
            return const AccountsReport();
          case 12:
            return const AdminReports();
          case 13:
            return const PaymentDashboard();
          case 14:
            return const MasterDashboard();
          case 15:
            return const Settings();
          case 16:
            return const Automation();
          case 17:
            return const Logout();
          case 18:
            return const AllForms();

          //==========================

          case 19:
            return const TripManagementDashboard();
          case 20:
            return const OrderManagement();
          case 21:
            return const VehicleManagement();
          case 22:
            return const BillingDashboard();
          case 23 :
            return const ReportDashboard();
          case 24:
            return const VoucherDashboard();
          case 25:
            return const OrderDashboard();
          case 26:
            return const VehicleDashboard();
          case 27:
            return const TrafficDashboard();
          case 28:
            return const AllForms();
          case 29:
            return const Account();
          case 30:
            return const CameraExampleHome();
          case 31:
            return const DashboardTabs();
          case 32:
            return const Traffic();
          case 33:
            return const DriverDetails();
          case 34:
            return const Accounts();
          case 35:
            return const DriversList();
          default:
            return Text(
              pageTitle,
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}

dynamic _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'LR Management';
    case 1:
      return 'Traffic';
    case 2:
      return 'Order Management';
    case 3:
      return 'Favorites';
    case 4:
      return 'Custom iconWidget';
    case 5:
      return 'Profile';
    case 6:
      return 'Settings';
    default:
      return 'Not found page';
  }
}

const primaryColor = Color(0xFF685BFF);
// const canvasColor = Color(0xFF2E2E48);
const canvasColor = Color(0xFF134780);
// const scaffoldBackgroundColor = Color(0xFFE9E9F3);
Color scaffoldBackgroundColor = Colors.white;
const accentCanvasColor = Color(0xFF134799);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
