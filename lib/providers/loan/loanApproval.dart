import 'dart:convert';

import 'package:chokchey_finance/models/listLoan.dart';
import 'package:chokchey_finance/models/requestDetailLoan.dart';
import 'package:chokchey_finance/models/requestLoanApproval.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../manageService.dart';

class LoanApproval with ChangeNotifier {
  final storage = new FlutterSecureStorage();
  var isLoading = false;

//Request list loan
  Future<List<RequestLoanApproval>> getLoanApproval(
      _pageSize, _pageNumber) async {
    isLoading = true;

    try {
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"sdate\": \"\",\n    \"edate\": \"\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await api().post(baseURLInternal + 'loanRequests/byuser',
          headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        final dynamic parsed = [];
        parsed.addAll(jsonDecode(response.body));
        isLoading = false;
        notifyListeners();
        return jsonDecode(response.body)
            .map<RequestLoanApproval>(
                (json) => RequestLoanApproval.fromJson(json))
            .toList();
      } else {
        print('statusCode::: ${response.statusCode}');
        isLoading = false;
      }
    } catch (error) {
      isLoading = false;
    }
  }

  Future<List<RequestDetailLoan>> getLoanApprovalDetail(rcode) async {
    try {
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      // var bodyRow =
      //     "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"sdate\": \"\",\n    \"edate\": \"\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await api().get(
        baseURLInternal + 'loanRequests/Applications/' + rcode,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final dynamic parsed = [];
        parsed.add(jsonDecode(response.body));
        notifyListeners();
        return parsed
            .map<RequestDetailLoan>((json) => RequestDetailLoan.fromJson(json))
            .toList();
      } else {
        print('statusCode::: ${response.statusCode}');
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
    var bodyRow =
        "{\n    \"rcode\": \"$rcode\",\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"lcode\": \"$lcode\",\n    \"roleList\": \"$roleList\",\n    \"cmt\": \"$cmt\"\n\n}";
    logger().e("bodyRow: ${bodyRow}");

    try {
      final response = await api().post(
          baseURLInternal + 'loanRequests/post/' + rcode + '/Approve',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: bodyRow);
      final parsed = jsonDecode(response.body);
      if (response.statusCode == 201) {
        logger().e("response.statusCode: ${response.statusCode}");

        successfully = true;
        logger().e("parsed: ${parsed}");
        return parsed;
      } else {
        successfully = false;
      }
      notifyListeners();
    } catch (error) {
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

    var bodyRow =
        "{\n    \"rcode\": \"$rcode\",\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"lcode\": \"$lcode\",\n    \"roleList\": \"$roleList\",\n    \"cmt\": \"$cmt\"\n\n}";

    try {
      final response = await api().post(
          baseURLInternal + 'loanRequests/post/' + rcode + '/Disapprove',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: bodyRow);
      final parsed = jsonDecode(response.body);
      if (response.statusCode == 200) {
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

    var bodyRow =
        "{\n    \"rcode\": \"$rcode\",\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"lcode\": \"$lcode\",\n    \"rdate\": \"\",\n    \"roleList\": \"$roleList\",\n    \"cmt\": \"$cmt\"\n\n}";
    try {
      final response = await api().post(
          baseURLInternal + 'loanRequests/post/' + rcode + '/Return',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: bodyRow);
      final parsed = jsonDecode(response.body);
      if (response.statusCode == 200) {
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
