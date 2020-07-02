import 'dart:async';
import 'dart:convert';
import 'package:chokchey_finance/modals/listApproval.dart';
import 'package:chokchey_finance/services/manageService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<List<ListApproval>> fetchListDetail(
    http.Client client, loanApprovalApplicationNo) async {
  final bodyRowbodyRowDetail =
      "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"loanApprovalApplicationNo\": \"$loanApprovalApplicationNo\"\n    }\n}\n";
  try {
    final response =
        await client.post(baseUrl + 'LRA0003', body: bodyRowbodyRowDetail);
    final parsed = jsonDecode(response.body);
    final list = parsed['body']['loanApplicationDetailInfo'];
    var data = [];
    data.add(list);
    return data
        .map<ListApproval>((json) => ListApproval.fromJson(json))
        .toList();
  } catch (error) {}
}
