import 'dart:async';
import 'dart:convert';
import 'package:chokchey_finance/models/detialApproval.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:http/http.dart' as http;

// Future<List<DetailApproval>> fetchDetail(
Future fetchDetail(http.Client client, loanApprovalApplicationNo) async {
  final bodyRowbodyRowDetail =
      "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"loanApprovalApplicationNo\": \"$loanApprovalApplicationNo\"\n    }\n}\n";
  try {
    final response =
        await api().post(baseUrl + 'LRA0003', body: bodyRowbodyRowDetail);
    final parsed = jsonDecode(response.body);
    final list = parsed['body']['approvalList'];
    return list
        .map<DetailApproval>((json) => DetailApproval.fromJson(json))
        .toList();
  } catch (error) {}
}
