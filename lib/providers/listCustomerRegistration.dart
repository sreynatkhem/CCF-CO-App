import 'package:chokchey_finance/models/customers.dart';
import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class ListCustomerRegistrationProvider with ChangeNotifier {
  bool _isFetching = false;
  final data = [];

  Future<List<Customers>> fetchListCustomerRegistration() async {
    _isFetching = true;
    try {
      _isFetching = false;
      final response = await api().get(
        'https://jsonplaceholder.typicode.com/users',
      );
      final parsed = jsonDecode(response.body);
      data.add(parsed);
      notifyListeners();
      return parsed.map<Customers>((json) => Customers.fromJson(json)).toList();
    } catch (error) {
      print('error: $error');
      _isFetching = false;
    }
  }

  bool get isFetching => _isFetching;
}
