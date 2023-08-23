import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pfc/AlertBoxes.dart';
import 'package:pfc/GlobalVariable/GlobalVariable.dart';
import 'package:pfc/Provider/DropDownProvider.dart';
import 'package:pfc/responsive.dart';
import 'package:pfc/utility/global.dart';
import 'package:provider/provider.dart';
import 'Validation.dart';
import 'colors.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:excel/excel.dart' hide Border , BorderStyle;
import 'package:universal_html/html.dart' as html;

class BStyles {
  Widget button(String text, String tooltip, String image, {void Function()? onPressed}) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.primaryDark, maximumSize: const Size(100, 30), minimumSize: const Size(50, 30)),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                width: 30,
                color: Colors.white,
              ),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )),
    );
  }

  // Widget button(String text, String tooltip, String image) {
  //   return Tooltip(
  //     message: tooltip,
  //     child: ElevatedButton(
  //         style: ElevatedButton.styleFrom(backgroundColor: ThemeColors.primaryDark, maximumSize: const Size(100, 30), minimumSize: const Size(50, 30)),
  //         onPressed: () {},
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Image.asset(
  //               image,
  //               width: 30,
  //               color: Colors.white,
  //             ),
  //             Expanded(
  //                 child: Text(
  //                   text,
  //                   style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
  //                   overflow: TextOverflow.ellipsis,
  //                 )),
  //           ],
  //         )),
  //   );
  // }

  static ButtonStyle blueButtonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(ThemeColors.primaryColor),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}

//==========================================================================

class ButtonStyles {
  static ButtonStyle blueButton() {
    return ElevatedButton.styleFrom(
        minimumSize: const Size(400, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), shadowColor: Colors.transparent, backgroundColor: ThemeColors.primary);
  }

  static ButtonStyle smallButton(backgroundColor, textColor) {
    return ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shadowColor: Colors.transparent,
        minimumSize: const Size(80, 50),
        foregroundColor: textColor,
        side: BorderSide(color: ThemeColors.grey700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)));
  }

  static ButtonStyle accountButton() {
    return ElevatedButton.styleFrom(
        minimumSize: const Size(565, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), shadowColor: Colors.transparent, backgroundColor: ThemeColors.primaryColor);
  }

  static ButtonStyle customiseButton(backgroundColor, textColor, width, height) {
    return ElevatedButton.styleFrom(
        padding: const EdgeInsets.only(top: 11, left: 10, right: 10, bottom: 12),
        backgroundColor: backgroundColor,
        shadowColor: Colors.transparent,
        minimumSize: Size(width, height),
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)));
  }

  static ButtonStyle dashboardButton(bool isSelected) {
    return ElevatedButton.styleFrom(
        backgroundColor: isSelected ? ThemeColors.primary : Colors.transparent,
        shadowColor: Colors.transparent,
        side: BorderSide(color: ThemeColors.primary),
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        minimumSize: const Size(100, 50));
  }

  static ButtonStyle dashboardButton2({bool isSelected = false}) {
    return ElevatedButton.styleFrom(
      backgroundColor: isSelected ? ThemeColors.primary : Colors.transparent,
      shadowColor: Colors.transparent,
      side: BorderSide(color: ThemeColors.primary),
      foregroundColor: isSelected ? Colors.white : ThemeColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      minimumSize: const Size(100, 50),
    );
  }
}

//==========================================================================

class DayInputFormatter extends TextInputFormatter {
  final RegExp _dayRegExp = RegExp(r'^(0[1-9]|[12][0-9]|3[01])$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_dayRegExp.hasMatch(newValue.text)) {
      return newValue;
    } else {
      // Return the old value to prevent invalid input
      return oldValue;
    }
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

class UiDecoration {
  static bool isExpanded = false;

  /// AppBar
  static appBar(String title) {
    return AppBar(
      // backgroundColor: Colors.blueGrey.shade200,
      title: Text(
        title,
      ),
      backgroundColor: ThemeColors.primary,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.white,
    );
  }

  // date text field
  Widget dateField(
    TextEditingController controller, {
    hintStyle = false,
    String hintText = '',
    double width = 28,
    void Function(String)? onChanged,
    FocusNode? focusNode,
    String? Function(String?)? validator,
        List<TextInputFormatter>? inputFormatters
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        //
        focusNode: focusNode,
        //
        textAlign: TextAlign.center,
        //
        inputFormatters: inputFormatters ,
        // inputFormatters: [
        //   FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
        //   _NumberRangeTextInputFormatter(1, 31),
        // ],
        //
        decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.white,
            filled: true,
            hintStyle: hintStyle == false ? const TextStyle() : hintStyle,
            isDense: true,
            border: const OutlineInputBorder(borderSide: BorderSide(color: ThemeColors.formTextColor)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: ThemeColors.textFormFieldColor)),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3)),
        //
        onChanged: onChanged,
        //
        validator: validator,
      ),
    );
  }

  // date text field - dd-mm-yyyy
  Widget dateFieldInput(TextEditingController dayController, TextEditingController monthController, TextEditingController yearController, BuildContext context, void Function() setState) {
    return Container(
      width: 270,
      decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DatePicker Icon
          IconButton(
            onPressed: () {
              UiDecoration().showDatePickerDecoration2(context).then((value) {
                // setState(() {
                //   String month = value.month.toString().padLeft(2, '0');
                //   String day = value.day.toString().padLeft(2, '0');
                //   dateControllerUI.text = "$day-$month-${value.year}";
                //   dateControllerApi.text = "${value.year}-$month-$day";
                // });
              });
            },
            icon: const Icon(Icons.calendar_month_outlined),
          ),

          // dd - day
          /// day
          UiDecoration().dateField(
            dayController,
            hintText: 'dd',
            onChanged: (value) {
              dayController.value = TextEditingValue(
                text: Validation.dateDay(value),
                selection: TextSelection(baseOffset: Validation.dateDay(value).length, extentOffset: Validation.dateDay(value).length),
              );
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                AlertBoxes.flushBarErrorMessage("Enter Day", context);
                return '';
              } else if (value.length > 2) {
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
            monthController,
            hintText: 'mm',
            hintStyle: const TextStyle(fontSize: 12),
            onChanged: (value) {
              monthController.value = TextEditingValue(
                text: Validation.dateMonth(value),
                selection: TextSelection(baseOffset: Validation.dateMonth(value).length, extentOffset: Validation.dateMonth(value).length),
              );
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                AlertBoxes.flushBarErrorMessage("Enter Month", context);
                return '';
              } else if (value.length > 2) {
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
            yearController,
            hintText: 'yyyy',
            width: 42.5,
            onChanged: (value) {
              yearController.value = TextEditingValue(
                text: Validation.dateYear(value),
                selection: TextSelection(baseOffset: Validation.dateYear(value).length, extentOffset: Validation.dateYear(value).length),
              );
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                AlertBoxes.flushBarErrorMessage("Enter Year", context);
                return '';
              } else if (value.length != 4) {
                AlertBoxes.flushBarErrorMessage("Invalid Year", context);
                return '';
              }
              // else if(int.parse(value) > 12){
              //   AlertBoxes.flushBarErrorMessage("Invalid Year", context);
              //   return '';
              // }

              return null;
            },
          ),
        ],
      ),
    );
  }

  // Future<void> exportToExcel(List<List<dynamic>> data) async {
  //   var excel = Excel.createExcel();
  //   var sheet = excel['Sheet1'];
  //   sheet.setColAutoFit(1);
  //
  //   // Define a cell style for the heading
  //   CellStyle cellStyle = CellStyle(bold: true);
  //
  //   // Populate the sheet with data
  //   for (int row = 0; row < data.length; row++) {
  //     for (int col = 0; col < data[row].length; col++) {
  //       CellIndex cellIndex = CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row);
  //
  //       // Apply bold style to the heading row
  //       if (row == 0) {
  //         sheet.cell(cellIndex).value = data[row][col];
  //         sheet.cell(cellIndex).cellStyle = cellStyle;
  //       } else {
  //         sheet.cell(cellIndex).value = data[row][col];
  //       }
  //     }
  //   }
  //
  //   // Generate a unique file name based on the current timestamp
  //   String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //   String fileName = 'data_$timestamp.xlsx';
  //
  //   // Get the appropriate directory based on the platform
  //   Directory directory;
  //   if (html.window.navigator.userAgent.contains('Mozilla') &&
  //       html.window.navigator.userAgent.contains('Chrome')) {
  //     // For Chrome on web, use the Downloads directory
  //     directory = Directory('Downloads');
  //   } else {
  //     // For other platforms, use the application documents directory
  //     directory = await getApplicationDocumentsDirectory();
  //   }
  //
  //   // Create the file path
  //   String filePath = '${directory.path}/${fileName.replaceAll(':', '_')}';
  //
  //   // Save the Excel file
  //   var bytes = excel.save();
  //   File file = File(filePath);
  //   await file.writeAsBytes(bytes!);
  //
  //   // Open the file based on the platform
  //   if (html.window.navigator.userAgent.contains('Mozilla') &&
  //       html.window.navigator.userAgent.contains('Chrome')) {
  //     // For Chrome on web, trigger the download
  //     html.AnchorElement(href: filePath)
  //       ..setAttribute('download', fileName)
  //       ..click();
  //   } else {
  //     // For other platforms, open the file using the default program
  //     OpenFile.open(filePath);
  //   }
  // }

  Future<void> excelFunc(exportData) async {
    if (kIsWeb) {
      UiDecoration().exportToExcelWeb(exportData);
    } else {
      UiDecoration().exportToExcelDesktop(exportData);
    }
  }

  Future<void> pdfFunc(data) async {
    if (kIsWeb) {
      UiDecoration().generatePDFWeb(data);
    } else {
      UiDecoration().generatePDFDesktop(data);
    }
  }

  Future<void> exportToExcelDesktop(List<List<dynamic>> excelData) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.setColAutoFit(1);

    // Define a cell style for the heading
    CellStyle cellStyle = CellStyle(bold: true);

    // Populate the sheet with data
    for (int row = 0; row < excelData.length; row++) {
      for (int col = 0; col < excelData[row].length; col++) {
        CellIndex cellIndex = CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row);

        // Apply bold style to the heading row
        if (row == 0) {
          sheet.cell(cellIndex).value = excelData[row][col];
          sheet.cell(cellIndex).cellStyle = cellStyle;
        } else {
          sheet.cell(cellIndex).value = excelData[row][col];
        }
      }
    }

    // Generate a unique file name based on the current timestamp
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = 'data_$timestamp.xlsx';

    // Get the appropriate directory based on the platform
    Directory? directory;
    if (html.window.navigator.userAgent.contains('Mozilla') && html.window.navigator.userAgent.contains('Chrome')) {
      // For Chrome on web, use the Downloads directory
      directory = Directory('Downloads');
    } else {
      // For other platforms, use the application documents directory
      directory = await getApplicationDocumentsDirectory();
    }

    // Create the file path
    String filePath = '${directory.path}/${fileName.replaceAll(':', '_')}';

    // Save the Excel file
    var bytes = excel.save();
    File file = File(filePath);
    await file.writeAsBytes(bytes!);

    // Open the file based on the platform
    if (html.window.navigator.userAgent.contains('Mozilla') && html.window.navigator.userAgent.contains('Chrome')) {
      // For Chrome on web, trigger the download
      html.AnchorElement(href: filePath)
        ..setAttribute('download', fileName)
        ..click();
    } else {
      // For other platforms, open the file using the default program
      OpenFile.open(filePath);
    }
  }

  // Future<void> exportToExcelWeb(List<List<dynamic>> excelData) async {
  //   var excel = Excel.createExcel();
  //   var sheet = excel['Sheet1'];
  //   sheet.setColAutoFit(1);
  //
  //   // Define a cell style for the heading
  //   CellStyle cellStyle = CellStyle(bold: true);
  //
  //   // Populate the sheet with data
  //   for (int row = 0; row < excelData.length; row++) {
  //     for (int col = 0; col < excelData[row].length; col++) {
  //       CellIndex cellIndex = CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row);
  //
  //       // Apply bold style to the heading row
  //       if (row == 0) {
  //         sheet.cell(cellIndex).value = excelData[row][col];
  //         sheet.cell(cellIndex).cellStyle = cellStyle;
  //       } else {
  //         sheet.cell(cellIndex).value = excelData[row][col];
  //       }
  //     }
  //   }
  //
  //   // Generate a unique file name based on the current timestamp
  //   String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //   String fileName = 'data_$timestamp.xlsx';
  //
  //   // Save the Excel file as a download
  //   var bytes = excel.save();
  //   final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //
  //   // Remove any existing download link
  //   if (html.document.getElementById('download-link') != null) {
  //     html.document.getElementById('download-link')!.remove();
  //   }
  //
  //   // Create the download link
  //   final anchor = html.document.createElement('a') as html.AnchorElement
  //     ..id = 'download-link'
  //     ..href = url
  //     ..style.display = 'none'
  //     ..download = fileName;
  //   html.document.body?.children.add(anchor);
  //   anchor.click();
  //   html.document.body?.children.remove(anchor);
  //   html.Url.revokeObjectUrl(url);
  // }
  Future<void> exportToExcelWeb(List<List<dynamic>> excelData) async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    // Define a cell style for the heading
    CellStyle cellStyle = CellStyle(bold: true);

    // Populate the sheet with data
    for (int row = 0; row < excelData.length; row++) {
      for (int col = 0; col < excelData[row].length; col++) {
        sheet.setColAutoFit(col);
        CellIndex cellIndex = CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row);

        // Apply bold style to the heading row
        if (row == 0) {
          sheet.cell(cellIndex).value = excelData[row][col];
          sheet.cell(cellIndex).cellStyle = cellStyle;
        } else {
          sheet.cell(cellIndex).value = excelData[row][col];
        }
      }
    }

    // Generate a unique file name based on the current timestamp
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = 'data_$timestamp.xlsx';

    // Save the Excel file as a download
    var bytes = excel.save();
    final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create the download link
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future<void> generatePDFDesktop(List<List<dynamic>> pdfData) async {
    final pdf = pw.Document();

    const int itemsPerPage = 30;
    // Calculate the number of pages
    final int pageCount = (pdfData.length / itemsPerPage).ceil();

    // Generate pages
    for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
      final startItemIndex = pageIndex * itemsPerPage;
      final endItemIndex = (startItemIndex + itemsPerPage < pdfData.length) ? startItemIndex + itemsPerPage : pdfData.length;
      final pageItems = pdfData.sublist(startItemIndex, endItemIndex);

      final tableRows = pageItems.skip(1).map((row) => row.map((item) => item.toString()).toList()).toList();

      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) {
            final table = pw.Table.fromTextArray(
              defaultColumnWidth: const pw.FlexColumnWidth(1),
              headers: pdfData[0],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              data: tableRows,
            );

            return [
              pw.Center(
                child: table,
              ),
            ];
          },
        ),
      );
    }

    // Save the PDF to a file
    final output = await getApplicationDocumentsDirectory();
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final file = File('${output.path}/${timestamp}example.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file
    OpenFile.open(file.path);
  }

  Future<void> generatePDFWeb(List<List<dynamic>> dataList) async {
    final pdf = pw.Document();

    const int itemsPerPage = 30;
    // Calculate the number of pages
    final int pageCount = (dataList.length / itemsPerPage).ceil();

    // Generate pages
    for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
      final startItemIndex = pageIndex * itemsPerPage;
      final endItemIndex = (startItemIndex + itemsPerPage < dataList.length) ? startItemIndex + itemsPerPage : dataList.length;
      final pageItems = dataList.sublist(startItemIndex, endItemIndex);

      final tableRows = pageItems.skip(1).map((row) => row.map((item) => item.toString()).toList()).toList();

      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) {
            final table = pw.Table.fromTextArray(
              defaultColumnWidth: const pw.FlexColumnWidth(1),
              headers: dataList[0],
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              data: tableRows,
            );

            return [
              pw.Center(
                child: table,
              ),
            ];
          },
        ),
      );
    }

    final pdfData = await pdf.save();

    final blob = html.Blob([pdfData], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'example.pdf';

    html.document.body?.children.add(anchor);

    anchor.click();

    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future<void> generatePrintDocument(List<List<dynamic>> printData) async {
    final pdf = pw.Document();

    const int itemsPerPage = 30;
    // Calculate the number of pages
    final int pageCount = (printData.length / itemsPerPage).ceil();

    // Generate pages
    for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
      final startItemIndex = pageIndex * itemsPerPage;
      final endItemIndex = (startItemIndex + itemsPerPage < printData.length) ? startItemIndex + itemsPerPage : printData.length;
      final pageItems = printData.sublist(startItemIndex, endItemIndex);

      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) {
            final tableHeaders = pageItems[0].map<String>((item) => item.toString()).toList();
            final tableRows = pageItems.skip(1).map((row) => row.map((item) => item.toString()).toList()).toList();
            final table = pw.Table.fromTextArray(
              defaultColumnWidth: const pw.FixedColumnWidth(100.0),
              headers: tableHeaders,
              // Convert headers to string values
              data: tableRows,
              // Convert data to string values
              cellStyle: const pw.TextStyle(fontSize: 12),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            );

            return [
              pw.Center(
                child: table,
              ),
            ];
          },
        ),
      );
    }

    // Generate the PDF as a Uint8List
    final Uint8List pdfBytes = await pdf.save();

    // Print the PDF document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }

  // Future<void> generatePDFDesktop(List<List<dynamic>> pdfData) async {
  //   final pdf = pw.Document();
  //
  //   const int itemsPerPage = 29;
  //   // Calculate the number of pages
  //   final int pageCount = (pdfData.length / itemsPerPage).ceil();
  //
  //   // Generate pages
  //   for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
  //     final startItemIndex = pageIndex * itemsPerPage;
  //     final endItemIndex = (startItemIndex + itemsPerPage < pdfData.length)
  //         ? startItemIndex + itemsPerPage
  //         : pdfData.length;
  //     final pageItems = pdfData.sublist(startItemIndex, endItemIndex);
  //
  //     pdf.addPage(
  //       pw.MultiPage(
  //         build: (pw.Context context) {
  //           final List<pw.Widget> content = [];
  //
  //           final table = pw.Table.fromTextArray(
  //             // headers: headers,
  //             data: pageItems,
  //           );
  //
  //           // Add data to the page
  //           // for (String item in pageItems) {
  //           //   content.add(pw.Text(item, style: pw.TextStyle(fontSize: 12)));
  //           //   content.add(pw.SizedBox(height: 10)); // Add spacing between items
  //           // }
  //
  //           return [
  //             pw.Center(
  //               child: table,
  //             ),
  //           ];
  //         },
  //       ),
  //     );
  //   }
  //
  //   // Save the PDF to a file
  //   final output = await getApplicationDocumentsDirectory();
  //   String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //   final file = File('${output.path}/${timestamp}example.pdf');
  //   await file.writeAsBytes(await pdf.save());
  //
  //   // Open the PDF file
  //   OpenFile.open(file.path);
  // }
  ///
  // Future<void> generatePDFDesktop(List<List<dynamic>> pdfData) async {
  //   final pdf = pw.Document();
  //
  //   const int itemsPerPage = 29;
  //   // Calculate the number of pages
  //   final int pageCount = (pdfData.length / itemsPerPage).ceil();
  //
  //   // Generate pages
  //   for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
  //     final startItemIndex = pageIndex * itemsPerPage;
  //     final endItemIndex = (startItemIndex + itemsPerPage < pdfData.length)
  //         ? startItemIndex + itemsPerPage
  //         : pdfData.length;
  //     final pageItems = pdfData.sublist(startItemIndex, endItemIndex);
  //
  //     pdf.addPage(
  //       pw.MultiPage(
  //         build: (pw.Context context) {
  //           final List<pw.Widget> content = [];
  //
  //           // Create a table with custom cell builders
  //           final table = pw.Table(
  //             defaultColumnWidth: pw.FixedColumnWidth(1),
  //             border: pw.TableBorder.all(),
  //             children: pageItems.map((row) {
  //               return pw.TableRow(
  //                 children: row.map((cell) {
  //                   if (cell is Uint8List) {
  //                     // If the cell contains image data, create an Image widget
  //                     return pw.Container(
  //                       padding: pw.EdgeInsets.all(5),
  //                       child: pw.Image(pw.MemoryImage(cell)),
  //                     );
  //                   } else if (cell is String && cell.startsWith('http')) {
  //                     // If the cell contains a URL, create a UrlLink widget with a hyperlink
  //                     return pw.Container(
  //                       padding: pw.EdgeInsets.all(5),
  //                       child: pw.UrlLink(
  //                         child: pw.Text(cell),
  //                         destination: cell,
  //                       ),
  //                     );
  //                   } else {
  //                     // Otherwise, create a Text widget
  //                     return pw.Container(
  //                       padding: pw.EdgeInsets.all(5),
  //                       child: pw.Text(cell.toString()),
  //                     );
  //                   }
  //                 }).toList(),
  //               );
  //             }).toList(),
  //           );
  //
  //           return [
  //             pw.Center(
  //               child: table,
  //             ),
  //           ];
  //         },
  //       ),
  //     );
  //   }
  //
  //   // Save the PDF to a file
  //   final output = await getApplicationDocumentsDirectory();
  //   String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //   final file = File('${output.path}/${timestamp}example.pdf');
  //   await file.writeAsBytes(await pdf.save());
  //
  //   // Open the PDF file
  //   OpenFile.open(file.path);
  // }
  ///
  // Future<void> generatePDFWeb(List<List<dynamic>> dataList) async {
  //   final pdf = pw.Document();
  //
  //   const int itemsPerPage = 29;
  //   final int pageCount = (dataList.length / itemsPerPage).ceil();
  //
  //   for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
  //     final startItemIndex = pageIndex * itemsPerPage;
  //     final endItemIndex = (startItemIndex + itemsPerPage < dataList.length)
  //         ? startItemIndex + itemsPerPage
  //         : dataList.length;
  //     final pageItems = dataList.sublist(startItemIndex, endItemIndex);
  //
  //     // Filter out empty or null values from pageItems
  //     final filteredPageItems = pageItems.where((row) => row.isNotEmpty).toList();
  //
  //     if (filteredPageItems.isNotEmpty) {
  //       pdf.addPage(
  //         pw.Page(
  //           build: (pw.Context context) {
  //             final List<pw.Widget> content = [];
  //
  //             final table = pw.Table.fromTextArray(
  //               data: filteredPageItems.map((row) => row.map((item) => item.toString()).toList()).toList(),
  //             );
  //
  //             content.add(pw.Center(child: table));
  //
  //             return pw.Column(children: content);
  //           },
  //         ),
  //       );
  //     }
  //   }
  //
  //   final pdfData = await pdf.save();
  //
  //   final blob = html.Blob([pdfData], 'application/pdf');
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   final anchor = html.document.createElement('a') as html.AnchorElement
  //     ..href = url
  //     ..style.display = 'none'
  //     ..download = 'example.pdf';
  //
  //   html.document.body?.children.add(anchor);
  //
  //   anchor.click();
  //
  //   html.document.body?.children.remove(anchor);
  //   html.Url.revokeObjectUrl(url);
  // }
  ///
  // Future<void> generatePrintDocument(List<List<dynamic>> printData) async {
  //   final pdf = pw.Document();
  //
  //   const int itemsPerPage = 29;
  //   // Calculate the number of pages
  //   final int pageCount = (printData.length / itemsPerPage).ceil();
  //
  //   // Generate pages
  //   for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
  //     final startItemIndex = pageIndex * itemsPerPage;
  //     final endItemIndex = (startItemIndex + itemsPerPage < printData.length)
  //         ? startItemIndex + itemsPerPage
  //         : printData.length;
  //     final pageItems = printData.sublist(startItemIndex, endItemIndex);
  //
  //     pdf.addPage(
  //       pw.MultiPage(
  //         build: (pw.Context context) {
  //           final List<pw.Widget> content = [];
  //           final tableHeaders = pageItems[0].map<String>((item) => item.toString()).toList();
  //           final tableRows = pageItems.skip(1).map((row) => row.map((item) => item.toString()).toList()).toList();
  //
  //
  //           final table = pw.Table.fromTextArray(
  //             defaultColumnWidth: pw.FixedColumnWidth(100.0),
  //             headers: tableHeaders, // Convert headers to string values
  //             data: tableRows, // Convert data to string values
  //             cellStyle: pw.TextStyle(fontSize: 12),
  //             headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
  //           );
  //
  //           return [
  //             pw.Center(
  //               child: table,
  //             ),
  //           ];
  //         },
  //       ),
  //     );
  //   }
  //
  //   // Generate the PDF as a Uint8List
  //   final Uint8List pdfBytes = await pdf.save();
  //
  //   // Print the PDF document
  //   await Printing.layoutPdf(
  //     onLayout: (PdfPageFormat format) async => pdfBytes,
  //   );
  // }

  void initialDateApi(
    Function setState,
    TextEditingController dateController,
  ) {
    setState(() {
      String month = GlobalVariable.displayDate.month.toString().padLeft(2, '0');
      String day = GlobalVariable.displayDate.day.toString().padLeft(2, '0');
      dateController.text = "${GlobalVariable.displayDate.year}-$month-$day";
    });
  }

  void initialDateUi(
    Function setState,
    TextEditingController dateController,
  ) {
    setState(() {
      String month = GlobalVariable.displayDate.month.toString().padLeft(2, '0');
      String day = GlobalVariable.displayDate.day.toString().padLeft(2, '0');
      dateController.text = "$day-$month-${GlobalVariable.displayDate.year}";
    });
  }

  // bool showCurrentDate () {
  //   // checking if "current date" is in between "FromDate" and "ToDate"
  //   if(GlobalVariable.fYearFrom.isBefore(DateTime.now()) && GlobalVariable.fYearTo.isAfter(DateTime.now()))
  //   {
  //     return true;
  //   }
  //   // checking if "current date" == "FromDate" || "ToDate"
  //   else if(GlobalVariable.fYearFrom == DateTime.now() || GlobalVariable.fYearTo == DateTime.now()){
  //     return true;
  //   }
  //   // don't show current date
  //   else{
  //     return false;
  //   }
  //
  // }

  static bool showCurrentDate() {
    // checking if "current date" is in between "FromDate" and "ToDate"
    if (GlobalVariable.fYearFrom.isBefore(DateTime.now()) && GlobalVariable.fYearTo.isAfter(DateTime.now())) {
      return true;
    }
    // checking if "current date" == "FromDate" || "ToDate"
    else if (GlobalVariable.fYearFrom == DateTime.now() || GlobalVariable.fYearTo == DateTime.now()) {
      return true;
    }
    // don't show current date
    else {
      return false;
    }
  }

  // "dd-mm-yy"  changing date format
  String getFormattedDate(String dtStr) {
    var dt = DateTime.parse(dtStr);
    return "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
  }

  BoxDecoration formDecoration({color = false}) {
    return BoxDecoration(
      color: color == false ? Colors.white : color,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
      // boxShadow: [
      //   BoxShadow(
      //       color: Colors.grey.shade300,
      //       spreadRadius: .5,
      //       blurRadius: 1
      //   )
      // ]
    );
  }

  BoxDecoration formDecoration2({color = false}) {
    return BoxDecoration(
      color: color == false ? Colors.white : color,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
      // boxShadow: [
      //   BoxShadow(
      //       color: Colors.grey.shade300,
      //       spreadRadius: .5,
      //       blurRadius: 1
      //   )
      // ]
    );
  }

  Widget textFormField(String label, controller) {
    return TextFormField(
      controller: controller,
      cursorColor: ThemeColors.grey700,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ThemeColors.grey700)),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500),
      ),
    );
  }

  Widget tableField(TextEditingController controller,{void Function(String)? onChanged, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
      child: TextFormField(
        readOnly: readOnly,
        onChanged: onChanged,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly
        ],
        controller: controller,
        decoration: UiDecoration()
            .outlineTextFieldDecoration('Amount', ThemeColors.primaryColor),
      ),
    );
  }

  Widget customButton(setState, context, bool isHover, bool isTapped, Function() page) {
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
                builder: (context) => page(),
              ));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 100,
          width: 300,
          decoration: BoxDecoration(
              color: isTapped ? ThemeColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                isHover
                    ? BoxShadow(
                        color: isTapped ? Colors.black : ThemeColors.primary,
                        offset: const Offset(7, 7),
                      )
                    : BoxShadow(
                        color: ThemeColors.primary,
                        offset: const Offset(0, 0),
                      ),
              ],
              border: Border.all(color: ThemeColors.primary, width: 2)),
          child: Center(
              child: Text(
            "NeuBrutalism Design",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: isTapped ? Colors.white : ThemeColors.primary),
          )),
        ),
      ),
    );
  }

  InputDecoration outlineTextFieldDecoration(hint, borderColor, {lbl, icon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      fillColor: Colors.white,
      isDense: true,
      border: const OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ThemeColors.textFormFieldColor),
      ),
      filled: true,
      hintText: hint,
      // hintStyle: const TextStyle(fontSize: 14),
    );
  }

  Widget outlineField(double width, String label, flex, controller) {
    return Expanded(
      flex: flex,
      child: SizedBox(
        width: width,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(contentPadding: const EdgeInsets.all(12), isDense: true, labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          onChanged: (value) {},
        ),
      ),
    );
  }

  Widget inTransitReported() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0.5),
        color: const Color(0xffffd8a1),
        width: double.infinity,
        alignment: Alignment.center,
        height: 40,
        child: const Text('MH18BG2389 <-- Pune'),
      ),
    );
  }

  Widget inTransitUnloaded() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0.5),
        color: const Color(0xffd9ffa1),
        width: double.infinity,
        alignment: Alignment.center,
        height: 40,
        child: const Text('MH18BG2389 <-- Pune'),
      ),
    );
  }

  Widget inTransitOnRoad() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0.5),
        color: const Color(0xffff0707),
        width: double.infinity,
        alignment: Alignment.center,
        height: 40,
        child: const Text('MH18BG2389 <-- Pune'),
      ),
    );
  }

  Widget inTransit(String cityName, String title, Widget vehicleName) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: ListTileTheme(
        dense: true,
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          backgroundColor: const Color(0xff337ab7),
          collapsedBackgroundColor: const Color(0xff337ab7),
          collapsedTextColor: Colors.white,
          collapsedIconColor: Colors.white,
          textColor: Colors.white,
          iconColor: Colors.white,
          childrenPadding: const EdgeInsets.all(0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                cityName,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              )),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     inTransitCircle(0xff491fee),
              //     const SizedBox(width: 5,),
              //     inTransitCircle(0xff22a948),
              //     const SizedBox(width: 5,),
              //     inTransitCircle(0xffff0707),
              //   ],
              // ),
            ],
          ),
          children: [
            // OnRoad
            ExpansionTile(
              initiallyExpanded: true,
              collapsedBackgroundColor: const Color(0xffdff0d8),
              backgroundColor: const Color(0xffdff0d8),
              title: TextDecorationClass().inTransitText(title),
              children: [
                inTransitOnRoad(),
                inTransitOnRoad(),
                inTransitOnRoad(),
                inTransitOnRoad(),
                inTransitOnRoad(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget inTransitCircle(color1) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          // gradient: LinearGradient(colors: [const Color(0xff0d334d), const Color(0xff0d334d).withOpacity(0.7)])
          gradient: LinearGradient(colors: [Color(color1), Color(color1)])),
      child: const Text(
        '13',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget vehicleFilter(String title, String total) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.greenAccent,
      ),
      child: Row(
        children: [
          Text(title),
          Text(total),
        ],
      ),
    );
  }

  Widget vehicleExpansionTile(String lrNumber, String expectedDate,activityDate,String fromLocation,String toLocation,String entryBy,String company,String status, color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
                    ),
                    Text(
                      'LR Number: $lrNumber',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Expected Date: $expectedDate",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Text(
                        "Activity Date: $activityDate",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
                      ),
                    ),
                    // LR Number | City from -> to
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 0,
                          child: Text(
                            fromLocation,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   width: 4,
                        // ),
                        Icon(
                          Icons.arrow_forward,
                          size: 10,
                          color: Colors.grey.shade600,
                        ),
                        // const SizedBox(
                        //   width: 4,
                        // ),
                        Expanded(
                          child: Text(
                            toLocation,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),

                    // Expected Date | Entry by
                    Text(
                      "Entry By: $entryBy",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      // softWrap: false,
                    ),
                  ],
                ),
              ),

              /// status
              const SizedBox(
                width: 20,
              ),
              Container(
                  width: 80,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    status,
                    style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget vehicleExpansionTileDate(String date) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          date,
          style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500, fontSize: 10),
        ),
        const SizedBox(
          width: 10,
        ),
        const Expanded(child: Divider(color: Colors.grey, thickness: 0.5)),
      ],
    );
  }

  // Same as vehicleExpansionTileDate without divider
  Widget smallHeading(String date) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          date,
          style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500, fontSize: 10),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  InputDecoration textFieldDecoration(String lbl, borderColor) {
    return InputDecoration(
        label: Text(
          lbl,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: ThemeColors.primaryColor, fontSize: 20),
        ),
        fillColor: ThemeColors.whiteColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(3),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(3),
        ),
        // isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10));
  }

  InputDecoration dateFieldDecoration(hint, {lbl, void Function()? onTap}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      fillColor: ThemeColors.whiteColor,
      isDense: true,
      prefixIcon: InkWell(
          onTap: onTap,
          child: const Icon(
            Icons.calendar_month_outlined,
            size: 25,
            color: ThemeColors.primaryColor,
          )),
      prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
      border: const OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ThemeColors.textFormFieldColor),
      ),
      filled: true,
      labelStyle: const TextStyle(color: ThemeColors.primaryColor, fontSize: 20),
      hintText: hint,
      labelText: lbl,
      // focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(5),
      //     borderSide: BorderSide(color: ThemeColors.grey700)
      // ),
      // enabledBorder: OutlineInputBorder(
      //   borderSide:  BorderSide(color: ThemeColors.formFieldColor),
      //   borderRadius: BorderRadius.circular(5),
      // ),
    );
  }

  InputDecoration longtextFieldDecoration(String lbl, borderColor) {
    return InputDecoration(
      hintText: lbl,
      fillColor: ThemeColors.whiteColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  InputDecoration longtextFieldDecoration2(String lbl, borderColor) {
    return InputDecoration(
      hintText: lbl,
      fillColor: ThemeColors.whiteColor,
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Future showDatePickerDecoration(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(DateTime.now().year + 50),
    );
  }

  // for financial year
  Future showDatePickerDecoration2(BuildContext context) {
    DateTime fYearFrom = GlobalVariable.fYearFrom;
    DateTime fYearTo = GlobalVariable.fYearTo;

    print('902g: ${showCurrentDate()}');
    return showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: showCurrentDate() ? DateTime.now() : DateTime(fYearTo.year, fYearTo.month, fYearTo.day),
      firstDate: showCurrentDate() ? DateTime(fYearFrom.year, fYearFrom.month, fYearFrom.day) : DateTime(fYearFrom.year, fYearFrom.month, fYearFrom.day),
      lastDate: showCurrentDate() ? DateTime(fYearTo.year, fYearTo.month, fYearTo.day) : DateTime(fYearTo.year, fYearTo.month, fYearTo.day),
    );
  }

  CalendarDatePicker showDate(BuildContext context) {
    return CalendarDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      onDateChanged: (DateTime value) {
        Navigator.of(context).pop(value);
      },
    );
  }

  Widget stackedBarGraph(color, String percent, int flex) {
    return Expanded(
        flex: flex,
        child: Container(
          padding: const EdgeInsets.only(left: 5),
          width: 100,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(color), Color(color).withOpacity(0.7)],
            ),
          ),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "$percent%",
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              )),
        ));
  }

  Widget graphTitle(String title, int flex) {
    return Expanded(
        flex: flex,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 10, color: ThemeColors.grey),
            ),
            Container(
              width: 0.5,
              height: 10,
              color: ThemeColors.grey,
              margin: const EdgeInsets.only(left: 1),
            ),
            const SizedBox(
              height: 3,
            )
          ],
        ));
  }

  Widget graphInfo(String title, String time, String percent) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                  )),
              Expanded(
                  flex: 3,
                  child: Text(
                    time,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  )),
              Expanded(flex: 1, child: Text("$percent%", style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end)),
            ],
          ),
        ),
      ],
    );
  }

  Widget greyDivider() {
    return const Divider(
      color: Colors.grey,
    );
  }

  Widget reportTable(String date, String atm, String amount, String desc, String name) {
    return Container(
      padding: const EdgeInsets.only(top: 3, left: 3, right: 3),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: ThemeColors.grey, width: 0.3))),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    atm,
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                amount,
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                desc,
                style: const TextStyle(overflow: TextOverflow.clip, fontSize: 10),
              ),
            ),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepperContainer(String title, Widget widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextDecorationClass().stepperFormTitle(title),
        const SizedBox(
          height: 5,
        ),
        const Divider(),
        Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: widget,
        ),
        const Divider(),
      ],
    );
  }

  Widget addMore(String info) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(5)),
      child: Text(
        info,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget orderDetails(String title, Widget dropdown) {
    return Row(
      children: [
        Expanded(
            child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        const SizedBox(
          width: 0,
        ),
        dropdown
      ],
    );
  }

  Widget orderDetails2(String title, Widget dropdown) {
    return Row(
      children: [
        Expanded(
            child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        Expanded(
          child: Row(
            children: [
              dropdown,
            ],
          ),
        ),
      ],
    );
  }

  /// Vehicle Dashboard
  Widget vehicleDocCard(Color color, String icon, String cardTitle, String qty1, String qty2, String qty3) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),

        /// border: Border.all(color: ThemeColors.primaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: 0.1,
            blurRadius: 3,
            // offset: const Offset(3, 3)
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 110,
            decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(topLeft: Radius.circular(7), bottomLeft: Radius.circular(7))),
            child: Image.asset(
              icon,
              color: Colors.white,
              height: 100,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextDecorationClass().title1(cardTitle, color),
              const SizedBox(
                height: 5,
                width: 190,
                child: Divider(),
              ),
              TextDecorationClass().currentMonth(qty1),
              const SizedBox(
                height: 5,
                width: 190,
                child: Divider(),
              ),
              TextDecorationClass().nextMonth(qty2),
              const SizedBox(
                height: 5,
                width: 190,
                child: Divider(),
              ),
              TextDecorationClass().docExpired(qty3)
            ],
          ),
        ],
      ),
    );
  }

  Widget noteText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: Row(
        children: [
          // dot
          Container(
            margin: const EdgeInsets.only(top: 3),
            height: 4,
            width: 4,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: ThemeColors.darkRedColor),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: const TextStyle(color: ThemeColors.darkRedColor, fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  /// Dashboard Navigation button
  Widget navigationButton(String title, Color color1, dynamic icon, Color color2, Color background) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 72,
      width: 200,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: color2, fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color: Colors.lightGreen.shade100
                    color: color1),
                child: Icon(
                  icon,
                  color: color2,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget navigationButton2(String title, Color color1, dynamic icon, Color color2) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 72,
      width: 200,
      decoration: BoxDecoration(
        // color: Colors.white,
        color: color2,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: color1, fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    // color: Colors.lightGreen.shade100
                    color: Colors.white),
                child: Icon(
                  icon,
                  color: color2,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Dropdown Decoration
  Widget dropDown(flex, child, {double? width}) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 35,
        width: width,
        // padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade400)),
        child: child,
      ),
    );
  }

  /// DataTable ButtonDecoration
  Widget actionButton(Color color, Widget child) {
    return Container(
      height: 20,
      width: 20,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: child,
    );
  }

  Icon editIcon() {
    return const Icon(
      Icons.edit,
      size: 15,
      color: Colors.white,
    );
  }

  Icon deleteIcon() {
    return const Icon(
      Icons.delete,
      size: 15,
      color: Colors.white,
    );
  }

  Icon infoIcon() {
    return const Icon(
      Icons.info_outlined,
      size: 15,
      color: Colors.white,
    );
  }

  // for info popup
  Widget info(String title, String value) {
    return Row(
      children: [
        Expanded(
            child: Text(
          title,
          textAlign: TextAlign.end,
        )),
        const SizedBox(
          width: 50,
        ),
        Expanded(child: Text(value))
      ],
    );
  }

  /// Static Dashboards

  /// Account Dashboard

  BoxDecoration dashboardBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: Colors.grey.shade300),
      // boxShadow: [
      //   BoxShadow(
      //       color: Colors.grey.shade300,
      //       blurRadius: 3,
      //       spreadRadius: 0.5
      //   ),
      // ]
    );
  }

  Widget cardWidget(String heading, String heading2, String subHeading, IconData icon, Color borderColor, double percent, String percentText) {
    return Expanded(
      child: Container(
        decoration: dashboardBox(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: 270,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(topLeft: Radius.circular(3) , topRight: Radius.circular(3)),
                border: Border(bottom: BorderSide(style: BorderStyle.solid, width: 4, color: borderColor)),
                boxShadow: [BoxShadow(color: Colors.grey.shade400, spreadRadius: .5, blurRadius: 3)]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Heading
                Text(
                  heading,
                  style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 0,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Icon
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0, top: 5),
                      child: Icon(
                        icon,
                        color: borderColor,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),

                    /// Heading2
                    Text(
                      heading2,
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),

                    /// subHeading
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        subHeading,
                        style: const TextStyle(fontSize: 23, color: Colors.grey),
                      ),
                    ),
                    const Spacer(),

                    /// Graph
                    SizedBox(
                      height: 60,
                      child: CircularPercentIndicator(
                        radius: 25.0,
                        lineWidth: 3.0,
                        animation: true,
                        animationDuration: 3000,
                        percent: percent,
                        animateFromLastPercent: true,
                        center: Text(
                          percentText,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        // progressColor: Colors.tealAccent,
                        linearGradient: LinearGradient(colors: [borderColor, borderColor]),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget targetCard(String percent, Color color, double percentage, String title) {
    return Expanded(
      child: Container(
        width: 300,
        decoration: dashboardBox(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15, bottom: 10),
              child: LinearPercentIndicator(
                lineHeight: 4,
                leading: Text(
                  percent,
                  style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                progressColor: color,
                barRadius: const Radius.circular(5),
                percent: percentage,
                animation: true,
                animationDuration: 1200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 8),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Trip Management Dashboard
  Widget topCardWidget(IconData icon, String qty, String title, Color color) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(color: color)),
      child: Row(
        children: [
          /// Icon
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadiusDirectional.circular(5),
            ),
            child: Icon(
              icon,
              size: 30,
              color: color,
            ),
          ),

          const SizedBox(
            width: 20,
          ),

          /// details
          Padding(
            padding: const EdgeInsets.only(bottom: 9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  qty.toUpperCase(),
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                ),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget greenCard(String title, String qty, double width) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xff135846),
          borderRadius: BorderRadiusDirectional.circular(5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                ),
                Text(
                  qty,
                  style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
                )
              ],
            ),

            const SizedBox(
              height: 15,
            ),

            /// horizontal line
            Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xff42796b),
                    borderRadius: BorderRadiusDirectional.circular(20),
                  ),
                ),
                Container(
                  width: width,
                  height: 10,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget moreDetails(String qty, String title) {
    return Column(
      children: [
        Text(
          qty,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade800),
        )
      ],
    );
  }

  Widget driverUpdates(String fromToLocation, String assets, String driverName, String time, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Driver Image
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(assets),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fromToLocation,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        driverName,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                      ),
                      Text(
                        time,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),

          /// Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
            child: Text(
              status,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  /// Orders Dashboard
  Widget orderCards(Color background, Color color, String qty, Icon icon, Icon icon2, String title, String percent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Row1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// qty + arrow
              Row(
                children: [
                  Text(
                    qty,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  icon
                ],
              ),
              const SizedBox(
                width: 100,
              ),
              icon2
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          /// Row2
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// title + percentage
              Text(
                title,
                style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                width: 100,
              ),
              Text(
                percent,
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 13),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget linerGraph(String companyName, String percent, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Company Name & profit
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              companyName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            )),
            Text(
              percent,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        LinearPercentIndicator(
          lineHeight: 8,
          padding: const EdgeInsets.all(0),
          progressColor: Colors.blue,
          barRadius: const Radius.circular(2),
          percent: percentage,
          animation: true,
          animationDuration: 1200,
        ),
      ],
    );
  }

  Widget salesUpdate(Color color, String title, String percentage, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 6,
              width: 6,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 50,
            ),
            Text(
              percentage,
              style: const TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.arrow_upward,
              size: 15,
              color: Colors.green,
            )
          ],
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  /// Vehicle Management Dashboard
  Widget topInfo(Color color, String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 0),
                height: 7,
                width: 7,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
              )
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
          )
        ],
      ),
    );
  }

  Widget topInfo2(Color color, String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 6,
                width: 6,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.red.shade700),
              )
            ],
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25, color: Colors.red.shade700),
          )
        ],
      ),
    );
  }

  Widget statusInfo(Color color, String status, String percentage, String total) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          height: 8,
          width: 8,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(1)),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            flex: 2,
            child: Text(
              status,
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey.shade700),
            )),
        Expanded(
            child: Text(
          percentage,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
        )),
        Expanded(
            child: Text(
          "$total Vehicles",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey.shade600),
          textAlign: TextAlign.end,
        )),
      ],
    );
  }

  Widget vehicleLeft(String vehicleNo, String time) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Text(
              vehicleNo,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w500),
            )),
        Expanded(
            child: Text(
          time,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w400),
          textAlign: TextAlign.end,
        )),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.arrow_back,
              size: 15,
              color: Colors.orange,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "Left",
              style: TextStyle(color: Colors.grey.shade800, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        )),
      ],
    );
  }

  Widget vehicleEntered(String vehicleNo, String time) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Text(
              vehicleNo,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w500),
            )),
        Expanded(
            child: Text(
          time,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w400),
          textAlign: TextAlign.end,
        )),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.arrow_forward,
              size: 15,
              color: Colors.blue,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "Entered",
              style: TextStyle(color: Colors.grey.shade800, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        )),
      ],
    );
  }

  // Total Amount Show
  //Total Amount Show
  Widget totalAmountLabel(title, {background = false, backgroundColor, foregroundColor}) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 4, right: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: background == false ? Colors.white : backgroundColor, border: Border.all(color: background == false ? Colors.grey.shade300 : backgroundColor), borderRadius: BorderRadius.circular(5)),
      height: 45,
      child: Text(
        title,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: background == false ? Colors.black : foregroundColor),
      ),
    );
  }

  Widget totalAmount(amount) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 2, right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(color: ThemeColors.whiteColor, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(5)),
      height: 45,
      child: Text(
        amount,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget totalAmount(title,amount){
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Container(
  //           margin: const EdgeInsets.only(top: 5 , left: 4 , right: 2),
  //           padding: const EdgeInsets.only(left: 10),
  //           alignment: Alignment.centerLeft,
  //           decoration: BoxDecoration(
  //               color: ThemeColors.whiteColor,
  //               border: Border.all(color: Colors.grey.shade300),
  //               borderRadius: BorderRadius.circular(5)
  //           ),
  //           height: 45,
  //           child: Text(title , style: const TextStyle(fontSize: 17 , fontWeight: FontWeight.bold),),
  //         ),
  //       ),
  //       Expanded(
  //         child: Container(
  //           margin: const EdgeInsets.only(top: 5, left: 2 , right: 4),
  //           padding: const EdgeInsets.only(left: 10),
  //           alignment: Alignment.centerLeft,
  //           decoration: BoxDecoration(
  //               color: ThemeColors.whiteColor,
  //               border: Border.all(color: Colors.grey.shade300),
  //               borderRadius: BorderRadius.circular(5)
  //           ),
  //           height: 45,
  //           child: Text(amount , style: const TextStyle(fontSize: 17 , fontWeight: FontWeight.bold),),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // vehicle update
  Widget vehicleInfo(String title, String value) {
    return Container(
      width: 230,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(border: Border.all(color: ThemeColors.textFormFieldColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "$title ",
                style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
            ],
          ),
          // Text(value , style: const TextStyle(fontWeight: FontWeight.w500 , fontSize: 14),),
        ],
      ),
    );
  }

  Widget paginationFunc(String totalRecords, {void Function()? firstOnPressed, void Function()? prevOnPressed, void Function()? nextOnPressed, void Function()? lastOnPressed}) {
    return // Pagination
        Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Total Records: $totalRecords"),

        const SizedBox(
          width: 100,
        ),

        // First Page Button
        IconButton(
          onPressed: firstOnPressed,
          icon: const Icon(Icons.first_page),
        ),

        // Prev Button
        IconButton(
          onPressed: prevOnPressed,
          icon: const Icon(Icons.chevron_left),
        ),

        const SizedBox(
          width: 30,
        ),

        // Next Button
        IconButton(
          onPressed: nextOnPressed,
          icon: const Icon(Icons.chevron_right),
        ),

        // Last Page Button
        IconButton(
          onPressed: lastOnPressed,
          icon: const Icon(Icons.last_page),
        ),
      ],
    );
  }

  // Widget deleteButtonDecoration({required BuildContext context, required void Function()? onPressed}){
  //   return  Container(
  //     height: 20,
  //     width: 20,
  //     margin: const EdgeInsets.all(1),
  //     decoration: BoxDecoration(color: ThemeColors.deleteColor, borderRadius: BorderRadius.circular(5)),
  //     child: IconButton(padding: const EdgeInsets.all(0),onPressed: () {
  //       showDialog(context: context, builder: (context) {
  //         return
  //           AlertDialog(
  //             title: const Text("Are you sure you want to delete"),
  //             actions: [
  //               TextButton(onPressed: () {
  //                 Navigator.pop(context);
  //               }, child: const Text("Cancel")),
  //
  //               TextButton(
  //                 style: TextButton.styleFrom(
  //                     backgroundColor: ThemeColors.darkRedColor,
  //                     foregroundColor: Colors.white
  //                 ),
  //                 onPressed: onPressed,
  //                 child: const Text("Delete"),
  //               )
  //             ],
  //           );
  //       },);
  //     }, icon: const Icon(Icons.delete, size: 15, color: Colors.white,)),
  //   );
  // }

  TextButton deleteButton({required BuildContext context, required void Function()? onPressed}){
    return  TextButton(
        style: TextButton.styleFrom(
            backgroundColor: ThemeColors.darkRedColor,
            foregroundColor: Colors.white
        ),
        onPressed: onPressed,
        child: const Text("Delete"),
    );
  }

  TextButton cancelButton({required BuildContext context, required void Function()? onPressed}){
    return  TextButton(onPressed:onPressed , child: const Text("Cancel"));
  }


}

//==========================================================================

class TextDecorationClass {
  Widget formTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w500, color: ThemeColors.titleColor, fontSize: 18),
    );
  }

  // Widget fieldTitle(String text) {
  //   return Text(
  //     text,
  //     style: const TextStyle(color: ThemeColors.formTextColor, fontWeight: FontWeight.w500),
  //     textAlign: TextAlign.end,
  //   );
  // }

  Widget fieldTitle(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.w500),
      textAlign: TextAlign.end,
    );
  }

  Widget fieldTitleColor(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.w500),
      textAlign: TextAlign.end,
    );
  }

  /// DataTable Column & Row
  Widget dataColumnName(String columnName) {
    return Text(columnName);
  }

  Widget dataRowCell(String dataCell) {
    return Text(dataCell);
  }

  Widget subHeading2(String heading, {fontSize = false, textOverflow = false}) {
    return Text(
      heading,
      style: TextStyle(color: ThemeColors.darkBlack, fontSize: fontSize == false ? 17 : fontSize, overflow: textOverflow == false ? TextOverflow.ellipsis : textOverflow, fontWeight: FontWeight.w400),
    );
  }

  Widget tableHeading(String heading) {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 7, left: 9),
      color: const Color(0xffb3e0ff),
      alignment: Alignment.centerLeft,
      child: TextDecorationClass().heading(heading),
    );
  }

  Widget tableSubHeading(String heading) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      alignment: Alignment.topLeft,
      child: Text(
        heading,
        style: const TextStyle(
            color: Colors.black54, fontSize: 17, fontWeight: FontWeight.w500),
        textAlign: TextAlign.start,
      ),
    );
  }

  // align start
  Widget fieldTitle2(String text) {
    return Text(
      text,
      style: const TextStyle(color: ThemeColors.formTextColor, fontWeight: FontWeight.bold),
      textAlign: TextAlign.start,
    );
  }

  Widget heading(String heading) {
    return Text(
      heading,
      style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  Widget subHeading(String heading) {
    return Expanded(
      child: Text(
        heading,
        style: const TextStyle(
          color: ThemeColors.darkBlack,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.end,
      ),
    );
  }

  // Widget subHeading(String heading) {
  //   return Expanded(
  //     child: Text(
  //       heading,
  //       style: const TextStyle(
  //           color: ThemeColors.darkBlack,
  //           fontSize: 17,
  //           fontWeight: FontWeight.bold,
  //           overflow: TextOverflow.clip
  //       ),
  //       textAlign: TextAlign.end,
  //     ),
  //   );
  // }

  Widget heading1(String heading) {
    return Text(
      heading,
      style: const TextStyle(color: ThemeColors.darkBlack, fontSize: 17, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
      textAlign: TextAlign.end,
    );
  }
  Widget blueHeading(String heading) {
    return Text(
      heading,
      style: const TextStyle(color: Colors.blue, fontSize: 17, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
      textAlign: TextAlign.start,
    );
  }

  Widget heading2(String heading) {
    return Text(
      heading,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget title1(String title, Color color) {
    return Text(
      title,
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15),
    );
  }

  Widget currentMonth(String qty) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          qty,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const Text(
          " Current Month",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget nextMonth(String qty) {
    return Row(
      children: [
        Text(
          qty,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const Text(
          " Next Month",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget docExpired(String qty) {
    return Row(
      children: [
        Text(
          qty,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: ThemeColors.darkRedColor),
        ),
        const Text(
          " Expired",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ThemeColors.darkRedColor),
        ),
      ],
    );
  }

  // Widget subHeading2(String heading) {
  //   return Text(
  //     heading,
  //     style: const TextStyle(color: ThemeColors.darkBlack, fontSize: 17, fontWeight: FontWeight.w400),
  //   );
  // }

  Widget inTransitText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
    );
  }

  Widget accountsHeading(String heading) {
    return Expanded(
      child: Text(
        heading,
        style: const TextStyle(color: ThemeColors.primaryColor, fontSize: 15, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
        textAlign: TextAlign.start,
      ),
    );
  }

  // Stepper
  Widget stepperText(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget stepperFormTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, color: ThemeColors.darkRedColor),
    );
  }

  // Vehicle Assign
  Widget documentStatus(String title) {
    return Expanded(child: Text(title));
  }

  //  Button Text
  Widget buttonText(String text) {
    return Text(
      text,
      style: const TextStyle(),
    );
  }

  // Dropdown
  TextStyle dropDownText() {
    return const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis);
  }

  // Dashboard Buttons
  TextStyle dashboardBtn() {
    return TextStyle(color: ThemeColors.primary, fontSize: 17);
  }

  //====================
  Widget tableSubHeading2(String heading) {
    return Text(
      heading,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      textAlign: TextAlign.start,
    );
  }

  Widget vehicleDocInfo(String heading) {
    return Text(
      heading,
      style: TextStyle(color: ThemeColors.primary.withOpacity(.9), fontSize: 15, fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.right,
    );
  }
}

//==========================================================================

class FormWidgets {
  InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      contentPadding: const EdgeInsets.all(8),
      isDense: true,
      enabled: true,
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    );
  }

  Widget formDetails(String title, String hintText, TextEditingController controller, {optional = false, maxLines, validator, onSaved}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // Input Name
              child: TextDecorationClass().fieldTitle(title),
            ),

            optional == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),

            const SizedBox(
              width: 20,
            ),

            // TextFormField
            Expanded(
              flex: 4,
              child: TextFormField(
                controller: controller,
                validator: validator,
                onSaved: onSaved,
                maxLines: maxLines,
                // decoration: inputDecoration(hintText),
                decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget formDetails9(String title, String hintText, TextEditingController controller, {optional = false} /*List<TextInputFormatter> textFormatter*/) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),
            optional == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 4,
              child: TextFormField(
                // inputFormatters: textFormatter,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: controller,
                // decoration: inputDecoration(hintText),
                decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget formDetails8(String title, String hintText, TextEditingController controller, {maxLines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextDecorationClass().fieldTitle2(title),
        const SizedBox(
          width: 10,
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.grey),
        ),
      ],
    );
  }

  Widget formDetails10(String title, Widget widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextDecorationClass().fieldTitle2(title),
        const SizedBox(
          width: 10,
        ),
        widget
      ],
    );
  }

  Widget formDetails2(String title, Widget dropdown, {optional = false}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // text field name
            Expanded(child: TextDecorationClass().fieldTitle(title)),

            // if field is required "*" will appear : ""
            optional == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),

            const SizedBox(width: 20),

            // TextFormField || Dropdown || other widgets
            Expanded(
              flex: 4,
              child: dropdown,
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  // title and widget in column
  Widget formDetails22(String title, Widget dropdown, {optional = false}) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // text field name
            Row(
              children: [
                TextDecorationClass().fieldTitle(title),

                // if field is required "*" will appear : ""
                optional == false
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text("*", style: TextStyle(color: Colors.red)),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        child: Text("", style: TextStyle(color: Colors.red)),
                      ),
              ],
            ),

            const SizedBox(
              height: 3,
            ),

            // TextFormField || Dropdown || other widgets
            dropdown,
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget formDetails3(String title, Widget dropdown, String hintText, TextEditingController controller, {inputFormatters, readOnly = false}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field name
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),

            const SizedBox(
              width: 35,
            ),

            // Dropdown || Any Widget
            Expanded(
              child: dropdown,
            ),

            const SizedBox(
              width: 10,
            ),

            // textField
            Expanded(
                flex: 3,
                child: TextFormField(
                  controller: controller,
                  inputFormatters: inputFormatters,
                  readOnly: readOnly,
                  decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.grey),
                ))
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget formDetails4(String title, String hintText, TextEditingController controller) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 4,
              child: TextFormField(
                controller: controller,
                maxLines: 3,
                // decoration: inputDecoration(hintText),
                decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget formDetails5(String title, String hintText, String hintText2, TextEditingController controller, TextEditingController controller2) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),
            const SizedBox(
              width: 20,
            ),

            // textFormField
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  // formField 1
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.grey),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),

                  // formField2
                  Expanded(
                    child: TextFormField(
                      controller: controller2,
                      decoration: UiDecoration().outlineTextFieldDecoration(hintText2, ThemeColors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget formDetails6(String title, String hintText, String hintText2, TextEditingController controller, TextEditingController controller2) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: controller,
                      decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.grey),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controller2,
                      decoration: UiDecoration().outlineTextFieldDecoration(hintText2, ThemeColors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget formDetails7(String title, String hintText, String hintText2, TextEditingController controller, TextEditingController controller2, bool obscure, VoidCallback? onTap) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Title
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  // formField 1
                  TextFormField(
                    controller: controller,
                    decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.grey),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // formField 2
                  TextFormField(
                    controller: controller2,
                    obscureText: obscure,
                    decoration: UiDecoration().outlineTextFieldDecoration(
                      hintText2,
                      ThemeColors.grey,
                      icon: InkWell(
                          onTap: onTap,
                          child: Icon(
                            obscure == true ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget formDetailsDropDown(context, String title, String hintText, setState, List<String> list) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),
            const SizedBox(
              width: 20,
            ),
            // dropdown
            Expanded(
              flex: 4,
              child: Container(
                height: 40,
                width: 350,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: ThemeColors.grey700)),
                child: Consumer<DropdownProvider>(
                  builder: (context, value, child) {
                    return DropdownButton<String>(
                      borderRadius: BorderRadius.circular(5),
                      dropdownColor: ThemeColors.whiteColor,
                      underline: Container(
                        decoration: const BoxDecoration(border: Border()),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Select a class',
                        style: TextStyle(color: ThemeColors.darkBlack),
                      ),
                      icon: const Icon(
                        CupertinoIcons.chevron_down,
                        color: ThemeColors.darkBlack,
                        size: 20,
                      ),
                      iconSize: 30,
                      value: value.dropdownValue,
                      elevation: 16,
                      style: const TextStyle(color: ThemeColors.darkGreyColor, fontSize: 16, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        GlobalClass.dropdownValue = newValue!;
                        value.setDropdownValue();
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget textFormField(String hintText, TextEditingController controller, {onFieldSubmitted, onChanged}) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9\\s]')),
      ],
      decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
    );
  }

  Widget containerWidget(String title, String qty, color) {
    return Responsive(
      /// Mobile
      mobile: Container(
        width: 180,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        margin: const EdgeInsets.only(top: 0, right: 3, bottom: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
          // border: Border.all(color: ThemeColors.whiteColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
            ),
            const SizedBox(
              height: 0,
            ),
            Text(qty, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      /// Tablet
      tablet: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        margin: const EdgeInsets.only(top: 0, right: 3, bottom: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
          // border: Border.all(color: ThemeColors.whiteColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
            ),
            const SizedBox(
              height: 0,
            ),
            Text(qty, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      /// Desktop
      desktop: Container(
        width: 180,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        margin: const EdgeInsets.only(top: 0, right: 3, bottom: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
          // border: Border.all(color: ThemeColors.whiteColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500, overflow: TextOverflow.clip),
            ),
            const SizedBox(
              height: 0,
            ),
            Text(qty, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget numberTextField(title, controller, hintText, {void Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextDecorationClass().fieldTitle2(title),
        const SizedBox(
          width: 10,
        ),
        TextFormField(
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: controller,
          decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.grey),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget contactField(String title, String hintText, TextEditingController controller, BuildContext context, {optional = false} /*List<TextInputFormatter> textFormatter*/) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),

            // if field is required "*" will appear : ""
            optional == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),

            const SizedBox(
              width: 20,
            ),

            // textFormField
            Expanded(
              flex: 4,
              child: TextFormField(
                // inputFormatters: textFormatter,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //
                controller: controller,
                //
                decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
                //
                onChanged: (val) {
                  controller.value = TextEditingValue(
                    text: Validation.mobileNumber(val),
                    selection: TextSelection(baseOffset: Validation.mobileNumber(val).length, extentOffset: Validation.mobileNumber(val).length),
                  );
                },
                //
                validator: (value) {
                  if (optional == false) {
                    // if field is "NOT OPTIONAL"
                    if (value == null || value.isEmpty) {
                      AlertBoxes.flushBarErrorMessage("Mobile No Field is Required", context);
                      return 'Mobile No Field is Required';
                    } else if (value.length != 10) {
                      AlertBoxes.flushBarErrorMessage("Invalid Mobile No", context);
                      return 'Invalid Mobile No';
                    } else if (int.parse(value[0]) < 7) {
                      AlertBoxes.flushBarErrorMessage("Invalid Mobile No", context);
                      return 'Invalid Mobile No';
                    }
                  }

                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  // Mobile No: textField1 -- textField2 (using 2 fields in a row)
  Widget contactField2(String title, String hintText1, String hintText2, TextEditingController controller1, TextEditingController controller2, BuildContext context,
      {optional1 = false, optional2 = false} /*List<TextInputFormatter> textFormatter*/) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),

            // if field is required "*" will appear : ""
            optional1 == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),

            const SizedBox(
              width: 20,
            ),

            // textFormField
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  // Field 1
                  Expanded(
                    child: TextFormField(
                      // inputFormatters: textFormatter,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      //
                      controller: controller1,
                      //
                      decoration: UiDecoration().outlineTextFieldDecoration(hintText1, ThemeColors.primaryColor),
                      //
                      onChanged: (val) {
                        controller1.value = TextEditingValue(
                          text: Validation.mobileNumber(val),
                          selection: TextSelection(baseOffset: Validation.mobileNumber(val).length, extentOffset: Validation.mobileNumber(val).length),
                        );
                      },
                      //
                      validator: (value) {
                        if (optional1 == false) {
                          // if field is "NOT OPTIONAL"
                          if (value == null || value.isEmpty) {
                            AlertBoxes.flushBarErrorMessage("Mobile No Field is Required", context);
                            return 'Mobile No Field is Required';
                          } else if (value.length != 10) {
                            AlertBoxes.flushBarErrorMessage("Invalid Mobile No", context);
                            return 'Invalid Mobile No';
                          } else if (int.parse(value[0]) < 7) {
                            AlertBoxes.flushBarErrorMessage("Invalid Mobile No", context);
                            return 'Invalid Mobile No';
                          }
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),

                  // Field 2
                  Expanded(
                    child: TextFormField(
                      // inputFormatters: textFormatter,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      //
                      controller: controller2,
                      //
                      decoration: UiDecoration().outlineTextFieldDecoration(hintText1, ThemeColors.primaryColor),
                      //
                      onChanged: (val) {
                        controller2.value = TextEditingValue(
                          text: Validation.mobileNumber(val),
                          selection: TextSelection(baseOffset: Validation.mobileNumber(val).length, extentOffset: Validation.mobileNumber(val).length),
                        );
                      },
                      //
                      validator: (value) {
                        if (optional2 == false) {
                          // if field is "NOT OPTIONAL"
                          if (value == null || value.isEmpty) {
                            AlertBoxes.flushBarErrorMessage("Mobile No Field is Required", context);
                            return 'Mobile No Field is Required';
                          } else if (value.length != 10) {
                            AlertBoxes.flushBarErrorMessage("Invalid Mobile No", context);
                            return 'Invalid Mobile No';
                          } else if (int.parse(value[0]) < 7) {
                            AlertBoxes.flushBarErrorMessage("Invalid Mobile No", context);
                            return 'Invalid Mobile No';
                          }
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  // title and textField in Column
  Widget contactField3(String title, String hintText, TextEditingController controller, BuildContext context, {optional = false} /*List<TextInputFormatter> textFormatter*/) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Row(
              children: [
                TextDecorationClass().fieldTitle(title),

                // if field is required "*" will appear : ""
                optional == false
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text("*", style: TextStyle(color: Colors.red)),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        child: Text("", style: TextStyle(color: Colors.red)),
                      ),
              ],
            ),

            const SizedBox(
              height: 3,
            ),

            // textFormField
            TextFormField(
              // inputFormatters: textFormatter,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //
              controller: controller,
              //
              decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
              //
              onChanged: (val) {
                controller.value = TextEditingValue(
                  text: Validation.mobileNumber(val),
                  selection: TextSelection(baseOffset: Validation.mobileNumber(val).length, extentOffset: Validation.mobileNumber(val).length),
                );
              },
              //
              validator: (value) {
                if (optional == false) {
                  // if field is "NOT OPTIONAL"
                  if (value == null || value.isEmpty) {
                    AlertBoxes.flushBarErrorMessage("Mobile No Field is Required", context);
                    return 'Mobile No Field is Required';
                  } else if (value.length != 10) {
                    AlertBoxes.flushBarErrorMessage("Invalid Mobile No", context);
                    return 'Invalid Mobile No';
                  } else if (int.parse(value[0]) < 7) {
                    AlertBoxes.flushBarErrorMessage("Invalid Mobile No", context);
                    return 'Invalid Mobile No';
                  }
                }

                return null;
              },
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget nameAgeField(String title, String hintText1, String hintText2, TextEditingController controller1, TextEditingController controller2, BuildContext context,
      {optional1 = false, optional2 = false} /*List<TextInputFormatter> textFormatter*/) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),

            // if field is required "*" will appear : ""
            optional1 == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),

            const SizedBox(
              width: 20,
            ),

            // textFormField
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  // Field 1
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      // inputFormatters: textFormatter,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z\\s]')),
                      ],
                      //
                      controller: controller1,
                      //
                      decoration: UiDecoration().outlineTextFieldDecoration(hintText1, ThemeColors.primaryColor),
                      //
                      onChanged: (val) {
                        controller1.value = TextEditingValue(
                          text: Validation.name(val),
                          selection: TextSelection(baseOffset: Validation.name(val).length, extentOffset: Validation.name(val).length),
                        );
                      },
                      //
                      validator: (value) {
                        if (optional1 == false) {
                          // if field is "NOT OPTIONAL"
                          if (value == null || value.isEmpty) {
                            AlertBoxes.flushBarErrorMessage("Enter $title", context);
                            return 'Enter $title';
                          } else if (!RegExp(r'^[a-zA-Z\\s]').hasMatch(value)) {
                            return 'Special Characters Not Allowed';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),

                  // Field 2
                  Expanded(
                    child: TextFormField(
                      // inputFormatters: textFormatter,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      //
                      controller: controller2,
                      //
                      decoration: UiDecoration().outlineTextFieldDecoration(hintText2, ThemeColors.primaryColor),
                      //
                      onChanged: (val) {
                        controller2.value = TextEditingValue(
                          text: Validation.age(val),
                          selection: TextSelection(baseOffset: Validation.age(val).length, extentOffset: Validation.age(val).length),
                        );
                      },
                      //
                      validator: (value) {
                        if (optional2 == false) {
                          // if field is "NOT OPTIONAL"
                          if (value == null || value.isEmpty) {
                            AlertBoxes.flushBarErrorMessage("Age Field is Required", context);
                            return 'Age is Required';
                          }
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget emailField(String title, String hintText, TextEditingController controller, BuildContext context, {optional = false}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Field Name
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),

            // if field is required "*" will appear : ""
            optional == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),

            const SizedBox(width: 20),

            // textFormField
            Expanded(
              flex: 4,
              child: TextFormField(
                //
                controller: controller,
                //
                decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
                //
                validator: (value) {
                  if (optional == false) {
                    // if field is "NOT OPTIONAL" - field is required
                    if (value == null || value.isEmpty) {
                      // if field is "null" || "empty ;
                      AlertBoxes.flushBarErrorMessage("Email ID Field is Required", context);
                      return 'Email ID Field is Required';
                    } else if (!RegExp(r"^[a-zA-Z\d.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+").hasMatch(value)) {
                      // if field value is wrong || does not match with regExp
                      AlertBoxes.flushBarErrorMessage("Enter a valid email!", context);
                      return 'Enter a valid email!';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget numberField(String title, String hintText, TextEditingController controller, BuildContext context, {optional = false, validLabel}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),

            // if field is required "*" will appear : ""
            optional == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),

            const SizedBox(
              width: 20,
            ),

            // textFormField
            Expanded(
              flex: 4,
              child: TextFormField(
                //
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                //
                controller: controller,
                //
                decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
                //
                validator: (value) {
                  if (optional == false) {
                    // if field is NOT OPTIONAL
                    if (value == null || value.isEmpty) {
                      AlertBoxes.flushBarErrorMessage("Enter $title", context);
                      return 'Enter $title';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  // title and textField in Column
  Widget numberField2(String title, String hintText, TextEditingController controller, BuildContext context, {optional = false, validLabel}) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Row(
              children: [
                TextDecorationClass().fieldTitle(title),

                // if field is required "*" will appear : ""
                optional == false
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text("*", style: TextStyle(color: Colors.red)),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        child: Text("", style: TextStyle(color: Colors.red)),
                      ),
              ],
            ),

            const SizedBox(
              height: 3,
            ),

            // textFormField
            TextFormField(
              //
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              //
              controller: controller,
              //
              decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
              //
              validator: (value) {
                if (optional == false) {
                  // if field is NOT OPTIONAL
                  if (value == null || value.isEmpty) {
                    AlertBoxes.flushBarErrorMessage("Enter $title", context);
                    return 'Enter $title';
                  }
                }
                return null;
              },
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget textField(String title, String hintText, TextEditingController controller, BuildContext context, {optional = false, validLabel, maxLines = 1}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),

            // if field is required "*" will appear : ""
            optional == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),

            const SizedBox(
              width: 20,
            ),

            // textFormField
            Expanded(
              flex: 4,
              child: TextFormField(
                //
                controller: controller,
                //
                decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
                //
                validator: (value) {
                  if (optional == false) {
                    // if field is NOT OPTIONAL
                    if (value == null || value.isEmpty) {
                      AlertBoxes.flushBarErrorMessage("Enter $title", context);
                      return 'Enter $title';
                    }
                  }
                  return null;
                },
                //
                maxLines: maxLines,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  // title and textField are in Column
  Widget textField2(String title, String hintText, TextEditingController controller, BuildContext context, {optional = false, validLabel, maxLines = 1}) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Row(
              children: [
                TextDecorationClass().fieldTitle(title),
                // if field is required "*" will appear : ""
                optional == false
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text("*", style: TextStyle(color: Colors.red)),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        child: Text("", style: TextStyle(color: Colors.red)),
                      ),
              ],
            ),
            const SizedBox(
              height: 3,
            ),

            // textFormField
            TextFormField(
              //
              controller: controller,
              //
              decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
              //
              validator: (value) {
                if (optional == false) {
                  // if field is NOT OPTIONAL
                  if (value == null || value.isEmpty) {
                    AlertBoxes.flushBarErrorMessage("Enter $title", context);
                    return 'Enter $title';
                  }
                }
                return null;
              },
              //
              maxLines: maxLines,
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget passwordField(String title, String hintText, TextEditingController controller, BuildContext context, {optional = false, validLabel, obscureText}) {
    // bool isVisible = false;
    ValueNotifier<bool> isVisible = ValueNotifier<bool>(false);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),

            // if field is required "*" will appear : ""
            optional == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),

            const SizedBox(
              width: 20,
            ),

            // textFormField
            Expanded(
              flex: 4,
              // using "ValueListenableBuilder" to show or hide password on icon tap
              child: ValueListenableBuilder(
                valueListenable: isVisible,
                builder: (context, value, child) {
                  return TextFormField(
                    //
                    controller: controller,
                    //
                    obscureText: isVisible.value == true ? false : true,
                    //
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      suffixIconConstraints: const BoxConstraints(minHeight: 35),
                      fillColor: Colors.white,
                      isDense: true,
                      border: const OutlineInputBorder(),
                      suffixIcon: InkWell(
                          onTap: () {
                            isVisible.value = !isVisible.value;
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(isVisible.value == true ? Icons.visibility : Icons.visibility_off),
                          )),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ThemeColors.textFormFieldColor),
                      ),
                      filled: true,
                      hintText: hintText,
                    ),
                    //
                    validator: (value) {
                      if (optional == false) {
                        // if field is NOT OPTIONAL
                        if (value == null || value.isEmpty) {
                          AlertBoxes.flushBarErrorMessage("Enter $title", context);
                          return 'Enter $title';
                        }
                      }
                      return null;
                    },
                    //
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  // only alphabet an space - no numbers or symbols
  Widget onlyAlphabetField(String title, String hintText, TextEditingController controller, BuildContext context,
      {optional = false, validLabel, focusNode, readOnly = false, int? maxLines = 1, obscureText = false, void Function(String)? onFieldSubmitted, FocusNode? nextFocus}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),

            // if field is required "*" will appear : ""
            optional == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),

            const SizedBox(width: 20),

            // textFormField
            Expanded(
              flex: 4,
              child: TextFormField(
                //
                controller: controller,
                //
                obscureText: obscureText,
                //
                decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
                //
                validator: (value) {
                  if (optional == false) {
                    // if field is "NOT OPTIONAL"
                    if (value == null || value.isEmpty) {
                      AlertBoxes.flushBarErrorMessage("Enter $title", context);
                      return 'Enter $title';
                    } else if (!RegExp(r'^[a-zA-Z\\s]').hasMatch(value)) {
                      return 'Special Characters Not Allowed';
                    }
                  }
                  return null;
                },
                //
                focusNode: focusNode,
                //
                onChanged: (val) {
                  controller.value = TextEditingValue(
                    text: Validation.name(val),
                    selection: TextSelection(baseOffset: Validation.name(val).length, extentOffset: Validation.name(val).length),
                  );
                },
                //
                onFieldSubmitted: onFieldSubmitted ??
                    (value) {
                      FocusScope.of(context).requestFocus(nextFocus);
                    },
                //
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z\\s]')),
                ],
                //
                readOnly: readOnly,
                //
                maxLines: maxLines,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  // only alphabet an space - no numbers or symbols (title & textField are in Column)
  Widget onlyAlphabetField2(String title, String hintText, TextEditingController controller, BuildContext context,
      {optional = false, validLabel, focusNode, readOnly = false, int? maxLines = 1, obscureText = false, void Function(String)? onFieldSubmitted, FocusNode? nextFocus}) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Row(
              children: [
                TextDecorationClass().fieldTitle(title),
                // if field is required "*" will appear : ""
                optional == false
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text("*", style: TextStyle(color: Colors.red)),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7),
                        child: Text("", style: TextStyle(color: Colors.red)),
                      ),
              ],
            ),

            const SizedBox(
              height: 3,
            ),

            // textFormField
            TextFormField(
              //
              controller: controller,
              //
              obscureText: obscureText,
              //
              decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
              //
              validator: (value) {
                if (optional == false) {
                  // if field is "NOT OPTIONAL"
                  if (value == null || value.isEmpty) {
                    AlertBoxes.flushBarErrorMessage("Enter $title", context);
                    return 'Enter $title';
                  } else if (!RegExp(r'^[a-zA-Z\\s]').hasMatch(value)) {
                    return 'Special Characters Not Allowed';
                  }
                }
                return null;
              },
              //
              focusNode: focusNode,
              //
              onChanged: (val) {
                controller.value = TextEditingValue(
                  text: Validation.name(val),
                  selection: TextSelection(baseOffset: Validation.name(val).length, extentOffset: Validation.name(val).length),
                );
              },
              //
              onFieldSubmitted: onFieldSubmitted ??
                  (value) {
                    FocusScope.of(context).requestFocus(nextFocus);
                  },
              //
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z\\s]')),
              ],
              //
              readOnly: readOnly,
              //
              maxLines: maxLines,
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  // only alphabet , numbers and space
  Widget alphanumericField(String title, String hintText, TextEditingController controller, BuildContext context, {onFieldSubmitted, optional = false, validLabel, focusNode, onChanged, maxLines}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),

            // if field is required "*" will appear : ""
            optional == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),

            const SizedBox(
              width: 20,
            ),

            // textFormField
            Expanded(
              flex: 4,
              child: TextFormField(
                //
                controller: controller,
                //
                decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
                //
                validator: (value) {
                  if (optional == false) {
                    // if field is "NOT OPTIONAL"
                    if (value == null || value.isEmpty) {
                      AlertBoxes.flushBarErrorMessage("Enter $title", context);
                      return 'Enter $title';
                    } else if (!RegExp(r'^[a-zA-Z,\d\\s]').hasMatch(value)) {
                      return 'Special Characters Not Allowed';
                    }
                  }
                  return null;
                },
                //
                focusNode: focusNode,
                //
                onChanged: onChanged ??
                    (val) {
                      controller.value = TextEditingValue(
                        text: Validation.name(val),
                        selection: TextSelection(baseOffset: Validation.name(val).length, extentOffset: Validation.name(val).length),
                      );
                    },
                //
                onFieldSubmitted: onFieldSubmitted,
                //
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9\\s]')),
                ],
                //
                maxLines: maxLines,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  // for info
  Widget infoField(String title, String hintText, TextEditingController controller, BuildContext context, {onFieldSubmitted, optional = false, validLabel, focusNode, readOnly = true}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // field Name
            Expanded(
              child: TextDecorationClass().fieldTitle(title),
            ),

            // if field is required "*" will appear : ""
            optional == false
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("*", style: TextStyle(color: Colors.red)),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Text("", style: TextStyle(color: Colors.red)),
                  ),

            const SizedBox(
              width: 20,
            ),

            // textFormField
            Expanded(
              flex: 4,
              child: TextFormField(
                //
                controller: controller,
                //
                decoration: UiDecoration().outlineTextFieldDecoration(hintText, ThemeColors.primaryColor),
                //
                focusNode: focusNode,
                //
                readOnly: readOnly,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget textFieldDecorationContact(String heading, String hint, TextEditingController controller, {optional = false, validLabel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              optional == true
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "*",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : const Text(""),
              Expanded(
                child: Text(
                  heading,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: TextFormField(
            ///
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],

            ///
            controller: controller,

            ///
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                left: 10,
              ),
              fillColor: Colors.white,
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFDDE0E6)),
              ),
              filled: true,
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14),
            ),
            // decoration: UiDecoration().outlineTextFieldDecoration(hint, ThemeColors.primaryColor),
            ///
            onChanged: (val) {
              controller.value = TextEditingValue(
                text: Validation.mobileNumber(val),
                selection: TextSelection(baseOffset: Validation.mobileNumber(val).length, extentOffset: Validation.mobileNumber(val).length),
              );
            },

            ///
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mobile No Field is Required';
              } else if (value.length != 10) {
                return 'Invalid Mobile No';
              } else if (int.parse(value[0]) < 7) {
                return 'Invalid Mobile No';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget textFieldDecorationEmail(String heading, String hint, TextEditingController controller, {optional = false, validLabel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              optional == true
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "*",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : const Text(""),
              Expanded(
                child: Text(
                  heading,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                left: 10,
              ),
              fillColor: Colors.white,
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFDDE0E6)),
              ),
              filled: true,
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email ID Field is Required';
              } else if (!RegExp(r"^[a-zA-Z\d.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+").hasMatch(value)) {
                return 'Enter a valid email!';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget textFieldDecorationNumber(String heading, String hint, TextEditingController controller, {optional = false, validLabel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              optional == true
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "*",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : const Text(""),
              Expanded(
                child: Text(
                  heading,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: TextFormField(
            ///
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],

            ///
            controller: controller,

            ///
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                left: 10,
              ),
              fillColor: Colors.white,
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFDDE0E6)),
              ),
              filled: true,
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14),
            ),

            ///
            validator: (value) {
              if (optional == true) {
                if (value == null || value.isEmpty) {
                  return validLabel;
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

//==========================================================================

class DropdownDecoration {
  Widget dropdownDecoration(Widget child) {
    return Container(
      height: 33,
      width: 350,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: ThemeColors.textFormFieldColor)),
      child: child,
    );
  }

  Widget dropdownDecoration2(Widget child) {
    return Container(
      height: 30,
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: ThemeColors.textFormFieldColor)),
      child: child,
    );
  }

  Icon dropdownIcon() {
    return Icon(
      CupertinoIcons.chevron_down,
      color: ThemeColors.grey,
      size: 20,
    );
  }

  TextStyle dropdownTextStyle() {
    return TextStyle(color: ThemeColors.dropdownTextColor, fontSize: 16, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis);
  }
}

//==========================================================================

class InputValidation {
  Widget textFieldDecorationContact(String heading, String hint, TextEditingController controller, {optional = false, validLabel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              optional == true
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        "*",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : const Text(""),
              Expanded(
                child: Text(
                  heading,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: TextFormField(
            ///
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],

            ///
            controller: controller,

            ///
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                left: 10,
              ),
              fillColor: Colors.white,
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFDDE0E6)),
              ),
              filled: true,
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14),
            ),
            // decoration: UiDecoration().outlineTextFieldDecoration(hint, ThemeColors.primaryColor),
            ///
            onChanged: (val) {
              controller.value = TextEditingValue(
                text: Validation.mobileNumber(val),
                selection: TextSelection(baseOffset: Validation.mobileNumber(val).length, extentOffset: Validation.mobileNumber(val).length),
              );
            },

            ///
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mobile No Field is Required';
              } else if (value.length != 10) {
                return 'Invalid Mobile No';
              } else if (int.parse(value[0]) < 7) {
                return 'Invalid Mobile No';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

//==========================================================================

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(seconds: 1),
      ),
    );
}

Widget createButton({
  VoidCallback? onTap,
  required String text,
}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    ),
    child: Text(text),
  );
}
