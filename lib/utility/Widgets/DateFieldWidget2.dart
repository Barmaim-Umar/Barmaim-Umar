import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/utility/Validation.dart';
import 'package:pfc/utility/colors.dart';
import 'package:pfc/utility/styles.dart';

class DateFieldWidget2 extends StatefulWidget {
  const DateFieldWidget2(
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
  State<DateFieldWidget2> createState() => _DateFieldWidget2State();
}

class _DateFieldWidget2State extends State<DateFieldWidget2> {
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
                UiDecoration().showDatePickerDecoration(context).then((value) {
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
                FocusScope.of(context).nextFocus();
              } else if(value.isEmpty){
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
                FocusScope.of(context).nextFocus();
              } else if(value.isEmpty){
                FocusScope.of(context).previousFocus();
              }
            },
            //
            validator: (value) {
              if (value == null || value.isEmpty) {
                AlertBoxes.flushBarErrorMessage("Enter Year", context);
                return '';
              } else if (value.length != 4) {
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
