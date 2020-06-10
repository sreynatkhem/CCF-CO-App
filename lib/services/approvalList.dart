import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../modals/index.dart';

class ApprovalListApi {
  Future<Album> fetchQuote() async {
    var url = 'http://jsonplaceholder.typicode.com/photos?_start=0&_limit=5';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print('Number of books about http: $jsonResponse.');
      // return Album.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    // return Album.fromJson([]);
  }
}
