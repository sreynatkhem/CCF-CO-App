import 'package:chokchey_finance/models/approvalList.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApprovelistProvider with ChangeNotifier {
  bool _isFetching = false;
  final data = [];

  Future<List<Approval>> fetchApprovals() async {
    _isFetching = true;
    final storage = new FlutterSecureStorage();
    String user_id = await storage.read(key: 'user_id');
    final bodyRow =
        "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n		\"channelTypeCode\" :\"08\",\n		\"previousTransactionID\" :\"\",\n		\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"${user_id}\"\n    }\n}\n";
    try {
      final response = await api().post(
        baseUrl + 'LRA0002',
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: bodyRow,
      );
      final parsed = jsonDecode(response.body);
      final list = parsed['body']['approvalList'];
      logger().e('List: $list');
      data.add(list);
      _isFetching = false;
      notifyListeners();
      return list.map<Approval>((json) => Approval.fromJson(json)).toList();
    } catch (error) {
      print('error: $error');
    }
  }

  // fetch api apsara history from core backing approve or return or reject loan.
  Future fetchHistoryAPSARA(
      branchCode, customerNo, userID, fromDate, toDate, status) async {
    _isFetching = true;

    final bodyRow =
        "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n		\"channelTypeCode\" :\"08\",\n		\"previousTransactionID\" :\"\",\n		\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"branchCode\": \"${branchCode}\",\n    \"customerNo\": \"${customerNo}\",\n    \"authorizerEmployeeNo\" :\"${userID}\",\n   \"inquiryFromDate\": \"${fromDate}\",\n   \"inquiryToDate\": \"${toDate}\",\n   \"loanApprovalApplicationStatusCode\": \"${status}\"\n    }\n}\n";
    try {
      final response = await api().post(
        baseUrl + 'LRA0005',
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: bodyRow,
      );
      final parsed = jsonDecode(response.body);
      final list = parsed['body'];
      notifyListeners();
      return list;
    } catch (error) {
      print('error: $error');
    }
  }

  bool get isFetching => _isFetching;
}
