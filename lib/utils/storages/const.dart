import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'dart:async';
import 'colors.dart';

final String fontFamily = 'Segoe UI';

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
