import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  bool isSelected;
  String title;
  Color primaryColor;
  Color secondaryColor;
  IconData icon;
  VoidCallback onPress;
  
  NavigationButton({super.key,
    required this.isSelected,
    required this.onPress,
    required this.title ,
    required this.primaryColor ,
    required this.secondaryColor ,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
        height: 70,
        width: 170,
        decoration:  BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: primaryColor ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title , style:  TextStyle(color: isSelected ? Colors.white : primaryColor , fontWeight: FontWeight.w500 , fontSize: 18),),
                const SizedBox(width: 5,),
                Container(
                  height: 45,
                  width: 45,
                  decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Colors.lightGreen.shade100
                      color: isSelected ? Colors.white : secondaryColor
                  ),
                  child:  Icon(
                    icon, color: primaryColor,),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
