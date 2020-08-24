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

//Request list loan
  Future<List<RequestLoanApproval>> getLoanApproval(
      _pageSize, _pageNumber) async {
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
        notifyListeners();
        return jsonDecode(response.body)
            .map<RequestLoanApproval>(
                (json) => RequestLoanApproval.fromJson(json))
            .toList();
      } else {
        print('statusCode::: ${response.statusCode}');
      }
    } catch (error) {}
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

  //approval
  Future approval(rcode, ucode, bcode, lcode, rdate, roleList, cmt) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");
    var bodyRow =
        "{\n    \"rcode\": \"$rcode\",\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$bcode\",\n    \"lcode\": \"$lcode\",\n    \"roleList\": \"$roleList\",\n    \"cmt\": \"$cmt\"\n\n}";

    try {
      final response = await api().post(
          baseURLInternal + 'loanRequests/post/' + rcode + '/Approve',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: bodyRow);
      final parsed = jsonDecode(response.body);
      notifyListeners();
    } catch (error) {
      print("error $error");
    }
  }

//reject
  Future rejectFunction(
      rcode, ucode, bcode, lcode, rdate, roleList, cmt) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");
    var bodyRow =
        "{\n    \"rcode\": \"$rcode\",\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$bcode\",\n    \"lcode\": \"$lcode\",\n    \"roleList\": \"$roleList\",\n    \"cmt\": \"$cmt\"\n\n}";

    try {
      final response = await api().post(
          baseURLInternal + 'loanRequests/post/' + rcode + '/Disapprove',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: bodyRow);
      final parsed = jsonDecode(response.body);
    } catch (error) {}
  }

  //return
  Future returnFunction(
      rcode, ucode, bcode, lcode, rdate, roleList, cmt) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");
    var bodyRow =
        "{\n    \"rcode\": \"$rcode\",\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"200101\",\n    \"lcode\": \"400011\",\n    \"rdate\": \"\",\n    \"roleList\": \"[100003,100004,100002,100001]\",\n    \"cmt\": \"okay\"\n\n}";
    try {
      final response = await api().post(
          baseURLInternal + 'loanRequests/post/' + rcode + '/Return',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: bodyRow);
      final parsed = jsonDecode(response.body);
    } catch (error) {}
  }
}
