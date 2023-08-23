import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/auth/auth.dart';
import 'package:pfc/utility/Widgets/DateFieldWidget2.dart';
import 'package:pfc/utility/Widgets/SearchDropdownWidget.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';
import 'package:pfc/utility/utility.dart';
import 'package:http/http.dart' as http;

class DriverDetails extends StatefulWidget {
  const DriverDetails({Key? key}) : super(key: key);

  @override
  State<DriverDetails> createState() => _DriverDetailsState();
}

List<String> selectDriverCityList = [];
List<String> maritalStatusDropdownList = ["Married" , "Unmarried"];
List<String> licenseTypeDropdownList = ["Learner’s License" , "Permanent Driving License" , "Commercial Driving License" , "International Driving Permit" ];

class _DriverDetailsState extends State<DriverDetails> with Utility {
  bool obscure = true;
  String dropDownValue = '5';
  bool update = false;

  String selectDriverCityDropdownValue = '';
  String maritalStatusDropdownValue = '';
  String licenseTypeDropdownValue = '';

  int index = 0;
  int freshLoad = 0;
  int driverID = 0;

  // for image picker
  List<int> imageBytes =[];
  var img;
  int totalSize = 0;
  int sentSize = 0;

  ScrollController scrollController = ScrollController();

  /// ProfileStep
  TextEditingController driverNameController = TextEditingController(text: "Santosh");
  TextEditingController driverResidentAddressController = TextEditingController(text: "Maharashtra");
  TextEditingController driverPermanentAddressController = TextEditingController(text: "Delhi");
  TextEditingController driverMobNo1Controller = TextEditingController(text: "9800922190");
  TextEditingController driverMobNo2Controller = TextEditingController(text: "9980807676");
  TextEditingController driverDOBControllerUi = TextEditingController();
  TextEditingController driverDOBControllerApi = TextEditingController();
  TextEditingController driverAgeController = TextEditingController(text: "35");
  TextEditingController driverHabitsController = TextEditingController(text: "Coding");
  TextEditingController driverAccidentsHistoryController = TextEditingController(text: "No Accidents");
  TextEditingController driverFatherNameController = TextEditingController(text:"Suraj");
  TextEditingController driverFatherAgeController = TextEditingController(text: "60");
  TextEditingController driverMotherNameController = TextEditingController(text: "Shruti");
  TextEditingController driverMotherAgeController = TextEditingController(text: "60");
  TextEditingController driverWifeNameController = TextEditingController(text: "Sayli");
  TextEditingController driverWifeAgeController = TextEditingController(text: "35");
  TextEditingController driverLicenseNumberController = TextEditingController(text: "848853");
  TextEditingController driverLicenseDateOfdIssueControllerUi = TextEditingController();
  TextEditingController driverLicenseDateOfdIssueControllerApi = TextEditingController();
  TextEditingController licenseIssuingAuthorityController = TextEditingController(text: "PDC");
  TextEditingController licenseValidityFromControllerUi = TextEditingController();
  TextEditingController licenseValidityFromControllerApi = TextEditingController();
  TextEditingController licenseValidityToControllerUi = TextEditingController();
  TextEditingController licenseValidityToControllerApi = TextEditingController();
  TextEditingController loginIDController = TextEditingController(text: "santosh");
  TextEditingController passwordController = TextEditingController(text: "santosh");
  final formKey = GlobalKey<FormState>();

  /// GuarantorStep
  TextEditingController guarantorNameController = TextEditingController();
  TextEditingController guarantorMobileNumberController = TextEditingController();
  FocusNode focusNode2 = FocusNode();
  final formKey2 = GlobalKey<FormState>();
  List guarantorList = [
    {"guarantor_name":"Sanjay Rade PFC Driver Vehicle No. 3229" , "guarantor_mobile_number":"8766862103"} ,
    {"guarantor_name":"Sohil PFC Driver Vehicle No. 3229" , "guarantor_mobile_number":"7327677660"}
  ];

  /// FriendsStep
  TextEditingController friendNameController = TextEditingController();
  TextEditingController friendAddressController = TextEditingController();
  TextEditingController friendMobileNumberController = TextEditingController();
  FocusNode focusNode3 = FocusNode();
  final formKey3 = GlobalKey<FormState>();
  List friendsList = [
    {"friend_name":"Santosh Lane (Brother)" , "friend_address":"Ada Jana" , "friend_mobile_number" : "9960604343"},
    {"friend_name":"Kalim (Friend)" , "friend_address":"Aurangabad" , "friend_mobile_number" : "3049688556"},
  ];


  /// Children
  TextEditingController childrenNameController = TextEditingController();
  TextEditingController childrenAgeController = TextEditingController();
  FocusNode focusNode4 = FocusNode();
  final formKey4 = GlobalKey<FormState>();
  List childrenList = [
    {"children_name" : "Sanjay Santosh" , "children_age":"15"},
    {"children_name" : "Samar " , "children_age":"22"},
  ];


  /// ExperienceStep
  TextEditingController organizationNameController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController noOfMonthsController = TextEditingController();
  TextEditingController reasonForLeavingController = TextEditingController();
  TextEditingController dayControllerDriverDOB = TextEditingController();
  TextEditingController monthControllerDriverDOB = TextEditingController();
  TextEditingController yearControllerDriverDOB = TextEditingController();
  TextEditingController driverDOBDateApi =TextEditingController();
  TextEditingController dayControllerDriverLicenseDateOfIssue = TextEditingController();
  TextEditingController monthControllerDriverLicenseDateOfIssue = TextEditingController();
  TextEditingController yearControllerDriverLicenseDateOfIssue = TextEditingController();
  TextEditingController driverLicenseDateOfIssueDateApi =TextEditingController();
  TextEditingController dayControllerLicenseValidityFrom = TextEditingController();
  TextEditingController monthControllerLicenseValidityFrom = TextEditingController();
  TextEditingController yearControllerLicenseValidityFrom = TextEditingController();
  TextEditingController licenseValidityFromDateApi =TextEditingController();
  TextEditingController dayControllerLicenseValidityTo = TextEditingController();
  TextEditingController monthControllerLicenseValidityTo = TextEditingController();
  TextEditingController yearControllerLicenseValidityTo = TextEditingController();
  TextEditingController licenseValidityToDateApi =TextEditingController();
  FocusNode focusNode5 = FocusNode();
  final formKey5 = GlobalKey<FormState>();
  var driverGroupId ;
  List driverGroupList = [];
  List experienceList = [
    {"organization_name":"Kailash Road Lines (PandaBoard)" , "from_date":"19-02-2011" , "to_date":"30-12-2027" , "no_of_months":"112" , "reason_for_leaving":"Home Work"},
    {"organization_name":"ATC (Aurangabad)" , "from_date":"19-02-2017" , "to_date":"30-12-2022" , "no_of_months":"52" , "reason_for_leaving":"Licence Renewal"},
  ];


  /// PictureStep
  TextEditingController docNameController = TextEditingController();
  String? imgPath;
  var imgPathWeb;
  late DropzoneViewController dropzoneController;

  @override
  void initState() {
    super.initState();
    addCity();
    GlobalVariable.edit == true?driverEditApiFunc():null;
  }

  // API

  driverProfileUpdateApiFunc(){
    driverProfileUpdateApi().then((value){
      var info = jsonDecode(value);
      if(info['success']==true){
        setState(() {
          GlobalVariable.edit = false;
        });
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }
      else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  driverEditApiFunc() {
    driverEditApi().then((value) {
      var info = jsonDecode(value);
      if(info['success']==true){
        getDriverGroupName();
        driverNameController.text = info['data'][0]['driver_name'];
        driverResidentAddressController.text = info['data'][0]['driver_ro'];
        driverPermanentAddressController.text = info['data'][0]['permanent_address'];
        driverMobNo1Controller.text = info['data'][0]['driver_mobile_number'];
        driverMobNo2Controller.text = info['data'][0]['driver_mobile_number_second'].toString();
        driverDOBControllerUi.text = UiDecoration().getFormattedDate(info['data'][0]['driver_dob'].toString());
        driverAgeController.text = info['data'][0]['driver_age'].toString();
        dropDownValue = info['data'][0]['driver_marital_status'];
        driverHabitsController.text = info['data'][0]['driver_habits'].toString();
        driverAccidentsHistoryController.text = info['data'][0]['driver_accidents'].toString();
        driverFatherNameController.text = info['data'][0]['driver_father'].toString();
        driverFatherAgeController.text = info['data'][0]['driver_father_age'].toString();
        driverMotherNameController.text = info['data'][0]['driver_mother'].toString();
        driverMotherAgeController.text = info['data'][0]['driver_mother_age'].toString();
        driverWifeNameController.text = info['data'][0]['driver_wife'].toString();
        driverWifeAgeController.text = info['data'][0]['driver_wife_age'].toString();
        driverLicenseNumberController.text = info['data'][0]['driver_license_number'].toString();
        driverLicenseDateOfdIssueControllerUi.text = UiDecoration().getFormattedDate(info['data'][0]['driver_license_date_of_issue'].toString());
        licenseIssuingAuthorityController.text = info['data'][0]['driver_license_issuing_authority'].toString();
        licenseValidityFromControllerUi.text = UiDecoration().getFormattedDate(info['data'][0]['driver_license_validity_from'].toString());
        licenseValidityToControllerUi.text = UiDecoration().getFormattedDate(info['data'][0]['driver_license_validity_to'].toString());
        licenseTypeDropdownValue = info['data'][0]['driver_license_type'].toString();
        loginIDController.text = info['data'][0]['driver_login_id'].toString();
        passwordController.text = info['data'][0]['driver_login_password'].toString();
      }
    });
  }

  addCity() {
    setState(() {
      freshLoad = 1;
    });
    cityDropDownApi().then(
          (value) {
        var info = jsonDecode(value);
        if (info['success'].toString() == 'true') {
          driverGroupList.clear();
          selectDriverCityList.clear();
          for(int i = 0; i <info['data'].length; i++){
            driverGroupList.add(info['data'][i]);
            selectDriverCityList.add(info['data'][i]['driver_group_name']);
          }
          setState(() {
            freshLoad = 0;
          });
        } else {
          setState(() {
            freshLoad = 1;
          });
        }
      },
    );
  }

  createDriverProfileApiFunc(){
    driverProfileApi().then((value){
      var info = jsonDecode(value);
      if(info['success']==true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
        driverID = info['driver'];
      }
      else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  driverGuarantorApiFunc(){
    driverGuarantorApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  driverFriendsApiFunc(){
    driverFriendsApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      } else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  driverChildrenApiFunc(){
    driverChildrenApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }
      else{
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  driverExperienceApiFunc(){
    driverExperienceApi().then((value) {
      var info = jsonDecode(value);
      if(info['success'] == true){
        AlertBoxes.flushBarSuccessMessage(info['message'], context);
      }else {
        AlertBoxes.flushBarErrorMessage(info['message'], context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps() => [
      Step(title: TextDecorationClass().stepperText("Profile"), content: profileStep()),
      Step(title: TextDecorationClass().stepperText("Guarantors"), content: guarantorsStep()),
      Step(title: TextDecorationClass().stepperText("Friends"), content: friendsStep()),
      Step(title: TextDecorationClass().stepperText("Children"), content: childrenStep()),
      Step(title: TextDecorationClass().stepperText("Experience"), content: experienceStep()),
      Step(title: TextDecorationClass().stepperText("Picture"), content: driverPictureStep()),
    ];
    return Scaffold(
      appBar: UiDecoration.appBar("Driver Details"),

      body: Container(
        color: Colors.white,
        child: Stepper(
          currentStep: index,
          //
          steps: steps(),
          //
          type: StepperType.horizontal,
          //
          onStepTapped: (value) {
            setState(() {
              index = value;
            });
          },
          //
          onStepCancel: () {},
          //
          controlsBuilder: (BuildContext context,controller) {
            return Row(
              children: <Widget>[
                // Previous button
                index <=0 ? const SizedBox.shrink() :
                TextButton(
                  style: ButtonStyles.smallButton(ThemeColors.primaryColor, ThemeColors.whiteColor),
                  onPressed:  () {
                    setState(() {
                      index > 0 ? index-- : index = 5;
                    });
                  },
                  child: const Text('Previous'),
                ),

                const SizedBox(width: 10,),

                // Submit Button - if index == 5 then "Submit Button" will appear else "Next Button" will appear
                index == 5 ?
                TextButton(onPressed: () {
                  if(img == null || img == "" ){
                  AlertBoxes.flushBarErrorMessage("Please Pick a File", context);
                  }
                  else{
                    uploadFile();
                  }
                  },
                    child: const Text("Submit")) :

                // Next Button | Update Button
                TextButton(
                  style: ButtonStyles.smallButton(ThemeColors.primaryColor, ThemeColors.whiteColor),
                  onPressed: () {

                    /// Validation working fine (switch case)
                    switch(index){

                      case 0:
                        if(formKey.currentState!.validate()){
                          formKey.currentState!.save();
                          GlobalVariable.edit==true?driverProfileUpdateApiFunc(): createDriverProfileApiFunc();
                        setState(() {
                          index = 1;
                          FocusScope.of(context).requestFocus(focusNode2);
                        });
                        }
                        break;
                      case 1:
                        if(formKey2.currentState!.validate()){
                          formKey2.currentState!.save();
                            driverGuarantorApiFunc();
                          setState(() {
                            index = 2;
                            FocusScope.of(context).requestFocus(focusNode3);
                          });
                        }
                        break;
                      case 2:
                        if(formKey3.currentState!.validate()){
                          formKey3.currentState!.save();
                            driverFriendsApiFunc();
                          setState(() {
                            index = 3;
                            FocusScope.of(context).requestFocus(focusNode4);
                          });
                        }
                        break;
                      case 3:
                        if(formKey4.currentState!.validate()){
                          formKey4.currentState!.save();
                            driverChildrenApiFunc();
                          setState(() {
                            index = 4;
                            FocusScope.of(context).requestFocus(focusNode5);
                          });
                        }
                        break;
                      case 4:
                        if(formKey5.currentState!.validate()){
                          formKey5.currentState!.save();
                            driverExperienceApiFunc();
                          setState(() {
                            index = 5;
                          });
                        }
                        break;

                    }

                    /// old validation (if else)
                    // if(driverNameController.text.isEmpty) {
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Name", context);
                    // }
                    // else if(driverResidentAddressController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Resident Address", context);
                    // }
                    // else if(driverPermanentAddressController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Permanent Address", context);
                    // }
                    // else if(driverMobNo1Controller.text.isEmpty && driverMobNo2Controller.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Mobile Number", context);
                    // }
                    // else if(driverDOBControllerUi.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Date Of Birth", context);
                    // }
                    // else if(driverAgeController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Age", context);
                    // }
                    // else if(driverHabitsController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Habits", context);
                    // }
                    // else if(driverAccidentsHistoryController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Accidents History", context);
                    // }
                    // else if(driverFatherNameController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Father Name", context);
                    // }
                    // else if(driverFatherAgeController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Father Age", context);
                    // }
                    // else if(driverMotherNameController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Mother Name", context);
                    // }
                    // else if(driverMotherAgeController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Mother Age", context);
                    // }
                    // else if(driverWifeNameController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Wife Name", context);
                    // }
                    // else if(driverWifeAgeController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver Wife Age", context);
                    // }
                    // else if(driverLicenseNumberController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver License Number", context);
                    // }
                    // else if(driverLicenseDateOfdIssueControllerUi.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Driver License Date of Issue", context);
                    // }
                    // else if(licenseIssuingAuthorityController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter License Issuing Authority", context);
                    // }
                    // else if(licenseValidityFromControllerUi.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter License Validity From", context);
                    // }
                    // else if(licenseValidityToControllerUi.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter License Validity To", context);
                    // }
                    // else if(loginIDController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Login ID", context);
                    // }
                    // else if(passwordController.text.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Enter Password", context);
                    // }
                    // else if(index == 0){
                    //   GlobalVariable.edit==true?driverProfileUpdateApiFunc(): createDriverProfileApiFunc();
                    //   setState(() {
                    //     index = 1;
                    //   });
                    // }
                    // else if(guarantorList.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Please ADD GUARANTOR", context);
                    //
                    //   if(guarantorNameController.text.isEmpty){
                    //     AlertBoxes.flushBarErrorMessage("Enter Guarantor's Name", context);
                    //   } else if(guarantorMobileNumberController.text.isEmpty){
                    //     AlertBoxes.flushBarErrorMessage("Enter Guarantor's Mobile Number", context);
                    //   }
                    //
                    // }
                    // else if(index == 1){
                    //   setState(() {
                    //     driverGuarantorApiFunc();
                    //     index = 2;
                    //   });
                    // }
                    // else if(friendsList.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Please ADD FRIEND", context);
                    //
                    //   if(friendNameController.text.isEmpty){
                    //     AlertBoxes.flushBarErrorMessage("Enter Friend's Name", context);
                    //   } else if(friendAddressController.text.isEmpty){
                    //     AlertBoxes.flushBarErrorMessage("Enter Friend's Address", context);
                    //   } else if(friendMobileNumberController.text.isEmpty){
                    //     AlertBoxes.flushBarErrorMessage("Enter Friend's Mobile Number", context);
                    //   }
                    //
                    // }
                    // else if(index == 2){
                    //   setState(() {
                    //     driverFriendsApiFunc();
                    //     index = 3;
                    //   });
                    // }
                    // else if(childrenList.isEmpty) {
                    //   AlertBoxes.flushBarErrorMessage("Please ADD CHILDREN", context);
                    //   if(childrenNameController.text.isEmpty){
                    //     AlertBoxes.flushBarErrorMessage("Enter Children Name", context);
                    //   } else if(childrenAgeController.text.isEmpty){
                    //     AlertBoxes.flushBarErrorMessage("Enter Children Age", context);
                    //   }
                    //
                    // }
                    // else if(index == 3){
                    //   setState(() {
                    //     driverChildrenApiFunc();
                    //     index = 4;
                    //   });
                    // }
                    // else if(experienceList.isEmpty){
                    //   AlertBoxes.flushBarErrorMessage("Please ADD EXPERIENCE", context);
                    //   if(organizationNameController.text.isEmpty){
                    //     AlertBoxes.flushBarErrorMessage("Enter Organization Name", context);
                    //   } else if(fromDateController.text.isEmpty){
                    //     AlertBoxes.flushBarErrorMessage("Enter From Date", context);
                    //   } else if(toDateController.text.isEmpty){
                    //     AlertBoxes.flushBarErrorMessage("Enter To Date", context);
                    //   } else if(noOfMonthsController.text.isEmpty){
                    //     AlertBoxes.flushBarErrorMessage("Enter No. Of Months", context);
                    //   } else if(reasonForLeavingController.text.isEmpty){
                    //     AlertBoxes.flushBarErrorMessage("Enter Reason for Leaving", context);
                    //   }
                    //
                    // }
                    // else if(index == 4){
                    //   driverExperienceApiFunc();
                    //   setState(() {
                    //     index = 5;
                    //   });
                    // }
                  },
                  child: Text(GlobalVariable.edit==true?'Update':'Next'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  profileStep() {
    return UiDecoration().stepperContainer("Driver Form 1", Form(
      key: formKey,
      child: FocusScope(
        child: FocusTraversalGroup(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FocusTraversalGroup(
                  child: Column(
                    children: [
                      FormWidgets().formDetails2('Select Driver',SearchDropdownWidget(
                          dropdownList: selectDriverCityList,
                          hintText: 'Select Ledger',
                          selectedItem: selectDriverCityDropdownValue,
                          onChanged: (value) {
                            setState(() {
                              selectDriverCityDropdownValue = value!;
                              getDriverGroupId();
                            });
                          },
                        ),),
                      FormWidgets().onlyAlphabetField('Driver Name', 'Driver Name', driverNameController , context),
                      FormWidgets().textField('Driver Resident Address (R/O)', 'Driver Resident Address (R/O)', driverResidentAddressController , context , maxLines: 4),
                      FormWidgets().textField('Driver Permanent Address ', 'Driver Permanent Address', driverPermanentAddressController , context , maxLines: 4),
                      FormWidgets().contactField2("Drive Mobile Number", "Enter Mobile Number 1", "Enter Mobile Number 2", driverMobNo1Controller, driverMobNo2Controller, context),
                      FormWidgets().formDetails2('Driver Date Of Birth',
                        DateFieldWidget2(
                            dayController: dayControllerDriverDOB,
                            monthController: monthControllerDriverDOB,
                            yearController: yearControllerDriverDOB,
                            dateControllerApi: driverDOBDateApi
                        ),
                      //   TextFormField(
                      //   readOnly: true,
                      //   controller: driverDOBControllerUi,
                      //   decoration:
                      //   UiDecoration().dateFieldDecoration('From Date'),
                      //   onTap: () {
                      //     UiDecoration()
                      //         .showDatePickerDecoration(context)
                      //         .then((value) {
                      //       setState(() {
                      //         String month =
                      //         value.month.toString().padLeft(2, '0');
                      //         String day = value.day.toString().padLeft(2, '0');
                      //         driverDOBControllerUi.text = "$day-$month-${value.year}";
                      //         driverDOBControllerApi.text = "${value.year}-$month-$day";
                      //       });
                      //     });
                      //   },
                      //
                      //   validator: (value) {
                      //     if(value == null || value == ''){
                      //       return "Please Select Date";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      ),
                      FormWidgets().numberField('Driver Age', 'Driver Age', driverAgeController , context),
                      FormWidgets().formDetails2('Marital Status',SearchDropdownWidget(
                             dropdownList: maritalStatusDropdownList,
                             hintText: "Please Select Marital Status",
                             onChanged: (value) {maritalStatusDropdownValue = value!;},
                             selectedItem: maritalStatusDropdownValue,
                             showSearchBox: false,
                             maxHeight: 100,
                         )),
                      FormWidgets().onlyAlphabetField('Driver Habits', 'Driver Habits', driverHabitsController , context , maxLines: 3),
                      FormWidgets().onlyAlphabetField('Driver Accidents History', 'Driver Accidents History', driverAccidentsHistoryController , context , maxLines: 3),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10,),

              Expanded(
                child: FocusTraversalGroup(
                  child: Column(
                    children: [
                      FormWidgets().nameAgeField("Driver Father", "Father Name", "Age", driverFatherNameController, driverFatherAgeController, context),
                      FormWidgets().nameAgeField('Driver Mother', 'Mother Name', 'Age', driverMotherNameController, driverMotherAgeController , context),
                      FormWidgets().nameAgeField('Driver Wife', 'Wife Name', 'Age', driverWifeNameController, driverWifeAgeController , context),
                      FormWidgets().alphanumericField('Driver License Number', 'Driver License Number', driverLicenseNumberController , context),
                      FormWidgets().formDetails2('Driver License Date of Issue',
                        DateFieldWidget2(
                            dayController: dayControllerDriverLicenseDateOfIssue,
                            monthController: monthControllerDriverLicenseDateOfIssue,
                            yearController: yearControllerDriverLicenseDateOfIssue,
                            dateControllerApi: driverLicenseDateOfIssueDateApi
                        ),
                      //   TextFormField(
                      //   readOnly: true,
                      //   controller: driverLicenseDateOfdIssueControllerUi,
                      //   decoration:
                      //   UiDecoration().dateFieldDecoration('From Date'),
                      //   onTap: () {
                      //     UiDecoration()
                      //         .showDatePickerDecoration(context)
                      //         .then((value) {
                      //       setState(() {
                      //         String month =
                      //         value.month.toString().padLeft(2, '0');
                      //         String day = value.day.toString().padLeft(2, '0');
                      //         driverLicenseDateOfdIssueControllerUi.text = "$day-$month-${value.year}";
                      //         driverLicenseDateOfdIssueControllerApi.text = "${value.year}-$month-$day";
                      //       });
                      //     });
                      //   },
                      //   validator: (value) {
                      //     if(value == null || value == ''){
                      //       return "Please Select Date";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      ),
                      FormWidgets().onlyAlphabetField('License Issuing Authority', 'License Issuing Authority', licenseIssuingAuthorityController,context),
                      FormWidgets().formDetails2('License Validity From',
                        DateFieldWidget2(
                            dayController: dayControllerLicenseValidityFrom,
                            monthController: monthControllerLicenseValidityFrom,
                            yearController: yearControllerLicenseValidityFrom,
                            dateControllerApi: licenseValidityFromDateApi
                        ),
                      //   TextFormField(
                      //   readOnly: true,
                      //   controller: licenseValidityFromControllerUi,
                      //   decoration:
                      //   UiDecoration().dateFieldDecoration('From Date'),
                      //   onTap: () {
                      //     UiDecoration()
                      //         .showDatePickerDecoration(context)
                      //         .then((value) {
                      //       setState(() {
                      //         String month =
                      //         value.month.toString().padLeft(2, '0');
                      //         String day = value.day.toString().padLeft(2, '0');
                      //         licenseValidityFromControllerUi.text = "$day-$month-${value.year}";
                      //         licenseValidityFromControllerApi.text = "${value.year}-$month-$day";
                      //       });
                      //     });
                      //   },
                      //
                      //   validator: (value) {
                      //     if(value == null || value == ''){
                      //       return "Please Select Date";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      ),
                      FormWidgets().formDetails2('License Validity To',
                        DateFieldWidget2(
                            dayController: dayControllerLicenseValidityTo,
                            monthController: monthControllerLicenseValidityTo,
                            yearController: yearControllerLicenseValidityTo,
                            dateControllerApi: licenseValidityToDateApi
                        ),
                      //   TextFormField(
                      //   readOnly: true,
                      //   controller: licenseValidityToControllerUi,
                      //   decoration:
                      //   UiDecoration().dateFieldDecoration('From Date'),
                      //   onTap: () {
                      //     UiDecoration()
                      //         .showDatePickerDecoration(context)
                      //         .then((value) {
                      //       setState(() {
                      //         String month =
                      //         value.month.toString().padLeft(2, '0');
                      //         String day = value.day.toString().padLeft(2, '0');
                      //         licenseValidityToControllerUi.text = "$day-$month-${value.year}";
                      //         licenseValidityToControllerApi.text = "${value.year}-$month-$day";
                      //       });
                      //     });
                      //   },
                      //
                      //   validator: (value) {
                      //     if(value == null || value == ''){
                      //       return "Please Select Date";
                      //     }
                      //     return null;
                      //   },
                      // ),
                      ),
                      FormWidgets().formDetails2('License Type',SearchDropdownWidget(
                          dropdownList: licenseTypeDropdownList,
                          hintText: "Please Select License Type",
                          onChanged: (value) {licenseTypeDropdownValue = value!;},
                          selectedItem: licenseTypeDropdownValue,
                          showSearchBox: false,
                          maxHeight: 200,
                      )),
                      FormWidgets().textField("Login ID", "Enter Login ID", loginIDController, context),
                      FormWidgets().passwordField("Password", "Password", passwordController, context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  guarantorsStep() {
    return
      UiDecoration().stepperContainer("Driver Guarantors (Driver's ID: $driverID)", Form(
        key: formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FocusScope(
              child: FocusTraversalGroup(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Spacer(),

                    // Guarantor Name
                    Expanded(flex: 2, child: FormWidgets().onlyAlphabetField2("Guarantor Name", "Guarantor Name", guarantorNameController,context , focusNode: focusNode2)),
                    const SizedBox(width: 50,),

                    // Guarantor Mobile Number
                    Expanded(flex: 2, child: FormWidgets().contactField3("Guarantor Mobile Number", "Guarantor Mobile Number", guarantorMobileNumberController , context)),
                    const SizedBox(width: 50,),


                    // Add Button
                    Column(
                      children: [
                        TextDecorationClass().fieldTitle(''),
                        Container(
                          decoration: BoxDecoration(color: ThemeColors.primaryColor, borderRadius: BorderRadius.circular(5)),
                          child: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                if(formKey2.currentState!.validate()){
                                  formKey2.currentState!.save();

                                  setState(() {
                                    guarantorList.add({"guarantor_name": guarantorNameController.text, "guarantor_mobile_number": guarantorMobileNumberController.text});
                                    guarantorNameController.clear();
                                    guarantorMobileNumberController.clear();
                                  });
                                }
                                // if(guarantorNameController.text.isEmpty){
                                //   AlertBoxes.flushBarErrorMessage("Please Enter Guarantor Name", context);
                                // } else if(guarantorMobileNumberController.text.isEmpty){
                                //   AlertBoxes.flushBarErrorMessage("Please Enter Mobile Number", context);
                                // } else {
                                //   setState(() {
                                //     guarantorList.add({"guarantor_name": guarantorNameController.text, "guarantor_mobile_number": guarantorMobileNumberController.text});
                                //     guarantorNameController.clear();
                                //     guarantorMobileNumberController.clear();
                                //   });
                                // }
                              },
                              icon: const Icon(CupertinoIcons.add)),
                        ),
                      ],
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50,),

            /// Guarantor List Divider

            guarantorList.isEmpty ? const SizedBox() :
            Row(
              children: const [
                Expanded(child: SizedBox(),),
                Text("Guarantors List" , style: TextStyle(fontWeight: FontWeight.bold),),  SizedBox(width: 10,),
                Expanded(flex: 4,child: Divider()),
                Spacer()
              ],
            ),
            ListView.builder(
              controller: scrollController,
              itemCount: guarantorList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),

                        // Name
                        Expanded(flex: 2, child: UiDecoration().addMore(guarantorList[index]["guarantor_name"].toString())),
                        const SizedBox(width: 50,),
                        // Mobile Number
                        Expanded(flex: 2, child: UiDecoration().addMore(guarantorList[index]["guarantor_mobile_number"].toString())),
                        const SizedBox(width: 50,),
                        // Delete Button
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(color: ThemeColors.darkRedColor, borderRadius: BorderRadius.circular(5)),
                          child: IconButton(color: Colors.white, onPressed: () {
                            setState(() {
                              guarantorList.removeAt(index);
                            });
                          }, icon: const Icon(CupertinoIcons.delete , size: 20,)),
                        ),
                        const Spacer()
                      ],
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ));

  }

  friendsStep() {
    return UiDecoration().stepperContainer("Driver's Reputed Person / Friends",  Form(
      key: formKey3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FocusScope(
            child: FocusTraversalGroup(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Spacer(),

                  // Friend Name
                  Expanded(flex: 2, child: FormWidgets().onlyAlphabetField2("Persons / Friends Name", "Persons / Friends Name", friendNameController, context , focusNode: focusNode3)),
                  const SizedBox(width: 50),

                  // Friend Address
                  Expanded(flex: 2, child: FormWidgets().textField2("Address", "Address", friendAddressController, context)),
                  const SizedBox(width: 50),

                  // Friend Mobile Number
                  Expanded(flex: 2, child: FormWidgets().contactField3("Mobile Number", "Mobile Number", friendMobileNumberController, context)),
                  const SizedBox(width: 50),

                  // add button
                  Column(
                    children: [
                      TextDecorationClass().fieldTitle(''),
                      Container(
                        decoration: BoxDecoration(color: ThemeColors.primaryColor, borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              if(friendNameController.text.isEmpty){
                                AlertBoxes.flushBarErrorMessage("Enter Friend Name", context);
                              } else if(friendAddressController.text.isEmpty){
                                AlertBoxes.flushBarErrorMessage("Enter Address", context);
                              } else if(friendMobileNumberController.text.isEmpty){
                                AlertBoxes.flushBarErrorMessage("Enter Mobile Number", context);
                              } else {
                                setState(() {
                                  friendsList.add({"friend_name": friendNameController.text, "friend_address": friendAddressController.text , "friend_mobile_number": friendMobileNumberController.text});
                                  friendNameController.clear();
                                  friendAddressController.clear();
                                  friendMobileNumberController.clear();
                                });
                              }
                            },
                            icon: const Icon(CupertinoIcons.add)),
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          /// Friends List Divider

          friendsList.isEmpty ? const SizedBox() :
          Row(
            children: const [
              Expanded(
                child: SizedBox(),),
              Text("Friends List" , style: TextStyle(fontWeight: FontWeight.bold),),  SizedBox(width: 10,),
              Expanded(
                  flex: 7,
                  child: Divider()),
              Spacer()
            ],
          ),
          ListView.builder(
            controller: scrollController,
            itemCount: friendsList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),

                      // Friend Name
                      Expanded(flex: 2, child: UiDecoration().addMore(friendsList[index]["friend_name"].toString())),
                      const SizedBox(
                        width: 50,
                      ),
                      // Friend Address
                      Expanded(flex: 2, child: UiDecoration().addMore(friendsList[index]["friend_address"].toString())),
                      const SizedBox(
                        width: 50,
                      ),
                      // Friend Mobile Number
                      Expanded(flex: 2, child: UiDecoration().addMore(friendsList[index]["friend_mobile_number"].toString())),
                      const SizedBox(
                        width: 50,
                      ),

                      // delete button
                      Container(
                        decoration: BoxDecoration(color: ThemeColors.darkRedColor, borderRadius: BorderRadius.circular(5)),
                        child: IconButton(color: Colors.white, onPressed: () {
                          setState(() {
                            friendsList.removeAt(index);
                          });
                        }, icon:  const Icon(CupertinoIcons.delete , size: 20,)),
                      ),
                      const Spacer()
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
    ),);

  }

  childrenStep() {
    return UiDecoration().stepperContainer("Driver Children", Form(
      key: formKey4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FocusScope(
            child: FocusTraversalGroup(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Spacer(),

                  // Children Name
                  Expanded(flex: 2, child: FormWidgets().onlyAlphabetField2("Children Name", "Children Name", childrenNameController, context, focusNode: focusNode4)),
                  const SizedBox(
                    width: 50,
                  ),

                  // Children Age
                  Expanded(flex: 2, child: FormWidgets().numberField2("Children Age", "Age", childrenAgeController, context)),
                  const SizedBox(
                    width: 50,
                  ),

                  // add button
                  Column(
                    children: [
                      TextDecorationClass().fieldTitle(''),
                      Container(
                        decoration: BoxDecoration(color: ThemeColors.primaryColor, borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              if(childrenNameController.text.isEmpty){
                                AlertBoxes.flushBarErrorMessage("Enter Children Name", context);
                              } else if(childrenAgeController.text.isEmpty){
                                AlertBoxes.flushBarErrorMessage("Enter Children Age", context);
                              }else {
                                setState(() {
                                  childrenList.add({"children_name": childrenNameController.text, "children_age": childrenAgeController.text});
                                  childrenNameController.clear();
                                  childrenAgeController.clear();
                                });
                              }

                            },
                            icon: const Icon(CupertinoIcons.add)),
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          /// Children List Divider

          childrenList.isEmpty ? const SizedBox() :
          Row(
            children: const [
              Expanded(child: SizedBox(),),
              Text("Children List" , style: TextStyle(fontWeight: FontWeight.bold),),  SizedBox(width: 10,),
              Expanded(
                  flex: 4,
                  child: Divider()),
              Spacer()
            ],
          ),
          ListView.builder(
            controller: scrollController,
            itemCount: childrenList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),

                      // Children Name
                      Expanded(flex: 2, child: UiDecoration().addMore(childrenList[index]["children_name"].toString())),
                      const SizedBox(
                        width: 50,
                      ),
                      // Children Age
                      Expanded(flex: 2, child: UiDecoration().addMore(childrenList[index]["children_age"].toString())),
                      const SizedBox(
                        width: 50,
                      ),

                      // delete button
                      Container(
                        decoration: BoxDecoration(color: ThemeColors.darkRedColor, borderRadius: BorderRadius.circular(5)),
                        child: IconButton(color: Colors.white, onPressed: () {
                          setState(() {
                            childrenList.removeAt(index);
                          });
                        }, icon:  const Icon(CupertinoIcons.delete , size: 20,)),
                      ),
                      const Spacer()
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
    ),);
  }

  experienceStep() {
    return UiDecoration().stepperContainer("Driver Experience",  Form(
      key: formKey5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FocusScope(
            child: FocusTraversalGroup(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Spacer(),

                  // Organization Name
                  Expanded(flex: 2, child: FormWidgets().onlyAlphabetField2("Organization Name", "Organization Name", organizationNameController, context, focusNode: focusNode5)),
                  const SizedBox(width: 50,),

                  // From Date
                  Expanded(
                    flex: 2,
                    child: FormWidgets().formDetails22('From',TextFormField(
                      readOnly: true,
                      controller: fromDateController,
                      decoration:
                      UiDecoration().dateFieldDecoration('From Date'),
                      onTap: () {
                        UiDecoration()
                            .showDatePickerDecoration(context)
                            .then((value) {
                          setState(() {
                            String month =
                            value.month.toString().padLeft(2, '0');
                            String day = value.day.toString().padLeft(2, '0');
                            fromDateController.text = "$day-$month-${value.year}";
                          });
                        });
                      },

                      validator: (value) {
                        if(value == null || value == ''){
                          return "Please Select Date";
                        }
                        return null;
                      },
                    ),),
                  ),

                  const SizedBox(width: 50,),

                  // To Date
                  Expanded(
                    flex: 2,
                    child: FormWidgets().formDetails22('To',TextFormField(
                      readOnly: true,
                      controller: toDateController,
                      decoration:
                      UiDecoration().dateFieldDecoration('To Date'),
                      onTap: () {
                        UiDecoration()
                            .showDatePickerDecoration(context)
                            .then((value) {
                          setState(() {
                            String month =
                            value.month.toString().padLeft(2, '0');
                            String day = value.day.toString().padLeft(2, '0');
                            toDateController.text = "$day-$month-${value.year}";
                          });
                        });
                      },

                      validator: (value) {
                        if(value == null || value == ''){
                          return "Please Select Date";
                        }
                        return null;
                      },
                    ),),
                  ),
                  const SizedBox(width: 50,),

                  // No Of Months
                  Expanded(flex: 2, child: FormWidgets().numberField2("No Of Months", "No Of Months", noOfMonthsController, context)),
                  const SizedBox(width: 50,),

                  // Reason For Leaving
                  Expanded(flex: 2, child: FormWidgets().onlyAlphabetField2("Reason For Leaving", "Reason For Leaving", reasonForLeavingController, context)),
                  const SizedBox(width: 50,),

                  // add button
                  Column(
                    children: [
                      TextDecorationClass().fieldTitle(''),
                      Container(
                        decoration: BoxDecoration(color: ThemeColors.primaryColor, borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              if(organizationNameController.text.isEmpty){
                                AlertBoxes.flushBarErrorMessage("Enter Organization Name", context);
                              } else if(fromDateController.text.isEmpty){
                                AlertBoxes.flushBarErrorMessage("Enter From Date", context);
                              } else if(toDateController.text.isEmpty){
                                AlertBoxes.flushBarErrorMessage("Enter To Date", context);
                              } else if(noOfMonthsController.text.isEmpty){
                                AlertBoxes.flushBarErrorMessage("Enter No. Of Months", context);
                              } else if(reasonForLeavingController.text.isEmpty){
                                AlertBoxes.flushBarErrorMessage("Enter Reason For Leaving", context);
                              } else{
                                setState(() {
                                  experienceList.add({"organization_name": organizationNameController.text, "from_date": fromDateController.text , "to_date": toDateController.text , "no_of_months": noOfMonthsController.text , "reason_for_leaving": reasonForLeavingController.text});
                                  organizationNameController.clear();
                                  fromDateController.clear();
                                  toDateController.clear();
                                  noOfMonthsController.clear();
                                  reasonForLeavingController.clear();
                                });
                              }
                            },
                            icon: const Icon(CupertinoIcons.add)),
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50,),
          /// Experience List Divider

          experienceList.isEmpty ? const SizedBox() :
          Row(
            children: const [
              Expanded(child: SizedBox(),),
              Text("Experience List" , style: TextStyle(fontWeight: FontWeight.bold),),  SizedBox(width: 10,),
              Expanded(
                  flex: 12,
                  child: Divider()),
              Spacer()
            ],
          ),
          ListView.builder(
            controller: scrollController,
            itemCount: experienceList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),

                      // Organization Name
                      Expanded(flex: 2, child: UiDecoration().addMore(experienceList[index]["organization_name"].toString())),
                      const SizedBox(
                        width: 50,
                      ),
                      // From Date
                      Expanded(flex: 2, child: UiDecoration().addMore(experienceList[index]["from_date"].toString())),
                      const SizedBox(
                        width: 50,
                      ),
                      // To Date
                      Expanded(flex: 2, child: UiDecoration().addMore(experienceList[index]["to_date"].toString())),
                      const SizedBox(
                        width: 50,
                      ),
                      // No Of Months
                      Expanded(flex: 2, child: UiDecoration().addMore(experienceList[index]["no_of_months"].toString())),
                      const SizedBox(
                        width: 50,
                      ),
                      // Reason For Leaving
                      Expanded(flex: 2, child: UiDecoration().addMore(experienceList[index]["reason_for_leaving"].toString())),
                      const SizedBox(
                        width: 50,
                      ),

                      // delete button
                      Container(
                        decoration: BoxDecoration(color: ThemeColors.darkRedColor, borderRadius: BorderRadius.circular(5)),
                        child: IconButton(color: Colors.white, onPressed: () {
                          setState(() {
                            experienceList.removeAt(index);
                          });
                        }, icon:  const Icon(CupertinoIcons.delete , size: 20,)),
                      ),
                      const Spacer()
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
    ),
    );
  }

  driverPictureStep() {
    return SingleChildScrollView(
      child: Column(
        children: [

          kIsWeb ?
          Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Center(child: imgPathWeb == null ? const Text("WEB Please Select Image") :  Image.memory(imgPathWeb),),
          ) :
          Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Center(child: imgPath == null ? const Text("Please Select Image") :  Image.file(File(imgPath!)),),
          ),

          // FormWidgets().onlyAlphabetField("Document Name","", docNameController, context),

          TextButton(
              onPressed: () {
                kIsWeb ? pickFileWeb() : pickFile();
                },
              child: const Text("Pick Image")),

          ((img == null || img == "") && (imgPath == null || imgPath == ""))
           ?
          const Text("No file chosen" , style: TextStyle(fontSize: 13),) :
          const Text("Image Picked ✔" , style: TextStyle(fontSize: 13 , color: Colors.green),)

        ],
      ),
    );
  }

  // Future uploadFile() async {
  //   var dio = Dio();
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   try {
  //     if (result != null) {
  //       File file = File(result.files.single.path ?? " ");
  //
  //       String fileName = file.path.split('/').last;
  //
  //       String filePath = file.path;
  //
  //       dio.options.headers["token"] = Auth.token;
  //
  //       FormData data =
  //
  //       FormData.fromMap({
  //         'driver_id': driverID.toString(),
  //         'drivers_document_title': fileName,
  //         'drivers_document_path': await MultipartFile.fromFile(filePath, filename: fileName),
  //       });
  //
  //       var response = await dio.post("${GlobalVariable.baseURL}VehicleDriver/DocumentStore", data: data,
  //           onSendProgress: (int sent, int total) {
  //
  //           }
  //       );
  //
  //       if (response.data['success'] == true) {
  //         AlertBoxes.flushBarSuccessMessage(response.data['message'], context);
  //         setState(() {
  //           update = false;
  //           // vehicleDocFetchApiFunc();
  //         });
  //       } else {
  //         AlertBoxes.flushBarErrorMessage(response.data['message'], context);
  //       }
  //
  //     } else {
  //
  //     }
  //   }
  //   catch(e){
  //     return AlertBoxes.flushBarErrorMessage("$e", context);
  //   }
  //
  // }

  Future uploadFile() async {

    var dio = Dio();

    try {
      // dio
      dio.options.headers["token"] = Auth.token;

      FormData data =
      // Create form
      FormData.fromMap({
        'driver_id': driverID.toString(),
        'drivers_document_title': "driverImage"   /*docNameController.text*/,
        'drivers_document_path': img
      });

      var response = await dio.post("${GlobalVariable.baseURL}VehicleDriver/DocumentStore", data: data,
          onSendProgress: (int sent, int total) {
            debugPrint("sent:: $sent    TOTAL:: $total");
          }
      );

      if (response.data['success'] == true) {
        AlertBoxes.flushBarSuccessMessage(response.data['message'], context);
        setState(() {
          update = false;
        });
      } else {
        AlertBoxes.flushBarErrorMessage(response.data['message'], context);
      }
    }
    catch(e){
      return AlertBoxes.flushBarErrorMessage("catch ERROR: $e", context);
    }

  }

  /// Function to pick file
  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom ,  allowedExtensions: ['JPEG', 'JPG','PNG', 'GIF', 'TIFF', 'BMP', 'SVG', 'WebP'],);
    if (result != null) {

      File file = File(result.files.single.path ?? " ");
      // String fileName = file.path.split('/').last;  /* getting file name */
      File imageFile = File(file.path);

      // to display selected image

      imgPath = result.files.single.path ?? " ";

      // Uint8List? fileBytes = result.files.first.bytes;

      int sizeInBytes = imageFile.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);

      // print("inBytes: ${imageFile.lengthSync()}");
      // print("inMB: $sizeInMb");

      if(sizeInMb > 2){
        setState(() {
          img = "";
          imgPath = null;

        });
        AlertBoxes.flushBarErrorMessage("Upload file less then 2mb", context);
      } else {
        imageBytes = imageFile.readAsBytesSync();
        img = base64Encode(imageBytes);
        setState(() {});
      }
    }
  }

  Future pickFileWeb() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom ,  allowedExtensions: ['JPEG', 'JPG','PNG', 'GIF', 'TIFF', 'BMP', 'SVG', 'WebP'],);
    Uint8List? fileBytes = result?.files.first.bytes;
    imgPathWeb = fileBytes;
    img = base64Encode(imgPathWeb);
    setState(() {});
  }

  // API
  Future driverProfileApi() async {

    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDriver/ProfileStore");

    var body = {
      'drivers_group_id': driverGroupId.toString(),
      'driver_name': driverNameController.text,
      'driver_ro': driverResidentAddressController.text,
      'permanent_address': driverPermanentAddressController.text,
      'driver_mobile_number': driverMobNo1Controller.text,
      'driver_mobile_number_second': driverMobNo2Controller.text,
      'driver_dob': driverDOBControllerApi.text,
      'driver_age': driverAgeController.text,
      'driver_marital_status': maritalStatusDropdownValue,
      'driver_habits': driverHabitsController.text,
      'driver_accidents': driverAccidentsHistoryController.text,
      'driver_father': driverFatherNameController.text,
      'driver_father_age': driverFatherAgeController.text,
      'driver_mother': driverMotherNameController.text,
      'driver_mother_age': driverMotherAgeController.text,
      'driver_wife': driverWifeNameController.text,
      'driver_wife_age': driverWifeAgeController.text,
      'driver_license_number': driverLicenseNumberController.text,
      'driver_license_date_of_issue': driverLicenseDateOfdIssueControllerApi.text,
      'driver_license_issuing_authority': licenseIssuingAuthorityController.text,
      'driver_license_validity_from': licenseValidityFromControllerApi.text,
      'driver_license_validity_to': licenseValidityToControllerApi.text,
      'driver_license_type': licenseTypeDropdownValue,
      'driver_login_id': loginIDController.text,
      'driver_login_password': passwordController.text,
    };

    var response = await http.post(url, headers: headers, body: body);

    return response.body.toString();
  }

  Future driverGuarantorApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDriver/GuaranteeStore");
    var body = {
      'driver_id': driverID.toString(),
      'guarantor_name': guarantorNameController.text,
      'guarantor_mobile_number': guarantorMobileNumberController.text
    };
    var response = await http.post(url , headers: headers , body: body);
    return response.body.toString();
  }

  Future driverFriendsApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDriver/RelativeStore");
    var body = {
      'driver_id': driverID.toString(),
      'relative_name': friendNameController.text,
      'relative_address': friendAddressController.text,
      'relative_mobile_number': friendMobileNumberController.text
    };
    var response = await http.post(url , headers: headers , body: body);
    return response.body.toString();
  }

  Future driverChildrenApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDriver/ChildrenStore");
    var body = {
      'driver_id': driverID.toString(),
      'children_name': childrenNameController.text,
      'children_age': childrenAgeController.text
    };
    var response = await http.post(url , headers: headers , body: body);
    return response.body.toString();
  }

  Future driverExperienceApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDriver/ExperienceStore");
    var body = {
      'driver_id': driverID.toString(),
      'organization_name': organizationNameController.text,
      'no_of_months': noOfMonthsController.text,
      'from_date': fromDateController.text,
      'to_date': toDateController.text,
      'reason_for_leaving': reasonForLeavingController.text
    };
    var response = await http.post(url , headers: headers , body: body);
    return response.body.toString();
  }

  Future driverProfileUpdateApi() async {
    var headers = {
      'token': Auth.token,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDriver/ProfileStore");
    var body = {
      'drivers_group_id': driverGroupId.toString(),
      'driver_name': driverNameController.text,
      'driver_ro': driverResidentAddressController.text,
      'permanent_address': driverPermanentAddressController.text,
      'driver_mobile_number': driverMobNo1Controller.text,
      'driver_mobile_number_second': driverMobNo2Controller.text,
      'driver_dob': driverDOBControllerApi.text,
      'driver_age': driverAgeController.text,
      'driver_marital_status': maritalStatusDropdownValue,
      'driver_habits': driverHabitsController.text,
      'driver_accidents': driverAccidentsHistoryController.text,
      'driver_father': driverFatherNameController.text,
      'driver_father_age': driverFatherAgeController.text,
      'driver_mother': driverMotherNameController.text,
      'driver_mother_age': driverMotherAgeController.text,
      'driver_wife': driverWifeNameController.text,
      'driver_wife_age': driverWifeAgeController.text,
      'driver_license_number': driverLicenseNumberController.text,
      'driver_license_date_of_issue': driverLicenseDateOfdIssueControllerApi.text,
      'driver_license_issuing_authority': licenseIssuingAuthorityController.text,
      'driver_license_validity_from': licenseValidityFromControllerApi.text,
      'driver_license_validity_to': licenseValidityToControllerApi.text,
      'driver_license_type': licenseTypeDropdownValue,
      'driver_login_id': loginIDController.text,
      'driver_login_password': passwordController.text,
      'driver_id' : GlobalVariable.driverId.toString()
    };
    var response = await http.post(url, headers: headers, body: body);

    return response.body.toString();
  }

  getDriverGroupId() {
    for (int i = 0; i < driverGroupList.length; i++) {
      if (selectDriverCityDropdownValue == driverGroupList[i]['driver_group_name']) {
        driverGroupId = driverGroupList[i]['drivers_group_id'];
        GlobalVariable.driverGroupId = driverGroupList[i]['drivers_group_id'];

      }
    }
  }

  getDriverGroupName() {
    for (int i = 0; i < driverGroupList.length; i++) {
      if (GlobalVariable.driverGroupId == driverGroupList[i]['drivers_group_id']) {
        selectDriverCityDropdownValue = driverGroupList[i]['driver_group_name'];
        driverGroupId = driverGroupList[i]['drivers_group_id'];
      }
    }
  }

  Future driverEditApi() async {
    var headers = {
      'token': Auth.token
    };
    var url = Uri.parse('${GlobalVariable.baseURL}VehicleDriver/ProfileEdit?driver_id=${GlobalVariable.driverId}');
    var response = await http.get(url,headers: headers);
    return response.body.toString();
  }

  // Dropdown Api
  Future cityDropDownApi() async {
    var headers = {'token' : Auth.token};
    var url = Uri.parse("${GlobalVariable.baseURL}VehicleDriver/GroupFetch");
    var response = await http.get(url , headers: headers);
    return response.body.toString();
  }

// Future driverGuarantor() async {
//   var url = Uri.parse("${GlobalVariable.baseUrl}api/pfc/...");
//   var body = {
//     'guarantor_name': guarantorNameController.text,
//     'guarantor_mobile': guarantorMobileNumberController.text,
//   };
//   var response = await http.post(url, body: body);
//   return response.body.toString();
// }
}

