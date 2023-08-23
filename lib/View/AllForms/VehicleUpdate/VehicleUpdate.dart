import 'package:flutter/material.dart';

class MyDatePicker extends StatefulWidget {
  @override
  _MyDatePickerState createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: const Text('Select Date'),
        ),
        const SizedBox(height: 16),
        Text(
          'Selected Date: ${selectedDate != null ? selectedDate.toString() : "No date selected"}',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

class DateTimePickerCustom extends StatefulWidget {
  const DateTimePickerCustom({Key? key}) : super(key: key);

  @override
  State<DateTimePickerCustom> createState() => _DateTimePickerCustomState();
}

class _DateTimePickerCustomState extends State<DateTimePickerCustom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode()); // Remove focus from any focused fields
        },
        child: MyDatePicker(),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:pfc/responsive.dart';
// import 'package:pfc/utility/colors.dart';
// import 'package:pfc/utility/styles.dart';
//
// class VehicleUpdate extends StatefulWidget {
//   const VehicleUpdate({Key? key}) : super(key: key);
//
//   @override
//   State<VehicleUpdate> createState() => _VehicleUpdateState();
// }
//
// class _VehicleUpdateState extends State<VehicleUpdate> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: UiDecoration.appBar("Vehicle Update"),
//       body: Responsive(
//           /// Mobile
//           mobile: const Center(child: Text("Mobile"),),
//
//           /// Tablet
//           tablet: const Center(child: Text("Tablet"),),
//
//           /// Desktop
//           desktop: vehicleDocs(),
//       ),
//     );
//   }
//
//   vehicleDocs(){
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Vehicle Information
//         Container(
//           width: 500,
//           height: 300,
//           padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 5),
//           margin: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             border: Border.all(color: ThemeColors.textFormFieldColor),
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: Wrap(
//             runSpacing: 10,
//             spacing: 10,
//             children: [
//               UiDecoration().vehicleInfo("Vehicle No:", "MH1974 6675"),
//               UiDecoration().vehicleInfo("Company:", "Eicher"),
//               UiDecoration().vehicleInfo("Chassis No:", "331U3S03323"),
//               UiDecoration().vehicleInfo("Engine No:", "55355933943"),
//               UiDecoration().vehicleInfo("Type:", "Type"),
//               UiDecoration().vehicleInfo("No. Of Wheels:", "16"),
//               UiDecoration().vehicleInfo("OnLoad Avg:", "16"),
//               UiDecoration().vehicleInfo("Empty Avg:", "22"),
//               UiDecoration().vehicleInfo("Manufacturing Date:", "22-04-2021"),
//               UiDecoration().vehicleInfo("Registration Date:", "22-06-2021"),
//               UiDecoration().vehicleInfo("Status:", "Booked"),
//             ],
//           )
//         ),
//         Container(
//             width: 500,
//             color: Colors.red,
//             margin: const EdgeInsets.all(20),
//             child:  const ListTile(leading: Text("Doc 1"),))
//       ],
//     );
//   }
//
// }
