// import 'dart:async';
// import 'dart:convert';
// import 'package:chokchey_finance/models/index.dart';
// import 'package:chokchey_finance/models/listApproval.dart';
// import 'package:chokchey_finance/providers/manageService.dart';
// import 'package:chokchey_finance/utils/storages/const.dart';

// // Future<List<ListApproval>> fetchListDetail(loanApprovalApplicationNo) async {
// Future fetchListDetail(loanApprovalApplicationNo) async {
//   final bodyRowbodyRowDetail =
//       "{\n    \"header\": {\n        \"userID\" :\"SYSTEM\",\n\t\t\"channelTypeCode\" :\"08\",\n\t\t\"previousTransactionID\" :\"\",\n\t\t\"previousTransactionDate\" :\"\"\n    },\n    \"body\": {\n    \"loanApprovalApplicationNo\": \"$loanApprovalApplicationNo\"\n    }\n}\n";
//   try {
//     final response =
//         await api().post(baseUrl + 'LRA0003', body: bodyRowbodyRowDetail);
//     final parsed = jsonDecode(response.body);
//     final list = parsed['body']['loanApplicationDetailInfo'];
//     dynamic data = [];
//     data.add(list);
//     return data
//         .map<ListApproval>((json) => ListApproval.fromJson(json))
//         .toList();
//   } catch (error) {}
// }
