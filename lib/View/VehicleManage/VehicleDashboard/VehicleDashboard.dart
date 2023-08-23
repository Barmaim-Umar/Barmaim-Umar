import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class VehicleDashboard extends StatefulWidget {
  const VehicleDashboard({Key? key}) : super(key: key);

  @override
  State<VehicleDashboard> createState() => _VehicleDashboardState();
}

class _VehicleDashboardState extends State<VehicleDashboard> {

  TextEditingController addDocumentController = TextEditingController();

  List<Widget> documentList = [
    UiDecoration().vehicleDocCard(Colors.blue, "assets/truckInsurance.png", "INSURANCE POLICY (324)", "30", "0", "68"),
    UiDecoration().vehicleDocCard(Colors.orange, "assets/truckHealth.png", "FITNESS (24)", "26", "10", "8"),
    UiDecoration().vehicleDocCard(const Color(0XFF37cdcc), "assets/road.png", "STATE ROAD TAX (204)", "96", "150", "73"),
    UiDecoration().vehicleDocCard(const Color(0XFFef12b8), "assets/docIcon.png", "MH PERMIT (407)", "5", "13", "17"),
    UiDecoration().vehicleDocCard(const Color(0XFF605da2), "assets/docIcon.png", "ALL INDIA PERMIT (701)", "18", "22", "52"),
    UiDecoration().vehicleDocCard(const Color(0XFFd71b60), "assets/car_puc.png", "PUC (394)", "0", "1", "22"),
    UiDecoration().vehicleDocCard(const Color(0XFF3c9871), "assets/speed.png", "SPEED GOVERNANCE (158)", "0", "0", "122"),
    UiDecoration().vehicleDocCard(const Color(0XFFe99ea9), "assets/license.png", "DRIVER LICENSE ", "545", "0", "2"),
    UiDecoration().vehicleDocCard(const Color(0XFFe87650), "assets/permit.png", "KARNATAKA PERMIT (16)", "0", "0", "0"),
    UiDecoration().vehicleDocCard(const Color(0XFFe1A650), "assets/tax.png", "KARNATAKA TAX (16)", "0", "0", "6"),
    UiDecoration().vehicleDocCard(const Color(0XFF94b2eb), "assets/permit.png", "TELANGANA PERMIT (16)", "0", "0", "0"),
    UiDecoration().vehicleDocCard(const Color(0XFFaa899d), "assets/tax.png", "TELANGANA TAX (16)", "16", "0", "0"),
  ];

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: UiDecoration.appBar("Vehicle Dashboard"),
      body: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Dashboard
            Expanded(
              child: Container(
                color: Colors.transparent,
                margin: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 0 , top: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [
                            // BoxShadow(color: ThemeColors.boxShadow , blurRadius: 5.0 , spreadRadius: 3),
                          ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                const Text("Vehicle Dashboard", style: TextStyle(fontWeight: FontWeight.w500 , fontSize: 25),),

                                /// Buttons
                                Row(children: [
                                  ElevatedButton(onPressed: () {},
                                      style: ButtonStyles.customiseButton(Colors.orangeAccent, Colors.white, 50.0, 40.0),
                                      child: TextDecorationClass().buttonText("Vehicle Details")),
                                  const SizedBox(width: 5,),
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyles.customiseButton(ThemeColors.primaryColor, Colors.white, 50.0, 40.0),
                                      child: TextDecorationClass().buttonText("View Documents Details")),
                                  const Spacer(),

                                  /// Add document button
                                  InkWell(
                                    onTap: () {addDocument();},
                                    child: Container  (
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(7),
                                        boxShadow: [
                                          BoxShadow(color: Colors.grey.shade400 ,
                                          blurRadius: 3,
                                            spreadRadius: 1
                                          )
                                        ]
                                      ),
                                      child: Row(
                                        children: [
                                          // icon
                                          Container(
                                            decoration: const BoxDecoration(
                                                color: ThemeColors.whiteColor,
                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(7) , topLeft: Radius.circular(7))
                                            ),
                                            width: 25,
                                            height: 40,
                                            child: const Icon(Icons.add , color: ThemeColors.primaryColor,size: 30),
                                          ),
                                          const SizedBox(height: 40,child: VerticalDivider()),
                                          const Text("Add" , style: TextStyle(color: ThemeColors.primaryColor , fontWeight: FontWeight.bold , fontSize: 20),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                ),
                                const SizedBox(height: 20,),

                                // Container(
                                //   width: 300,
                                //   decoration:  BoxDecoration(
                                //     color: Colors.white,
                                //     borderRadius: BorderRadius.circular(7),
                                //     border: Border.all(color: ThemeColors.primaryColor),
                                //     boxShadow:  const [
                                //       BoxShadow(
                                //         color: Colors.transparent ,
                                //       spreadRadius: 1,
                                //       blurRadius: 2
                                //     )],
                                //   ),
                                //   child: Row(
                                //     children: [
                                //       Container(
                                //         width: 70,
                                //         height: 110,
                                //         decoration: const BoxDecoration(
                                //           color: Colors.blue,
                                //           borderRadius: BorderRadius.only(topLeft: Radius.circular(7) , bottomLeft: Radius.circular(7))
                                //         ),
                                //         child: const Icon(Icons.car_repair , color: Colors.white),
                                //       ),
                                //       const SizedBox(width: 5,),
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           TextDecoration().title1("Insurance Policy" , ThemeColors.primaryColor),
                                //           TextDecoration().currentMonth("30"),
                                //           const Divider(),
                                //           TextDecoration().nextMonth("0"),
                                //           const Divider(),
                                //           TextDecoration().docExpired("68")
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),

                                Expanded(
                                  child: MasonryGridView.builder(gridDelegate: const SliverSimpleGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 400),
                                  shrinkWrap: true,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  itemCount: documentList.length,
                                  ///
                                  itemBuilder: (context, index) => documentList[index],

                                    // children: [
                                    //   UiDecoration().vehicleDocCard(Colors.blue, "assets/truckInsurance.png", "INSURANCE POLICY (324)", "30", "0", "68"),
                                    //   UiDecoration().vehicleDocCard(Colors.orange, "assets/truckHealth.png", "FITNESS (24)", "26", "10", "8"),
                                    //   UiDecoration().vehicleDocCard(const Color(0XFF37cdc4), "assets/road.png", "STATE ROAD TAX (204)", "96", "150", "73"),
                                    //   UiDecoration().vehicleDocCard(const Color(0XFFef12b8), "assets/docIcon.png", "MH PERMIT (407)", "5", "13", "17"),
                                    //   UiDecoration().vehicleDocCard(const Color(0XFF605da2), "assets/docIcon.png", "ALL INDIA PERMIT (701)", "18", "22", "52"),
                                    //   UiDecoration().vehicleDocCard(const Color(0XFFd71b60), "assets/carPuc.png", "PUC (394)", "0", "1", "22"),
                                    //   UiDecoration().vehicleDocCard(const Color(0XFF3c9871), "assets/speed.png", "SPEED GOVERNANCE (158)", "0", "0", "122"),
                                    //   UiDecoration().vehicleDocCard(const Color(0XFFe99ea9), "assets/license.png", "DRIVER LICENSE ", "545", "0", "2"),
                                    //   UiDecoration().vehicleDocCard(const Color(0XFFe87650), "assets/permit.png", "KARNATAKA PERMIT (16)", "0", "0", "0"),
                                    //   UiDecoration().vehicleDocCard(const Color(0XFFe1A650), "assets/tax.png", "KARNATAKA TAX (16)", "0", "0", "6"),
                                    //   UiDecoration().vehicleDocCard(const Color(0XFF94b2eb), "assets/permit.png", "TELANGANA PERMIT (16)", "0", "0", "0"),
                                    //   UiDecoration().vehicleDocCard(const Color(0XFFaa899d), "assets/tax.png", "TELANGANA TAX (16)", "16", "0", "0"),
                                    // ],
                                  ),
                                )

                              ],
                            ),
                          ),
                        )),
                    const SizedBox(width: 5,),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
  
  addDocument(){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Add Document"),
        content:     Container(
          width: 300,
          decoration:  BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            // border: Border.all(color: ThemeColors.primaryColor),
            boxShadow:   [
              BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 1,
                  blurRadius: 3
              )],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start ,
            children: [
              Container(
                width: 70,
                height: 110,
                decoration:  const BoxDecoration(
                    color: ThemeColors.primaryColor,
                    borderRadius:  BorderRadius.only(topLeft: Radius.circular(7) , bottomLeft: Radius.circular(7))
                ),
                child: Image.asset("assets/tax.png" , color: Colors.white, height: 100,),
              ),
              const SizedBox(width: 5,),
              SizedBox(
                height: 110,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3,),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: addDocumentController,
                      decoration: UiDecoration().outlineTextFieldDecoration("Enter Document Name", ThemeColors.primaryColor),
                    ),
                  ),
                    const SizedBox( height: 3 , width: 190,child: Divider(),),

                    TextDecorationClass().currentMonth("0"),
                    const SizedBox( height: 3, width: 190,child: Divider(),),

                    TextDecorationClass().nextMonth("0"),
                    const SizedBox( height: 3, width: 190,child: Divider(),),

                    TextDecorationClass().docExpired("0"),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: () {
            setState(() {
              documentList.add(UiDecoration().vehicleDocCard(const Color(0XFFaa899d), "assets/tax.png", addDocumentController.text, "16", "0", "0"),);
              Navigator.pop(context);
            });

          }, child: const Text("Add"))
        ],
      );
    },);
  }

}
