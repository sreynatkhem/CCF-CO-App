import 'package:json_annotation/json_annotation.dart';
import "listLoanRequests.dart";
part 'requestLoanApproval.g.dart';

@JsonSerializable()
class RequestLoanApproval {
    RequestLoanApproval();

    num totalLoanRequest;
    num totalPage;
    num totalApproved;
    num totalReturn;
    num totalDisapprove;
    ListLoanRequests listLoanRequests;
    
    factory RequestLoanApproval.fromJson(Map<String,dynamic> json) => _$RequestLoanApprovalFromJson(json);
    Map<String, dynamic> toJson() => _$RequestLoanApprovalToJson(this);
}
