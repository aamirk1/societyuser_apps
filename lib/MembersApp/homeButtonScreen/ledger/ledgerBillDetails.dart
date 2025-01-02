// ignore_for_file: file_names
import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_to_character/number_to_character.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
// import 'package:number_to_character/number_to_character.dart';
import 'package:societyuser_app/MembersApp/auth/splash_service.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';

// ignore: must_be_immutable
class LedgerBillDetailsPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  LedgerBillDetailsPage({
    super.key,
    required this.societyName,
    required this.name,
    required this.flatno,
    required this.billDate,
    required this.billNo,
    required this.billAmount,
    required this.dueDate,
    required this.allBillData,
    // required this.interest,
    // this.payableAmount,
    // this.arrears,
    // this.maintenanceCharges,
    // this.mhadaLeaseRent,
    // this.nonOccupancyChg,
    // this.parkingCharges,
    // this.repairFund,
    // this.sinkingFund,
    // this.towerBenefit,
    // this.municipalTax,
    // this.othercharges,
  });

  String societyName;
  String name;
  String flatno;
  String billDate;
  String billNo;
  String billAmount;
  String dueDate;
  Map<String, dynamic> allBillData = {};
  // String interest;
  // String? payableAmount;
  // String? arrears;
  // String? maintenanceCharges;
  // String? mhadaLeaseRent;
  // String? nonOccupancyChg;
  // String? parkingCharges;
  // String? repairFund;
  // String? sinkingFund;
  // String? towerBenefit;
  // String? municipalTax;
  // String? othercharges;

  @override
  State<LedgerBillDetailsPage> createState() => _LedgerBillDetailsPageState();
}

class _LedgerBillDetailsPageState extends State<LedgerBillDetailsPage> {
  final SplashService _splashService = SplashService();

  bool isLoading = true;
  // ignore: non_constant_identifier_names
  String? society_name;
  String? email;
  String? regNo;
  String? landmark;
  String? city;
  String? state;
  String? pincode;

  dynamic totalDues = 0.0;
  List<String> colums = [
    'Sr.No.',
    'Particulars of \n Charges',
    'Amount',
  ];
  // List<dynamic> particulars = [
  //   'Maintenance Charges',
  //   'Municipal Tax',
  //   'Legal Notice Charges',
  //   'Parking Charges',
  //   'Mhada Lease Rent',
  //   'repair Fund',
  //   'Other Charges',
  //   'Sinking Fund',
  //   'Non Occupancy Chg',
  //   'Interest',
  //   'Tower Benefit',
  // ];

  // List<String> valuesbill = [];
  Map<String, dynamic> allBillDetails = {};
  var converter = NumberToCharacterConverter('en');
  String words = '';
  String phoneNum = '';
  void numbertochar(int amount) {
    words = converter.getTextForNumber(amount);
  }

  @override
  initState() {
    getSociety(widget.societyName).whenComplete(() {});

    totalDues = double.parse(widget.billAmount) +
        (widget.allBillData['8_Arrears'].isNotEmpty
            ? double.parse(widget.allBillData['8_Arrears'])
            : 0) +
        (widget.allBillData['7_Interest'].isNotEmpty
            ? double.parse(widget.allBillData['7_Interest'])
            : 0);
    numbertochar(totalDues.toInt());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<ChangeValue>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarBgColor,
        title: const Center(
            child: Text(
          'Bill Details',
          style: TextStyle(color: Colors.white),
        )),
        actions: [
          IconButton(
              onPressed: () {
                createPdf(context,
                    societyName: widget.societyName,
                    regNo: regNo!,
                    billAmount: '',
                    words: words,
                    flatNo: widget.flatno,
                    billDate: widget.billDate,
                    billNo: widget.billNo,
                    dueDate: widget.dueDate,
                    allBillData: widget.allBillData);
                // _generatePDF(context);
              },
              icon: const Icon(Icons.print))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.99,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '$society_name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text("Registration Number: $regNo"),
                        Text(
                            "$society_name $landmark, $city, $state, $pincode"),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "MAINTENANCE BILL",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          color: textColor,
                          thickness: 1,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Text(
                                        "Name: ${widget.name}",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Flat No.: ${widget.flatno}"),
                                    Text(
                                      "Bill No.: ${widget.billNo == '' ? 'N/A' : widget.billNo}",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "Bill Date: ${widget.billDate == '' ? 'N/A' : widget.billDate}",
                                      style: TextStyle(
                                          color: textColor, fontSize: 12),
                                    ),
                                    Text(
                                      "Due Date: ${widget.dueDate == '' ? 'N/A' : widget.dueDate}",
                                      style: TextStyle(
                                          color: textColor, fontSize: 12),
                                    ),
                                  ])
                            ]),
                        Divider(
                          color: textColor,
                          thickness: 1,
                        ),
                        Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.30,
                                width: MediaQuery.of(context).size.width * 0.95,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    dividerThickness: 0,
                                    columnSpacing: 40,
                                    columns: [
                                      DataColumn(
                                          label: Text(
                                        colums[0],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        colums[1],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        colums[2],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ],
                                    rows: widget.allBillData.entries
                                        .toList()
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final index = entry.key;
                                      final value = entry.value;
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text((index + 1)
                                                .toString()), // Display serial number
                                          ),
                                          DataCell(
                                            Text(value.key.replaceFirst(
                                                RegExp(r'^\d+_'), '')),
                                            // Text(value.key
                                            //   .split('${index + 1}_')
                                            //   .join('')),
                                          ),
                                          DataCell(
                                            Text(value.value.toString()),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ]),
                        Divider(
                          color: textColor,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Row(children: [
                            Expanded(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: Text(
                                  textAlign: TextAlign.justify,
                                  "Rupees $words Only",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                            VerticalDivider(
                              thickness: 1,
                              color: textColor,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Total",
                                            style: TextStyle(fontSize: 9),
                                          ),
                                          Text(
                                            "Previous Dues",
                                            style: TextStyle(fontSize: 9),
                                          ),
                                          Text(
                                            "Intrest On Dues",
                                            style: TextStyle(fontSize: 9),
                                          )
                                        ],
                                      ),
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(":",
                                              style: TextStyle(fontSize: 9)),
                                          Text(":",
                                              style: TextStyle(fontSize: 9)),
                                          Text(":",
                                              style: TextStyle(fontSize: 9)),
                                        ],
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(widget.billAmount,
                                                style: const TextStyle(
                                                    fontSize: 9)),
                                            Text(
                                                "${widget.allBillData['8_Arrears']}",
                                                style: const TextStyle(
                                                    fontSize: 9)),
                                            Text(
                                                "${widget.allBillData['7_Interest']}",
                                                style: const TextStyle(
                                                    fontSize: 9)),
                                          ]),
                                      Divider(
                                        color: textColor,
                                        thickness: 1,
                                      ),
                                    ],
                                  ),
                                  Divider(color: textColor, thickness: 1),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Total Dues Amount: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                              child: Text(
                                                totalDues.toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ])
                                ],
                              ),
                            ),
                          ]),
                        ),
                        Divider(
                          color: textColor,
                          thickness: 1,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.99,
                          // height: MediaQuery.of(context).size.height * 0.05,
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'Please pay your dues on or before Due Date. Otherwise Simple interest @21%p.a. will be charged on Arrears. Please Pay by cross cheques or via NEFT only in favouring ',
                                  style:
                                      TextStyle(fontSize: 9, color: textColor),
                                ),
                                TextSpan(
                                  text: '$society_name',
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      ' and mention your flat number. If you have any descrepancy in the bill please contact society office.',
                                  style:
                                      TextStyle(fontSize: 9, color: textColor),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> getSociety(String societyname) async {
    // ignore: unused_local_variable

    phoneNum = await _splashService.getPhoneNum();

    DocumentSnapshot societyQuerySnapshot = await FirebaseFirestore.instance
        .collection('society')
        .doc(societyname)
        .get();
    Map<String, dynamic> societyData =
        societyQuerySnapshot.data() as Map<String, dynamic>;
    society_name = societyData['societyName'];
    email = societyData['email'];
    regNo = societyData['regNo'];
    landmark = societyData['landmark'];
    city = societyData['city'];
    state = societyData['state'];
    pincode = societyData['pincode'];
    setState(() {});
    isLoading = false;
  }

  Future<void> createPdf(
    BuildContext context, {
    required String societyName,
    required String regNo,
    required String billAmount,
    required String words,
    required String flatNo,
    required String billNo,
    required String billDate,
    required String dueDate,
    required Map<String, dynamic> allBillData,
  }) async {
    try {
      // Load fonts
      final fontData1 = await rootBundle.load('fonts/IBMPlexSans-Medium.ttf');
      final fontData2 = await rootBundle.load('fonts/IBMPlexSans-Bold.ttf');

      final pdf = pw.Document(pageMode: PdfPageMode.outlines);
      final List<String> columns = ['Sr. No.', 'Particular', 'Amount'];
      // Add page to PDF
      pdf.addPage(
        pw.MultiPage(
          maxPages: 100,
          theme: pw.ThemeData.withFont(
            base: pw.Font.ttf(fontData1),
            bold: pw.Font.ttf(fontData2),
          ),
          footer: (pw.Context context) {
            return _buildPaymentInstructions(societyName, words);
            //  pw.Container(
            //   alignment: pw.Alignment.centerRight,
            //   margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            //   child: pw.Text('User ID - 45',
            //       style: const pw.TextStyle(color: PdfColors.black)),
            // );
          },
          build: (pw.Context context) => <pw.Widget>[
            pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.SizedBox(
                height: 600,
                child: pw.Column(
                  children: [
                    pw.Text(societyName,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 16)),
                    pw.Text("Registration Number: $regNo"),
                    pw.Text("$society_name $landmark, $city, $state, $pincode"),
                    pw.SizedBox(height: 10),
                    pw.Text("MAINTENANCE BILL",
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Divider(color: PdfColors.black, thickness: 1),
                    _buildBillDetails(flatNo, billNo, billDate, dueDate),
                    pw.Divider(color: PdfColors.black, thickness: 1),
                    _buildSummaryss(widget.allBillData, columns),
                    // pw.Divider(color: PdfColors.black, thickness: 1),
                    // _buildSummary(widget.allBillData),
                    pw.Divider(color: PdfColors.black, thickness: 1),
                    // _buildSummaryss(allBillData, columns),
                    _buildPaymentInstructions(societyName, words),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

      // Generate PDF data
      final List<int> pdfData = await pdf.save();
      if (pdfData.isEmpty) {
        print('PDF data is empty!');
        return;
      }

      // Save PDF to device
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/Bill.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfData);
      print('PDF saved at $filePath');

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
      // Open the PDF
      // final intent = AndroidIntent(
      //   action: 'android.intent.action.VIEW',
      //   data: Uri.file(filePath).toString(),
      //   type: 'application/pdf',
      // );
      // await intent.launch();
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Center(child: Text('Error generating PDF: $e'))),
      );
    }

    // Save PDF to device
    //   final List<int> pdfData = await pdf.save();
    //   const String pdfPath = 'Bill.pdf';

    //   if (Platform.isAndroid) {
    //     final directory = await getApplicationDocumentsDirectory();
    //     final file = File('${directory.path}/$pdfPath');
    //     await file.writeAsBytes(pdfData);

    //     final intent = AndroidIntent(
    //       action: 'android.intent.action.VIEW',
    //       data: file.path,
    //       type: 'application/pdf',
    //     );
    //     await intent.launch();
    //   }
  }

  pw.Widget _buildBillDetails(
      String flatNo, String billNo, String billDate, String dueDate) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: pw.Text("Name: ${widget.name}",
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Flat No.: $flatNo"),
            pw.Text("Bill No.: ${billNo.isEmpty ? 'N/A' : billNo}"),
            pw.Text("Bill Date: ${billDate.isEmpty ? 'N/A' : billDate}"),
            pw.Text("Due Date: ${dueDate.isEmpty ? 'N/A' : dueDate}"),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSummary(Map<String, dynamic> allBillData) {
    return pw.SizedBox(
      height: 10,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("Total Dues Amount: ${totalDues.toString()}",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),

          // Additional summary items can be added here
        ],
      ),
    );
  }

  pw.TableRow buildTableRow(List<String> cells, {bool isHeader = false}) {
    return pw.TableRow(
      children: cells.map((cell) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text(
            cell,
            style: pw.TextStyle(
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: 12,
            ),
            textAlign: pw.TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildSummaryss(
      Map<String, dynamic> allBillData, List<String> columns) {
    print('allBillData print $allBillData');
    print('columns print $columns');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // pw.Center(
        //   child: pw.Text('Summary',
        //       style:
        //           pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        // ),
        // pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.symmetric(
              inside: const pw.BorderSide(
            color: PdfColors.black,
            width: 0.5,
          )),
          children: [
            // Table Header
            buildTableRow(columns, isHeader: true),
            // Table Rows

            ...allBillData.entries.toList().asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value;
              return buildTableRow([
                (index + 1).toString(),
                value.key.replaceFirst(RegExp(r'^\d+_'), ''),
                value.value.toString(),
              ]);
            }).toList(),
          ],
        ),
        pw.Divider(color: PdfColors.black, thickness: 1),

        // pw.Text("Flat No.: $flatNo"),
        // pw.Text("Intrest: ${allBillData['7_Interest'].toString()}",
        //     style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
        pw.Text("Total Dues Amount: ${totalDues.toString()}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  pw.Widget _buildPaymentInstructions(String societyName, String words) {
    return pw.RichText(
      textAlign: pw.TextAlign.justify,
      text: pw.TextSpan(
        children: [
          const pw.TextSpan(
            text:
                'Please pay your dues on or before Due Date. Otherwise, simple interest @21% p.a. will be charged on arrears. Pay by cheque or via NEFT to ',
            style: pw.TextStyle(fontSize: 9, color: PdfColors.black),
          ),
          pw.TextSpan(
            text: societyName,
            style: pw.TextStyle(
                color: PdfColors.black,
                fontSize: 11,
                fontWeight: pw.FontWeight.bold),
          ),
          const pw.TextSpan(
            text:
                ' and mention your flat number. If you have discrepancies in the bill, please contact the society office.',
            style: pw.TextStyle(fontSize: 9, color: PdfColors.black),
          ),
        ],
      ),
    );
  }

  // Future<void> createPdf(BuildContext context) async {
  //   try {
  //     final pdf = pw.Document();

  //     // Add a page to the PDF
  //     pdf.addPage(
  //       pw.Page(
  //         build: (pw.Context context) {
  //           return pw.Center(
  //             child: pw.Text('Hello World', style: pw.TextStyle(fontSize: 40)),
  //           );
  //         },
  //       ),
  //     );

  //     // Save the PDF and initiate download
  //     await Printing.layoutPdf(
  //       onLayout: (PdfPageFormat format) async => pdf.save(),
  //     );
  //   } catch (e) {
  //     // Handle any errors that occur during PDF generation
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error generating PDF: $e')),
  //     );
  //   }
  // }
}
