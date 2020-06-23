import 'package:flutter/material.dart';

final String fontFamily = 'Segoe UI';

const fontSizeLg = 20.0;
const fontSizeSm = 18.0;
const fontSizeXs = 15.0;

const fontWeight700 = FontWeight.w700;
const fontWeight500 = FontWeight.w400;

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
    fontSize: fontSizeSm,
    color: Colors.black,
    fontWeight: fontWeight500);

Function statusApproval(value) {
  switch (value) {
    case 10:
      {
        'Request';
      }
      break;

    case 20:
      {
        'Approve';
      }
      break;

    case 30:
      {
        'Final Approve';
      }
      break;

    case 80:
      {
        'Return';
      }
      break;

    case 90:
      {
        'Reject';
      }
      break;

    default:
      {
        // ''
      }
      break;
  }
}

//service const
