import 'dart:async';
import 'dart:convert';

import 'package:chokchey_finance/utils/storages/const.dart';
import 'package:http/http.dart';
import '../manageService.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future returnFunction(rcode, ucode, bcode, lcode, rdate, roleList, cmt) async {
  final storage = new FlutterSecureStorage();
  String user_id = await storage.read(key: 'user_id');
  String user_name = await storage.read(key: 'user_name');
  // var bodyRow =
  //     "{\n    \"rcode\": \"$rcode\",\n    \"ucode\": \"$ucode\",\n    \"bcode\": \"200101\",\n    \"lcode\": \"400011\",\n    \"rdate\": \"\",\n    \"roleList\": \"[100003,100004,100002,100001]\",\n    \"cmt\": \"okay\"\n\n}";
  final Map<String, dynamic> bodyRow = {
    "rcode": "$rcode",
    "ucode": "$ucode",
    "bcode": "$bcode",
    "lcode": "$lcode",
    "rdate": "$rdate",
    "roleList": roleList,
    "cmt": "$cmt"
  };
  var token = await storage.read(key: 'user_token');
  try {
    final Response response = await api().post(
        Uri.parse(baseURLInternal + 'loanRequests/post/' + rcode + '/Approve'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token
        },
        body: json.encode(bodyRow));
    final parsed = jsonDecode(response.body);
  } catch (error) {}
}
