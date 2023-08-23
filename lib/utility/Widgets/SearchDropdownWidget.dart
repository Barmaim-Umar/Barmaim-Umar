// ignore_for_file: file_names

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/utility/colors.dart';

class SearchDropdownWidget extends StatefulWidget {
  final List<String> dropdownList;
  final String hintText;
  final Function(String?)? onChanged;
  final String selectedItem;
  final bool showSearchBox ;
  final double maxHeight;
  final bool optional;
  final bool showClearButton;
  final FocusNode? focusNode;
  Color? fillColor;
  bool? textColor = false;
  Color? borderColor;

  SearchDropdownWidget({Key? key,
    required this.dropdownList,
    required this.hintText,
    required this.onChanged,
    required this.selectedItem ,
    this.showSearchBox = true,
    this.maxHeight = 300,
    this.optional = false,
    this.showClearButton = false,
    this.focusNode,
    this.fillColor,
    this.textColor,
    this.borderColor
  }) : super(key: key);

  @override
  State<SearchDropdownWidget> createState() => _SearchDropdownWidgetState();
}

class _SearchDropdownWidgetState extends State<SearchDropdownWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: TextTheme(subtitle1: TextStyle(color: widget.selectedItem.isEmpty ? Colors.grey.shade600 : Colors.black)),
      ),
      child: DropdownSearch<String>(
        dropdownBuilder: (context, selectedItem) {
          return Text(selectedItem.toString(),style: widget.textColor==true?const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16):const TextStyle(),);
        },
        //
        focusNode: widget.focusNode,
        //
        showClearButton: widget.showClearButton,
        //
        clearButtonProps: const IconButtonProps(
            icon: Icon(Icons.clear),
            constraints: BoxConstraints(minHeight: 20 , maxHeight: 35),
            padding: EdgeInsets.zero
        ),
        //
        dropdownButtonProps:  IconButtonProps(
          icon: Icon(
            Icons.arrow_drop_down,
            color: widget.borderColor??ThemeColors.grey,
            size: 30,
          ),
          visualDensity: const VisualDensity(vertical: -3.5 , horizontal: -3), // decreasing dropdown height
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 0),
        ),
        //
        maxHeight: widget.maxHeight == false ? 300 : widget.maxHeight,
        //
        mode: Mode.MENU,
        // scrollbarProps & selectionListViewProps required same controllers
        scrollbarProps: ScrollbarProps(controller: _scrollController, isAlwaysShown: true),
        //
        selectionListViewProps: SelectionListViewProps(controller: _scrollController),
        //
        showSelectedItems: true,
        //
        items: widget.dropdownList,
        //
        dropdownSearchDecoration: InputDecoration(
          fillColor: widget.fillColor??Colors.white,
          filled: true,
          hintText: widget.hintText,
          isDense: true,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor??ThemeColors.textFormFieldColor,width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor??ThemeColors.textFormFieldColor,width: 2),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor??ThemeColors.textFormFieldColor,width: 2),
          ),
          suffixIconConstraints: const BoxConstraints(minHeight: 0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor??ThemeColors.textFormFieldColor,width: 2),
          ),

          contentPadding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 8),
        ),
        //
        onChanged: widget.onChanged,
        //
        selectedItem: widget.selectedItem.isEmpty ? widget.hintText : widget.selectedItem,
        //
        showSearchBox: widget.showSearchBox,
        //
        searchFieldProps: const TextFieldProps(
          autofocus: true,
          cursorColor: Colors.blueGrey,
        ),
        //
        validator: widget.optional == true ? null :
            (value) {
          if (value == null || value.isEmpty || value == "" || value == widget.hintText) // initially value is "hintText"
              {
            AlertBoxes.flushBarErrorMessage("Please select an option", context);
            return 'Please select an option';
          }
          return null; // Input is valid
        },
        //
        // dropdownBuilder: ,

      ),
    );
  }
}


// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:pfc/AlertBoxes.dart';
// import 'package:pfc/utility/colors.dart';
//
// class SearchDropdownWidget extends StatefulWidget {
//   final List<String> dropdownList;
//   final String hintText;
//   final Function(String?)? onChanged;
//   final String selectedItem;
//   final bool showSearchBox ;
//   final double maxHeight;
//   final bool optional;
//   final bool showClearButton;
//   final FocusNode? focusNode;
//
//   const SearchDropdownWidget({Key? key,
//     required this.dropdownList,
//     required this.hintText,
//     required this.onChanged,
//     required this.selectedItem ,
//     this.showSearchBox = true,
//     this.maxHeight = 300,
//     this.optional = false,
//     this.showClearButton = false,
//     this.focusNode,
//   }) : super(key: key);
//
//   @override
//   State<SearchDropdownWidget> createState() => _SearchDropdownWidgetState();
// }
//
// class _SearchDropdownWidgetState extends State<SearchDropdownWidget> {
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: ThemeData(
//         textTheme: TextTheme(subtitle1: TextStyle(color: widget.selectedItem.isEmpty ? Colors.grey.shade600 : Colors.black)),
//       ),
//       child: DropdownSearch<String>(
//         //
//         focusNode: widget.focusNode,
//         //
//         showClearButton: widget.showClearButton,
//         //
//         clearButtonProps: const IconButtonProps(
//             icon: Icon(Icons.clear),
//             constraints: BoxConstraints(minHeight: 20 , maxHeight: 35),
//           padding: EdgeInsets.zero
//         ),
//         //
//         dropdownButtonProps:  IconButtonProps(
//             icon: Icon(
//               Icons.arrow_drop_down,
//               color: ThemeColors.grey,
//               size: 30,
//             ),
//             visualDensity: const VisualDensity(vertical: -3.5 , horizontal: -3), // decreasing dropdown height
//             alignment: Alignment.topCenter,
//             padding: const EdgeInsets.only(top: 0),
//         ),
//         //
//         maxHeight: widget.maxHeight == false ? 300 : widget.maxHeight,
//         //
//         mode: Mode.MENU,
//         // scrollbarProps & selectionListViewProps required same controllers
//         scrollbarProps: ScrollbarProps(controller: _scrollController, isAlwaysShown: true),
//         //
//         selectionListViewProps: SelectionListViewProps(controller: _scrollController),
//         //
//         showSelectedItems: true,
//         //
//         items: widget.dropdownList,
//         //
//         dropdownSearchDecoration: InputDecoration(
//           fillColor: Colors.white,
//             filled: true,
//             hintText: widget.hintText,
//             isDense: true,
//             border: const OutlineInputBorder(),
//             suffixIconConstraints: const BoxConstraints(minHeight: 0),
//             enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: ThemeColors.textFormFieldColor,),
//           ),
//
//             contentPadding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 8),
//         ),
//         //
//         onChanged: widget.onChanged,
//         //
//         selectedItem: widget.selectedItem.isEmpty ? widget.hintText : widget.selectedItem,
//         //
//         showSearchBox: widget.showSearchBox,
//         //
//         searchFieldProps: const TextFieldProps(
//           autofocus: true,
//           cursorColor: Colors.blueGrey,
//         ),
//         //
//         validator: widget.optional == true ? null :
//             (value) {
//           if (value == null || value.isEmpty || value == "" || value == widget.hintText) // initially value is "hintText"
//           {
//             AlertBoxes.flushBarErrorMessage("Please select an option", context);
//             return 'Please select an option';
//           }
//           return null; // Input is valid
//         },
//         //
//
//       ),
//     );
//   }
// }
