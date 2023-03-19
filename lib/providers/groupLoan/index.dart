import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class GroupLoanProvider with ChangeNotifier {
  final storage = new FlutterSecureStorage();
  var successfullyByID = false;
  //
  var successfully = false;
  var listData = [];
  //
  var _isError = false;
  var _isLoadingFetchLoan = false;
  var listGroupLoan = [];

  Future fetchLoan(
      _pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    final storage = new FlutterSecureStorage();
    _isLoadingFetchLoan = true;
    try {
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
      // bodyRow =
      //     "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n    \"btlcode\": \"$btlcode\",\n    \"status\": \"\",\n    \"code\": \"\",\n    \"sdate\": \"$sdates\",\n    \"edate\": \"$edates\"\n}";
      final Map<String, dynamic> bodyRow = {
        "pageSize": "$_pageSize",
        "pageNumber": "$_pageNumber",
        "ucode": "$ucode",
        "bcode": "$bcodes",
        "btlcode": "$btlcode",
        "status": "",
        "code": "",
        "sdate": "$sdates",
        "edate": "$edates"
      };
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'loanRequests/all'),
          headers: headers,
          body: json.encode(bodyRow));
      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);
        _isLoadingFetchLoan = false;
        notifyListeners();
        return listLoan;
      } else {
        _isLoadingFetchLoan = false;
      }
    } catch (error) {
      _isError = false;
    }
  }

  Future postGroupLoan(gname, groupLoanDetail) async {
    final storage = new FlutterSecureStorage();
    String? user_id = await storage.read(key: 'user_id');
    var token = await storage.read(key: 'user_token');
    var branch = await storage.read(key: 'branch');
    // final boyrow =
    //     "{\n    \"ucode\": \"$user_id\",\n  \"bcode\": \"$branch\",\n \"gname\": \"$gname\",\n \"groupLoanDetail\": $groupLoanDetail,\n    }";
    final Map<String, dynamic> bodyRow = {
      "ucode": "$user_id",
      "bcode": "$branch",
      "gname": "$gname",
      "groupLoanDetail": groupLoanDetail
    };
    try {
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'GroupLoan/creategrouploan'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + '$token'
          },
          body: json.encode(bodyRow));
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
    // var bodyRow =
    //     "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n    \"btlcode\": \"$btlcode\",\n    \"status\": \"\",\n    \"code\": \"\",\n    \"sdate\": \"$sdates\",\n    \"edate\": \"$edates\"\n}";
    final Map<String, dynamic> bodyRow = {
      "pageSize": "$_pageSize",
      "pageNumber": "$_pageNumber",
      "ucode": "$ucode",
      "bcode": "$bcodes",
      "btlcode": "$btlcode",
      "status": "",
      "code": "",
      "sdate": "$sdates",
      "edate": "$edates"
    };
    try {
      successfullyByID = true;
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'GroupLoan/' + gcode),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + '$token'
          },
          body: json.encode(bodyRow));
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
    // var bodyRow =
    //     "{\n    \"gcode\": \"$gcode\",\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n  \"roleList\": \"$roleList\",\n    \"cmt\": \"$cmt\"\n\n}";
    final Map<String, dynamic> bodyRow = {
      "gcode": "$gcode",
      "ucode": "$user_ucode",
      "bcode": "$branch",
      "roleList": "$roleList",
      "cmt": "$cmt"
    };
    try {
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'GroupLoan/Post/' + gcode + '/' + status),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + '$token'
          },
          body: json.encode(bodyRow));
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
      // bodyRow =
      //     "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"$bcodes\",\n     \"status\": \"\",\n       \"sdate\": \"$sdates\",\n    \"edate\": \"$edates\"\n}";

      final Map<String, dynamic> bodyRow = {
        "pageSize": "$_pageSize",
        "pageNumber": "$_pageNumber",
        "ucode": "$ucode",
        "bcode": "$bcodes",
        "btlcode": "",
        "status": "",
        "code": "",
        "sdate": "$sdates",
        "edate": "$edates"
      };
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'GroupLoan/all'),
          headers: headers,
          body: json.encode(bodyRow));
      notifyListeners();
      if (response.statusCode == 200) {
        var listLoan = jsonDecode(response.body);
        listData.addAll(listLoan);
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
