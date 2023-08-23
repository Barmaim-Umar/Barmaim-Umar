import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';

class PdfTest extends StatefulWidget {
  const PdfTest({Key? key}) : super(key: key);

  @override
  State<PdfTest> createState() => _PdfTestState();
}

class _PdfTestState extends State<PdfTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Column(
            children: [
              ElevatedButton(onPressed: () {
                driverForm();
              }, child: const Text("PDF")),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> driverForm() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(0),
        build: (pw.Context context) {
          final container = pw.Container(
            margin: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey)),
            child: pw.Column(
              children: [

                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    /// Details
                    pw.Expanded(
                      flex: 2,
                      child: pw.Column(
                        children: [
                          /// company name
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Container(
                                  alignment: pw.Alignment.center,
                                  decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
                                  child: pw.Text("pushpak freight carrier".toUpperCase(), style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),),),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    /// Driver Image
                    pw.Expanded(
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black)
                        ),
                        child: pw.Column(
                          children: [
                            pw.Container(decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.green , width: 5)),
                                child: pw.Image(pw.MemoryImage(File('assets/driverImages/img1.jpeg',).readAsBytesSync()),width: 70),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );


          return [
            pw.Center(
              child: container,
            ),
          ];
        },
      ),
    );

    // Save the PDF to a file
    final output = await getApplicationDocumentsDirectory();
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final file = File('${output.path}/${timestamp}example.pdf');
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file
    OpenFile.open(file.path);
  }

}
