import 'dart:async';
import 'dart:convert';

import 'package:chokchey_finance/services/manageService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../modals/index.dart';

Future<List<DetailApproval>> fetchDetail(
    http.Client client, loanApprovalApplicationNo) async {
  final bodyRowbodyRowDetail =
      "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"loanApprovalApplicationNo\": \"$loanApprovalApplicationNo\"\n    }\n}\n";
  try {
    final response =
        await client.post(baseUrl + 'LRA0003', body: bodyRowbodyRowDetail);
    final parsed = jsonDecode(response.body);
    final list = parsed['body']['approvalList'];
    return list
        .map<DetailApproval>((json) => DetailApproval.fromJson(json))
        .toList();
    // return compute(parseApprovals, response.body);
  } catch (error) {}
}

// A function that converts a response body into a List<Approval>.
// List<DetailApproval> parseApprovals(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
// }
