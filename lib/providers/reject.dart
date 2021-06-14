// import 'dart:async';

// import 'package:chokchey_finance/models/approvalList.dart';
// import 'package:chokchey_finance/utils/storages/const.dart';
// import 'package:http/http.dart' as http;
// import 'manageService.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// // Future<List<Approval>> rejectFunction(http.Client client,
// Future rejectFunction(http.Client client, loanApprovalApplicationNo,
//     evaluateStatusCode, comments) async {
//   final storage = new FlutterSecureStorage();
//   String user_id = await storage.read(key: 'user_id');
//   String user_name = await storage.read(key: 'user_name');

//   // final bodyRow =
//   //     "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"$user_id\",\n    \"authorizerEmpName\": \"$user_name\",\n    \"evaluateStatusCode\": \"90\",\n    \"loanApprovalApplicationNo\": \"$loanApprovalApplicationNo\",\n    \"authorizationOpinionContents\": \"$comments\"\n    }\n}";

//   // try {
//   //   await api().post(baseUrl + 'LRA0004',
//   //       headers: {
//   //         "Content-Type": "application/json; charset=utf-8",
//   //       },
//   //       body: bodyRow);
//   // } catch (error) {
//   //   client.close();
//   // }

//   try {
//     var headers = {'Content-Type': 'application/json'};
//     var request = http.Request('POST', Uri.parse(baseUrl + 'LRA0004'));
//     request.body =
//         "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"authorizerEmployeeNo\": \"$user_id\",\n    \"authorizerEmpName\": \"$user_name\",\n    \"evaluateStatusCode\": \"90\",\n    \"loanApprovalApplicationNo\": \"$loanApprovalApplicationNo\",\n    \"authorizationOpinionContents\": \"$comments\"\n    }\n}";
//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//     } else {}
//   } catch (error) {
//     client.close();
//   }
// }
