import 'package:flutter/material.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class CustomMenuButton extends StatefulWidget {
  final List buttonNames;
  const CustomMenuButton({Key? key, required this.buttonNames}) : super(key: key);
  @override
  State<CustomMenuButton> createState() => _CustomMenuButtonState();
}

class _CustomMenuButtonState extends State<CustomMenuButton> {
  @override
  void initState() {
    print("initList: ${widget.buttonNames.length}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        height: 40,
        width: 80,
        decoration: BoxDecoration(
          // color: Colors.white,
            color: ThemeColors.primary,
            // border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 2,
                  spreadRadius: 3,
                  offset: const Offset(-3, 0.0)
              ),
            ]
        ),
        child: PopupMenuButton(
          elevation: 10,
          tooltip: 'show pages',
          shape: OutlineInputBorder(borderSide: BorderSide(color: ThemeColors.primary)),
          constraints: const BoxConstraints(minWidth: 200),
          onSelected: (value) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => widget.buttonNames[value]['class_name'],));
          },
          icon: const Icon(Icons.menu, color: Colors.white),
          // itemBuilder: (context) {
          //   return List.generate( widget.buttonNames.length, (index) {
          //     return
          //
          //         List.generate(2, (index2) {
          //           return PopupMenuItem(
          //               height: 10,
          //               enabled: false,
          //               textStyle: TextStyle(color: Colors.grey.shade700),
          //               child: Column(
          //                 children: [
          //                   const Divider(),
          //                   Text(widget.buttonNames[index]['name']),
          //                   const Divider(),
          //                 ],
          //               )
          //           );
          //         });
          //   });
          // },
          /// ===========
          itemBuilder: (context) {
            return
            /// Voucher section
              [
                PopupMenuItem(
                  height: 10,
                  enabled: false,
                  textStyle: TextStyle(color: Colors.grey.shade700),
                  child:
                  Column(
                    children: [
                      Divider(color: ThemeColors.buttonDropdownColor),
                      Text("Vouchers", style: TextStyle(color: ThemeColors.buttonDropdownColor)),
                       Divider(color: ThemeColors.buttonDropdownColor,),
                    ],
                  )
                ),
              ] +
              List.generate(5, (index) => PopupMenuItem(
              value: index,
              child:  Text(widget.buttonNames[index]['btn_name'] ,style: TextDecorationClass().dashboardBtn(),),),) +
                  /// Adv section
                  [
                    PopupMenuItem(
                        height: 10,
                        enabled: false,
                        textStyle: TextStyle(color: Colors.grey.shade700),
                        child: Column(
                          children: [
                            Divider(color: ThemeColors.buttonDropdownColor),
                            Text("Advance Vouchers", style: TextStyle(color: ThemeColors.buttonDropdownColor)),
                            Divider(color: ThemeColors.buttonDropdownColor,),
                          ],
                        )
                    ),
                  ] +
                  List.generate(5, (index) => PopupMenuItem(
                    value: index,
                    child:  Text(widget.buttonNames[index+5]['btn_name'] ,style: TextDecorationClass().dashboardBtn(),),),) +
                  /// Salary
                  [
                    PopupMenuItem(
                        height: 10,
                        enabled: false,
                        textStyle: TextStyle(color: Colors.grey.shade700),
                        child: Column(
                          children:  [
                            Divider(color: ThemeColors.buttonDropdownColor),
                            Text("Salary", style: TextStyle(color: ThemeColors.buttonDropdownColor)),
                            Divider(color: ThemeColors.buttonDropdownColor,),
                          ],
                        )
                    ),
                  ] +
                  List.generate(2, (index) => PopupMenuItem(
                    value: index,
                    child:  Text(widget.buttonNames[index+10]['btn_name'] ,style: TextDecorationClass().dashboardBtn(),),),) +
                  /// Others
                  [
                    PopupMenuItem(
                        height: 10,
                        enabled: false,
                        textStyle: TextStyle(color: Colors.grey.shade700),
                        child: Column(
                          children:  [
                            Divider(color: ThemeColors.buttonDropdownColor,),
                            Text("Others", style: TextStyle(color: ThemeColors.buttonDropdownColor)),
                            Divider(color: ThemeColors.buttonDropdownColor,),
                          ],
                        )
                    ),
                  ] +
                  List.generate(1, (index) => PopupMenuItem(
                    value: index,
                    child:  Text(widget.buttonNames[index+12]['btn_name'] ,style: TextDecorationClass().dashboardBtn(),),),);
          },
        ),

      ),
    );
  }
}
