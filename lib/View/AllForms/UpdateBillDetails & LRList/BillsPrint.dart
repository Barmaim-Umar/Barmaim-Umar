import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BillData {
  String companyName;
  String address;
  // Add more properties as needed

  BillData({required this.companyName, required this.address});
}
Future<void> generateBillAndPrint() async {
  final pdf = pw.Document();
  List<BillData> bills = [
    BillData(
      companyName: ' 78545541',
      address: 'NA 1',
      // Add more properties as needed
    ),
    BillData(
      companyName: '1234562',
      address: 'Address2',
      // Add more properties as needed
    ),BillData(
      companyName: '1234562',
      address: 'Address2',
      // Add more properties as needed
    ),
    // Add more BillData objects for additional bills
  ];
  for (var billData in bills) {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(50),


        build: (pw.Context context) {
          return [
            pw.Container(
              decoration:
              pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text('PUSHPAK FREIGHT CARRIER',
                        style: pw.TextStyle(
                            fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5.0),
                    child: pw.Center(
                        child: pw.Text(
                            "Address:4 'DEVPRIYA' BUILDING, NEAR PATWARDHAN HOSPITAL , STATION ROAD ,",
                            style: pw.TextStyle(
                              fontSize: 10,
                            ))),
                  ),
                  pw.Center(
                      child: pw.Text(" AURANGABAD , MAHARASHTRA - 431005",
                          style: pw.TextStyle(fontSize: 10))),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          children: [
                            pw.Text(
                              'Tel No. ',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold),
                            ),
                            pw.SizedBox(height: 27),
                            pw.Text('Email ID',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(':0240 2342098',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                )),
                            pw.Text(':9422702203',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                )),
                            pw.Text(':9890169005/9970179797',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                )),
                            pw.Text('pushpakfreightcarrier@rediffmail.com',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                )),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Bill No.',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text('Date',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text('GST No.',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text('PAN No.',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(billData.companyName,
                                style: pw.TextStyle(
                                  fontSize: 10,
                                )),
                            pw.Text('09-09-2023',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                )),
                            pw.Text(billData.address,
                                style: pw.TextStyle(
                                  fontSize: 10,
                                )),
                            pw.Text('AACFP9617N',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.Divider(),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8.0),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('To,',
                            style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Text('WoodPecker Distilleries & breweies PVT LTD.',
                            style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                            'Plot No. 96/97 & 100 Sublayout IV, Growth Centre Industrial Area, Hassantaluk573201',
                            style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                  pw.Divider(),
                  pw.Table(
                      defaultVerticalAlignment: pw.TableCellVerticalAlignment
                          .middle,
                      // defaultColumnWidth: pw.FixedColumnWidth(50.0),


                      border: pw.TableBorder.all(
                          color: PdfColors.black, width: 1.0),
                      children: [
                        pw.TableRow(


                            children: [
                              pw.Container(
                                height: 30,
                                child: pw.Center(
                                  child: pw.Text('GR No', style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold
                                  ), textAlign: pw.TextAlign.center),
                                ),
                              ),
                              pw.Text('GR Date', style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold
                              ), textAlign: pw.TextAlign.center),
                              pw.Text('   Vehicle No  ', style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold
                              ), textAlign: pw.TextAlign.center),
                              pw.Text(' Vehicle Type ', style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold
                              ), textAlign: pw.TextAlign.center),
                              pw.Text('STN/INV NO & Date', style: pw
                                  .TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold
                              ), textAlign: pw.TextAlign.center),
                              pw.Text('From', style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold
                              ), textAlign: pw.TextAlign.center),
                              pw.Text('To', style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold
                              ), textAlign: pw.TextAlign.center),
                              pw.Text('Amount', style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold
                              ), textAlign: pw.TextAlign.center),
                            ]),
                        pw.TableRow(children: [
                          pw.Container(
                            height: 20,
                            child: pw.Center(
                              child: pw.Text('152400',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                          pw.Text('17-08-2023',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('NL01AG46163',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('37FT HQ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('    ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Aurangabad',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Hassan',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('73200',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                        ]),pw.TableRow(children: [
                          pw.Container(
                            height: 20,
                            child: pw.Center(
                              child: pw.Text('152400',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                          pw.Text('17-08-2023',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('NL01AG46163',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('37FT HQ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('    ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Aurangabad',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Hassan',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('73200',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                        ]),pw.TableRow(children: [
                          pw.Container(
                            height: 20,
                            child: pw.Center(
                              child: pw.Text('152400',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                          pw.Text('17-08-2023',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('NL01AG46163',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('37FT HQ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('    ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Aurangabad',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Hassan',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('73200',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                        ]),pw.TableRow(children: [
                          pw.Container(
                            height: 20,
                            child: pw.Center(
                              child: pw.Text('152400',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                          pw.Text('17-08-2023',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('NL01AG46163',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('37FT HQ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('    ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Aurangabad',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Hassan',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('73200',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                        ]),
                        pw.TableRow(children: [
                          pw.Container(
                            height: 20,
                            child: pw.Center(
                              child: pw.Text('152400',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                          pw.Text('17-08-2023',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('NL01AG46163',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('37FT HQ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('    ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Aurangabad',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Hassan',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('73200',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                        ]), pw.TableRow(children: [
                          pw.Container(
                            height: 20,
                            child: pw.Center(
                              child: pw.Text('152400',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                          pw.Text('17-08-2023',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('NL01AG46163',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('37FT HQ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('    ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Aurangabad',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Hassan',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('73200',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                        ]), pw.TableRow(children: [
                          pw.Container(
                            height: 20,
                            child: pw.Center(
                              child: pw.Text('152400',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                          pw.Text('17-08-2023',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('NL01AG46163',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('37FT HQ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('    ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Aurangabad',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Hassan',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('73200',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                        ]), pw.TableRow(children: [
                          pw.Container(
                            height: 20,
                            child: pw.Center(
                              child: pw.Text('152400',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                          pw.Text('17-08-2023',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('NL01AG46163',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('37FT HQ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('    ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Aurangabad',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Hassan',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('73200',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                        ]), pw.TableRow(children: [
                          pw.Container(
                            height: 20,
                            child: pw.Center(
                              child: pw.Text('152400',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                          pw.Text('17-08-2023',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('NL01AG46163',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('37FT HQ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('    ',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Aurangabad',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('Hassan',
                              style: pw.TextStyle(
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                          pw.Text('73200',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 10,
                              ), textAlign: pw.TextAlign.center),
                        ]),
                      ]),
                  pw.Row(
                      children: [
                        pw.Column(children: [
                          pw.Text('Freight Amount:72300 | ', style: pw
                              .TextStyle(fontSize: 10,))
                        ]),
                        pw.Column(children: [
                          pw.Text('Reported Date : 21-08-2023 | ', style: pw
                              .TextStyle(fontSize: 10,))

                        ]),
                        pw.Column(children: [
                          pw.Text('UnLoaded Date : 21-08-2023 | ', style: pw
                              .TextStyle(fontSize: 10,))
                        ]),

                      ]),
                  pw.SizedBox(height: 150),
                  pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.black),
                      children: [
                        pw.TableRow(
                            verticalAlignment: pw.TableCellVerticalAlignment
                                .middle,
                            children: [
                              pw.Center(child: pw.Text('Addition Charges (+)',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.center)),
                              pw.Table(
                                  border: pw.TableBorder.all(
                                      color: PdfColors.black, width: 1.0),
                                  children: [
                                    pw.TableRow(children: [
                                      pw.Text('Freight Total (A)',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight
                                                  .bold)),
                                      pw.Text('72300 ',
                                          textAlign: pw.TextAlign.right)
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text(
                                          'A 01 - Detention in warehouse/Halting'),
                                      pw.Text('0 ', style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),

                                    ]), pw.TableRow(children: [
                                      pw.Text(
                                          'A 02 - Detention for Direct Billing'),
                                      pw.Text('0 ', style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),

                                    ]), pw.TableRow(children: [
                                      pw.Text('A 03 - Toll Tax'),
                                      pw.Text('0 ', style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),

                                    ]), pw.TableRow(children: [
                                      pw.Text('A 04 - Unloading Charge'),
                                      pw.Text('0 ', style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),

                                    ]), pw.TableRow(children: [
                                      pw.Text(
                                          'A 05 - Multipoint Load/Unloading'),
                                      pw.Text('0 ', style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),

                                    ]), pw.TableRow(children: [
                                      pw.Text('A 06 - Incentive'),
                                      pw.Text('0 ', style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),

                                    ]), pw.TableRow(children: [
                                      pw.Text(
                                          'A 07 - Freight Adjustment Addition'),
                                      pw.Text('0 ', style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),

                                    ]), pw.TableRow(children: [
                                      pw.Text('Addn Total (B)',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight
                                                  .bold)),
                                      pw.Text('0 ', style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),

                                    ]),
                                  ])
                            ]),
                        pw.TableRow(
                            verticalAlignment: pw.TableCellVerticalAlignment
                                .middle,
                            children: [
                              pw.Center(child: pw.Text('Subtraction ( - )',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold))),
                              pw.Table(
                                  border: pw.TableBorder.all(
                                      color: PdfColors.black, width: 1.0),
                                  children: [
                                    pw.TableRow(children: [
                                      pw.Text('S 01 -Late penalty'),
                                      pw.Text(
                                          '0 ', textAlign: pw.TextAlign.right)
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text('S 02 -Damage'),
                                      pw.Text('0 ', style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),

                                    ]), pw.TableRow(children: [
                                      pw.Text(
                                          'S 03 -Freight Adjustment Subtraction'),
                                      pw.Text('0 ',
                                          textAlign: pw.TextAlign.right),

                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text('Subtraction Total (C)',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight
                                                  .bold)),
                                      pw.Text('72300 ',
                                          textAlign: pw.TextAlign.right),

                                    ]),

                                  ])
                            ]),
                        pw.TableRow(
                            children: [
                              pw.Text('Total Bill Amount ( A+B+C )', style: pw
                                  .TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Text('72300 ', style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.right)

                            ])
                      ]
                  ),


                ],

              ),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(
                  width: 400,
                  alignment: pw.Alignment.topLeft,
                  margin: pw.EdgeInsets.only(top: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          "We confirm that we are not taking Tax Credit of Input/CapitalGoods",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold)),
                      pw.Text("Tax for rendering such services",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold)),
                      pw.Text("GST paid under Reverse charge mechanism",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold)),
                    ],
                  ),

                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [

                    pw.Padding(
                      padding: pw.EdgeInsets.only(top: 40),
                      child: pw.Text(
                        'Authorized Signature',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],

                ),

              ],
            )


          ];

          // pw.TableHelper.fromTextArray(
          //   context: context,
          //   headerAlignment: pw.Alignment.centerLeft,
          //   cellAlignment: pw.Alignment.centerLeft,
          //   headerDecoration: pw.BoxDecoration(
          //     color: PdfColors.grey300,
          //   ),
          //   data: <List<String>>[
          //     <String>['Description', 'Value'],
          //     <String>['Date', '2023-09-11'],
          //     <String>['Sender', 'John Doe'],
          //     <String>['Receiver', 'Jane Doe'],
          //     <String>['Item', 'Sample Item'],
          //     <String>['Quantity', '2'],
          //     <String>['Weight (kg)', '5'],
          //     <String>['Distance (km)', '100'],
          //     <String>[
          //       'Total Amount',
          //       '1000'
          //     ], // Assuming service charge is 10
          //   ],
          // ),

        },


      ),
    );
  }

  await Printing.layoutPdf(
    onLayout: (_) async => pdf.save(),
  );
}