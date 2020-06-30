import 'package:chokchey_finance/modals/index.dart';
import 'package:chokchey_finance/services/manageService.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../modals/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApprovelistProvider with ChangeNotifier {
  Future<List<Approval>> fetchApprovals(http.Client client) async {
    final storage = new FlutterSecureStorage();
    String user_id = await storage.read(key: 'user_id');

    final bodyRow =
        "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n		\"channelTypeCode\" :\"08\",\n		\"previousTransactionID\" :\"\",\n		\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"${user_id}\"\n    }\n}\n";
    try {
      final response = await client.post(baseUrl + 'LRA0002',
          headers: {
            "Content-Type": "application/json; charset=utf-8",
          },
          body: bodyRow);
      final parsed = jsonDecode(response.body);
      final list = parsed['body']['approvalList'];
      notifyListeners();
      return list.map<Approval>((json) => Approval.fromJson(json)).toList();
    } catch (error) {
      client.close();
    }
  }
}
