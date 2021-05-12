import 'package:chokchey_finance/models/createLoan.dart';
import 'package:chokchey_finance/models/index.dart';
import 'package:chokchey_finance/models/listLoan.dart';
import 'package:chokchey_finance/models/valueListCustomers.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class NotificationProvider with ChangeNotifier {
  final storage = new FlutterSecureStorage();
  var successfully = false;

  Future postNotificationRead(number) async {
    var token = await storage.read(key: 'user_token');
    try {
      final response = await api().post(
        baseURLInternal + 'messages/read/' + number,
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
      final response = await api().get(
        baseURLInternal + 'announcements/' + number,
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
    _pageSize,
    _pageNumber,
  ) async {
    var token = await storage.read(key: 'user_token');
    var user_ucode = await storage.read(key: "user_ucode");

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    var bodyRow =
        "{\n    \"pageSize\": 20,\n    \"pageNumber\": 1,\n    \"ucode\": \"$user_ucode\",\n}";
    try {
      final response = await api().post(baseURLInternal + 'messages/byuser',
          headers: headers, body: json.encode(bodyRow));
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
