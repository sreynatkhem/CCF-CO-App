import 'dart:convert';

import 'package:chokchey_finance/providers/manageService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LmapProvider with ChangeNotifier {
  var parsed = [];

  Future clearLmap() async {
    parsed = [];
    notifyListeners();
  }

  Future getLmap({
    pageSize,
    province,
    district,
    commune,
    village,
  }) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse(baseURLInternal + 'LMap/lmap'));

      request.body = json.encode({
        "pageSize": "$pageSize",
        "pageNumber": "1",
        "province": "$province",
        "district": "$district",
        "commune": "$commune",
        "village": "$village",
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        parsed = jsonDecode(await response.stream.bytesToString());
        notifyListeners();
      } else {
        parsed = [];
        notifyListeners();
      }
    } catch (error) {
      parsed = [];
      notifyListeners();
    }
  }
}
