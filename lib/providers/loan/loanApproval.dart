import 'dart:convert';

import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import '../manageService.dart';

class LoanApproval with ChangeNotifier {
  final storage = new FlutterSecureStorage();
  var isLoading = false;

//Request list loan
  Future getLoanApproval(
      _pageSize, _pageNumber, status, code, bcode, sdate, edate) async {
    isLoading = true;

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
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
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

      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'loanRequests/all'),
          headers: headers,
          body: json.encode(bodyRow));
      if (response.statusCode == 200) {
        final dynamic parsed = [];
        parsed.addAll(jsonDecode(response.body));
        isLoading = false;
        notifyListeners();
        return jsonDecode(response.body);
      } else {
        isLoading = false;
      }
    } catch (error) {
      isLoading = false;
      print('error provider::: ${error}');
    }
  }

  Future getLoanApprovalDetail(rcode) async {
    try {
      var token = await storage.read(key: 'user_token');

      // var bodyRow =
      //     "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"sdate\": \"\",\n    \"edate\": \"\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final Response response = await api().get(
        Uri.parse(baseURLInternal + 'loanRequests/Applications/' + rcode),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final dynamic parsed = [];
        parsed.add(jsonDecode(response.body));
        notifyListeners();

        return parsed;
      }
    } catch (error) {}
  }

  var successfully = false;
  var successfullyReturn = false;
  var successfullyReject = false;
  //approval
  Future approval(rcode, ucode, bcode, lcode, rdate, roleList, cmt) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");
    var branch = await storage.read(key: 'branch');
    successfully = false;
    final Map<String, dynamic> bodyRow = {
      "rcode": "$rcode",
      "ucode": "$user_ucode",
      "bcode": "$branch",
      "lcode": "$lcode",
      "roleList": "${roleList}",
      "cmt": "$cmt"
    };

    try {
      final Response response = await api().post(
          Uri.parse(
              baseURLInternal + 'loanRequests/post/' + rcode + '/Approve'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: json.encode(bodyRow));
      final parsed = jsonDecode(response.body);

      if (response.statusCode == 201) {
        successfully = true;
        notifyListeners();
        return parsed;
      } else {
        successfully = false;
      }
    } catch (error) {
      logger().e("error :${error}");

      successfully = false;
    }
  }

//reject
  Future rejectFunction(
      rcode, ucode, bcode, lcode, rdate, roleList, cmt) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");
    var branch = await storage.read(key: 'branch');

    final Map<String, dynamic> bodyRow = {
      "rcode": "$rcode",
      "ucode": "$user_ucode",
      "bcode": "$branch",
      "lcode": "$lcode",
      "roleList": "$roleList",
      "cmt": "$cmt"
    };
    try {
      final Response response = await api().post(
          Uri.parse(
              baseURLInternal + 'loanRequests/post/' + rcode + '/Disapprove'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: json.encode(bodyRow));
      final parsed = jsonDecode(response.body);
      if (response.statusCode == 201) {
        successfullyReject = true;
        return parsed;
      } else {
        successfullyReject = false;
      }
    } catch (error) {
      successfullyReject = false;
    }
  }

  //return
  Future returnFunction(
      rcode, ucode, bcode, lcode, rdate, roleList, cmt) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");
    var branch = await storage.read(key: 'branch');
    final Map<String, dynamic> bodyRow = {
      "rcode": "$rcode",
      "ucode": "$user_ucode",
      "bcode": "$branch",
      "lcode": "$lcode",
      "rdate": "",
      "roleList": "$roleList",
      "cmt": "$cmt"
    };
    try {
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'loanRequests/post/' + rcode + '/Return'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: json.encode(bodyRow));
      final parsed = jsonDecode(response.body);
      if (response.statusCode == 201) {
        successfullyReturn = true;
        return parsed;
      } else {
        successfullyReturn = false;
      }
    } catch (error) {
      successfullyReturn = false;
    }
  }

  bool get isFetchingSuccessfully => successfully;
  bool get isFetchingSuccessfullyReturn => successfullyReturn;
  bool get isFetchingSuccessfullyReject => successfullyReject;
  bool get isFetchingLoading => isLoading;
}
