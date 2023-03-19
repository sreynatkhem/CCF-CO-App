import 'package:chokchey_finance/providers/manageService.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future registerApproval(http.Client client, loanApprovalApplicationNo,
    evaluateStatusCode, comments) async {
  final storage = new FlutterSecureStorage();
  String? user_id = await storage.read(key: 'user_id');
  String? user_name = await storage.read(key: 'user_name');

  // final bodyRow =
  //     "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"$user_id\",\n    \"authorizerEmpName\": \"$user_name\",\n    \"evaluateStatusCode\": \"20\",\n    \"loanApprovalApplicationNo\": \"$loanApprovalApplicationNo\",\n    \"authorizationOpinionContents\": \"$comments\"\n    }\n}";
  // try {
  //   final response = await api().post(baseUrl + 'LRA0004',
  //       headers: {
  //         "Content-Type": "application/json; charset=utf-8",
  //       },
  //       body: bodyRow);
  //   final parsed = jsonDecode(response.body);
  // } catch (error) {
  //   client.close();
  // }

  try {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(baseUrl + 'LRA0004'));
    request.body =
        "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"$user_id\",\n    \"authorizerEmpName\": \"$user_name\",\n    \"evaluateStatusCode\": \"20\",\n    \"loanApprovalApplicationNo\": \"$loanApprovalApplicationNo\",\n    \"authorizationOpinionContents\": \"$comments\"\n    }\n}";
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
    } else {}
  } catch (error) {
    client.close();
  }
}
