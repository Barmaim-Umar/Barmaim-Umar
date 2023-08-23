import 'package:flutter/material.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class SearchDataTable extends StatefulWidget {
  bool isSelected;
  TextEditingController search;

  Function(String)? onFieldSubmitted;
  String columnName;

  SearchDataTable({Key? key,
    required this.isSelected,
    required this.search,
    this.onFieldSubmitted,
    required this.columnName,
  }) : super(key: key);

  @override
  State<SearchDataTable> createState() => _SearchDataTableState();
}

class _SearchDataTableState extends State<SearchDataTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.columnName),
        widget.isSelected == false
            ? const SizedBox()
            : SizedBox(
                height: 35,
                width: 200,
                child: TextFormField(
                  controller: widget.search,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  onChanged: widget.onFieldSubmitted,
                  autofocus: true,
                  decoration: UiDecoration().outlineTextFieldDecoration('Search', ThemeColors.primary),
                ),
              ),
      ],
    );
  }
}
