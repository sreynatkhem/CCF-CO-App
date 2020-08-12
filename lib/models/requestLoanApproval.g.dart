// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requestLoanApproval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestLoanApproval _$RequestLoanApprovalFromJson(Map<String, dynamic> json) {
  return RequestLoanApproval()
    ..totalLoanRequest = json['totalLoanRequest'] as num
    ..totalPage = json['totalPage'] as num
    ..totalApproved = json['totalApproved'] as num
    ..totalReturn = json['totalReturn'] as num
    ..totalDisapprove = json['totalDisapprove'] as num
    ..listLoanRequests = json['listLoanRequests'] == null
        ? null
        : ListLoanRequests.fromJson(
            json['listLoanRequests'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RequestLoanApprovalToJson(
        RequestLoanApproval instance) =>
    <String, dynamic>{
      'totalLoanRequest': instance.totalLoanRequest,
      'totalPage': instance.totalPage,
      'totalApproved': instance.totalApproved,
      'totalReturn': instance.totalReturn,
      'totalDisapprove': instance.totalDisapprove,
      'listLoanRequests': instance.listLoanRequests
    };
