import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'dart:async';
import 'colors.dart';

final String fontFamily = 'Segoe UI';
final double gMaxWidth = 400.0;

const fontSizeLg = 20.0;
const fontSizeSm = 18.0;
const fontSizeXs = 15.0;
const fontSizeXxs = 13.0;

const fontWeight500 = FontWeight.w400;
const fontWeight700 = FontWeight.w700;
const fontWeight800 = FontWeight.w800;
const fontWeight900 = FontWeight.w900;

final mainTextStyle = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeLg,
  color: Colors.white,
  fontWeight: fontWeight700,
);

final mainTitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    color: Colors.white,
    fontWeight: fontWeight700);

final mainTitleStyleBlack = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    color: Colors.black,
    fontWeight: fontWeight700);

final textTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    color: Colors.white,
    fontWeight: fontWeight700);

final mainTitleBlack = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    color: Colors.black,
    fontWeight: fontWeight800);

final normalTitle = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeSm,
  color: Colors.white,
);

final normalTitleblack = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeXs,
  color: Colors.black,
);

final mainTitleBlue = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    color: logolightGreen,
    fontWeight: fontWeight800);

final titleBlue = TextStyle(
  fontFamily: fontFamily,
  fontSize: fontSizeXs,
  color: logolightGreen,
);

api() {
  var httpClient = HttpClient();
  httpClient.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  var _ioClient = IOClient(httpClient);
  return _ioClient;
}

getDateTimeYMD(time) {
  DateTime dateTimeApproved = DateTime.parse(time);
  String dateTime = DateFormat("yyyy-MM-dd").format(dateTimeApproved);
  return dateTime;
}

getYYMMDD(time) {
  DateTime dateTimeApproved = DateTime.parse(time);
  String dateTime = DateFormat("yyyyMMdd").format(dateTimeApproved);
  return dateTime;
}

getDDMMYY(time) {
  DateTime dateTimeApproved = DateTime.parse(time);
  String dateTime = DateFormat("dd-MM-yyyy").format(dateTimeApproved);
  return dateTime;
}

Future<String> readResponse(HttpClientResponse response) {
  final completer = Completer<String>();
  final contents = StringBuffer();
  response.transform(utf8.decoder).listen((data) {
    contents.write(data);
  }, onDone: () => completer.complete(contents.toString()));
  return completer.future;
}

logger() {
  var loggers = Logger(
    printer: PrettyPrinter(),
  );
  return loggers;
}

var numFormat = new NumberFormat("#,###.00", "en_US");
// const width = MediaQuery.of(context).size.width * 1;
// const height = MediaQuery.of(context).size.width * 0.12;

final formatCurrency = new NumberFormat("#,##0.00", "en_US");
//
final storage = new FlutterSecureStorage();
bool isInteger(num value) => value is int || value == value.roundToDouble();
//
widthView(context, value) {
  var widthValue = value != null ? value : 1.9;
  var width = MediaQuery.of(context).size.width * widthValue;
  return width;
}

void showInSnackBar(String value, colorsBackground, scaffoldKey) {
  scaffoldKey.currentState.showSnackBar(new SnackBar(
    content: new Text(value),
    backgroundColor: colorsBackground,
  ));
}

isIphoneX(context) {
  final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
  return iphonex;
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  // String get toTitleCase => this.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.toCapitalized()).join(" ");
}
