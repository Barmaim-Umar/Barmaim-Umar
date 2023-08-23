import 'package:flutter/material.dart';
import 'package:pfc/utility/colors.dart';

class CustomButton extends StatefulWidget {
  final Widget page;
  final String name;

  const CustomButton({Key? key, required this.name, required this.page}) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isTapped = false;
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
      },
      child: GestureDetector(
        onTapUp: (v) {
          setState(() {
            isTapped = false;
          });
        },
        onTapDown: (v) {
          setState(() {
            isTapped = true;
          });
        },
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => widget.page,
              ));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 100,
          width: 300,
          decoration: BoxDecoration(
              color: isHover ? Colors.blue.shade200 : Colors.white,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                isHover
                    ? BoxShadow(
                        color: isHover ? Colors.black38 : ThemeColors.primary,
                        offset: const Offset(6, 6),
                      )
                    : BoxShadow(
                        color: ThemeColors.primary,
                        offset: const Offset(0, 0),
                      ),
              ],
              border: Border.all(color: isHover ? Colors.black : ThemeColors.primary, width: 2)),
          child: Center(
              child: Text(
            widget.name,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: isHover ? Colors.white : ThemeColors.primary),
          )),
        ),
      ),
    );
  }
}



