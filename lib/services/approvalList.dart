import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../modals/index.dart';

Future<List<Approval>> fetchApprovals(http.Client client) async {
  final response = await client
      .get('http://jsonplaceholder.typicode.com/photos?_start=0&_limit=5');
  // Use the compute function to run parseApprovals in a separate isolate.
  return compute(parseApprovals, response.body);
}

// A function that converts a response body into a List<Approval>.
List<Approval> parseApprovals(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Approval>((json) => Approval.fromJson(json)).toList();
}
