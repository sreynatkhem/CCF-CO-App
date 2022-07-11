import 'dart:convert';

import 'package:chokchey_finance/components/searchCO.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoanArrearProvider with ChangeNotifier {
  dynamic listSearchCo = [];
  Future searchByFilter({
    searchusername,
  }) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse(baseURLInternal + 'Users/search'));
      request.body = json.encode({
        "pageSize": 20,
        "pageNumber": 1,
        "searchusername": "$searchusername"
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      logger().e(response.statusCode);
      if (response.statusCode == 200) {
        var parsed = jsonDecode(await response.stream.bytesToString());
        notifyListeners();
        return UserModel.fromJsonList(parsed);
      } else {
        print(response.reasonPhrase);
      }
    } catch (Error) {
      logger().e(Error);
    }
  }

  Future fetchLoanArrearProvider(
      {baseDate,
      mgmtBranchCode,
      currencyCode,
      loanAccountNo,
      referenceEmployeeNo}) async {
    try {
      var headers = {'Content-Type': 'application/json; charset=utf-8'};
      var request = http.Request('POST', Uri.parse(baseUrl + 'LEN0001'));
      request.body =
          '''{\n    "header": {\n        "userID" :"SYSTEM",\n\t\t"channelTypeCode" :"08",\n\t\t"previousTransactionID" :"",\n\t\t"previousTransactionDate" :""\n    },\n    "body": {\n        "baseDate": "$baseDate",\n        "mgmtBranchCode": "$mgmtBranchCode",\n        "currencyCode": "$currencyCode",\n        "loanAccountNo": "$loanAccountNo",\n        "referenceEmployeeNo":"$referenceEmployeeNo"\n    }\n}\n''';
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final parsed = jsonDecode(await response.stream.bytesToString());
        final list = parsed['body']['arrearList'];
        notifyListeners();
        return list;
      } else {
        logger().e("error");
      }
    } catch (error) {
      logger().e("error: $error");
    }
  }
}
