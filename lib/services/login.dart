import 'dart:async';
import 'dart:convert';

import 'package:chokchey_finance/services/manageService.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../modals/index.dart';

Future<List<LoginModals>> fetchLogins(http.Client client) async {
  try {
    final response = await client.get(fireBaseUrl);
    // Use the compute function to run parseLogins in a separate isolate.
    return compute(parseLogins, response.body);
  } catch (error) {}
}

// A function that converts a response body into a List<Login>.
List<LoginModals> parseLogins(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<LoginModals>((json) => LoginModals.fromJson(json)).toList();
}
