import 'dart:convert';
import 'dart:io';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/screens/loanRegistration/widgetCardAddReferent.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class AddReferentDocument extends StatefulWidget {
  AddReferentDocument(this.listLoan, this.editLoan);
  dynamic listLoan;
  String editLoan;

  @override
  _GridHeaderState createState() =>
      _GridHeaderState(this.listLoan, this.editLoan);
}

class _GridHeaderState extends State<AddReferentDocument> {
  _GridHeaderState(this.listLoan, this.editLoan);
  dynamic listLoan;
  String editLoan = '';

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  var loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  var response;
  var validateImage;

  Future onSubmite() async {
    var url = baseURLInternal + 'loanDocuments';
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);

    final storage = new FlutterSecureStorage();

    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: 'user_ucode');
    var branch = await storage.read(key: 'branch');

    Map<String, String> headers = {
      "Content-Type": "multipart/form-data",
      "Authorization": "Bearer " + token
    }; // ignore this headers if there is no authentication

    // multipart that takes file
    if (_imageNation != null &&
        _imageNation.path != null &&
        _imageNation.path.isNotEmpty) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_imageNation.openRead()));
      var length = await _imageNation.length();
      request.files.add(new http.MultipartFile('kyc[101]', stream, length,
          filename: basename(_imageNation.path)));
    }

    // FamilyBook
    if (_imageFamily != null &&
        _imageFamily.path != null &&
        _imageFamily.path.isNotEmpty) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_imageFamily.openRead()));
      var length = await _imageFamily.length();
      request.files.add(new http.MultipartFile('kyc[102]', stream, length,
          filename: basename(_imageFamily.path)));
    }

    // Resident
    if (_imageResident != null &&
        _imageResident.path != null &&
        _imageResident.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageResident.openRead()));
      var length = await _imageResident.length();
      request.files.add(new http.MultipartFile('kyc[103]', stream, length,
          filename: basename(_imageResident.path)));
    }

    // Kyc Other
    if (_imageOther != null &&
        _imageOther.path != null &&
        _imageOther.path.isNotEmpty) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_imageOther.openRead()));
      var length = await _imageOther.length();
      request.files.add(new http.MultipartFile('kyc[104]', stream, length,
          filename: basename(_imageOther.path)));
    }

    // Employee Salary Slip
    if (_imageSalarySlip != null &&
        _imageSalarySlip.path != null &&
        _imageSalarySlip.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageSalarySlip.openRead()));
      var length = await _imageSalarySlip.length();
      request.files.add(new http.MultipartFile('employee[211]', stream, length,
          filename: basename(_imageSalarySlip.path)));
    }

    // Employee Bank Statement
    if (_imageBankStatement != null &&
        _imageBankStatement.path != null &&
        _imageBankStatement.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageBankStatement.openRead()));
      var length = await _imageBankStatement.length();
      request.files.add(new http.MultipartFile('employee[212]', stream, length,
          filename: basename(_imageBankStatement.path)));
    }

    // Employee SalaryVerify
    if (_imageSalaryVerify != null &&
        _imageSalaryVerify.path != null &&
        _imageSalaryVerify.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageSalaryVerify.openRead()));
      var length = await _imageSalaryVerify.length();
      request.files.add(new http.MultipartFile('employee[213]', stream, length,
          filename: basename(_imageSalaryVerify.path)));
    }

    // Employee Employee Contrat
    if (_imageEmployeeContrat != null &&
        _imageEmployeeContrat.path != null &&
        _imageEmployeeContrat.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageEmployeeContrat.openRead()));
      var length = await _imageEmployeeContrat.length();
      request.files.add(new http.MultipartFile('employee[214]', stream, length,
          filename: basename(_imageEmployeeContrat.path)));
    }

    // Employee Employee ID
    if (_imageEmployeeID != null &&
        _imageEmployeeID.path != null &&
        _imageEmployeeID.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageEmployeeID.openRead()));
      var length = await _imageEmployeeID.length();
      request.files.add(new http.MultipartFile('employee[215]', stream, length,
          filename: basename(_imageEmployeeID.path)));
    }
    // Employee Employee ID
    if (_imageEmployeeOther != null &&
        _imageEmployeeOther.path != null &&
        _imageEmployeeOther.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageEmployeeOther.openRead()));
      var length = await _imageEmployeeOther.length();
      request.files.add(new http.MultipartFile('employee[216]', stream, length,
          filename: basename(_imageEmployeeOther.path)));
    }

    // Business Photo of Service
    if (_imagePhotoOfService != null &&
        _imagePhotoOfService.path != null &&
        _imagePhotoOfService.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imagePhotoOfService.openRead()));
      var length = await _imagePhotoOfService.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[221]', stream, length,
          filename: basename(_imagePhotoOfService.path)));
    }

    // Business
    if (_imageBusinessPermit != null &&
        _imageBusinessPermit.path != null &&
        _imageBusinessPermit.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageBusinessPermit.openRead()));
      var length = await _imageBusinessPermit.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[222]', stream, length,
          filename: basename(_imageBusinessPermit.path)));
    }

    // Business
    if (_imageIncomeStatementBank != null &&
        _imageIncomeStatementBank.path != null &&
        _imageIncomeStatementBank.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageIncomeStatementBank.openRead()));
      var length = await _imageIncomeStatementBank.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[224]', stream, length,
          filename: basename(_imageIncomeStatementBank.path)));
    }

    // Business
    if (_imagePatent != null &&
        _imagePatent.path != null &&
        _imagePatent.path.isNotEmpty) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_imagePatent.openRead()));
      var length = await _imagePatent.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[225]', stream, length,
          filename: basename(_imagePatent.path)));
    }

    // Business
    if (_imageRentalContract != null &&
        _imageRentalContract.path != null &&
        _imageRentalContract.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageRentalContract.openRead()));
      var length = await _imageRentalContract.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[226]', stream, length,
          filename: basename(_imageRentalContract.path)));
    }

    // _imageBusinessLocationtitleDedd
    if (_imageBusinessLocationtitleDedd != null &&
        _imageBusinessLocationtitleDedd.path != null &&
        _imageBusinessLocationtitleDedd.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageBusinessLocationtitleDedd.openRead()));
      var length = await _imageBusinessLocationtitleDedd.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[223]', stream, length,
          filename: basename(_imageBusinessLocationtitleDedd.path)));
    }
    // Business
    if (_imageSaleAndPurchase != null &&
        _imageSaleAndPurchase.path != null &&
        _imageSaleAndPurchase.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageSaleAndPurchase.openRead()));
      var length = await _imageSaleAndPurchase.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[227]', stream, length,
          filename: basename(_imageSaleAndPurchase.path)));
    }
    // Business
    if (_imageBusinessOther != null &&
        _imageBusinessOther.path != null &&
        _imageBusinessOther.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageBusinessOther.openRead()));
      var length = await _imageBusinessOther.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[228]', stream, length,
          filename: basename(_imageBusinessOther.path)));
    }

    // Collateral
    if (_imageCollateralCertificate != null &&
        _imageCollateralCertificate.path != null &&
        _imageCollateralCertificate.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageCollateralCertificate.openRead()));
      var length = await _imageCollateralCertificate.length();
      request.files.add(new http.MultipartFile(
          'collateral[301]', stream, length,
          filename: basename(_imageCollateralCertificate.path)));
    }

    // Collateral
    if (_imageCollateralPicture != null &&
        _imageCollateralPicture.path != null &&
        _imageCollateralPicture.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageCollateralPicture.openRead()));
      var length = await _imageCollateralPicture.length();
      request.files.add(new http.MultipartFile(
          'collateral[302]', stream, length,
          filename: basename(_imageCollateralPicture.path)));
    }

    // add headers
    request.headers.addAll(headers);

    // adding params
    var loanCode = listLoan != null ? listLoan['lcode'] : editLoan;
    request.fields['lcode'] = loanCode;
    request.fields['bcode'] = branch;
    request.fields['ucode'] = user_ucode;

    try {
      // send
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      var json = jsonDecode(respStr);

      // logger.i('json::: ${json}');
      setState(() {
        validateImage = json[0];
      });

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        // logger.i('message::::: ${value}');
      });
    } catch (e) {
      logger.i('e::::: ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      headerTexts: "Add Referent Document",
      actionsNotification: <Widget>[
        // Using Stack to show edit registration
        new Stack(
          children: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.save,
                  size: 25,
                ),
                onPressed: () {
                  onSubmite();
                }),
          ],
        ),
      ],
      bodys: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: logolightGreen, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                gridKYC(),
                gridEmployee(),
                gridBS(),
                gridCollateralDocument()
              ],
            ),
          ),
        ),
      ),
    );
  }

//
  File _imageNation;
  File _imageFamily;
  File _imageResident;
  File _imageOther;

  //
  File _imageSalarySlip;
  File _imageBankStatement;
  File _imageSalaryVerify;
  File _imageEmployeeContrat;
  File _imageEmployeeID;
  File _imageEmployeeOther;
  //

  File _imagePhotoOfService;
  File _imageBusinessPermit;
  File _imageBusinessLocationtitleDedd;
  File _imageIncomeStatementBank;
  File _imagePatent;
  File _imageRentalContract;
  File _imageSaleAndPurchase;
  File _imageBusinessOther;
  //

  File _imageCollateralCertificate;
  File _imageCollateralPicture;
  //

  // getImage
  Future getImage() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('PickedFile: ${pickedFile.toString()}');
      setState(() {
        _imageNation = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

//getFamily
  Future getFamily() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('PickedFile: ${pickedFile.toString()}');
      setState(() {
        _imageFamily = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

// getResident
  Future getResident() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageResident = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

// getOther
  Future getOther() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageOther = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

// getSalarySlip
  Future getSalarySlip() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageSalarySlip = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

  // getBankStatement
  Future getBankStatement() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageBankStatement = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

  // getSalaryVerify
  Future getSalaryVerify() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageSalaryVerify = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

  // getEmployeeContrat
  Future getEmployeeContrat() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageEmployeeContrat =
            File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

// getEmployeeID
  Future getEmployeeID() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageEmployeeID = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

  // getEmployeeContrat
  Future getEmployeeOther() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageEmployeeOther = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

// getBusinessOther
  Future getBusinessLocationTitle() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageBusinessLocationtitleDedd =
            File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

// getBusinessOther
  Future getBusinessOther() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageBusinessOther = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

  // getBusinessRentalContract
  Future getBusinessRentalContract() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageRentalContract = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

  // getBusinessSaleAndPurchase
  Future getBusinessSaleAndPurchase() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageSaleAndPurchase =
            File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

  // getBusinessPatent
  Future getBusinessPatent() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePatent = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

  // getBusinessPermit
  Future getBusinessPermit() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageBusinessPermit = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

  // getIncomeStatementAndBank
  Future getIncomeStatementAndBank() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageIncomeStatementBank =
            File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

// getPhotoOfService
  Future getPhotoOfService() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePhotoOfService = File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

  // getCollateralCertificate
  Future getCollateralCertificate() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageCollateralCertificate =
            File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

  // getCollateralPicture
  Future getCollateralPicture() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageCollateralPicture =
            File(pickedFile.path); // Exception occurred here
      });
    } else {
      print('PickedFile: is null');
    }
    return null;
  }

  Widget gridKYC() {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              '1.KYC',
              style: mainTitleBlack,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                WidgetCardAddRef(
                    validateImage:
                        validateImage != null && validateImage['key'] == '101'
                            ? Colors.red
                            : null,
                    text: 'Native ID',
                    onTaps: () {
                      getImage();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageNation = null;
                      });
                    },
                    image: _imageNation),
                WidgetCardAddRef(
                    validateImage:
                        validateImage != null && validateImage['key'] == '102'
                            ? Colors.red
                            : null,
                    text: 'Family book',
                    onTaps: () {
                      getFamily();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageFamily = null;
                      });
                    },
                    image: _imageFamily),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                WidgetCardAddRef(
                    text: 'Resident Book',
                    validateImage:
                        validateImage != null && validateImage['key'] == '103'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getResident();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageResident = null;
                      });
                    },
                    image: _imageResident),
                WidgetCardAddRef(
                    text: 'Other',
                    validateImage:
                        validateImage != null && validateImage['key'] == '104'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getOther();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageOther = null;
                      });
                    },
                    image: _imageOther),
              ],
            ),
          ],
        ));
  }

  Widget gridEmployee() {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              '2.Employee',
              style: mainTitleBlack,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                WidgetCardAddRef(
                    text: 'Salary Slip last 3 months',
                    validateImage:
                        validateImage != null && validateImage['key'] == '211'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getSalarySlip();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageSalarySlip = null;
                      });
                    },
                    image: _imageSalarySlip),
                WidgetCardAddRef(
                    text: 'Bank statement last 3 months',
                    validateImage:
                        validateImage != null && validateImage['key'] == '212'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBankStatement();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageBankStatement = null;
                      });
                    },
                    image: _imageBankStatement),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                WidgetCardAddRef(
                    text: 'Salary verify letter',
                    validateImage:
                        validateImage != null && validateImage['key'] == '213'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getSalaryVerify();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageSalaryVerify = null;
                      });
                    },
                    image: _imageSalaryVerify),
                WidgetCardAddRef(
                    text: 'Employee ID (validity)',
                    validateImage:
                        validateImage != null && validateImage['key'] == '215'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getEmployeeID();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageEmployeeID = null;
                      });
                    },
                    image: _imageEmployeeID),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                WidgetCardAddRef(
                    text: 'Employee contrat (validity)',
                    validateImage:
                        validateImage != null && validateImage['key'] == '214'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getEmployeeContrat();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageEmployeeContrat = null;
                      });
                    },
                    image: _imageEmployeeContrat),
                WidgetCardAddRef(
                    text: 'Other',
                    validateImage:
                        validateImage != null && validateImage['key'] == '216'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getEmployeeOther();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageEmployeeOther = null;
                      });
                    },
                    image: _imageEmployeeOther),
              ],
            ),
          ],
        ));
  }

  Widget gridBS() {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              '3.Business',
              style: mainTitleBlack,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                WidgetCardAddRef(
                    text: 'Photo of service location',
                    validateImage:
                        validateImage != null && validateImage['key'] == '221'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getPhotoOfService();
                    },
                    onClearImage: () {
                      setState(() {
                        _imagePhotoOfService = null;
                      });
                    },
                    image: _imagePhotoOfService),
                WidgetCardAddRef(
                    text: 'Business permit(validity)',
                    validateImage:
                        validateImage != null && validateImage['key'] == '222'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBusinessPermit();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageBusinessPermit = null;
                      });
                    },
                    image: _imageBusinessPermit),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                WidgetCardAddRef(
                    text: 'Income statement/Bank statement last 3 months',
                    validateImage:
                        validateImage != null && validateImage['key'] == '224'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getIncomeStatementAndBank();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageIncomeStatementBank = null;
                      });
                    },
                    image: _imageIncomeStatementBank),
                WidgetCardAddRef(
                    text: 'Patent (validity)',
                    validateImage:
                        validateImage != null && validateImage['key'] == '225'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBusinessPatent();
                    },
                    onClearImage: () {
                      setState(() {
                        _imagePatent = null;
                      });
                    },
                    image: _imagePatent),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                WidgetCardAddRef(
                    text: 'Sale-purchase receipt/ service receipt',
                    validateImage:
                        validateImage != null && validateImage['key'] == '227'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBusinessSaleAndPurchase();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageSaleAndPurchase = null;
                      });
                    },
                    image: _imageSaleAndPurchase),
                WidgetCardAddRef(
                    text: 'Rental contract (validity)',
                    validateImage:
                        validateImage != null && validateImage['key'] == '226'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBusinessRentalContract();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageRentalContract = null;
                      });
                    },
                    image: _imageRentalContract),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                WidgetCardAddRef(
                    text: 'Business Location Title Deed',
                    validateImage:
                        validateImage != null && validateImage['key'] == '223'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBusinessLocationTitle();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageRentalContract = null;
                      });
                    },
                    image: _imageRentalContract),
                WidgetCardAddRef(
                    text: 'Other',
                    validateImage:
                        validateImage != null && validateImage['key'] == '228'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBusinessOther();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageBusinessOther = null;
                      });
                    },
                    image: _imageBusinessOther),
              ],
            ),
          ],
        ));
  }

  Widget gridCollateralDocument() {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              '4.Supporting Collateral',
              style: mainTitleBlack,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                WidgetCardAddRef(
                    text: 'Collateral certificate',
                    validateImage:
                        validateImage != null && validateImage['key'] == '301'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getCollateralCertificate();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageCollateralCertificate = null;
                      });
                    },
                    image: _imageCollateralCertificate),
                WidgetCardAddRef(
                    text: 'Collateral picture',
                    validateImage:
                        validateImage != null && validateImage['key'] == '302'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getCollateralPicture();
                    },
                    onClearImage: () {
                      setState(() {
                        _imageCollateralPicture = null;
                      });
                    },
                    image: _imageCollateralPicture),
              ],
            ),
          ],
        ));
  }
}
