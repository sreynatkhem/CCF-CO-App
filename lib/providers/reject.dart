import 'dart:async';

import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:http/http.dart' as http;
import '../modals/index.dart';
import 'manageService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<List<Approval>> rejectFunction(http.Client client,
    loanApprovalApplicationNo, evaluateStatusCode, comments) async {
  final storage = new FlutterSecureStorage();
  String user_id = await storage.read(key: 'user_id');
  String user_name = await storage.read(key: 'user_name');

  final bodyRow =
      "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"$user_id\",\n    \"authorizerEmpName\": \"$user_name\",\n    \"evaluateStatusCode\": \"90\",\n    \"loanApprovalApplicationNo\": \"$loanApprovalApplicationNo\",\n    \"authorizationOpinionContents\": \"$comments\"\n    }\n}";

  try {
    await post().post(baseUrl + 'LRA0004',
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: bodyRow);
  } catch (error) {
    client.close();
  }
}