import 'package:chokchey_finance/models/login.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginProvider with ChangeNotifier {
  bool _isFetching = false;
  final data = [];

  Future<List<LoginModels>> fetchLogin(id, password) async {
    _isFetching = true;
    final bodyRow =
        "{\n    \"uid\": \"$id\",\n    \"upassword\": \"$password\"\n}";
    try {
      _isFetching = false;
      final response = await api().post(
        'http://119.82.252.42:2020/api/token',
        headers: {
          "Content-Type": "application/json",
        },
        body: bodyRow,
      );
      final parsed = jsonDecode(response.body);
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

  bool get isFetching => _isFetching;
}
