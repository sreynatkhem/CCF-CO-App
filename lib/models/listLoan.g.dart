// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listLoan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListLoan _$ListLoanFromJson(Map<String, dynamic> json) {
  return ListLoan()
    ..totalLoan = json['totalLoan'] as num
    ..totalPage = json['totalPage'] as num
    ..totalApprove = json['totalApprove'] as num
    ..totalRequest = json['totalRequest'] as num
    ..totalReturn = json['totalReturn'] as num
    ..totalDisapprove = json['totalDisapprove'] as num
    ..listLoans = json['listLoans'] == null
        ? null
        : CreateLoan.fromJson(json['listLoans'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ListLoanToJson(ListLoan instance) => <String, dynamic>{
      'totalLoan': instance.totalLoan,
      'totalPage': instance.totalPage,
      'totalApprove': instance.totalApprove,
      'totalRequest': instance.totalRequest,
      'totalReturn': instance.totalReturn,
      'totalDisapprove': instance.totalDisapprove,
      'listLoans': instance.listLoans
    };
