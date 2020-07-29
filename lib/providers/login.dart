import 'package:chokchey_finance/models/login.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:convert';

import 'manageService.dart';

class LoginProvider with ChangeNotifier {
  bool _isFetching = false;
  final data = [];
  final storage = new FlutterSecureStorage();

  Future<List<LoginModels>> fetchLogin(id, password) async {
    _isFetching = true;
    final bodyRow =
        "{\n    \"uid\": \"$id\",\n    \"upassword\": \"$password\"\n}";
    try {
      _isFetching = false;
      final response = await api().post(
        baseURLInternal + 'token',
        headers: {
          "Content-Type": "application/json",
        },
        body: bodyRow,
      );
      final parsed = jsonDecode(response.body);
      print('error parsed: ${response.statusCode}');

      data.add(parsed);
      notifyListeners();
      return parsed
          .map<LoginModels>((json) => LoginModels.fromJson(json))
          .toList();
    } catch (error) {
      print('error: $error');
      _isFetching = false;
    }
  }

  Future<List<LoginModels>> postLoginChangePassword(upassword) async {
    _isFetching = true;

    var user_ucode = await storage.read(key: 'user_ucode');
    var token = await storage.read(key: 'user_token');
    print('upassword: $upassword');
    try {
      if (token != null) {
        _isFetching = false;
        final bodyRow = "{\n    \"upassword\": \"$upassword\"\n}\n";
        final response = await api().post(
          baseURLInternal + 'Users/ChangePassword/' + user_ucode,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: bodyRow,
        );
        print('response::: ${jsonDecode(response.body)}');
        print('URL: ${baseURLInternal + 'Users/ChangePassword/' + user_ucode}');
        final parsed = jsonDecode(response.body);
        return parsed
            .map<LoginModels>((json) => LoginModels.fromJson(json))
            .toList();
      } else {
        print('errorgg:');
      }
    } catch (error) {
      _isFetching = false;
      print('postLoginChangePassword: ${error}');
    }
  }

  bool get isFetching => _isFetching;
}
