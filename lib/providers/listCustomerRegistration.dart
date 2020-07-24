import 'package:chokchey_finance/modals/index.dart';
import 'package:chokchey_finance/providers/manageService.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import '../modals/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ListCustomerRegistrationProvider with ChangeNotifier {
  bool _isFetching = false;
  final data = [];

  Future<List<Approval>> fetchApprovals() async {
    _isFetching = true;
    final storage = new FlutterSecureStorage();
    String user_id = await storage.read(key: 'user_id');

    try {
      final response = await post().post(
        'https://gorest.co.in/public-api/users?_format=json&access-token=RSP6eOpMjAV3dTLKyRQ3EaOMQYYNvUr8xuuQ',
      );
      final parsed = jsonDecode(response.body);
      final list = parsed['body']['approvalList'];
      data.add(list);
      _isFetching = false;
      notifyListeners();
      return list.map<Approval>((json) => Approval.fromJson(json)).toList();
    } catch (error) {
      print('error: $error');
    }
  }

  bool get isFetching => _isFetching;
}
