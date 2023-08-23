import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class GenerateSalary extends StatefulWidget {
  const GenerateSalary({Key? key}) : super(key: key);

  @override
  State<GenerateSalary> createState() => _GenerateSalaryState();
}

List<String> months = ['Select Month', 'January', 'February', 'March', 'April', 'May', 'Jun', 'July', 'August', 'September', 'October', 'November', 'December'];

class _GenerateSalaryState extends State<GenerateSalary> with Utility{

  TextEditingController basicSalary =TextEditingController();
  TextEditingController incentive =TextEditingController();
  TextEditingController pf =TextEditingController();
  TextEditingController esic =TextEditingController();
  TextEditingController pt =TextEditingController();
  TextEditingController leaveDeduction =TextEditingController();
  TextEditingController netSalary =TextEditingController();
  TextEditingController date =TextEditingController();
  TextEditingController dayControllerTo = TextEditingController();
  TextEditingController monthControllerTo = TextEditingController();
  TextEditingController yearControllerTo = TextEditingController();
  TextEditingController toDateApi = TextEditingController();

  String monthDropdown = months.first;
  int freshLoad = 0;
  List employeeSalaryList = [];
  List <TextEditingController> basicSalaryControllerList = [];
  List <TextEditingController> incentiveControllerList = [];
  List<TextEditingController> pfControllerList = [];
  List <TextEditingController> esicControllerList = [];
  List <TextEditingController> ptControllerList = [];
  List <TextEditingController> leaveControllerList = [];
  List <TextEditingController> netSalaryControllerList = [];

  List salaryInfo =[];
  String month = '';

  employeeFetchApiFunc(){
    setStateMounted(() { freshLoad = 1;});
    employeeFetchApi().then((value) {
      var info = jsonDecode(value);

      if (info['success']== true){

        employeeSalaryList.addAll(info['data']);
        pfControllerList.addAll(List.generate(info['data'].length, (index) => TextEditingController(text: info['data'][index]['pf'].toString())));
        ptControllerList.addAll(List.generate(info['data'].length, (index) => TextEditingController(text: info['data'][index]['pt'].toString())));
        incentiveControllerList.addAll(List.generate(info['data'].length, (index) => TextEditingController(text: '0')));
        netSalaryControllerList.addAll(List.generate(info['data'].length, (index) => TextEditingController(text: '0')));
        leaveControllerList.addAll(List.generate(info['data'].length, (index) => TextEditingController(text: '0')));
        basicSalaryControllerList.addAll(List.generate(info['data'].length, (index) => TextEditingController(text: info['data'][index]['basic_salary'].toString())));
        esicControllerList.addAll(List.generate(info['data'].length, (index) => TextEditingController(text: info['data'][index]['esic'].toString())));
        setStateMounted(() {freshLoad = 0;});
      } else{
        setStateMounted(() {freshLoad = 0;});
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    employeeFetchApiFunc();
  }

  generateSalaryFunc() {
    generateSalary().then((value) {
      var info = jsonDecode(value);
      if (info['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiDecoration.appBar('Generate Salary'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: UiDecoration().formDecoration(),
          child: Column(
            children: [
              Row(
                children: [
                  UiDecoration().dropDown(1, DropdownButton<String>(
                    borderRadius: BorderRadius.circular(5),
                    dropdownColor: ThemeColors.whiteColor,
                    underline: Container(
                      decoration:
                      const BoxDecoration(border: Border()),
                    ),
                    isExpanded: true,
                    icon: const Icon(
                      CupertinoIcons.chevron_down,
                      color: ThemeColors.darkBlack,
                      size: 20,
                    ),
                    iconSize: 30,
                    value: monthDropdown,
                    elevation: 16,
                    style: TextDecorationClass().dropDownText(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      month = newValue!;
                      setState(() {
                        monthDropdown = newValue;
                      });
                    },
                    items: months.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(value),
                          );
                        }).toList(),
                  )),
                  const Spacer(),
                  DateFieldWidget(
                      dayController: dayControllerTo,
                      monthController: monthControllerTo,
                      yearController: yearControllerTo,
                      dateControllerApi: toDateApi
                  ),
                  // Expanded(
                  //   flex: 1,
                  //   child: TextFormField(
                  //     textAlign: TextAlign.center,
                  //     readOnly: true,
                  //     controller: date,
                  //     decoration: UiDecoration().outlineTextFieldDecoration("Salary Generate Date", Colors.grey),
                  //     onTap: (){
                  //       UiDecoration().showDatePickerDecoration(context).then((value){
                  //         setState(() {
                  //           String month = value.month.toString().padLeft(2, '0');
                  //           String day = value.day.toString().padLeft(2, '0');
                  //           date.text = "$day-$month-${value.year}";
                  //         });
                  //       });
                  //     },
                  //   ),
                  // ),
                  widthBox20(),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ButtonStyles.customiseButton(ThemeColors.primaryColor, ThemeColors.whiteColor, 200.0, 46.0),
                      onPressed: (){
                        salaryInfoFunc();
                        generateSalaryFunc();
                      },
                      child: const Text('Generate Salary',style: TextStyle(fontSize: 20),),
                    ),
                  ),
                  widthBox20(),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ButtonStyles.customiseButton(ThemeColors.greenColor, ThemeColors.whiteColor, 200.0, 46.0),
                      onPressed: (){
                        employeeFetchApiFunc();
                      },
                      child: const Text('Salary Report',style: TextStyle(fontSize: 20),),
                    ),
                  ),
                ],
              ),
              heightBox20(),
              freshLoad == 1 ? const CircularProgressIndicator() : Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    0: FlexColumnWidth(2.0)
                  },
                  border: TableBorder.all(color: Colors.grey.shade400),
                  children: [ TableRow(
                      children: [
                        TextDecorationClass().tableHeading('Employee Name'),
                        TextDecorationClass().tableHeading('Basic Salary'),
                        TextDecorationClass().tableHeading('Incentive'),
                        TextDecorationClass().tableHeading('PF'),
                        TextDecorationClass().tableHeading('ESIC'),
                        TextDecorationClass().tableHeading('PT'),
                        TextDecorationClass().tableHeading('Leave Deduction'),
                        TextDecorationClass().tableHeading('Net Salary'),
                      ]
                  ) ] +
                      List.generate(employeeSalaryList.length, (index) {
                        setNetSalary(index);

                        return
                          TableRow(
                              children: [
                                TextDecorationClass().tableSubHeading(employeeSalaryList[index]['employee_name']),
                                UiDecoration().tableField(basicSalaryControllerList[index],onChanged: (value) {
                                  setNetSalary(index);
                                },readOnly: true),
                                UiDecoration().tableField(incentiveControllerList[index],onChanged: (value) {
                                  setNetSalary(index);
                                },),
                                UiDecoration().tableField(pfControllerList[index],onChanged: (value) {
                                  setNetSalary(index);
                                },readOnly: true),
                                UiDecoration().tableField(esicControllerList[index],onChanged: (value) {
                                  setNetSalary(index);
                                },readOnly: true),
                                UiDecoration().tableField(ptControllerList[index],onChanged: (value) {
                                  setNetSalary(index);
                                },readOnly: true),
                                UiDecoration().tableField(leaveControllerList[index],onChanged: (value) {
                                  setNetSalary(index);
                                },),
                                UiDecoration().tableField(netSalaryControllerList[index], readOnly: true),
                              ]
                          );
                      })
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future generateSalary() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse('${GlobalVariable.baseURL}Employee/GenerateSalary');
    // print(employeeSalaryList.length);
    var body = {
      'Salary': salaryInfo.toString(),
    };

    var response = await http.post(url, headers: headers, body: body);
    return response.body.toString();
  }



  Future employeeFetchApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse(
        "${GlobalVariable.baseURL}Account/EmployeeSalaryList");
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  setStateMounted(VoidCallback fn){
    if(mounted){
      setState(fn);
    }
  }

  void setNetSalary(int index) {
    double salary = double.parse(basicSalaryControllerList[index].text.isEmpty?"0":basicSalaryControllerList[index].text);
    salary += double.parse(incentiveControllerList[index].text.isEmpty?"0":incentiveControllerList[index].text);
    salary -= double.parse(pfControllerList[index].text.isEmpty?"0":pfControllerList[index].text);
    salary -= double.parse(esicControllerList[index].text.isEmpty?"0":esicControllerList[index].text);
    salary -= double.parse(ptControllerList[index].text.isEmpty?"0":ptControllerList[index].text);
    salary -= double.parse(leaveControllerList[index].text.isEmpty?"0":leaveControllerList[index].text);
    netSalaryControllerList[index].text = salary.toString();
    // NetSalaryController[index].text = salary.toString();
    // _employeesCheckedList[index]['net_salary'] = salary.toString();
  }

  salaryInfoFunc(){
    salaryInfo.clear();
    for (int i = 0; i<employeeSalaryList.length;i++){
      salaryInfo.add([
        employeeSalaryList[i]['employee_id'],
        employeeSalaryList[i]['basic_salary'],
        employeeSalaryList[i]['pf'],
        employeeSalaryList[i]['esic'],
        employeeSalaryList[i]['pt'],
        leaveControllerList[i].text,
        incentiveControllerList[i].text,
        month,
        date.text
      ]);
    }
  }
}
