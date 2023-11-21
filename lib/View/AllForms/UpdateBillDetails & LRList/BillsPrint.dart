import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


Future<void> generateBillAndPrint({
  List<dynamic> BillsLRsData= const [],
  List freightAmount =const [],
  String billNo = '',
  String date = '',
  String ledger = '',

  List haltAmount = const [],
  List loadingUnloadingCharge = const[],
  /// Addition Total
  String detentionInWarehouse = '',
  String directBillingTotal = '',
  String tollTaxTotal = '',
  String loadingUnloadingTotal = '',
  String multiLoadUnloadTotal = '',
  String incentiveTotal = '',
  String freightAdjustmentAdditionTotal = '',

  ///sutraction Total
  String latePenaltyTotal = '',
  String adjustmentSubtractionTotal = '',
  String damageTotal = '',

  /// grand Total
  String totalFreightAmount = '',
  String totalFreightAddition = '',
  String totalFreightSubtraction = '',
  String grandTotalAmount = '',
}) async {
  final pdf = pw.Document();

  // print("tbggb: ${BillsLRsData}");
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(50),
        build: (pw.Context context) {
          return [
            pw.Container(
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black)),
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
                            pw.Text(billNo.toString(),
                                style: pw.TextStyle(
                                  fontSize: 10,
                                )),
                            pw.Text(date.toString(),
                                style: pw.TextStyle(
                                  fontSize: 10,
                                )),
                            pw.Text('GSt Number',
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
                        pw.Text(ledger.toString(),
                            style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                            BillsLRsData[0]['ledger_address'].toString(),
                            style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                  pw.Divider(),
                  pw.Table(
                      columnWidths: {
                        0: pw.FlexColumnWidth(1),
                        1: pw.FlexColumnWidth(1),
                        2: pw.FlexColumnWidth(1.3),
                        3: pw.FlexColumnWidth(1),
                        4: pw.FlexColumnWidth(1),
                        5: pw.FlexColumnWidth(1.2),
                        6: pw.FlexColumnWidth(1),
                        7: pw.FlexColumnWidth(1),
                      },

                      defaultVerticalAlignment:
                      pw.TableCellVerticalAlignment.middle,
                      // defaultColumnWidth: pw.FixedColumnWidth(50.0),

                      border: pw.TableBorder.all(
                          color: PdfColors.black, width: 1.0),
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            height: 30,
                            child: pw.Center(
                              child: pw.Text('GR No',
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.center),
                            ),
                          ),
                          pw.Text('GR Date',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center),
                          pw.Text('   Vehicle No  ',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center),
                          pw.Text(' Vehicle Type ',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center),
                          pw.Text('STN/INV NO & Date',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center),
                          pw.Text('From',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center),
                          pw.Text('To',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center),
                          pw.Text('Amount',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center),
                        ]),


                      ]),

                  pw.ListView.builder(
                    itemCount: BillsLRsData.length,
                    itemBuilder: (context, index) {
                      return pw.Column(
                          children: [
                            pw.Table(
                                columnWidths: {
                                  0: pw.FlexColumnWidth(1),
                                  1: pw.FlexColumnWidth(1),
                                  2: pw.FlexColumnWidth(1.3),
                                  3: pw.FlexColumnWidth(1),
                                  4: pw.FlexColumnWidth(1),
                                  5: pw.FlexColumnWidth(1.2),
                                  6: pw.FlexColumnWidth(1),
                                  7: pw.FlexColumnWidth(1),
                                },

                                border: pw.TableBorder.all(
                                    color: PdfColors.black, width: 1.0),
                                children: [
                                  pw.TableRow(children: [
                                    pw.Container(
                                      height: 20,
                                      child: pw.Center(
                                        child: pw.Text(BillsLRsData[index]['lr_number'].toString(),
                                            style: pw.TextStyle(
                                              fontSize: 10,
                                            )),
                                      ),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(3.0),
                                      child: pw.Text(BillsLRsData[index]['ledger_date'].toString(),
                                          style: pw.TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: pw.TextAlign.center),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(3.0),
                                      child: pw.Text(BillsLRsData[index]['vehicle_number'].toString(),
                                          style: pw.TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: pw.TextAlign.center),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(3.0),
                                      child: pw.Text(BillsLRsData[index]['vehicle_type'].toString(),
                                          style: pw.TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: pw.TextAlign.center),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(3.0),
                                      child: pw.Text(BillsLRsData[index]['lr_invoice_number'].toString(),
                                          style: pw.TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: pw.TextAlign.center),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(3.0),
                                      child: pw.Text(BillsLRsData[index]['from_location'].toString(),
                                          style: pw.TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: pw.TextAlign.center),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(3.0),
                                      child: pw.Text(BillsLRsData[index]['to_location'].toString(),
                                          style: pw.TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: pw.TextAlign.center),
                                    ),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.all(3.0),
                                      child: pw.Text(BillsLRsData[index]['total_freight_amount'].toString(),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                          textAlign: pw.TextAlign.center),
                                    ),
                                  ]),
                                ]),
                            pw.Table(
                                // columnWidths: {
                                //   0: pw.FlexColumnWidth(1),
                                //   1: pw.FlexColumnWidth(1),
                                //   2: pw.FlexColumnWidth(1),
                                // },
                                tableWidth: pw.TableWidth.max,
                                border: pw.TableBorder.all(color: PdfColors.black),
                                children: [
                                  pw.TableRow(children: [
                                    pw.Text('Freight Amount:${freightAmount[index].text}',
                                        style: pw.TextStyle(
                                          fontSize: 11,
                                        ),
                                        textAlign: pw.TextAlign.center),
                                    if(haltAmount[index].text!='0')pw.Text('Halt Amount:${haltAmount[index].text}',
                                        style: pw.TextStyle(
                                          fontSize: 11,
                                        ),
                                        textAlign: pw.TextAlign.center),
                                    if(loadingUnloadingCharge[index].text!='0')pw.Text('Load/Unload:${loadingUnloadingCharge[index].text}',
                                        style: pw.TextStyle(
                                          fontSize: 11,
                                        ),
                                        textAlign: pw.TextAlign.center),
                                    pw.Text('Reported Date : ${BillsLRsData[index]['reported_date'].toString()} ',
                                        style: pw.TextStyle(
                                          fontSize: 11,
                                        ),
                                        textAlign: pw.TextAlign.center),
                                    pw.Text('UnLoaded Date :${BillsLRsData[index]['unloaded_date'].toString()} ',
                                        style: pw.TextStyle(
                                          fontSize: 11,
                                        ),
                                        textAlign: pw.TextAlign.center)
                                  ]),
                                ]),

                          ]
                      );
                    },
                  ) ,


                  pw.SizedBox(height: 30),
                  pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.black),
                      children: [
                        pw.TableRow(
                            verticalAlignment:
                            pw.TableCellVerticalAlignment.middle,
                            children: [
                              pw.Center(
                                  child: pw.Text('Addition Charges (+)',
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold),
                                      textAlign: pw.TextAlign.center)),
                              pw.Table(
                                  border: pw.TableBorder.all(
                                      color: PdfColors.black, width: 1.0),
                                  children: [
                                    pw.TableRow(children: [
                                      pw.Text(' Freight Total (A)',
                                          style: pw.TextStyle(
                                              fontWeight:
                                              pw.FontWeight.bold)),
                                      pw.Text('$totalFreightAmount ',
                                          textAlign: pw.TextAlign.right)
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text(
                                          ' A 01 - Detention in warehouse/Halting'),
                                      pw.Text('$detentionInWarehouse ',
                                          style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text(
                                          ' A 02 - Detention for Direct Billing'),
                                      pw.Text('$directBillingTotal ',
                                          style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text(' A 03 - Toll Tax'),
                                      pw.Text('$tollTaxTotal ',
                                          style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text(' A 04 - Unload/unload Charge'),
                                      pw.Text('$loadingUnloadingTotal ',
                                          style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text(
                                          ' A 05 - Multipoint Load/Unloading'),
                                      pw.Text('$multiLoadUnloadTotal ',
                                          style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text(' A 06 - Incentive'),
                                      pw.Text('$incentiveTotal ',
                                          style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text(
                                          ' A 07 - Freight Adjustment Addition'),
                                      pw.Text('$freightAdjustmentAdditionTotal ',
                                          style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text(' Addn Total (B)',
                                          style: pw.TextStyle(
                                              fontWeight:
                                              pw.FontWeight.bold)),
                                      pw.Text('$totalFreightAddition ',
                                          style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),
                                    ]),
                                  ])
                            ]),
                        pw.TableRow(
                            verticalAlignment:
                            pw.TableCellVerticalAlignment.middle,
                            children: [
                              pw.Center(
                                  child: pw.Text(' Subtraction ( - )',
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold))),
                              pw.Table(
                                  border: pw.TableBorder.all(
                                      color: PdfColors.black, width: 1.0),
                                  children: [
                                    pw.TableRow(children: [
                                      pw.Text(' S 01 -Late penalty'),
                                      pw.Text('$latePenaltyTotal ',
                                          textAlign: pw.TextAlign.right)
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text(' S 02 -Damage'),
                                      pw.Text('$damageTotal ',
                                          style: pw.TextStyle(),
                                          textAlign: pw.TextAlign.right),
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text(
                                          ' S 03 -Freight Adjustment Subtraction'),
                                      pw.Text('$adjustmentSubtractionTotal ',
                                          textAlign: pw.TextAlign.right),
                                    ]),
                                    pw.TableRow(children: [
                                      pw.Text(' Subtraction Total (C)',
                                          style: pw.TextStyle(
                                              fontWeight:
                                              pw.FontWeight.bold)),
                                      pw.Text('$totalFreightSubtraction ',
                                          textAlign: pw.TextAlign.right),
                                    ]),
                                  ])
                            ]),
                        pw.TableRow(children: [
                          pw.Text(' Total Bill Amount ( A+B+C )',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text('$grandTotalAmount ',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.right)
                        ])
                      ]),
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
                          style:
                          pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Tax for rendering such services",
                          style:
                          pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("GST paid under Reverse charge mechanism",
                          style:
                          pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.only(top: 50),
                      child: pw.Text(
                        'Authorized Signature',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 50),
            pw.Container(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start
                  ,
                  children: [
                    pw.Text("I/We hereby declare that though our aggregate turnover in any preceding financial year from 2017-18 onwards is ",style: pw.TextStyle(fontSize: 9)),
                    pw.Text("more than the aggregate turnover notified under sub-rule (4) of rule 48, we are not required to prepare an invoice in ",style: pw.TextStyle(fontSize: 9)),
                    pw.Text("terms of the provisions of the said sub-rul",style: pw.TextStyle(fontSize: 9)),
                  ]),
            )
          ];


        },
      ),
    );


  await Printing.layoutPdf(
    onLayout: (_) async => pdf.save(),
  );

  // calculateTotal(){
  //   double sum = 0.0;
  //   for(int i=0; i<freightAdjustmentSubtractionController.length; i++){
  //     sum += double.parse(freightAdjustmentSubtractionController[i].text.isEmpty ? '0.0' : freightAdjustmentSubtractionController[i].text);
  //   }
  //   setState(() {
  //     freightAdjustmentSubtractionSum = sum.toString();
  //     calculateGrandTotalAmount();
  //   });
  // }
}