import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/models/index.dart';
import 'package:chokchey_finance/models/listLoan.dart';
import 'package:chokchey_finance/models/valueListCustomers.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GroupLoanProvider with ChangeNotifier {
  final storage = new FlutterSecureStorage();
  var successfullyByID = false;
  //
  var successfully = false;
  var listData = [];
  //

  Future postGroupLoan(gname, groupLoanDetail) async {
    final storage = new FlutterSecureStorage();
    String user_id = await storage.read(key: 'user_id');
    var token = await storage.read(key: 'user_token');
    var branch = await storage.read(key: 'branch');

    final boyrow =
        "{\n    \"ucode\": \"$user_id\",\n  \"bcode\": \"$branch\",\n \"gname\": \"$gname\",\n \"groupLoanDetail\": $groupLoanDetail,\n    }";
    logger().i('boyrow: ${boyrow}');

    try {
      final response = await api().post(
          baseURLInternal + 'GroupLoan/creategrouploan',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: boyrow);
      logger().i(baseURLInternal + 'GroupLoan/creategrouploan');

      final list = jsonDecode(response.body);
      notifyListeners();
      return list;
    } catch (error) {
      logger().i('error: ${error}');
    }
  }

  //get group loan by id
  Future fetchGroupLoanByID(
      gcode, _pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");
    var branch = await storage.read(key: "branch");
    var level = await storage.read(key: "level");
    var sdates = sdate != null ? sdate : '';
    var edates = edate != null ? edate : '';
    var codes = code != null ? code : '';
    var statuses = status != null ? status : '';
    var btlcode = status != null ? status : '';
    var bcodes;
    var ucode;
    if (level == '3') {
      bcodes = bcode != null && bcode != "" ? bcode : branch;
      btlcode = '';
      ucode = codes != null && codes != "" ? codes : "";
    }

    if (level == '2') {
      bcodes = bcode != null && bcode != "" ? bcode : branch;
      btlcode = user_ucode;
      ucode = code != null && code != "" ? code : '';
    }

    if (level == '1') {
      bcodes = bcode != null && bcode != "" ? bcode : branch;
      ucode = user_ucode;
      btlcode = '';
    }

    if (level == '4' || level == '5' || level == '6') {
      bcodes = bcode != null && bcode != "" ? bcode : '';
      btlcode = '';
      ucode = code != null && code != "" ? code : '';
    }
    var bodyRow =
        "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n    \"btlcode\": \"$btlcode\",\n    \"status\": \"\",\n    \"code\": \"\",\n    \"sdate\": \"$sdates\",\n    \"edate\": \"$edates\"\n}";
    try {
      successfullyByID = true;

      final response = await api().post(baseURLInternal + 'GroupLoan/' + gcode,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: bodyRow);
      final list = jsonDecode(response.body);

      if (response.statusCode == 200) {
        successfullyByID = false;
      } else {
        successfullyByID = false;
      }
      notifyListeners();
      return list;
    } catch (error) {
      successfullyByID = false;
    }
  }

  //Approval
  Future approvalRejectReturn(
      gcode, ucode, bcode, roleList, cmt, status) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");
    var branch = await storage.read(key: 'branch');
    var bodyRow =
        "{\n    \"gcode\": \"$gcode\",\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n  \"roleList\": \"$roleList\",\n    \"cmt\": \"$cmt\"\n\n}";

    try {
      final response = await api().post(
          baseURLInternal + 'GroupLoan/Post/' + gcode + '/' + status,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: bodyRow);
      final parsed = jsonDecode(response.body);
      if (response.statusCode == 201) {
        successfully = true;
        return parsed;
      } else {
        successfully = false;
      }
      notifyListeners();
    } catch (error) {
      logger().e("error: ${error}");

      successfully = false;
    }
  }

  Future fetchGroupLoanAll(
      _pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    try {
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var level = await storage.read(key: "level");
      var bodyRow;
      var sdates = sdate != null ? sdate : '';
      var edates = edate != null ? edate : '';
      var codes = code != null ? code : '';
      var statuses = status != null ? status : '';
      var btlcode = status != null ? status : '';
      var bcodes;
      var ucode;
      if (level == '3') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        btlcode = '';
        ucode = codes != null && codes != "" ? codes : "";
      }

      if (level == '2') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        btlcode = user_ucode;
        ucode = code != null && code != "" ? code : '';
      }

      if (level == '1') {
        bcodes = bcode != null && bcode != "" ? bcode : branch;
        ucode = user_ucode;
        btlcode = '';
      }

      if (level == '4' || level == '5' || level == '6') {
        bcodes = bcode != null && bcode != "" ? bcode : '';
        btlcode = '';
        ucode = code != null && code != "" ? code : '';
      }
      bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n     \"status\": \"\",\n       \"sdate\": \"$sdates\",\n    \"edate\": \"$edates\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      logger().e("bodyRow: ${bodyRow}");

      final response = await api().post(baseURLInternal + 'GroupLoan/all',
          headers: headers, body: bodyRow);
      notifyListeners();
      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);

        listData.addAll(listLoan);
        logger().e("listLoan: ${listLoan}");

        return listLoan;
      }
    } catch (error) {
      logger().e("error: ${error}");
    }
  }

  dynamic get listDataSuccessful => listData;
  bool get isFetchingSuccessfully => successfully;
  bool get isFetchingSuccessfullyGroupLoanByID => successfullyByID;
}
