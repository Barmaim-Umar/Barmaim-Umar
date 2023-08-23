import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/utility/Validation.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class DateFieldWidget extends StatefulWidget {
  const DateFieldWidget(
      {Key? key,
        required this.dayController,
        required this.monthController,
        required this.yearController,
        required this.dateControllerApi,
      }) : super(key: key);

  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final TextEditingController dateControllerApi; // API date format - yyyy-mm-dd

  @override
  State<DateFieldWidget> createState() => _DateFieldWidgetState();
}

class _DateFieldWidgetState extends State<DateFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DatePicker Icon
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: ThemeColors.textFormFieldColor)),
            child: IconButton(
              padding: const EdgeInsets.only(bottom: 0),
              constraints: const BoxConstraints(maxHeight: 40, minHeight: 40, maxWidth: 40, minWidth: 40),
              onPressed: () {
                UiDecoration().showDatePickerDecoration2(context).then((value) {
                  setState(() {
                    widget.dayController.text = value.day.toString().padLeft(2, '0');
                    widget.monthController.text = value.month.toString().padLeft(2, '0');
                    widget.yearController.text = value.year.toString();

                    // API date  yyyy-mm-dd
                    String month = value.month.toString().padLeft(2, '0');
                    String day = value.day.toString().padLeft(2, '0');
                    widget.dateControllerApi.text = "${value.year}-$month-$day";
                  });
                });
              },
              icon: const Icon(
                Icons.calendar_month_outlined,
                size: 23,
                color: ThemeColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 5),

          /// dd - day
          UiDecoration().dateField(
            //
            widget.dayController,
            //
            hintText: 'dd',
            //
            inputFormatters:  [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
            _NumberRangeTextInputFormatter(0, 31),
            ],
            //
            onChanged: (value) {
              widget.dayController.value = TextEditingValue(
                text: Validation.dateDay(value),
                selection: TextSelection(baseOffset: Validation.dateDay(value).length, extentOffset: Validation.dateDay(value).length),
              );

              if(value.length == 2){
                // assigning value to dateApiController
                if(widget.dayController.text.isNotEmpty && widget.monthController.text.isNotEmpty && widget.yearController.text.isNotEmpty){
                  widget.dateControllerApi.text = "${widget.yearController.text}-${widget.monthController.text}-${widget.dayController.text}";
                }
                // next focus
                FocusScope.of(context).nextFocus();
              }
            },
            //
            validator: (value) {
              if (value == null || value.isEmpty) {
                AlertBoxes.flushBarErrorMessage("Enter Day", context);
                return '';
              } else if (value.length != 2) {
                AlertBoxes.flushBarErrorMessage("Invalid Date - day", context);
                return '';
              } else if (int.parse(value) > 31) {
                AlertBoxes.flushBarErrorMessage("Invalid day", context);
                return '';
              }
              // day validation
              else if (int.parse(widget.yearController.text) < GlobalVariable.fYearFrom.year ||
                  (int.parse(widget.yearController.text) == GlobalVariable.fYearFrom.year &&
                      int.parse(value) < GlobalVariable.fYearFrom.day)) {
                AlertBoxes.flushBarErrorMessage(
                    "Select a day from ${GlobalVariable.fYearFrom.day}-${GlobalVariable.fYearFrom.month}-${GlobalVariable.fYearFrom.year} to ${GlobalVariable.fYearTo.day}-${GlobalVariable.fYearTo.month}-${GlobalVariable.fYearTo.year}",
                    context
                );
                return '';
              }
              // day validation
              else if (int.parse(widget.yearController.text) > GlobalVariable.fYearTo.year ||
                  (int.parse(widget.yearController.text) == GlobalVariable.fYearTo.year &&
                      int.parse(value) > GlobalVariable.fYearTo.day)) {
                AlertBoxes.flushBarErrorMessage(
                    "Select a day from ${GlobalVariable.fYearFrom.day}-${GlobalVariable.fYearFrom.month}-${GlobalVariable.fYearFrom.year} to ${GlobalVariable.fYearTo.day}-${GlobalVariable.fYearTo.month}-${GlobalVariable.fYearTo.year}",
                    context
                );
              return'';
              }
              // day validation
              // else if(int.parse(widget.yearController.text) <= GlobalVariable.fYearFrom.year){
              //   if(int.parse(value) < GlobalVariable.fYearFrom.day){
              //     AlertBoxes.flushBarErrorMessage("select day from ${GlobalVariable.fYearFrom.day}-${GlobalVariable.fYearFrom.month}- ${GlobalVariable.fYearFrom.year} to ${GlobalVariable.fYearTo.day}-${GlobalVariable.fYearTo.month}- ${GlobalVariable.fYearTo.year}", context);
              //     return '';
              //   }
              // }
              // // day validation
              // else if(int.parse(widget.yearController.text) <= GlobalVariable.fYearTo.year){
              //   if(int.parse(value) > GlobalVariable.fYearTo.day){
              //     AlertBoxes.flushBarErrorMessage("select day from ${GlobalVariable.fYearFrom.day}-${GlobalVariable.fYearFrom.month}- ${GlobalVariable.fYearFrom.year} to ${GlobalVariable.fYearTo.day}-${GlobalVariable.fYearTo.month}- ${GlobalVariable.fYearTo.year}", context);
              //     return '';
              //   }
              // }

              return null;
            },

          ),
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text("-"),
          ),

          /// mm - month
          UiDecoration().dateField(
            //
            widget.monthController,
            //
            hintText: 'mm',
            //
            inputFormatters:  [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
              _NumberRangeTextInputFormatter(0, 12),
            ],
            //
            hintStyle: const TextStyle(fontSize: 12),
            //
            onChanged: (value) {
              widget.monthController.value = TextEditingValue(
                text: Validation.dateMonth(value),
                selection: TextSelection(baseOffset: Validation.dateMonth(value).length, extentOffset: Validation.dateMonth(value).length),
              );

              if(value.length == 2){
                // assigning value to dateApiController
                if(widget.dayController.text.isNotEmpty && widget.monthController.text.isNotEmpty && widget.yearController.text.isNotEmpty){
                  widget.dateControllerApi.text = "${widget.yearController.text}-${widget.monthController.text}-${widget.dayController.text}";
                }
                // next focus
                FocusScope.of(context).nextFocus();
              } else if(value.isEmpty){
                // previous focus
                FocusScope.of(context).previousFocus();
              }
            },
            //
            validator: (value) {
              if (value == null || value.isEmpty) {
                AlertBoxes.flushBarErrorMessage("Enter Month", context);
                return '';
              } else if (value.length != 2) {
                AlertBoxes.flushBarErrorMessage("Invalid Month", context);
                return '';
              } else if (int.parse(value) > 12) {
                AlertBoxes.flushBarErrorMessage("Invalid Month", context);
                return '';
              }
              // month validation
              else if (int.parse(widget.yearController.text) == GlobalVariable.fYearFrom.year &&
                  int.parse(value) < GlobalVariable.fYearFrom.month) {
                AlertBoxes.flushBarErrorMessage(
                    "Select a month from ${GlobalVariable.fYearFrom.month}-${GlobalVariable.fYearFrom.year} to ${GlobalVariable.fYearTo.month}-${GlobalVariable.fYearTo.year}",
                    context
                );
                return '';
              }
              else if (int.parse(widget.yearController.text) == GlobalVariable.fYearTo.year &&
                  int.parse(value) > GlobalVariable.fYearTo.month) {
                AlertBoxes.flushBarErrorMessage(
                    "Select a month from ${GlobalVariable.fYearFrom.month}-${GlobalVariable.fYearFrom.year} to ${GlobalVariable.fYearTo.month}-${GlobalVariable.fYearTo.year}",
                    context
                );
              return'';
              }

              return null;
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text("-"),
          ),

          /// yyyy - year
          UiDecoration().dateField(
            //
            widget.yearController,
            //
            hintText: 'yyyy',
            //
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+'))],
            //
            width: 42.5,
            //
            onChanged: (value) {
              widget.yearController.value = TextEditingValue(
                text: Validation.dateYear(value),
                selection: TextSelection(baseOffset: Validation.dateYear(value).length, extentOffset: Validation.dateYear(value).length),
              );

              if(value.length == 4){
                // assigning value to dateApiController
                if(widget.dayController.text.isNotEmpty && widget.monthController.text.isNotEmpty && widget.yearController.text.isNotEmpty){
                  widget.dateControllerApi.text = "${widget.yearController.text}-${widget.monthController.text}-${widget.dayController.text}";
                }
                // next focus
                FocusScope.of(context).nextFocus();
              } else if(value.isEmpty){
                // previous focus
                FocusScope.of(context).previousFocus();
              }
            },
            //
            validator: (value) {
              if (value == null || value.isEmpty) {
                AlertBoxes.flushBarErrorMessage("Enter Year", context);
                return '';
              } else if(GlobalVariable.fYearFrom.year > int.parse(value)){
                AlertBoxes.flushBarErrorMessage("enter 'Year' between or equal to: ${GlobalVariable.fYearFrom.year} - ${GlobalVariable.fYearTo.year}", context);
                return '';
              }else if(GlobalVariable.fYearTo.year < int.parse(value)){
                AlertBoxes.flushBarErrorMessage("enter 'Year' between or equal to: ${GlobalVariable.fYearFrom.year} - ${GlobalVariable.fYearTo.year}", context);
                return '';
              }else if (value.length != 4) {
                AlertBoxes.flushBarErrorMessage("Invalid Year", context);
                return '';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}
class _NumberRangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  _NumberRangeTextInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    int? number = int.tryParse(newValue.text);
    if (number != null && (number < min || number > max)) {
      // Return the old value if the input is outside the desired range
      return oldValue;
    }
    return newValue;
  }
}
