import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';

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

post() {
  var httpClient = HttpClient();
  httpClient.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  var _ioClient = IOClient(httpClient);
  return _ioClient;
}
