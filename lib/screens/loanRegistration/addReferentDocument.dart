import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chokchey_finance/localizations/appLocalizations.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/components/header.dart';
import 'package:chokchey_finance/screens/home/Home.dart';
import 'package:chokchey_finance/screens/loanRegistration/widgetCardAddReferent.dart';
import 'package:chokchey_finance/utils/storages/colors.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:io' as Io;
import 'package:path_provider/path_provider.dart';

class AddReferentDocument extends StatefulWidget {
  AddReferentDocument(this.listLoan, this.editLoan);
  dynamic? listLoan;
  String? editLoan;

  @override
  _GridHeaderState createState() => _GridHeaderState();
}

class _GridHeaderState extends State<AddReferentDocument> {
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getImageDocument();
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

  //KYC
  var imageDocumentedNation;
  var nationID;

  var imageDocumentedFamily;
  var familyID;

  var imageDocumentedResidentBook;
  var residentID;

  var imageDocumentedKYCOther;
  var kYCOtherID;

  //employee
  var imageDocumentedEmployeeSalaySlip;
  var employeeSalaySlipID;

  var imageDocumentedEmployeeBankStatement;
  var employeeBankStatementID;

  var imageDocumentedEmployeeSalaryVerify;
  var employeeSalaryVerifyID;

  var imageDocumentedEmployeeEmployeeID;
  var employeeEmployeeID;

  var imageDocumentedEmployeeEmployeecontract;
  var employeeContractID;

  var imageDocumentedEmployeeEmployeeOther;
  var employeeOtherID;

  //Business
  var imageDocumentedBusinessPhotosService;
  var businessPhotosServiceID;

  var imageDocumentedBusinessPermit;
  var businessPermitID;

  var imageDocumentedBusinessIncomeStatement;
  var businessIncomeStatementID;

  var imageDocumentedBusinessPaten;
  var businessPatenID;

  var imageDocumentedBusinessSalePurchase;
  var businessSalePurchaseID;

  var imageDocumentedBusinessRental;
  var businessRentalID;

  var imageDocumentedBusinessLocation;
  var businessLocationID;

  var imageDocumentedBusinessOther;
  var businessOtherID;

  //Collateral
  var imageDocumentedCollateralCertificate;
  var collateralCertificateID;

  var imageDocumentedCollateralPicture;
  var collateralPictureID;

  convertBase64ToImage(img64) {
    final decodedBytes = base64Decode(img64);
    var file = Io.File("decodedBezkoder.png");
    return file.writeAsBytesSync(decodedBytes);
  }

  var storeListImage;

  Future getImageDocument() async {
    var loanCode =
        widget.listLoan != null ? widget.listLoan['lcode'] : widget.editLoan;
    var url = Uri.parse(baseURLInternal + 'loanDocuments/byloan/' + loanCode);
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    try {
      final Response response = await api().get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token
      });
      final parsed = jsonDecode(response.body);
      setState(() {
        storeListImage = parsed;
      });
      //  imageDocumented
      for (var item in parsed) {
        switch (item['type']) {
          case '101':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);

            setState(() {
              imageDocumentedNation = _bytes;
              nationID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/101.png');
            file.writeAsBytesSync(List.from(imageDocumentedNation));
            setState(() {
              _imageNation = file;
            });
            break;
          case '102':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedFamily = _bytes;
              familyID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/102.png');
            file.writeAsBytesSync(List.from(imageDocumentedFamily));
            setState(() {
              _imageFamily = file;
            });
            break;
          //
          case '103':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedResidentBook = _bytes;
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/103.png');
            file.writeAsBytesSync(List.from(imageDocumentedResidentBook));
            setState(() {
              _imageResident = file;
              residentID = item['dcode'];
            });
            break;
          case '104':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedKYCOther = _bytes;
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/104.png');
            file.writeAsBytesSync(List.from(imageDocumentedKYCOther));
            setState(() {
              _imageOther = file;
              kYCOtherID = item['dcode'];
            });
            break;
          //
          case '211':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedEmployeeSalaySlip = _bytes;
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/211.png');
            file.writeAsBytesSync(List.from(imageDocumentedEmployeeSalaySlip));
            setState(() {
              _imageSalarySlip = file;
              employeeSalaySlipID = item['dcode'];
            });
            break;
          case '212':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedEmployeeBankStatement = _bytes;
              employeeBankStatementID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/212.png');
            file.writeAsBytesSync(
                List.from(imageDocumentedEmployeeBankStatement));
            setState(() {
              _imageBankStatement = file;
            });
            break;
          //
          case '213':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedEmployeeSalaryVerify = _bytes;
              employeeSalaryVerifyID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/213.png');
            file.writeAsBytesSync(
                List.from(imageDocumentedEmployeeSalaryVerify));
            setState(() {
              _imageSalaryVerify = file;
            });
            break;
          case '215':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedEmployeeEmployeeID = _bytes;
              employeeEmployeeID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/215.png');
            file.writeAsBytesSync(List.from(imageDocumentedEmployeeEmployeeID));
            setState(() {
              _imageEmployeeID = file;
            });
            break;
          //
          case '214':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedEmployeeEmployeecontract = _bytes;
              employeeContractID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/214.png');
            file.writeAsBytesSync(
                List.from(imageDocumentedEmployeeEmployeecontract));
            setState(() {
              _imageEmployeeContrat = file;
            });
            break;
          case '216':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedEmployeeEmployeeOther = _bytes;
              employeeOtherID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/216.png');
            file.writeAsBytesSync(
                List.from(imageDocumentedEmployeeEmployeeOther));
            setState(() {
              _imageEmployeeOther = file;
            });
            break;

          //Business
          case '221':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedBusinessPhotosService = _bytes;
              businessPhotosServiceID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/221.png');
            file.writeAsBytesSync(
                List.from(imageDocumentedBusinessPhotosService));
            setState(() {
              _imagePhotoOfService = file;
            });
            break;
          case '222':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedBusinessPermit = _bytes;
              businessPermitID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/222.png');
            file.writeAsBytesSync(List.from(imageDocumentedBusinessPermit));
            setState(() {
              _imageBusinessPermit = file;
            });
            break;
          //
          case '224':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedBusinessIncomeStatement = _bytes;
              businessIncomeStatementID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/224.png');
            file.writeAsBytesSync(
                List.from(imageDocumentedBusinessIncomeStatement));
            setState(() {
              _imageIncomeStatementBank = file;
            });
            break;
          case '225':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedBusinessPaten = _bytes;
              businessPatenID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/225.png');
            file.writeAsBytesSync(List.from(imageDocumentedBusinessPaten));
            setState(() {
              _imagePatent = file;
            });
            break;
          //
          case '227':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedBusinessSalePurchase = _bytes;
              businessSalePurchaseID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/227.png');
            file.writeAsBytesSync(
                List.from(imageDocumentedBusinessSalePurchase));
            setState(() {
              _imageSaleAndPurchase = file;
            });
            break;
          case '226':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedBusinessRental = _bytes;
              businessRentalID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/226.png');
            file.writeAsBytesSync(List.from(imageDocumentedBusinessRental));
            setState(() {
              _imageRentalContract = file;
            });
            break;
          //
          case '223':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedBusinessLocation = _bytes;
              businessLocationID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/223.png');
            file.writeAsBytesSync(List.from(imageDocumentedBusinessLocation));
            setState(() {
              _imageBusinessLocationtitle = file;
            });
            break;
          case '228':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedBusinessOther = _bytes;
              businessOtherID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/228.png');
            file.writeAsBytesSync(List.from(imageDocumentedBusinessOther));
            setState(() {
              _imageBusinessOther = file;
            });
            break;
          //
          case '301':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedCollateralCertificate = _bytes;
              collateralCertificateID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/301.png');
            file.writeAsBytesSync(
                List.from(imageDocumentedCollateralCertificate));
            setState(() {
              _imageCollateralCertificate = file;
            });
            break;
          case '302':
            var uri = item['filepath'];
            Uint8List _bytes = base64.decode(uri.split(',').last);
            setState(() {
              imageDocumentedCollateralPicture = _bytes;
              collateralPictureID = item['dcode'];
            });
            final directory = await getApplicationDocumentsDirectory();
            var file = Io.File('${directory.path}/302.png');
            file.writeAsBytesSync(List.from(imageDocumentedCollateralPicture));
            setState(() {
              _imageCollateralPicture = file;
            });
            break;

          default:
        }
      }
    } catch (e) {
      logger.w('error: $e');
    }
  }

  Future onSubmite(context) async {
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
        _imageNation!.path != null &&
        _imageNation!.path.isNotEmpty) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_imageNation!.openRead()));
      var length = await _imageNation!.length();
      request.files.add(new http.MultipartFile('kyc[101]', stream, length,
          filename: basename(_imageNation!.path)));
    }

    // FamilyBook
    if (_imageFamily != null &&
        _imageFamily!.path != null &&
        _imageFamily!.path.isNotEmpty) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_imageFamily!.openRead()));
      var length = await _imageFamily!.length();
      request.files.add(new http.MultipartFile('kyc[102]', stream, length,
          filename: basename(_imageFamily!.path)));
    }

    // Resident
    if (_imageResident != null &&
        _imageResident!.path != null &&
        _imageResident!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageResident!.openRead()));
      var length = await _imageResident!.length();
      request.files.add(new http.MultipartFile('kyc[103]', stream, length,
          filename: basename(_imageResident!.path)));
    }

    // Kyc Other
    if (_imageOther != null &&
        _imageOther!.path != null &&
        _imageOther!.path.isNotEmpty) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_imageOther!.openRead()));
      var length = await _imageOther!.length();
      request.files.add(new http.MultipartFile('kyc[104]', stream, length,
          filename: basename(_imageOther!.path)));
    }

    // Employee Salary Slip
    if (_imageSalarySlip != null &&
        _imageSalarySlip!.path != null &&
        _imageSalarySlip!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageSalarySlip!.openRead()));
      var length = await _imageSalarySlip!.length();
      request.files.add(new http.MultipartFile('employee[211]', stream, length,
          filename: basename(_imageSalarySlip!.path)));
    }

    // Employee Bank Statement
    if (_imageBankStatement != null &&
        _imageBankStatement!.path != null &&
        _imageBankStatement!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageBankStatement!.openRead()));
      var length = await _imageBankStatement!.length();
      request.files.add(new http.MultipartFile('employee[212]', stream, length,
          filename: basename(_imageBankStatement!.path)));
    }

    // Employee SalaryVerify
    if (_imageSalaryVerify != null &&
        _imageSalaryVerify!.path != null &&
        _imageSalaryVerify!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageSalaryVerify!.openRead()));
      var length = await _imageSalaryVerify!.length();
      request.files.add(new http.MultipartFile('employee[213]', stream, length,
          filename: basename(_imageSalaryVerify!.path)));
    }

    // Employee Employee Contrat
    if (_imageEmployeeContrat != null &&
        _imageEmployeeContrat!.path != null &&
        _imageEmployeeContrat!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageEmployeeContrat!.openRead()));
      var length = await _imageEmployeeContrat!.length();
      request.files.add(new http.MultipartFile('employee[214]', stream, length,
          filename: basename(_imageEmployeeContrat!.path)));
    }

    // Employee Employee ID
    if (_imageEmployeeID != null &&
        _imageEmployeeID!.path != null &&
        _imageEmployeeID!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageEmployeeID!.openRead()));
      var length = await _imageEmployeeID!.length();
      request.files.add(new http.MultipartFile('employee[215]', stream, length,
          filename: basename(_imageEmployeeID!.path)));
    }
    // Employee Employee ID
    if (_imageEmployeeOther != null &&
        _imageEmployeeOther!.path != null &&
        _imageEmployeeOther!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageEmployeeOther!.openRead()));
      var length = await _imageEmployeeOther!.length();
      request.files.add(new http.MultipartFile('employee[216]', stream, length,
          filename: basename(_imageEmployeeOther!.path)));
    }

    // Business Photo of Service
    if (_imagePhotoOfService != null &&
        _imagePhotoOfService!.path != null &&
        _imagePhotoOfService!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imagePhotoOfService!.openRead()));
      var length = await _imagePhotoOfService!.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[221]', stream, length,
          filename: basename(_imagePhotoOfService!.path)));
    }

    // Business
    if (_imageBusinessPermit != null &&
        _imageBusinessPermit!.path != null &&
        _imageBusinessPermit!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageBusinessPermit!.openRead()));
      var length = await _imageBusinessPermit!.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[222]', stream, length,
          filename: basename(_imageBusinessPermit!.path)));
    }

    // Business
    if (_imageIncomeStatementBank != null &&
        _imageIncomeStatementBank!.path != null &&
        _imageIncomeStatementBank!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageIncomeStatementBank!.openRead()));
      var length = await _imageIncomeStatementBank!.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[224]', stream, length,
          filename: basename(_imageIncomeStatementBank!.path)));
    }

    // Business
    if (_imagePatent != null &&
        _imagePatent!.path != null &&
        _imagePatent!.path.isNotEmpty) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_imagePatent!.openRead()));
      var length = await _imagePatent!.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[225]', stream, length,
          filename: basename(_imagePatent!.path)));
    }

    // Business
    if (_imageRentalContract != null &&
        _imageRentalContract!.path != null &&
        _imageRentalContract!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageRentalContract!.openRead()));
      var length = await _imageRentalContract!.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[226]', stream, length,
          filename: basename(_imageRentalContract!.path)));
    }

    // _imageBusinessLocationtitleDedd
    if (_imageBusinessLocationtitle != null &&
        _imageBusinessLocationtitle!.path != null &&
        _imageBusinessLocationtitle!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageBusinessLocationtitle!.openRead()));
      var length = await _imageBusinessLocationtitle!.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[223]', stream, length,
          filename: basename(_imageBusinessLocationtitle!.path)));
    }
    // Business
    if (_imageSaleAndPurchase != null &&
        _imageSaleAndPurchase!.path != null &&
        _imageSaleAndPurchase!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageSaleAndPurchase!.openRead()));
      var length = await _imageSaleAndPurchase!.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[227]', stream, length,
          filename: basename(_imageSaleAndPurchase!.path)));
    }
    // Business
    if (_imageBusinessOther != null &&
        _imageBusinessOther!.path != null &&
        _imageBusinessOther!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageBusinessOther!.openRead()));
      var length = await _imageBusinessOther!.length();
      request.files.add(new http.MultipartFile(
          'businessOwnerShip[228]', stream, length,
          filename: basename(_imageBusinessOther!.path)));
    }

    // Collateral
    if (_imageCollateralCertificate != null &&
        _imageCollateralCertificate!.path != null &&
        _imageCollateralCertificate!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageCollateralCertificate!.openRead()));
      var length = await _imageCollateralCertificate!.length();
      request.files.add(new http.MultipartFile(
          'collateral[301]', stream, length,
          filename: basename(_imageCollateralCertificate!.path)));
    }

    // Collateral
    if (_imageCollateralPicture != null &&
        _imageCollateralPicture!.path != null &&
        _imageCollateralPicture!.path.isNotEmpty) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imageCollateralPicture!.openRead()));
      var length = await _imageCollateralPicture!.length();
      request.files.add(new http.MultipartFile(
          'collateral[302]', stream, length,
          filename: basename(_imageCollateralPicture!.path)));
    }

    // add headers
    request.headers.addAll(headers);

    // adding params
    var loanCode =
        widget.listLoan != null ? widget.listLoan['lcode'] : widget.editLoan;
    request.fields['lcode'] = loanCode;
    request.fields['bcode'] = branch;
    request.fields['ucode'] = user_ucode;
    setState(() {
      _isLoading = true;
    });
    try {
      // send
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      var json = jsonDecode(respStr);
      setState(() {
        validateImage = json[0];
      });

      if (response.statusCode == 200) {
        showInSnackBar(
            AppLocalizations.of(context)!.translate('successfully') ??
                'Successfully',
            Colors.redAccent);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            ModalRoute.withName("/Home"));
        //   context,
        //   MaterialPageRoute(builder: (context) => ListLoanApprovals()),
        // );
      } else {
        logger.i('response.statusCode::::: ${response.statusCode}');
      }
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        logger.i('message::::: ${value}');
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showInSnackBar(
          AppLocalizations.of(context)!.translate('please_select_document') ??
              'Please select document',
          Colors.redAccent);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKeyAddDocument =
      new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value, colorsBackground) {
    _scaffoldKeyAddDocument.currentState!.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: colorsBackground,
    ));
  }

  showDailog(context, value, imageClear1, imageClear2) {
    return AwesomeDialog(
        context: context,
        // animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        title: AppLocalizations.of(context)!.translate('information') ??
            'Information',
        desc: AppLocalizations.of(context)!.translate('do_you_want') ??
            'Do you want to upload document and submit request?',
        btnOkOnPress: () async {
          if (value != null && value != '')
            onDelete(value, imageClear1, imageClear2);
        },
        btnCancelText: AppLocalizations.of(context)!.translate('no') ?? "No",
        btnCancelOnPress: () async {},
        btnCancelIcon: Icons.close,
        btnOkIcon: Icons.check_circle,
        btnOkColor: logolightGreen,
        btnOkText: AppLocalizations.of(context)!.translate('yes') ?? 'Yes')
      ..show();
  }

  final storage = new FlutterSecureStorage();

  Future onDelete(value, imageClear1, imageClear2) async {
    var token = await storage.read(key: 'user_token');
    try {
      final Response response = await api().post(
        Uri.parse(baseURLInternal + 'loandocuments/' + value + '/delete'),
        headers: {
          "contentType": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      setState(() {
        imageClear1 = null;
        imageClear2 = null;
      });
      // final list = jsonDecode(response.body);
    } catch (error) {
      logger.e('error delete image: ${error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Header(
      keys: _scaffoldKeyAddDocument,
      headerTexts: "add_referent_document",
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
                  onSubmite(context);
                }),
          ],
        ),
      ],
      bodys: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: logolightGreen, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: <Widget>[
                      gridKYC(context),
                      gridEmployee(context),
                      gridBS(context),
                      gridCollateralDocument(context)
                    ],
                  ),
                ),
              ),
            ),
    );
  }

//
  File? _imageNation;
  File? _imageFamily;
  File? _imageResident;
  File? _imageOther;

  //
  File? _imageSalarySlip;
  File? _imageBankStatement;
  File? _imageSalaryVerify;
  File? _imageEmployeeContrat;
  File? _imageEmployeeID;
  File? _imageEmployeeOther;
  //

  File? _imagePhotoOfService;
  File? _imageBusinessPermit;
  File? _imageBusinessLocationtitle;
  File? _imageIncomeStatementBank;
  File? _imagePatent;
  File? _imageRentalContract;
  File? _imageSaleAndPurchase;
  File? _imageBusinessOther;
  //

  File? _imageCollateralCertificate;
  File? _imageCollateralPicture;
  //

  // getImage
  Future getImage() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageNation = File(pickedFile.path); // Exception occurred here
      });
    } else {}
    return null;
  }

//getFamily
  Future getFamily() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFamily = File(pickedFile.path); // Exception occurred here
      });
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
    return null;
  }

// getBusinessOther
  Future getBusinessLocationTitle() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageBusinessLocationtitle =
            File(pickedFile.path); // Exception occurred here
      });
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
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
    } else {}
    return null;
  }

  Widget gridKYC(context) {
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
                    imageDocumented: imageDocumentedNation != null
                        ? imageDocumentedNation
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '101'
                            ? Colors.red
                            : null,
                    text: 'Native ID',
                    onTaps: () {
                      getImage();
                    },
                    onClearImage: () async {
                      logger.e('image: ');
                      if (nationID != null) {
                        try {
                          var token = await storage.read(key: 'user_token');
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                nationID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageNation = null;
                            imageDocumentedNation = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageNation = null;
                          imageDocumentedNation = null;
                        });
                      }
                    },
                    image: _imageNation),
                WidgetCardAddRef(
                    imageDocumented: imageDocumentedFamily != null
                        ? imageDocumentedFamily
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '102'
                            ? Colors.red
                            : null,
                    text: 'Family book',
                    onTaps: () {
                      getFamily();
                    },
                    onClearImage: () async {
                      if (familyID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                familyID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageFamily = null;
                            imageDocumentedFamily = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageFamily = null;
                          imageDocumentedFamily = null;
                        });
                      }
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
                    imageDocumented: imageDocumentedResidentBook != null
                        ? imageDocumentedResidentBook
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '103'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getResident();
                    },
                    // onClearImage: () {
                    //   showDailog(context, residentID, _imageResident,
                    //       imageDocumentedResidentBook);
                    // },
                    onClearImage: () async {
                      if (residentID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                residentID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageResident = null;
                            imageDocumentedResidentBook = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageResident = null;
                          imageDocumentedResidentBook = null;
                        });
                      }
                    },
                    image: _imageResident),
                WidgetCardAddRef(
                    text: 'Other',
                    imageDocumented: imageDocumentedKYCOther != null
                        ? imageDocumentedKYCOther
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '104'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getOther();
                    },
                    onClearImage: () async {
                      if (kYCOtherID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                kYCOtherID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageOther = null;
                            imageDocumentedKYCOther = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageOther = null;
                          imageDocumentedKYCOther = null;
                        });
                      }
                    },
                    image: _imageOther),
              ],
            ),
          ],
        ));
  }

  Widget gridEmployee(context) {
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
                    imageDocumented: imageDocumentedEmployeeSalaySlip != null
                        ? imageDocumentedEmployeeSalaySlip
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '211'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getSalarySlip();
                    },
                    // onClearImage: () {
                    //   showDailog(context, employeeSalaySlipID, _imageSalarySlip,
                    //       imageDocumentedEmployeeBankStatement);
                    // },
                    onClearImage: () async {
                      if (employeeSalaySlipID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                employeeSalaySlipID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageSalarySlip = null;
                            imageDocumentedEmployeeSalaySlip = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageSalarySlip = null;
                          imageDocumentedEmployeeSalaySlip = null;
                        });
                      }
                    },
                    image: _imageSalarySlip),
                WidgetCardAddRef(
                    text: 'Bank statement last 3 months',
                    imageDocumented:
                        imageDocumentedEmployeeBankStatement != null
                            ? imageDocumentedEmployeeBankStatement
                            : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '212'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBankStatement();
                    },
                    // onClearImage: () {
                    //   showDailog(
                    //       context,
                    //       employeeBankStatementID,
                    //       _imageBankStatement,
                    //       imageDocumentedEmployeeBankStatement);
                    // },
                    onClearImage: () async {
                      if (employeeBankStatementID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                employeeBankStatementID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageBankStatement = null;
                            imageDocumentedEmployeeBankStatement = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageBankStatement = null;
                          imageDocumentedEmployeeBankStatement = null;
                        });
                      }
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
                    imageDocumented: imageDocumentedEmployeeSalaryVerify != null
                        ? imageDocumentedEmployeeSalaryVerify
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '213'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getSalaryVerify();
                    },
                    // onClearImage: () {
                    //   showDailog(
                    //       context,
                    //       employeeSalaryVerifyID,
                    //       _imageSalaryVerify,
                    //       imageDocumentedEmployeeSalaryVerify);
                    // },
                    onClearImage: () async {
                      if (employeeSalaryVerifyID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                employeeSalaryVerifyID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageSalaryVerify = null;
                            imageDocumentedEmployeeSalaryVerify = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageSalaryVerify = null;
                          imageDocumentedEmployeeSalaryVerify = null;
                        });
                      }
                    },
                    image: _imageSalaryVerify),
                WidgetCardAddRef(
                    text: 'Employee ID (validity)',
                    imageDocumented: imageDocumentedEmployeeEmployeeID != null
                        ? imageDocumentedEmployeeEmployeeID
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '215'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getEmployeeID();
                    },
                    // onClearImage: () {
                    //   showDailog(context, employeeEmployeeID, _imageEmployeeID,
                    //       imageDocumentedEmployeeEmployeeID);
                    // },
                    onClearImage: () async {
                      if (employeeEmployeeID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                employeeEmployeeID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageEmployeeID = null;
                            imageDocumentedEmployeeEmployeeID = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageEmployeeID = null;
                          imageDocumentedEmployeeEmployeeID = null;
                        });
                      }
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
                    imageDocumented:
                        imageDocumentedEmployeeEmployeecontract != null
                            ? imageDocumentedEmployeeEmployeecontract
                            : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '214'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getEmployeeContrat();
                    },
                    // onClearImage: () {
                    //   showDailog(
                    //       context,
                    //       employeeContractID,
                    //       _imageEmployeeContrat,
                    //       imageDocumentedEmployeeEmployeecontract);
                    // },
                    onClearImage: () async {
                      if (employeeContractID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                employeeContractID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageEmployeeContrat = null;
                            imageDocumentedEmployeeEmployeecontract = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageEmployeeContrat = null;
                          imageDocumentedEmployeeEmployeecontract = null;
                        });
                      }
                    },
                    image: _imageEmployeeContrat),
                WidgetCardAddRef(
                    text: 'Other',
                    imageDocumented:
                        imageDocumentedEmployeeEmployeeOther != null
                            ? imageDocumentedEmployeeEmployeeOther
                            : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '216'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getEmployeeOther();
                    },
                    // onClearImage: () {
                    //   showDailog(context, employeeOtherID, _imageEmployeeOther,
                    //       imageDocumentedEmployeeEmployeeOther);
                    // },
                    onClearImage: () async {
                      if (employeeOtherID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                employeeOtherID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageEmployeeOther = null;
                            imageDocumentedEmployeeEmployeeOther = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageEmployeeOther = null;
                          imageDocumentedEmployeeEmployeeOther = null;
                        });
                      }
                    },
                    image: _imageEmployeeOther),
              ],
            ),
          ],
        ));
  }

  Widget gridBS(context) {
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
                    imageDocumented:
                        imageDocumentedBusinessPhotosService != null
                            ? imageDocumentedBusinessPhotosService
                            : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '221'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getPhotoOfService();
                    },
                    onClearImage: () async {
                      if (businessPhotosServiceID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                businessPhotosServiceID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imagePhotoOfService = null;
                            imageDocumentedBusinessPhotosService = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imagePhotoOfService = null;
                          imageDocumentedBusinessPhotosService = null;
                        });
                      }
                    },
                    image: _imagePhotoOfService),
                WidgetCardAddRef(
                    text: 'Business permit(validity)',
                    imageDocumented: imageDocumentedBusinessPermit != null
                        ? imageDocumentedBusinessPermit
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '222'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBusinessPermit();
                    },
                    onClearImage: () async {
                      if (businessPermitID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                businessPermitID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageBusinessPermit = null;
                            imageDocumentedBusinessPermit = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageBusinessPermit = null;
                          imageDocumentedBusinessPermit = null;
                        });
                      }
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
                    imageDocumented:
                        imageDocumentedBusinessIncomeStatement != null
                            ? imageDocumentedBusinessIncomeStatement
                            : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '224'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getIncomeStatementAndBank();
                    },
                    // onClearImage: () {
                    //   showDailog(
                    //       context,
                    //       businessIncomeStatementID,
                    //       _imageIncomeStatementBank,
                    //       imageDocumentedBusinessIncomeStatement);
                    // },
                    onClearImage: () async {
                      if (businessIncomeStatementID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                businessIncomeStatementID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageIncomeStatementBank = null;
                            imageDocumentedBusinessIncomeStatement = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageIncomeStatementBank = null;
                          imageDocumentedBusinessIncomeStatement = null;
                        });
                      }
                    },
                    image: _imageIncomeStatementBank),
                WidgetCardAddRef(
                    text: 'Patent (validity)',
                    imageDocumented: imageDocumentedBusinessPaten != null
                        ? imageDocumentedBusinessPaten
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '225'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBusinessPatent();
                    },
                    // onClearImage: () {
                    //   showDailog(context, businessPatenID, _imagePatent,
                    //       imageDocumentedBusinessPaten);
                    // },
                    onClearImage: () async {
                      if (businessPatenID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                businessPatenID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imagePatent = null;
                            imageDocumentedBusinessPaten = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imagePatent = null;
                          imageDocumentedBusinessPaten = null;
                        });
                      }
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
                    imageDocumented: imageDocumentedBusinessSalePurchase != null
                        ? imageDocumentedBusinessSalePurchase
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '227'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBusinessSaleAndPurchase();
                    },
                    // onClearImage: () {
                    //   showDailog(
                    //       context,
                    //       businessSalePurchaseID,
                    //       _imageSaleAndPurchase,
                    //       imageDocumentedBusinessSalePurchase);
                    // },
                    onClearImage: () async {
                      if (businessSalePurchaseID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                businessSalePurchaseID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageSaleAndPurchase = null;
                            imageDocumentedBusinessSalePurchase = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageSaleAndPurchase = null;
                          imageDocumentedBusinessSalePurchase = null;
                        });
                      }
                    },
                    image: _imageSaleAndPurchase),
                WidgetCardAddRef(
                    text: 'Rental contract (validity)',
                    imageDocumented: imageDocumentedBusinessRental != null
                        ? imageDocumentedBusinessRental
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '226'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBusinessRentalContract();
                    },
                    // onClearImage: () {
                    //   showDailog(context, businessRentalID,
                    //       _imageRentalContract, imageDocumentedBusinessRental);
                    // },
                    onClearImage: () async {
                      if (businessRentalID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                businessRentalID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageRentalContract = null;
                            imageDocumentedBusinessRental = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageRentalContract = null;
                          imageDocumentedBusinessRental = null;
                        });
                      }
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
                    imageDocumented: imageDocumentedBusinessLocation != null
                        ? imageDocumentedBusinessLocation
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '223'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBusinessLocationTitle();
                    },
                    // onClearImage: () {
                    //   showDailog(
                    //       context,
                    //       businessLocationID,
                    //       _imageBusinessLocationtitle,
                    //       imageDocumentedBusinessLocation);
                    // },
                    onClearImage: () async {
                      if (businessLocationID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                businessLocationID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageBusinessLocationtitle = null;
                            imageDocumentedBusinessLocation = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageBusinessLocationtitle = null;
                          imageDocumentedBusinessLocation = null;
                        });
                      }
                    },
                    image: _imageBusinessLocationtitle),
                WidgetCardAddRef(
                    text: 'Other',
                    imageDocumented: imageDocumentedBusinessOther != null
                        ? imageDocumentedBusinessOther
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '228'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getBusinessOther();
                    },
                    // onClearImage: () {
                    //   showDailog(context, businessOtherID, _imageBusinessOther,
                    //       imageDocumentedBusinessOther);
                    // },
                    onClearImage: () async {
                      if (businessOtherID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                businessOtherID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageBusinessOther = null;
                            imageDocumentedBusinessOther = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageBusinessOther = null;
                          imageDocumentedBusinessOther = null;
                        });
                      }
                    },
                    image: _imageBusinessOther),
              ],
            ),
          ],
        ));
  }

  Widget gridCollateralDocument(context) {
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
                    imageDocumented:
                        imageDocumentedCollateralCertificate != null
                            ? imageDocumentedCollateralCertificate
                            : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '301'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getCollateralCertificate();
                    },
                    onClearImage: () async {
                      if (collateralCertificateID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                collateralCertificateID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageCollateralCertificate = null;
                            imageDocumentedCollateralCertificate = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageCollateralCertificate = null;
                          imageDocumentedCollateralCertificate = null;
                        });
                      }
                    },
                    image: _imageCollateralCertificate),
                WidgetCardAddRef(
                    text: 'Collateral picture',
                    imageDocumented: imageDocumentedCollateralPicture != null
                        ? imageDocumentedCollateralPicture
                        : null,
                    validateImage:
                        validateImage != null && validateImage['key'] == '302'
                            ? Colors.red
                            : null,
                    onTaps: () {
                      getCollateralPicture();
                    },
                    onClearImage: () async {
                      if (collateralPictureID != null) {
                        var token = await storage.read(key: 'user_token');
                        try {
                          final Response response = await api().post(
                            Uri.parse(baseURLInternal +
                                'loandocuments/' +
                                collateralPictureID +
                                '/delete'),
                            headers: {
                              "contentType": "application/json",
                              "Authorization": "Bearer " + token
                            },
                          );
                          setState(() {
                            _imageCollateralPicture = null;
                            imageDocumentedCollateralPicture = null;
                          });
                        } catch (error) {
                          logger.e('error delete image: ${error}');
                        }
                      } else {
                        setState(() {
                          _imageCollateralPicture = null;
                          imageDocumentedCollateralPicture = null;
                        });
                      }
                    },
                    image: _imageCollateralPicture),
              ],
            ),
          ],
        ));
  }
}
