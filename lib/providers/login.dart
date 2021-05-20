import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

import 'manageService.dart';

class LoginProvider with ChangeNotifier {
  bool _isFetching = false;
  final storage = new FlutterSecureStorage();

  Future fetchLogin(id, password) async {
    _isFetching = true;
    final Map<String, dynamic> bodyRow = {
      "uid": "$id",
      "upassword": "$password"
    };
    try {
      _isFetching = false;
      final Response response = await api().post(
        Uri.parse(baseURLInternal + 'token'),
        headers: {
          "content-type": "application/json",
        },
        body: json.encode(bodyRow),
      );
      final parsed = jsonDecode(response.body);
      notifyListeners();
      // return parsed
      //     .map<LoginModels>((json) => LoginModels.fromJson(json))
      //     .toList();
      return parsed;
    } catch (error) {
      logger().e("error: $error");
      _isFetching = false;
    }
  }

  // Future<List<LoginModels>> postLoginChangePassword(upassword) async {
  Future postLoginChangePassword(upassword) async {
    _isFetching = true;
    var user_ucode = await storage.read(key: 'user_ucode');
    var token = await storage.read(key: 'user_token');
    try {
      if (token != null) {
        _isFetching = false;
        final bodyRow = "{\n    \"upassword\": \"$upassword\"\n}\n";
        final Response response = await api().post(
          Uri.parse(baseURLInternal + 'Users/ChangePassword/' + user_ucode),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: bodyRow,
        );
        final parsed = jsonDecode(response.body);
        // return parsed
        //     .map<LoginModels>((json) => LoginModels.fromJson(json))
        //     .toList();
        return parsed;
      } else {
        print('error:');
      }
    } catch (error) {
      _isFetching = false;
    }
  }

  bool get isFetching => _isFetching;
}
