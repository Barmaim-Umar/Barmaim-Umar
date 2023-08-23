import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:http/http.dart' as http;
import 'package:pfc/auth/auth.dart';

class ServiceWrapper{

  Future newLedger() async {
    var url = Uri.parse("${GlobalVariable.baseURL}Account/LedgersStore");
    var body = {
    'group_id': '2',
    'ledger_title': 'ledger_title',
    'ledger_alias_title': 'ledger_alias_title',
    'ledger_contact_number': '7986541234',
    'ledger_email': 'syedzulkharnain@gmail.com',
    'ledger_address': 'ledger_address',
    'ledger_state_code': '431001',
    'ledger_state': 'ledger_state',
    'ledger_country': 'ledger_country',
    'ledger_credit_days': '10',
    'ledger_gst_number': '10',
    'ledger_pan_number': '10',
    'ledger_registered': '10',
    'ledger_bank_name': 'ledger_bank_name',
    'ledger_bank_account_number': '10',
    'ledger_bank_ifsc': '10',
    'ledger_bank_branch': 'ledger_bank_branch',
    'opening_balance': 'opening_balance',
    'opening_type': 'opening_type',
    'ledger_date': '10-20-502',
    'fixed': '10'
    };
    var response = await http.post(url , body: body);
    return response.body.toString();
  }

  Future driverForm(loginIDController, passwordController) async {
    var url = Uri.parse("${GlobalVariable.baseURL}api/teacher/Login?login_id=$loginIDController&login_password=$passwordController");
    var body = {
      '01': loginIDController,
      '02': passwordController,
      '03': passwordController,
      '04': passwordController,
      '05': passwordController,
      '06': passwordController,
      '07': passwordController,
      '08': passwordController,
      '09': passwordController,
      '10': passwordController,
      '11': passwordController,
      '12': passwordController,
      '13': passwordController,
      '14': passwordController,
      '15': passwordController,
      '16': passwordController,
      '17': passwordController,
      '18': passwordController,
      '19': passwordController,
      '20': passwordController,
      '21': passwordController,
      '22': passwordController,
      '23': passwordController,
      '24': passwordController,
    };
    var response = await http.post(url, body: body);
    return response.body.toString();
  }

  ///===================

  Future driverDeleteApi(Url) async{
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}$Url');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  // ledger fetch api
  Future ledgerFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/LedgersFetch");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  // vehicle fetch api
  Future vehicleFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Vehicle/VehicleFetch");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  // group fetch api
  Future groupFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}Account/GroupFetch");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

  // Current financial year api
  Future currentFYApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse("${GlobalVariable.baseURL}FY/CurrentFY");
    var response = await  http.get(url, headers: headers);
    return response.body.toString();
  }

}