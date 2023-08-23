import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/utility/colors.dart';

class NavigationMenuButton extends StatefulWidget {
  NavigationMenuButton({Key? key, required this.showNavigationMenu, required this.onTap, required this.onEnter, required this.onExit}) : super(key: key);
  bool showNavigationMenu;
  final void Function()? onTap;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;

  @override
  State<NavigationMenuButton> createState() => _NavigationMenuButtonState();
}

class _NavigationMenuButtonState extends State<NavigationMenuButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: widget.onEnter,
        onExit: widget.onExit,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 40,
          width: 80,
          decoration: BoxDecoration(
              color: widget.showNavigationMenu ? ThemeColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: ThemeColors.primary)
          ),
          child:  Icon(Icons.menu, color: widget.showNavigationMenu ? Colors.white : ThemeColors.primary),
        ),
      ),
    );
  }
}
