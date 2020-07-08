import 'package:chokchey_finance/modals/index.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import '../modals/index.dart';
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
      final response = await post().post(
        baseUrl + 'LRA0002',
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: bodyRow,
      );
      final parsed = jsonDecode(response.body);
      final list = parsed['body']['approvalList'];
      data.add(list);
      _isFetching = false;
      notifyListeners();
      return list.map<Approval>((json) => Approval.fromJson(json)).toList();
    } catch (error) {
      print('error: $error');
    }
  }

  bool get isFetching => _isFetching;
}
