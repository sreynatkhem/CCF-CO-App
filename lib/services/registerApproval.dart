import 'package:chokchey_finance/modals/index.dart';
import 'package:chokchey_finance/services/manageService.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../modals/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<List<Approval>> registerApproval(
  http.Client client,
  loanApprovalApplicationNo,
  evaluateStatusCode,
) async {
  final storage = new FlutterSecureStorage();
  String user_id = await storage.read(key: 'user_id');
  String user_name = await storage.read(key: 'user_name');

  final bodyRow =
      "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"$user_id\",\n    \"authorizerEmpName\": \"$user_name\",\n    \"evaluateStatusCode\": \"20\",\n    \"loanApprovalApplicationNo\": \"$loanApprovalApplicationNo\",\n    \"authorizationOpinionContents\": \"Please re-check on loan fund purpose \"\n    }\n}";
  print("bodyRow $bodyRow");
  try {
    final response = await client.post(baseUrl + 'LRA0004',
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: bodyRow);
    final parsed = jsonDecode(response.body);
    print("parsed: $parsed");
  } catch (error) {
    client.close();
    print("error: $error");
  }
}