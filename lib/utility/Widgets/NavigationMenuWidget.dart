import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pfc/utility/colors.dart';

class NavigationMenuWidget extends StatefulWidget {
  const NavigationMenuWidget({Key? key, required this.buttonNames, this.onEnter, this.onExit}) : super(key: key);
  final List buttonNames ;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;

  @override
  State<NavigationMenuWidget> createState() => _NavigationMenuWidgetState();
}

class _NavigationMenuWidgetState extends State<NavigationMenuWidget> {
  bool showNavigationMenu = false;
  int currentIndex = -1;
  int currentIndex2 = -1;
  bool animatedHover = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      top: 60,
      child: MouseRegion(
        onEnter: widget.onEnter ?? (event) {
          setState(() {
            showNavigationMenu = true;
          });
        },
        onExit: widget.onExit ?? (event) {
          Future.delayed(
            const Duration(milliseconds: 200),
                () {
              setState(() {
                showNavigationMenu = false;
              });
            },
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            width: 180 * double.parse(widget.buttonNames.length.toString()), // 180 --> is the width of a single section
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: ThemeColors.primary)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 400,

                  /// Horizontal ListView
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.buttonNames.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return MouseRegion(
                        onEnter: (event) {
                          currentIndex = index;
                        },
                        child: Container(
                          height: 300,
                          width: 180,
                          padding: const EdgeInsets.only(left: 7, top: 7),
                          decoration: BoxDecoration(color: index == 0 || index % 2 == 0 ? Colors.grey.shade100 : Colors.white, borderRadius: BorderRadius.circular(3)),
                          margin: const EdgeInsets.only(right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Section Name
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(colors: currentIndex == index ? [ThemeColors.primaryColor, ThemeColors.primaryColor] : [ThemeColors.primaryColor, ThemeColors.primaryColor])
                                      .createShader(bounds);
                                },
                                child: Text(
                                  widget.buttonNames[index]['name'],
                                  style: TextStyle(
                                    color: ThemeColors.menuTextColor,
                                    fontWeight: currentIndex == index ? FontWeight.w400 : FontWeight.w400,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                /// Vertical ListView
                                child: ListView.builder(
                                  itemCount: widget.buttonNames[index]['values'].length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index2) {
                                    return MouseRegion(
                                      onEnter: (event) {
                                        setState(() {
                                          currentIndex2 = index2;
                                          animatedHover = true;
                                        });
                                      },
                                      onExit: (event) {
                                        setState(() {
                                          animatedHover = false;
                                        });
                                      },
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => widget.buttonNames[index]['values'][index2]['class_name'],
                                              ));
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 100),
                                          margin: const EdgeInsets.symmetric(vertical: 2),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: currentIndex2 == index2 ? Colors.transparent : Colors.transparent,
                                              )
                                            ],
                                          ),
                                          child: AnimatedDefaultTextStyle(
                                            style: TextStyle(
                                                color: currentIndex2 == index2 && currentIndex == index ? ThemeColors.primary : Colors.grey.shade700,
                                                fontWeight: currentIndex2 == index2 && currentIndex == index ? FontWeight.bold : FontWeight.w400,
                                                fontSize: 16),
                                            duration: const Duration(milliseconds: 100),

                                            /// page names
                                            child: Text(widget.buttonNames[index]['values'][index2]['btn_name']),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
