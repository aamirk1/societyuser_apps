// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:societyuser_app/MembersApp/common_widget/colors.dart';
import 'package:societyuser_app/MembersApp/provider/AllComplaintProvider.dart';

// ignore: camel_case_types, must_be_immutable
class ApplyComplaints extends StatefulWidget {
  ApplyComplaints(
      {super.key, this.flatno, this.societyName, required this.fcmId});
  String? flatno;
  String? societyName;
  String fcmId;
  @override
  State<ApplyComplaints> createState() => _ApplyComplaintsState();

  List<String> items = [
    'House Keeping Complaint',
    'Security Issues',
    'Parking Issue',
    'Admin Issue',
    'Accounts Issue',
    'Vendor Complaints',
    'Water Related',
    'Leackage Related',
    'Pet Animals Related',
    'Others',
  ];
  List<String> application = [
    'House Keeping Complaint By Member',
    'Security Issues By Member',
    'Parking Issue By Member',
    'Admin Issue By Member',
    'Accounts Issue By Member',
    'Vendor Complaints By Member',
    'Water Related By Member',
    'Leackage Related By Member',
    'PetAnimal Related By Member',
    'Others By Member',
  ];
}

// ignore: camel_case_types
class _ApplyComplaintsState extends State<ApplyComplaints> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final TextEditingController _societyNameController = TextEditingController();
  final TextEditingController complaintstypeController =
      TextEditingController();
  final TextEditingController saleController = TextEditingController();
  final TextEditingController gasController = TextEditingController();
  final TextEditingController electricController = TextEditingController();
  final TextEditingController passportController = TextEditingController();
  final TextEditingController renovationController = TextEditingController();
  final TextEditingController giftController = TextEditingController();
  final TextEditingController bankController = TextEditingController();

  String date2 = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    // print('date2 $date2');
  }

  @override
  Widget build(BuildContext context) {
    // saleController.text =
    //     'I would like to apply for complaints to sale my flat ${widget.flatno} to ';
    // gasController.text =
    //     'I would like to apply for complaints to gas pipe my flat no ${widget.flatno}  ';
    // electricController.text =
    //     'I would like to apply for complaints to change  my electric meter my flat no is ${widget.flatno} ';
    // passportController.text =
    //     'I would like to apply for complaints to sale my flat ${widget.flatno}  ';
    // renovationController.text =
    //     'I would like to apply for complaints to renovate my flat ${widget.flatno} to ';
    // giftController.text =
    //     'I would like to apply for complaints to sale my flat ${widget.flatno} to ';
    // bankController.text =
    //     'I would like to apply for complaints to sale my flat ${widget.flatno} to ';
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: appBarBgColor,
        title: const Text(
          'Apply complaints',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Complaint Type',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 10,
                        ),
                      ),
                      items: widget.items
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style:
                                      TextStyle(fontSize: 14, color: textColor),
                                ),
                              ))
                          .toList(),
                      // value: selectedSocietyName,
                      onChanged: (value) async {
                        setState(() {
                          complaintstypeController.text = value.toString();
                          switch (value.toString()) {
                            case 'House Keeping Complaint':
                              _showDialog(
                                  widget.application[0], saleController);
                              break;
                            case 'Security Issues':
                              _showDialog(widget.application[1], gasController);
                              break;
                            case 'Parking Issue':
                              _showDialog(
                                  widget.application[2], electricController);
                              break;
                            case 'Admin Issue':
                              _showDialog(
                                  widget.application[3], passportController);
                              break;
                            case 'Accounts Issue':
                              _showDialog(
                                  widget.application[4], renovationController);
                              break;
                            case 'Vendor Complaints':
                              _showDialog(
                                  widget.application[5], giftController);
                              break;
                            case 'Water Related':
                              _showDialog(
                                  widget.application[6], bankController);
                              break;
                            case 'Leackage Related':
                              _showDialog(
                                  widget.application[7], bankController);
                              break;
                            case 'Pet Animals Related':
                              _showDialog(
                                  widget.application[8], bankController);
                              break;
                            case 'Others':
                              _showDialog(
                                  widget.application[9], bankController);
                              break;
                          }
                        });
                        setState(() {});
                      },
                      buttonStyleData: const ButtonStyleData(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border(
                                right: BorderSide(
                                  color: Colors.grey,
                                ),
                                left: BorderSide(color: Colors.grey),
                                top: BorderSide(color: Colors.grey),
                                bottom: BorderSide(
                                  color: Colors.grey,
                                ))),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 40,
                        width: 200,
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: complaintstypeController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 4,
                            right: 8,
                            left: 8,
                          ),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: complaintstypeController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search Complaints Type',
                              hintStyle: const TextStyle(fontSize: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value.toString().contains(searchValue);
                        },
                      ),
                      //This to clear the search value when you close the menu
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          complaintstypeController.clear();
                        }
                      },
                    ),
                  ),
                  // TypeAheadField(
                  //     textFieldConfiguration: TextFieldConfiguration(
                  //         controller: complaintstypeController,
                  //         decoration: const InputDecoration(
                  //             labelText: 'Select complaints Type',
                  //             border: OutlineInputBorder())),
                  //     suggestionsCallback: (pattern) async {
                  //       // return await getSocietyList();

                  //       return widget.items;
                  //     },
                  //     itemBuilder: (context, suggestion) {
                  //       return ListTile(
                  //         title: Text(
                  //           suggestion.toString(),
                  //           style: TextStyle(color: textColor),
                  //         ),
                  //       );
                  //     },
                  //     onSuggestionSelected: (suggestion) {
                  //       complaintstypeController.text = suggestion.toString();
                  //       switch (suggestion.toString()) {
                  //         case 'House Keeping Complaint':
                  //           _showDialog(widget.application[0], saleController);
                  //           break;
                  //         case 'Security Issues':
                  //           _showDialog(widget.application[1], gasController);
                  //           break;
                  //         case 'Parking Issue':
                  //           _showDialog(
                  //               widget.application[2], electricController);
                  //           break;
                  //         case 'Admin Issue':
                  //           _showDialog(
                  //               widget.application[3], passportController);
                  //           break;
                  //         case 'Accounts Issue':
                  //           _showDialog(
                  //               widget.application[4], renovationController);
                  //           break;
                  //         case 'Vendor Complaints':
                  //           _showDialog(widget.application[5], giftController);
                  //           break;
                  //         case 'Water Related':
                  //           _showDialog(widget.application[6], bankController);
                  //           break;
                  //         case 'Leackage Related':
                  //           _showDialog(widget.application[7], bankController);
                  //           break;
                  //         case 'Pet Animals Related':
                  //           _showDialog(widget.application[8], bankController);
                  //           break;
                  //         case 'Others':
                  //           _showDialog(widget.application[9], bankController);
                  //           break;
                  //       }
                  //     }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(String selectedValue, TextEditingController controller) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: Text(
                        selectedValue.toString(),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: textColor),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: controller,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      maxLines: 6,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green)),
                          onPressed: () async {
                            storeUserData(
                              context,
                              complaintstypeController.text,
                              controller.text,
                            ).whenComplete(() {
                              controller.clear();
                              complaintstypeController.clear();
                              complaintstypeController.text = '';
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> storeUserData(
      BuildContext context, String complaintsType, String text) async {
    final provider = Provider.of<AllComplaintProvider>(context, listen: false);
    try {
      // Create a new document in the "users" collection
      await firestore
          .collection('complaints')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('typeofcomplaints')
          .doc(complaintsType)
          .collection('dateOfComplaint')
          .doc(date2)
          .set({
        'complaintsType': complaintsType,
        'text': text,
        'fcmId': widget.fcmId
      });

      await firestore
          .collection('complaints')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .set({"flatno": widget.flatno});

      await firestore
          .collection('complaints')
          .doc(widget.societyName)
          .collection('flatno')
          .doc(widget.flatno)
          .collection('typeofcomplaints')
          .doc(complaintsType)
          .set({"typeofcomplaints": complaintsType});

      provider.addSingleList({"dateOfComplaint": date2});

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Center(child: Text('Complaint Submitted successfully')),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseException {
      // print('Error storing data: $e');
    }
  }
}
