import 'dart:io';
import 'package:chokchey_finance/components/groupFormBuilder.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/components/imagePicker.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class LoanRegister extends StatefulWidget {
  @override
  _LoanRegister createState() => _LoanRegister();
}

class _LoanRegister extends State {
  //IMAGE PICKER
  PermissionStatus _status;
  final ImagePicker _picker = ImagePicker();
  File _image;
  var _pickImageError;

  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    Map<Permission, PermissionStatus> statuses = await [
      // Permission.location,
      Permission.storage,
      Permission.camera,
    ].request();

    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    if (await Permission.camera.request().isDenied ||
        await Permission.camera.request().isPermanentlyDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        // Permission.location,
        Permission.storage,
        Permission.camera,
      ].request();
    }
    if (await Permission.camera.request().isGranted) {
      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 300,
          enableCamera: true,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#abcdef",
            actionBarTitle: "Add Image",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#FFFFFF",
          ),
        );
      } on Exception catch (e) {
        error = e.toString();
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;
      print('images: ${images} ');
      setState(() {
        images = resultList;
        _error = error;
      });
    }
  }

//   requestPromission() async {
//     if (await Permission.camera.request().isGranted) {
//       // Either the permission was already granted before or the user just granted it.
//       try {
//         final pickedFile = await _picker.getImage(source: ImageSource.camera);
//         setState(() {
//           _image = File(pickedFile.path);
//         });
//       } catch (e) {
//         setState(() {
//           _pickImageError = e;
//         });
//       }
//       print('isGranted *****');
//     }

// // You can request multiple permissions at once.
//     Map<Permission, PermissionStatus> statuses = await [
//       // Permission.location,
//       Permission.storage,
//       Permission.camera,
//     ].request();
//   }

  //TEXT INPUT
  var valueAmount;
  var valueNumberofTerm;
  var valueInterest;
  var valueMaintenanceFee;
  var valueAdminFee;
  var valueRepaymentMethod;
  var valueOpenDate;
  var valueMaturityDate;
  var valueFirstRepaymentDate;
  var valueGenerateGracePeriodNumber;
  var valueLoanPurpose;
  var valueORARD;
  var valueReferByWho;

  final GlobalKey<FormBuilderState> maintenanceFee =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> interestRate =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> numberOfTerm =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> loanAmount = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> adminFee = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> repaymentMethod =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> openData = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> datehMaturityDate =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> firstRepaymentDate =
      GlobalKey<FormBuilderState>();

  final GlobalKey<FormBuilderState> generateGracePeriodNumber =
      GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> loanPurpose = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> oRARD = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> referByWho = GlobalKey<FormBuilderState>();

  onSubmit() {
    print({
      valueAmount,
      valueNumberofTerm,
      valueInterest,
      valueAdminFee,
      valueMaintenanceFee,
      valueRepaymentMethod,
      valueOpenDate,
      valueMaturityDate,
      valueFirstRepaymentDate,
      valueGenerateGracePeriodNumber,
      valueLoanPurpose,
      valueORARD,
      valueReferByWho
    });
  }

  final numberOfTermFocus = FocusNode();
  final interestRateFocus = FocusNode();
  final maintenanceFeeFocus = FocusNode();
  final adminFeeFocus = FocusNode();
  var generateGracePeriodNumberFocus = FocusNode();
  var loanPurposeFocus = FocusNode();
  var referByWhoFocus = FocusNode();
  var openDataFocus = FocusNode();
  var datehMaturityDateFocus = FocusNode();
  var firstRepaymentDateFocus = FocusNode();

  final ValueChanged _onChanged = (val) => print(val);
  @override
  Widget build(BuildContext context) {
    var percentage =
        'https://uxwing.com/wp-content/themes/uxwing/download/03-text-editing/percentage.png';
    return Header(
        headerTexts: 'Loans Register',
        bodys: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: <Widget>[
                GroupFromBuilder(
                  icons: Icons.attach_money,
                  keys: loanAmount,
                  childs: FormBuilderTextField(
                    attribute: 'number',
                    autofocus: true,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Loan amount',
                      border: InputBorder.none,
                    ),
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(numberOfTermFocus);
                    },
                    onChanged: (v) {
                      setState(() {
                        valueAmount = v;
                      });
                    },
                    valueTransformer: (text) {
                      return text == null ? null : text;
                    },
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(errorText: 'Number only')
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                GroupFromBuilder(
                  icons: Icons.branding_watermark,
                  keys: numberOfTerm,
                  childs: FormBuilderTextField(
                    attribute: 'number',
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(interestRateFocus);
                    },
                    focusNode: numberOfTermFocus,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Number of term',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) {
                      setState(() {
                        valueNumberofTerm = v;
                      });
                    },
                    valueTransformer: (text) {
                      return text == null ? null : text;
                    },
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                GroupFromBuilder(
                  keys: interestRate,
                  imageIcon: percentage,
                  childs: FormBuilderTextField(
                    attribute: 'number',
                    focusNode: interestRateFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(maintenanceFeeFocus);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Interest rate',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) {
                      setState(() {
                        valueInterest = v;
                      });
                    },
                    valueTransformer: (text) {
                      return text == null ? null : text;
                    },
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                GroupFromBuilder(
                  icons: Icons.attach_money,
                  keys: maintenanceFee,
                  childs: FormBuilderTextField(
                    attribute: 'number',
                    focusNode: maintenanceFeeFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(adminFeeFocus);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Maintenance fee',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) {
                      setState(() {
                        valueMaintenanceFee = v;
                      });
                    },
                    valueTransformer: (text) {
                      return text == null ? null : text;
                    },
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                GroupFromBuilder(
                  icons: Icons.attach_money,
                  keys: adminFee,
                  childs: FormBuilderTextField(
                    attribute: 'number',
                    focusNode: adminFeeFocus,
                    textInputAction: TextInputAction.next,
                    // onFieldSubmitted: (v) {
                    //   FocusScope.of(context).requestFocus(repaymentMethodFocus);
                    // },
                    decoration: const InputDecoration(
                      labelText: 'Admin fee',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) {
                      setState(() {
                        valueAdminFee = v;
                        valueRepaymentMethod = v;
                      });
                    },
                    valueTransformer: (text) {
                      return text == null ? null : text;
                    },
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                GroupFromBuilder(
                  icons: Icons.check,
                  keys: repaymentMethod,
                  childs: FormBuilderDropdown(
                    attribute: 'name',
                    decoration: InputDecoration(
                      labelText: "Repayment method",
                      border: InputBorder.none,
                    ),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                    hint: Text(
                      'Repayment method',
                    ),
                    // onChanged: (value) {
                    //   setState(() {
                    //     FocusScope.of(context).requestFocus(FocusNode());
                    //     valueRepaymentMethod = value;
                    //   });
                    // },
                    onChanged: (value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() => valueRepaymentMethod = value);
                    },
                    items: [
                      'Declining',
                      'Annuity',
                      'Semi-balloon',
                      'Balloon',
                      'Negotiate',
                    ]
                        .map((valueGurantorCustomer) => DropdownMenuItem(
                            value: valueGurantorCustomer,
                            child: Text(
                              "$valueGurantorCustomer",
                            )))
                        .toList(),
                  ),
                ),
                GroupFromBuilder(
                  icons: Icons.date_range,
                  keys: openData,
                  childs: FormBuilderDateTimePicker(
                    attribute: 'date',
                    focusNode: openDataFocus,
                    textInputAction: TextInputAction.next,
                    inputType: InputType.date,
                    onChanged: (v) {
                      valueOpenDate = v ?? DateTime.now();
                    },
                    validators: [FormBuilderValidators.required()],
                    format: DateFormat("yyyy-MM-dd"),
                    decoration: InputDecoration(
                      labelText: "Open date",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GroupFromBuilder(
                  icons: Icons.date_range,
                  keys: datehMaturityDate,
                  childs: FormBuilderDateTimePicker(
                    attribute: 'date',
                    focusNode: datehMaturityDateFocus,
                    textInputAction: TextInputAction.next,
                    inputType: InputType.date,
                    onChanged: (v) {
                      valueMaturityDate = v ?? DateTime.now();
                    },
                    validators: [FormBuilderValidators.required()],
                    format: DateFormat("yyyy-MM-dd"),
                    decoration: InputDecoration(
                      labelText: "Maturity date",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GroupFromBuilder(
                  icons: Icons.date_range,
                  keys: firstRepaymentDate,
                  childs: FormBuilderDateTimePicker(
                    attribute: 'date',
                    focusNode: firstRepaymentDateFocus,
                    textInputAction: TextInputAction.next,
                    inputType: InputType.date,
                    onChanged: (v) {
                      valueFirstRepaymentDate = v ?? DateTime.now();
                      FocusScope.of(context)
                          .requestFocus(generateGracePeriodNumberFocus);
                    },
                    validators: [FormBuilderValidators.required()],
                    format: DateFormat("yyyy-MM-dd"),
                    decoration: InputDecoration(
                      labelText: "First repayment date",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GroupFromBuilder(
                  icons: Icons.confirmation_number,
                  keys: generateGracePeriodNumber,
                  childs: FormBuilderTextField(
                    attribute: 'number',
                    focusNode: generateGracePeriodNumberFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(loanPurposeFocus);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Generate grace period number',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) {
                      valueGenerateGracePeriodNumber = v;
                    },
                    valueTransformer: (text) {
                      return text == null ? null : text;
                    },
                    keyboardType: TextInputType.number,
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                GroupFromBuilder(
                  icons: Icons.attach_money,
                  keys: loanPurpose,
                  childs: FormBuilderTextField(
                    attribute: 'name',
                    focusNode: loanPurposeFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(referByWhoFocus);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Loan purpose',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) {
                      valueLoanPurpose = v;
                    },
                    valueTransformer: (text) {
                      return text == null ? null : text;
                    },
                    keyboardType: TextInputType.text,
                  ),
                ),
                GroupFromBuilder(
                  icons: Icons.face,
                  keys: referByWho,
                  childs: FormBuilderTextField(
                    attribute: 'name',
                    focusNode: referByWhoFocus,
                    textInputAction: TextInputAction.next,
                    // onFieldSubmitted: (v) {
                    //   FocusScope.of(context).requestFocus(repaymentMethodFocus);
                    // },
                    decoration: const InputDecoration(
                      labelText: 'Refer by who',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) {
                      valueReferByWho = v;
                    },
                    valueTransformer: (text) {
                      return text == null ? null : text;
                    },
                  ),
                ),
                GroupFromBuilder(
                  icons: Icons.check,
                  keys: oRARD,
                  childs: FormBuilderDropdown(
                    attribute: 'name',
                    decoration: InputDecoration(
                      labelText:
                          "O=Open,R=Request, A=Approved,R=Return,D=Disapprove",
                      border: InputBorder.none,
                    ),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                    hint: Text(
                      'O,R,A,R,D',
                    ),
                    onChanged: (value) {
                      setState(() {
                        valueORARD = value;
                      });
                    },
                    items: [
                      'Open',
                      'Request',
                      'Approved',
                      'Return',
                      'Disapprove',
                    ]
                        .map((valueORARD) => DropdownMenuItem(
                            value: valueORARD,
                            child: Text(
                              "$valueORARD",
                            )))
                        .toList(),
                  ),
                ),
                if (images.length != 0)
                  Container(
                    width: 375,
                    height: images.length >= 4 ? 300 : 135,
                    padding: EdgeInsets.only(top: 10),
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: List.generate(images.length, (index) {
                        Asset asset = images[index];
                        return Stack(children: <Widget>[
                          AssetThumb(
                            asset: asset,
                            width: 300,
                            height: images.length >= 6 ? 500 : 200,
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    images.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ))
                        ]);
                      }),
                    ),
                  ),
                ImagePickers(
                  onPressed: () => loadAssets(),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 300,
                    height: 90,
                    padding: EdgeInsets.only(top: 40, left: 10, bottom: 10),
                    child: new RaisedButton(
                      onPressed: () {
                        onSubmit();
                      },
                      color: logolightGreen,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: logolightGreen, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
