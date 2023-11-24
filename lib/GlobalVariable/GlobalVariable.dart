import 'package:pfc/utility/styles.dart';

class GlobalVariable{
  static String baseURL = 'http://192.168.5.100:$accountPort';
  static String baseURL2 = 'http://192.168.5.100:';
  static String trafficBaseURL = 'http://192.168.5.100:3000/';
  static String accountPort = '3001/';
  static String port3005 = '3005/';
  static String billingBaseURL = 'http://192.168.5.100:3002/';

  static List<dynamic> dashboardHeaders =[];
  static int userId = 0;
  static String userName = '';
  static String loginEmail = '';

  static int driverId = 0;
  static var driverGroupId;
  static var vehicleId;
  static String entryBy = '';  // using in  APIs {"entry_by" : entryBy}

  /// DataTable
  static int totalRecords = 0;
  static int totalPages = 1;
  static int currentPage = 1;
  static bool next = false;
  static bool prev = false;

  static bool edit = false;

  /// Financial Year Date
  static DateTime fYearFrom = DateTime(1950);
  static DateTime fYearTo = DateTime(DateTime.now().year + 50);
  static var currentFYId;
  static DateTime get displayDate {
    return UiDecoration.showCurrentDate()
        ? DateTime.now()
        : DateTime(fYearTo.year, fYearTo.month, fYearTo.day);
  }

  /// Alliance Dropdown List
  static List<String> allianceList = ['Assets' , 'Income' , 'Expenses' , 'Liabilities'];

  /// Customer edit list
  static List customerEditList = [];
  static bool update = false;


  /// testing
  static bool rebuild = false;
  static int setStateCount = 0;

  /// Traffic Dashboard
  static var vehicleDetails = {};
}
