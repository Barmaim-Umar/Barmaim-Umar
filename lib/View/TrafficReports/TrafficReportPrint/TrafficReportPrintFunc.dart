import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';



class TrafficReportPrintFunction{

  Future<void> generatePrintDocument(List<List<dynamic>> printData) async {

    print('MAintainance:${printData[0][0].length}');

    final pdf = pw.Document();

    const int itemsPerPage = 30;
    // Calculate the number of pages
    final int pageCount = (printData[0][0].length / itemsPerPage).ceil();
    List<pw.Widget> widgets2213 = [];
    // Generate pages
    for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
    print('this is pageCount: $pageCount');
      // final startItemIndex = pageIndex * itemsPerPage;
      // final endItemIndex = (startItemIndex + itemsPerPage < printData.length) ? startItemIndex + itemsPerPage : printData.length;
      // final pageItems = printData.sublist(startItemIndex, endItemIndex);
      final table =
      // pw.Wrap(
      //
      //
      //     children: List.generate(printData[0][0].length, (index) => pw.Text("${printData[0][0][index].toString()}, "),)
      // );
      ///=====================================
      ///
      ///
      // pw.Text('text'),
      pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey),
        defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
        // headers: tableHeaders,
        columnWidths: {
          0:const pw.FlexColumnWidth(3),
          1:const pw.FlexColumnWidth(10),
        },
        children: [


          pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('PFC',style: const pw.TextStyle(fontSize: 17),),
                ),
                pw.Row(
                  children: [
                    pw.Row(
                      children: [
                        pw.Container(
                          margin:   const pw.EdgeInsets.all(5),
                          height: 20,
                          width: 15,
                          decoration: pw.BoxDecoration(
                              color: PdfColors.green,
                              borderRadius: pw.BorderRadius.circular(10)
                          ),
                        ),
                        pw.Text('OnRoad',style:  pw.TextStyle(fontSize: 10,fontWeight:pw.FontWeight.bold))
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Container(
                          margin: const pw.EdgeInsets.all(5),
                          height: 20,
                          width: 15,
                          decoration: pw.BoxDecoration(
                              color: PdfColors.purpleAccent,
                              borderRadius: pw.BorderRadius.circular(10)
                          ),
                        ),
                        pw.Text('Empty',style: pw.TextStyle(fontWeight:pw.FontWeight.bold , fontSize: 10),)
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Container(
                          margin: const pw.EdgeInsets.all(5),
                          height: 20,
                          width: 15,
                          decoration: pw.BoxDecoration(
                              color: PdfColors.blue.shade(700),
                              borderRadius: pw.BorderRadius.circular(10)
                          ),
                        ),
                        pw.Text('Reported',style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),)
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Container(
                          margin: const pw.EdgeInsets.all(5),
                          height: 20,
                          width: 15,
                          decoration: pw.BoxDecoration(
                              color: PdfColors.red,
                              borderRadius: pw.BorderRadius.circular(10)
                          ),
                        ),
                        pw.Text('Reported Halt',style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),)
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Container(
                          margin: const pw.EdgeInsets.all(5),
                          height: 20,
                          width: 15,
                          decoration: pw.BoxDecoration(
                              color: PdfColors.orange,
                              borderRadius: pw.BorderRadius.circular(10)
                          ),
                        ),
                        pw.Text('Unloaded',style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),)
                      ],
                    ),
                  ],
                )
              ]
          ),
          pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('Vehicle In Maintanance (${printData[0][0].length})',style: pw.TextStyle(color: PdfColors.deepOrangeAccent,fontSize: 15,fontWeight: pw.FontWeight.bold),),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Wrap(
                    spacing: 5,
                    runSpacing: 5, // Adjust the vertical spacing between items as needed
                    children: [
                      // for (int i = 0; i < trafficReport['vehicle_Maintanance'].length; i++)
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5.0),
                        child: pw.Wrap(
                          runSpacing: 10,
                            children: List.generate(100, (index) => pw.Text("${printData[0][0][index].toString()},  "),)
                        ),
                      ),
                    ],
                  ),
                ),
              ]
          ),
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                  'Vehicle Without Driver ({trafficReport[',
                  style: pw.TextStyle(color: PdfColors.brown, fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Wrap(
                  spacing: 5,
                  runSpacing: 5, // Adjust the vertical spacing between items as needed
                  children: [
                    // for (int i = 0; i < trafficReport['vehicle_without_driver'].length; i++)
                    pw.Text(
                      'MH209376,'*200,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('Pending LR (456789)',style: pw.TextStyle(color: PdfColors.blue.shade(900),fontSize: 16,fontWeight: pw.FontWeight.bold),),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Wrap(
                    spacing: 5,
                    runSpacing: 5, // Adjust the vertical spacing between items as needed
                    children: [
                      for (int i = 0; i < 10; i++)
                        pw.Text(
                          '123555888111'+',',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ]
          ),

          pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('To Location',style: pw.TextStyle(fontSize: 17,fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text('Details',style: pw.TextStyle(fontSize: 17,fontWeight: pw.FontWeight.bold),textAlign: pw.TextAlign.center),
                ),
              ]
          ),
          pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Ahmedabad',style: pw.TextStyle(fontSize: 17,fontWeight: pw.FontWeight.bold),),
                      pw.Row(
                        children: [
                          pw.Text('(1)',style: pw.TextStyle(color: PdfColors.green,fontWeight: pw.FontWeight.bold,fontSize: 16),),
                          pw.Text('(1)',style: pw.TextStyle(color: PdfColors.purpleAccent,fontWeight: pw.FontWeight.bold,fontSize: 16)),
                          pw.Text('(1)',style: pw.TextStyle(color: PdfColors.blue.shade(900),fontWeight: pw.FontWeight.bold,fontSize: 16)),
                          pw.Text('(1)',style: pw.TextStyle(color: PdfColors.orange,fontWeight: pw.FontWeight.bold,fontSize: 16)),
                        ],
                      )
                    ],
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(right: 8.0,left: 8),
                  child: pw.Wrap(
                    spacing: 5,
                    children: [
                      pw.RichText(
                          text:  pw.TextSpan(
                              text: 'MH18BG2368',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold,color: PdfColors.green,fontSize: 17),
                              children: [
                                pw.TextSpan(text: ' Ranjangaon(PEP|02-08)',style: pw.TextStyle(fontStyle: pw.FontStyle.italic,fontWeight: pw.FontWeight.bold))
                              ]
                          )
                      ),
                      pw.RichText(
                          text: pw.TextSpan(
                              text: 'MH18BG2368',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold,color: PdfColors.blue.shade(900),fontSize: 17),
                              children: [
                                pw.TextSpan(text: ' Ranjangaon(PEP|02-08)',style: pw.TextStyle(fontStyle: pw.FontStyle.italic,fontWeight: pw.FontWeight.normal))
                              ]
                          )
                      ),
                      pw.RichText(
                          text:  pw.TextSpan(
                              text: 'MH18BG2368',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold,color: PdfColors.purpleAccent,fontSize: 17),
                              children: [
                                pw.TextSpan(text: ' Ranjangaon(PEP|02-08)',style: pw.TextStyle(fontStyle: pw.FontStyle.italic,fontWeight: pw.FontWeight.bold))
                              ]
                          )
                      ),
                      pw.RichText(
                          text:  pw.TextSpan(
                              text: 'MH18BG2368',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal,color: PdfColors.red,fontSize: 17),
                              children: [
                                pw.TextSpan(text: ' Ranjangaon(PEP|02-08)',style: pw.TextStyle(fontStyle: pw.FontStyle.italic,fontWeight: pw.FontWeight.normal))
                              ]
                          )
                      ),
                      pw.RichText(
                          text:  pw.TextSpan(
                              text: 'MH18BG2368',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal,color: PdfColors.red,fontSize: 17),
                              children: [
                                pw.TextSpan(text: ' Ranjangaon(PEP|02-08)',style: pw.TextStyle(fontStyle:  pw.FontStyle.italic,fontWeight:  pw.FontWeight.normal))
                              ]
                          )
                      ),  pw.RichText(
                          text:  pw.TextSpan(
                              text: 'MH18BG2368',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal,color: PdfColors.red,fontSize: 17),
                              children: [
                                pw.TextSpan(text: ' Ranjangaon(PEP|02-08)',style: pw.TextStyle(fontStyle:  pw.FontStyle.italic,fontWeight:  pw.FontWeight.normal))
                              ]
                          )
                      ),  pw.RichText(
                          text:  pw.TextSpan(
                              text: 'MH18BG2368',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal,color: PdfColors.red,fontSize: 17),
                              children: [
                                pw.TextSpan(text: ' Ranjangaon(PEP|02-08)',style: pw.TextStyle(fontStyle:  pw.FontStyle.italic,fontWeight:  pw.FontWeight.normal))
                              ]
                          )
                      ),  pw.RichText(
                          text:  pw.TextSpan(
                              text: 'MH18BG2368',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal,color: PdfColors.red,fontSize: 17),
                              children: [
                                pw.TextSpan(text: ' Ranjangaon(PEP|02-08)',style: pw.TextStyle(fontStyle:  pw.FontStyle.italic,fontWeight:  pw.FontWeight.normal))
                              ]
                          )
                      ),  pw.RichText(
                          text:  pw.TextSpan(
                              text: 'MH18BG2368',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal,color: PdfColors.red,fontSize: 17),
                              children: [
                                pw.TextSpan(text: ' Ranjangaon(PEP|02-08)',style: pw.TextStyle(fontStyle:  pw.FontStyle.italic,fontWeight:  pw.FontWeight.normal))
                              ]
                          )
                      ),
                    ],
                  ),
                ),
              ]
          ),
          pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Amravati',style: pw.TextStyle(fontSize: 17,fontWeight: pw.FontWeight.bold),),
                      pw.Row(
                        children: [
                          pw.Text('(1)',style: pw.TextStyle(color: PdfColors.green,fontWeight: pw.FontWeight.bold,fontSize: 16),),
                          pw.Text('(1)',style: pw.TextStyle(color: PdfColors.purpleAccent,fontWeight: pw.FontWeight.bold,fontSize: 16)),
                          pw.Text('(1)',style: pw.TextStyle(color: PdfColors.blue.shade(600),fontWeight: pw.FontWeight.bold,fontSize: 16)),
                          pw.Text('(1)',style: pw.TextStyle(color: PdfColors.orange,fontWeight: pw.FontWeight.bold,fontSize: 16)),
                        ],
                      )
                    ],
                  ),
                ),
                pw.Text('')
              ]
          ),
          pw.TableRow(
              children: [
                pw.Padding(
                  padding: const  pw.EdgeInsets.all(8.0),
                  child: pw.Column(
                    mainAxisAlignment:  pw.MainAxisAlignment.start,
                    crossAxisAlignment:  pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Akola',style: pw.TextStyle(fontSize: 17,fontWeight:  pw.FontWeight.bold),),
                      pw.Row(
                        children: [
                          pw.Text('(1)',style:  pw.TextStyle(color:  PdfColors.green,fontWeight:  pw.FontWeight.bold,fontSize: 16),),
                          pw.Text('(1)',style:  pw.TextStyle(color:  PdfColors.purpleAccent,fontWeight:  pw.FontWeight.bold,fontSize: 16)),
                          pw.Text('(1)',style:  pw.TextStyle(color:  PdfColors.blue.shade(900),fontWeight:  pw.FontWeight.bold,fontSize: 16)),
                          pw.Text('(1)',style:  pw.TextStyle(color:  PdfColors.orange,fontWeight:  pw.FontWeight.bold,fontSize: 16)),
                        ],
                      )
                    ],
                  ),
                ),
                pw.Text('')
              ]
          ),
          pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Column(
                    mainAxisAlignment:  pw.MainAxisAlignment.start,
                    crossAxisAlignment:  pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Aurangabad',style:  pw.TextStyle(fontSize: 17,fontWeight:  pw.FontWeight.bold),),
                      pw.Row(
                        children: [
                          pw.Text('(1)',style:  pw.TextStyle(color: PdfColors.green,fontWeight:  pw.FontWeight.bold,fontSize: 16),),
                          pw.Text('(1)',style:  pw.TextStyle(color: PdfColors.purpleAccent,fontWeight:  pw.FontWeight.bold,fontSize: 16)),
                          pw.Text('(1)',style:  pw.TextStyle(color: PdfColors.blue.shade(900),fontWeight:  pw.FontWeight.bold,fontSize: 16)),
                          pw.Text('(1)',style:  pw.TextStyle(color: PdfColors.orange,fontWeight:  pw.FontWeight.bold,fontSize: 16)),
                        ],
                      )
                    ],
                  ),
                ),
                pw.Text('')
              ]
          ),
        ],
      );
      ///==========================
      widgets2213.add(table);
    }
      print('ListWidgets; ${widgets2213[0]}');

    pdf.addPage(

      pw.MultiPage(
          header: (context) {
            return pw.Column(
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.all(20),
                  child: pw.Container(
                    alignment: pw.Alignment.topCenter,
                    decoration: pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.blue,  // Change this color as needed
                          width: 2,              // Change this width as needed
                        ),
                      ),
                    ),
                    child: pw.Text(
                      'PUSHPAK FREIGHT CARRIER',
                      style: pw.TextStyle(
                        color: PdfColors.blue,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // pw.SizedBox(height: 5), // Add spacing between the container and the new text
                // pw.Text(
                //   'Traffic Report',
                //   style: pw.TextStyle(
                //     color: PdfColors.black, // You can change the color
                //     fontSize: 16,
                //     fontWeight: pw.FontWeight.normal,
                //   ),
                // ),
              ],
            );
          },
          footer: (context) {
            final now = DateTime.now();
            final formattedDate = "${now.year}-${now.month}-${now.day}";
            return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  formattedDate,
                  style: pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  'Page ${context.pageNumber}',
                  style: pw.TextStyle(fontSize: 12),
                ),
              ],
            );
          },
          build: (context) => [widgets2213[0]]
      ),
    );
    // Generate the PDF as a Uint8List
    final Uint8List pdfBytes = await pdf.save();

    // Print the PDF document
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }
}