import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class NotificationProvider with ChangeNotifier {
  final storage = new FlutterSecureStorage();
  var successfully = false;

  Future pushNotificationLoanArrear(
      {ucode, accountcustomer, overduedate, namecustomer, phone}) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse(baseURLInternal + 'LoanArrear/pushnotificationloanarrear'));
      request.body = json.encode({
        "ucode": "$ucode",
        "accountcustomer": "$accountcustomer",
        "overduedate": "$overduedate",
        "namecustomer": "$namecustomer",
        "phone": "$phone"
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var parsed = jsonDecode(await response.stream.bytesToString());
        logger().e("asdfasdfasdf: ${parsed}");
        notifyListeners();
        return parsed;
      } else {
        print(response.reasonPhrase);
      }
    } catch (onError) {
      logger().e(onError);
    }
  }

  Future getListLoanArrear(
      {baseDate,
      mgmtBranchCode,
      currencyCode,
      loanAccountNo,
      referenEmployeeNo}) async {
    try {
      var headers = {'Content-Type': 'application/json; charset=utf-8'};
      var request = http.Request('POST', Uri.parse(baseUrl + 'LEN0001'));
      request.body =
          '''{\n    "header": {\n        "userID" :"SYSTEM",\n\t\t"channelTypeCode" :"08",\n\t\t"previousTransactionID" :"",\n\t\t"previousTransactionDate" :""\n    },\n    "body": {\n        "baseDate": "$baseDate",\n        "mgmtBranchCode": "$mgmtBranchCode",\n        "currencyCode": "$currencyCode",\n        "loanAccountNo": "$loanAccountNo",\n        "referenEmployeeNo":"$referenEmployeeNo"\n    }\n}\n''';
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var parsed = jsonDecode(await response.stream.bytesToString());
        var list = parsed['body']['arrearList'];
        notifyListeners();
        return list;
      } else {
        print(response.reasonPhrase);
      }
    } catch (Error) {
      logger().e(Error);
    }
  }

  Future postNotificationRead(number) async {
    var token = await storage.read(key: 'user_token');
    try {
      final Response response = await api().post(
        Uri.parse(baseURLInternal + 'messages/read/' + number),
        headers: {
          "contentType": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final list = jsonDecode(response.body);
      if (response.statusCode == 200) {
        successfully = true;
      } else {
        successfully = false;
      }
      notifyListeners();
      return list;
    } catch (error) {
      logger().i('error: ${error}');
    }
  }

  Future fetchNotificationAnnouncement(number) async {
    var token = await storage.read(key: 'user_token');
    try {
      final Response response = await api().get(
        Uri.parse(baseURLInternal + 'announcements/' + number),
        headers: {
          "contentType": "application/json",
          "Authorization": "Bearer " + token
        },
      );
      final list = jsonDecode(response.body);
      if (response.statusCode == 200) {
        successfully = true;
      } else {
        successfully = false;
      }
      notifyListeners();
      return list;
    } catch (error) {
      logger().i('error: ${error}');
    }
  }

  Future getNotification(
    _pageSize,
    _pageNumber,
  ) async {
    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    final Map<String, dynamic> bodyRow = {
      "pageSize": "$_pageSize",
      "pageNumber": "$_pageNumber",
      "ucode": "$user_ucode"
    };
    try {
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'messages/byuser'),
          headers: headers,
          body: json.encode(bodyRow));
      var parsed = jsonDecode(response.body);
      notifyListeners();
      return parsed;
    } catch (error) {
      logger().i('error: ${error}');
    }
  }

  Future getNotificationProvider(
    _pageSizeParam,
    _pageNumberParam,
  ) async {
    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    final Map<String, dynamic> bodyRow = {
      "pageSize": "$_pageSizeParam",
      "pageNumber": "$_pageSizeParam",
      "ucode": "$user_ucode"
    };

    try {
      final Response response = await api().post(
          Uri.parse(baseURLInternal + 'messages/byuser'),
          headers: headers,
          body: json.encode(bodyRow));
      var parsed = jsonDecode(response.body);
      notifyListeners();
      return parsed;
    } catch (error) {
      logger().i('error: ${error}');
    }
  }

  Future fetchMessageFromCEO() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'user_token');
    try {
      final Response response = await api().get(
          Uri.parse(baseURLInternal + 'Announcements/CEOMessage'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          });
      final parsed = jsonDecode(response.body);
      return parsed;
    } catch (error) {
      logger().e(error);
    }
  }

  bool get isFetchingSuccessfullyNotification => successfully;
}
