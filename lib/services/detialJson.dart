import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../modals/index.dart';

final String test =
    '[{"auth":"Requested","branch":23,"employeeNo":"102240","employeeName":"SykeangSren","registerDate":18052020,"approvalDate":18052020},{"auth":"Requested","branch":23,"employeeNo":"102240","employeeName":"SykeangSren","registerDate":18052020,"approvalDate":18052020},]';

Future<List<DetailApproval>> fetchDetail(http.Client client) async {
  final response = await client
      .get('http://jsonplaceholder.typicode.com/photos?_start=0&_limit=5');

  // Use the compute function to run parseApprovals in a separate isolate.

  return compute(parseApprovals, response.body);
}

// A function that converts a response body into a List<Approval>.
List<DetailApproval> parseApprovals(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<DetailApproval>((json) => DetailApproval.fromJson(json))
      .toList();
}
