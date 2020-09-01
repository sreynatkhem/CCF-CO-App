import 'dart:convert';

import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApprovalHistoryProvider {
  final storage = new FlutterSecureStorage();

//Request list loan
  Future getApprovalHistorySummary(
      _pageSize, _pageNumber, status, code, sdate, edate) async {
    try {
      var token = await storage.read(key: 'user_token');
      var user_ucode = await storage.read(key: "user_ucode");
      var branch = await storage.read(key: "branch");
      var status;
      var code;
      var bodyRow =
          "{\n    \"pageSize\": $_pageSize,\n    \"pageNumber\": $_pageNumber,\n    \"ucode\": \"$user_ucode\",\n    \"bcode\": \"$branch\",\n    \"status\": \"$status\",\n     \"code\": \"$code\",\n     \"sdate\": \"$sdate\",\n    \"edate\": \"$edate\"\n}";
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await api().post(baseURLInternal + 'reports/summary',
          headers: headers, body: bodyRow);
      if (response.statusCode == 200) {
        var list = jsonDecode(response.body);
        logger().e('list: ${list}');
        return list;
      } else {
        logger().e('response.statusCode != 200 :: ${response.statusCode}');
      }
    } catch (error) {
      logger().e('error :: ${error}');
    }
  }
}
